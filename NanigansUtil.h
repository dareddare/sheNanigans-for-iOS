//
//  NanigansUtil.h
//  StariKocijas
//
//  Created by Darko Pavlovic on 2/25/13.
//  Copyright (c) 2013 Nordeus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NanigansUtil : NSObject

// Method tat returns url for given event
+ (NSString*)urlForEventType:(NSString*)eventType eventName:(NSString*)eventName andParameters:(NSDictionary*)parameters;

@end
