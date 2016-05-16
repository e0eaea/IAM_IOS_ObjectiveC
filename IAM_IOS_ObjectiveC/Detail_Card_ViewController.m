//
//  Detail_Card_ViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 11..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "Detail_Card_ViewController.h"
#import "Size_Define.h"



@interface Detail_Card_ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *k1;
@property (strong, nonatomic) IBOutlet UIButton *k2;
@property (strong, nonatomic) IBOutlet UIButton *k3;
@property (strong, nonatomic) IBOutlet UIButton *k4;
@property (strong, nonatomic) IBOutlet UIButton *k5;

@property (strong, nonatomic) IBOutlet UIButton *main_image;

@property (strong, nonatomic) IBOutlet UITextField *nickname;

@property (strong, nonatomic) IBOutlet UIButton *hide_status;

@property (strong, nonatomic) IBOutlet UIButton *phone_button;
@property (strong, nonatomic) IBOutlet UIButton *sns_button;
@property (strong, nonatomic) IBOutlet UIButton *video_button;
@property (strong, nonatomic) IBOutlet UIButton *add_card;

@property (nonatomic, retain) UIActivityIndicatorView *registrationProgressing;

@end

@implementation Detail_Card_ViewController

-(id) init_with_client_info:(Client *)client
{
    
    NSLog(@"클라이언트 아이디1 %@!!!",client.id);
    
    if(self = [super init])
    {  _client=client;
       [Client request_more_info:_client.id];
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
    [self.view addSubview:_registrationProgressing];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receive_more_info:)
                                                 name:@"more_info"
                                               object:nil];
}


- (void)receive_more_info:(NSNotification *) notification
{
    
    NSLog(@"자세한 정보 받아옴!");
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [_main_image setBackgroundImage:[UIImage imageWithData:[NSData dataFromBase64String:[notification.userInfo objectForKey:@"profile_picture"]]]
                           forState:UIControlStateNormal];
    _nickname.text=[notification.userInfo objectForKey:@"nickname"];
 
    [_registrationProgressing stopAnimating];
    [_registrationProgressing removeFromSuperview];
        
    [self.view setUserInteractionEnabled:YES];
        
    });
        

    
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
