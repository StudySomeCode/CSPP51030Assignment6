//
//  Networking.h
//  What's The Weather?
//
//  Created by Mark Meyer on 3/1/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject

+ (id)sharedNetworking;

- (void)getWeatherForURL:(NSString*)url
                 success:(void (^)(NSDictionary *dict, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion;
@end
