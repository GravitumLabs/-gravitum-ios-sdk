#import <Foundation/Foundation.h>

@interface Settings : NSObject
{
    NSString * SettingsPath;
    NSString * SettingsAssetName;
    NSString * SettingsAssetExtension;
    
    NSString * SDKVersion;
    
    bool TrackSessionDuration;
    NSString * AppToken;
    NSString * AppSecret;
    NSString * MessagingId;
    
    bool DebugLogs;
}

+(Settings *)getSettings;

-(void)setAppToken : (NSString*)newAppToken;
-(void)setAppSecret : (NSString*)newSecret;
-(void)setSenderId : (NSString*)newId;
-(void)setDebugLogs : (bool)enable;

-(bool) DebugLogs;
-(bool )getTackSessionDuration;
-(NSString *)getAppToken;
-(NSString *)getAppSecret;
-(NSString *)getMessagingId;



@end
