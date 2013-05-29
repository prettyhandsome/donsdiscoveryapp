//
//  ViewController.m
//  DonsDiscoveryApp
//
//  Created by Javier Evelyn on 5/28/13.
//  Copyright (c) 2013 MMA Team 3. All rights reserved.
//

#import "ViewController.h"
#import "FlickrByLocViewController.h"
#import "FlickrByTagViewController.h"
#import "FlickrByTagCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
