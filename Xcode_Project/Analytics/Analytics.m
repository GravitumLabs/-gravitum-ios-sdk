#import <Foundation/Foundation.h>
#import "Analytics.h"
#import "SessionManager.h"
//@import UIKit;

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
    [theSingleton SetDevicePushToken:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    return theSingleton;}

-(id)init{
    _deviceGcmId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    _userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    _gender = Unknown;
    CacheArray = [[NSMutableArray alloc] init];
    
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
-(NSString *)getDeviceGcmId{return _deviceGcmId;}
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
    
    
    
    _birthday = date;}
-(void)SetUserId:(NSString* )newUserId{_userId = newUserId;}
-(void)SetDevicePushToken: (NSString*) gcmId{_deviceGcmId = gcmId;}
-(void)SetGender:(Gender *) newGender{_gender = newGender;}
-(void)SetUserName: (NSString *)newUserName{_userName = newUserName;}
-(void)SetFacebookId:(NSString *)newFacebookId{_facebookId = newFacebookId;}
-(void)SetBurthday :(NSDate*)newBirthday{
    _birthday = newBirthday;
}

-(void)SessionStart{
    if(_isInited && [[SessionManager getManager] isSessionUndefined]){
        SessionStartRequest * sessionStartRequest = [[SessionStartRequest alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(OnSessionStartRequestCompleted:)
                                                     name:@"RequestCompleted"
                                                   object:sessionStartRequest];

        
        [sessionStartRequest Send];
    }
    
    /*if (_isInited && SessionManager.GetSessionId().equals(SessionManager.SESSION_UNDEFINED)) {
     StartSessionRequest startSession = new StartSessionRequest();
     startSession.setResultCallback(new RequestCallback() {
     @Override
     public void OnSuccess(JSONObject data) {
     try {
     SessionManager.SetSessionId(data.getString("session"));
     WebServer.GetInstance().loadCachedRequests();
     WebServer.GetInstance().sendCachedRequests();
     } catch (JSONException e) {
     Log.d(InternalData.TAG, "Parse Session ID error: " + e.getMessage());
     e.printStackTrace();
     }
     }
     
     @Override
     public void OnFail(int code, String message) {
     Log.d(InternalData.TAG, "Session Start Fail| Code:" + Integer.toString(code) + " Message:" + message);
     }
     });
     startSession.send();
     }*/
    
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
    /*WebServer.GetInstance().flushCachedRequests();
    
    if (_isInited && !SessionManager.GetSessionId().equals(SessionManager.SESSION_UNDEFINED)) {
        StopSessionRequest stopSession = new StopSessionRequest();
        stopSession.setResultCallback(new RequestCallback() {
            @Override
            public void OnSuccess(JSONObject data) {
                SessionManager.SetSessionId(SessionManager.SESSION_UNDEFINED);
                Log.d(InternalData.TAG, "Session End Success");
            }
            
            @Override
            public void OnFail(int code, String message) {
                SessionManager.SetSessionId(SessionManager.SESSION_UNDEFINED);
                Log.d(InternalData.TAG, "Session End Fail| Code:" + Integer.toString(code) + " Message:" + message);
            }
        });
        stopSession.send();
    }*/
}

-(void)OnSessionStopCompletedHandler: (NSNotification*)notification{
    
    NSLog(@"Session has succesfully stoped");
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
//    if([[SessionManager getManager] isSessionUndefined] || [[WebServer getWebServer] isOflineMode]){
//        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:@"Monetary" forKey:@"EventType"];
//        [dict setObject:productId forKey:@"EventProductId"];
//        [dict setObject:[NSNumber numberWithDouble:_price] forKey:@"EventPrice"];
//        [dict setObject:currency forKey:@"currency"];
//        
//        [CacheArray addObject:dict];
//    }
    
    MonetaryEventRequest * request = [[MonetaryEventRequest alloc] initWithString:productId price:_price currency:currency];
    [request Send];
}

-(void)OnGcmIdRequestCompletedHandler{
    
    AuthRequest * request = [[AuthRequest alloc] initWithString];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnAuthRequestCompletedHandler:)
                                        
                                                 name:@"RequestCompleted"
                                               object:request];
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
                if([[Settings getSettings] DebugLogs])
                NSLog(@"userServerId from after Auth \n%@", _userServerId);
                SessionStartRequest *sessionStart = [[SessionStartRequest alloc] init];
                if([[Settings getSettings] DebugLogs])
                NSLog(@"Init succesfull, starting session");
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