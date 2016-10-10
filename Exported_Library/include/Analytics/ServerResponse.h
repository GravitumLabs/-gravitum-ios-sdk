@class Error;
@class WebServer;
#include <UIKit/UIKit.h>

@interface ServerResponse : NSObject{
    NSString * _Id;
    NSError * _Error;
    NSDictionary<NSString *, NSObject * > * _Data;
    
    NSString * _RawResponse;
}

-(id)initWithString: (NSString * )rawResponse;
-(NSDictionary<NSString *, NSObject * > *)getData;
-(bool)isFailed;
-(NSString*) RawResponce;
-(NSError *)Error;
-(NSString *)Id;

@end