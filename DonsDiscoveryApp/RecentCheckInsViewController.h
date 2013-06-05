//
//  RecentCheckInsViewController.h
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 6/3/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSquareVenue.h"

@interface RecentCheckInsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *checkinTableView;
@property (strong,nonatomic) FourSquareVenue *selectedVenue; 

@end
