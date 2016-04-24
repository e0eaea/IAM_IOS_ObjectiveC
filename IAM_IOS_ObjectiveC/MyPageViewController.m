//
//  MyPageViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 12..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "MyPageViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UUID_Define.h"
#import "AppDelegate.h"
#import "MyInfo.h"

@interface MyPageViewController ()<CBPeripheralManagerDelegate, UITextViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
     NSManagedObject *info= [fetchedObjects objectAtIndex:0];
    
    MyInfo* my = (MyInfo *)info;
    _id_label.text=my.id;
    
    UINavigationBar * navibar =self.navigationController.navigationBar;
    navibar.barTintColor=[UIColor colorWithRGBA:0x01afffff];
     
    
    
}

- (void)didReceiveMemoryWarning {
    [self.peripheralManager stopAdvertising];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"self.peripheralManager powered on.");
    
    // Start sending
    
}

- (IBAction)switchChanged:(id)sender
{
    
    
    if (_advertisingSwitch.on) {
        // All we advertise is our service's UUID
        
        NSLog(@"보내는중!");
        
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]], CBAdvertisementDataLocalNameKey:_id_label.text}];
    }
    
    else {
        [self.peripheralManager stopAdvertising];
              NSLog(@"껐음!");
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
