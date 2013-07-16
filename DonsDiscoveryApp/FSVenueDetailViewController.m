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
    
    NSString *venueName;
    NSString *venueLat;
    NSString  *venueLong;

    CGPoint _originalCenter;
    WikiDragUpView *wikiView;
    CGPoint originalPoint; 

    //ekh wiki search terms
    NSArray         *searchArray;
    NSMutableArray  *wikiSearchResultArray;
    //NSDictionary    *locationDictionary;
    NSMutableString *venueDetailsString;
   
}
@property (strong, nonatomic) NSString  *venueCity;
@property (strong, nonatomic) NSURL     * wikiFullURL;



//-(void)makeWikiURLRequest;
-(void)loadWikiCollectionView;
-(void) parseFoursquareForWikiSearchTags;

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
    //Set up properties for selected venue (                   ekh: these come from the prev. vc)
    venueLat = _selectedVenue.venueLat;
    venueLong = _selectedVenue.venueLong;
    //NSLog(@"detail venue lat is %@ and lng is %@",venueLat,venueLong);
    venueName= _selectedVenue.title;
    _venueNameLabel.text =venueName;
    
    
    //set Up Pan Gesture Recognizer
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setMinimumNumberOfTouches:1];
    
    [self.wikiBottomBarView addGestureRecognizer:panRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    wikiView = [[WikiDragUpView alloc]init];
    
    
    // set up original bounds for ImageView so it doesn't pass a specific height 
    originalPoint = self.wikiBottomBarView.center;
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
        
        //CGPoint translation = [panRecognizer translationInView:self.view];
        CGPoint imageViewPosition = originalPoint;
        //imageViewPosition.x -= translation.x;
        //  imageViewPosition.y -= translation.y;
        //
        //            if (imageViewPosition.y >= imageViewPosition.y && imageViewPosition.y <= 300) {
        //                panRecognizer.view.center = newCenter;
        //                [panRecognizer setTranslation:CGPointZero inView:self.view];
        //            }
        
        self.wikiBottomBarView.center = imageViewPosition;
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

    
    NSString *tappedVenueDetails= [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?v=20120321&oauth_token=%@", self.selectedVenue.venueID, foursquareClientID];
    NSLog(@"line 192: %@ <-- link with fs token?", tappedVenueDetails);
    
    NSURL *tappedVenueDetailsURL = [NSURL URLWithString:tappedVenueDetails];
    NSURLRequest *venueURLRequest = [NSURLRequest requestWithURL:tappedVenueDetailsURL];
    
    [NSURLConnection sendAsynchronousRequest:venueURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
                               
                               NSDictionary *completeVenueDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                 options:0 error:nil];
                               
                               NSDictionary *responseDictionary = [completeVenueDict objectForKey:@"response"];
                               NSDictionary *venueDictionary = [responseDictionary objectForKey:@"venue"];
                               NSString *venueCanonicalURL = [venueDictionary objectForKey:@"canonicalUrl"];
                               NSString *venueURL = [venueDictionary objectForKey: @"url"];
                               NSNumber *venueRating = [venueDictionary objectForKey:@"rating"];
                               NSString *venueDescription = [venueDictionary objectForKey:@"description"];
                               NSLog(@"canonical url:%@, url: %@, rating:%@, description:%@", venueCanonicalURL, venueURL, venueRating, venueDescription);
                               
                               NSDictionary *locationDictionary = [venueDictionary objectForKey:@"location"];
                               self.venueCity = [locationDictionary objectForKey:@"city"];
                               NSString *venueAddress = [locationDictionary objectForKey:@"address"];
                               NSString *venueCrossStreet = [locationDictionary objectForKey:@"crossStreet"];
                               NSLog(@"%@: %@, %@, %@", venueName, venueAddress, venueCrossStreet, self.venueCity);
                               
                               
                               NSDictionary  *contactDictionary = [venueDictionary objectForKey:@"contact"];
                               NSString *venueContact =[contactDictionary objectForKey:@"formattedPhone"];
                               NSLog(@"phone: %@", venueContact);
                               
                               NSDictionary *hoursDictionary = [venueDictionary objectForKey:@"hours"];
                               NSString *venueOpen = [hoursDictionary objectForKey:@"status"];
                               NSLog (@"is open: %@", venueOpen);
                               
                               
                               NSMutableArray *venueCategories = [locationDictionary objectForKey:@"categories"];
                            
    
                               if (venueOpen != nil){
                                   self.venueOpenLabel.text = venueOpen;
                               } else {
                                   self.venueOpenLabel.text =  @"No hour information listed for this venue.";
                               }
                               
                               if (venueURL != nil){
                                   self.venueURLLable.text = venueURL;
                               } else {
                                   self.venueURLLable.text = @"No website information available.";
                               }
                               
                               if (venueContact!= nil){
                                   self.VenuePhoneLabel.text = venueContact;
                               } else {
                                   self.VenuePhoneLabel.text = @"No phone number available.";
                               }
                               
                               if (venueRating != nil){
                                   NSString *venueRatingString = [venueRating stringValue];
                                   self.venueRatingLabel.text= venueRatingString;
                               } else {
                                   self.venueRatingLabel.text= @"This venue has not been rated.";}
                               
                               if (![venueCategories objectAtIndex:0] >=0){
                                   NSString *venueFirstCategory = [venueCategories objectAtIndex:0];
                                   NSLog(@"categories: %@",venueCategories);
                               } else {
                                   NSLog(@"categories: %@",venueCategories);}
                              
                               [self loadWikiCollectionView];
                               
                           }];

       NSLog(@"line 221:foursquareCity = %@", self.venueCity);}



