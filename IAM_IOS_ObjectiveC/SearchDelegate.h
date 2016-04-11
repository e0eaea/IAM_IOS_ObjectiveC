//
//  SearchDelegate.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 9..
//  Copyright © 2016년 KMK. All rights reserved.
//

#ifndef SearchDelegate_h
#define SearchDelegate_h


#import <UIKit/UIKit.h>

@protocol SearchDelegate

- (void) response_brief_info:(NSDictionary *)info;

@end

#endif /* SearchDelegate_h */
