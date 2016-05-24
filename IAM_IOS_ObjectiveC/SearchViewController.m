//
//  SearchViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 9..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "UUID_Define.h"

#import "SearchViewController.h"
#import "Detail_Card_ViewController.h"
#import "SearchCell.h"
#import "NSData+Base64.h"
#import "SearchDelegate.h"
#import "AppDelegate.h"
#import "KeywordViewController.h"


@interface SearchViewController ()  <CBCentralManagerDelegate, CBPeripheralDelegate,CBPeripheralManagerDelegate,SearchDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *favorite_button;
@property (strong, nonatomic) IBOutlet UIButton *random_button;

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;

@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;


@property (strong, nonatomic) MyInfo* myInfo;
@property (nonatomic,strong)  NSMutableArray* select_keyword;

@property (nonatomic)  NSMutableArray * tableData;
@property (nonatomic)  NSMutableArray * black_list;

@property (nonatomic) NSTimer* timer;
@property (nonatomic) int num;
@property (nonatomic) bool is_random;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.search_delegate=(id)self;
   UINavigationBar * navibar =self.navigationController.navigationBar;
   navibar.barTintColor=[UIColor colorWithRGBA:0x01afffff];
    
    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:(id)self queue:nil];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                            selector:@selector(background_cleaner:) userInfo:nil repeats:YES];
    
    
    
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    
 
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    _tableData=[NSMutableArray new];
    _black_list=[NSMutableArray new];
    
    // random_search
    [_favorite_button setBackgroundImage:[UIImage imageNamed:@"favorite_white.png" ] forState:UIControlStateNormal];
    [_random_button setBackgroundImage:[UIImage imageNamed:@"random_selected.png" ] forState:UIControlStateNormal];
    _is_random=true;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *info= [fetchedObjects objectAtIndex:0];
    
    _myInfo=(MyInfo*)info;
    
    [self set_search_keyword];
    [self scan];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    [self.centralManager stopScan];
    [_tableData removeAllObjects];
    [_black_list removeAllObjects];
   // [self.peripheralManager stopAdvertising];
     NSLog(@"Scanning stopped");
     _timer=nil;
    
    [super viewWillDisappear:animated];
}


- (IBAction)favorite_random_button:(id)sender {
    
    int tag = (int)[sender tag];
    
    if(tag==0)
    {
        if(![_myInfo.keyword isEqualToString:@"null"])
        {
            [_favorite_button setBackgroundImage:[UIImage imageNamed:@"favorite_selected.png" ] forState:UIControlStateNormal];
            [_random_button setBackgroundImage:[UIImage imageNamed:@"random_white.png" ] forState:UIControlStateNormal];
              _is_random=false;
        }
        else
        { [self show_alert:@"오류" message:@"키워드를 선택하세요!" yes:@"" no:@""]; return;}
        
    }
    
    else{
        [_favorite_button setBackgroundImage:[UIImage imageNamed:@"favorite_white.png" ] forState:UIControlStateNormal];
        [_random_button setBackgroundImage:[UIImage imageNamed:@"random_selected.png" ] forState:UIControlStateNormal];
        _is_random=true;
    }
    
    [self.tableData removeAllObjects];
    [self.black_list removeAllObjects];
    [self.tableView reloadData];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        return;
    }
    
    // The state must be CBCentralManagerStatePoweredOn...
    // ... so start scanning
    
    
       [self scan];
    
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"self.peripheralManager powered on.");
    
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]], CBAdvertisementDataLocalNameKey:_myInfo.id}];
    
    // Start sending
    
}

- (void)scan
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"CBCentralManager must be powered to scan peripherals. %ld", (long)self.centralManager.state);
        return;
    }
    
    NSLog(@"Scanning started");
    
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];

}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    bool flag=true;
    
    // Reject any where the value is above reasonable range
    if (RSSI.integerValue > -5) {
        return;
    }
    
    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    if (RSSI.integerValue < -300) {
        return;
    }
    
    
    NSString *bluetooth_id=[advertisementData objectForKey:@"kCBAdvDataLocalName"];
    
    if(bluetooth_id==nil) return;
    

    for(Client * client in _tableData)
        if([client.id isEqualToString:bluetooth_id])
        { flag=false; [self renew_usebit:bluetooth_id]; break;}
    
    for(Client * client in _black_list)
        if([client.id isEqualToString:bluetooth_id])
        { flag=false; break;}
    
    
    if(flag)
    {
        Client *new_client=[[Client alloc]initWithClientID:bluetooth_id];
        [_tableData addObject:new_client];
        
        if(_is_random)
         [Client request_random_info:bluetooth_id];
        else
         [Client request_interest_info:bluetooth_id keyword:_select_keyword];
        
    }
    
}


