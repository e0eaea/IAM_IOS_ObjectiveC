//
//  MyInfo+CoreDataProperties.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 24..
//  Copyright © 2016년 KMK. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *nickname;
@property (nullable, nonatomic, retain) NSSet<Card *> *mycards;

@end

@interface MyInfo (CoreDataGeneratedAccessors)

- (void)addMycardsObject:(Card *)value;
- (void)removeMycardsObject:(Card *)value;
- (void)addMycards:(NSSet<Card *> *)values;
- (void)removeMycards:(NSSet<Card *> *)values;

@end

NS_ASSUME_NONNULL_END
