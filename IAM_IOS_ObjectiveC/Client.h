//
//  Client.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 3..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject


@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* base64_image;

-(void)init:(NSString *)id;


@end
