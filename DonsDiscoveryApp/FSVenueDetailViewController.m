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
    NSMutableString *venueDetailsString = [[NSMutableString alloc] init];
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
    //please put me on another queue
    
    NSString *foursquareClientID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]mutableCopy];

    
    NSString *tappedVenueDetails= [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?v=20120321&oauth_token=%@", self.selectedVenue.venueID, foursquareClientID];
    NSLog(@"line 192: %@ <-- link with fs token?", tappedVenueDetails)
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
                               NSDictionary* locationDictionary = [venueDictionary objectForKey:@"location"];
                               NSString *venueURL = [venueDictionary objectForKey:@"canonicalUrl"];
                               
                               self.venueCity = [locationDictionary objectForKey:@"city"];
                               
                
                               NSString *venueOpen = [[locationDictionary objectForKey:@"hours"] objectForKey:@"status"];
                               NSString *venueContact =[[locationDictionary objectForKey:@"contact"] objectForKey:@"formattedPhone"];
                               NSString *venueRating = [locationDictionary objectForKey:@"rating"];
                               NSMutableArray *venueCategories = [locationDictionary objectForKey:@"categories"];
                              
                               
                               if (venueOpen != nil) {
                                   [venueDetailsString appendString:venueOpen];
                               }else {
                                   NSLog(@"no hours info");
                                   
                               if (venueURL != nil) {
                                   [venueDetailsString appendString:venueURL];
                               } else {
                                   NSLog(@"no url");
                               }
                               
                               if (venueOpen != nil) {
                                   [venueDetailsString appendString:venueOpen];
                               }else {
                                   NSLog(@"no hours info");
                                   
                               self.phoneLabel.text = venueContact;
                               self.ratingLabel.text = venueRating;
                               if (![venueCategories objectAtIndex:0] >=0) {
                                   NSString *venueFirstCategory = [venueCategories objectAtIndex:0];
                                   self.categoryLabel.text = venueFirstCategory;}
// for each of theset things that are not nil, append them to a string followed by \n
                               
                               if (venueURL == nil) {
                                   NSLog(@"crazy");
                               }
                               NSLog(@"line 228:VenueWebsite label: %@", venueURL);
                               [self loadWikiCollectionView];
                           }];

    // runs this first, skipping the NSURLConnection, when called in VDL. Returns to VDL to load wiki for the first time (generic search) as part of the tableview creation before being populated. So, i have to load the connection view in the block or the wiki won't load with the data.  I tried placing this method in the init, to run it before VDL, but the VDL methods were faster. 
    
    NSLog(@"line 234:foursquareCity = %@", self.venueCity);

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
    NSLog(@"line 251:wikiSearchURL: %@",wikiSearchURL);
    
    
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
                                   
                                   FSVenueDetail_WikiObject *cellWikiObject = [[FSVenueDetail_WikiObject alloc] init];
                                   
                                   
                                   cellWikiObject.wikiTitle = [wikiSearchDictionary objectForKey:@"title"];
                                
                                   [wikiSearchResultArray addObject: cellWikiObject];
                                                                
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
    
    NSLog(@"venue detail vc this logs the items in section:%d", wikiSearchResultArray.count);
    return wikiSearchResultArray.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FSVenueDetail_WikiCell *wikiCell = [self.wikiCollectionView dequeueReusableCellWithReuseIdentifier: @"wikiCell" forIndexPath:indexPath];
    //the documentation says that if you dequeue, the cell will never be nil, so i removed the if cell = nil part.
    
    FSVenueDetail_WikiObject *wikiObject = [wikiSearchResultArray objectAtIndex:indexPath.item];
    
    wikiCell.wikiLabel.text = wikiObject.wikiTitle;
    NSString *wikiSearchByTitle = [NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@",wikiObject.wikiTitle];
    NSString *wikiTitleUrlString = [wikiSearchByTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.wikiFullURL = [NSURL URLWithString:wikiTitleUrlString];
    
    NSURLRequest *wikiSelectionRequest = [NSURLRequest requestWithURL:self.wikiFullURL];
    NSString *wikiFirstPara =[wikiCell.wikiWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('p')[0].textContent"];
    [wikiCell.wikiWebView loadRequest:wikiSelectionRequest];
    wikiCell.wikifirstParaText.text = wikiFirstPara;
    NSLog(@"%@", wikiFirstPara);
    

    
        return wikiCell;
   
}


@end
