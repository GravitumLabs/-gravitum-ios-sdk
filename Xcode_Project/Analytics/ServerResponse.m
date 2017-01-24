#import <Foundation/Foundation.h>
#import "ServerResponse.h"
#import "WebServer.h"
#import "Error.h"

@interface ServerResponse (){}


@end

@implementation ServerResponse

-(id)initWithString: (NSString * )rawResponse{
    bool debuging = [[Settings getSettings] DebugLogs];
    _RawResponse = rawResponse;
    NSError * jsonError;
    
    NSData * objectData = [rawResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary<NSString *, NSObject *> * dict = [NSJSONSerialization JSONObjectWithData:objectData
                                                                                  options:NSJSONReadingMutableContainers
                                                                                    error:&jsonError];
    _Id = [NSString stringWithFormat:@" %@", [dict objectForKey:@"method"]];
    if(debuging)
        NSLog(@"Server response string data:\n %@", dict);
    WebServer *ws = [WebServer getWebServer];
    if(jsonError.description != NULL){
        _Error = jsonError;
        
        NSLog(@"%@ Package %@ Failed: %@", [ws WEBSERVER_LOG_HEADER] , _Id, _Error.description);
    }else{
        if([[dict objectForKey:@"data"] isKindOfClass: [ NSDictionary< NSString*,NSObject*>  class]]){
            NSError * erroR;
            
            
            

            NSString * stringData ;
            NSData * jsondata = [NSJSONSerialization dataWithJSONObject:[dict objectForKey:@"data"]
                                                                options:0
                                                                  error: &erroR];
            if(!jsondata){
                NSLog(@"NSdictionary to json convert error: %@", erroR.localizedDescription);
                
            }else{
                NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:jsondata
                                                                            options:0
                                                                              error:&erroR];
                if(!dictionary){
                    NSLog(@"json To NSDictionary conver error: %@", erroR.localizedDescription);
                }else{
                    _Data = dictionary;
                }
                
               stringData = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
            }
            if(debuging)
                NSLog(@"Parsing Data \n %@", _Data);
        }
        if(debuging)
            NSLog(@"%@ Request %@ Completed (SUCCEEDED)", [ws WEBSERVER_LOG_HEADER] , _Id);
    }
    return self;
}

-(bool)isFailed{
    return _Error == nil;
}

-(NSString*) RawResponce{
    return _RawResponse;
}

-(NSError *)Error{
    return _Error;
}

-(NSString *)Id{
    return _Id;
}
-(NSDictionary<NSString *, NSObject * > *)getData{
    return _Data;
}

@end