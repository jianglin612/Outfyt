//
//  OFCameraViewController.m
//  Outfyt
//
//  Created by John Lin on 12/25/13.
//  Copyright (c) 2013 Outfyt. All rights reserved.
//

#import "OFCameraViewController.h"
#import "OFTagCell.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface OFCameraViewController ()

@end

@implementation OFCameraViewController

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
    
    //Camera
    //Need to disable video (TBD, do not have working iphone)
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate=self;
    self.imagePicker.allowsEditing = NO;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    
    [self presentViewController:self.imagePicker animated:NO completion:nil];
    
    //other setup for tableView
    self.tagTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tagTableView setBackgroundColor:[UIColor clearColor]];
    [self setUpRightSwipe];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tagTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    //photo was taken/selected
    if([mediaType isEqualToString: (NSString *)kUTTypeImage]){
        self.chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *temp = [self cropImage: self.chosenImage toSize:(CGSizeMake(320.0f, 320.0f))];
        self.resizedImage = [self resizeImage: temp toWidth:320.0f andHeight:320.0f];
        
        self.imagePreview.image = self.resizedImage;
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //otherwise reset to the feed
    else{
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.tabBarController setSelectedIndex:0];
    }
}

//helper methods

-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    CGSize newSize = CGSizeMake(width,height);
    CGRect newRectangle = CGRectMake(0,0,width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)cropImage:(UIImage *)originalImage toSize:(CGSize)cropSize{
    //calculate scale factor to go between cropframe and original image
    float SF = originalImage.size.width / cropSize.width;
    
    //find the centre x,y coordinates of image
    float centreX = originalImage.size.width / 2;
    float centreY = originalImage.size.height / 2;
    
    //calculate crop parameters
    float cropX = centreX - ((cropSize.width / 2) * SF);
    float cropY = centreY - ((cropSize.height / 2) * SF);
    
    CGRect cropRect = CGRectMake(cropX, cropY, (cropSize.width *SF), (cropSize.height * SF));
    
    CGAffineTransform rectTransform;
    switch (originalImage.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI_2), 0, -originalImage.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI_2), -originalImage.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI), -originalImage.size.width, -originalImage.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, originalImage.scale, originalImage.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectApplyAffineTransform(cropRect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:originalImage.scale orientation:originalImage.imageOrientation];
    CGImageRelease(imageRef);
    //return result;
    
    //Now want to scale down cropped image!
    //want to multiply frames by 2 to get retina resolution
    CGRect scaledImgRect = CGRectMake(0, 0, (cropSize.width * 2), (cropSize.height * 2));
    
    UIGraphicsBeginImageContextWithOptions(scaledImgRect.size, NO, [UIScreen mainScreen].scale);
    
    [result drawInRect:scaledImgRect];
    
    UIImage *scaledNewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledNewImage;
    
}

- (void)setUpRightSwipe {
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(swipeRight:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tagTableView addGestureRecognizer:recognizer];
    recognizer.delegate = self;
}

//this method is called to help add a tag
- (void)addTagWithBrand: (NSString *)brand withClothing: (NSString  *)clothing withPrice: (NSString *)price{
    NSArray *tag = [[NSArray alloc] initWithObjects: brand,clothing,price,nil];
    if (!self.tagArray) self.tagArray = [[NSMutableArray alloc] init];
    [self.tagArray addObject:tag];
}

- (void)removeTagAtIndex:(int)index{
    [self.tagArray removeObjectAtIndex:index];
}

//tag table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tagArray count]+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier;
    
    if(indexPath.row==0){
        //add tag cell
        cellIdentifier=@"addTagCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        return cell;
    }
    else{
        //tag cells, need to be updated with the correct tags from the tagArray
        cellIdentifier=@"tagCell";
        OFTagCell *cell = (OFTagCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *tagAtIndexPath=[self.tagArray objectAtIndex:(indexPath.row-1)];
        cell.brand.text = [tagAtIndexPath objectAtIndex:0];
        cell.clothing.text = [tagAtIndexPath objectAtIndex:1];
        cell.price.text = [tagAtIndexPath objectAtIndex:2];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tagTableView deselectRowAtIndexPath:indexPath animated:NO];
    //should set up a warning to the number of tags you can add (to be created)
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.tagTableView];
    NSIndexPath *indexPath = [self.tagTableView indexPathForRowAtPoint:location];
    [self removeTagAtIndex:(indexPath.row-1)];
    //add some fancy animation (to be created)
    [self.tagTableView reloadData];
}

@end
