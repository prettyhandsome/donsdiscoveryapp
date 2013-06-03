//
//  FSVenueDetailViewController.m
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 6/2/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "FSVenueDetailViewController.h"


@interface FSVenueDetailViewController ()
{
    
    NSString *venueID;
    NSString *venueName;
    CGPoint _originalCenter;
    WikiDragUpView *wikiView;
    CGPoint originalPoint; 

}


@end

@implementation FSVenueDetailViewController
@synthesize wikiBottomBarImage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    venueName= _selectedVenue.title;
    _venueNameLabel.text =venueName;
    
    //set Up Pan Gesture Recognizer
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setMinimumNumberOfTouches:1];
    
    [self.wikiBottomBarImage addGestureRecognizer:panRecognizer];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    WikiDragUpView *wikiView = [[WikiDragUpView alloc]init];
    
    
    // set up original bounds for ImageView so it doesn't pass a specific height 
    originalPoint = wikiBottomBarImage.center; 
    CGFloat maxY = wikiView.frame.origin.y;
    

    if ( panRecognizer.state == UIGestureRecognizerStateBegan || panRecognizer.state == UIGestureRecognizerStateChanged) {
        
        // set up the translation or new coordinates for the ImageView. Notice I only added a "translation" to the y coordinates since we are not adjusting the X coordinates 
        CGPoint translation = [panRecognizer translationInView:self.view];
        CGPoint newCenter = CGPointMake(self.view.bounds.size.width / 2,
                                        panRecognizer.view.center.y + translation.y);
        
        // Set up height limit
        if (newCenter.y >= maxY +90 && newCenter.y <= 300) {
            panRecognizer.view.center = newCenter;
            [panRecognizer setTranslation:CGPointZero inView:self.view];
        }
        
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        // GO over this with Don or Keith or someone! 
        NSLog(@"its over");
        //            [self.view sendSubviewToBack:myImage];
        //            [UIView animateWithDuration:.2 animations:^{
        //                self.myImage.transform = CGAffineTransformIdentity;
        //            }];
        
        CGPoint translation = [panRecognizer translationInView:self.view];
        CGPoint imageViewPosition = originalPoint;
        //imageViewPosition.x -= translation.x;
        //  imageViewPosition.y -= translation.y;
        //
        //            if (imageViewPosition.y >= imageViewPosition.y && imageViewPosition.y <= 300) {
        //                panRecognizer.view.center = newCenter;
        //                [panRecognizer setTranslation:CGPointZero inView:self.view];
        //            }
        
        wikiBottomBarImage.center = imageViewPosition;
        [panRecognizer setTranslation:CGPointZero inView:self.view];
    }
    
    
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
