//
//  OFTabBarController.m
//  Outfyt
//
//  Created by Jiang Lin on 1/25/14.
//  Copyright (c) 2014 Outfyt. All rights reserved.
//

#import "OFTabBarController.h"
#import "OFCameraViewController.h"

@interface OFTabBarController ()

@end

@implementation OFTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if([[tabBar items] indexOfObject:item]==1){
        NSArray *viewControllers = [self viewControllers];
        UINavigationController *nav = viewControllers[1];
        OFCameraViewController *cvc = (OFCameraViewController *) nav.viewControllers[0];
        [cvc viewDidLoad];
    }
}

@end
