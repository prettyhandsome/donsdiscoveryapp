//
//  WikiCollectionFlowLayoutAttributes.m
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 7/31/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "WikiCollectionFlowLayoutAttributes.h"

@implementation WikiCollectionFlowLayoutAttributes
-(id)copyWithZone:(NSZone *)zone
{
    WikiCollectionFlowLayoutAttributes *attributes = [super copyWithZone:zone];
    
    attributes.shouldRasterize = self.shouldRasterize;
    attributes.maskingValue = self.maskingValue;
    
    return attributes;
}
@end
