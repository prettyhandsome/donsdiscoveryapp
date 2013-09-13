//
//  StyleSheet.m
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 7/31/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "StyleSheet.h"


@implementation StyleSheet

+(void)applyStyle{

#pragma
#pragma Navigation Bar Appearance

UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];

[navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"rabbitNavBar-sky.png"]  forBarMetrics:UIBarMetricsDefault];

#pragma
#pragma BackButton Attributes
    
    int imageSize = 44; //image width
    
    UIImage *barItemBackDefaultImg = [[UIImage imageNamed:@"rabbitNavBar-back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, imageSize, 0, 0)];
    UIImage *barItemBackSelectImg = [[UIImage imageNamed:@"rabbitNavBar-back-tap.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, imageSize, 0, 0)];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-44.0, 0.0)
                                                         forBarMetrics:UIBarMetricsDefault]; //this one can be used to scoot the default title offscreen.
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage: barItemBackDefaultImg
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage: barItemBackSelectImg
                                                      forState:UIControlStateSelected
                                                    barMetrics:UIBarMetricsDefault];
 
    //NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, [UIFont fontWithName:@"AmericanTypewriter-Light" size:12.0],UITextAttributeFont, nil];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor grayColor],UITextAttributeTextColor,
                                [UIColor clearColor],UITextAttributeTextShadowColor,
                                [UIFont fontWithName:@"AmericanTypewriter" size:14.0f],UITextAttributeFont,
                                nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
   }
@end
