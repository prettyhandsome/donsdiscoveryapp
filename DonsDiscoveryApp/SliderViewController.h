//
//  SliderViewController.h
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 5/29/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"

@interface SliderViewController : UIViewController

@property (strong, nonatomic) IBOutlet KIImagePager *imagePager;
@property (strong, nonatomic) NSMutableArray *locationImagesSlideArray;

@end
