//
//  SetPropertiesRequest.m
//  Analytics
//
//  Created by User on 12/22/16.
//  Copyright © 2016 Gravitum. All rights reserved.
//

#import "SetPropertiesRequest.h"
#import "Analytics.h"

@implementation SetPropertiesRequest

NSString *const SetCustomFieldsId = @"SetCustomFields";

-(id)initWithProperties:(NSDictionary<NSString *, NSObject *> *)newProperties {
	self = [super initWithString:SetCustomFieldsId];
	properties = [[NSMutableDictionary<NSString*,NSObject*> alloc] init];

	properties = newProperties;

	_cacheable = YES;
	_authRequired = YES;
	return self;
}


-(NSDictionary<NSString *, NSObject *> *)GenerateData{
	NSMutableDictionary<NSString*, NSObject *> * OriginalJSON = [[NSMutableDictionary<NSString*, NSObject *> alloc] init];
	
	Analytics * analytics = [[Analytics getAnalytics] init];
	
	[OriginalJSON setValue: [analytics getUserServerId] forKey:@"user"];
	[OriginalJSON setValue: properties forKey:@"fields"];

	if([[Settings getSettings] DebugLogs])
		NSLog(@"Generating data for SetPushTokenRequest: %@", OriginalJSON);
	
	return OriginalJSON;
}

-(bool) AuthenticationRequired{
	return _authRequired;
}

@end
