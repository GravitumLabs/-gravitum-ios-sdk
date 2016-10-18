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
    
    
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    
    NSString * string = [NSString stringWithFormat:@"%0.2f", _price];
    
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@""];
    [formatter setDecimalSeparator:@"."];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    NSNumber * newNumber  = [formatter numberFromString:string];
    
    
    [OriginalJSON setValue: newNumber forKey:@"price"];
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
    
    
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    
    NSString * string = [NSString stringWithFormat:@"%0.2f", _price];
    
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@""];
    [formatter setDecimalSeparator:@"."];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    NSNumber * newNumber  = [formatter numberFromString:string];
    
    [dict setValue: newNumber forKey:@"price"];
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