-(void)loadWikiCollectionView
{
//this is a prime candidate for stuff to put on the not main thread.
    wikiSearchResultArray = [[NSMutableArray alloc] init];
    
    NSString *wikiConcantenateString = [NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query&prop=info&inprop=url&format=json&list=search&srsearch=%@ local", self.venueCity];
    
    NSString *wikiURLString = [wikiConcantenateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //change to tag or hard code an appropriate choice: arts cuisine events (by city)  beverages by country.
    

    NSURL *wikiSearchURL = [NSURL URLWithString:wikiURLString];
    NSURLRequest *wikiSearchRequest = [NSURLRequest requestWithURL:wikiSearchURL];
    NSLog(@"line 259:wikiSearchURL: %@",wikiSearchURL);
    
    
    [NSURLConnection sendAsynchronousRequest:wikiSearchRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error){
                               
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSDictionary *queryDictionary = [responseDictionary objectForKey:@"query"];
                               searchArray = [queryDictionary objectForKey:@"search"];
                               
                               
                               //i can't tell if this is a dictionary sorting issue - or whether it's a loading issue, as with the gallery.
                               //sortedWikiQueryArray = [[queryDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                                   //return ([obj1 compare:obj2] == NSOrderedDescending);
                               
                               for (NSDictionary *wikiSearchDictionary in searchArray) {
                                   
                                   FSVenueDetail_WikiObject *wikiObject = [[FSVenueDetail_WikiObject alloc] init];
                                   
                                   wikiObject.wikiTitle = [wikiSearchDictionary objectForKey:@"title"];
                                   
                                   NSString *wikiSearchByTitle = [NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@",wikiObject.wikiTitle];
                                   NSString *wikiTitleUrlString = [wikiSearchByTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                   wikiObject.wikiMainURL = [NSURL URLWithString:wikiTitleUrlString];

                                   [wikiSearchResultArray addObject: wikiObject];
                                   NSLog(@"%@", wikiSearchResultArray);
                                                                
                               }
                               [self.wikiCollectionView reloadData];
                               
                           }];
}


#pragma
#pragma mark CollectionView Setup


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSLog(@"venue detail vc: sections/view");
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"venue detail vc this logs the items in wiki section:%d", wikiSearchResultArray.count);
    return wikiSearchResultArray.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FSVenueDetail_WikiCell *wikiCollCell = [self.wikiCollectionView dequeueReusableCellWithReuseIdentifier: @"wikiCell" forIndexPath:indexPath];
    //the documentation says that if you dequeue, the cell will never be nil, so i removed the if cell = nil part.

    FSVenueDetail_WikiObject *wikiCellObject = [wikiSearchResultArray objectAtIndex:indexPath.item];
    
    NSURLRequest *wikiSelectionRequest = [NSURLRequest requestWithURL:wikiCellObject.wikiMainURL];
    NSString *wikiFirstPara =[wikiCollCell.wikiWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('p')[0].textContent"];
    [wikiCollCell.wikiWebView loadRequest:wikiSelectionRequest];
        
    NSLog(@"%@", wikiFirstPara);
    
    wikiCollCell.wikiLabel.text = wikiCellObject.wikiTitle;
        wikiCollCell.wikifirstParaText.text = wikiFirstPara;


    return wikiCollCell;

}



@end
