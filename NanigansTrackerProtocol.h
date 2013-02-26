//
//  NanigansTrackerProtocol.h
//  StariKocijas
//
//  Created by Darko Pavlovic on 2/25/13.
//  Copyright (c) 2013 Nordeus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NanigansTrackerProtocol <NSObject>

@required

// Method that is called when event should be tracked
- (void)trackEventOfType:(NSString*)eventType eventName:(NSString*)eventName withParameters:(NSDictionary*)parameters;

@optional

// Method that sets parameters that should be sent with every event
- (void)setEventDefaultParameters:(NSDictionary*)parameters;

@end
