//
//  SourceURLTags.h
//  2013-05-28
//
//  Created by Erin Hochstatter on 5/28/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceURLTags : NSObject

@property (strong, nonatomic) NSString *idForTag;
@property (strong, nonatomic) NSString *secretForTag;
@property (strong, nonatomic) NSString *serverForTag;
@property (strong, nonatomic) NSString *farmForTag;
@property (strong, nonatomic) NSString *urlStringForTag;
@property (strong, nonatomic) NSString *titleForTag;

// accuracy=11 // has_geo=1, geo_context=2 (optional - outdoors only=2 ),

// has_geo=1 in URL string in FlickrViewController.m


@end
