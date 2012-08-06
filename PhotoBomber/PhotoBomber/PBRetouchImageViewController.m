//
//  PBRetouchImageViewController.m
//  PhotoBomber
//
//  Created by Blossom Woo on 8/5/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//

#import "AFPhotoEditorController.h"
#import "GPUImage.h"
#import "PBRetouchImageViewController.h"
#import "PBShareViewController.h"

@interface PBRetouchImageViewController () {
    UIView *canvas;
    CAShapeLayer *_marque;
    CGFloat _lastScale;
    CGFloat _lastRotation;
    CGFloat _firstX;
    CGFloat _firstY; 
}
@end

@implementation PBRetouchImageViewController
@synthesize backgroundImageView;
@synthesize croppedPhotobomberImageView;
@synthesize imageContainerView;
@synthesize retouchedImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload {
    [self setBackgroundImageView:nil];
    [self setCroppedPhotobomberImageView:nil];
    [self setImageContainerView:nil];
    [self setRetouchedImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Helper methods
- (void)mashImages {
    UIImage *originalImage = self.backgroundImageView.image;
    UIImage *noiseLayer = self.croppedPhotobomberImageView.image;
    
    //    if ([self uploadFile:UIImagePNGRepresentation(noiseLayer)]) {
    
    GPUImageOverlayBlendFilter *overlayBlendFilter = [[GPUImageOverlayBlendFilter alloc] init];
    GPUImagePicture *pic1 = [[GPUImagePicture alloc] initWithImage:originalImage];
    GPUImagePicture *pic2 = [[GPUImagePicture alloc] initWithImage:noiseLayer];
    
    [pic1 addTarget:overlayBlendFilter];
    [pic1 processImage];
    [pic2 addTarget:overlayBlendFilter];
    [pic2 processImage];
    
//    UIImage *blendedImage = [overlayBlendFilter imageFromCurrentlyProcessedOutputWithOrientation:originalImage.imageOrientation];
    
    //Blend Image Method 1 
//    [self displayEditorForImage:blendedImage];
    
    //Blend Image Method 2
    [self displayEditorForImage:[self imageWithView:self.imageContainerView]];
}

//Merge uiview
- (UIImage *) imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)displayEditorForImage:(UIImage *)imageToEdit {
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    [self presentModalViewController:editorController animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
        return NO;
    }
    return YES;
}

- (void)showOverlayWithFrame:(CGRect)frame {
    if (![_marque actionForKey:@"linePhase"]) {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.5f];
        [dashAnimation setRepeatCount:HUGE_VALF];
        [_marque addAnimation:dashAnimation forKey:@"linePhase"];
    }
    
    _marque.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    _marque.position = CGPointMake(frame.origin.x + canvas.frame.origin.x, frame.origin.y + canvas.frame.origin.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);
    [_marque setPath:path];
    CGPathRelease(path);
    
    _marque.hidden = NO;
}

- (IBAction)scale:(UIGestureRecognizer *)sender {
    if ([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = self.croppedPhotobomberImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.croppedPhotobomberImageView setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    [self showOverlayWithFrame:self.croppedPhotobomberImageView.frame];
}

- (IBAction)rotate:(UIGestureRecognizer *)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = self.croppedPhotobomberImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self.croppedPhotobomberImageView setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    [self showOverlayWithFrame:self.croppedPhotobomberImageView.frame];
}


- (IBAction)move:(UIGestureRecognizer *)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:canvas];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [self.croppedPhotobomberImageView center].x;
        _firstY = [self.croppedPhotobomberImageView center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [self.croppedPhotobomberImageView setCenter:translatedPoint];
    [self showOverlayWithFrame:self.croppedPhotobomberImageView.frame];
}

- (IBAction)tapped:(UIGestureRecognizer *)sender{
    _marque.hidden = YES;
}

#pragma mark - Aviary Methods
- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image {
    self.retouchedImageView.image = image;
    [self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"step5" sender:self];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - IBActions
- (IBAction)nextButtonPressed:(id)sender {
    // mash images
    [self mashImages];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PBShareViewController *destinationViewController = segue.destinationViewController;
    // force view to load IBOutlets
    if ([destinationViewController view]) {
        destinationViewController.imageView.image = self.retouchedImageView.image;
    }
}

@end
