//
//  KeywordViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 15..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "KeywordViewController.h"
#import "UIColor+Helper.h"

@interface KeywordViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *s_buttons;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic,strong) NSMutableArray* select_keyword;

@property int flag;
@property (strong,nonatomic) Card * card;
@property (strong,nonatomic) MyInfo * myinfo;

@end

@implementation KeywordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for(NSString *keyword in _select_keyword)
    {   for(UIButton * button in _buttons)
    {
        if([button.titleLabel.text isEqualToString:keyword])
        {   [button setBackgroundImage:[UIImage imageNamed:@"keyword.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTag:1];
        }
    }
    }
    
    [self set_keyword_buttons];
    
}


- (void) set_keyword:(Card*) card
{
    _card=card;
    _flag=0;
    _select_keyword=[[NSMutableArray alloc]init];
    
    
    if(![_card.keyword isEqualToString:@"null"])
    {
        NSArray *s=[_card.keyword componentsSeparatedByString:@" "];
        
        for ( NSString * component in s )
            [_select_keyword addObject:component];
    }
    
    
}

- (void) set_search_keyword:(MyInfo *) myinfo
{
    _myinfo=myinfo;
    _flag=1;
    
    _select_keyword=[[NSMutableArray alloc]init];
    
    
    if(![_myinfo.keyword isEqualToString:@"null"])
    {
        NSArray *s=[_myinfo.keyword componentsSeparatedByString:@" "];
        
        for ( NSString * component in s )
            [_select_keyword addObject:component];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)keyword_selected:(UIButton*) sender {
    
    
    UIButton *button = (UIButton*)sender;
    NSString* title = button.titleLabel.text;
    
    if([sender tag]==0)
    {
        if([_select_keyword count]<5)
        {
            
            [_select_keyword addObject:title];
            
            [button setBackgroundImage:[UIImage imageNamed:@"keyword.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTag:1];
            
            
        }
        
        else{
            [self show_alert:@"오류" message:@"5개 이상 선택할 수 없습니다." yes:@"" no:@""];
        }
        
    }
    
    else if([sender tag]==1 && [_select_keyword count]>0){
        
        for(int i=0; i<[_select_keyword count]; i++)
        {
            NSString *s=[_select_keyword objectAtIndex:i];
            if([title isEqualToString:s])
                [_select_keyword removeObjectAtIndex:i];
        }
        
        [button setBackgroundImage:[UIImage imageNamed:@"keyword-bg-unselected.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRGBA:0x01afffff] forState:UIControlStateNormal];
        [button setTag:0];
        
        
        
    }
    
    [self set_keyword_buttons];
    
}

- (void) set_keyword_buttons
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int current_num=(int)[_select_keyword count];
        
        for(int i=0; i<current_num; i++)
        {
            UIButton *button=[_s_buttons objectAtIndex:i];
            
            [button setBackgroundImage:[UIImage imageNamed:@"keyword.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:[_select_keyword objectAtIndex:i] forState:UIControlStateNormal];
        }
        
        for(int i=current_num; i<5; i++)
        {
            UIButton *button=[_s_buttons objectAtIndex:i];
            [button setBackgroundImage:[UIImage imageNamed:@"keyword_x.png"] forState:UIControlStateNormal];
            
            [button setTitle:@"" forState:UIControlStateNormal];
        }
        
    });
    
}
- (IBAction)done_clicked:(id)sender {
    
    NSString *keywords_string=@"";
    
    
    int current_num=(int)[_select_keyword count];
   
    if(current_num>0)
        keywords_string=[_select_keyword objectAtIndex:0];
    
    else
    {  [self show_alert:@"오류" message:@"키워드를 하나 이상 선택하세요." yes:@"" no:@""]; return;}
    
    for(int i=1; i<current_num; i++)
    {
        NSString *s=[_select_keyword objectAtIndex:i];
        keywords_string=[NSString stringWithFormat:@"%@ %@",keywords_string,s];
    }
    
    if(_flag==0)
        _card.keyword=keywords_string;
    
    else
    {
        _myinfo.keyword=keywords_string;
        NSError *error;
        
        if (![_myinfo.managedObjectContext save:&error])
        {
            NSLog(@"Problem saving: %@", [error localizedDescription]);
        }
        
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) show_alert:(NSString*)title message:(NSString*)message yes:(NSString*)yes no:(NSString*)no
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    if([yes isEqualToString:@""])
        yes=@"확인";
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:yes
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    
                                    
                                }];
    
    [alert addAction:yesButton];
    
    
    
    if(![no isEqualToString:@""])
    {
        
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:no
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel no, thanks button
                                       
                                   }];
        
        
        [alert addAction:noButton];
    }
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
