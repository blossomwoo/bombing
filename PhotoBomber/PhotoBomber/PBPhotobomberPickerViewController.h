//
//  PBPhotobomberPickerViewController.h
//  PhotoBomber
//
//  Created by Blossom Woo on 8/5/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//
#import <FPPicker/FPPicker.h>
#import <UIKit/UIKit.h>

@interface PBPhotobomberPickerViewController : UIViewController<FPPickerDelegate>
@property (nonatomic) UIImageView *backgroundImageView;
@end
