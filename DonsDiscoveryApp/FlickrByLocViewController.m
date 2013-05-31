//
//  FlickrByLocViewController.m
//  2013-05-28
//
//  Created by Erin Hochstatter on 5/29/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "FlickrByLocViewController.h"
#import "FlickrByLocCell.h"
#import "SourceURLTags.h"

@interface FlickrByLocViewController ()

{
    NSArray *photoByLocArray;

}

@end

@implementation FlickrByLocViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

NSString *kLocCellID= @"flickrLocCell";
NSString *kApiKey =@"83992732ed047326809fb0a1cb368e8b";


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    [self getLatLngForText];
    
    //[self.flickrByLocationCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kLocCellID];
    
    [self.locViewActivityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getLatLngForText{

    NSString *replaceString= [self.locText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", replaceString];
    NSLog(@"url - %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
   
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error){
                               
                               NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSArray *resultsArray = [resultsDictionary objectForKey:@"results"];
                               NSDictionary *mainDictionary = [resultsArray objectAtIndex:0];
                               NSDictionary *geometryDictionary = [mainDictionary objectForKey:@"geometry"];
                               NSDictionary *locationDictionary = [geometryDictionary objectForKey:@"location"];
                               
                               self.latitudeInput = [locationDictionary objectForKey:@"lat"];
                               self.longitudeInput = [locationDictionary objectForKey:@"lng"];
                               
                               
                               [self getFlickrJSONData];
                               
                           }];
    

}

-(void)getFlickrJSONData{
    
    NSLog(@"latitude %@, longitude %@", self.latitudeInput, self.longitudeInput);

    
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&format=json&nojsoncallback=1&lat=%@&lon=%@", kApiKey, self.latitudeInput, self.longitudeInput];
    
    NSURL *imageByLocURL = [NSURL URLWithString:urlString];
    NSLog(@"url w/ lat, lng: %@", urlString);
    
    NSURLRequest *imageByLocRequest = [NSURLRequest requestWithURL: imageByLocURL];
    
    //[self.locViewActivityIndicator startAnimating];
    
    
    [NSURLConnection sendAsynchronousRequest:imageByLocRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error){
                               
                               NSDictionary *locRequestDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               __unused NSDictionary *statOKDict = [locRequestDictionary objectForKey:@"stat"];
                               NSDictionary *photosbyLocDict =[locRequestDictionary objectForKey:@"photos"];
                               photoByLocArray = [photosbyLocDict objectForKey:@"photo"];
                               
                               self.locationImagesArray = [[NSMutableArray alloc] initWithCapacity:100];
                               //capacity can change, as needed.
                               
                               for (NSDictionary *singlePicByLocDict in photoByLocArray) {
                                   
                                   NSString *titleForLoc = [singlePicByLocDict objectForKey:@"title"];
                                   NSString *idForLoc = [singlePicByLocDict objectForKey:@"id"];
                                   NSString *secretForLoc =[singlePicByLocDict objectForKey:@"secret"];
                                   NSString *serverForLoc = [singlePicByLocDict objectForKey:@"server"];
                                   NSString *farmForLoc = [singlePicByLocDict objectForKey:@"farm"];
                                   NSString *urlForLocatedPic = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", farmForLoc, serverForLoc, idForLoc, secretForLoc];
                                   
                                   
                                   SourceURLTags *sourceURLTag = [[SourceURLTags alloc] init];
                                   sourceURLTag.idForTag =idForLoc;
                                   sourceURLTag.secretForTag = secretForLoc;
                                   sourceURLTag.serverForTag = serverForLoc;
                                   sourceURLTag.farmForTag = farmForLoc;
                                   sourceURLTag.urlStringForTag =urlForLocatedPic;
                                   sourceURLTag.titleForTag = titleForLoc;
                                   
                                   NSLog(@"%@", sourceURLTag.urlStringForTag);
                                   
                                   
                                   [self.locationImagesArray addObject:sourceURLTag];
                                   NSLog(@"array count = %d", self.locationImagesArray.count);
                               }
                               [self.flickrByLocationCollectionView reloadData];
                               //[self.locViewActivityIndicator stopAnimating];
                           }];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    //SourceURLTags *blockTag = [[SourceURLTags alloc] init];
    //NSURL *blockUrl = [NSURL URLWithString: blockTag.urlStringForTag];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   NSLog(@"hello from inside the block");
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSLog(@"this logs the sections in view");
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"this logs the items in section:%d", self.locationImagesArray.count);
    return self.locationImagesArray.count;
}



/*
 - (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 FlickrPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
 NSString *searchTerm = self.searches[indexPath.section];
 cell.photo = self.searchResults[searchTerm]
 [indexPath.row];
 return cell;
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FlickrByLocCell *flickrByLocCell = [self.flickrByLocationCollectionView dequeueReusableCellWithReuseIdentifier:kLocCellID forIndexPath:indexPath];
    //the documentation says that if you dequeue, the cell will never be nil, so i removed the if cell = nil part.
    
    SourceURLTags *individualPic = [self.locationImagesArray objectAtIndex:indexPath.item];
    NSString *thumbURLString =individualPic.urlStringForTag;
    NSURL *thumbURL = [NSURL URLWithString: thumbURLString];
    //NSData *thumbData = [NSData dataWithContentsOfURL:thumbURL];
    //NSLog(@"link at cell creation:%@", thumbURL);
    //UIImage *thumbnail = [UIImage imageWithData:thumbData];
    flickrByLocCell.locImageView.image = nil;
    
     [self downloadImageWithURL:thumbURL completionBlock:^(BOOL succeeded, UIImage *image) {
         if (succeeded) {
             
             // change the image in the cell
             
             UIImage *thumbnail = image;
             FlickrByLocCell *cell =((FlickrByLocCell*)[collectionView cellForItemAtIndexPath:indexPath]);
             cell.locImageView.image = image;
             
             // cache the image for use later (when scrolling up)
             thumbnail = image;
         }
         
      }];
    
    // if we want to select, we can create a custom background class with an image or CGRect.
    //mediaCell.selectedBackgroundView = [[MediaCellSelectedBG alloc] initWithFrame:CGRectZero];
    [self.locViewActivityIndicator stopAnimating];
    
    return flickrByLocCell;
}
    
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//
//        //((SliderViewController*)(segue.destinationViewController)).locationImagesSlideArray = self.locationImagesArray;
//        
//       // NSLog(@"%d",((FlickrByLocViewController*)(segue.destinationViewController)).locationImagesArray.count);
//    
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
// //   [self performSegueWithIdentifier:@"fromLocToSliderSegue" sender:self];
//}

@end
