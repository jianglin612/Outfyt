//
//  OFCameraViewController.h
//  Outfyt
//
//  Created by John Lin on 12/25/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,strong) UIImage *chosenImage;
@property (nonatomic,strong) UIImage *resizedImage;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSMutableArray *tagArray;

@property (weak, nonatomic) IBOutlet UILabel *toFriendsField;
@property (weak, nonatomic) IBOutlet UITextView *commentField;
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;
@property (weak, nonatomic) IBOutlet UILabel *toField;

- (IBAction)pushToButton:(id)sender;



- (void)addTagWithBrand: (NSString *)brand withClothing: (NSString  *)clothing withPrice: (NSString *)price;



@end
