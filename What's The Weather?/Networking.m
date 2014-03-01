//
//  Networking.m
//  What's The Weather?
//
//  Created by Mark Meyer on 3/1/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "Networking.h"

@implementation Networking

// -----------------------------------------------------------------------------
#pragma mark - Initialization
// -----------------------------------------------------------------------------
+ (id)sharedNetworking
{
    static dispatch_once_t pred;
    static Networking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if ( self = [super init] ) {
        
    }
    return self;
}

#pragma - Requests

- (void)getWeatherForURL:(NSString*)url
                 success:(void (^)(NSDictionary *dict, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     
                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     
                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                     if (httpResp.statusCode == 200) {
                                         NSError *jsonError;
                                         
                                         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                         
                                         NSLog(@"DownloadeData:%@",dict);
                                         
                                         successCompletion(dict,nil);
                                     } else {
                                         NSLog(@"Fail Not 200:");
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (failureCompletion) failureCompletion();
                                         });
                                     }
                                 }] resume];
}

@end
