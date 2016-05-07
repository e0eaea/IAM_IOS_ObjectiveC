//
//  AppDelegate.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "AppDelegate.h"



@interface AppDelegate ()

@property(strong,nonatomic) MyInfo * myinfo;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController* viewController;
    
    
    KOSession *session = [KOSession sharedSession];
    
    if([session isOpen])
    {
        NSLog(@"이미 열려있음!!");
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        viewController = [storyBoard instantiateViewControllerWithIdentifier:@"Main"];
        
        
    }
    else
    {
        
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
        viewController = [storyBoard instantiateViewControllerWithIdentifier:@"Login"];
        
    }
    
    [_window setRootViewController:viewController];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    /*
     if([[KOSession sharedSession] isOpen]) {
     
     NSLog(@"KOSession is alived.");
     [KOSession handleDidBecomeActive];
     }
     
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    
    [self saveContext];
    
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "mobile.IAM_IOS_ObjectiveC" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"IAM_IOS_ObjectiveC" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"IAM_IOS_ObjectiveC.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (UIWindow*)get_window{
    
    return _window;
    
}


- (MyInfo *)getMyInfo {
    
    NSLog(@"here");
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([fetchedObjects count]==0)
        return NULL;
    else
    { MyInfo *myinfo=[fetchedObjects objectAtIndex:0];
        return myinfo;
        
    }
    
}

- (void) saveData:(NSDictionary *)data {     //UserInfo Save
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if([fetchedObjects count]==0)
        _myinfo = (MyInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"MyInfo" inManagedObjectContext:_managedObjectContext];
    
    else
        _myinfo=(MyInfo*)[fetchedObjects objectAtIndex:0];
    
    
    _myinfo.id=[data valueForKey:@"id"];
    _myinfo.nickname=[data valueForKey:@"nickname"];
    
    
    // here's where the actual save happens, and if it doesn't we print something out to the console
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
    NSLog(@"New User : %@", _myinfo);
    
    
}




- (void)connectToServer:(NSString*)jsonString url:(NSString *)urlString {
    
    NSLog(@"ConnectToServer With Json, URL");
    //Formatting the URL
    //NSString *urlAsString = kSend;
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Structuring the URL request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[urlRequest setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    
    //    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest
                                     completionHandler:^(NSData *data,NSURLResponse *response,NSError *connectionError) {
                                         
                                         NSLog(@"받아옴!");
                                         
                                         
                                         
                                         if ([data length] > 0 && connectionError == nil) {
                                             
                                             
                                             NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                             NSError *error;
                                             NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:[html dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                                             
                                             //NSLog(@"diction : %@", diction);
                                             // NSString *method = [diction valueForKey:@"type"];
                                             
                                             
                                             
                                             if (connectionError !=nil){
                                                 
                                                 NSLog(@"Error happened = %@",connectionError);
                                                 
                                             }
                                             
                                             if([urlString isEqualToString:brief_info])
                                                 [_search_delegate response_brief_info:diction];
                                             
                                             
                                             else if([urlString isEqualToString:more_info])
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"more_info"
                                                                                                     object:nil userInfo:diction];
                                             
                                             
                                         }
                                         
                                     }]resume];
    
}

//카카오톡로그인

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([KOSession isKakaoAccountLoginCallback:url])
        return [KOSession handleOpenURL:url];
    
    return NO;
}



- (void) logout
{
    NSLog(@"로그아웃!!");
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    UIViewController* viewController = [storyBoard instantiateViewControllerWithIdentifier:@"Login"];
    [_window setRootViewController:viewController];
    
}


- (void) uploadImageLegacy:(UIImage *)image json:(NSString*)jsonString{
    //upload single image
    NSURL *url = [NSURL URLWithString:card_image_upload];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [request setHTTPMethod:@"POST"];
    NSString *contentTypeValue = [NSString stringWithFormat:@"multipart/form-data; boundary=%s", POST_BODY_BOURDARY];
    [request addValue:contentTypeValue forHTTPHeaderField:@"Content-type"];
    
    NSMutableData *dataForm = [NSMutableData alloc];
    
    
    //image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    [dataForm appendData:[[NSString stringWithFormat:@"\r\n--%s\r\n",POST_BODY_BOURDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataForm appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"picture\"; filename=\"%@.jpg\"\r\n", @"picture"] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataForm appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataForm appendData:[NSData dataWithData:imageData]];
    [dataForm appendData:[[NSString stringWithFormat:@"\r\n--%s--\r\n",POST_BODY_BOURDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //  json
    [dataForm appendData:[[NSString stringWithFormat:@"--%s\r\n", POST_BODY_BOURDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataForm appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@_time\" \r\n\r\n",@"mkmk"] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataForm  appendData:[[NSString stringWithFormat:@"%@", jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataForm  appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [dataForm appendData:[[NSString stringWithFormat:@"--%s--\r\n",POST_BODY_BOURDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:dataForm];
    
    
    
    NSLog(@"리퀘스트는 ");
  
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:(id)self delegateQueue:nil];
    NSURLSessionUploadTask *uploadTask = [urlSession uploadTaskWithRequest:request fromData:dataForm];
    [uploadTask resume];
    
   
    
}



@end
