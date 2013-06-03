//
//  FourSquareVenue.h
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 5/30/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FourSquareVenue : NSObject <MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *venueLat;
@property (nonatomic, copy) NSString *venueLong;

@property(nonatomic,copy)   NSString *subtitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic,copy) NSArray *rawTagArray;

@end
