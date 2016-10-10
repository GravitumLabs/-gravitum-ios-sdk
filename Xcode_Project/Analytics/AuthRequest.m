#import "AuthRequest.h"
#import "Analytics.h"

@implementation AuthRequest

NSString *const AuthPackId = @"Auth";


-(id)initWithString{
    return [super initWithString:AuthPackId];
}

-(void)Send{
    WebServer * ws = [WebServer getWebServer];
    [ws Send:self];
}

-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData{
    if([[Settings getSettings] DebugLogs])
        NSLog(@"Generating data in AuthRequest");
    NSMutableDictionary<NSString*, NSObject *> * OriginalJSON = [[NSMutableDictionary<NSString*, NSObject *> alloc] init];
    
    Analytics *analytics = [Analytics getAnalytics];
    
    Gender gen = (Gender)[analytics getUserGender];
    NSString * gender = nil;
    switch (gen) {
        case Male:
        gender = @"Male";
            break;
        case Female:
            gender = @"Female";
            break;
        case Unknown:
            gender = @"Undnown";
            break;
        default:
            break;
    }
    
    double secsUtc1970 = [[analytics getBirthday] timeIntervalSince1970];
    [OriginalJSON setValue: [NSNumber numberWithInt:(int)secsUtc1970] forKey:@"user_birthday"];
    [OriginalJSON setValue: [analytics getUserId] forKey:@"user_id"];
    [OriginalJSON setValue: [NSNumber numberWithInt:(int)[analytics getUserGender]] forKey:@"user_gender"];
    [OriginalJSON setValue: [analytics getUserName]  forKey:@"user_name"];
    [OriginalJSON setValue: [analytics getFacebookId]  forKey:@"user_facebook_id"];
    [OriginalJSON setValue: [[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [OriginalJSON setValue: [analytics getDeviceGcmId] forKey:@"device_push_token"];
    [OriginalJSON setValue: [NSString stringWithFormat:@"%f", [[UIScreen mainScreen] bounds].size.height] forKey:@"device_height"];
    [OriginalJSON setValue: [NSString stringWithFormat:@"%f", [[UIScreen mainScreen] bounds].size.width] forKey:@"device_width"];
    [OriginalJSON setValue: [NSNumber numberWithInt:1] forKey:@"device_os"];
    [OriginalJSON setValue: [[UIDevice currentDevice] systemVersion] forKey:@"device_os_version"];
    [OriginalJSON setValue: [[UIDevice currentDevice] model] forKey:@"device_model"];
    [OriginalJSON setValue: @"" forKey:@"device_manufacturer"];
    [OriginalJSON setValue: [[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"device_language"];
    [OriginalJSON setValue:[NSNumber numberWithInt:(int)[[NSTimeZone  localTimeZone] secondsFromGMT]] forKey:@"device_timezone"];
    
    

    return OriginalJSON;
}


-(bool) AuthenticationRequired{
    return false;
}

@end
