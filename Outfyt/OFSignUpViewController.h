//
//  OFSignUpViewController.h
//  Outfyt
//
//  Created by John Lin on 12/24/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFSignUpViewController : UIViewController

//Text Fields
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)pushNextButton:(id)sender;

@end
