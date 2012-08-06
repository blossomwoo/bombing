//
//  PBRetouchImageViewController.h
//  PhotoBomber
//
//  Created by Blossom Woo on 8/5/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBRetouchImageViewController : UIViewController<AFPhotoEditorControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *croppedPhotobomberImageView;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *retouchedImageView;

@end
