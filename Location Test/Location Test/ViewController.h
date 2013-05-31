//
//  ViewController.h
//  Location Test
//
//  Created by Erin Hochstatter on 5/30/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *CurrentLatLabel;
@property (strong, nonatomic) IBOutlet UILabel *CurrentLngLabel;
- (IBAction)fakeSignInButton:(id)sender;

@end
