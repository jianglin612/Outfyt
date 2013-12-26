//
//  OFCameraViewController.h
//  Outfyt
//
//  Created by John Lin on 12/25/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic,strong) UIImage *chosenImage;
@property (nonatomic,strong) UIImage *resizedImage;
@property (nonatomic,strong) UIImagePickerController *imagePicker;

@property (weak, nonatomic) IBOutlet UITextView *commentField;

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;


@end
