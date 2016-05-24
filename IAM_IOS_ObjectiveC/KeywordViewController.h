//
//  KeywordViewController.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 15..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "MyInfo.h"


@interface KeywordViewController : UIViewController

- (void) set_keyword:(Card*) card;
- (void) set_search_keyword:(MyInfo *) myinfo;

@end
