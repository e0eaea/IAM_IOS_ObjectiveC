//
//  Card_Images_ViewController.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C_Image_ViewController.h"
#import "Card.h"


@interface Card_Images_ViewController : UIViewController<UIPageViewControllerDataSource>


@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (nonatomic,strong) NSData *main_image_data;
@property (nonatomic,strong) NSMutableArray *arrPageImages;

- (C_Image_ViewController *)viewControllerAtIndex:(NSUInteger)index;
-(void) setup_images:(Card *)card;

@end
