//
//  Video+CoreDataProperties.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 6..
//  Copyright © 2016년 KMK. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Video.h"

NS_ASSUME_NONNULL_BEGIN

@interface Video (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *video;
@property (nullable, nonatomic, retain) Card *card;

@end

NS_ASSUME_NONNULL_END
