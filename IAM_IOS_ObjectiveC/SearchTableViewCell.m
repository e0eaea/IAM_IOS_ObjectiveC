//
//  SearchTableViewCell.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 4..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell()



@end


@implementation SearchTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _name.text=@"";
    _uuid.text=@"";
    
    return self;
}


-(void) adjust
{
    _name.text=_type.name;
    _uuid.text=_type.uuid;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
