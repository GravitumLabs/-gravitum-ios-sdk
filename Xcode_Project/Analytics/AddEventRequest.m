//
//  AddEventRequest.m
//  app-preview
//
#import "AddEventRequest.h"
#import "Analytics.h"

@implementation AddEventRequest

NSString *const AddEventPackId = @"AddEvent";

-(id)initWithString:(NSString *) newEventId{
    
    self = [super initWithString:AddEventPackId];
    _eventId = newEventId;
    _eventData = [[NSDictionary<NSString*,NSObject*> alloc] init];
        NSMutableDictionary<NSString*,NSObject*>* eventData = [[NSMutableDictionary<NSString*,NSObject*> alloc] init];
    _eventData = eventData;
    return self;
}



-(id)initWithString :(NSString *)newEventId eventData:(NSDictionary<NSString*,NSObject*> *)eventData{
    self = [super initWithString:AddEventPackId];
    _eventId = newEventId;
    if(eventData != nil)
        _eventData = eventData;
    return self;
}

-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData{
    NSMutableDictionary<NSString*, NSObject *> * OriginalJSON = [[NSMutableDictionary<NSString*, NSObject *> alloc] init];
    
    Analytics * analytics = [[Analytics getAnalytics] init];
    SessionManager * sm = [[SessionManager getManager] init];
    
    
    [OriginalJSON setValue:[analytics getUserServerId] forKey:@"user"];
    [OriginalJSON setValue: [sm sessionId] forKey:@"session"];
    [OriginalJSON setValue:_eventId forKey:@"event"];
    if(_eventData == nil){
        NSMutableDictionary<NSString*,NSObject*>* eventData = [[NSMutableDictionary<NSString*,NSObject*> alloc] init];
        _eventData = eventData;
    }
    
    
    [OriginalJSON setValue: _eventData forKey:@"data"];
    if([[Settings getSettings] DebugLogs])
        NSLog(@"Generating data for EventRequest: %@", OriginalJSON);
    return OriginalJSON;
}

//{"method":"AddEvent",
//    "fields":
//            {
//            "session":"57e93fb9b34b993ae3688d03",
//            "user":"57e93fb3b34b993ae3688d01",
//            "data":
//                {
//                    "custom_int_data":10101,
//                    "custom_string_data":"string_data"
//                }
//            }
//}


//Good
//{"method":"AddEvent",
//    "fields":
//        {"data":
//            {
//            "custom_int_data":10101,
//            "custom_string_data":"string_data"
//            },
//        "session":"57e93fb9b34b993ae3688d03",
//        "event":"sample_event",
//        "user":"57e93fb3b34b993ae3688d01"
//    }
//}


-(bool) AuthenticationRequired{
    return YES;
}

-(NSString *) GetJsonData{
    NSMutableDictionary<NSString * , NSObject *> * dict = [[NSMutableDictionary<NSString * , NSObject *> alloc] init];
    
    
    [dict setValue:request_Id forKey:@"requestId"];
    //[dict setValue:AddEventPackId forKey:@"requestId"];
    [dict setValue:_eventId forKey:@"eventId"];
    [dict setValue:_eventData  forKey:@"eventDDData"];

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
