#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "Analytics.h"

@interface MonetaryEventRequest : BaseRequest
{
    NSString * _productId;
    double  _price;
    NSString * _currency;
}

-(id)initWithString :(NSString *)productID price:(double)price currency:(NSString *) currency;

-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData;

-(NSString *) GetJsonData;

@end
