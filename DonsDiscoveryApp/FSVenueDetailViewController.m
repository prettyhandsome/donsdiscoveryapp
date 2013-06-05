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

    //ekh wiki search terms
    NSArray *searchArray;
    NSMutableArray *wikiSearchResultArray;
    NSDictionary *locationDictionary;
   
}
@property (strong, nonatomic) NSString *venueCity;

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
    
    [self parseFoursquareForWikiSearchTags];

    
    //[self makeWikiURLRequest];
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
//-(void)makeWikiURLRequest {
//    
//      
//    
//    NSString *wikiURLString = [NSString stringWithFormat:@"http://api.wikilocation.org/articles?lat=45.55&lng=-86.65&limit=1"];
//    
//    wikiURLString = [wikiURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSURL *url = [NSURL URLWithString:wikiURLString];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    
//    [NSURLConnection sendAsynchronousRequest:urlRequest
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
//                               
//                               
//                               NSDictionary *resultsFromWiki= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                               
//                               
//                            NSArray  *searchResultsArray=[resultsFromWiki objectForKey:@"articles"];
//                               for (NSDictionary *dictionary in searchResultsArray) {
//                                   
//                                   NSString *articleID = [dictionary objectForKey:@"id"];
//                                   NSString *articleTitle = [dictionary objectForKey:@"title"];
//                                   NSString *wikiArticleURL = [dictionary objectForKey:@"url"];
//                                   NSLog(@"the title is %@",articleTitle);
//                               }
//    
//                           }];
//    
//}



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
        if (newCenter.y >= maxY + 90 && newCenter.y <= 300) {
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

#pragma 
#pragma ekh WikiStuff

-(void) parseFoursquareForWikiSearchTags{
    
    
    NSString *foursquareClientID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]mutableCopy];

    
    //    If I can add Venue ID to the items passed over in the venue class then I can search by VenueID, scrape the city and the category.
    NSString *tappedVenueDetails= [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/40a55d80f964a52020f31ee3?oauth_token=%@",foursquareClientID];
    NSLog(@"%@ <-- link with fs token?", tappedVenueDetails)
    ;
    
    NSURL *tappedVenueDetailsURL = [NSURL URLWithString:tappedVenueDetails];
    NSURLRequest *venueURLRequest = [NSURLRequest requestWithURL:tappedVenueDetailsURL];
    
    [NSURLConnection sendAsynchronousRequest:venueURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
                               
                               NSDictionary *completeVenueDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                 options:0 error:nil];
                               
                               NSDictionary *responseDictionary = [completeVenueDict objectForKey:@"response"];
                               NSDictionary *venueDictionary = [responseDictionary objectForKey:@"venue"];
                               locationDictionary = [venueDictionary objectForKey:@"location"];
                               
                               self.venueCity = [locationDictionary objectForKey:@"city"];
                               NSString *venueURL = [locationDictionary objectForKey:@"url"];
                               
                               NSString *venueOpen = [[locationDictionary objectForKey:@"hours"] objectForKey:@"status"];
                               NSString *venueContact =[[locationDictionary objectForKey:@"contact"] objectForKey:@"formattedPhone"];
                               NSString *venueRating = [locationDictionary objectForKey:@"rating"];
                               NSMutableArray *venueCategories = [locationDictionary objectForKey:@"categories"];
                              
                               //throw this one level out?
                               NSLog(@"foursquareCity = %@", self.venueCity);
                               [self loadWikiCollectionView];
                               self.websiteLabel.text = venueURL;
                               self.openLabel.text = venueOpen;
                               self.phoneLabel.text = venueContact;
                               self.ratingLabel.text = venueRating;
                               if (![venueCategories objectAtIndex:0] >=0) {
                                   NSString *venueFirstCategory = [venueCategories objectAtIndex:0];
                                   self.categoryLabel.text = venueFirstCategory;}


                           }];
    
    }

-(void)loadWikiCollectionView
{
//this is a prime candidate for stuff to put on the not main thread. 
    wikiSearchResultArray = [[NSMutableArray alloc] init];
    
    NSString *wikiConcantenateString = [NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query&prop=info&inprop=url&format=json&list=search&srsearch=%@ sculpture", self.venueCity];
    
    NSString *wikiURLString = [wikiConcantenateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //change to tag or hard code an appropriate choice: arts cuisine events (by city)  beverages by country.
    

    NSURL *wikiSearchURL = [NSURL URLWithString:wikiURLString];
    NSURLRequest *wikiSearchRequest = [NSURLRequest requestWithURL:wikiSearchURL];
    NSLog(@"url searchURL: %@",wikiSearchURL);
    
    
    [NSURLConnection sendAsynchronousRequest:wikiSearchRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error){
                               
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSDictionary *queryDictionary = [responseDictionary objectForKey:@"query"];
                               searchArray = [queryDictionary objectForKey:@"search"];
                               
                               for (NSDictionary *wikiSearchDictionary in searchArray) {
                                   
                                   FSVenueDetail_WikiObject *wikiObject = [[FSVenueDetail_WikiObject alloc] init];
                                   
                                   wikiObject.wikiTitle = [wikiSearchDictionary objectForKey:@"title"];
                                   
                                   NSString *wikiSearchByTitle = [NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@",wikiObject.wikiTitle];
                                   NSString *wikiTitleUrlString = [wikiSearchByTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                   wikiObject.wikiFullURL = [NSURL URLWithString:wikiTitleUrlString];
                                   
                                   [wikiSearchResultArray addObject: wikiObject];
                                   NSLog (@"wikipedia entries in array: %d", wikiSearchResultArray.count);
                                                                
                               }
                               [self.wikiCollectionView reloadData];
                               
                           }];
}

#pragma
#pragma mark CollectionView Setup


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSLog(@"this logs the sections in view");
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"this logs the items in section:%d", wikiSearchResultArray.count);
    return wikiSearchResultArray.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FSVenueDetail_WikiCell *wikiCell = [self.wikiCollectionView dequeueReusableCellWithReuseIdentifier: @"wikiCell" forIndexPath:indexPath];
    //the documentation says that if you dequeue, the cell will never be nil, so i removed the if cell = nil part.
    
    FSVenueDetail_WikiObject *wikiObject = [wikiSearchResultArray objectAtIndex:indexPath.row];
    wikiCell.wikiLabel.text = wikiObject.wikiTitle;
    
    NSURLRequest *wikiSelectionRequest = [NSURLRequest requestWithURL:wikiObject.wikiFullURL];
    NSString *wikiFirstPara =[wikiCell.wikiWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('p')[0].textContent"];
    NSLog(@"%@", wikiFirstPara);
    [wikiCell.wikiWebView loadRequest:wikiSelectionRequest];
    
    wikiCell.wikifirstParaText.text = wikiFirstPara;
    
        return wikiCell;
   
}


@end
