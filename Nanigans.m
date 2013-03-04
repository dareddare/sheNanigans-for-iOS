//
//  Nanigans.m
//  StariKocijas
//
//  Created by Darko Pavlovic on 2/25/13.
//  Copyright (c) 2013 Nordeus. All rights reserved.
//

#import "Nanigans.h"
#import "NanigansSimpleTracker.h"

@interface Nanigans ()

// Lock object used for synchronization
@property (nonatomic, retain) NSObject* trackersLock;

// Collection holding all the trackers
@property (nonatomic, retain) NSMutableDictionary* trackers;

// Instance method that returns currently active tracker
- (NSObject<NanigansTrackerProtocol>*)activeTracker;

// Checks if tracker is valid.
- (BOOL)trackerIsValid;

@end

@implementation Nanigans

#pragma mark - Memory management

/**
 * Initializes Nanigans object.
 *
 * @return A Nanigans object.
 */
- (id)init {
	self = [super init];
	if (self) {
		
		// Create lock object for synchronizing acces to the trackers collection
		self.trackersLock = [[[NSObject alloc] init] autorelease];
		
		// Create collection where trackers will be stored
		self.trackers = [NSMutableDictionary dictionary];
		
	}
	return self;
}

/**
 * Clears all Nanigans trackers.
 */
- (void)clear {
	@synchronized(self.trackersLock) {
		// Clear trackers
		[self.trackers removeAllObjects];
		
		// Clear the trackers type
		_trackerType = NO_TRACKER;
	}
}

#pragma mark - Properties

- (void)setTrackerType:(TrackerType)trackerType {
	@synchronized(self.trackersLock) {
		_trackerType = trackerType;
	}
}

#pragma mark - Other methods

/**
 * Returns active tracker. If the tracker does not exist but tracker type is set, it creates the tracker and adds it to the collection.
 * @return Active tracker.
 */
+ (NSObject<NanigansTrackerProtocol>*)activeTracker {
	return [[self trackers] activeTracker];
}

/**
 * Returns active tracker. If the tracker does not exist but tracker type is set, it creates the tracker and adds it to the collection.
 * @return Active tracker.
 */
- (NSObject<NanigansTrackerProtocol>*)activeTracker {
	// Check if valid tracker has been set before
	if (![self trackerIsValid]) {
		return nil;
	}
	
	// Get the tracker
	NSObject<NanigansTrackerProtocol>* tracker = nil;
	@synchronized(self.trackersLock) {
		
		// Try to read it from the trackers collection
		tracker = self.trackers[@(_trackerType)];
		
		// If reading has failed, create tracker and add it to the collection
		if (tracker == nil) {
			if (_trackerType == SIMPLE_TRACKER) {
				tracker = [[[NanigansSimpleTracker alloc] init] autorelease];
			}
			if ((tracker != nil) && (_trackerType != NO_TRACKER)) {
				self.trackers[@(_trackerType)] = tracker;
			}
		}
	}
	
	// Return it
	return tracker;
	
}

#pragma mark - Helper method

/**
 * Checks if current tracker is valid.
 * @return Returns whether or not the active tracker is valid.
 */
- (BOOL)trackerIsValid {
	@synchronized(self.trackersLock) {
		return (_trackerType == SIMPLE_TRACKER);
	}
}

#pragma mark - Singleton implementation

static Nanigans* trackers = nil;

/**
 * Singleton factory method. This is the only way an instance of the singleton class can be created.
 *
 * @return A singleton object instance.
 */
+ (Nanigans*)trackers {
	@synchronized(self) {
		if (!trackers) {
			// Create the instance
			trackers = [[super allocWithZone:nil] init];
		}
	}
	
	return trackers;
}

+ (id)allocWithZone:(NSZone*)zone {
	return [[self trackers] retain];
}

- (id)copyWithZone:(NSZone *)zone {
	// No copying is allowed
	return self;
}

- (id)retain {
	return self;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

- (oneway void)release {
	
}

- (id)autorelease {
	return self;
}

@end
