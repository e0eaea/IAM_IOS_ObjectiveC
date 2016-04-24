//
//  Card+CoreDataProperties.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 24..
//  Copyright © 2016년 KMK. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *nickname;
@property (nullable, nonatomic, retain) NSString *phone_number;
@property (nullable, nonatomic, retain) NSString *introduction;
@property (nullable, nonatomic, retain) NSData *video;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *keyword;

@end

NS_ASSUME_NONNULL_END
