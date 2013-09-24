//
//  FSVenueDetailViewController.m
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 6/2/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "FSVenueDetailViewController.h"
#import "WikipediaAPIClient.h"
#import <AFNetworking.h>

static NSString *CellIdentifier = @"CellIdentifier";

@interface FSVenueDetailViewController ()
{
    
    NSString *venueName;
    NSString *venueLat;
    NSString  *venueLong;

    CGPoint _originalCenter;
    WikiDragUpView *wikiView;
    CGPoint originalPoint;

    //ekh wiki search terms
    NSArray             *searchArray;
    NSMutableArray      *wikiSearchResultArray;
    //NSDictionary      *locationDictionary;
    NSString            *venueFirstCategory;
   
}
@property (strong, nonatomic) NSString  *venueCity;
@property (strong, nonatomic) NSURL     * wikiFullURL;
@property (nonatomic, strong) NSOperationQueue *wikiQueue;





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
    //Set up properties for selected venue (ekh: these come from the prev. vc)
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
    
    self.wikiQueue = [[NSOperationQueue alloc] init];self.wikiQueue.maxConcurrentOperationCount = 3;
    
    // Register our classes so we can use our custom subclassed cell and header
    //[self.wikiCollectionView setCollectionViewLayout:wikiLayout animated:NO];
    [self.wikiCollectionView registerClass:[FSVenueDetail_WikiCell class] forCellWithReuseIdentifier:CellIdentifier];
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
    //ekh - I changed this to no, so that this gesture recognizer was not being activated when you interacted with the collection view. 
    return NO;
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
                               if (venueCrossStreet==nil) {
                                   venueCrossStreet = @"";
                               }
                               NSMutableString *venueAddressString = [NSMutableString stringWithFormat:@"%@, %@ \n%@", venueAddress, self.venueCity, venueCrossStreet];
                               self.locationTextView.text = venueAddressString;
                               
                               
                               
                               NSDictionary  *contactDictionary = [venueDictionary objectForKey:@"contact"];
                               NSString *venueContact =[contactDictionary objectForKey:@"formattedPhone"];
                               NSLog(@"phone: %@", venueContact);
                               
                               NSDictionary *hoursDictionary = [venueDictionary objectForKey:@"hours"];
                               NSString *venueOpen = [hoursDictionary objectForKey:@"status"];
                               NSLog (@"is open: %@", venueOpen);
                               
                               
                               NSMutableArray *venueCategories = [venueDictionary objectForKey:@"categories"];
                               if ([venueCategories count] !=0){
                               //if ([venueCategories objectAtIndex:0] != nil){
                                   NSDictionary *venueCat1Dict = [venueCategories objectAtIndex:0];
                                   venueFirstCategory = [venueCat1Dict objectForKey:@"name"];
                                   NSLog(@"categories: %@",venueCategories);
                               } else {
                                   NSLog(@"no categories");}
                            
    
                               if (venueOpen != nil){
                                   self.venueOpenLabel.text = venueOpen;
                               } else {
                                   self.venueOpenLabel.text =  @"No hour information listed for this venue.";
                               }
                               
                               if (venueURL != nil){
                                   self.venueURLView.text = venueURL;
                               } else {
                                   self.venueURLView.text = @"No website information available.";
                               }
                               
                               if (venueContact!= nil){
                                   self.phoneTextVIew.text = venueContact;
                               } else {
                                   self.phoneTextVIew.text = @"No phone number available.";
                               }
                               
                               if (venueRating != nil){
                                   NSString *venueRatingString = [venueRating stringValue];
                                   self.venueRatingLabel.text= venueRatingString;
                               } else {
                                   self.venueRatingLabel.text= @"This venue has not been rated.";}
                               
                              
                               [self loadWikiCollectionView];
                               
                           }];

       NSLog(@"line 221:foursquareCity = %@", self.venueCity);}



