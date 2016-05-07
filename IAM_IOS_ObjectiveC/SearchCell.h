//
//  SearchCell.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 9..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"



@interface SearchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *back_image;
@property (strong, nonatomic) IBOutlet UIImageView *profile_image;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIButton *like_button;

@property (strong, nonatomic) Client *client_info;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progressing;

- (void) adjust;

@end
