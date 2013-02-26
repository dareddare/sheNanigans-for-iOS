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
 * @param event Event for which url should be created.
 * @param parameters Parameters that should be added to the event
 * @param 
 */
+ (NSString*)urlForEvent:(NSString*)event andParameters:(NSDictionary*)parameters {
	return @"http://192.168.69.237:8888/nantest.php?darko=MOBILE&nesto=MOBILE&attempt=1";
}

@end
