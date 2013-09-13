//
//  WikipediaAPIClient.m
//  DonsDiscoveryApp
//
//  Created by ehochs  on 9/11/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "WikipediaAPIClient.h"
#import <AFJSONRequestOperation.h>

NSString * const kWikiBaseURLString = @"http://en.wikipedia.org";

@implementation WikipediaAPIClient

+(WikipediaAPIClient *)sharedClient {
    static WikipediaAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kWikiBaseURLString]];
    });
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;
    return self;
}
@end
