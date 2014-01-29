//
//  OFToFriendViewController.m
//  Outfyt
//
//  Created by Jiang Lin on 1/18/14.
//  Copyright (c) 2014 Outfyt. All rights reserved.
//

#import "OFToFriendViewController.h"
#import "OFToFriendCell.h"
#import "OFCameraViewController.h"

@interface OFToFriendViewController ()

@end

@implementation OFToFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsRelationsToSend=[NSMutableArray new];\
    self.sendToPublicSwitch=FALSE;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PFUser *currentUser=[PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"friendRelation"];
    [query whereKey:@"user" equalTo: currentUser];
    [query includeKey:@"friend"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        self.friendRelationsArray=results;
        [self.myTableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 2;
    }
    else{
        return [self.friendRelationsArray count];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OFToFriendCell";
    OFToFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.section==0){
        if(indexPath.row==0){
            cell.header.text=@"Public";
        }
        else{
            cell.header.text=@"All Friends";
        }
    }
    if(indexPath.section==1){
        PFObject *relation = self.friendRelationsArray[indexPath.row];
        PFObject *friend=relation[@"friend"];
        
        cell.label.text=friend[@"username"];
        cell.header.text=[NSString stringWithFormat: @"%@ %@",relation[@"firstName"],relation[@"lastName"]];

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:NO];
    OFToFriendCell *cell=(OFToFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.addSwitch.text isEqualToString: @"0"]){
        UIImage *image = [UIImage imageNamed: @"icon_star_alt.png"];
        [cell.addImage setImage:image];
        cell.addSwitch.text=@"1";
        if(indexPath.section==0&&indexPath.row==0){
            self.sendToPublicSwitch=TRUE;
        }
        if(indexPath.section==0&&indexPath.row==1){
            //to be implemented
        }
        if(indexPath.section==1){
            [self.friendsRelationsToSend addObject: self.friendRelationsArray[indexPath.row]];
        }
    }
    else{
        UIImage *image = [UIImage imageNamed: @"icon_plus_alt2.png"];
        [cell.addImage setImage:image];
        cell.addSwitch.text=@"0";
        
        if(indexPath.section==0&&indexPath.row==0){
            self.sendToPublicSwitch=FALSE;
            
        }
        if(indexPath.section==0&&indexPath.row==1){
            //to be implemented
        }
        if(indexPath.section==1){
            [self.friendsRelationsToSend removeObject: self.friendRelationsArray[indexPath.row]];
        }
    }
    self.toLabel.text=[self convertToText:self.friendsRelationsToSend sendToPublic:self.sendToPublicSwitch];
    
    
}

-(NSString *)convertToText:(NSMutableArray *)relationsToSend sendToPublic:(BOOL) toPublic{
    NSMutableString *friendsToSendString = [NSMutableString new];
    
    if(toPublic){
        [friendsToSendString appendString:@"Public, "];
    }
    for (PFObject *relation in relationsToSend){
        if(relation[@"firstName"]==NULL){
            PFObject *friend=relation[@"friend"];
            [friendsToSendString appendFormat: @"blah%@, ", friend[@"username"]];
        }
        else{
            [friendsToSendString appendFormat: @"%@ %@, ", relation[@"firstName"], relation[@"lastName"]];
        }
    }
    if([friendsToSendString length]>1){
        return [friendsToSendString substringToIndex:[friendsToSendString length]-2];
    }
    return @"";
}

- (IBAction)pushDoneButton:(id)sender {
    OFCameraViewController *rvc=(OFCameraViewController *) self.navigationController.viewControllers[0];
    //prepare for returning to the main camera view
    NSString *toFriendsString = [self convertToText:self.friendsRelationsToSend sendToPublic:self.sendToPublicSwitch];
    NSMutableArray *friendsToSendArray=[NSMutableArray new];
    for (PFObject *relation in self.friendsRelationsToSend){
        [friendsToSendArray addObject:relation[@"friend"]];
    }
    
    [rvc prepareFriendsToSendTo: friendsToSendArray withText: toFriendsString withSendToPublic:self.sendToPublicSwitch];

    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
