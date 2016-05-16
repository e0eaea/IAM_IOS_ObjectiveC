//
//  LoginViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 7..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "LoginViewController.h"
#import <sys/utsname.h>
#import "MainViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *kakao_button;
@property(strong, nonatomic) MyInfo * myinfo;
@property(strong,nonatomic) UIWindow * window;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    

    _window=[[[UIApplication sharedApplication] delegate]window];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next_click:(id)sender {
   
    
    [[KOSession sharedSession] close];
    
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        
        if ([[KOSession sharedSession] isOpen]) {
            // login success.
            NSLog(@"login success.");
          
                    [KOSessionTask meTaskWithCompletionHandler:^(KOUser* result, NSError* error){
                        
                        if (result) {
                            NSLog(@"카카오톡 프로필 가져오기 성공 %@",result);
                            
                            NSArray *dictionKeys = @[@"type", @"id",@"nickname"];
                            NSArray *dictionVals = @[@"login",
                                                     result.ID.stringValue, [result propertyForKey:@"nickname"]];
                            
                            NSDictionary *kakaoData = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
                            
                            NSString *userJsonData = [Common_modules transToJson:kakaoData];
                            
                            [[[UIApplication sharedApplication] delegate] performSelector:@selector(connectToServer:url:) withObject:userJsonData withObject:sign_up];
                            
                            [self check_login:kakaoData];
                            
                            
                        }
                        else
                            NSLog(@"카카오톡 프로필 가져오기 실패 %@", error);

                }];
        }}];
    
}



- (void) check_login:(NSDictionary *)data
{
    NSLog(@"로그인 넘어가기");
    
    MyInfo *myinfo=[[[UIApplication sharedApplication] delegate] performSelector:@selector(getMyInfo)];
    NSString *message=@"";
    
    //최초로그인
    if([myinfo isKindOfClass:NULL])
    {
        message=@"로그인 성공";
        NSLog(@"로그인1");
        
        
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(saveData:) withObject:data];

    
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController* viewController = [storyBoard instantiateViewControllerWithIdentifier:@"Main"];
        
        [_window setRootViewController:viewController];
        
    }
    
    else{
        //기존접속이 아닌경우
        if(myinfo.id!=[data valueForKey:@"id"])
        {
            message=@"로그인 성공2";
            NSLog(@"로그인2");
            
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"새로운 로그인"
                                          message:@"기존의 사용자정보는 사라집니다."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"네"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            //Handel your yes please button action here
                                             [[[UIApplication sharedApplication] delegate] performSelector:@selector(saveData:) withObject:data];
                                            
                                            
                                            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                            UIViewController* viewController = [storyBoard instantiateViewControllerWithIdentifier:@"Main"];
                                            
                                            [_window setRootViewController:viewController];
                                            
                                            
                                        }];
            
            [alert addAction:yesButton];
            
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"아니오"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel no, thanks button
                                           
                                           
                                           UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
                                           UIViewController* viewController = [storyBoard instantiateViewControllerWithIdentifier:@"Login"];
                                           
                                           [_window setRootViewController:viewController];
                                           
                                       }];
            
            
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        else{
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
            UIViewController* viewController = [storyBoard instantiateViewControllerWithIdentifier:@"Login"];
            
            [_window setRootViewController:viewController];

            
        }
        
    }
    NSLog(@"넘어가기 끝");

}





//키보드 내리기
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // UITouch *touch = [[event allTouches] anyObject];
    
   // [_name_field resignFirstResponder];
    
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
