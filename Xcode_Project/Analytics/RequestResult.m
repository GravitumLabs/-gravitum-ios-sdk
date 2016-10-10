#import <Foundation/Foundation.h>
#import "RequestResult.h"

@interface RequestResult (){}

@end


@implementation RequestResult

+(RequestResult *)getRequestResult{
    static RequestResult* theSingleton = nil;
    
    if (theSingleton  == nil)
    {
        theSingleton = [[RequestResult alloc] init];
    }
    return theSingleton;
}

-(NSURL *)getURL{return url;}
-(BaseRequest*)getBaseRequest {return Request;}
-(RequestStatus*)getRequestStatus {return Status;}
-(NSURLResponse*)getResponse{return Response;}
-(NSError *)getError{return _Error;}
-(NSData *)getResultData{return ResultData;}

-(void)setResultData :(NSData*)data{
    ResultData = data;
}

-(void)setError:(NSError *)error{
    _Error = error;
}

-(void)setResponse :(NSURLResponse*)response{
    Response = response;
}

-(void)setUrl : (NSURL*)newUrl{
    url = newUrl;
}
-(void)setBaseResult:(BaseRequest*)request{
    Request = request;
}
-(void)setRequestStatus:(RequestStatus *)value{
    Status = value;
}




@end