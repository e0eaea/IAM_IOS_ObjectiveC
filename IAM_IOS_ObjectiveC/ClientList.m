//
//  ClientList.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 3..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "ClientList.h"
#import "Client.h"

@implementation ClientList

-(id)init
{
    _client_list=[[NSDictionary alloc]init];
    return self;
}


-(void)addClient:(Client *)new_client
{
    [_client_list setValue:new_client forKey:new_client.id];
}

@end
