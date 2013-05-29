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


@end