-(void)loadWikiCollectionView
{
//this is a prime candidate for stuff to put on the not main thread.
    wikiSearchResultArray = [[NSMutableArray alloc] init];

    // 1 - Create API client
    WikipediaAPIClient *client = [WikipediaAPIClient sharedClient];
    
    // 2 - Create API query request
    NSString *wikiConcantenateString = [NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query&prop=info&inprop=url&format=json&list=search&srsearch=%@ %@", self.venueCity, venueFirstCategory];

    NSString *wikiPath = [wikiConcantenateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest* request = [client requestWithMethod:@"GET" path:wikiPath parameters:nil];

    // 3 - Create JSON request operation
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
       
        // 3a - Request succeeded block

        NSDictionary *responseDictionary = JSON;
        NSDictionary *queryDictionary = [responseDictionary objectForKey:@"query"];
        searchArray = [queryDictionary objectForKey:@"search"];
        
        for (NSDictionary *wikiSearchDictionary in searchArray) {
            
            FSVenueDetail_WikiObject *wikiObject = [[FSVenueDetail_WikiObject alloc] init];
            
            wikiObject.wikiTitle = [wikiSearchDictionary objectForKey:@"title"];
           NSString *snippetString =[wikiSearchDictionary objectForKey:@"snippet"];
                        
            NSString *wikiSearchByTitle = [NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@",wikiObject.wikiTitle];
            NSString *wikiTitleUrlString = [wikiSearchByTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            wikiObject.wikiMainURL = [NSURL URLWithString:wikiTitleUrlString];
            
            wikiObject.wikiSnippetString = [self removeCommonTagsfor:snippetString];
//            -12char to get to beginning of ...more...

            NSLog(@"unadulterated snippet: %@", snippetString);
            NSLog(@"%@: %@", wikiObject.wikiTitle, wikiObject.wikiSnippetString);
            
        [wikiSearchResultArray addObject: wikiObject];
            
        }
        [self.wikiCollectionView reloadData];


    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // 3b - Request failed block
        NSLog(@"received a %d", response.statusCode);
        NSLog(@"the error was %@", error);
    }];
    // 4 - Start request
    [operation start];
}

-(NSMutableAttributedString*)removeCommonTagsfor: (NSString*) string
{
    NSString *boldBeginsString = [NSString stringWithFormat:@"<b>"];
    NSString *boldEndsString = [NSString stringWithFormat:@"</b>"];
    NSString *cleanString =[string stringByReplacingOccurrencesOfString:boldBeginsString withString:@""];
    cleanString =[cleanString stringByReplacingOccurrencesOfString:boldEndsString withString:@""];

    
    NSString *searchClassBegin = [NSString stringWithFormat:@"<span class='searchmatch'>"];
    NSString *searchClassEnds = [NSString stringWithFormat:@"</span>"];
    cleanString =[cleanString stringByReplacingOccurrencesOfString:searchClassBegin withString:@""];
    cleanString =[cleanString
                  stringByReplacingOccurrencesOfString:searchClassEnds withString:@""];

    NSString *moreString = [NSString stringWithFormat:@"%@ tap for more...", cleanString];
    
    NSMutableAttributedString *newWikiSnippet = [[NSMutableAttributedString alloc] initWithString:moreString];
    UIFont *helvLtItal = [UIFont fontWithName: @"Helvetica-LightOblique" size:12.0f];
    [newWikiSnippet addAttribute:NSFontAttributeName value:helvLtItal range:NSMakeRange(newWikiSnippet.length-20, 20)];
    
    return newWikiSnippet;
}

    
    //Configures a cell for a given index path
-(void)configureCell:(FSVenueDetail_WikiCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    FSVenueDetail_WikiObject *wikiCellObject = wikiSearchResultArray[indexPath.row];
    cell.wikifirstParaText.attributedText =  wikiCellObject.wikiSnippetString;
    cell.wikiLabel.text = wikiCellObject.wikiTitle;
        
    //NSURLRequest *wikiSelectionRequest = [NSURLRequest requestWithURL:wikiCellObject.wikiMainURL];

    //[cell loadWebView:wikiSelectionRequest];
    
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
     
    FSVenueDetail_WikiCell *wikiCollCell = [self.wikiCollectionView dequeueReusableCellWithReuseIdentifier: CellIdentifier forIndexPath:indexPath];

    [self configureCell:wikiCollCell forIndexPath:indexPath];
    NSLog(@"Wiki Cell Dequeued?");
   
    
    return wikiCollCell;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FSVenueDetail_WikiObject *tappedWikiArticle = [wikiSearchResultArray objectAtIndex:indexPath.item];
    [[UIApplication sharedApplication] openURL:tappedWikiArticle.wikiMainURL];
    NSLog(@"tappedArticle : %@", tappedWikiArticle.wikiTitle);
    
}

@end
