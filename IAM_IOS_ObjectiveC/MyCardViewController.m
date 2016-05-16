//
//  MyCardViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 1..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "MyCardViewController.h"
#import "Common_modules.h"
#import "MyInfo.h"
#import "Card.h"
#import "Image.h"
#import "Card_Images_ViewController.h"
#import "KeywordViewController.h"

#import "Server_address.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>



@interface MyCardViewController ()<UITabBarDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *keywordView;


@property (strong, nonatomic) IBOutlet UITextField *name_field;
@property (strong, nonatomic) IBOutlet UITextField *phone_field;
@property (strong, nonatomic) IBOutlet UITextView *status_message;
@property (strong, nonatomic) IBOutlet UITextView *sns_list;


@property (strong, nonatomic) IBOutlet UIButton *keyword_select_button;
@property (strong, nonatomic) IBOutlet UIButton *card_image;
@property (strong, nonatomic) IBOutlet UIButton *video_image;


@property (strong, nonatomic) IBOutlet UIButton *phone_toggle;    //1
@property (strong, nonatomic) IBOutlet UIButton *status_toggle;   //2
@property (strong, nonatomic) IBOutlet UIButton *sns_toggle;      //3
@property (strong, nonatomic) IBOutlet UIButton *video_toggle;    //4

@property (strong, nonatomic) IBOutlet UIButton *image_modify;
@property (strong, nonatomic) IBOutlet UIButton *name_modify;
@property (strong, nonatomic) IBOutlet UIButton *phone_modify;
@property (strong, nonatomic) IBOutlet UIButton *status_modify;
@property (strong, nonatomic) IBOutlet UIButton *sns_modify;
@property (strong, nonatomic) IBOutlet UIButton *video_modify;

@property (strong, nonatomic) IBOutlet UIButton *plus_button;


@property (nonatomic) int card_index;
@property (nonatomic) BOOL is_new;

@property(strong, nonatomic) MyInfo * myinfo;
@property(strong, nonatomic) Card * this_card;
@property (nonatomic) NSMutableArray* text_views;
@property (nonatomic) NSMutableArray * on_off_array;


@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;

@end

@implementation MyCardViewController



- (void) new_card_create:(MyInfo*) info card_num:(int)card_num{
    
    _is_new=true;
    _myinfo=info;
    _card_index=card_num;
    
    NSLog(@"새로운카드");
    
    
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    
    _this_card=(Card*)[NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:_managedObjectContext];
    
    _on_off_array= [NSMutableArray new];
    
    for(int i=0; i<5; i++)
        [_on_off_array addObject:@"1"];
    
    
    _this_card.main_image=UIImagePNGRepresentation([UIImage imageNamed:@"image_empty.png"]);
    [_card_image setBackgroundImage:[UIImage imageWithData:_this_card.main_image] forState:UIControlStateNormal];
    
}


-(void) hide_modify_button
{
    _name_modify.hidden=YES;
    _phone_modify.hidden=YES;
    _status_modify.hidden=YES;
    _sns_modify.hidden=YES;
    
    
    _name_field.userInteractionEnabled=YES;
    _phone_field.userInteractionEnabled=YES;
    _status_message.userInteractionEnabled=YES;
    _sns_list.userInteractionEnabled=YES;
    
}

- (void) setting_exist_card:(Card*) card
{
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    _this_card=card;
    _is_new=false;
    
    NSLog(@"가져온 카드상태  %@",_this_card.on_off);
    
    _on_off_array= [NSMutableArray new];
    
    for(int i=0; i<5; i++)
        [_on_off_array addObject:[NSString stringWithFormat:@"%d",[_this_card.on_off characterAtIndex:i]-48]];
    
    self.title=@"My card";
    
    NSLog(@"배열로 변환 %@",_on_off_array);
    
    
}



