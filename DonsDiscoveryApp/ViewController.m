//
//  ViewController.m
//  DonsDiscoveryApp
//
//  Created by Javier Evelyn on 5/28/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageNamed:@"RabbitNavBar-sky.png"]
     forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)connectToFSwithButton:(id)sender {
}
@end
