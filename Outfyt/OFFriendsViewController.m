//
//  OFFriendsViewController.m
//  Outfyt
//
//  Created by John Lin on 12/30/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import "OFFriendsViewController.h"
#import "OFFriendCell.h"
#import <Parse/Parse.h>

@interface OFFriendsViewController ()

@end

@implementation OFFriendsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PFUser *currentUser=[PFUser currentUser];

    PFQuery *query = [PFQuery queryWithClassName:@"friendRelation"];
    [query whereKey:@"user" equalTo: currentUser];
    [query includeKey:@"friend"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        self.unregisteredFriendRelations=results;
        [self.myTableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 0;//to be implemented
    }
    else{
        return [self.unregisteredFriendRelations count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendCell";
    OFFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *unregisteredFriendRelation=self.unregisteredFriendRelations[indexPath.row];
    PFObject *unregisteredFriend=unregisteredFriendRelation[@"friend"];
    
    cell.label.text= unregisteredFriend[@"username"];
    cell.header.text=[NSString stringWithFormat: @"%@ %@",unregisteredFriendRelation[@"firstName"],unregisteredFriendRelation[@"lastName"]];
    
    return cell;
}

@end
