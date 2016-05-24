//
//  Card+CoreDataProperties.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 18..
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
@property (nonatomic) int16_t card_number;
@property (nullable, nonatomic, retain) NSSet<Image *> *card_images;
@property (nullable, nonatomic, retain) NSOrderedSet<Video *> *card_videos;
@property (nullable, nonatomic, retain) MyInfo *myinfo;
@property (nullable, nonatomic, retain) Other_Info *otherinfo;

@end

@interface Card (CoreDataGeneratedAccessors)

- (void)addCard_imagesObject:(Image *)value;
- (void)removeCard_imagesObject:(Image *)value;
- (void)addCard_images:(NSSet<Image *> *)values;
- (void)removeCard_images:(NSSet<Image *> *)values;

- (void)insertObject:(Video *)value inCard_videosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCard_videosAtIndex:(NSUInteger)idx;
- (void)insertCard_videos:(NSArray<Video *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCard_videosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCard_videosAtIndex:(NSUInteger)idx withObject:(Video *)value;
- (void)replaceCard_videosAtIndexes:(NSIndexSet *)indexes withCard_videos:(NSArray<Video *> *)values;
- (void)addCard_videosObject:(Video *)value;
- (void)removeCard_videosObject:(Video *)value;
- (void)addCard_videos:(NSOrderedSet<Video *> *)values;
- (void)removeCard_videos:(NSOrderedSet<Video *> *)values;

@end

NS_ASSUME_NONNULL_END
