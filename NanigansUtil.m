//
//  NanigansUtil.m
//  StariKocijas
//
//  Created by Darko Pavlovic on 2/25/13.
//  Copyright (c) 2013 Nordeus. All rights reserved.
//

#import "NanigansUtil.h"
#import "NanigansConfig.h"

@interface NanigansUtil ()

+ (BOOL)attributionIdNeededForThePixelType:(NSString*)pixelType;

@end

static NSSet* fbAttributionIdNeededPixels = nil;

@implementation NanigansUtil

/**
 * Creates url for the event.
 * @param eventType Type of the event for which url should be created.
 * @param eventName Name of the event for which url should be created.
 * @param parameters Parameters that should be added to the event.
 */
+ (NSString*)urlForEventType:(NSString*)eventType eventName:(NSString*)eventName andParameters:(NSDictionary*)parameters {
	// Check if event descriptors are valid
	if ((eventType == nil) || ([eventType length] == 0)) {
		return nil;
	}
	if ((eventName == nil) || ([eventName length] == 0)) {
		return nil;
	}
	
	// Create parameters which will be used for url to be created
	NSMutableDictionary* allEventParameters = [NSMutableDictionary dictionary];
	
	// Add parameters (for insctance. this could be user id or fb app id)
	if (parameters != nil) {
		[allEventParameters addEntriesFromDictionary:parameters];
	}
	
	// Add event descriptors
	allEventParameters[@"type"] = eventType;
	allEventParameters[@"name"] = eventName;
	
	// Add attribution id from pasteboard
#warning check if user should have attribution id
	NSString* attributionId = nil;
	if ([self attributionIdNeededForThePixelType:eventType]) {
		// Get pasteboard
		UIPasteboard* pasteBoard = [UIPasteboard pasteboardWithName:@"fb_app_attribution" create:false];
		if (pasteBoard == nil) {
			return nil;
		}
		
		// Get attribution id
		attributionId = pasteBoard.string;
		if ((attributionId == nil) || ([attributionId length] == 0)) {
			return nil;
		}
	}
	if (attributionId != nil) {
		allEventParameters[@"fb_attr_id"] = attributionId;
	}
	
	// Add unique user id
	CFUUIDRef uniqueUserId = CFUUIDCreate(NULL);
	NSString* uniqueUserIdString = (NSString*)CFUUIDCreateString(NULL, uniqueUserId);
	CFRelease(uniqueUserId);
	uniqueUserIdString = [[uniqueUserIdString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
	if (uniqueUserIdString != nil) {
		allEventParameters[@"unique"] = uniqueUserIdString;
	}
		
	// Create get parameters
	NSMutableString* getParameters = [@"" mutableCopy];
	for (NSInteger i = 0; i < [[allEventParameters allKeys] count]; i++) {
		NSString* key = [allEventParameters allKeys][i];
		NSString* value = allEventParameters[key];
		value = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, NULL, (CFStringRef)@":!*();@/&?#[]+$,='%’\"", kCFStringEncodingUTF8);
		
		if (i == 0) {
			[getParameters appendString:[NSString stringWithFormat:@"%@=%@", key, value]];
		}
		else {
			[getParameters appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
		}
	}
	
	// Create url using get prameters and script url
	NSMutableString* scriptUrl = [@"http://192.168.69.237:8888/nantest.php" mutableCopy];
	if ([getParameters length] > 0) {
		[scriptUrl appendString:[NSString stringWithFormat:@"?%@", getParameters]];
	}
	
	return scriptUrl;
}

/**
 * Checks if fb attribution id is needed for this pixel.
 * @param pixelType Type of the event for which it should be checked if attribution id is needed.
 * @return Whether or not attribution id is needed for the pixel.
 */
+ (BOOL)attributionIdNeededForThePixelType:(NSString*)pixelType {
	if (fbAttributionIdNeededPixels == nil) {
		fbAttributionIdNeededPixels = [[NSSet setWithObjects:NANIGANS_PIXELS_WITH_FB_ATTRIBUTION_ID, nil] retain];
	}
	return [fbAttributionIdNeededPixels containsObject:[pixelType lowercaseString]];
}

@end
