#import "Enums.h"
#import "BaseRequest.h"

@interface RequestResult : NSObject
{
    @public RequestResult * requestResult;
    NSURL * url;
    BaseRequest * Request;
    RequestStatus * Status;
    NSURLResponse * Response;
    NSError * _Error;
    NSData * ResultData;
}

+(RequestResult *)getRequestResult;

-(NSData *)getResultData;
-(NSURL *)getURL;
-(BaseRequest *)getBaseRequest;
-(RequestStatus*)getRequestStatus;
-(NSURLResponse*)getResponse;
-(NSError *)getError;

-(void)setResultData :(NSData*)data;
-(void)setError :(NSError*)error;
-(void)setResponse :(NSURLResponse*)response;
-(void)setUrl : (NSURL*)newUrl;
-(void)setBaseResult:(BaseRequest *)request;
-(void)setRequestStatus:(RequestStatus*)value;

@end