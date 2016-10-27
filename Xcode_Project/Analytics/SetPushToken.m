//
//  SetPushToken.m
//  app-preview
//
//  Created by Dmitry Yerchick on 10/18/16.
//  Copyright © 2016 Yerchick. All rights reserved.
//

#import "SetPushToken.h"
#import "Analytics.h"

@implementation SetPushToken

NSString *const SetPushTockenPackId = @"SetPushToken";

-(id)initWithString:(NSString *)token{
    self = [super initWithString:SetPushTockenPackId];
    
    _token = token;
    _cacheable = NO;
    return self;
}


-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData{
    NSMutableDictionary<NSString*, NSObject *> * OriginalJSON = [[NSMutableDictionary<NSString*, NSObject *> alloc] init];
    
    Analytics * analytics = [[Analytics getAnalytics] init];
   // SessionManager * sm = [[SessionManager getManager] init];
    
    
    [OriginalJSON setValue:[analytics getUserServerId] forKey:@"user"];
    [OriginalJSON setValue: _token forKey:@"device_push_token"];

    if([[Settings getSettings] DebugLogs])
        NSLog(@"Generating data for SetPushTokenRequest: %@", OriginalJSON);
    return OriginalJSON;
}

-(bool) AuthenticationRequired{
    return true;
}



@end
