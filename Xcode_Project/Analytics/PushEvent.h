//
//  PushEvent.h
//  app-preview
//
//  Created by User on 10/19/16.
//  Copyright © 2016 Yerchick. All rights reserved.
//

#import "BaseRequest.h"

@interface PushEvent : BaseRequest
{
	int _type;
	int _id;
}
-(id)initWithString:(int )_Id type:(int )type;
-(NSMutableDictionary<NSString *, NSObject *> *)GenerateData;
//-(bool) AuthenticationRequired;
@end
