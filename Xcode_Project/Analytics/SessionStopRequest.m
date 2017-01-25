#import "SessionStopRequest.h"
#import "Settings.h"

@interface SessionStopRequest(){};

@end




@implementation SessionStopRequest


NSString *const StopPackId = @"StopSession";


-(id)init{
    return [super initWithString:StopPackId];
}

-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData{
    NSMutableDictionary<NSString*, NSObject *> * OriginalJSON = [[NSMutableDictionary<NSString*, NSObject *> alloc] init];
    SessionManager * sm = [[SessionManager getManager] init];
    [OriginalJSON setValue: [sm sessionId] forKey:@"session"];
    if([[Settings getSettings] DebugLogs])
        NSLog(@"%@",[NSString stringWithFormat:@"Generating data from sessionStopRequest: %@, %@", [sm sessionId], @"session"]);
    return OriginalJSON;
}

-(bool) AuthenticationRequired{
    return false;
}

@end
