#ifndef Enums_h
#define Enums_h
#endif
typedef enum RequestStatus {Completed, Failed, Timeout} RequestStatus;


@interface Enums : NSObject
{
    RequestStatus * status;
}

@end
