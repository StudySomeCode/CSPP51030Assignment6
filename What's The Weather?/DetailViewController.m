//
//  DetailViewController.m
//  What's The Weather?
//
//  Created by Mark Meyer on 3/1/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)pass:(NSString *)City
{
    NSLog(@"City: %@",City);
    if (_detailItem != City) {
        _detailItem = City;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = self.detailItem;
        
        NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&mode=json", self.detailItem];
        url = [url stringByAddingPercentEscapesUsingEncoding:
               NSASCIIStringEncoding];

        [[Networking sharedNetworking] getWeatherForURL:url                                                       success:^(NSDictionary *dict, NSError *error){
            
            NSDictionary *coords = [dict objectForKey:@"coord"];
            CLLocationCoordinate2D centerCoord;
            centerCoord.latitude = [[coords objectForKey:@"lat"] doubleValue];
            centerCoord.longitude = [[coords objectForKey:@"lon"] doubleValue];
            
            MKMapCamera *mapCam = [[MKMapCamera alloc] init];
            mapCam.centerCoordinate = centerCoord;
            mapCam.altitude = 25000;
            
            [self.mapView setCamera:mapCam animated:YES];
            
                                                    NSLog(@"success");
                                                }
                                                failure:^(void){
                                                    //TODO UIAlertView
                                                    NSLog(@"error");
                                                }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
