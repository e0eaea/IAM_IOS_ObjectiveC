//
//  SearchViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 9..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "UUID_Define.h"

#import "SearchViewController.h"
#import "SearchCell.h"
#import "NSData+Base64.h"
#import "SearchDelegate.h"
#import "AppDelegate.h"


@interface SearchViewController ()  <CBCentralManagerDelegate, CBPeripheralDelegate,SearchDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;

@property (nonatomic)  NSMutableArray *request_ids;
@property (nonatomic)  NSMutableArray * tableData;
@property (nonatomic) int num;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:(id)self queue:nil];

    
    _request_ids=[NSMutableArray new];
    _tableData=[NSMutableArray new];
 
    _num=0;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.search_delegate=(id)self;
    

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
    BOOL flag=true;
    
    // Reject any where the value is above reasonable range
    if (RSSI.integerValue > -5) {
        return;
    }
    
    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    if (RSSI.integerValue < -300) {
        return;
    }
    
    //NSLog(@"Discovered %@ at %@,%@", peripheral.name,advertisementData, RSSI);
    
    NSString *bluetooth_id=[advertisementData objectForKey:@"kCBAdvDataLocalName"];
    // NSString *uuid=[advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"][0];
    
    if(!bluetooth_id) bluetooth_id=@"이름없음";
    //if(!uuid) uuid=@"UUID없음";
    
   // NSLog(@"\n블루투스를 통해 받은 정보 %@", advertisementData);
    
    
    if(_num <5) { NSLog(@"값이 뭔데? %d",_num); _num++;   }
    else { flag=false;   }
    
    /*
    for(NSString* request_id in _request_ids)
        if([request_id isEqualToString:bluetooth_id])
          { flag=false; break;}

    */
    if(flag)
    {
        [_request_ids addObject:bluetooth_id];
        [Client request_brief_info:bluetooth_id];
    }
    
    
    /*
    [_tableData addObject:new_client];
    [_tableView reloadData];
    
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [_tableView scrollToRowAtIndexPath:topIndexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
    
    */
}


//서버로부터 정보를 받아옴!
- (void) response_brief_info:(NSDictionary *)info
{
    
    Client *new_client=[[Client alloc]init];
    new_client.name=[info objectForKey:@"nickname"];
    new_client.base64_image=[NSData dataFromBase64String:[info objectForKey:@"profile_picture"]];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{

        
        [_tableData addObject:new_client];
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
    // Return the number of rows in the section.
    
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









- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    [super viewWillDisappear:animated];
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
