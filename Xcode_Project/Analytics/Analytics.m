#import <Foundation/Foundation.h>
#import "Analytics.h"
#import "SessionManager.h"
#import "PushEvent.h"
#import "SetPushToken.h"


@interface Analytics()
{}

@end



@implementation Analytics

+(Analytics *) getAnalytics{
    static Analytics* theSingleton = nil;
    
    if (theSingleton  == nil)
    {
        theSingleton = [[Analytics alloc] init];
    }
	
    return theSingleton;}

-(id)init{
	if(_devicePushToken == nil)
		_devicePushToken= @"";
    _userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    _gender = Unknown;
    CacheArray = [[NSMutableArray alloc] init];
	useNotifications = NO;
    return self;
}

-(id)initWithParameters :(NSString*)AppToken AppSecret:(NSString*)AppSecret SenderId:(NSString * _Nullable)SenderId{
    
    Settings * settings = [Settings getSettings];
    [settings setAppToken: AppToken];
    [settings setAppSecret:AppSecret];
    [settings setSenderId:SenderId];
    return self;
}

-(void)Init{
	
    AuthRequest *request = nil;
    request = [[AuthRequest alloc] initWithString];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnAuthRequestCompletedHandler:)
                                                 name:@"RequestCompleted"
                                               object:request];
    [request Send];
}

//GETTERS
-(NSString *)getUserId {    return _userId;}
-(NSDate *)getBirthday{return _birthday;}
-(Gender *)getUserGender{return _gender;}
-(NSString *)getUserName{
    if(_userName != nil){
     return _userName;
    }else{
        return @"";
    }
}
-(NSString *)getFacebookId{
    if(_facebookId!= nil){
            return _facebookId;
    }else{
        return @"";
    }
    
}
-(NSString *)getUserServerId{return _userServerId;}
-(NSString *)getDevicePushToken{return _devicePushToken;}
-(bool *)isInited{return &(_isInited);}

//PUBLIC METHODS
-(void)SetBirthday:(int)dayBorn monthBorn:(int)monthBorn yearBorn:(int)yearBorn{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    comps.day = (NSInteger)dayBorn;
    comps.month = (NSInteger) monthBorn;
    comps.year = (NSInteger)yearBorn;
    comps.hour = 00;
    comps.minute = 00;
    comps.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate * date = [calendar dateFromComponents:comps];
    _birthday = date;
}

-(void)SetUserId:(NSString* )newUserId{_userId = newUserId;}
-(void)useNotifications:(bool)use{
	useNotifications = use;
	if(_isInited)
		[Analytics RegisterNotifications];
}
-(void)SetGender:(Gender *) newGender{_gender = newGender;}
-(void)SetUserName: (NSString *)newUserName{_userName = newUserName;}
-(void)SetFacebookId:(NSString *)newFacebookId{_facebookId = newFacebookId;}
-(void)SetBurthday :(NSDate*)newBirthday{
    _birthday = newBirthday;
}

-(void)SetDevicePushToken: (NSString*) token{
	if([_devicePushToken  isEqual: @""] || ![_devicePushToken isEqualToString:token]){
		_devicePushToken = token;
		SetPushToken * NewTokenRequest = [[SetPushToken alloc] initWithString:_devicePushToken];
		[NewTokenRequest Send];
	}
	
}
-(void)SetDevicePushTokenData: (NSData*) token{
	const unsigned *tokenBytes = [token bytes];
	NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
						  ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
						  ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
						  ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
	
	[self SetDevicePushToken:hexToken];
}
-(void)PushEvent: (int )Id type:(int)type{
	PushEvent * request = [[PushEvent alloc] initWithString:Id type:type];
	[request Send];
}

-(void)OpenedFromPush :(NSDictionary *)data{
	NSLog(@"opened from a push notification when the app was on background");
	int push_id = (int)[[[data objectForKey:@"aps"] objectForKey:@"push_id"] integerValue];
	[[Analytics getAnalytics] PushEvent:push_id type:1];
}

