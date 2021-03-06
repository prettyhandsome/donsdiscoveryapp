//
//  FlickrTappedViewController.m
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 5/30/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "FlickrTappedViewController.h"
#import "FlickrByTagViewController.h"
#import "SourceURLTags.h"
#import "FourSquareVenue.h"
#import "TappedPhotoAnnotation.h"
#import "TappedPhotoAnnotationView.h"
#import "FSVenueDetailViewController.h"
#import "RecentCheckInsViewController.h"


@interface FlickrTappedViewController ()
{
    NSMutableArray *rawTagArray;
    NSString *venueLat;
    NSString *venueLng;
    NSString *venueName;
    NSString *tappedPhotoTag;
    NSString *tappedPhotoCity;
    NSString *tappedPhoteState;
    NSString *venueID;
    FourSquareVenue *selectedVenue;
    
   
}


-(void) getFlickrGeoLocationURLRequest;
-(void) getFourSquareMapURLData;
-(void) setUpVenueMapAnnotationData;
-(void) dropPinForFlickPhoto;

@end

@implementation FlickrTappedViewController
@synthesize tappedPhotolatitude;
@synthesize photoTappedObjectArray;
@synthesize tappedPhotolongitude;
@synthesize tappedPhotoTitle;
@synthesize popUpLabel;
@synthesize latTextLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//For now I'm using a static Photo ID for the GEO-Location URL Request;
NSString *apiKeyAgain =@"83992732ed047326809fb0a1cb368e8b";



- (void)viewDidLoad
{
    [super viewDidLoad];
    
       
    
      NSLog(@"the tapped photo ID is %@",_photoTappedID); 
	// Do any additional setup after loading the view.
    
    [self getFlickrGeoLocationURLRequest];
  //  [self dropPinForFlickPhoto];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Parse Flickr URL 
-(void) getFlickrGeoLocationURLRequest
{
    NSString *geoURLString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1",apiKeyAgain,_photoTappedID];
    
    NSURL *url = [NSURL URLWithString:geoURLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
        
                               NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0 error:nil];
                            //Create dictionary for location data and fetch lat/ long
                            NSDictionary *geoInfoDictionary = [[resultsDict objectForKey:@"photo"] objectForKey:@"location"];
                               
                            tappedPhotolatitude= [geoInfoDictionary objectForKey:@"latitude"];
                            tappedPhotolongitude=[geoInfoDictionary objectForKey:@"longitude"];
                            tappedPhotoCity = [[geoInfoDictionary objectForKey:@"locality"] objectForKey:@"_content"];
                            tappedPhoteState = [[geoInfoDictionary objectForKey:@"region"]objectForKey:@"_content"];
                              NSLog(@"city is %@, state is %@",tappedPhotoCity,tappedPhoteState);
                              //popUpLabel.text = (@"Your photo is in %@,%@",photoCity,photoState);
                               
                             [self dropPinForFlickPhoto];
                               
                               NSLog(@"the latitude is %@",tappedPhotolatitude);
                               NSLog(@"the longitude is%@",tappedPhotolongitude);
                               
                               NSDictionary *photoContentDescriptions = [[resultsDict objectForKey:@"photo"] objectForKey:@"title"];
                               
                               tappedPhotoTitle = [photoContentDescriptions objectForKey:@"_content"];
                               
                                                               
                            //Create array for tag data and get an array of tags. The tag section in the JSON returns an array of dictionaries
                            
                            NSArray *tagResultsArray= [[[resultsDict objectForKey:@"photo"] objectForKey:@"tags"] objectForKey:@"tag"];
                               
                               //Instantiate Array here so that it can eventually fill up everything in the loop
                               rawTagArray = [[NSMutableArray alloc] init];
                               
                               for (NSDictionary *dictionary in tagResultsArray) {
                                   
                                   tappedPhotoTag = [dictionary objectForKey:@"raw"];
                                   [rawTagArray addObject:tappedPhotoTag];
                                  // NSLog(@"tapped photo tag ARRAY has %@",rawTagArray);
                                 //  NSLog (@"there are %i items in the array",rawTagArray.count);

                                   rawTagArray = [[NSMutableArray alloc] init];
                                   [rawTagArray addObject:tappedPhotoTag];
                                  // NSLog(@"tapped photo tags are %@",rawTagArray);
                                
                                  
                               }
                                [self getFourSquareMapURLData];
                                                          
                }];
   

    }

#pragma mark Drop a Pin for original Flickr Photo selected (location of it)

-(void) dropPinForFlickPhoto {
    
    TappedPhotoAnnotation  *tappedPhotoAnnotation = [[TappedPhotoAnnotation alloc] init];
    
    tappedPhotoAnnotation.coordinate = CLLocationCoordinate2DMake([tappedPhotolatitude floatValue], [tappedPhotolongitude floatValue]);
    tappedPhotoAnnotation.title = tappedPhotoTitle;
         
    CLLocationCoordinate2D center = tappedPhotoAnnotation.coordinate;
    //ekh-i changed this from .2, just because zooming on the simulator was making me crazy, feel free to adjust back.
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    self.mapView.region = region;
    [self.mapView addAnnotation:tappedPhotoAnnotation];
    NSString *popUpString = [NSString stringWithFormat:@"Your photo is in %@,%@!",tappedPhotoCity,tappedPhoteState];
    popUpLabel.text = popUpString; 
     

}

