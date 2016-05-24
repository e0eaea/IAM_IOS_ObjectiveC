//
//  SearchCell.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 9..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    return self;
}




- (void) adjust
{
    if(_client_info.status)
    {
        
        [_progressing stopAnimating];
        [_progressing removeFromSuperview];
        
        [ _profile_image setImage:[UIImage imageWithData: _client_info.card.main_image]];

  
      _profile_image.clipsToBounds = NO;
      _profile_image.layer.cornerRadius  = _profile_image.frame.size.height/3;
      _profile_image.layer.borderWidth = 1;
      _profile_image.layer.borderColor = [UIColor lightGrayColor].CGColor;
      
      _profile_image.layer.masksToBounds  = YES;
  
        _name.text=_client_info.card.nickname;
       _keyword.text=_client_info.card.keyword;
        self.contentView.userInteractionEnabled=YES;
    }
    
    else
    {   _name.text=@"";
        _keyword.text=@"";
        NSLog(@" 프로그래스 돌아가");
    
        self.contentView.userInteractionEnabled=NO;
        _progressing.hidesWhenStopped = YES;
        [_progressing startAnimating];
    
    
    }
    

   // _profile_image.image=[UIImage imageWithData:_client_info.base64_image];
   
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
