#import <Foundation/Foundation.h>
#import "SessionManager.h"
#import "Settings.h"
@interface SessionManager()
{
    
}



@end

@implementation SessionManager




+(SessionManager *) getManager{
    static SessionManager* theSingleton = nil;
    
    if (theSingleton  == nil)
    {
        theSingleton = [[SessionManager alloc] init];
    }
    if([theSingleton  sessionId] == nil)
        [theSingleton setSessionId:UndefinedSession];
    return theSingleton;}


NSString *const UndefinedSession = @"UNDEFINED_SESSION";




-(void)Init{
    if([[Settings getSettings] DebugLogs])
        NSLog(@"Init");
    sessionId_ = UndefinedSession;
}

//SETTER
-(NSString *)sessionId{
    return sessionId_;
}
//GETTER
-(void)setSessionId:(NSString *)sessionId{
    sessionId_ = sessionId;
}



-(void)dealloc{
    sessionId_ = nil;
}

-(BOOL)isSessionUndefined{
    return ([sessionId_ isEqualToString: UndefinedSession] || [sessionId_ isEqualToString: @""] );
}

@end