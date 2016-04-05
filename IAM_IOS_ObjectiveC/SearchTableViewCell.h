//
//  SearchTableViewCell.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 4..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brief_profile.h"

@interface SearchTableViewCell : UITableViewCell

@property (strong, nonatomic) Brief_profile * type;

@property (strong, nonatomic) IBOutlet UILabel* name;
@property (strong, nonatomic) IBOutlet UILabel* uuid;

-(void) adjust;

@end
