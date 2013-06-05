//
//  FSVenueDetailViewController.h
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 6/2/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrTappedViewController.h"
#import "FourSquareVenue.h"
#import "WikiDragUpView.h"
#import "FSVenueDetail-WikiCell.h"
#import "FSVenueDetail-WikiObject.h"

@interface FSVenueDetailViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (strong, nonatomic) FourSquareVenue *selectedVenue; 
@property (strong, nonatomic) IBOutlet UILabel *websiteLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *openLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *wikiBottomBarImage;

@property (strong, nonatomic) IBOutlet UICollectionView *wikiCollectionView;
@end
