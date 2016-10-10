#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "Analytics.h"

@interface SessionStartRequest : BaseRequest

-(id)init;
-(bool) AuthenticationRequired;
-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData;

@end
