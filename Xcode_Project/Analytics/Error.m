#import <Foundation/Foundation.h>
#import "Error.h"

@interface Error ()
{

}


@end

@implementation Error

-(NSString *)Description{
    return description_;
}

-(id)initWithName: (NSString *)description{
    self = [super init];
    if(self){
        [self setDescription:description];
    }
    return self;
}

-(void)setDescription: (NSString *)desc{
    description_ = desc;
}


@end