+(void)RegisterNotifications{
	NSLog(@"Registering for notifications at Apple Server");
	
	//Register the supported interaction types
	UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeNone;
	UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types
																			   categories:nil];
	//Rigister for remote notifications
	
	[[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
	[[UIApplication sharedApplication] registerForRemoteNotifications];
	
}

-(void)SessionStart{
    //NSLog(@"SessionStartRequest");
    if(_isInited && [[SessionManager getManager] isSessionUndefined]){
        SessionStartRequest * sessionStartRequest = [[SessionStartRequest alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(OnSessionStartRequestCompleted:)
                                                     name:@"RequestCompleted"
                                                   object:sessionStartRequest];

        
        [sessionStartRequest Send];
    }
}


-(void)SessionEnd{
    
    [[WebServer getWebServer] FlushCachedRequests];
    
    
    if(_isInited && ![[SessionManager getManager] isSessionUndefined]){
        SessionStopRequest * sessionStopRequest = [[SessionStopRequest alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(OnSessionStopCompletedHandler:)
                                                     name:@"RequestCompleted"
                                                   object:sessionStopRequest];

        [sessionStopRequest Send];
        
    }
}

-(void)OnSessionStopCompletedHandler: (NSNotification*)notification{
    
    NSLog(@"Session has succesfully stopped");
    [[SessionManager getManager] setSessionId:UndefinedSession];
}

-(void)SendEvent: (NSString *)newId data:(NSDictionary<NSString *, NSObject *> *)data{
    AddEventRequest * request = [[AddEventRequest alloc] initWithString:newId eventData:data];
    [request Send];
}

-(void)SendEvent: (NSString *)newId {

    AddEventRequest * request = [[AddEventRequest alloc] initWithString:newId];
    [request Send];
}

-(void)SendMonetaryEvent :(NSString*)productId price:(double)_price currency:(NSString * )currency{
    MonetaryEventRequest * request = [[MonetaryEventRequest alloc] initWithString:productId price:_price currency:currency];
    [request Send];
}

-(void)OnAuthRequestCompletedHandler: (NSNotification*)notification {
    if([[Settings getSettings] DebugLogs])
        NSLog(@"OnAuthRequestCompletedHandler");
    NSDictionary * dict = [notification userInfo];
    //NSLog(@"userinfo: \n %@", dict);
    RequestStatus requestStatus = [[dict valueForKey:@"RequestStatus"] intValue];
    if(requestStatus == Completed){
        if([[Settings getSettings] DebugLogs])
            NSLog(@"OnAuthRequestCompletedHandler. RequestStatus == Completed");
        ServerResponse * serverResponse = [dict valueForKey:@"ServerResponse"];
        if(serverResponse != nil){
            if([[Settings getSettings] DebugLogs])
                NSLog(@"OnAuthRequestCompletedHandler. serverResponse != nil");
            if([serverResponse Error] == nil)
            {
                if([[Settings getSettings] DebugLogs])
                    NSLog(@"OnAuthRequestCompletedHandler. serverResponse Error == nil");
             
                _isInited = true;
                NSDictionary<NSString *, NSObject * > * ddd =[serverResponse getData];
                
                _userServerId = (NSString*)[ddd valueForKey:@"user"];
				if(useNotifications)
					[Analytics RegisterNotifications];
				

				
                SessionStartRequest *sessionStart = [[SessionStartRequest alloc] init];
                if([[Settings getSettings] DebugLogs])
                    NSLog(@"userServerId from after Auth \n%@ \n Init succesfull, starting session", _userServerId);

                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(OnSessionStartRequestCompleted:)
                                                             name:@"RequestCompleted"
                                                           object:sessionStart];
                [sessionStart Send];
            }else{
                NSLog(@"Auth Rquest fail : %@", [[serverResponse Error] description] );
            }
        }else{
            NSLog(@"OnAuthRequestCompletedHandler. serverResponse == nil");
        }
    }else{
        NSLog(@"OnAuthRequestCompletedHandler. RequestStatus != Completed");
    }
}

-(void)OnSessionStartRequestCompleted :(NSNotification*)notification{
    if([[Settings getSettings] DebugLogs])
        NSLog(@"ONSessionStartRequestCompleted");
    NSDictionary * dict = [notification userInfo];
    RequestStatus requestStatus = [[dict valueForKey:@"RequestStatus"] intValue];
    if(requestStatus == Completed){
        ServerResponse * serverResponse = [dict valueForKey:@"ServerResponse"];
        if([serverResponse Error] == nil)
        {
            SessionManager * sm = [SessionManager getManager];
            [sm setSessionId:(NSString*)[[serverResponse getData] valueForKey:@"session"]];
            if([[Settings getSettings] DebugLogs])
                NSLog(@"OnSessionStartRequestCompleted. ServerError == nil");
            [[WebServer getWebServer] LoadCachedRequests];
            [[WebServer getWebServer] SendDelayedPackages];
            
        }else{
            NSLog(@"Start Game Session request failed : %@", [[serverResponse Error] description]);
        }
    }
}


-(void)TrackGameSession :(bool*)pause{
    if(pause && _isInited && ![[SessionManager getManager] isSessionUndefined]){
        NSLog(@"Gravitum Analytics : Session Stop");
        
        [[[SessionStopRequest alloc] init] Send];
        [[SessionManager getManager] setSessionId:UndefinedSession];
    }else{
        if(_isInited && [[SessionManager getManager] isSessionUndefined]){
            NSLog(@"Gravitum Analytics : Session Start");
            
            SessionStartRequest * startRequest = [[SessionStartRequest alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(OnSessionStartRequestCompleted:)
                                                         name:@"RequestCompleted"
                                                       object:startRequest];
            [startRequest Send];
        }
    }
    
}








@end
