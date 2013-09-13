//
//  WikipediaAPIClient.h
//  DonsDiscoveryApp
//
//  Created by ehochs  on 9/11/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>


@interface WikipediaAPIClient : AFHTTPClient

+(WikipediaAPIClient *)sharedClient;

@end
