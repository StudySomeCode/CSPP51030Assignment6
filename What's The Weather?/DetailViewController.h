//
//  DetailViewController.h
//  What's The Weather?
//
//  Created by Mark Meyer on 3/1/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MasterDetailProtocol.h"
#import "Networking.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, MasterDetailProtocol>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (void)pass:(NSString *)City;
@end
