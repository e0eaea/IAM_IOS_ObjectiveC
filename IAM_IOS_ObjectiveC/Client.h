//
//  Client.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 3..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Base64.h"
#import "AppDelegate.h"
#import "Common_Modules.h"
#import "MyInfo.h"
#import "Card.h"

@interface Client : NSObject


@property (nonatomic) bool status;
@property (strong, nonatomic) MyInfo * myinfo;
@property (strong, nonatomic) Card * card;
@property (strong, nonatomic) NSString* id;

@property (nonatomic) int usebit;

- (id) initWithClientID:(NSString*)client_id;

+ (void) request_random_info:(NSString *)id;

+ (void) request_interest_info:(NSString *)id keyword:(NSMutableArray*)keyword;

+ (void) request_more_info:(NSString *)id card_number:(NSString*)card_number;

@end
