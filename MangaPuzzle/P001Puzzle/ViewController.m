//
//  ViewController.m
//  P001Puzzle
//
//  Created by 陈 少佳 on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


int breakBtnStatus =1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [gameView setGameImage:[[UIImage imageNamed:[Data nextInnerImg]] CGImage]];
}


-(void)breakBtnPressed:(id)sender{
    
    switch (breakBtnStatus) {
        case 1:
            breakBtnStatus=2;
            [breakBtn setTitle:@"Pause" forState:UIControlStateNormal];
            
            showSourceBtn.hidden=YES;
            changeImageBtn.hidden=YES;            
            [gameView startBreak];
            break;
        case 2:
            breakBtnStatus=1;
            [breakBtn setTitle:@"Upset" forState:UIControlStateNormal];
            
            showSourceBtn.hidden=NO;
            changeImageBtn.hidden=NO;    
            
            [gameView stopBreak];
            break;
        default:
            break;
    }
}


-(void)changeImageBtnPressed:(id)sender{
    [[[UIActionSheet alloc] initWithTitle:@"Select source image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Puzzle image",@"Camera",@"Gallery",@"Album", nil] showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    UIImagePickerController * upc;
    
    switch (buttonIndex) {
        case 0://内置图片
            [gameView setGameImage:[[UIImage imageNamed:[Data nextInnerImg]] CGImage]];
            break;
        case 1://照像机
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                upc = [[UIImagePickerController alloc] init];
                upc.sourceType = UIImagePickerControllerSourceTypeCamera;
                upc.delegate=self;
                [self presentModalViewController:upc animated:YES];
            }else {
                [[[UIAlertView alloc] initWithTitle:@"Promt" message:@"Dear friend, your device does not have a camera!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            }
            
            break;
        case 2://图库
            
            upc = [[UIImagePickerController alloc] init];
            upc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            upc.delegate=self;
            [self presentModalViewController:upc animated:YES];
            
            break;
        case 3://相册
            upc = [[UIImagePickerController alloc] init];
            upc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            upc.delegate=self;
            [self presentModalViewController:upc animated:YES];
            break;
        default:
            break;
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    [self dismissViewControllerAnimated:YES completion:nil];

    int width = CGImageGetWidth(image.CGImage);
    int height = CGImageGetHeight(image.CGImage);
    int minValue = MIN(width, height);
    
    if (minValue>320) {
        int imageWidth=320;
        
        CGImageRef srcCopy = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, minValue, minValue));
        UIImage * newImage = [UIImage imageWithCGImage:srcCopy];
        
        UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageWidth));
        [newImage drawInRect:CGRectMake(0, 0, imageWidth, imageWidth)];
        [gameView setGameImage:UIGraphicsGetImageFromCurrentImageContext().CGImage];
        UIGraphicsEndImageContext();
        
        CGImageRelease(image.CGImage);
    }else {
        [gameView setGameImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, minValue, minValue))];
        
        CGImageRelease(image.CGImage);
    }
   
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
