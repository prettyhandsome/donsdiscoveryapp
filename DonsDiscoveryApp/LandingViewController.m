//
//  LandingViewController.m
//  DonsDiscoveryApp
//
//  Created by Erin Hochstatter on 5/31/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "LandingViewController.h"
#import "FlickrByLocViewController.h"
#import "FlickrByTagViewController.h"
#import "FlickrByTagCell.h"
#import "FlickrTappedViewController.h"


@interface LandingViewController ()

@end


NSString *kClientID = @"EBI30SCSCWA0UWVD5GRZI4HUGZNRLOTFGBVDVQB3FG2LU5O0";
NSString *kRedirectURI = @"app://testapp123";

@implementation LandingViewController

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

    self.loginWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.loginWebView.delegate = self;
    
    NSString *authenticateURLString = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@",kClientID,kRedirectURI];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    NSLog(@"viewDidLoad");
    [self.loginWebView loadRequest:request];
    
    [self.view addSubview:self.loginWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:@"itms-apps"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *URLString = [[self.loginWebView.request URL] absoluteString];
    NSLog(@"--> %@", URLString);
    // So this portion, i believe, once the user accepts, a link containing an access_token string. (http://YOUR_REGISTERED_REDIRECT_URI/#access_token=ACCESS_TOKEN) This looks for the string, and saves it as a default.  Not sure what to do with that, and it also doesn't really seem to have worked.
    
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        NSLog(@"access token ---> %@", accessToken);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"access_token"];
        [defaults synchronize];
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //if (error.code == NSURLErrorNotConnectedToInternet){
    NSLog(@"You are not connected");
    [self.loginWebView removeFromSuperview];
}

//oauth_token=ACCESS_TOKEN  <-- add this to the end of search requests to get user specific results.

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"segueToTaggedView"])
    {
        ((FlickrByTagViewController*)(segue.destinationViewController)).tagText = self.searchByTagTextField.text;
        NSLog(@"%@",((FlickrByTagViewController*)(segue.destinationViewController)).tagText );
    }
    
    if ([[segue identifier] isEqualToString:@"segueToLocationView"]){
        
        ((FlickrByLocViewController*)(segue.destinationViewController)).locText = self.searchByLocTextField.text;
        NSLog(@"%@",((FlickrByLocViewController*)(segue.destinationViewController)).locText );
    }
    
}

@end
