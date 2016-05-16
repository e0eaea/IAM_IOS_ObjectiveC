//
//  Card_image_ViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "C_Image_ViewController.h"
#import "Card_Images_ViewController.h"

@interface C_Image_ViewController ()

@property (nonatomic,strong) NSDictionary *image_data;
@property (nonatomic,strong) Card_Images_ViewController * images_view;

@end

@implementation C_Image_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    _imageView.image = [UIImage imageWithData:_imgFile.image];
    _images_view=(Card_Images_ViewController*)_card_images;
    
    NSArray *dictionKeys = @[@"image"];
    NSArray *dictionVals = @[_imgFile];
    _image_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if([_images_view.main_image_data isEqualToData:_imgFile.image])
    {   NSLog(@"같음!");   [self set_main_button:YES]; }
    else
    {  NSLog(@"다름!"); [self set_main_button:NO];     }
    
    NSLog(@"이미지 띄우기");
}
    
- (void) set_main_button:(BOOL)is_main{
 
    if(is_main)
    {
        [_main_register setBackgroundImage:[UIImage imageNamed:@"main_selected.png"] forState:UIControlStateNormal];
        [_main_register setTag:1];
    }
    
    else{
        
        [_main_register setBackgroundImage:[UIImage imageNamed:@"main_unselected.png"] forState:UIControlStateNormal];
        [_main_register setTag:0];
        
    }
}

- (IBAction)close_button_click:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
    }]];
    
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"delete_image"  object:nil userInfo:_image_data];
        
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

    
}


- (IBAction)main_click:(id)sender {

      NSLog(@"메인카드 이미지 변경");
    
    int tag=(int)[_main_register tag];
    
    if(tag==0)
    {
        [_main_register setBackgroundImage:[UIImage imageNamed:@"main_selected.png"] forState: UIControlStateNormal];
        [_main_register setTag:1];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"change_main_image"
                                                            object:nil userInfo:_image_data];
    }
    else
    {
        [_main_register setBackgroundImage:[UIImage imageNamed:@"main_unselected.png"] forState: UIControlStateNormal];
        [_main_register setTag:0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"change_main_image"
                                                            object:nil userInfo:nil];
        
        
    }
    
  
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
