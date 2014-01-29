//
//  OFToFriendViewController.h
//  Outfyt
//
//  Created by Jiang Lin on 1/18/14.
//  Copyright (c) 2014 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface OFToFriendViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *friendsRelationsToSend;
@property (strong, nonatomic) NSArray *friendRelationsArray;
@property (nonatomic) BOOL sendToPublicSwitch;

@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)pushDoneButton:(id)sender;


@end
