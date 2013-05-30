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

@interface FlickrByTagViewController ()
{
    NSArray *photoByTagArray;

}
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
    
    NSLog(@"on second ViewController %@", self.tagText);
    
    [self getFlickrJSONData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getFlickrJSONData{
    
    NSString *replaceString= [self.tagText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"string=%@", replaceString);
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&format=json&nojsoncallback=1&tags=%@", kApiKeyAgain, replaceString];
    
    NSURL *imageByTagURL = [NSURL URLWithString:urlString];
    
    NSURLRequest *imageByTagRequest = [NSURLRequest requestWithURL: imageByTagURL];
    
    [self.activityIndicator startAnimating];
    
    
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
                                   NSString *idForTag = [singlePicByTagDict objectForKey:@"id"];
                                   NSString *secretForTag =[singlePicByTagDict objectForKey:@"secret"];
                                   NSString *serverForTag = [singlePicByTagDict objectForKey:@"server"];
                                   NSString *farmForTag = [singlePicByTagDict objectForKey:@"farm"];
                                   NSString *urlForTaggedPic = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", farmForTag, serverForTag, idForTag, secretForTag];
                                   
                        
                                   SourceURLTags *sourceURLTag = [[SourceURLTags alloc] init];
                                   sourceURLTag.idForTag =idForTag;
                                   sourceURLTag.secretForTag = secretForTag;
                                   sourceURLTag.serverForTag = serverForTag;
                                   sourceURLTag.farmForTag = farmForTag;
                                   sourceURLTag.urlStringForTag =urlForTaggedPic;
                                   sourceURLTag.titleForTag = titleForTag;
                        
                                   NSLog(@"%@", sourceURLTag.urlStringForTag);
                                   
                                   
                                   [self.taggedImagesArray addObject:sourceURLTag];
                                    NSLog(@"array count = %d", self.taggedImagesArray.count);
                               }
                               [self.taggedItemsCollectionView reloadData];
                               [self.activityIndicator stopAnimating];
                           }];
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
    
    SourceURLTags *individualTag = [self.taggedImagesArray objectAtIndex:indexPath.row];
    NSString *thumbURLString =individualTag.urlStringForTag;
    NSURL *thumbURL = [NSURL URLWithString: thumbURLString];
    //NSData *thumbData = [NSData dataWithContentsOfURL:thumbURL];
    //NSLog(@"link at cell creation:%@", thumbURL);
    //UIImage *thumbnail = [UIImage imageWithData:thumbData];
    flickrByTagCell.tagImageView.image = nil; 
    
    [self downloadImageWithURL:thumbURL completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            // change the image in the cell
            UIImage *thumbnail = image;
            FlickrByTagCell *cell =((FlickrByTagCell*)[collectionView cellForItemAtIndexPath:indexPath]);
            cell.tagImageView.image = image;
            
            // cache the image for use later (when scrolling up)
            thumbnail = image;}
    
    //flickrByTagCell.tagImageView.image= thumbnail;
    flickrByTagCell.tagLabel.text = individualTag.titleForTag;
    
    // if we want to select, we can create a custom background class with an image or CGRect.
    //mediaCell.selectedBackgroundView = [[MediaCellSelectedBG alloc] initWithFrame:CGRectZero];
    }];
    
    return flickrByTagCell;
}


@end
