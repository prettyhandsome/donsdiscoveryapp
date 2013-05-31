//
//  TappedPhotoAnnotationView.m
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 5/30/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "TappedPhotoAnnotationView.h"

@implementation TappedPhotoAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.image = [UIImage imageNamed:@"OrangeMapPin_WithPhoto.png"];
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

@end
