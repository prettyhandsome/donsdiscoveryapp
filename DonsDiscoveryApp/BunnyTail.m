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
    
    float xCenter = (self.superview.frame.size.width/2);
    float yCenter = ((self.superview.frame.size.height/2)+30);

    CGPoint centerPos = CGPointMake(xCenter, yCenter);
    self.center = centerPos;

    
    CGPoint rightPos = CGPointMake(centerPos.x+1, centerPos.y+1);
    CGPoint leftPos = CGPointMake(centerPos.x-1, centerPos.y-1);

    
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
                                             options: ((UIViewAnimationOptions)(UIViewAnimationCurveEaseInOut))
                                          animations:^{
                                              self.center = centerPos;
                                          }
                                          completion:^(BOOL finished){
                                                  
                                              [UIView animateWithDuration:0.5
                                                                    delay:0.1
                                                                  options: ((UIViewAnimationOptions)(UIViewAnimationCurveEaseInOut))
                                                               animations:^{
                                                                   
                                                                   self.transform = CGAffineTransformMakeRotation(20 * M_PI/180);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.2
                                                                                         delay:0.1
                                                                                       options: ((UIViewAnimationOptions)(UIViewAnimationCurveEaseInOut))
                                                                                    animations:^{
                                                                                        self.center = leftPos;
                                                                                    }
                                                                                    completion:^(BOOL finished){
                                                                                        
                                                                                        NSLog(@"Done!");

                                                                                    }];
                                                               }];
                                          }];
                     }];

}

@end
