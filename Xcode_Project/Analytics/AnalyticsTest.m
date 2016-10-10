#import "AnalyticsTest.h"

@implementation AnalyticsTest



+(void)FillDataAndStartSession{
    
    NSString * AppToken = @"c645af3355ab53234d1d1a1468e956fd";
    NSString * AppSecret = @"c686a7321bb0c068bc04dc3412ed7f9616d9d21533d5f82b0810ec5901cc3c5b";
    NSString * SenderId = @"";
    
    Analytics * analytics = [[Analytics getAnalytics] initWithParameters:AppToken AppSecret:AppSecret SenderId:SenderId];
    [analytics SetUserId:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    [analytics SetUserName:@"GesicaAlba"];
    [analytics SetGender:(Gender*)Male];
    [analytics SetBirthday:12 monthBorn:02 yearBorn:1987];
    [analytics Init];
    
    [[Analytics getAnalytics] SendEvent ]
    
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(SetOfflineMode)
                                   userInfo:nil
                                    repeats:NO];

    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(SendTestEvent)
                                   userInfo:nil
                                    repeats:NO];

    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(SendTestMonetaryEvent)
                                   userInfo:nil
                                    repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:4
                                     target:self
                                   selector:@selector(SetOnLineMode)
                                   userInfo:nil
                                    repeats:NO];
    
    
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(SendSessionStopRequest)
                                   userInfo:nil
                                    repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:6
                                     target:self
                                   selector:@selector(SendSessionStartRequest)
                                   userInfo:nil
                                    repeats:NO];
    
    
     [NSTimer scheduledTimerWithTimeInterval:15
                                      target:self
                                    selector:@selector(SendTestEvent)
                                    userInfo:nil
                                     repeats:NO];
}

+(void)SendTestEvent{
    NSLog(@"Sending Test Event");
    NSMutableDictionary<NSString*,NSObject*>* eventData = [[NSMutableDictionary<NSString*,NSObject*> alloc] init];
    [eventData setValue:@"string_data" forKey:@"custom_string_data"];
    [eventData setValue:[NSNumber numberWithInteger:10101] forKey:@"custom_int_data"];
    Analytics * analytics = [Analytics getAnalytics];
    [analytics SendEvent:@"sample_event" data:eventData];

}

+(void)SendTestMonetaryEvent{
    NSLog(@"Sending Test Monetary Event");
    
    [[Analytics getAnalytics] SendMonetaryEvent:@"coins" price:0.99 currency:@"USD"];
}

+(void)SendSessionStopRequest{
    [[Analytics getAnalytics] SessionEnd];
}
+(void)SendSessionStartRequest{
    [[Analytics getAnalytics] SessionStart];
}
+(void)SetOfflineMode{[[WebServer getWebServer]SetOfflineMode:YES];}
+(void)SetOnLineMode{[[WebServer getWebServer]SetOfflineMode:NO];}

@end
