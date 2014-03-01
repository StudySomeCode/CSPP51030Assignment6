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
            
            
            NSDictionary *main = [dict objectForKey:@"main"];
            self.tempLabel.text = [NSString stringWithFormat:@"Temperature %@ K", [[main objectForKey:@"temp"] stringValue]];
            self.highLabel.text = [NSString stringWithFormat:@"High Temperature %@ K", [[main objectForKey:@"temp_max"] stringValue]];
            self.lowLabel.text =  [NSString stringWithFormat:@"Low Temperature %@ K", [[main objectForKey:@"temp_min"] stringValue]];
            self.windLabel.text = [NSString stringWithFormat:@"Humidity %@ %%", [[main objectForKey:@"humidity"] stringValue]];
            self.pressureLabel.text = [NSString stringWithFormat:@"Pressure %@ mb", [[main objectForKey:@"pressure"] stringValue]];
            
            NSArray *weather = [dict objectForKey:@"weather"];
            NSDictionary *weatherDict = weather[0];
            self.descriptionLabel.text = [NSString stringWithFormat:@"%@", [weatherDict objectForKey:@"description"]];
            
            [self.mapView setCamera:mapCam animated:YES];
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
    barButtonItem.title = NSLocalizedString(@"Cities", @"Cities");
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
