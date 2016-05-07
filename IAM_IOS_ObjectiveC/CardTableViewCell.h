//
//  CardTableViewCell.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 4..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *card_image;
@property (strong, nonatomic) IBOutlet UIButton *card_open;
@property (strong, nonatomic) IBOutlet UITextField *card_title;

@end
