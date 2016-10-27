#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "WebServer.h"


@interface BaseRequest (){}

@end

@implementation BaseRequest



-(id)initWithString:(NSString *)_id
{
    request_Id = _id;
    _cacheable = NO;
    WebServer * ws = [WebServer getWebServer];
    _TimeStamp = [ws CurrentTimeStamp];
	_authRequired = YES;
    return self;
}

-(id)init{
    return self;
}

-(void)DispatchCompletedRequest :(RequestStatus *)requestStatus serverResponse:(ServerResponse * _Nullable)responseD  {
    if(requestStatus == Completed) {
        Response = responseD;
        if([[Settings getSettings] DebugLogs])
            NSLog(@"DispatchCompletedRequest - SUCCEEDED");
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [NSNumber numberWithInt:(RequestStatus)requestStatus] forKey:@"RequestStatus"];
    if(responseD != nil){
                [dict setObject:responseD forKey:@"ServerResponse"];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"RequestCompleted" object:self userInfo:dict];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName: @"RequestCompleted" object:self userInfo:dict];
    }
    
    

}

-(ServerResponse *)getResponse{
    return Response;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)Send{
    WebServer * ws = [WebServer getWebServer];
    [ws Send:self];
}

-(bool)isCacheable{return _cacheable;}

-(bool) AuthenticationRequired{
    return _authRequired;
}

-(NSString*)id{
    return request_Id;
}

-(int32_t)Timeout{
    return 10;
}

-(int32_t)getTimeStamp{
    return _TimeStamp;
}


-(NSMutableDictionary<NSString *,NSObject *> *) GenerateData{
    
    return [[NSMutableDictionary alloc] init];
}

-(NSString *) GetJsonData{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    

    [dict setValue:request_Id forKey:@"requestId"];
    NSString * stringData;
    NSError *erroR;
    NSData * jsondata = [NSJSONSerialization dataWithJSONObject:dict
                                                        options:0
                                                          error: &erroR];
    if(!jsondata){
        NSLog(@"NSdictionary to json convert error: %@", erroR.localizedDescription);
        
    }else{
        stringData = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    }
    return stringData;
}


@end











