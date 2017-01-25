#import <Foundation/Foundation.h>
#import "BaseRequest.h"


@interface AddEventRequest : BaseRequest
{
    NSString * _eventId;
    NSDictionary<NSString * , NSObject *> * _eventData;
}

-(id)initWithString:(NSString *) newEventId;

-(id)initWithString : (NSString *)newEventId  eventData:(NSDictionary<NSString*,NSObject*> *)eventData;

-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData;


//-(NSString *) GetJsonData;

@end
