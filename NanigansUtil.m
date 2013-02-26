//
//  NanigansUtil.m
//  StariKocijas
//
//  Created by Darko Pavlovic on 2/25/13.
//  Copyright (c) 2013 Nordeus. All rights reserved.
//

#import "NanigansUtil.h"

@implementation NanigansUtil

/**
 * Creates url for the event.
 * @param eventType Type of the event for which url should be created.
 * @param eventName Name of the event for which url should be created.
 * @param parameters Parameters that should be added to the event.
 */
+ (NSString*)urlForEventType:(NSString*)eventType eventName:(NSString*)eventName andParameters:(NSDictionary*)parameters {
	if ((eventType == nil) || ([eventType length] == 0)) {
		return nil;
	}
	if ((eventName == nil) || ([eventName length] == 0)) {
		return nil;
	}
	
#warning implement this
	return [NSString stringWithFormat:@"http://192.168.69.237:8888/nantest.php?eventType=%@&eventName=%@", eventType, eventName];
}

@end
