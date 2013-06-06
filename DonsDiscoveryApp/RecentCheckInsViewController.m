//
//  RecentCheckInsViewController.m
//  DonsDiscoveryApp
//
//  Created by Sonam Dhingra on 6/3/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "RecentCheckInsViewController.h"
#import "LandingViewController.h"

@interface RecentCheckInsViewController ()
{
    NSMutableArray *recentCheckInInfoArray;
    NSString *recentUserFullName;
    
}

-(void) getRecentCheckInsFromFSURLRequest;

@end

@implementation RecentCheckInsViewController




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
	// Do any additional setup after loading the view.
    [self getRecentCheckInsFromFSURLRequest];
  //  [_checkinTableView reloadData];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getRecentCheckInsFromFSURLRequest {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults stringForKey:@"access_token"];
    NSLog(@"access token  %@",accessToken);
    
    NSString *checkInURLString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/checkins/recent?oauth_token=%@&ll=44.65,-87.65&limit=100&v=20130603",accessToken];
    
    checkInURLString = [checkInURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:checkInURLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
                               
    NSDictionary *resultsFromCheckInURL = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
                               NSDictionary *resultsDict = [resultsFromCheckInURL objectForKey:@"response"];
                               NSArray *recentCheckIns = [resultsDict objectForKey:@"recent"];
                               
                               // Declare Mutable Array here and we will add the data we get from fast enumeration to it. 
                               recentCheckInInfoArray = [[NSMutableArray alloc] init];
                               
                               for (NSDictionary *checkInInfoDict in recentCheckIns) {
                                   
                                   NSString *firstName = [[checkInInfoDict objectForKey:@"user"] objectForKey:@"firstName"];
                                   NSString *lastName = [[checkInInfoDict objectForKey:@"user"] objectForKey:@"lastName"];
                                   
                                   if (lastName == nil) {
                                       
                                    lastName = @"";
                                   } 
                                  
                                   recentUserFullName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
                                   [recentCheckInInfoArray addObject:recentUserFullName];
                                   
                               }
                               
                               NSLog(@"recent check in array has %@",recentCheckInInfoArray);
                               [_checkinTableView reloadData];
    
                           }];

    }


#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1; 
    
}

//-(void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    
//}

//Add section title "Recent Check Ins"
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    section = 0;
    return @"Recent Check ins";
}

        
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return recentCheckInInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSString *identifier = @"myIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];



}
    cell.textLabel.text = recentCheckInInfoArray[indexPath.row];
    return cell;
}

@end
