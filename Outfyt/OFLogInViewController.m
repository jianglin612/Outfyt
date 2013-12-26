//
//  OFLogInViewController.m
//  Outfyt
//
//  Created by John Lin on 12/24/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import "OFLogInViewController.h"
#import <Parse/Parse.h>

@interface OFLogInViewController ()

@end

@implementation OFLogInViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushLogInButton:(id)sender {
    NSString *userName = self.userNameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *user, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message: [error.userInfo objectForKey:@"Invalid User Name or Password"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)pushForgotPasswordButton:(id)sender {
    //implement reset password (TBD)
}


@end
