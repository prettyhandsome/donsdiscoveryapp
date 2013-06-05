//
//  FSVenueDetail-WikiCell.h
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 6/4/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSVenueDetail_WikiCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIWebView *wikiWebView;
@property (strong, nonatomic) IBOutlet UILabel *wikiLabel;
@property (strong, nonatomic) IBOutlet UITextView *wikifirstParaText;


@end
