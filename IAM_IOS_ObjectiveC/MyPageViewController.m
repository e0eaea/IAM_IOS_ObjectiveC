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
#import "Size_Define.h"

@interface MyPageViewController ()<CBPeripheralManagerDelegate, UITextViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (nonatomic)  NSMutableArray * tableData;
@property (strong, nonatomic) MyInfo* myInfo;
@property (strong,nonatomic) Card* tmp_card;
@property (strong,nonatomic) NSIndexPath * tmp_index;
@property (strong,nonatomic) NSMutableArray *on_off_array;
@property (nonatomic, retain) UIActivityIndicatorView *registrationProgressing;
@property (strong, nonatomic) UIView * blind_view;


@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.navigationController setNavigationBarHidden:NO];
    
    UINavigationBar * navibar =self.navigationController.navigationBar;
    navibar.barTintColor=[UIColor colorWithRGBA:0x01afffff];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(change_on_off_status:)
                                                 name:@"on_off_alert" object:nil];
    
    
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
    
    
    NSSortDescriptor *cardSort = [NSSortDescriptor sortDescriptorWithKey:@"card_number" ascending:NO];
    NSArray *sortedcard =    [_myInfo.mycards sortedArrayUsingDescriptors:@[cardSort]];
    
    
    [_tableData addObjectsFromArray:sortedcard];
        
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
    cell.this_card=card;
    
    if( ([card.on_off characterAtIndex:0]-48) ==1)
        [cell.card_open setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    
    
    else
    {  [cell.card_open setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
        cell.card_open.tag=0;
    }
    
    cell.svc=(id)self;

    
    cell.card_image.image=[UIImage imageWithData: card.main_image];
    cell.card_title.text=card.keyword;
    
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
                                        
                                        _tmp_card=[_tableData objectAtIndex:indexPath.row];
                                        _tmp_index=indexPath;
                                        
                                        [self remove_card:_tmp_card];
                                        
                                        
                                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                                 selector:@selector(respone_remove_card:)
                                                                                     name:@"delete_card" object:nil];
         
                                        
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




//서버에 카드삭제
- (void) remove_card:(Card*) card
{
    
    NSLog(@"json으로 삭제할꺼 만드는중");
    
    
    self.view.userInteractionEnabled=NO;
    _registrationProgressing = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [_registrationProgressing setFrame:CGRectMake((WINDOW_WIDTH / 2) - 50, (WINDOW_HEIGHT / 2) - 50, 100, 100)];
    _registrationProgressing.hidesWhenStopped = YES;
    [_registrationProgressing startAnimating];
    
    
    _blind_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    
    [_blind_view setBackgroundColor:[UIColor blackColor]];
    [_blind_view setAlpha:0.7];
    [self.view addSubview:_blind_view];
    
    [self.view addSubview:_registrationProgressing];
    
    
    
    NSArray *dictionKeys = @[@"id",@"card_number"];
    NSArray *dictionVals = @[card.myinfo.id,[NSString stringWithFormat:@"%d",card.card_number]];
    
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    NSString *userJsonData = [Common_modules transToJson:client_data];

    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(connectToServer:url:) withObject:userJsonData withObject:delete_card];
    
}


