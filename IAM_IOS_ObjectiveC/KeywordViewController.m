//
//  KeywordViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 15..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "KeywordViewController.h"

@interface KeywordViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *s_buttons;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic,strong) NSMutableArray* select_keyword;

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
    
}

- (void) set_keyword:(NSString *) keywords
{
    _select_keyword=[[NSMutableArray alloc]init];
    
    if(![keywords isEqualToString:@"null"])
    {
       NSArray *s=[keywords componentsSeparatedByString:@" "];
       [_select_keyword arrayByAddingObjectsFromArray:s];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)keyword_selected:(UIButton*) sender {
   
        
    UIButton *button = (UIButton*)sender;
    NSString* title = button.titleLabel.text;
    
    if([sender tag]==0 && [_select_keyword count]<5)
    {
        
        [_select_keyword addObject:title];
        
        [button setBackgroundImage:[UIImage imageNamed:@"keyword.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTag:1];
            
          
    }
    
    else if([sender tag]==1 && [_select_keyword count]>0){

        for(int i=0; i<[_select_keyword count]; i++)
            {
                NSString *s=[_select_keyword objectAtIndex:i];
                if([title isEqualToString:s])
                    [_select_keyword removeObjectAtIndex:i];
            }
        
        [button setBackgroundImage:[UIImage imageNamed:@"keyword-bg-unselected.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
