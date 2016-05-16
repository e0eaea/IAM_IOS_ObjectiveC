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


@interface SearchViewController ()  <CBCentralManagerDelegate, CBPeripheralDelegate,SearchDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *favorite_button;
@property (strong, nonatomic) IBOutlet UIButton *random_button;

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;

@property (nonatomic)  NSMutableArray * tableData;
@property (nonatomic) NSTimer* timer;
@property (nonatomic) int num;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableData=[NSMutableArray new];
    
    _num=0;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.search_delegate=(id)self;
    UINavigationBar * navibar =self.navigationController.navigationBar;
    navibar.barTintColor=[UIColor colorWithRGBA:0x01afffff];
    
    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:(id)self queue:nil];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self
                                            selector:@selector(background_cleaner:) userInfo:nil repeats:YES];
    
 
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self scan];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    [self.centralManager stopScan];
     NSLog(@"Scanning stopped");
     _timer=nil;
    
    [super viewWillDisappear:animated];
}


- (IBAction)favorite_random_button:(id)sender {
    
    int tag = (int)[sender tag];
    
    if(tag==0)
    {
        [_favorite_button setBackgroundImage:[UIImage imageNamed:@"favorite_selected.png" ] forState:UIControlStateNormal];
        [_random_button setBackgroundImage:[UIImage imageNamed:@"random_white.png" ] forState:UIControlStateNormal];
        
    }
    
    else{
        [_favorite_button setBackgroundImage:[UIImage imageNamed:@"favorite_white.png" ] forState:UIControlStateNormal];
        [_random_button setBackgroundImage:[UIImage imageNamed:@"random_selected.png" ] forState:UIControlStateNormal];
    }
    
    
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
    
   // NSLog(@"받아온 신호 %@",bluetooth_id);
    
    for(Client * client in _tableData)
        if([client.id isEqualToString:bluetooth_id])
        { flag=false; [self renew_usebit:bluetooth_id]; break;}
    
    
    if(flag)
    {
        Client *new_client=[[Client alloc]initWithClientID:bluetooth_id];
        [_tableData addObject:new_client];
        [Client request_brief_info:bluetooth_id];
        
    }
    
}


//서버로부터 정보를 받아옴!
- (void) response_brief_info:(NSDictionary *)info
{
    NSString *client_id=[info objectForKey:@"id"];
    
    NSLog(@"%@",info);
    NSLog(@"가져온 정보의 id는 %@",client_id);
    
    for( Client* new_client in _tableData)
        if([client_id isEqualToString:new_client.id])
        {
            new_client.name=[info objectForKey:@"nickname"];
            new_client.base64_image=[NSData dataFromBase64String:[info objectForKey:@"profile_picture"]];
            new_client.status=YES;
        }
    
    NSLog(@"here!!");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [_tableView reloadData];
        
        
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [_tableView scrollToRowAtIndexPath:topIndexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
        
        
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
    
    
    Detail_Card_ViewController *detail=[[Detail_Card_ViewController alloc]init_with_client_info:c];
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

- (IBAction)logout_click:(id)sender {
    
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            // logout success.
            [[[UIApplication sharedApplication] delegate] performSelector:@selector(logout)];
        } else {
            // failed
            NSLog(@"failed to logout.");
        }
    }];
    
    
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
