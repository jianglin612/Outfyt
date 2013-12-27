//
//  OFAddTagViewController.m
//  Outfyt
//
//  Created by John Lin on 12/26/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import "OFAddTagViewController.h"
#import "OFAddTagCell.h"
#import "OFCameraViewController.h"

@interface OFAddTagViewController ()

@end

@implementation OFAddTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //hardcoded arrays for brand and clothing
    self.brandArray = [[NSArray alloc] initWithObjects: @"Gap", @"Banana Republic", @"JCrew", @"Nike", @"Coach", @"Lacoste", nil];
    self.clothingArray = [[NSArray alloc] initWithObjects: @"Shirt", @"Dress", @"Pants", @"Shorts", @"Shoes", @"Necklace", nil];
    self.tableType=@"Brand";
    self.brand=@"";
    self.clothing=@"";
    
    [self.myTableView setHidden: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushBrandButton:(id)sender {
    self.tableType=@"Brand";
    [self.myTableView reloadData];
    [self.myTableView setHidden: NO];
}

- (IBAction)pushClothingButton:(id)sender {
    self.tableType=@"Clothing";
    [self.myTableView reloadData];
    [self.myTableView setHidden: NO];
}

- (IBAction)pushDoneButton:(id)sender {
    NSString *price =[self.priceSelection titleForSegmentAtIndex:self.priceSelection.selectedSegmentIndex];
    OFCameraViewController *rvc=(OFCameraViewController *) self.navigationController.viewControllers[0];
    [rvc addTagWithBrand:self.brand withClothing:self.clothing withPrice:price];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//tag table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.tableType isEqualToString:@"Brand"]){
        return self.brandArray.count;
    }
    else if([self.tableType isEqualToString:@"Clothing"]){
        return self.clothingArray.count;
    }
    else{
        //should never reach here
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"cell";
    OFAddTagCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if([self.tableType isEqualToString:@"Brand"]){
        cell.label.text= [self.brandArray objectAtIndex:indexPath.row];
        
        //set image
        UIImage *cellImage = [UIImage imageNamed: @"icon_cogs.png"];
        [cell.image setImage: cellImage];
    }
    else if([self.tableType isEqualToString:@"Clothing"]){
        cell.label.text= [self.clothingArray objectAtIndex:indexPath.row];
        
        //set image
        UIImage *cellImage = [UIImage imageNamed: @"icon_cogs.png"];
        [cell.image setImage: cellImage];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:NO];
    if([self.tableType isEqualToString:@"Brand"]){
        self.brand = [self.brandArray objectAtIndex:indexPath.row];
        [self.brandButton setTitle:self.brand forState:UIControlStateNormal];
    }
    else if([self.tableType isEqualToString:@"Clothing"]){
        self.clothing = [self.clothingArray objectAtIndex:indexPath.row];
        [self.clothingButton setTitle:self.clothing forState:UIControlStateNormal];
    }
}



@end
