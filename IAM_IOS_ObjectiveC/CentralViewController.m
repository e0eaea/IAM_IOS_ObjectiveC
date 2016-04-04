//
//  CentralViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "CentralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "UUID_Define.h"

@interface CentralViewController ()  <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) IBOutlet UITextView   *uuid_setting;
@property (strong, nonatomic) IBOutlet UIButton     *filter_button;
@property (strong, nonatomic) IBOutlet UILabel   *name;
@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *data;

@end

@implementation CentralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // And somewhere to store the incoming data
    _data = [[NSMutableData alloc] init];
    
   // [self startTimedTask];
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    [super viewWillDisappear:animated];
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
   
      [self.centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }];
      
 
}

- (void)startTimedTask
{
    NSTimer *fiveSecondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(performBackgroundTask) userInfo:nil repeats:YES];
}

- (void)performBackgroundTask
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self scan];
       
    });
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    

    NSLog(@"here!1");
    // Reject any where the value is above reasonable range
    if (RSSI.integerValue > -5) {
        return;
    }
    
    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    if (RSSI.integerValue < -300) {
        return;
    }
    
    NSLog(@"Discovered %@ at %@,%@", peripheral.name,advertisementData, RSSI);
    
    NSString *s=[advertisementData objectForKey:@"kCBAdvDataLocalName"];
    
    NSLog(@"원하는 값만 뽑아보자! %@", s);
    

    
   self.name.text=s;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // UITouch *touch = [[event allTouches] anyObject];
    
    [_uuid_setting resignFirstResponder];
    
}


- (IBAction)filterChange:(id)sender
{
    [self.centralManager stopScan];
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:_uuid_setting.text]]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
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
