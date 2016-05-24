//
//  MyCardViewController.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 1..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define NAME_PLACEHOLDER @"이름을 입력하세요"
#define PHONE_PLACEHOLDER @"핸드폰 번호를 입력하세요"
#define STATUS_PLACEHOLDER @"상태메세지를 입력하세요"
#define FB_PLACEHOLDER @"페이스북을 연동"
#define TW_PLACEHOLDER @"트위터 연동"


@interface MyCardViewController : UIViewController

- (void) new_card_create:(MyInfo*) info card_num:(int)card_num;
- (void) setting_exist_card:(Card*) card;

@end