//서버로부터 정보를 받아옴!
- (void) response_brief_info:(NSDictionary *)info
{
    if(info==nil)
    {
        [_tableData removeAllObjects];
        [_black_list removeAllObjects];
        
    [self show_alert:@"오류" message:@"서버연결오류!" yes:@"" no:@""];
        
        return;
    }
    
    NSLog(@"전체 리스폰스  %@",info);
    NSString *client_id=[info objectForKey:@"id"];
    
    NSLog(@"가져온 정보의 id는 %@",client_id);
    
    NSArray *keyword_arr=[info objectForKey:@"keyword"];
    
    NSString *is_null=[NSString stringWithFormat:@"%@",[info objectForKey:@"card_state"]];
    NSLog(@"카드상태는 %@",is_null);
    
    
    
    
    for( Client* new_client in _tableData)
        if([client_id isEqualToString:new_client.id])
        {
            if([is_null isEqualToString:@"-1"])
            {
                [_black_list addObject:new_client];
                [_tableData removeObject:new_client];
            }
            
            else
            {
                new_client.myinfo=_myInfo;
                new_client.card.nickname=[info objectForKey:@"nickname"];
                new_client.card.main_image=[NSData dataFromBase64String:[info objectForKey:@"profile_picture"]];
                new_client.status=YES;
                new_client.card.card_number=[[info objectForKey:@"card_number"] intValue];
                
                
                NSString *keywords_string=[NSString stringWithFormat:@"%@",[keyword_arr objectAtIndex:0]];
                int current_num=(int)[keyword_arr count];
               // NSLog(@"현재 키워드 갯수 %d",current_num);
                
                for(int i=1; i<current_num; i++)
                {
                    NSString *s=[keyword_arr objectAtIndex:i];
                    keywords_string=[NSString stringWithFormat:@"%@ %@",keywords_string,s];
                }
                
                new_client.card.keyword=keywords_string;
                
                
            }
        }
    
    
    NSLog(@"here!!");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [_tableView reloadData];
        
        if([_tableData count]!=0)
        {   NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [_tableView scrollToRowAtIndexPath:topIndexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
        }
        
    });
    
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


//섹션의 row갯수 반환
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

// 셀 만들기
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    SearchCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil]
                        objectAtIndex:0];
    
    
    cell.client_info = (Client *)_tableData[indexPath.row];
    
    [cell adjust];
    
    return cell;
}

//섹션 헤더 높이
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UIColor *clearColor = [UIColor clearColor];
    view.tintColor = clearColor;
}

//테이블셀의 높이
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"셀클릭");
    
    Client *c=(Client *)_tableData[indexPath.row];
    
    
    Detail_Card_ViewController *detail=[[Detail_Card_ViewController alloc]init_with_client_info:c from_favorite:NO];
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}


- (IBAction)my_keyword_select:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KeywordViewController *vc = [sb instantiateViewControllerWithIdentifier:@"KeywordViewController"];
    
    [vc set_search_keyword:_myInfo];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


//백그라운드에서 하는 일
- (void)background_cleaner:(NSTimer *)theTimer {
    [self reduce_usebit];
    [self remove_client];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_tableView reloadData];
        
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        if([_tableData count]>0)
            [_tableView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
        
    });
    
}


//usebit 조정
- (void) renew_usebit:(NSString *)client_id
{
    for(Client * client in _tableData)
        if([client.id isEqualToString:client_id])
            client.usebit=2;
    
}

-(void) reduce_usebit
{
    for(Client * client in _tableData)
        client.usebit-=1;
}


-(void) remove_client
{
    bool flag=false;
    
    for(Client * client in _tableData)
        if(client.usebit<=0)
        {flag=true; break;}
    
    if(flag)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *tempArray = [_tableData mutableCopy];
            for(Client * client in _tableData)
                if(client.usebit<=0)
                    [tempArray removeObject:client];
            
            _tableData=tempArray;
            
            [_tableView reloadData];
            
        });
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) show_alert:(NSString*)title message:(NSString*)message yes:(NSString*)yes no:(NSString*)no
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    if([yes isEqualToString:@""])
        yes=@"확인";
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:yes
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    
                                    
                                }];
    
    [alert addAction:yesButton];
    
    
    
    if(![no isEqualToString:@""])
    {
        
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:no
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel no, thanks button
                                       
                                   }];
        
        
        [alert addAction:noButton];
    }
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

//select_keyword확인
- (void) set_search_keyword
{
    _select_keyword=[[NSMutableArray alloc]init];
    
    if(![_myInfo.keyword isEqualToString:@"null"])
    {
        NSArray *s=[_myInfo.keyword componentsSeparatedByString:@" "];
        
        for ( NSString * component in s )
            [_select_keyword addObject:component];
    }
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
