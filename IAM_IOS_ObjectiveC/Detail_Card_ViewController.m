//
//  Detail_Card_ViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 11..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "Detail_Card_ViewController.h"
#import "Size_Define.h"
#import "Image.h"
#import "MyInfo.h"
#import "Other_Info.h"



@interface Detail_Card_ViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (strong, nonatomic) IBOutlet UIButton *main_image;

@property (strong, nonatomic) IBOutlet UITextField *nickname;
@property (strong, nonatomic) IBOutlet UITextView *status_field;

@property (strong, nonatomic) IBOutlet UIButton *hide_status;

@property (strong, nonatomic) IBOutlet UIButton *phone_button;
@property (strong, nonatomic) IBOutlet UIButton *sns_button;
@property (strong, nonatomic) IBOutlet UIButton *video_button;
@property (strong, nonatomic) IBOutlet UIButton *add_card;

@property(strong, nonatomic) UIView *blind_view;
@property (nonatomic,strong) NSMutableArray* select_keyword;
@property (nonatomic,strong) NSMutableArray* on_off_array;
@property(nonatomic) bool is_favorite;


@property (nonatomic, retain) UIActivityIndicatorView *registrationProgressing;

@end

@implementation Detail_Card_ViewController

-(id) init_with_client_info:(Client *)client from_favorite:(bool)from_favorite
{
    
    NSLog(@"클라이언트 아이디1 %@!!!",client.id);
    
    if(self = [super init])
    {  _client=client;
        [Client request_more_info:_client.id card_number:[NSString stringWithFormat:@"%d",_client.card.card_number]];
        
        if(from_favorite)
        {   _is_favorite=YES;
            [self set_for_favorite];
        }
        else
            _is_favorite=NO;
    }
    
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receive_more_info:)
                                                 name:@"more_info"
                                               object:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    
    _select_keyword=[[NSMutableArray alloc]init];
    if(![_client.card.keyword isEqualToString:@"null"])
    {
        
        NSArray *s=[_client.card.keyword componentsSeparatedByString:@" "];
        
        for ( NSString * component in s )
        {   [_select_keyword addObject:component]; NSLog(@"%@",component);}
    }
    
    
    [self set_keyword_buttons];
    
}


- (void)receive_more_info:(NSNotification *) notification
{
    if(notification.userInfo ==nil)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"오류"
                                      message:@"서버에서 다운로드 실패!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"확인"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.navigationController popViewControllerAnimated:YES];

                                    }];
        
        [alert addAction:yesButton];
        
        
     
        [self presentViewController:alert animated:YES completion:nil];


        return;
        
    }
        
    NSLog(@"자세한 정보 받아옴!");
    
    _on_off_array=[notification.userInfo objectForKey:@"on_off"];
    
    NSString *now_status=@"";
    
    for(NSString * bit in _on_off_array)
        now_status=[NSString stringWithFormat:@"%@%@",now_status,bit];
    
    _client.card.on_off=now_status;
    _client.card.main_image=[NSData dataFromBase64String:[notification.userInfo objectForKey:@"profile_picture"]];
    _client.card.status_message=[notification.userInfo objectForKey:@"status_message"];
    _client.card.phone_number=[notification.userInfo objectForKey:@"phone_number"];
    //_client.card.sns_list=[notification.userInfo objectForKey:@"sns"];
    
    NSString *image_cnt=[NSString stringWithFormat:@"%@",[notification.userInfo objectForKey:@"picture_size"]];
    NSMutableArray * images=[notification.userInfo objectForKey:@"picture"];
    
    
    for(int i=0; i<[image_cnt intValue]; i++)
    {
        Image * new_image = (Image *)[NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:_client.card.managedObjectContext];
        
        new_image.image=[NSData dataFromBase64String:[images objectAtIndex:i]];
        new_image.index=i;
        [_client.card addCard_imagesObject:new_image];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        [_main_image setBackgroundImage:[UIImage imageWithData:[NSData dataFromBase64String:[notification.userInfo objectForKey:@"profile_picture"]]]
                               forState:UIControlStateNormal];
        _nickname.text=[notification.userInfo objectForKey:@"nickname"];
        
        [self set_hide_info];
        
        [_blind_view removeFromSuperview];
        [_registrationProgressing stopAnimating];
        [_registrationProgressing removeFromSuperview];
        
       
        
        [self.view setUserInteractionEnabled:YES];
        
        
    });
    
   
    
    
}

