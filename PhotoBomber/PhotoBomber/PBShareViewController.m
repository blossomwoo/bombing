//
//  PBShareViewController.m
//  PhotoBomber
//
//  Created by Blossom Woo on 8/5/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//

#import <FPPicker/FPPicker.h>
#import <Sincerely/Sincerely.h>
#import "PBShareViewController.h"

@interface PBShareViewController ()

@end

@implementation PBShareViewController
@synthesize imageView;

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBActions
- (IBAction)shareButtonPressed:(id)sender {
    if (self.imageView.image == nil){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nothing to Save"
                                                          message:@"Select an image first."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
    }
    
    NSData *imgData = UIImagePNGRepresentation(self.imageView.image);
    
    /*
     * Create the object
     */
    FPSaveController *fpSave = [[FPSaveController alloc] init];
    
    /*
     * Set the delegate
     */
    fpSave.fpdelegate = self;
    
    /*
     * Select and order the sources (Optional) Default is all sources
     */
    //fpSave.sourceNames = [[NSArray alloc] initWithObjects: FPSourceDropbox, FPSourceFacebook, FPSourceBox, nil];
    
    /*
     * Set the data and data type to be saved.
     */
    fpSave.data = imgData;
    fpSave.dataType = @"image/png";
    
    /*
     * Display it.
     */
    [self presentModalViewController:fpSave animated:YES];
}

- (IBAction)mailButtonPressed:(id)sender {
    if (!self.imageView.image) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Publishing Error" message:@"Please create an image first" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]; 
        [alertView show];
        return;
    }
    
    SYSincerelyController *controller = [[SYSincerelyController alloc] initWithImages:[NSArray arrayWithObject:self.imageView.image]
                                                                              product:SYProductTypePostcard
                                                                       applicationKey:@"5CR3PSEXU4WK7IHYHF54CI7B3ECQPNQW2SIJ8PEI"
                                                                             delegate:self];
    
    if (controller) {
        [self presentModalViewController:controller animated:YES];
    }
}

- (IBAction)restartButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - FPSaveControllerDelegate Methods

- (void)FPSaveController:(FPSaveController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"FILE SAVED: %@", info);
    [self dismissModalViewControllerAnimated:YES];
}
- (void)FPSaveControllerDidCancel:(FPSaveController *)picker {
    NSLog(@"FP Cancelled Save");
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SYSincerelyControllerDelegate methods
- (void)sincerelyControllerDidFinish:(SYSincerelyController *)controller {
    /*
     * Here I know that the user made a purchase and I can do something with it
     */
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sincerelyControllerDidCancel:(SYSincerelyController *)controller {
    /*
     * Here I know that the user hit the cancel button and they want to leave the Sincerely controller
     */
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sincerelyControllerDidFailInitiationWithError:(NSError *)error {
    /*
     * Here I know that incorrect inputs were given to initWithImages:product:applicationKey:delegate;
     */
    
    NSLog(@"Error: %@", error);
}    

@end
