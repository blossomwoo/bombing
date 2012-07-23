//
//  PBFilePickerViewController.h
//  PhotoBomber
//
//  Created by Blossom Woo on 7/22/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBFilePickerViewController;

@protocol PBFilePickerDelegate <NSObject>
- (void)filePickerViewControllerDidCancel:(PBFilePickerViewController *)controller;
- (void)filePickerViewControllerDidSave:(PBFilePickerViewController *)controller;
@end

@interface PBFilePickerViewController : UITableViewController

@property (nonatomic, weak) id <PBFilePickerDelegate> delegate;

@end
