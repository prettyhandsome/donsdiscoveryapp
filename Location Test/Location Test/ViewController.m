//
//  ViewController.m
//  Location Test
//
//  Created by Erin Hochstatter on 5/30/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()

{
    CLLocation *myLocation;
    
}
@property (strong, nonatomic) CLLocationManager *myLocationManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // location services enabled.
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.myLocationManager)
        self.myLocationManager = [[CLLocationManager alloc] init];
    
    self.myLocationManager.delegate = self;
    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.myLocationManager startUpdatingLocation];
        //can also use startMonitoringSignificantLocationChanges to only access large changes, like cell tower switches
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"Please enable location services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    // Set a movement threshold for new events.
    self.myLocationManager.distanceFilter = 500;
    
    [self.myLocationManager startUpdatingLocation];
    //can probably stop monitoring again, once the location search string is formed, to save battery life? turn on again as needed?
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power
    
    myLocation = [locations lastObject];
    NSDate* eventDate = myLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
       
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fakeSignInButton:(id)sender {
    
    // If the event is recent, do something with it.
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          myLocation.coordinate.latitude,
          myLocation.coordinate.longitude);
    
    NSString *myLatitude = [NSString stringWithFormat:@"latitude %f", myLocation.coordinate.latitude];
    NSString *myLongitude = [NSString stringWithFormat:@"longitude %f", myLocation.coordinate.longitude];

    self.CurrentLatLabel.text = myLatitude;
    self.CurrentLngLabel.text = myLongitude;
}
@end
