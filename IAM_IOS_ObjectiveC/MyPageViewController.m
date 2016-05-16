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
#import "Card.h"
#import "CardTableViewCell.h"
#import "MyCardViewController.h"
#import "Common_modules.h"

@interface MyPageViewController ()<CBPeripheralManagerDelegate, UITextViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (nonatomic)  NSMutableArray * tableData;
@property (strong, nonatomic) MyInfo* myInfo;



@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.navigationController setNavigationBarHidden:NO];
    
    UINavigationBar * navibar =self.navigationController.navigationBar;
    navibar.barTintColor=[UIColor colorWithRGBA:0x01afffff];
    
    
    [self reload_list];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reload_list];
    
    [_tableview reloadData];
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if([_tableData count]>0)
        [_tableview scrollToRowAtIndexPath:topIndexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
}

- (void)reload_list
{
    _tableData=[NSMutableArray new];
    
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *info= [fetchedObjects objectAtIndex:0];
    
    
    
    _myInfo = (MyInfo *)info;
    
    for( Card * card in _myInfo.mycards)
        [_tableData addObject:card];
    
    
    /*
     
     CardTableViewCell *card=[[CardTableViewCell alloc]init];
     [_tableData addObject:card];
     
     CardTableViewCell *card1=[[CardTableViewCell alloc]init];
     [_tableData addObject:card1];
     
     CardTableViewCell *card2=[[CardTableViewCell alloc]init];
     [_tableData addObject:card2];
     
     */
    
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


//섹션의 row갯수 반환
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"현재 셀의 갯수 %lu",(unsigned long)_tableData.count);
    return _tableData.count;
}

// 셀 만들기
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CardTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CardTableViewCell" owner:self options:nil]
                               objectAtIndex:0];
    Card *card=[_tableData objectAtIndex:indexPath.row];
    
    cell.card_image.image=[UIImage imageWithData: card.main_image];

    
    return cell;
}

//섹션 헤더 높이
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UIColor *clearColor = [UIColor clearColor];
    view.tintColor = clearColor;
}

//테이블셀의 높이
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"셀클릭");
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyCardViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MyCardViewController"];
    [vc setting_exist_card:[_tableData objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"카드삭제"
                                      message:@"확인을 누르시면 카드가 사라집니다."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"확인"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [_myInfo removeMycardsObject:[_tableData objectAtIndex:indexPath.row]];
                                        [_tableData removeObjectAtIndex:indexPath.row];
                                        
                                        NSError *error;
                                        // here's where the actual save happens, and if it doesn't we print something out to the console
                                        if (![_managedObjectContext save:&error])
                                        {
                                            NSLog(@"Problem saving: %@", [error localizedDescription]);
                                        }
                                        
                                        NSLog(@"카드삭제");
                                        
                                        
                                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                        

                                        
                                    }];
        
        [alert addAction:yesButton];
        
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"취소"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       

                                       
                                   }];
        
        
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
    
}



- (IBAction)plus_button_tapped:(id)sender {
    
    // MyCardViewController * new_card=[[MyCardViewController alloc]init];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyCardViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MyCardViewController"];
    
    int total_card=(int)[_myInfo.mycards count];
    [vc new_card_create:_myInfo card_num:total_card];
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
