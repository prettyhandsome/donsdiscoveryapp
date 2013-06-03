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
    NSString *venueLat;
    NSString  *venueLong;
    
    
    CGPoint _originalCenter;
    WikiDragUpView *wikiView;
    CGPoint originalPoint; 

}

-(void)makeWikiURLRequest; 


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
    
    [self makeWikiURLRequest];
    //Set up properties for selected venue
    venueLat = _selectedVenue.venueLat;
    venueLong = _selectedVenue.venueLong;
    NSLog(@"detail venue lat is %@ and lng is %@",venueLat,venueLong);
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

#pragma mark JSON Wiki URL Request
-(void)makeWikiURLRequest {
    
      
    
    NSString *wikiURLString = [NSString stringWithFormat:@"http://api.wikilocation.org/articles?lat=45.55&lng=-86.65&limit=1"];
    
    wikiURLString = [wikiURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:wikiURLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
                               
                               
                               NSDictionary *resultsFromWiki= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               
                               
                            NSArray  *searchResultsArray=[resultsFromWiki objectForKey:@"articles"];
                               for (NSDictionary *dictionary in searchResultsArray) {
                                   
                                   NSString *articleID = [dictionary objectForKey:@"id"];
                                   NSString *articleTitle = [dictionary objectForKey:@"title"];
                                   NSString *wikiArticleURL = [dictionary objectForKey:@"url"];
                                   NSLog(@"the title is %@",articleTitle);
                               }
    
                           }];
    
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
        if (newCenter.y >= maxY +160 && newCenter.y <= 300) {
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
