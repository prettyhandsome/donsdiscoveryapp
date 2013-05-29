//
//  ViewController.m
//  DonsDiscoveryApp
//
//  Created by Javier Evelyn on 5/28/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<KIImagePagerDelegate, KIImagePagerDataSource>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    self.imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    
    NSLog(@"Testing, testing, 1, 2, 3!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) arrayWithImageUrlStrings
{
    return [NSArray arrayWithObjects:
            @"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen1.png",
            @"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png",
            @"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen3.png",
            @"http://wikitravel.org/upload/shared//thumb/b/b0/Skyline_from_Millenium_Park.jpg/350px-Skyline_from_Millenium_Park.jpg",
            nil];
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
