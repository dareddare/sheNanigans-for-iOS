//
//  Nanigans.h
//  StariKocijas
//
//  Created by Darko Pavlovic on 2/25/13.
//  Copyright (c) 2013 Nordeus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NanigansTrackerProtocol.h"

typedef enum {
	NO_TRACKER = 0,
	SIMPLE_TRACKER
} TrackerType;

@interface Nanigans : NSObject

// Class method that returns singleton object
+ (Nanigans*)trackers;

// Class method that returns currently active tracker
+ (NSObject<NanigansTrackerProtocol>*)activeTracker;

// Instance method that clears tracker info
- (void)clear;

// Property that says the tracker type
@property (nonatomic, assign) TrackerType trackerType;

// Instance method that returns currently active tracker
- (NSObject<NanigansTrackerProtocol>*)activeTracker;

@end
