//
//  PBShareViewController.h
//  PhotoBomber
//
//  Created by Blossom Woo on 8/5/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//
#import <FPPicker/FPPicker.h>
#import <Sincerely/Sincerely.h>
#import <UIKit/UIKit.h>

@interface PBShareViewController : UIViewController<FPSaveDelegate, SYSincerelyControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
