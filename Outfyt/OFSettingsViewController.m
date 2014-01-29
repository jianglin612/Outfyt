//
//  OFSettingsViewController.m
//  Outfyt
//
//  Created by John Lin on 12/25/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import "OFSettingsViewController.h"
#import <Parse/Parse.h>

@interface OFSettingsViewController ()

@end

@implementation OFSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //fills in the Username, mobile #, and email
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *user in objects) {
                self.username.text=user[@"username"];
                self.mobileNumber.text = user[@"mobileNumber"];
                self.email.text=user[@"email"];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section==1 && indexPath.row==1){
        [PFUser logOut];
        [self performSegueWithIdentifier:@"showLogIn" sender:self];
    }
}
@end
