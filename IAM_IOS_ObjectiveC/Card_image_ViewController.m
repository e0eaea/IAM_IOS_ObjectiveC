//
//  Card_image_ViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "Card_image_ViewController.h"

@interface Card_image_ViewController ()

@end

@implementation Card_image_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        _imageView.image = [UIImage imageWithData:_imgFile];
        _title_text.text = @"1";
    
    
}

- (IBAction)close_button_click:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
    }]];
    
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

    
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
