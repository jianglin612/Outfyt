//
//  OFToFriendCell.h
//  Outfyt
//
//  Created by Jiang Lin on 1/18/14.
//  Copyright (c) 2014 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFToFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *header;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *addSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;

@end
