//
//  Card+CoreDataProperties.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 13..
//  Copyright © 2016년 KMK. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *keyword;
@property (nullable, nonatomic, retain) NSData *main_image;
@property (nullable, nonatomic, retain) NSString *nickname;
@property (nullable, nonatomic, retain) NSString *on_off;
@property (nullable, nonatomic, retain) NSString *phone_number;
@property (nullable, nonatomic, retain) NSString *sns_list;
@property (nullable, nonatomic, retain) NSString *status_message;
@property (nullable, nonatomic, retain) NSSet<Image *> *card_images;
@property (nullable, nonatomic, retain) NSSet<Video *> *card_videos;
@property (nullable, nonatomic, retain) MyInfo *myinfo;

@end

@interface Card (CoreDataGeneratedAccessors)

- (void)addCard_imagesObject:(Image *)value;
- (void)removeCard_imagesObject:(Image *)value;
- (void)addCard_images:(NSSet<Image *> *)values;
- (void)removeCard_images:(NSSet<Image *> *)values;

- (void)addCard_videosObject:(Video *)value;
- (void)removeCard_videosObject:(Video *)value;
- (void)addCard_videos:(NSSet<Video *> *)values;
- (void)removeCard_videos:(NSSet<Video *> *)values;

@end

NS_ASSUME_NONNULL_END
