//
//  OptionViewController.m
//  관심명함
//
//  Created by KMK on 2016. 5. 22..
//  Copyright © 2016년 KMK. All rights reserved.
//
#import "AppDelegate.h"
#import "OptionViewController.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>



@interface OptionViewController ()

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBA:0x01afffff]];
}


- (IBAction)logout_click:(id)sender {
    
    
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            // logout success.
            [[[UIApplication sharedApplication] delegate] performSelector:@selector(logout)];
        } else {
            // failed
            NSLog(@"failed to logout.");
        }
    }];


    
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
