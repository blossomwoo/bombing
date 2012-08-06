//
//  PBBackgroundPickerViewController.m
//  PhotoBomber
//
//  Created by Blossom Woo on 8/4/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//

#import "PBBackgroundPickerViewController.h"
#import "PBPhotobomberPickerViewController.h"

@interface PBBackgroundPickerViewController ()
@property (nonatomic) UIImageView *backgroundImageView;

@end

@implementation PBBackgroundPickerViewController
@synthesize backgroundImageView;

#pragma mark - Lifecycle
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
    self.backgroundImageView.hidden = YES;
}

- (void)viewDidUnload {
    [self setBackgroundImageView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y, pickedImage.size.width, pickedImage.size.height);
    self.backgroundImageView.image = pickedImage;
    
    [self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"step2" sender:self];
}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker {
    NSLog(@"FP Cancelled Open");
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PBPhotobomberPickerViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.backgroundImageView = self.backgroundImageView;
}

@end
