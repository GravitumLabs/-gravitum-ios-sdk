@interface SessionManager : NSObject
{
    NSString * sessionId_;
}

FOUNDATION_EXPORT NSString *const UndefinedSession;



@property (nonatomic) NSString * sessionId;

+(SessionManager *)getManager;
-(BOOL)isSessionUndefined;
-(void)Init;


@end
