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
#import "BunnyTail.h"
#import "FSVenueDetailViewController.h"


@interface LandingViewController ()

@property (strong, nonatomic) NSArray *landingOptions;
@property (strong, nonatomic) NSString *searchStringOption;

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
    
//login to foursquare items
    self.loginWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.loginWebView.delegate = self;
    NSString *authenticateURLString = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@",kClientID,kRedirectURI];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    NSLog(@"viewDidLoad");
    [self.loginWebView loadRequest:request];
    [self.view addSubview:self.loginWebView];
    
    [self.bunnyTail rabbitTailBounce];

    
// related to table view for generating tag search collection, and segue to gallery view
    self.landingOptions = [NSArray arrayWithObjects: @"food", @"drink", @"art & architecture", @"events", @"feeling lucky", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 
#pragma mark Login to Foursquare

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
    NSLog(@"Either logged in or offline.");
    [self.loginWebView removeFromSuperview];
}

//oauth_token=ACCESS_TOKEN  <-- add this to the end of search requests to get user specific results.

#pragma
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.landingOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
    }
    
    UIImage *background = [UIImage imageNamed:@"grassyTableCell.png"];
    cell.backgroundView = [[UIImageView alloc] initWithImage:background];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.landingOptions objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    return cell;
}

#pragma
#pragma mark Segue to search collection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.searchStringOption = [self.landingOptions objectAtIndex:indexPath.row];
     [self.landingOptionsTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"segueToTaggedView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSArray *luckySearchStrings = [NSArray arrayWithObjects: @"awesome", @"cool", @"amazing", @"beautiful", @"fun", @"great", @"delicious", nil];
    
    int luckyIndexPath = arc4random()%(luckySearchStrings.count-1);
    NSString *luckySearch = luckySearchStrings[luckyIndexPath];
    
    if ([self.searchStringOption isEqualToString:@"feeling lucky"]) {
        ((FlickrByTagViewController*)(segue.destinationViewController)).tagText = luckySearch;
    } else {
        ((FlickrByTagViewController*)(segue.destinationViewController)).tagText = self.searchStringOption;
    }
    

        NSLog(@"%@",((FlickrByTagViewController*)(segue.destinationViewController)).tagText );
   
}

@end
