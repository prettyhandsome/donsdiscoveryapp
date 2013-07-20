//
//  WikiCollectionFlowLayout.m
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 7/19/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "WikiCollectionFlowLayout.h"

@implementation WikiCollectionFlowLayout


-(CGSize)collectionViewContentSize
    {
        return CGSizeMake(self.collectionView.frame.size.width,
     self.collectionView.frame.size.height) ;
    }


@end
