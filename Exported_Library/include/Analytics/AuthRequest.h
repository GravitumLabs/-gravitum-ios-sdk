#import "BaseRequest.h"
#import <Foundation/Foundation.h>
@class Analytics;


@interface AuthRequest : BaseRequest{}


FOUNDATION_EXPORT NSString *const PackId;

-(id)initWithString;

-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData;



-(void)Send;

@end
