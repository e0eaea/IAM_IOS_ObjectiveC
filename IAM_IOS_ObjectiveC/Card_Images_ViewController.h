//
//  Card_Images_ViewController.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card_image_ViewController.h"
#import "Card.h"


@interface Card_Images_ViewController : UIViewController<UIPageViewControllerDataSource>


@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (nonatomic,strong) NSMutableArray *arrPageTitles;
@property (nonatomic,strong) NSMutableArray *arrPageImages;

- (Card_image_ViewController *)viewControllerAtIndex:(NSUInteger)index;
-(void) setup_images:(Card *)card;

@end
