//
//  OFAddTagViewController.h
//  Outfyt
//
//  Created by John Lin on 12/26/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFAddTagViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *brandArray;
@property (strong, nonatomic) NSArray *clothingArray;
@property (weak, nonatomic) NSString *tableType;
@property (weak, nonatomic) NSString *brand;
@property (weak, nonatomic) NSString *clothing;
@property (nonatomic) int indexOfTag;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *brandButton;
@property (weak, nonatomic) IBOutlet UIButton *clothingButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priceSelection;

- (IBAction)pushBrandButton:(id)sender;
- (IBAction)pushClothingButton:(id)sender;
- (IBAction)pushDoneButton:(id)sender;



@end
