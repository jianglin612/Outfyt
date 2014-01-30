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

- (IBAction)pushNextButton:(id)sender {
    //Puts the values of the field texts into strings
    NSString *userName = self.userNameField.text;
    NSString *password = self.passwordField.text;
    NSString *dateOfBirth = self.dateOfBirthField.text;
    NSString *email = self.emailField.text;
    NSString *mobileNumber = [self trimPhoneNumber:self.mobileNumberField.text];
    NSString *gender = self.genderField.selectedSegmentIndex==0 ? @"Male" : @"Female";
    
    //Performs checks
    //Needs to be updated and also needs to add better dateOfBirthscroll and need another check for mobile
    if([userName length]==0 || [password length]==0 || [email length]==0 || [dateOfBirth length]==0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Oops!" message:@"Invalid data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    
    else if(![mobileNumber length]==10){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Oops!" message:@"Please enter 9 digit mobile phone number with no dashes or spaces" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    
    //DOB checker
    NSString *dayOfBirthString;
    NSString *monthOfBirthString;
    NSString *yearOfBirthString;
    
    dayOfBirthString = [dateOfBirth substringWithRange:NSMakeRange(0,2)];
    monthOfBirthString = [dateOfBirth substringWithRange:NSMakeRange(2,2)];
    yearOfBirthString = [dateOfBirth substringWithRange:NSMakeRange(4,4)];
    NSInteger dayOfBirthInt = [dayOfBirthString integerValue];
    NSInteger monthOfBirthInt = [monthOfBirthString integerValue];
    NSInteger yearOfBirthInt = [yearOfBirthString integerValue];
    NSInteger leapYearCheck = yearOfBirthInt % 4;
    
    if(yearOfBirthInt<1900 || yearOfBirthInt>2014){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a valid year" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else if(monthOfBirthInt<1 || monthOfBirthInt>12){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a valid month" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else if(dayOfBirthInt<1 || dayOfBirthInt>31){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a valid day" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else if(monthOfBirthInt==4 || monthOfBirthInt==6 || monthOfBirthInt==9 || monthOfBirthInt==11){
        if(dayOfBirthInt==31){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a valid date" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    }
    else if(monthOfBirthInt==2){
        if(dayOfBirthInt==31 || dayOfBirthInt==30 || (dayOfBirthInt==29 && leapYearCheck>0)){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a valid date" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
        }
    }

    //if the user is already an unregistered user (someone else friended you and possibly sent you messages without you signing up yet)
    
    
    //If checks pass, sign up via parse and also log on too
    //need to add a check for the mobile number, which is the key...
    else{
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" equalTo:mobileNumber]; // find all the women
        NSArray *usersWithPhoneNumber = [userQuery findObjects]; //there should only be one
        
        if([usersWithPhoneNumber count]!=0){
            NSLog(@"Phone number already exists!");
            
            [PFUser logInWithUsernameInBackground:mobileNumber password:mobileNumber block:^(PFUser *newUser, NSError *error) {
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message: [error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    }
                    else {
                        [newUser setUsername: userName];
                        newUser.password = password;
                        newUser.email = email;
                        newUser[@"gender"]=gender;
                        newUser[@"dateOfBirth"]=dateOfBirth;
                        newUser[@"mobileNumber"]=mobileNumber;
                        newUser[@"isRegistered"]=[NSNumber numberWithBool:YES];
                        [newUser saveEventually];
                        [self performSegueWithIdentifier:@"showTutorial1" sender:self];
                    }
            }];
        }
        
        //if the user is already an unregistered user (someone else friended you and possibly sent you messages without you signing up yet)
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
                    newUser[@"mobileNumber"]=mobileNumber;
                    newUser[@"isRegistered"]=[NSNumber numberWithBool:YES];
                    [newUser save];
                    
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
}
#pragma -helper methods

- (NSString *) trimPhoneNumber: (NSString *) phoneNumber{
    NSString *temp= [[phoneNumber componentsSeparatedByCharactersInSet:
                      [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                     componentsJoinedByString:@""];
    if(temp.length>10)
        temp=[temp substringWithRange: NSMakeRange(1,10)];
    return temp;
}
@end
