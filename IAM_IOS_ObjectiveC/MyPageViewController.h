//
//  MyPageViewController.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 12..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *id_label;
@property (strong, nonatomic) IBOutlet UISwitch *advertisingSwitch;

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *topbar;

@end
