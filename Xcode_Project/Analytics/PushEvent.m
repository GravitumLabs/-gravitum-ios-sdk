//
//  PushEvent.m
//  app-preview
//
//  Created by User on 10/19/16.
//  Copyright © 2016 Yerchick. All rights reserved.
//

#import "PushEvent.h"
#import "Settings.h"
#import "Analytics.h"

@implementation PushEvent

  NSString *const PushEventId = @"PushEvent";

-(id)initWithString:(int )_Id type:(int )type{
	self = [super initWithString:PushEventId];
	_id = _Id;
	_type = type;
	_cacheable = YES;
	_authRequired = TRUE;
	return self;
}


-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData{
	NSMutableDictionary<NSString*, NSObject *> * OriginalJSON = [[NSMutableDictionary<NSString*, NSObject *> alloc] init];
	
	
	
	[OriginalJSON setValue: [NSNumber numberWithInt:_id] forKey:@"push_id"];
	[OriginalJSON setValue: [NSNumber numberWithInt:_type] forKey:@"event"];
	if([[Analytics getAnalytics] getUserServerId] != nil){
		[OriginalJSON setObject:[[Analytics getAnalytics] getUserServerId] forKey:@"user"];
	}
	

	
	
	if([[Settings getSettings] DebugLogs])
		NSLog(@"Generating data for PushEvent: %@", OriginalJSON);
	return OriginalJSON;
}

//-(bool) AuthenticationRequired{
//	return true;
//}

@end
