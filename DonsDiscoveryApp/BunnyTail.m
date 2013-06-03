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
    
    CGPoint leftPos = CGPointMake(160, 200);
    CGPoint rightPos = CGPointMake(leftPos.x+2, leftPos.y);
    
    [UIView animateWithDuration: 1.0f
                     animations:^{
                         
                         self.center = CGPointMake(self.center.x+2, self.center.y+0);
                    } completion:^(BOOL finished) {
                         //later
                        
                     }];

}

@end
