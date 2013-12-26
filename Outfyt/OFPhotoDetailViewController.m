//
//  OFPhotoDetailViewController.m
//  Outfyt
//
//  Created by John Lin on 12/21/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import "OFPhotoDetailViewController.h"

@interface OFPhotoDetailViewController ()

@end

@implementation OFPhotoDetailViewController

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
	[self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 700)];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
