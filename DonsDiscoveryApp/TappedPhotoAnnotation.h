//
//  TappedPhotoAnnotation.h
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 5/30/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TappedPhotoAnnotation : NSObject <MKAnnotation>


@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy)   NSString *subtitle;
@property (nonatomic, copy) NSString *title;

@end
