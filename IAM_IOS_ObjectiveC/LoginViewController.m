//
//  LoginViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 7..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "LoginViewController.h"
#import <sys/utsname.h>
#import "Common_Modules.h"
#import "MainViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *next_button;
@property (strong, nonatomic) IBOutlet UITextField *name_field;
@property(strong, nonatomic) MyInfo * myinfo;
@property(strong,nonatomic) UIWindow * window;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    
    _window=[[[UIApplication sharedApplication] delegate]window];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next_click:(id)sender {
    
    if([_name_field.text isEqualToString:@""])
    {
        [Common_modules alert_show:self title:@"" message:@"이름을 입력하시오" yes:@"" no:@""];
    }
    //아이디가 있는 것인지 데이터베이스,서버에서 확인
    else{
        
        [self load_user_info:_name_field.text];
        
    
        
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController* viewController = [storyBoard instantiateViewControllerWithIdentifier:@"Main"];
        [_window setRootViewController:viewController];


        
    
    }
    
}

//데이터베이스에 유저정보 있나 확인!  (회원가입생기면 변경해야할 부분!!!!)
- (BOOL) load_user_info:(NSString*)id {
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([fetchedObjects count]!=0)
    {
    
    NSManagedObject *info= [fetchedObjects objectAtIndex:0];
    
   
        //기존 아이디
        if([[info valueForKey:@"id"] isEqualToString:id]) {
            NSLog(@"Already erolled user : %@", info);
            _myinfo = (MyInfo *)info;
            
             [Common_modules alert_show:self title:@"" message:@"기존 아이디!" yes:@"" no:@""];
            return true;
        }
    
        //기존 아이디가 아니다.
        else{
            
            _myinfo = (MyInfo *)info;
            _myinfo.id=id;
            
            NSError *error;
            
            // here's where the actual save happens, and if it doesn't we print something out to the console
            if (![_managedObjectContext save:&error])
            {
                NSLog(@"Problem saving: %@", [error localizedDescription]);
            }
            NSLog(@"Changing user : %@", _myinfo);
            
            [Common_modules alert_show:self title:@"" message:@"아이디 변경!" yes:@"" no:@""];
            
            return true;
            
            }
        
    }
    
    
    //기존에 아무것도 없는 경우
    else{
    
        
    NSArray *dictionKeys = @[@"type", @"id"];
    NSArray *dictionVals = @[@"login", id ];
    NSDictionary *MyData = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    [self saveData:MyData];
        
        
    [Common_modules alert_show:self title:@"" message:@"새로운 로그인!" yes:@"" no:@""];
    
    return false;
    }
    
}


//키보드 내리기
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // UITouch *touch = [[event allTouches] anyObject];
    
    [_name_field resignFirstResponder];
    
}



- (void) saveData:(NSDictionary *)data {     //UserInfo Save
    
    _myinfo = (MyInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"MyInfo" inManagedObjectContext:_managedObjectContext];
    _myinfo.id=[data valueForKey:@"id"];
    
    
    NSError *error;
    
    // here's where the actual save happens, and if it doesn't we print something out to the console
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
    NSLog(@"New User : %@", _myinfo);
    
    
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
