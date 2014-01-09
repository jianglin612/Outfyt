//
//  OFAddFriendsViewController.h
//  Outfyt
//
//  Created by John Lin on 12/27/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface OFAddFriendsViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *allContactsArray; //ideally this is a sorted dictionary or something...
@property (nonatomic,strong) NSMutableArray *allContactsSortedArray; //ideally this is a sorted dictionary or something...
@property (nonatomic,strong) NSArray *registeredFriendsArray;

@property (nonatomic,strong) NSMutableArray *contactsNotOnOutfyt;

@property (nonatomic,strong) NSMutableArray *unregisteredContactsToAdd;
@property (nonatomic,strong) NSMutableArray *registeredContactsToAdd;

@property (nonatomic,strong) NSMutableArray *unregisteredPFContactsToAdd; //this is probably extra code but will make it easier to seperate out the parse stuff if we choose to move away from it
@property (nonatomic,strong) NSMutableArray *registeredPFContactsToAdd;

@property (nonatomic, strong) PFUser *currentUser;



@end