- (void) setting_text_image
{
    _name_field.text=_this_card.nickname ? _this_card.nickname:NAME_PLACEHOLDER ;
    _phone_field.text=_this_card.nickname ? _this_card.phone_number:PHONE_PLACEHOLDER ;
    _status_message.text=_this_card.nickname ? _this_card.status_message:STATUS_PLACEHOLDER ;
    _sns_list.text=_this_card.nickname ? _this_card.sns_list:SNS_PLACEHOLDER ;
    
    [_card_image setBackgroundImage:[UIImage imageWithData:_this_card.main_image] forState:UIControlStateNormal ];
}

-(void) setting_on_off
{
    for(int i=1; i<5; i++)
    {
        UIButton *button;
        
  
        if(i==1)
            button=_phone_toggle;
        else if(i==2)
            button=_status_toggle;
        else if(i==3)
            button=_sns_toggle;
        else if(i==4)
            button=_video_toggle;
        
        
        if([[_on_off_array objectAtIndex:i] isEqualToString:@"0"])
        { [button setBackgroundImage:[UIImage imageNamed:@"toggle_hide.png"] forState:UIControlStateNormal];
            
            
            NSLog(@" 상태확인0 %@",[_on_off_array objectAtIndex:i]);
            [button setTag:i+100];
        }
        else
        { [button setBackgroundImage:[UIImage imageNamed:@"toggle_open.png"] forState:UIControlStateNormal];
            
            NSLog(@" 상태확인1 %@",[_on_off_array objectAtIndex:i]);
            [button setTag:i];
        }
    }
    
}




// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, _sns_list.frame.origin) ) {
        [self.scrollView scrollRectToVisible: _sns_list.frame animated:YES];
    }
}




// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    if(!_is_new)
    {  _name_field.userInteractionEnabled=NO;
        _phone_field.userInteractionEnabled=NO;
        _status_message.userInteractionEnabled=NO;
        _sns_list.userInteractionEnabled=NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _status_message.delegate = (id)self;
    _status_message.text = STATUS_PLACEHOLDER;
    _status_message.textColor = [UIColor lightGrayColor]; //optional
    
    
    _sns_list.delegate = (id)self;
    _sns_list.text = SNS_PLACEHOLDER;
    _sns_list.textColor = [UIColor lightGrayColor]; //optional
    
    if(_is_new)
    {
        _name_field.text=_myinfo.nickname;
        [self hide_modify_button];
    }
    else{
        [self setting_text_image];
        [self setting_on_off];
    }
    
    
    [self registerForKeyboardNotifications];
    
    /* [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification
     object:nil];
     
     */
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [_scrollView addGestureRecognizer:tap];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(change_main_image:)
                                                 name:@"change_main_image"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(delete_image:)
                                                 name:@"delete_image"
                                               object:nil];
    
}


// notification 처리

- (void) change_main_image:(NSNotification *) notification
{
    
    Image *image_data = [notification.userInfo objectForKey:@"image"];
    
    if(image_data==nil)
        _this_card.main_image=UIImagePNGRepresentation([UIImage imageNamed:@"image_empty.png"]);
    
    else
        _this_card.main_image=image_data.image;
    
    
    [_card_image setBackgroundImage:[UIImage imageWithData:_this_card.main_image] forState:UIControlStateNormal];
    
    
    NSLog(@"딜리케이트 받음");
    
}

- (void) delete_image:(NSNotification *) notification
{
    
    Image *image_data = [notification.userInfo objectForKey:@"image"];
    
    
    if([image_data.image isEqualToData:_this_card.main_image])
    {
        
        NSLog(@"메인 삭제용");
        _this_card.main_image=UIImagePNGRepresentation([UIImage imageNamed:@"image_empty.png"]);
        [_card_image setBackgroundImage:[UIImage imageWithData:_this_card.main_image] forState:UIControlStateNormal];
    }
    
    [_this_card removeCard_imagesObject:image_data];
    
    
    
    NSLog(@"갯수는  %lu",[_this_card.card_images count]);
    NSLog(@"이미지삭제");
    
}
- (void)dismissKeyboard {
    /*
     _name_field.userInteractionEnabled=NO;
     _phone_field.userInteractionEnabled=NO;
     _status_message.userInteractionEnabled=NO;
     _sns_list.userInteractionEnabled=NO;
     */
    //_scrollView.scrollEnabled=YES;
    
}

- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    //   _scrollView.scrollEnabled=NO;
    NSLog(@"키보드나옴");
}





-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBA:0x01afffff]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView isEqual:_status_message])
        if ([textView.text isEqualToString:STATUS_PLACEHOLDER]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
        }
    
    if([textView isEqual:_sns_list])
        if ([textView.text isEqualToString:SNS_PLACEHOLDER]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
        }
    
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView isEqual:_status_message])
        if ([textView.text isEqualToString:@""]) {
            textView.text = STATUS_PLACEHOLDER;
            textView.textColor = [UIColor lightGrayColor]; //optional
        }
    
    if([textView isEqual:_sns_list])
        if ([textView.text isEqualToString:@""]){
            textView.text = SNS_PLACEHOLDER;
            textView.textColor = [UIColor lightGrayColor]; //optional
        }
    
    [textView resignFirstResponder];
    
    
}


- (IBAction)modify_button_click:(id)sender {
    int tag=(int)[sender tag];
    
    _name_field.userInteractionEnabled=NO;
    _phone_field.userInteractionEnabled=NO;
    _status_message.userInteractionEnabled=NO;
    _sns_list.userInteractionEnabled=NO;
    
    [self resignFirstResponder];
    
    if(tag==0)
    { _name_field.userInteractionEnabled=YES; [_name_field becomeFirstResponder];}
    else if(tag==1)
    {  _phone_field.userInteractionEnabled=YES; [_phone_field becomeFirstResponder]; }
    else if(tag==2)
    {   _status_message.userInteractionEnabled=YES;  [_status_message becomeFirstResponder]; }
    else if(tag==3)
    { _sns_list.userInteractionEnabled=YES;   [_sns_list becomeFirstResponder]; }
}




- (IBAction)toggle_click:(id)sender {
    
    int tag=(int)[sender tag];
    bool flag=true;
    
    
    //hide->open
    if(tag>100)
        flag=false;
    
    tag%=10;
    
    UIButton *button;
    


    if(tag==1)
        button=_phone_toggle;
    else if(tag==2)
        button=_status_toggle;
    else if(tag==3)
        button=_sns_toggle;
    else if(tag==4)
        button=_video_toggle;
    
    if(flag)
    { [button setBackgroundImage:[UIImage imageNamed:@"toggle_hide.png"] forState:UIControlStateNormal];
        
        [_on_off_array replaceObjectAtIndex:tag withObject:@"0"];
        
        tag+=100;
    }
    else
    { [button setBackgroundImage:[UIImage imageNamed:@"toggle_open.png"] forState:UIControlStateNormal];
        
        [_on_off_array replaceObjectAtIndex:tag withObject:@"1"];
    }
    
    [sender setTag:tag];
    
}
- (IBAction)picture_modify_click:(id)sender {
    
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    
    imagePicker.delegate = (id)self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
    
}


-(void)imagePickerController:
(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Code here to work with media
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if(image==NULL)
    {   NSLog(@"비디오");
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"VideoURL = %@", videoURL);
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        NSError *error = NULL;
        CMTime time = CMTimeMake(1, 65);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        NSLog(@"error==%@, Refimage==%@", error, refImg);
        
        UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
        
        [_video_image setBackgroundImage:FrameImage forState:UIControlStateNormal];
    }
    else
    {
        //처음 사진등록일때
         if([_this_card.card_images count]==0)
         { [_card_image setBackgroundImage:image forState:UIControlStateNormal];
             _this_card.main_image=UIImagePNGRepresentation(image);
         }
        
        
        NSData *imageData    = UIImagePNGRepresentation(image);
        Image * new_image = (Image *)[NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:_managedObjectContext];
        
        new_image.image=imageData;
        
        [_this_card addCard_imagesObject:new_image];
        
    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController.tabBar setHidden:NO];
}



