//
//  SetPushToken.h
//  app-preview
//
//  Created by User on 10/18/16.
//  Copyright © 2016 Yerchick. All rights reserved.
//

#import "BaseRequest.h"

@interface SetPushToken : BaseRequest
{
    NSString * _token;
}


-(id)initWithString:(NSString *)token;
-(bool) AuthenticationRequired;

-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData;

@end
