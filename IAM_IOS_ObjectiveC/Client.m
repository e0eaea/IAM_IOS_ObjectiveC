//
//  Client.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 3..
//  Copyright © 2016년 KMK. All rights reserved.
//


#import "Client.h"

@interface Client()
@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;
@end

@implementation Client


- (id) initWithClientID:(NSString*)client_id
{
    self = [super init];
    
    
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    _card=(Card*)[NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:_managedObjectContext];
    
    _id=client_id;
    _usebit= 2; //유즈비트 2로 설정
    _status=false;
    
    return self;
}

//서버에 랜덤으로 정보요청!!!
+ (void) request_random_info:(NSString *)id
{
    NSArray *dictionKeys = @[@"id"];
    NSArray *dictionVals = @[id];
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    
    NSString *userJsonData = [Common_modules transToJson:client_data];
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(connectToServer:url:) withObject:userJsonData withObject:random_info];
    
    
}

//서버에 관심사으로 정보요청!
+ (void) request_interest_info:(NSString *)id keyword:(NSMutableArray*)keyword
{
    NSArray *dictionKeys = @[@"id",@"keyword"];
    NSArray *dictionVals = @[id,keyword];
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    
    NSString *userJsonData = [Common_modules transToJson:client_data];
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(connectToServer:url:) withObject:userJsonData withObject:interest_info];
    
}


//서버에 자세한요청!
+ (void) request_more_info:(NSString *)id card_number:(NSString*)card_number
{
    NSArray *dictionKeys = @[@"id",@"card_number"];
    NSArray *dictionVals = @[id,card_number];
    NSDictionary *client_data = [NSDictionary dictionaryWithObjects:dictionVals forKeys:dictionKeys];
    
    
    NSString *userJsonData = [Common_modules transToJson:client_data];
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(connectToServer:url:) withObject:userJsonData withObject:download_card];
    
    
}




@end
