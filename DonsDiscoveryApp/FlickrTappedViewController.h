//
//  FlickrTappedViewController.h
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 5/30/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FlickrTappedViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (strong,nonatomic) NSString *photoTappedID;
@property (strong,nonatomic) NSString *tappedPhotolatitude;
@property (strong,nonatomic) NSString *tappedPhotolongitude;
@property (strong,nonatomic) NSString *tappedPhotoTitle;

@property (strong,nonatomic) NSMutableArray *photoTappedObjectArray;

@property (weak, nonatomic) IBOutlet UILabel *latTextLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *popUpLabel;

- (IBAction)checkInButton:(id)sender;


@end
