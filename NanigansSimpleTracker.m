//
//  NanigansSimpleTracker.m
//  StariKocijas
//
//  Created by Darko Pavlovic on 2/25/13.
//  Copyright (c) 2013 Nordeus. All rights reserved.
//

#import "NanigansSimpleTracker.h"
#import "NanigansUtil.h"

#define EVENT_REQUEST_TIMEOUT_VALUE 15.0

@interface NanigansSimpleTracker ()

// Collection that contains default parameters that should be sent with all events
@property (nonatomic, retain) NSDictionary* defaultParameters;

// Mehtod that tracks events in background
- (void)trackInBackground:(NSString*)eventUrl;

@end

@implementation NanigansSimpleTracker

- (void)dealloc {
	self.defaultParameters = nil;
	[super dealloc];
}

#pragma mark - NanigansTrackerProtocol methods

/**
 * Creates event url and tracks the event in background.
 * @param eventType Type of the event that should be tracked.
 * @param eventName Name of the event that should be tracked.
 * @param parameters Parameters that should be added to the event.
 */
- (void)trackEventOfType:(NSString*)eventType eventName:(NSString*)eventName withParameters:(NSDictionary*)parameters {
	// Create parameters for the event. The parameters are created as union of given parameters and default parameters that are sent with every event
	NSDictionary* allParameters = nil;
	if (self.defaultParameters == nil) {
		// There are no default parameters
		allParameters = parameters;
	}
	else if (parameters == nil) {
		// There are no other parameters
		allParameters = self.defaultParameters;
	}
	else {
		// Parameters should be union of two parameters collection
		NSMutableDictionary* mutableParametersCollection = [NSMutableDictionary dictionary];
		[mutableParametersCollection addEntriesFromDictionary:self.defaultParameters];
		[mutableParametersCollection addEntriesFromDictionary:parameters];
		allParameters = mutableParametersCollection;
	}
		
	// Create event url
	NSString* eventUrl = [NanigansUtil urlForEventType:eventType eventName:eventName andParameters:allParameters];
	
	// Track the event in background
	if (eventUrl != nil) {
		[self performSelectorInBackground:@selector(trackInBackground:) withObject:eventUrl];
	}
}

/**
 * Sets parameters that should be sent with every event.
 * @param parameters Parameters that should be sent with every event.
 */
- (void)setEventDefaultParameters:(NSDictionary*)parameters {
	self.defaultParameters = parameters;
}

#pragma mark - Helper methods

/**
 * Tracks the event.
 * @param event Event that should be tracked.
 */
- (void)trackInBackground:(NSString*)eventUrl {
	// Create autorelease pool
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
	// Create the request
	NSURLRequest* eventRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:eventUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:EVENT_REQUEST_TIMEOUT_VALUE];
	
	// Create the connection.
	// There is no need for remembering the connection, because it is not used later.
	[NSURLConnection connectionWithRequest:eventRequest delegate:nil];
	
	// Drain the pool
	[pool drain];
}

@end
