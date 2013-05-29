//
//  FlickrByLocViewController.h
//  2013-05-28
//
//  Created by Erin Hochstatter on 5/29/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrByLocViewController : UICollectionViewController

@property (strong, nonatomic) NSString *locText;
@property (strong, nonatomic) NSString *latitudeInput;
@property (strong, nonatomic) NSString *longitudeInput;
@property  (strong, nonatomic) NSMutableArray *locationImagesArray;

@property (strong, nonatomic) IBOutlet UICollectionView *flickrByLocationCollectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *locViewActivityIndicator;


@end
