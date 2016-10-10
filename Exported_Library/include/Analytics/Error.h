#ifndef Error_h
#define Error_h


#endif /* Error_h */


@interface Error : NSObject
{
    NSString * description_;
}


-(NSString *)Description;
-(void)setDescription: (NSString *)desc;

@end