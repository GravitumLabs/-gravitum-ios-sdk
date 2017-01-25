#import "SessionStartRequest.h"


@interface SessionStartRequest(){
    
};

@end



@implementation SessionStartRequest
NSString *const StartPackId = @"StartSession";


-(id)init{
    return [super initWithString:StartPackId];
}


-(bool) AuthenticationRequired{
    return false;
}



-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData{
    NSMutableDictionary<NSString*, NSObject *> * OriginalJSON = [[NSMutableDictionary<NSString*, NSObject *> alloc] init];
    Analytics * analytics  = [Analytics getAnalytics];
    
    [OriginalJSON setValue: [analytics getUserServerId] forKey:@"user"];
    if([[Settings getSettings] DebugLogs])
        NSLog(@"%@",[NSString stringWithFormat:@"Generating data: %@, %@", [analytics getUserServerId], @"user"]);
    return OriginalJSON;
}


@end
