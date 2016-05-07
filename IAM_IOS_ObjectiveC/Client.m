//
//  Client.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 3..
//  Copyright © 2016년 KMK. All rights reserved.
//


#import "Client.h"

@implementation Client

- (id) initWithClientID:(NSString*)client_id
{
    self = [super init];
    
    _id=client_id;
    _usebit= 2; //유즈비트 2로 설정
    _status=false;
    
    return self;
}

//서버에 정보요청!
+ (void) request_brief_info:(NSString *)id
{
    NSArray *dictionKeys = @[@"id"];
    NSArray *dictionVals = @[id];
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    
    NSString *userJsonData = [Common_modules transToJson:client_data];
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(connectToServer:url:) withObject:userJsonData withObject:brief_info];
    
}


//서버에 자세한요청!
+ (void) request_more_info:(NSString *)id
{
    NSArray *dictionKeys = @[@"id"];
    NSArray *dictionVals = @[id];
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    
    NSString *userJsonData = [Common_modules transToJson:client_data];
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(connectToServer:url:) withObject:userJsonData withObject:more_info];
    
    
}




@end
