//
//  PeripheralViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "PeripheralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UUID_Define.h"

@interface PeripheralViewController () <CBPeripheralManagerDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView       *uuid_text;
@property (strong, nonatomic) IBOutlet UITextView       *name_text;
@property (strong, nonatomic) IBOutlet UISwitch         *advertisingSwitch;
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) NSData                    *dataToSend;
@property (nonatomic, readwrite) NSInteger              sendDataIndex;


@end



@implementation PeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Start up the CBPeripheralManager
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
   // UITouch *touch = [[event allTouches] anyObject];
    
    [_name_text resignFirstResponder];
    [_uuid_text resignFirstResponder];

}

- (IBAction)switchChanged:(id)sender
{
   
  
    if (self.advertisingSwitch.on) {
        // All we advertise is our service's UUID
        
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:_uuid_text.text]], CBAdvertisementDataLocalNameKey:_name_text.text }];
    }
    
    else {
        [self.peripheralManager stopAdvertising];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    
    [self.peripheralManager stopAdvertising];
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
