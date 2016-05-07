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

@property (strong, nonatomic) IBOutlet UIButton *image_toggle;
@property (strong, nonatomic) IBOutlet UIButton *name_toggle;
@property (strong, nonatomic) IBOutlet UIButton *phone_toggle;
@property (strong, nonatomic) IBOutlet UIButton *status_toggle;
@property (strong, nonatomic) IBOutlet UIButton *sns_toggle;
@property (strong, nonatomic) IBOutlet UIButton *video_toggle;

@property (strong, nonatomic) IBOutlet UIButton *card_modify;
@property (strong, nonatomic) IBOutlet UIButton *name_modify;
@property (strong, nonatomic) IBOutlet UIButton *phone_modify;
@property (strong, nonatomic) IBOutlet UIButton *status_modify;
@property (strong, nonatomic) IBOutlet UIButton *sns_modify;
@property (strong, nonatomic) IBOutlet UIButton *video_modify;

@property (strong, nonatomic) IBOutlet UIButton *plus_button;



@property (nonatomic) BOOL is_first;
@property (nonatomic) NSMutableArray* text_views;
@property(strong, nonatomic) MyInfo * myinfo;
@property(strong, nonatomic) Card * this_card;

@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;

@end

@implementation MyCardViewController


- (void) new_card_create:(MyInfo*) info{

    _is_first=false;
    _myinfo=info;
    NSLog(@"새로운카드");
    
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    
    _this_card=(Card*)[NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:_managedObjectContext];
    

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
    
    _name_field.userInteractionEnabled=NO;
    _phone_field.userInteractionEnabled=NO;
    _status_message.userInteractionEnabled=NO;
    _sns_list.userInteractionEnabled=NO;
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
    
    
    
    
}

- (void)dismissKeyboard {
    
    _name_field.userInteractionEnabled=NO;
    _phone_field.userInteractionEnabled=NO;
    _status_message.userInteractionEnabled=NO;
    _sns_list.userInteractionEnabled=NO;
    
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
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBA:0x01afffff]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
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
        button=_image_toggle;
    else if(tag==2)
        button=_name_toggle;
    else if(tag==3)
        button=_phone_toggle;
    else if(tag==4)
        button=_status_toggle;
    else if(tag==5)
        button=_sns_toggle;
    else if(tag==6)
        button=_video_toggle;
    
    if(flag)
    { [button setBackgroundImage:[UIImage imageNamed:@"toggle_hide.png"] forState:UIControlStateNormal];
        tag+=100;
    }
    else
        [button setBackgroundImage:[UIImage imageNamed:@"toggle_open.png"] forState:UIControlStateNormal];
    
    
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
        if([_this_card.card_images count]==0)
             [_card_image setBackgroundImage:image forState:UIControlStateNormal];
        
        NSData *imageData    = UIImagePNGRepresentation(image);
        Image * new_image = (Image *)[NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:_managedObjectContext];
       
        new_image.image=imageData;
        [_this_card addCard_imagesObject:new_image];
        
        /*
        NSString *base64Encoded = [imageData base64EncodedStringWithOptions:0];
        
        [self request_image:image];
        
        NSData *data2 = [[NSData alloc] initWithBase64EncodedString:base64Encoded options:0];
        
        UIImage *image2 = [UIImage imageWithData:data2];
        */
        
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

//서버에 정보요청!
- (void) request_image:(UIImage*)image
{
    
    NSArray *dictionKeys = @[@"id",@"idx",@"card_number",@"data"];
    NSArray *dictionVals = @[@"mk",@"0",@"0",@"11"];
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    
    NSString *userJsonData = [Common_modules transToJson:client_data];
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(uploadImageLegacy:json:) withObject:image withObject:userJsonData];
    
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
    

    
    if(![_name_field.text isEqualToString:NAME_PLACEHOLDER])
        _this_card.nickname=_name_field.text;
    if(![_phone_field.text isEqualToString:PHONE_PLACEHOLDER])
        _this_card.phone_number=_phone_field.text;
    if(![_status_message.text isEqualToString:STATUS_PLACEHOLDER])
        _this_card.status_message=_status_message.text;
    if(![_sns_list.text isEqualToString:SNS_PLACEHOLDER])
        _this_card.sns_list=_sns_list.text;
    
    [_myinfo addMycardsObject:_this_card];
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
