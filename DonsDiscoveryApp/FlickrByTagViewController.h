//
//  FlickrByTagViewController.h
//  2013-05-28
//
//  Created by Erin Hochstatter on 5/28/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrByTagViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSString *tagText;
@property  (strong, nonatomic) NSMutableArray *taggedImagesArray;

@property (strong, nonatomic) IBOutlet UICollectionView *taggedItemsCollectionView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *suggestionView;
@property (strong, nonatomic) IBOutlet UILabel *suggestionViewLabel;

@end
