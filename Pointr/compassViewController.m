//
//  compassViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 8/14/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import "compassViewController.h"
#import <CoreLocation/CoreLocation.h>

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

@interface compassViewController ()

@property float bearing;
@property CLLocationManager* locationManager;

@end

@implementation compassViewController

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
    
    self.locationManager=[[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate=self;
    //Start the compass updates.
    if ([CLLocationManager headingAvailable] ) {
        [self.locationManager startUpdatingHeading];
    }
    else {
        NSLog(@"No Heading Available: ");
        UIAlertView *noCompassAlert = [[UIAlertView alloc] initWithTitle:@"No Compass!" message:@"This device does not have the ability to measure magnetic fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noCompassAlert show];
        noCompassAlert = nil;
    }
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    //start updating compass
//    self.locationManager=[[CLLocationManager alloc] init];
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.headingFilter = 1;
//    self.locationManager.delegate = self;
//    [self.locationManager startUpdatingHeading];
//    
//    //get coords of current location
//    CLLocation *location = [self.locationManager location];
//    CLLocationCoordinate2D fromLoc = [location coordinate];
//    
//    //mecca:
//    CLLocationCoordinate2D toLoc = [location coordinate];
//    toLoc = CLLocationCoordinate2DMake(21.4167, 39.8167);
//    
//    
//    //calculate the bearing between current location and Mecca
//    
//    float fLat = degreesToRadians(fromLoc.latitude);
//    float fLng = degreesToRadians(fromLoc.longitude);
//    float tLat = degreesToRadians(toLoc.latitude);
//    float tLng = degreesToRadians(toLoc.longitude);
//    
//    float degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
//    
//    if (degree >= 0) {
//        self.bearing  = degree;
//    } else {
//        self.bearing = degree+360;
//    }
//    NSLog(@"bearing: %f", self.bearing);
//    
//    //rotate the needle from true north
//    float MnewRad =  degreesToRadians(self.bearing);
//    self.pointr.transform = CGAffineTransformMakeRotation(MnewRad);//rotate the number of degrees from north
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
//    //compass
//    float oldRad =  -self.locationManager.heading.trueHeading * M_PI / 180.0f;
//    float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
//
//    
//    //needle
//    //float MoldRad =  (-manager.heading.trueHeading - bearing) * M_PI / 180.0f; //tried this, but it causes needle to spin a lot
//    float MnewRad =  (180 + self.bearing) * M_PI / 180.0f;
//     = CGAffineTransformMakeRotation(MnewRad);
//
//    NSLog(@"%f => %f (%f)", self.locationManager.heading.trueHeading, newHeading.trueHeading, MnewRad);

    NSLog(@"New magnetic heading: %f", newHeading.magneticHeading);
    NSLog(@"New true heading: %f", newHeading.trueHeading);
//    NSString *headingstring = [[NSString alloc] initWithFormat:@"%f",newHeading.trueHeading];
//    trueHeading.text = headingstring;
//    [headingstring release];
//    
//    NSString *magneticstring = [[NSString alloc] initWithFormat:@"%f",newHeading.magneticHeading];
//    magneticHeading.text = magneticstring;
//    [magneticstring release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
