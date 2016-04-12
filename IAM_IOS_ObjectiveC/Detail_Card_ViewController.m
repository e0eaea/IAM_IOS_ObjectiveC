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
@property (nonatomic, retain) UIActivityIndicatorView *registrationProgressing;

@end

@implementation Detail_Card_ViewController

-(id) init_with_client_info:(Client *)client
{
    if(self = [super init])
        _client=client;

    
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
    
    [Client request_more_info:_client.id];
    
    
   

}


- (void)receive_more_info:(NSNotification *) notification
{
    
    
    NSLog(@"자세한 정보 받아옴!");
    
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
    _card_image.image=[UIImage imageWithData:
                       [NSData dataFromBase64String:[notification.userInfo objectForKey:@"profile_picture"]]];
    _card_name.text=[notification.userInfo objectForKey:@"nickname"];
 
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
