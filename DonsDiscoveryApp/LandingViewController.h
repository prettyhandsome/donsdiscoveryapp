//
//  LandingViewController.h
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 5/31/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingViewController : UIViewController<UIWebViewDelegate>

//web login properties
@property (strong, nonatomic) IBOutlet UIWebView *loginWebView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//tableview
@property (strong, nonatomic) IBOutlet UITableView *landingOptionsTableView;

@end
