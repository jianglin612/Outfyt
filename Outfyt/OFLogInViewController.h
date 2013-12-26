//
//  OFLogInViewController.h
//  Outfyt
//
//  Created by John Lin on 12/24/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFLogInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)pushLogInButton:(id)sender;
- (IBAction)pushForgotPasswordButton:(id)sender;

@end
