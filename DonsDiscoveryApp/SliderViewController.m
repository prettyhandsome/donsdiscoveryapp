//
//  SliderViewController.m
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 5/29/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()<KIImagePagerDelegate, KIImagePagerDataSource>

@end

@implementation SliderViewController

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
    
    self.imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    self.imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    
    NSLog(@"Testing, testing, 1, 2, 3!");
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) arrayWithImageUrlStrings
{
    self.locationImagesSlideArray = [[NSMutableArray alloc] init];
    NSArray *justURLStringArray = [NSArray mutableArrayValueForKey:@"urlStringForTag"];
    NSLog(@"url for justURL[0]: %@", justURLStringArray[0]);

//    [self.locationImagesSlideArray ];
    //if you retrieve the  key value for a property in an array of classes, you can get an array of just that thing.
    return  justURLStringArray;
    
}
- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleToFill;
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %d", __PRETTY_FUNCTION__, index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %d", __PRETTY_FUNCTION__, index);
}


@end
