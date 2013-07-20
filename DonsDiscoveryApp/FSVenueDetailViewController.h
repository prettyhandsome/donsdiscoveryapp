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

@interface FSVenueDetailViewController : UIViewController <UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (strong, nonatomic) FourSquareVenue *selectedVenue; 
@property (strong, nonatomic) IBOutlet UILabel *venueOpenLabel;
@property (strong, nonatomic) IBOutlet UITextView *venueURLView;
@property (strong, nonatomic) IBOutlet UITextView *locationTextView;
@property (strong, nonatomic) IBOutlet UITextView *phoneTextVIew;
@property (strong, nonatomic) IBOutlet UILabel *venueRatingLabel;


@property (weak, nonatomic) IBOutlet UIImageView *wikiBottomBarImage;
@property (strong, nonatomic) IBOutlet UIView *wikiBottomBarView;

@property (strong, nonatomic) IBOutlet UICollectionView *wikiCollectionView;
@end
