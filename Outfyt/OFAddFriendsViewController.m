//
//  OFAddFriendsViewController.m
//  Outfyt
//
//  Created by John Lin on 12/27/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import "OFAddFriendsViewController.h"
#import "OFAddFriendCell.h"

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface OFAddFriendsViewController ()

@end

@implementation OFAddFriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.unregisteredContactsToAdd = [NSMutableArray new];
    self.registeredContactsToAdd = [NSMutableArray new];
    
    self.registeredFriendsArray = [NSMutableArray new];
    self.contactsNotOnOutfyt=[NSMutableArray new];
    
    self.currentUser = [PFUser currentUser];
    
    if([self importContacts]){ //puts all contacts into the address book, will return false only if no permission granted
        
        //figure out which phone numbers are already friends and which are new
        NSMutableArray *phoneNumbers=[NSMutableArray new];
        for(NSDictionary *contact in self.allContactsArray){
            [phoneNumbers addObject: contact[@"phoneNumber"]];
        }
        
        //there are 3 options for your friend below:
        
        //2) friend is not using app but you already added him
        //3) friend is not using app and you did not already add him
        
        //1) friend is already using app in which case you pull the user name
        PFQuery *queryRegisteredFriends = [PFUser query];
        [queryRegisteredFriends whereKey:@"mobileNumber" containedIn: [phoneNumbers copy]];
        [queryRegisteredFriends whereKey:@"username" notContainedIn: [phoneNumbers copy]];
        self.registeredFriendsArray = [queryRegisteredFriends findObjects];
        
        //2) friend is not using app but you already added him
        //do nothing he should not be displayed
        
        //3) friend is not using app and you did not already add him
        NSArray *unregisteredRelationsArray=[NSArray new];
        PFQuery *query = [PFQuery queryWithClassName:@"unregisteredFriendRelation"];
        [query includeKey:@"user"];
        [query includeKey:@"friend"];
        [query whereKey:@"user" equalTo:self.currentUser];
        
        unregisteredRelationsArray = [query findObjects];
        
        NSMutableArray *unregisteredFriendsPhoneNumbers = [NSMutableArray new];
        for(PFObject *unregisteredRelation in unregisteredRelationsArray){
            PFUser *unregisteredFriend=unregisteredRelation[@"friend"];
            [unregisteredFriendsPhoneNumbers addObject:unregisteredFriend[@"mobileNumber"]];
        }
        
        //iterate through the list of contacts to see which one it belongs to
        for(NSDictionary *contact in self.allContactsArray){
            if([unregisteredFriendsPhoneNumbers containsObject:contact[@"phoneNumber"]]){
                //do nothing registered friends are already in registered Friends array
            }
            else{
                [self.contactsNotOnOutfyt addObject:contact];
            }
        }

        //sort the contacts
        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
        self.contactsNotOnOutfyt = [[self.contactsNotOnOutfyt sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        
        //people who added me
        //Use Parse to find the people who have added you (to be coded)
        
        //people who are on Outfyt
        //Use Parse to find those with an account on Outfyt
        //query for all the users with mobile phone numbers similar to contacts
        
        //everyone else remaining is not on Outfyt, no need to do anything here
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    //TBD takes care of the registered users
    
    //Takes care of unregistered users
    self.unregisteredPFContactsToAdd=[NSMutableArray new];
    //create the relations
    
    for (NSDictionary *contact in self.unregisteredContactsToAdd) {
        PFQuery *query = [PFUser query];
        [query whereKey:@"mobileNumber" equalTo:contact[@"phoneNumber"]]; // find all the women
        NSArray *pfTemp = [query findObjects];
        
        //if the user is not signed up sign him up
        PFUser *pfContact;
        
        if([pfTemp count]==0){
            pfContact = [PFUser user];
            pfContact.username = contact[@"phoneNumber"];
            pfContact.password = contact[@"phoneNumber"];
            //pfContact.email = contact[@"phoneNumber"];
            pfContact[@"mobileNumber"]=contact[@"phoneNumber"];
            [pfContact signUp];
        }
        else{
            pfContact=pfTemp[0];
        }
        PFObject *relation=[PFObject objectWithClassName:@"unregisteredFriendRelation"];
        [relation setObject:self.currentUser forKey:@"user"];
        [relation setObject:pfContact forKey:@"friend"];
        [relation setObject:contact[@"firstName"] forKey:@"firstName"];
        [relation setObject:contact[@"lastName"] forKey: @"lastName"];
        [relation save];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1; //# of people who added me not done yet
    }
    else if(section==1){
        return [self.registeredFriendsArray count]; //# of people who are on Outfyt
    }
    else{
        return [self.contactsNotOnOutfyt count]; //# of people who are in my contacts not on Outfyt
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"addFriendCell";
    OFAddFriendCell *cell = (OFAddFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(indexPath.section==0){
        //people who added me (TBD, so far everyone who is on Outfyt is lumped together
        //TBD
    }
    else if(indexPath.section==1){
        //people who are on Outfyt (make sure to remove from the sorted array)
        PFUser *user=self.registeredFriendsArray[indexPath.row];
        cell.header.text = user[@"username"];
        cell.label.text = @"";
    }
    else{
        //everyone else
        NSDictionary *contact=self.contactsNotOnOutfyt[indexPath.row];
        cell.label.text= contact[@"phoneNumber"];
        if(contact[@"lastName"]){
            cell.header.text = [NSString stringWithFormat: @"%@ %@",contact[@"firstName"],contact[@"lastName"]];
        }
        else{
            cell.header.text = contact[@"firstName"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    OFAddFriendCell *cell=(OFAddFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
        
    if([cell.switchLabel.text isEqualToString: @"0"]){
        UIImage *image = [UIImage imageNamed: @"icon_star_alt.png"];
        [cell.image setImage:image];
        cell.switchLabel.text=@"1";
        
        if(indexPath.section==1){
            PFUser *user = self.registeredFriendsArray[indexPath.row];
            [self.registeredContactsToAdd addObject: user];
        }
        if(indexPath.section==2){
            NSDictionary *contact=self.contactsNotOnOutfyt[indexPath.row];
            [self.unregisteredContactsToAdd addObject: contact];
        }
    }
    else{
        UIImage *image = [UIImage imageNamed: @"icon_plus_alt2.png"];
        [cell.image setImage:image];
        cell.switchLabel.text=@"0";
        
        if(indexPath.section==1){
            PFUser *user = self.registeredFriendsArray[indexPath.row];
            [self.registeredContactsToAdd removeObject: user];
        }
        if(indexPath.section==2){
            NSDictionary *contact=self.contactsNotOnOutfyt[indexPath.row];
            //if([self.unregisteredContactsToAdd indexOfObject:contact]!=Nil){
            [self.unregisteredContactsToAdd removeObject: contact];
        }
    }
}

//helpers


- (BOOL) importContacts{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    //if no access, request it
    if(!(ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized)){
        NSLog(@"No access");
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                //nothing
            } else {
                //return;
            }
        });
    }
    
    //if still no access, access was denied
    if(!(ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized))
    {
        //set up an image asking for access
        return FALSE;
    }
    
    NSArray *addressBookData = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    self.allContactsArray = [NSMutableArray new];
    for (NSInteger i = 0; i < [addressBookData count]; i++) {
        ABRecordRef person = (__bridge ABRecordRef)addressBookData[i];
        
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            phoneNumber = [self trimPhoneNumber:phoneNumber];

            if(firstName&&phoneNumber){
                if(!lastName){
                    lastName=@""; //cannot return nil otherwise it interferes with the NSDictionary
                }
                NSDictionary *contact = [NSDictionary dictionaryWithObjectsAndKeys:
                                         firstName, @"firstName",
                                         lastName, @"lastName",
                                         phoneNumber, @"phoneNumber",nil];
                [self.allContactsArray addObject:contact];
            }
        }
        CFRelease(phoneNumbers);
    }
    return TRUE;
}

- (NSString *) trimPhoneNumber: (NSString *) phoneNumber{
    NSString *temp= [[phoneNumber componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    if(temp.length>10)
        temp=[temp substringWithRange: NSMakeRange(1,10)];
    return temp;
}


@end