-(MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    NSString *reuseIdentifier= @"reuseIdentifier";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if ([annotation isKindOfClass:[TappedPhotoAnnotation class]]) {
        
        annotationView = [[TappedPhotoAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:reuseIdentifier];
        annotationView.canShowCallout= YES;
       // ((MKPinAnnotationView *)(annotationView)).animatesDrop = YES;
        
    }
        
    
    if(annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:reuseIdentifier];
        
        annotationView.canShowCallout= YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        ((MKPinAnnotationView *)(annotationView)).pinColor= MKPinAnnotationColorPurple;
        ((MKPinAnnotationView *)(annotationView)).animatesDrop = YES;
        
    } else {
        
        annotationView.annotation = annotation;
    }
    
    return annotationView;
    
    
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        // add animation to  TappedPhotoAnnotation
        if ([aV.annotation isKindOfClass:[TappedPhotoAnnotationView class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options:UIViewAnimationCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        aV.transform = CGAffineTransformIdentity; 
                    }];
                }];
            }
        }];
    }
}


#pragma mark Get Foursquare Venue Data

-(void) getFourSquareMapURLData {
    
    NSString *foursquareClientID=@"MFDIXCKNSUTA01UKTJUUCPDLOU2QX3GA4NAFF4YFHGF1KDXH";
    NSString *foursquareClientSecret =@"S5MZYU1VDCK5FT21TYMKUBUYAS4PED30350KQKVBXYJW5IPJ";
    //NSString *tagQuery1= [rawTagArray objectAtIndex:0];
    //NSString *tagQuery2 = [rawTagArray objectAtIndex:1];
 
//https:api.foursquare.com/v2/tips/search?ll=41.90,-87.65&radius=2000&query=pizza&client_id=MFDIXCKNSUTA01UKTJUUCPDLOU2QX3GA4NAFF4YFHGF1KDXH&client_secret=S5MZYU1VDCK5FT21TYMKUBUYAS4PED30350KQKVBXYJW5IPJ&v=20130530
    
    NSString *venuesCloseToPhotoLocationURLString= [NSString stringWithFormat:@"https://api.foursquare.com/v2/tips/search?ll=%@,%@&radius=20000&client_id=%@&client_secret=%@&v=20130602",tappedPhotolatitude,tappedPhotolongitude,foursquareClientID,foursquareClientSecret];

    
    venuesCloseToPhotoLocationURLString = [venuesCloseToPhotoLocationURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:venuesCloseToPhotoLocationURLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
    
                               NSDictionary *resultsfromVenueSearch = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0 error:nil];
                        
                               NSArray *venueArray = [[resultsfromVenueSearch objectForKey:@"response"]objectForKey:@"tips"];
                               
                               for (NSDictionary *dictionary in venueArray) {
                                       
                                       venueLat = [[[dictionary objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"];
                                       venueLng= [[[dictionary objectForKey:@"venue"] objectForKey:@"location"]objectForKey:@"lng"];
                                       venueName = [[dictionary objectForKey:@"venue"] objectForKey:@"name"];
                                       venueID = [[dictionary objectForKey:@"venue"] objectForKey:@"id"];
                                   // could the venueID be added to the class? NSLog(@"venue ID %@", venueID);
                                      // NSArray *tipArray = [dictionary objectForKey:@"text"];
                            
                                   
                            [self setUpVenueMapAnnotationData];
                               }
                               
                              
                           }];



}
-(void) setUpVenueMapAnnotationData {
    
   FourSquareVenue  *nearByVenues = [[FourSquareVenue  alloc] init];
    
    nearByVenues.coordinate = CLLocationCoordinate2DMake([venueLat  floatValue], [venueLng floatValue]);
    nearByVenues.title = venueName;
    nearByVenues.venueLat =venueLat;
    nearByVenues.venueLong = venueLng;
    nearByVenues.venueID = venueID;
    
        
    [self.mapView addAnnotation:nearByVenues];
    
}

-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    selectedVenue= [mapView.selectedAnnotations objectAtIndex:0];
    
    [self performSegueWithIdentifier:@"venueDetailsView" sender:self];
     NSLog(@"the selected venue name is %@", selectedVenue.title); 
    NSLog(@" BUTTON WORKED!"); 
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"venueDetailsView"]) {
    
    ((FSVenueDetailViewController *)segue.destinationViewController).selectedVenue= selectedVenue;

        
    }
    else if ([segue.identifier isEqualToString:@"pushToCheckIns"]) {
        
        ((RecentCheckInsViewController *)segue.destinationViewController).selectedVenue = selectedVenue; 
        
    }

    

}



- (IBAction)checkInButton:(id)sender {
    
    [self performSegueWithIdentifier:@"pushToCheckIns" sender:self];
}
@end
