//
//  Singleton.h
//  app-preview
//
//  Created by Yerchick on 8/16/16.
//  Copyright © 2016 Yerchick. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h


#endif /* Singleton_h */


@interface Singleton : NSObject {
    NSString *string;
}


@property (nonatomic, retain) NSString *string;

+(Singleton *)Instance;
-(id)test;

@end