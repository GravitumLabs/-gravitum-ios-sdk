#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "SessionManager.h"


@interface SessionStopRequest : BaseRequest


-(id)init;
-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData;
-(bool) AuthenticationRequired;
@end
