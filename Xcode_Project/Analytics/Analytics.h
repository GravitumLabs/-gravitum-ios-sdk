#import <UIKit/UIKit.h>
#import "AddEventRequest.h"
#import "MonetaryEventRequest.h"
#import "AuthRequest.h"
#import "Enums.h"
#import "ServerResponse.h"
#import "SessionStartRequest.h"
#import "WebServer.h"
#import "SessionStopRequest.h"

typedef enum Gender : NSInteger {
    Unknown = 0,
    Female = 1,
    Male = 2
}Gender;


@interface Analytics : NSObject
{
    NSString * _userId;
    NSString * _userName;
    NSString * _userServerId;
    NSString * _devicePushToken;
    NSString * _facebookId;
    NSDate * _birthday;
    Gender * _gender;
    bool  _isInited;
    NSMutableArray * CacheArray;
	bool useNotifications;
}

-(NSString * _Null_unspecified)getUserId;
-(NSDate *_Null_unspecified)getBirthday;
-(Gender *_Null_unspecified)getUserGender;
-(NSString *_Null_unspecified)getUserName;
-(NSString *_Null_unspecified)getFacebookId;
-(NSString *_Null_unspecified)getUserServerId;
-(NSString *_Null_unspecified)getDevicePushToken;
-(bool *_Null_unspecified)isInited;

-(void)Init;
-(id _Nonnull)initWithParameters :(NSString*_Nonnull)AppToken AppSecret:(NSString*_Nonnull)AppSecret SenderId:(NSString * _Nullable)SenderId;
-(void)SetBirthday:(int)dayBorn monthBorn:(int)monthBorn yearBorn:(int)yearBorn;
-(void)SetUserId:(NSString* _Null_unspecified)newUserId;

-(void)useNotifications :(bool )use;
-(void)SetDevicePushToken: (NSString* _Nonnull) token;
-(void)SetDevicePushTokenData: (NSData* _Nonnull) token;
-(void)OpenedFromPush :(NSDictionary * _Nonnull)data;

-(void)SetGender:(Gender *_Null_unspecified) newGender;
-(void)SetUserName: (NSString *_Null_unspecified)newUserName;
-(void)SetFacebookId:(NSString *_Null_unspecified)newFacebookId;
-(void)SendEvent: (NSString * _Nonnull)newId ;
-(void)SendEvent:(NSString * _Nonnull)newId data:(NSDictionary<NSString*,NSObject*>* _Nullable)data;
-(void)SendMonetaryEvent :(NSString* _Nonnull)productId price:(double )price currency:(NSString* _Nonnull)currency;

-(void)SessionStart;
-(void)SessionEnd;

+(Analytics * _Nonnull) getAnalytics;
+(void)RegisterNotifications;
@end


