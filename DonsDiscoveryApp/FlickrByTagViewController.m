//
//  FlickrByTagViewController.m
//  2013-05-28
//
//  Created by Erin Hochstatter on 5/28/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "FlickrByTagViewController.h"
#import "FlickrByTagCell.h"
#import "SourceURLTags.h"
#import "FlickrTappedViewController.h"

@interface FlickrByTagViewController ()
{
    //suggestion items:
    NSTimer *suggestionTimer;
    
//location items:

    NSString *currentLatitude;
    NSString *currentLongitude;
    
//collection view items:
    NSArray *photoByTagArray;
    NSString *idForTag;
    
    int     segueTestCount;
    int     flickrURLrequestCount;
}
@property (strong, nonatomic) CLLocationManager *myLocationManager;


@end

@implementation FlickrByTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

NSString *kCellID= @"flickrTagCell";
NSString *kApiKeyAgain =@"83992732ed047326809fb0a1cb368e8b";

- (void)viewDidLoad
{
    [super viewDidLoad];
    //confirm search tag made it from first VC
    NSLog(@"on second ViewController %@", self.tagText);

    //download the current coord.
    [self startStandardUpdates];
    [self chooseSuggestion];
    
    segueTestCount = 1;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 
#pragma mark Provide Instructions

-(void)chooseSuggestion{
    
    [super.view addSubview: self.suggestionView];
    
    if ([self.tagText isEqualToString: @"food"]) {
        self.suggestionViewLabel.text = @"take a look...\n tap what looks tasty!";
    } else if
        ([self.tagText isEqualToString: @"drink"]) {
        self.suggestionViewLabel.text = @"thirsty?\n tap what looks tempting!";
    } else if
        ([self.tagText isEqualToString: @"art & architecture"]) {
            self.suggestionViewLabel.text = @"tap what looks lovely!";
        
        } else if
            ([self.tagText isEqualToString: @"events"]) {
                self.suggestionViewLabel.text = @"tap what looks fun!";
        
            } else{
                self.suggestionViewLabel.text = @"tap what looks interesting!";
            }

}


#pragma 
#pragma mark Set Location

- (void)startStandardUpdates
{
    // Create the location manager if this object does not already have one.
    
    
    self.myLocationManager = [[CLLocationManager alloc] init];
    
    self.myLocationManager.delegate = ((id <CLLocationManagerDelegate>)(self));
    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.myLocationManager startUpdatingLocation];
        //        //can also use startMonitoringSignificantLocationChanges to only access large changes, like cell tower switches
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"Please enable location services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    //    // Set a movement threshold for new events.
    self.myLocationManager.distanceFilter = 500;
    
    [self.myLocationManager startUpdatingLocation];
    
    //can probably stop monitoring again, once the location search string is formed, to save battery life? turn on again as needed?
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    currentLatitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    currentLongitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    NSLog(@"currently at lat:%f long:%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    [self getFlickrJSONData];

    
}


#pragma 
#pragma mark Get JSON from Flickr

-(void)getFlickrJSONData{
    
    //tag string as web-friendly
    NSString *replaceString= [self.tagText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"replace string=%@", replaceString);
    
    //searches on tag, lat, long.
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&has_geo=1&api_key=%@&format=json&nojsoncallback=1&tags=%@&lat=%@&lon=%@",kApiKeyAgain, replaceString, currentLatitude, currentLongitude];
    NSLog(@"url string: %@",urlString);

    
    NSURL *imageByTagURL = [NSURL URLWithString:urlString];
    
    NSURLRequest *imageByTagRequest = [NSURLRequest requestWithURL: imageByTagURL];
    
    [self.activityIndicator startAnimating];
    flickrURLrequestCount++;
    NSLog(@"urlRequestCount %d", flickrURLrequestCount);
    
    [NSURLConnection sendAsynchronousRequest:imageByTagRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error){

                               
                               
                               NSDictionary *tagRequestDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               __unused NSDictionary *statOKDict = [tagRequestDictionary objectForKey:@"stat"];
                               NSDictionary *photosbyTagDict =[tagRequestDictionary objectForKey:@"photos"];
                               photoByTagArray = [photosbyTagDict objectForKey:@"photo"];
                               
                               self.taggedImagesArray = [[NSMutableArray alloc] initWithCapacity:100];
                               //capacity can change, as needed.
                               
                               for (NSDictionary *singlePicByTagDict in photoByTagArray) {
    
                                   NSString *titleForTag = [singlePicByTagDict objectForKey:@"title"];
                                   idForTag = [singlePicByTagDict objectForKey:@"id"];
                                   NSString *secretForTag =[singlePicByTagDict objectForKey:@"secret"];
                                   NSString *serverForTag = [singlePicByTagDict objectForKey:@"server"];
                                   NSString *farmForTag = [singlePicByTagDict objectForKey:@"farm"];
                                   NSString *urlForTaggedPic = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", farmForTag, serverForTag, idForTag, secretForTag];
                                   
                                   //NSString *latForPic = [singlePicByTagDict objectForKey:@"lat"];
                                   
                        
                                   SourceURLTags *sourceURLTag = [[SourceURLTags alloc] init];
                                   sourceURLTag.idForTag =idForTag;
                                   sourceURLTag.secretForTag = secretForTag;
                                   sourceURLTag.serverForTag = serverForTag;
                                   sourceURLTag.farmForTag = farmForTag;
                                   sourceURLTag.urlStringForTag =urlForTaggedPic;
                                   sourceURLTag.titleForTag = titleForTag;
                        
                                   NSLog(@"image url %@", sourceURLTag.urlStringForTag);
                                   
                                   
                                   [self.taggedImagesArray addObject:sourceURLTag];
                                    NSLog(@"array count = %d", self.taggedImagesArray.count);
                               }
                               [self.taggedItemsCollectionView reloadData];

                              // [self.activityIndicator stopAnimating];
                               
                               //i'd rather use a timer, but this will remove the label once pictures appear, it looks a little glitchy
                               if (self.taggedImagesArray.count !=0) {
                                   [self.suggestionView removeFromSuperview];
                               }

                           }];
      [self.activityIndicator stopAnimating];
    [self.myLocationManager stopUpdatingLocation];

}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


