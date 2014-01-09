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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    self.contactsNotOnOutfyt=[NSMutableArray new];
    
    if([self importContacts]){ //puts all contacts into the address book, will return false only if no permission granted
        
        //figure out which phone numbers are already friends and which are new
        NSMutableArray *phoneNumbers=[[NSMutableArray alloc]init];
        for(NSDictionary *contact in self.allContactsArray){
            [phoneNumbers addObject: contact[@"phoneNumber"]];
        }
        
        //there are 2 options for your friend
        //1) friend is already using app in which case you pull the user name
        //2) friend is not using app in which case we need to pull name from contacts
        //therefore it needs to be sorted into two lists
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" containedIn: [phoneNumbers copy]];
        [query whereKey:@"username" notContainedIn: [phoneNumbers copy]];
        self.registeredFriendsArray = [query findObjects];
        
        NSMutableArray *registeredFriendsPhoneNumbers = [NSMutableArray new];
        for(PFUser *registeredFriend in self.registeredFriendsArray){
            [registeredFriendsPhoneNumbers addObject:registeredFriend[@"mobileNumber"]];
        }
        
        //iterate through the list of contacts to see which one it belongs to
        for(NSDictionary *contact in self.allContactsArray){
            if([registeredFriendsPhoneNumbers containsObject:contact[@"phoneNumber"]]){
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.unregisteredContactsToAdd = [NSMutableArray new];
    self.registeredContactsToAdd = [NSMutableArray new];
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

    if(indexPath.section==0){
        //users who added me
        //TBD
    }
    else if(indexPath.section==1){
        //users who are on Outfyt
        //TBD
    }
    else{
        //should figure out how to optimize for bulk saving better
        //people who are not on Outfyt
        NSDictionary *contact=self.allContactsSortedArray[indexPath.row];
        
        if(contact == nil)
        {
            NSLog(@"Nil Contact");
        }
        //NSLog(contact);
        //NSLog(self.allContactsSortedArray);
        
        if([cell.switchLabel.text isEqualToString: @"0"]){
            UIImage *image = [UIImage imageNamed: @"icon_star_alt.png"];
            [cell.image setImage:image];
            cell.switchLabel.text=@"1";
            //self.unregisteredContactsToAdd=[[NSMutableArray alloc] init];
            [self.unregisteredContactsToAdd addObject: contact];
        }
        else{
            UIImage *image = [UIImage imageNamed: @"icon_plus_alt2.png"];
            [cell.image setImage:image];
            cell.switchLabel.text=@"0";
            if([self.unregisteredContactsToAdd indexOfObject:contact]!=Nil){
                [self.unregisteredContactsToAdd removeObject: contact];
            }
        }
    }
    
/*
    //PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    //PFRelation *friendsRelation = [self.currentUser relationforKey:@"friendRelation"];
    
    if ([self isFriend:user])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for (PFUser *friend in self.friends){
            if ([friend.objectId isEqualToString: user.objectId]){
                [self.friends removeObject:friend];
                break;
            }
        }
        
        [friendsRelation removeObject:user];
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self.friends addObject: user];
        [friendsRelation addObject:user];
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"error");
        }
    }];
 */
}
/*
-(BOOL)isFriend:(PFUser *)user{
    for (PFUser *friend in self.friends){
        if ([friend.objectId isEqualToString: user.objectId]){
            return YES;
        }
    }
    return NO;
}
*/






/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

//helper methods

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
