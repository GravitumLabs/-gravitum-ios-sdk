#import "Settings.h"

@implementation Settings

+(Settings *) getSettings{
    static Settings* theSingleton = nil;
    
    if (theSingleton  == nil)
    {
        theSingleton = [[Settings alloc] init];
    }
    return theSingleton;}

-(id)init{
    TrackSessionDuration = YES;
    DebugLogs = NO;
    return self;
}


-(void)setDebugLogs : (bool)enable{
    DebugLogs = enable;
}

-(bool) DebugLogs{
    return DebugLogs;
}
-(void)setAppToken : (NSString*)newToken{
    AppToken = newToken;
}
-(void)setAppSecret : (NSString*)newSecret{
    AppSecret = newSecret;
}
-(void)setSenderId : (NSString*)newId{
    MessagingId = newId;
}
-(bool)getTackSessionDuration{return TrackSessionDuration;};
-(NSString *)getAppToken{return  AppToken;};
-(NSString *)getAppSecret{return AppSecret;};
-(NSString *)getMessagingId{return MessagingId;};

@end
