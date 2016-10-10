#import <Foundation/Foundation.h>
#import "SessionManager.h"
#import "BaseRequest.h"
#import "ServerRequest.h"
#import "Enums.h"
#import "Settings.h"


@interface WebServer : NSObject
{
    NSMutableArray * DelayedPackages;
    bool _isOfflineMode;
}

-(void)Send :(BaseRequest *)package;

-(NSString *)WEBSERVER_LOG_HEADER;

+(WebServer * )getWebServer;

-(int32_t)CurrentTimeStamp;

-(void)SendDelayedPackages;

-(void)FlushCachedRequests;
-(void)LoadCachedRequests;
-(void)SetOfflineMode :(bool)Bool;
-(bool)isOflineMode;
@end



