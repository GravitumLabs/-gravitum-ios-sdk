#import "MonetaryEventRequest.h"

@implementation MonetaryEventRequest

NSString *const MonPackId = @"AddPurchase";


-(id)initWithString :(NSString *)productID price:(double)price currency:(NSString*)currency {
    self = [super initWithString:MonPackId];
    _productId = productID;
    _price = price;
    _currency = currency;
    return self;
}

-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData{
    NSMutableDictionary<NSString*, NSObject *> * OriginalJSON = [[NSMutableDictionary<NSString*, NSObject *> alloc] init];
    
    Analytics * analytics = [[Analytics getAnalytics] init];
    SessionManager * sm = [[SessionManager getManager] init];
    
    
    [OriginalJSON setValue:[analytics getUserServerId] forKey:@"user"];
    [OriginalJSON setValue: [sm sessionId] forKey:@"session"];
    [OriginalJSON setValue:_productId forKey:@"product_id"];
    [OriginalJSON setValue: [[NSNumber alloc] initWithDouble:_price]    forKey:@"price"];
    [OriginalJSON setValue: _currency forKey:@"currency"];
    
    //NSLog(@"%@",[NSString stringWithFormat:@"Generating data from MonetaryEventRequest: %@, %@", [sm sessionId], @"session"]);
    return OriginalJSON;
}

-(bool) AuthenticationRequired{
    return YES;
}

-(NSString *) GetJsonData{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
  
    [dict setValue:request_Id forKey:@"requestId"];
    [dict setValue:_productId forKey:@"productId"];
    [dict setValue:[NSNumber numberWithDouble:_price] forKey:@"price"];
    [dict setValue:_currency forKey:@"currency"];

    NSString * stringData;
    NSError *erroR;
    NSData * jsondata = [NSJSONSerialization dataWithJSONObject:dict
                                                        options:0
                                                          error: &erroR];
    if(!jsondata){
        NSLog(@"NSdictionary to json convert error: %@", erroR.localizedDescription);
        
    }else{
        stringData = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    }
    return stringData;
}


@end
