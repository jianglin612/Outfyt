//
//  OFSignUpViewController.m
//  Outfyt
//
//  Created by John Lin on 12/24/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import "OFSignUpViewController.h"
#import <Parse/Parse.h>

@interface OFSignUpViewController ()

@end

@implementation OFSignUpViewController

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
    NSLog(@"Loaded");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushNextButton:(id)sender {
    //Puts the values of the field texts into strings
    NSString *userName = self.userNameField.text;
    NSString *password = self.passwordField.text;
    NSString *dateOfBirth = self.dateOfBirthField.text;
    NSString *email = self.emailField.text;
    
    NSString *gender = self.genderField.selectedSegmentIndex==0 ? @"Male" : @"Female";
    
    //Performs checks
    //Needs to be updated and also needs to add better dateOfBirthscroll
    if([userName length]==0 || [password length]==0 || [email length]==0 || [dateOfBirth length]==0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Oops!" message:@"Invalid data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    
    //If checks pass, sign up via parse and also log on too
    else{
        PFUser *newUser = [PFUser user];
        newUser.username = userName;
        newUser.password = password;
        newUser.email = email;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message: [error.userInfo objectForKey:@"Unable to register user"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                //set the other attributes
                newUser[@"gender"]=gender;
                newUser[@"dateOfBirth"]=dateOfBirth;
                [newUser saveInBackground];
                
                //login
                [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *user, NSError *error) {
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message: [error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    }
                    else {
                        [self performSegueWithIdentifier:@"showTutorial1" sender:self];
                    }
                }];
            }
        }];
    }
}
@end