#pragma
#pragma mark Set Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSLog(@"this logs the sections in view");
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"this logs the items in section:%d", self.taggedImagesArray.count);
    return self.taggedImagesArray.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FlickrByTagCell *flickrByTagCell = [self.taggedItemsCollectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    //the documentation says that if you dequeue, the cell will never be nil, so i removed the if cell = nil part.
    NSLog(@"flickr Cell dequeued");
    SourceURLTags *individualTag = [self.taggedImagesArray objectAtIndex:indexPath.row];
    NSString *thumbURLString =individualTag.urlStringForTag;
    NSURL *thumbURL = [NSURL URLWithString: thumbURLString];
    
    flickrByTagCell.tagImageView.image = nil;
    flickrByTagCell.tagLabel.text = nil;
    
    [self downloadImageWithURL:thumbURL completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            // change the image in the cell
            UIImage *thumbnail = image;
            FlickrByTagCell *cell =((FlickrByTagCell*)[collectionView cellForItemAtIndexPath:indexPath]);
            cell.tagImageView.image = image;
            
            // cache the image for use later (when scrolling up)
            thumbnail = image;}
    
    flickrByTagCell.tagLabel.text = individualTag.titleForTag;
    
    // if we want to select, we can create a custom background class with an image or CGRect.
    //flickrByTagCell.selectedBackgroundView = [[MediaCellSelectedBG alloc] initWithFrame:CGRectZero];
    }];
    
    return flickrByTagCell;
    [self.activityIndicator stopAnimating];
}


#pragma
#pragma - Segue Prep & Send

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
     [self performSegueWithIdentifier:@"pushToDetails" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
        segueTestCount++;
        
        if ([[segue identifier] isEqualToString:@"pushToDetails"]){
        
            
            NSIndexPath *selectedIndexPath = [[self.taggedItemsCollectionView indexPathsForSelectedItems] objectAtIndex:0];
            NSString *photoIdToPush = [photoByTagArray valueForKey:@"id"][selectedIndexPath.row];
            ((FlickrTappedViewController*)(segue.destinationViewController)).photoTappedID = photoIdToPush;
        
    NSLog(@"photo ID to push is %@, %d time through",photoIdToPush, segueTestCount);

}
    }


@end
