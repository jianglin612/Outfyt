//
//  OFFriendsViewController.h
//  Outfyt
//
//  Created by John Lin on 12/30/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFFriendsViewController : UITableViewController

@property (nonatomic,strong) NSArray *unregisteredFriendRelations;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
