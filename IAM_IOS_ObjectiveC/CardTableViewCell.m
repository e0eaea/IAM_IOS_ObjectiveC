//
//  CardTableViewCell.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 4..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "CardTableViewCell.h"

@implementation CardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)toggle_on_off:(id)sender {
    
    int tag=(int)[sender tag];
    
    if(tag==1)
    [_card_open setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    else
        [_card_open setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    
    
    [_card_open setTag:(tag==0)? 1:0 ];
        
        
}

@end
