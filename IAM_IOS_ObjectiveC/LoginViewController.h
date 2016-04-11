//
//  LoginViewController.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 7..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MyInfo.h"

@interface LoginViewController : UIViewController

@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;


@property (nonatomic, retain) UIActivityIndicatorView *registrationProgressing;



@end
