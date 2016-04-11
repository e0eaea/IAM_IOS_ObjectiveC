//
//  AppDelegate.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MyInfo.h"
#import "Server_address.h"
#import "SearchDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,assign) id <SearchDelegate> search_delegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)connectToServer:(NSString*)jsonString url:(NSString *)urlString;


@end

