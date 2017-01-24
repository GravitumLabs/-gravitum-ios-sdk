#import <Foundation/Foundation.h>

@class BaseRequest;
@class SessionManager;
@class WebServer;

@interface ServerRequest : NSObject
{
    NSString * _URL;
    BaseRequest * _Package;
    bool RequestReceived;
}

-(void)Send :(BaseRequest*)package url:(NSString*)url;
+(NSString*)hmac :(NSString*)key :(NSString*)data;

+(NSString*)ReplaceCharacters : (NSString*)string oldChar:(NSString*)oldChar newChar:(NSString*)newChar;

@end
