//
//  SetPropertiesRequest.h
//  Analytics
//
//  Created by User on 12/22/16.
//  Copyright © 2016 Gravitum. All rights reserved.
//

#import "BaseRequest.h"

@interface SetPropertiesRequest : BaseRequest
{
	NSDictionary<NSString *, NSObject *> * properties;
}
-(id)initWithProperties:(NSDictionary<NSString *, NSObject *> *)newProperties;
-(NSDictionary<NSString *, NSObject *> *)GenerateData;
-(bool) AuthenticationRequired;

@end
