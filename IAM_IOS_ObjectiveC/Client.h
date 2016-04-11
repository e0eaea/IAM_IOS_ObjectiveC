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
#import "Common_Module.h"

@interface Client : NSObject


@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSData* base64_image;

+ (void) request_brief_info:(NSString *)id;


@end