- (IBAction)video_modify_click:(id)sender {
    
    // Present videos from which to choose
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = (id)self;
    
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    // This code ensures only videos are shown to the end user
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    videoPicker.hidesBottomBarWhenPushed=YES;
    
    [self.tabBarController.tabBar setHidden:YES];
    
    [self presentViewController:videoPicker animated:YES completion:nil];
    
    
}

//@connect server

//서버에 카드등록!
- (void) request_card
{
    
    NSLog(@"json 만드는중");
    NSArray *dictionKeys = @[@"id",@"keyword",@"nickname",
                             @"on_off",@"phone_number",@"sns_list",
                             @"status_message",@"card_number",@"image_size"];
    
   
    
    NSArray *dictionVals = @[_myinfo.id,_this_card.keyword,_this_card.nickname,
                             _on_off_array,_this_card.phone_number,_this_card.sns_list,
                             _this_card.status_message,[NSString stringWithFormat:@"%d",_card_index]
                             ,[NSString stringWithFormat:@"%lu",[_this_card.card_images count]+1]];
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    NSString *userJsonData = [Common_modules transToJson:client_data];
    
    NSLog(@"json 만드는중2");
    
    //사진 배열
    NSArray *images=[_this_card.card_images allObjects];
    
    //메인이미지 추가
    Image * main_image = (Image *)[NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:_managedObjectContext];
    main_image.image=_this_card.main_image;
    
    [images arrayByAddingObject:main_image];
    

     NSLog(@"json 만드는중3");
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(uploadImageLegacy:json:) withObject:images withObject:userJsonData];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"스크롤중");
    
    // If not dragging, send event to next responder
    if (!_scrollView.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!!_scrollView.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!!_scrollView.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}
- (IBAction)done_click:(id)sender {
    
   
    
    if([_name_field.text isEqualToString:@""])
    {
        [self show_alert:@"오류" message:@"이름을 입력해주세요." yes:@"" no:@""];
        return;
    }
    
    if([_this_card.main_image isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"image_empty.png"])])
    {
        [self show_alert:@"오류" message:@"메인사진을 등록해주세요." yes:@"" no:@""];
        return;
    }
    
    
    _this_card.nickname=([_name_field.text isEqualToString:NAME_PLACEHOLDER])?NAME_PLACEHOLDER:_name_field.text;
    
    _this_card.phone_number= ([_phone_field.text isEqualToString:PHONE_PLACEHOLDER])?PHONE_PLACEHOLDER:_phone_field.text;
    
    _this_card.status_message=([_status_message.text isEqualToString:STATUS_PLACEHOLDER])?STATUS_PLACEHOLDER:_status_message.text;
    
    _this_card.sns_list=([_sns_list.text isEqualToString:SNS_PLACEHOLDER])?SNS_PLACEHOLDER:_sns_list.text;
    
    
    
    NSString *now_status=@"";
    
    for(NSString * bit in _on_off_array)
        now_status=[NSString stringWithFormat:@"%@%@",now_status,bit];
    
    _this_card.on_off=now_status;

    
    if(_is_new)
    {
      [_myinfo addMycardsObject:_this_card];
      [self request_card];
        
    }
    
    NSError *error;
    
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
    
    //  [_myinfo removeMycards:_myinfo.mycards];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)image_click:(id)sender {
    
    if([_this_card.card_images count]==0)
        NSLog(@"아직 등록한 이미지 없음!!");
    
    else{
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Card_Images_ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"Card_Images_ViewController"];
        [vc setup_images:_this_card];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}


-(void) show_alert:(NSString*)title message:(NSString*)message yes:(NSString*)yes no:(NSString*)no
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
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

- (IBAction)click_keyword:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KeywordViewController *vc = [sb instantiateViewControllerWithIdentifier:@"KeywordViewController"];
    
    [vc set_keyword:_this_card.keyword];
    
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
