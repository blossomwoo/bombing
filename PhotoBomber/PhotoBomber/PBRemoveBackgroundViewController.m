//
//  PBRemoveBackgroundViewController.m
//  PhotoBomber
//
//  Created by Blossom Woo on 8/5/12.
//  Copyright (c) 2012 Jawbone. All rights reserved.
//

#import "PBRemoveBackgroundViewController.h"
#import "PBRetouchImageViewController.h"
#import "SBJsonParser.h"

@interface PBRemoveBackgroundViewController ()

@end

@implementation PBRemoveBackgroundViewController

@synthesize backgroundImageView;
@synthesize photobomberImageView;
@synthesize croppedPhotobomberImageView;
@synthesize retouchedImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self uploadFile:UIImagePNGRepresentation(self.croppedPhotobomberImageView.image)]) {
        // mash layers together
        [self performSegueWithIdentifier:@"step4" sender:self];
    } else {
        // TODO: show error message
    }
}

- (void)viewDidUnload
{
    [self setRetouchedImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Uploading file

-(BOOL)uploadFile:(NSData *)data
{
    // variables
    NSURL *url;
    NSMutableURLRequest *request;
    NSURLResponse *response;
    NSError *err;
    NSData *responseData;
    NSString *imageId;
    
    NSString *apiUrl = @"http://flashfotoapi.com/api/";
    NSString *username = @"philster";
    NSString *apiKey = @"LUPbRi4fzoWpCjh3ieFVcHZbMCmlrWbs";
    
    // upload photo
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@add/?privacy=public&partner_username=%@&partner_apikey=%@", apiUrl, username, apiKey]];
    request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSLog(@"responseData: %@", responseData);
    
    // parse json response
    NSString* jsonString = [[NSString alloc] initWithData:responseData
                                                 encoding:NSUTF8StringEncoding];    
    NSLog(@"jsonString: %@", jsonString);
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonObjects = [jsonParser objectWithString:jsonString error:&error];
    NSLog(@"jsonObjects: %@", jsonObjects);
    
    NSDictionary *imageVersionDictionary = [jsonObjects objectForKey:@"ImageVersion"];
    imageId = [imageVersionDictionary objectForKey:@"image_id"];
    NSLog(@"image id: %@", imageId);
    
    // detect face
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@findfaces/%@?partner_username=%@&partner_apikey=%@", apiUrl, imageId, username, apiKey]];
    request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSLog(@"responseData: %@", responseData);
    jsonString = [[NSString alloc] initWithData:responseData
                                       encoding:NSUTF8StringEncoding];    
    NSLog(@"jsonString: %@", jsonString);
    
    // if json is just "[]", then no face was detected
    if ([jsonString length] <= 2) {
        return NO;
    }
    
    // remove the background
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@segment/%@?partner_username=%@&partner_apikey=%@", apiUrl, imageId, username, apiKey]];
    request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSLog(@"responseData: %@", responseData);
    jsonString = [[NSString alloc] initWithData:responseData
                                       encoding:NSUTF8StringEncoding];    
    NSLog(@"jsonString: %@", jsonString);
    
    // parse json response
    jsonObjects = [jsonParser objectWithString:jsonString error:&error];
    NSLog(@"jsonObjects: %@", jsonObjects);
    NSString *segmentationStatus = [jsonObjects objectForKey:@"segmentation_status"];
    
    while (![segmentationStatus isEqualToString:@"finished"]) {
        // check segment status
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@segment_status/%@?partner_username=%@&partner_apikey=%@", apiUrl, imageId, username, apiKey]];
        request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"responseData: %@", responseData);
        jsonString = [[NSString alloc] initWithData:responseData
                                           encoding:NSUTF8StringEncoding];    
        NSLog(@"jsonString: %@", jsonString);
        
        jsonObjects = [jsonParser objectWithString:jsonString error:&error];
        NSLog(@"jsonObjects: %@", jsonObjects);
        segmentationStatus = [jsonObjects objectForKey:@"segmentation_status"];
    }
    
    if (![segmentationStatus isEqualToString:@"finished"]) {
        return NO;
    }
    
    // get resulting PNG with transparency image
    NSString *urlString = [NSString stringWithFormat:@"%@get/%@?version=HardMasked&partner_username=%@&partner_apikey=%@", apiUrl, imageId, username, apiKey];
    request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody:data];
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSLog(@"responseData: %@", responseData);
    jsonString = [[NSString alloc] initWithData:responseData
                                       encoding:NSUTF8StringEncoding];    
    NSLog(@"jsonString: %@", jsonString);
    UIImage *maskedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    self.croppedPhotobomberImageView.image = maskedImage;
        
    return YES;
    
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PBRetouchImageViewController *destinationViewController = segue.destinationViewController;
    // force view to load IBOutlets
    if ([destinationViewController view]) {
        destinationViewController.backgroundImageView.image = self.backgroundImageView.image;
        destinationViewController.croppedPhotobomberImageView.image = self.croppedPhotobomberImageView.image;
    }
}

@end
