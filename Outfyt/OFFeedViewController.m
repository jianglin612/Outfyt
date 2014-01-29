//
//  OFFeedViewController.m
//  Outfyt
//
//  Created by John Lin on 12/21/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import "OFFeedViewController.h"
#import <Parse/Parse.h>

@interface OFFeedViewController ()

@end

@implementation OFFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        NSLog(@"Current User: %@", currentUser.username);
    }
    else{
        [self performSegueWithIdentifier:@"showLogIn" sender:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
