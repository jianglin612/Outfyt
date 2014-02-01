//
//  OFFeedViewController.h
//  Outfyt
//
//  Created by John Lin on 12/21/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFFeedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *publicFriendSwitch;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
