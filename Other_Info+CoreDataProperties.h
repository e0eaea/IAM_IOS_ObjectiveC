//
//  Other_Info+CoreDataProperties.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 18..
//  Copyright © 2016년 KMK. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Other_Info.h"

NS_ASSUME_NONNULL_BEGIN

@interface Other_Info (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nonatomic) int16_t index;
@property (nullable, nonatomic, retain) MyInfo *myinfo;
@property (nullable, nonatomic, retain) NSSet<Card *> *other_cards;

@end

@interface Other_Info (CoreDataGeneratedAccessors)

- (void)addOther_cardsObject:(Card *)value;
- (void)removeOther_cardsObject:(Card *)value;
- (void)addOther_cards:(NSSet<Card *> *)values;
- (void)removeOther_cards:(NSSet<Card *> *)values;

@end

NS_ASSUME_NONNULL_END
