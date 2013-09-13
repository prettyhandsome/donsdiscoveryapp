//
//  FSVenueDetail-WikiObject.h
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 6/4/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSVenueDetail_WikiObject : NSObject

@property (strong, nonatomic) NSString * wikiTitle;
@property (strong, nonatomic) NSURL *wikiMainURL;
@property (strong, nonatomic) NSMutableAttributedString *wikiSnippetString;

@end
