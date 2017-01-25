#import <Foundation/Foundation.h>
#import "WebServer.h"
#import "RequestResult.h"
#import "AddEventRequest.h"
#import "MonetaryEventRequest.h"
#import "Reachability.h"
#import "SessionManager.h"

@interface WebServer(){
    Reachability *internetReachableFoo;
}

@end

@implementation WebServer


NSString *const LOCAL_CACHE_KEY = @"GRAVITUM_LOCAL_CACHE_KEY";

NSString * const WEBSERVER_LOG_HEADER_ = @"WebServer Log: ";
NSString * const WEBSERVER_VERSION = @"1.0";
//NSString * const SERVER_URL = @"https://api.gravitum.com/init";
NSString * const SERVER_URL = @"https://apiv2.gravitum.com/init";
NSString * const WEBSERVER_ERROR_HEADER = @"WebServer Error: ";
int const WEBSERVER_ALLOWED_REQUEST_TIME_RANGE = 900000;

+(WebServer *)getWebServer{
    static WebServer* theSingleton = nil;
    
    if (theSingleton  == nil)
    {
        theSingleton = [[WebServer alloc] init];
    }
    
    return theSingleton;}

-(id)init{
    DelayedPackages = [[NSMutableArray alloc] init];
    return self;
}
-(bool)isOflineMode{
    return _isOfflineMode;
}

-(void)SetOfflineMode :(bool)Bool{
    _isOfflineMode = Bool;
}

-(void)FlushCachedRequests{
    NSLog(@"FlushCachedRequests");
    NSMutableArray * Array = [[NSMutableArray alloc] init];
    if([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_CACHE_KEY] != nil){
        
        Array = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_CACHE_KEY];
        if(Array == nil){
            Array = [[NSMutableArray alloc] init];
            for(BaseRequest *object in DelayedPackages)
            {
                [Array addObject:[object GetJsonData]];
            }
        }else{
            for(BaseRequest *object in DelayedPackages)
            {
                [Array addObject:[object GetJsonData]];
            }
        }
        
    }else{
        
        for(BaseRequest *object in DelayedPackages){
            [Array addObject:[object GetJsonData]];
        }
    }
    
    if([[Settings getSettings] DebugLogs])
        NSLog(@"Cached list:\n %@",Array);
    NSUserDefaults * userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:Array  forKey:LOCAL_CACHE_KEY];
    [userData synchronize];
    [DelayedPackages removeAllObjects];
}

-(void)LoadCachedRequests {

    if([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_CACHE_KEY] != nil){
        NSMutableArray * Array = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_CACHE_KEY];
        for(NSString *s in Array){
            NSData * data = [s dataUsingEncoding:NSUTF8StringEncoding];
            NSError * erroR;
            NSMutableDictionary * jsondata = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:0
                                                                               error:&erroR];
            NSString  *requestId = [jsondata objectForKey:@"requestId"];
            NSLog(@"Resending loaded Request: %@",requestId);
            
            if([requestId  isEqual: @"AddPurchase"])
            {
                NSString * productId = [jsondata objectForKey:@"productId"];
                double price = [[jsondata objectForKey:@"price"] doubleValue];
                NSString * currency = [jsondata objectForKey:@"currency"];

                MonetaryEventRequest * request = [[MonetaryEventRequest alloc] initWithString:productId price:price currency:currency];
                [request Send];
            }
            else if([requestId isEqualToString:@"AddEvent"])
            {
                
                
                NSString * newId = [jsondata objectForKey:@"eventId"];
                NSMutableDictionary * eData = [jsondata objectForKey:@"eventDDData"];
                AddEventRequest * request = [[[AddEventRequest alloc] init ]initWithString:newId eventData:eData];
                //NSLog(@"NEW EVENT %@", eData);
                [request Send];
               
            }
        }
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LOCAL_CACHE_KEY];
    //NSLog(@"LoadCachedRequests: %@", DelayedPackages);
}

//- (void)testInternetConnection
//{
//    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
//    
//    // Internet is reachable
//    internetReachableFoo.reachableBlock = ^(Reachability*reach)
//    {
//        // Update the UI on the main thread
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"There is internet connection, but can't reach server");
//            //_isOfflineMode = NO;
//        });
//    };
//    
//    // Internet is not reachable
//    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
//    {
//        // Update the UI on the main thread
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"No internet connection!");
//            //_isOfflineMode = YES;
//            
//        });
//    };
//    
//    [internetReachableFoo startNotifier];
//}

- (void)testInternetConnection :(BaseRequest *) package
{
    Reachability * reachableFoo = [Reachability reachabilityWithHostName:@"www.google.com"];
    internetReachableFoo = reachableFoo;

    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        
            _isOfflineMode = NO;

        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        if(_isOfflineMode == NO){
            _isOfflineMode = YES;
            NSLog(@"No server connection! Set to offline mode");
        }

        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
 
        });
    };
    if(!_isOfflineMode){
        if([SessionManager getManager].isSessionUndefined && [package AuthenticationRequired] && [package isCacheable]){
            if(![DelayedPackages containsObject:package]){
                [DelayedPackages addObject:package];
                NSLog(@"%@ Cached... (UndefinedSession) DelayedPackages: %@", [package id], DelayedPackages.description);
            }
        }else {
            
            if([DelayedPackages containsObject:package]){
                [self SendRequest:package];
                [DelayedPackages removeObject:package];
            }else{
                //NSLog(@"Is cacheable = %@", [package isCacheable]);
                [self SendRequest:package];
            }
        }
    }else{
        if([package AuthenticationRequired] ){
            if(![DelayedPackages containsObject:package]){
                [DelayedPackages addObject:package];
                NSLog(@"%@ Cached... (Can't reach server) DelayedPackages: %@", [package id],DelayedPackages.description);
            }
        }
    }
    
    
    [internetReachableFoo startNotifier];
}