- (void) set_keyword_buttons
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int current_num=(int)[_select_keyword count];
        
        
        for(int i=0; i<current_num; i++)
        {
            UIButton *button=[_buttons objectAtIndex:i];
            
            [button setBackgroundImage:[UIImage imageNamed:@"keyword.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:[_select_keyword objectAtIndex:i] forState:UIControlStateNormal];
        }
        
        for(int i=current_num; i<5; i++)
        {
            UIButton *button=[_buttons objectAtIndex:i];
            [button setBackgroundImage:[UIImage imageNamed:@"keyword_x.png"] forState:UIControlStateNormal];
            
            [button setTitle:@"" forState:UIControlStateNormal];
        }
        
    });
    
}

- (void) set_hide_info
{
    
    
    if([[_on_off_array objectAtIndex:1] isEqualToString:@"1"])  //status_message show
    {
        [_hide_status setHidden:YES];
        NSLog(@"상태메세지 공개");
        
    }
    
    if([[_on_off_array objectAtIndex:2]isEqualToString:@"1"])  //phone_number_show
    {
     
        [_phone_button setBackgroundImage:[UIImage imageNamed:@"save-number.png"] forState:UIControlStateNormal];
        [_phone_button setTag:1];
        [_phone_button setUserInteractionEnabled:YES];
         NSLog(@"폰번호 공개");
        
    }
    
    if([[_on_off_array objectAtIndex:3] isEqualToString:@"1"])  // sns show
    {
        NSLog(@"sns 공개");
        
        [_sns_button setBackgroundImage:[UIImage imageNamed:@"connect-SNS.png"] forState:UIControlStateNormal];
        [_sns_button setTag:1];
        [_sns_button setUserInteractionEnabled:YES];
        
    }
    if([_on_off_array objectAtIndex:4])  // video show
    {
         NSLog(@"비디오 공개");
        [_video_button setBackgroundImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
        [_video_button setTag:1];
        [_video_button setUserInteractionEnabled:YES];
    }
    
    
}


- (IBAction)phone_click:(id)sender {
    
    NSLog(@"연락처 저장!");

    if([_client.card.phone_number isEqualToString:@"핸드폰 번호를 입력하세요"])
        [self show_alert:@"오류" message:@"연락처정보가 없습니다." yes:@"" no:@""];
    
    else{
        [self saveContact:_client.card.nickname givenName:@"" phoneNumber:_client.card.phone_number];
        [self show_alert:@"완료" message:@"연락처가 저장되었습니다." yes:@"" no:@""];
    }

}


- (IBAction)sns_click:(id)sender {

}

- (IBAction)add_card_click:(id)sender {
    
  Other_Info *other =(Other_Info*)[NSEntityDescription insertNewObjectForEntityForName:@"Other_Info" inManagedObjectContext:_client.myinfo.managedObjectContext];
    
    other.id=_client.id;
    
    
    NSArray * mArray=[_client.myinfo.interest_other allObjects];
    
    int max=0;
    for(Other_Info * i in mArray)
    {
        if(i.index > max)
            max=i.index;
    }
    
    int new_image_num=(int)max+1;
    
    other.index=new_image_num;
    
    [other addOther_cardsObject:_client.card];

    [_client.myinfo addInterest_otherObject:other];
    
    NSError *error;
    // here's where the actual save happens, and if it doesn't we print something out to the console
    if (![_client.myinfo.managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }

 

      [self show_alert:@"저장완료!" message:@"관심명함으로 등록되었습니다." yes:@"" no:@""];
        
      [_add_card setBackgroundImage:[UIImage imageNamed:@"added.png"] forState:UIControlStateNormal];
   
  
    [_add_card setTag:1];
    [_add_card setUserInteractionEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveContact:(NSString*)familyName givenName:(NSString*)givenName phoneNumber:(NSString*)phoneNumber {
    CNMutableContact *mutableContact = [[CNMutableContact alloc] init];
    
    mutableContact.givenName = givenName;
    mutableContact.familyName = familyName;
    CNPhoneNumber * phone =[CNPhoneNumber phoneNumberWithStringValue:phoneNumber];
    
    mutableContact.phoneNumbers = [[NSArray alloc] initWithObjects:[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:phone], nil];
    CNContactStore *store = [[CNContactStore alloc] init];
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:mutableContact toContainerWithIdentifier:store.defaultContainerIdentifier];
    
    NSError *error;
    if([store executeSaveRequest:saveRequest error:&error]) {
        NSLog(@"save");
    }else {
        NSLog(@"save error");
    }
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


- (void) set_for_favorite
{
    dispatch_async(dispatch_get_main_queue(), ^{
    [_add_card setBackgroundImage:[UIImage imageNamed:@"added.png"] forState:UIControlStateNormal];
    [_add_card setUserInteractionEnabled:NO];
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