- (IBAction)plus_button_tapped:(id)sender {
    
    // MyCardViewController * new_card=[[MyCardViewController alloc]init];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyCardViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MyCardViewController"];
    
    
    NSArray * mArray=[_myInfo.mycards allObjects];
    
    int max=0;
    for(Card * c in mArray)
    {
        if(c.card_number > max)
            max=c.card_number;
    }
    
    int new_cardNum=(int)max+1;
    
    
    NSLog(@"새로생길 카드 번호는 %d",new_cardNum );
    [vc new_card_create:_myInfo card_num:new_cardNum];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void) change_on_off_status:(NSNotification*) notification
{
    
    _tmp_card=[notification.userInfo objectForKey:@"card"];
    NSString* tag=[notification.userInfo objectForKey:@"tag"];
    
    self.view.userInteractionEnabled=NO;
    _registrationProgressing = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [_registrationProgressing setFrame:CGRectMake((WINDOW_WIDTH / 2) - 50, (WINDOW_HEIGHT / 2) - 50, 100, 100)];
    _registrationProgressing.hidesWhenStopped = YES;
    [_registrationProgressing startAnimating];
    
    
    _blind_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    
    [_blind_view setBackgroundColor:[UIColor blackColor]];
    [_blind_view setAlpha:0.7];
    [self.view addSubview:_blind_view];
    
    [self.view addSubview:_registrationProgressing];
    
    
    _on_off_array= [NSMutableArray new];
    
    for(int i=0; i<5; i++)
        [_on_off_array addObject:[NSString stringWithFormat:@"%d",[_tmp_card.on_off characterAtIndex:i]-48]];
    
    NSString * first_obj=[_on_off_array objectAtIndex:0];
    
    if([tag isEqualToString:@"1"])
    { first_obj=@"0"; NSLog(@"off로");}
    else
    { first_obj=@"1"; NSLog(@"on로");}
    
    [_on_off_array replaceObjectAtIndex:0 withObject:first_obj];
    
    NSArray *dictionKeys = @[@"id",@"card_number",@"on_off"];
    NSArray *dictionVals = @[_tmp_card.myinfo.id,[NSString stringWithFormat:@"%d",_tmp_card.card_number]
                             ,_on_off_array];
    
    
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    
    
    
    NSString *userJsonData = [Common_modules transToJson:client_data];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(response_on_off:)
                                                 name:@"card_upload" object:nil];
    

    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(connectToServer:url:) withObject:userJsonData withObject:card_json_modify];
    

}


- (void) response_on_off:(NSNotification*)notification
{
  

    NSLog(@"here");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"card_upload" object:nil];
    if (_blind_view!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
         
            [_registrationProgressing stopAnimating];
            [_blind_view removeFromSuperview];
            [_registrationProgressing removeFromSuperview];
            
            if(notification.userInfo==nil)
            {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"오류"
                                              message:@"서버에 업로드 실패!"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"확인"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                
                                            }];
                
                [alert addAction:yesButton];
                
                
                
                [self presentViewController:alert animated:YES completion:nil];
                
                self.view.userInteractionEnabled=YES;
                _blind_view=nil;
                
                return;
            }
            
            NSString *now_status=@"";
            
            for(NSString * bit in _on_off_array)
                now_status=[NSString stringWithFormat:@"%@%@",now_status,bit];
            
            _tmp_card.on_off=now_status;
            
            NSError *error;
            
            if (![_managedObjectContext save:&error])
            {
                NSLog(@"Problem saving: %@", [error localizedDescription]);
            }
            
            self.view.userInteractionEnabled=YES;
            
            _tmp_card=nil;
            _on_off_array=nil;
            _blind_view=nil;
    
            
        });
    }
    
}


- (void) respone_remove_card:(NSNotification*)notification
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"delete_card" object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
    [_registrationProgressing stopAnimating];
    [_blind_view removeFromSuperview];
    [_registrationProgressing removeFromSuperview];
    
    
    
    if(notification.userInfo==nil)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"오류"
                                      message:@"서버에 업로드 실패!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"확인"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    
    }
    
    else{
    
    [_myInfo removeMycardsObject:_tmp_card];
    
    [_tableData removeObjectAtIndex:_tmp_index.row];
    
    NSError *error;
    // here's where the actual save happens, and if it doesn't we print something out to the console
    if (![_myInfo.managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
    
    NSLog(@"카드삭제");
    
    
    [_tableview deleteRowsAtIndexPaths:@[_tmp_index] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
    self.view.userInteractionEnabled=YES;
    _tmp_card=nil;
    _tmp_index=nil;
    _blind_view=nil;
    
    
        
    });
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
