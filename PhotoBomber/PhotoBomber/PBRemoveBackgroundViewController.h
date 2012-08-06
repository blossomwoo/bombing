//
//  PBRemoveBackgroundViewController.h
//  PhotoBomber
//
//  Created by Blossom Woo on 8/5/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPhotoEditorController.h"

@interface PBRemoveBackgroundViewController : UIViewController<AFPhotoEditorControllerDelegate>

@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *photobomberImageView;
@property (nonatomic) UIImageView *croppedPhotobomberImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retouchedImageView;

@end
