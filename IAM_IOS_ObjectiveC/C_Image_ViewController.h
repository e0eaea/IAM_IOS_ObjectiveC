//
//  Card_image_ViewController.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

@interface C_Image_ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *main_register;
@property (strong, nonatomic) IBOutlet UIButton *close_button;

@property (nonatomic,strong) UIViewController * card_images;

@property NSUInteger pageIndex;
@property Image *imgFile;


@end
