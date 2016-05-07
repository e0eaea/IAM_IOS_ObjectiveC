//
//  Card_image_ViewController.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card_image_ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *title_text;
@property (strong, nonatomic) IBOutlet UIButton *close_button;
@property NSUInteger pageIndex;
@property NSData *imgFile;
@property NSString *txtTitle;

@end