-(void)Send: (BaseRequest *)package{
    //  SessionManager * sm = [SessionManager getManager];
    
    [self testInternetConnection:package];
    
    //   if(sm.isSessionUndefined || _isOfflineMode){
    //       if([package AuthenticationRequired]){
    //           [DelayedPackages addObject:package];
    //           NSLog(@"%@ Cached... DelayedPackages: %@", [package id], DelayedPackages.description);
    //          return;
    //       }
    //  }
    //   NSLog(@"WebServer: SendingRequest PackageId = %@" , [package id]);
    //   [self SendRequest:package];
    
}



-(NSString *)WEBSERVER_LOG_HEADER{
 
    
    return WEBSERVER_LOG_HEADER_;
}


-(int32_t)CurrentTimeStamp{
    //NSLog(@"WebServer  -CurrentTimeStamp: %f", [[NSDate date] timeIntervalSince1970]);
    return [[NSDate date]timeIntervalSince1970];
}

-(void)SendDelayedPackages{
    if([DelayedPackages count]> 0){
        NSLog(@"WebServer. SendingDelayedPackages");
        for(id object in DelayedPackages){
            NSLog(@"Sending request with object %@", object);
            [self SendRequest:object];
            // [DelayedPackages removeObject:object];
        }
        [DelayedPackages removeAllObjects];
    }else{
        NSLog(@"WebServer. There is no DelayedPackages");
    }
    
    
}


-(void)SendRequest:(BaseRequest*)package{
    ServerRequest *request = [[ServerRequest alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HandleRequestCompleted:)
                                                 name:@"RequestCompleted"
                                               object:request]; //or nil?
    [request Send:package url:SERVER_URL];
}


-(void)HandleRequestCompleted:(NSNotification*)resultDictionary{
    bool debuging = [[Settings getSettings] DebugLogs];
    if(debuging)
        NSLog(@"WebServer. HandleRequestCompleted");
    
    RequestResult * result = [resultDictionary.userInfo valueForKey:@"result"];
    
    if(result.getRequestStatus == Completed){
        if(debuging)
            NSLog(@"RequestStatus from Result == Completed");
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)[result getResponse];
        NSDictionary *dict = [httpResponse allHeaderFields];
        @try {
            
            if([[result getResponse] respondsToSelector:@selector(allHeaderFields)]){
                ///////////////// TIME VALIDATION CHECK
                NSString *ServerTimeString = [dict valueForKey:@"time"];
                double Now = [[NSDate date] timeIntervalSince1970];
                int ServerTime = [ServerTimeString intValue];
                //  NSLog(@"ServerTime = %d, CurrentTime = %f", ServerTime, Now);
                unsigned int diff = (int)(Now - ServerTime);
                if((int)diff > WEBSERVER_ALLOWED_REQUEST_TIME_RANGE){
                    NSLog(@"%@ Time Validation FAILED, Difference: %i", WEBSERVER_ERROR_HEADER, diff);
                    [self ValidationFailed:result];
                    return;
                }else{
                    if(debuging)
                        NSLog(@"Time validation ok, time difference: %i", diff);
                }
                
                NSString *ResponseHash = [dict objectForKey:@"SECRET"];
                
                NSData * resultData = [result getResultData];
                NSString * resultDataString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
                NSString *ClientHash = [ServerRequest hmac: [[Settings getSettings] getAppSecret] : resultDataString];
               //  NSLog(@"%@ Hash Validation : \n ClientHash   = %@ \n ResponseHash = %@ \n AppSecret    = %@" , WEBSERVER_LOG_HEADER_ , ClientHash, ResponseHash, [[Settings getSettings] getAppSecret]);
                if(![ClientHash isEqualToString:ResponseHash]){
                   
                    [self ValidationFailed:result];
                    return;
                }else{
                    if(debuging)
                        NSLog(@"Hash validation ok");
                }
                ServerResponse *response = [[ServerResponse alloc ]initWithString: resultDataString];
                [[result getBaseRequest] DispatchCompletedRequest:[result getRequestStatus] serverResponse:response];
            }
        } @catch (NSException *exception) {
            NSLog(@"Server response parsing failed %@", exception.description);
            [[result getBaseRequest] DispatchCompletedRequest:[result getRequestStatus] serverResponse:nil];
		} @finally {
			
		}
    }else{

        NSString *resultString = nil;
        if(result != nil){
            RequestStatus s = (RequestStatus)(result.getRequestStatus);
            switch (s) {
                case Failed:
                    resultString = @"failed";
                    break;
                    
                default:
                    resultString = @"other";
                    break;
            }
        }else{
            resultString = @"result == nil";
        }
        if(debuging)
            NSLog(@"Debugging... RequestResult is: %@", resultString);
        
        [[result getBaseRequest] DispatchCompletedRequest:[result getRequestStatus] serverResponse:nil];
    }
}



    -(void)ValidationFailed :(RequestResult*)result{
        [[result getBaseRequest] DispatchCompletedRequest:[result getRequestStatus] serverResponse:nil];
    }



@end
