//
//  WikiCollectionFlowLayout.m
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 7/19/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "WikiCollectionFlowLayout.h"
#import "FSVenueDetail-WikiCell.h"
#import "WikiCollectionFlowLayoutAttributes.h"

#define ACTIVE_DISTANCE         80
#define TRANSLATE_DISTANCE      80
#define ZOOM_FACTOR             0.2f
#define FLOW_OFFSET             5  //space between the cells in flow view
#define INACTIVE_GREY_VALUE     0.3f

@implementation WikiCollectionFlowLayout

#pragma mark - Overridden Methods



-(void)prepareLayout
{
    // Set up our basic properties
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.itemSize = CGSizeMake(260, 120);
    self.minimumLineSpacing = -5;      // Gets items up close to one another
    self.minimumInteritemSpacing = 200; // Makes sure we only have 1 row of items in portrait mode
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    // Very important — needed to re-layout the cells when scrolling.
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    for (UICollectionViewLayoutAttributes* attributes in layoutAttributesArray)
    {
        // We're going to calculate the rect of the collection view visible to the user.
        // That way, we can avoid laying out cells that are not visible.
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            [self applyLayoutAttributes:attributes forVisibleRect:visibleRect];
        }
    }
    
    return layoutAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    // We're going to calculate the rect of the collection view visible to the user.
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    
    [self applyLayoutAttributes:attributes forVisibleRect:visibleRect];
    
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // Returns a point where we want the collection view to stop scrolling at.
    
    // First, calculate the proposed center of the collection view once the collection view has stopped
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat verticalCenter = ((proposedContentOffset.y) + (CGRectGetHeight(self.collectionView.bounds) )/ 2.0)-30;
    // Use the center to find the proposed visible rect.
    CGRect proposedRect = CGRectMake(10.0, proposedContentOffset.y-60, self.collectionView.bounds.size.width, (self.collectionView.bounds.size.height));
    // Get the attributes for the cells in that rect.
    NSArray* array = [self layoutAttributesForElementsInRect:proposedRect];
    
    // This loop will find the closest cell to proposed center of the collection view
    for (UICollectionViewLayoutAttributes* layoutAttributes in array)
    {
        // We want to skip supplementary views
        if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell)
            continue;
        
        // Determine if this layout attribute's cell is closer than the closest we have so far
        CGFloat itemVerticalCenter = layoutAttributes.center.y;
        if (fabsf(itemVerticalCenter - verticalCenter) < fabsf(offsetAdjustment))
        {
            offsetAdjustment = itemVerticalCenter - verticalCenter;
        }
    }
    
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offsetAdjustment);
}


#pragma mark - Private Custom Methods

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes forVisibleRect:(CGRect)visibleRect
{
    // Applies the cover flow effect to the given layout attributes.
    
    // We want to skip supplementary views.
    if (attributes.representedElementKind) return;
    
    // Calculate the distance from the center of the visible rect to the center of the attributes.
    // Then normalize it so we can compare them all. This way, all items further away than the
    // active get the same transform.
    CGFloat distanceFromVisibleRectToItem = CGRectGetMidY(visibleRect) - attributes.center.y;
    CGFloat normalizedDistance = distanceFromVisibleRectToItem / ACTIVE_DISTANCE;
    BOOL isBottom = distanceFromVisibleRectToItem > 0;
    CATransform3D transform = CATransform3DIdentity;
    
    CGFloat maskAlpha = 0.0f;
    
    if (fabsf(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE)
    {
        // We're close enough to apply the transform in relation to
        // how far away from the center we are.
        
        
        transform = CATransform3DTranslate(CATransform3DIdentity, 0, (isBottom? - FLOW_OFFSET : FLOW_OFFSET)*ABS(distanceFromVisibleRectToItem/TRANSLATE_DISTANCE), (1 - fabsf(normalizedDistance)) * 40000 + (isBottom? 200 : 0));
        
        // Set the perspective of the transform.
        transform.m34 = -1/(4.6777 * self.itemSize.height);
        
        // Set the zoom factor.
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        transform = CATransform3DRotate(transform, 0,(isBottom? 1 : -1) * fabsf(normalizedDistance) * 45 * M_PI / 180, 1, 0);
        transform = CATransform3DScale(transform, zoom, zoom, 1);
        attributes.zIndex = 1;
        
        CGFloat ratioToCenter = (ACTIVE_DISTANCE - fabsf(distanceFromVisibleRectToItem)) / ACTIVE_DISTANCE;
        // Interpolate between 0.0f and INACTIVE_GREY_VALUE
        maskAlpha = INACTIVE_GREY_VALUE + ratioToCenter * (-INACTIVE_GREY_VALUE);
    }
    else
    {
        // We're too far away - just apply a standard perspective transform.
        
        transform.m34 = -1/(4.6777 * self.itemSize.height);
        transform = CATransform3DTranslate(transform, 0, isBottom? -FLOW_OFFSET : FLOW_OFFSET, 0);
        transform = CATransform3DRotate(transform, 1, (isBottom? 1 : -1) * 45 * M_PI / 180, 0, 0);
        attributes.zIndex = 0;
        
        maskAlpha = INACTIVE_GREY_VALUE;
    }
    
    attributes.transform3D = transform;
    
    // Rasterize the cells for smoother edges.
    //[(WikiCollectionFlowLayoutAttributes *)attributes setShouldRasterize:YES];
    //[(WikiCollectionFlowLayoutAttributes *)attributes setMaskingValue:maskAlpha];
}

@end












