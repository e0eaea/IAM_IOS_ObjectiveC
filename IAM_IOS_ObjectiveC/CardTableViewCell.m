//
//  CardTableViewCell.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 4..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "CardTableViewCell.h"
#import "Common_modules.h"
#import "AppDelegate.h"


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
    
    NSString *msg=@"";
    int tag=(int)[sender tag];
    
    if(tag==1)
        msg=@"카드를 주변사람들에게 숨깁니다.";
    else
        msg=@"카드가 주변사람들에게 공개됩니다.";
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"경고"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"확인"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
    
    
                                    NSArray *dictionKeys = @[@"card",@"tag"];
                                    NSArray *dictionVals = @[_this_card,[NSString stringWithFormat:@"%d",tag]];
                                    
                                    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
                                    
                                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                                             selector:@selector(change_on_off:)
                                                                                 name:@"card_upload" object:nil];

                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"on_off_alert"
                                                                                        object:nil userInfo:client_data];
                                
                                    
                                }];
    
    [alert addAction:yesButton];
    
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"취소"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                                   
                                   
                               }];
    
    
    [alert addAction:noButton];
    
    [_svc presentViewController:alert animated:YES completion:nil];
    
    
}


- (void) change_on_off:(NSNotification*) notification
{
    
    int tag=(int)[_card_open tag];

    if(notification.userInfo==nil)
    {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"오류"
                                      message:@"서버에 업로드 실패!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"확인"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                    
                                        
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"취소"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                       
                                       
                                   }];
        
        
        [alert addAction:noButton];
        
        [_svc presentViewController:alert animated:YES completion:nil];
    }
    
        
    else{
        NSLog(@"on_off 변경중");

        dispatch_async(dispatch_get_main_queue(), ^{
            
    
        if(tag==1)
            [_card_open setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
        
        else
            [_card_open setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
        
            
        [_card_open setTag:(tag==0)? 1:0 ];
            
        });
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"card_upload" object:nil];

}

@end
