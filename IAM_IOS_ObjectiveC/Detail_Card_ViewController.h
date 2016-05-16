//
//  Detail_Card_ViewController.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 11..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"


@interface Detail_Card_ViewController : UIViewController

@property (strong, nonatomic) Client *client;

-(id) init_with_client_info:(Client *)client;
@end
