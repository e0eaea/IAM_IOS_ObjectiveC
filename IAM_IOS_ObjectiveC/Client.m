//
//  Client.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 3..
//  Copyright © 2016년 KMK. All rights reserved.
//


#import "Client.h"

@implementation Client

//서버에 정보요청!
+ (void) request_brief_info:(NSString *)id
{
    NSArray *dictionKeys = @[@"id"];
    NSArray *dictionVals = @[id];
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    
    NSString *userJsonData = [Common_Module transToJson:client_data];
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(connectToServer:url:) withObject:userJsonData withObject:brief_info];
    
}





@end
