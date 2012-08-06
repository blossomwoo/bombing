//
//  PBPhotobomberPickerViewController.m
//  PhotoBomber
//
//  Created by Blossom Woo on 8/5/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//

#import "PBPhotobomberPickerViewController.h"
#import "PBRemoveBackgroundViewController.h"

@interface PBPhotobomberPickerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photobomberImageView;

@end

@implementation PBPhotobomberPickerViewController
@synthesize backgroundImageView;
@synthesize photobomberImageView;

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
    [self setPhotobomberImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBActions
- (IBAction)pickerModalAction: (id) sender {
    /*
     * Create the object
     */
    FPPickerController *fpController = [[FPPickerController alloc] init];
    
    /*
     * Set the delegate
     */
    fpController.fpdelegate = self;
    
    /*
     * Ask for specific data types. (Optional) Default is all files.
     */
    fpController.dataTypes = [NSArray arrayWithObjects:@"image/*", nil];
    //fpController.dataTypes = [NSArray arrayWithObjects:@"image/*", @"video/quicktime", nil];
    
    /*
     * Select and order the sources (Optional) Default is all sources
     */
    //fpController.sourceNames = [[NSArray alloc] initWithObjects: FPSourceImagesearch, nil];
    
    /*
     * Display it.
     */
    [self presentModalViewController:fpController animated:YES];
}

#pragma mark - FilePickerViewControllerDelegate
- (void)FPPickerController:(FPPickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"FILE CHOSEN: %@", info);
    
    UIImage *pickedImage = [info objectForKey:@"FPPickerControllerOriginalImage"];
    self.photobomberImageView.frame = CGRectMake(self.photobomberImageView.frame.origin.x, self.photobomberImageView.frame.origin.y, pickedImage.size.width, pickedImage.size.height);
    self.photobomberImageView.image = pickedImage;
    
    [self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"step3" sender:self];
}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker {
    NSLog(@"FP Cancelled Open");
    [self dismissModalViewControllerAnimated:YES];
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

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PBRemoveBackgroundViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.backgroundImageView = self.backgroundImageView;
    destinationViewController.croppedPhotobomberImageView = self.photobomberImageView;
}

@end
