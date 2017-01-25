#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import "ServerRequest.h"
#import "WebServer.h"
#import "SessionManager.h"
#import "BaseRequest.h"
#import "Settings.h"
#import "Enums.h"
#import "RequestResult.h"

@implementation ServerRequest


-(void)Send :(BaseRequest*)package url:(NSString*)url{
    _URL = url;
    _Package = package;
    bool debuging = [[Settings getSettings] DebugLogs];
    if(debuging){
        NSLog(@"Setting Server requests Package. PackageId =  %@ and URL to %@", [package id], [url description]);
    }
    
    [self SendRequest:package];
    if([_Package Timeout] > 0){
        [self performSelector: @selector(TimeOut) withObject:nil afterDelay:[_Package Timeout]];
        if(debuging)
            NSLog(@"Package Timeout = %i", [_Package Timeout]);
    }
}




-(void)SendRequest:(BaseRequest*)package{
    bool debuging = [[Settings getSettings] DebugLogs];
    if(debuging){
        NSLog(@"ServerRequest. Sending request with package id %@", [package id]);
    }
    
    NSMutableDictionary<NSString*,NSObject*>* OriginakJson = [[NSMutableDictionary<NSString*,NSObject*> alloc] init];
    NSMutableDictionary<NSString*,NSObject*> *dict = [package GenerateData] ;
    [OriginakJson setValue:[package id] forKey:@"method"];
    if(dict !=nil)
      [OriginakJson setValue:dict forKey:@"fields"];
    
    ////////////////// Dictionary TO STRING
    NSString * stringData;

    NSError *erroR;
    NSData * jsondata = [NSJSONSerialization dataWithJSONObject:OriginakJson
                                                         options:0
                                                           error: &erroR];
    if(!jsondata){
        NSLog(@"NSdictionary to json convert error: %@", erroR.localizedDescription);
        
    }else{
        stringData = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    }
    if(debuging){
       NSLog(@"Sending: %@", stringData);
    }
    
    ////////////////// String to Data
    NSData * postData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * hash = [ServerRequest hmac: [[Settings getSettings] getAppSecret] : stringData];
   // NSLog(@"Sending secret: %@", hash);
    if(debuging)
        NSLog(@"Sending data: %@", stringData);
    NSURL * url = [NSURL URLWithString:_URL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                         timeoutInterval:60.0];
                                     

    [request setHTTPBody:postData];
    
    [request addValue: [NSString stringWithFormat: @"%li", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"1" forHTTPHeaderField:@"environment"];
    [request addValue:@"1" forHTTPHeaderField:@"platform"];
    [request addValue:hash  forHTTPHeaderField:@"secret"];
    [request addValue:[[Settings getSettings] getAppToken] forHTTPHeaderField:@"token"];
    [request addValue:[[SessionManager getManager] sessionId] forHTTPHeaderField:@"session"];
    [request addValue:[NSString stringWithFormat:@"%i", [[WebServer getWebServer] CurrentTimeStamp]]  forHTTPHeaderField:@"client_time"];
    [request addValue:[NSString stringWithFormat:@"%d", (int)[package getTimeStamp]] forHTTPHeaderField:@"action_time"];
    request.HTTPMethod = @"Post";
    
    ////////////////
    // NEW CONNECTION TYPE
    ////////////////
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *uploadTask = [session
                                          dataTaskWithRequest:request
                                          completionHandler:^(NSData *  data,
                                                              NSURLResponse *  response,
                                                              NSError * _Nullable error) {
                                              
                                              RequestReceived = YES;
                                              RequestResult * result = [RequestResult getRequestResult];
                                              NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

                                              if(debuging){
                                                NSLog(@"ServerRequest. Response text from session: %@",[response description]);
                                              }
                                              NSLog(@"RequestReply: %@ \n %@ \n\n",requestReply, package);
                                              
                                              [result setResultData:data];
                                              [result setUrl:response.URL];
                                              [result setResponse:response];
                                              [result setError:error];
                                              [result setBaseResult:_Package];
                                              if(error){
                                                  [result setRequestStatus:(RequestStatus *)Failed];
                                              }else{
                                                  [result setRequestStatus:Completed];
                                              }
                                              
                                              NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                                              [dict setObject: result forKey:@"result"];
                                              if(debuging){
                                                  NSLog(@"ServerRequest. RequestCompleted");
                                              }
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName: @"RequestCompleted" object:self userInfo:dict];
                                              [self CleanUp];
                                              ///
                                          }];
    [uploadTask resume];
    
    
    
}

+(NSString*)ReplaceCharacters : (NSString*)string oldChar:(NSString*)oldChar newChar:(NSString*)newChar{
    NSArray * words = [string componentsSeparatedByString:oldChar];
    return [words componentsJoinedByString:newChar];
}


+(NSString*)hmac:(NSString*)key :(NSString*)data{
    NSData * nKey = [key dataUsingEncoding:NSASCIIStringEncoding];
    NSData * cData = [data dataUsingEncoding:NSASCIIStringEncoding];

    NSMutableData * hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, nKey.bytes, nKey.length, cData.bytes, cData.length, hash.mutableBytes);
    NSString * result = [hash base64EncodedStringWithOptions:0];
    result = [self ByteToString:hash];
    result = [result lowercaseString];
  
    return result;
}

+(NSString*) ByteToString:(NSData*)cData{
    NSUInteger capacity = cData.length *2;
    NSMutableString *sbuf = [NSMutableString stringWithCapacity: capacity];
    const unsigned char *buf = cData.bytes;
    NSInteger i;
    for(i=0; i<cData.length; ++i){
        [sbuf appendFormat:@"%02x", buf[i]];
    }
    return sbuf;
}


-(BaseRequest*) getPackage{
    return _Package;
}

-(void)TimeOut{
    if(RequestReceived){
        return;
    }
    RequestResult * result = [RequestResult getRequestResult];
    [result setRequestStatus : (RequestStatus*)Timeout];
    [result setBaseResult: _Package];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: result forKey:@"result"];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"RequestCompleted" object:self userInfo:dict];
    [self CleanUp];
}

-(void)CleanUp
{
    
}


@end
