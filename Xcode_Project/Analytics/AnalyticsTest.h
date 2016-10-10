#import <Foundation/Foundation.h>
#import "SessionManager.h"
#import "WebServer.h"
#import "Analytics.h"
#import "Settings.h"

@interface AnalyticsTest : NSObject{}

+(void)SendTestEvent;
+(void)SendTestMonetaryEvent;
+(void)FillDataAndStartSession;
+(void)SendSessionStopRequest;
+(void)SendSessionStartRequest;
+(void)SetOfflineMode;
+(void)SetOnLineMode;
@end
