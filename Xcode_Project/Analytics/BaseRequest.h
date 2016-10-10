#import "ServerResponse.h"
@class WebServer;
#import "Enums.h"
#include <UIKit/UIKit.h>

@interface BaseRequest : NSObject
{
    NSString * request_Id;
    int32_t  _TimeStamp;
    ServerResponse * _Nullable  Response;
}


-(id _Null_unspecified) initWithString : (NSString * _Null_unspecified)_id;

-(void)Send;

-(void)DispatchCompletedRequest :(RequestStatus * _Null_unspecified)requestStatus serverResponse:(ServerResponse * _Nullable)responseD;

-(ServerResponse * _Nullable)getResponse;

-(bool) AuthenticationRequired;

-(NSString *_Null_unspecified)id;

-(int32_t)Timeout;

-(int32_t)getTimeStamp;

-(NSMutableDictionary<NSString *,NSObject *> *_Null_unspecified) GenerateData;

-(NSString * _Nonnull) GetJsonData;

@end