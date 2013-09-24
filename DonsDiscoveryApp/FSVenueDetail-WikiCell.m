//
//  FSVenueDetail-WikiCell.m
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 6/4/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "FSVenueDetail-WikiCell.h"
#import "WikiCollectionFlowLayoutAttributes.h"
#import "AppDelegate.h"

@implementation FSVenueDetail_WikiCell

{
    UIView          *maskView;
    NSString        *wikiTruncatedTitle;
    UIWebView       *wikiWebView;
    UIView          *tapView;
    

    //UIActivityIndicatorView *activityIndicator;
}


- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    
    self.userInteractionEnabled = YES;
    /*wikiWebView = [[UIWebView alloc] initWithFrame:CGRectInset(CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 20, 20)];
    wikiWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    wikiWebView.clipsToBounds = YES;
    [wikiWebView setUserInteractionEnabled:NO];
    wikiWebView.scrollView.scrollEnabled =NO;

    [wikiWebView setAlpha:0.0];
    [self.contentView addSubview:wikiWebView];
    */
    
    self.wikiLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0, CGRectGetWidth(frame), 27)];
    self.wikiLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.wikiLabel.clipsToBounds = YES;
    [self.wikiLabel setUserInteractionEnabled:NO];
    self.wikiLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:14.0f];
    self.wikiLabel.textColor = [UIColor greenColor];
    self.wikiLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.wikiLabel];
    
    self.wikifirstParaText = [[UITextView alloc] initWithFrame:CGRectMake(-2,18, CGRectGetWidth(frame)-7, 100)];
    self.wikifirstParaText.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.wikifirstParaText.clipsToBounds = YES;
    [self.wikifirstParaText setUserInteractionEnabled:NO];
    [self.wikifirstParaText setFont:[UIFont fontWithName: @"Helvetica-Light" size:11.0f]];
    [self.wikifirstParaText setTextColor:[UIColor whiteColor]];
    self.wikifirstParaText.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.wikifirstParaText];
    
    tapView = [[UIView alloc] initWithFrame:CGRectMake(-2, 18, CGRectGetWidth(frame)-7, 100)];
    tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tapView.clipsToBounds = YES;
    [tapView setUserInteractionEnabled:YES];
    tapView.backgroundColor =[UIColor whiteColor];
    tapView.alpha = 0.0f;
    [self.contentView insertSubview:tapView aboveSubview:self.wikifirstParaText];

    
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    maskView.alpha = 1.0f;
    [self.contentView insertSubview:maskView aboveSubview:self.wikifirstParaText];
    
    // This will make the rest of our cell, outside the image view, appear transparent against a black background.
    //self.backgroundColor = [UIColor brownColor];
    
    
    return self;
}

#pragma mark - Overridden Methods

-(void)prepareForReuse
{
    //wikiWebView = nil;// doing this limits me to just 2 webview, dequeue one & two. the labels never load.
    self.wikiLabel.text = nil;
    self.wikifirstParaText.text = nil;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    maskView.alpha = 0.0f;
    //self.layer.shouldRasterize = NO;
    
    // Important! Check to make sure we're actually this special subclass.
    // Failing to do so could cause the app to crash!
    if (![layoutAttributes isKindOfClass:[WikiCollectionFlowLayoutAttributes class]])
    {
        return;
    }
    
    WikiCollectionFlowLayoutAttributes *castedLayoutAttributes = (WikiCollectionFlowLayoutAttributes *)layoutAttributes;
    
   // self.layer.shouldRasterize = castedLayoutAttributes.shouldRasterize;
    maskView.alpha = castedLayoutAttributes.maskingValue;
}

#pragma mark - Public Methods




/*-(void)loadWebView:(NSURLRequest*)wikiSelectionRequest;
{
    [wikiWebView loadRequest:wikiSelectionRequest];
    
    if (wikiWebView.loading == YES){
        [self evaluateWebViewStrings];
    } else {
        [self performSelector:@selector(evaluateWebViewStrings) withObject:nil afterDelay:.5f];
         }
    
    //right now, the view dequeues two cells right off the bat, it fills those cells with the webview, but the labels for those webviews show up on the first 'non-dequeued' cell.
    // tried perform @selector with delay
    // tried perform @selector with delay of a .2s, just to see if it could load evaluate the string after the load finished.

}

-(void)evaluateWebViewStrings
{
    NSString *wikiWebTitle =[wikiWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('title')[0].textContent"];
    NSLog(@"title: %@ char count: %d", wikiWebTitle, [wikiWebTitle length]);
    
    if ([wikiWebTitle length] >0){
        NSUInteger wikiBoilerIndex = [wikiWebTitle length]-35;
        NSRange wikiBoilerRange = [wikiWebTitle rangeOfComposedCharacterSequenceAtIndex:wikiBoilerIndex];
        wikiTruncatedTitle = [[NSString alloc] init];
        wikiTruncatedTitle = [wikiWebTitle substringToIndex: wikiBoilerRange.location];
        
        wikiLabel.text = wikiTruncatedTitle;
        
        NSString *wikiFirstPara =[wikiWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('p')[0].textContent"];
        //NSLog(@"%@", wikiFirstPara);
        
        wikiLabel.text = wikiTruncatedTitle;
        wikifirstParaText.text = wikiFirstPara;
    }
}*/

@end
