//
//  BunnyTail.m
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 6/1/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "BunnyTail.h"

@implementation BunnyTail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//you can access Core Animation through the methods and properties of the UIView class

-(void)rabbitTailBounce{
    
    CGPoint leftPos = CGPointMake(160, 238);
    self.center = leftPos;

    
    CGPoint rightPos = CGPointMake(leftPos.x+3, leftPos.y+0.5);
    
    [UIView animateWithDuration:0.2
                          delay:1.0
                        options: (((UIViewAnimationOptions)(UIViewAnimationCurveEaseOut)) /*| UIViewAnimationOptionRepeat <--- this makes an infinitely wiggly tail*/)
                     animations:^{
                         [UIView setAnimationRepeatCount:2]; 
                         self.center = rightPos;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2
                                               delay:0.1
                                             options: ((UIViewAnimationOptions)(UIViewAnimationCurveEaseOut))
                                          animations:^{
                                              self.center = leftPos;
                                          }
                                          completion:^(BOOL finished){
                                                  
                                              [UIView animateWithDuration:0.5
                                                                    delay:0.1
                                                                  options: ((UIViewAnimationOptions)(UIViewAnimationCurveEaseOut))
                                                               animations:^{
                                                                   
                                                                   self.transform = CGAffineTransformMakeRotation(20 * M_PI/180);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   
                                                                   NSLog(@"Done!");
                                                               }];
                                          }];
                     }];

}

@end
