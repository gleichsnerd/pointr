//
//  compassViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 8/14/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import "CompassViewController.h"
#import <CoreLocation/CoreLocation.h>

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

@interface CompassViewController ()

@property double bearing;
@property CLLocationManager* locationManager;
@property (strong, nonatomic) NSDictionary *distancePhrases;
@property (strong, nonatomic) NSString *prevDist;

@end

@implementation CompassViewController

typedef enum {DIST_CLOSE, DIST_WALK, DIST_BIKE, DIST_CAR, DIST_FAR, DIST_TOOFAR} FRIEND_DISTANCE;

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
//    self.pointr.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    self.pointr.layer.position = CGPointMake(self.pointr.image.size.width/2, self.pointr.image.size.height/2);
//    self.pointr.center = CGPointMake(self.pointr.image.size.width/2, self.pointr.image.size.height/2);
    
    //start updating compass
    [self.pointr setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.north setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.locationManager=[[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.headingFilter = 1;

    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    
    self.distancePhrases = [self setDistancePhrases];
    
}

- (NSDictionary *)setDistancePhrases
{
    NSDictionary *returnDict = [[NSDictionary alloc] init];
    NSArray *closePhrases = [[NSArray alloc] initWithObjects:@"", nil];
    NSArray *walkPhrases = [[NSArray alloc] initWithObjects:@"", nil];
    NSArray *bikePhrases = [[NSArray alloc] initWithObjects:@"", nil];
    NSArray *carPhrases = [[NSArray alloc] initWithObjects:@"", nil];
    NSArray *farPhrases = [[NSArray alloc] initWithObjects:@"", nil];
    NSArray *tooFarPhrases = [[NSArray alloc] initWithObjects:@"", nil];
    
    [returnDict setValue:closePhrases forKey:@"close"];
    [returnDict setValue:walkPhrases forKey:@"walk"];
    [returnDict setValue:bikePhrases forKey:@"bike"];
    [returnDict setValue:carPhrases forKey:@"car"];
    [returnDict setValue:farPhrases forKey:@"far"];
    [returnDict setValue:tooFarPhrases forKey:@"tooFar"];
    
    return returnDict;
}

- (double)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    double fLat = degreesToRadians(fromLoc.latitude);
    double fLng = degreesToRadians(fromLoc.longitude);
    double tLat = degreesToRadians(toLoc.latitude);
    double tLng = degreesToRadians(toLoc.longitude);
    
    double degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    // get user location
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D locUser = [location coordinate];
    CLLocation *friendLocation = [[CLLocation alloc] initWithLatitude:self.friendLat longitude:self.friendLong];
    CLLocationCoordinate2D locFriend = [friendLocation coordinate];
    
    self.bearing = [self getHeadingForDirectionFromCoordinate:locUser toCoordinate:locFriend];

    //compass
    double oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;

    double degreeAdj = 0;
    
//    if (locUser.latitude <= locFriend.latitude && locUser.longitude >= locFriend.longitude) {
//        degreeAdj = -90;
//        self.message.text = @"NW";
//    } else if (locUser.latitude <= locFriend.latitude && locUser.longitude <= locFriend.longitude) {
//        degreeAdj = -180;
//        self.message.text = @"SW";
//    } else if (locUser.latitude >= locFriend.latitude && locUser.longitude <= locFriend.longitude) {
//        degreeAdj = -270;
//        self.message.text = @"SE";
//    } else if (locUser.latitude >= locFriend.latitude && locUser.longitude >= locFriend.longitude) {
//        degreeAdj = -45;
//        self.message.text = @"NE";
//    }
    
    double newRad, compassRad;

    compassRad = -(degreesToRadians(newHeading.trueHeading));
    newRad = -(degreesToRadians(self.bearing + degreeAdj));
//    if (self.bearing >= newHeading.trueHeading && self.bearing <= newHeading.trueHeading + 180) {
//        newRad =  -((newHeading.trueHeading - self.bearing + 90) * M_PI) / 180.0f;
//        self.message.text = [NSString stringWithFormat:@"%f", newRad];
//    } else {
//        newRad =  -((newHeading.trueHeading + self.bearing - 90) * M_PI) / 180.0f;
//        self.message.text = [NSString stringWithFormat:@"%f", newRad];
//    }
    
//    }
//    double newRad =  (newHeading.trueHeading - (180 + self.bearing)) * M_PI / 180.0f;//-newHeading.trueHeading * M_PI / 180.0f;
//    double MnewRad =  (180 + self.bearing) * M_PI / 180.0f;
    self.north.transform = CGAffineTransformMakeRotation(compassRad);
    self.pointr.transform = CGAffineTransformMakeRotation(newRad);
    NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
    
    
    //needle
    //double MoldRad =  (-manager.heading.trueHeading - bearing) * M_PI / 180.0f; //tried this, but it causes needle to spin a lot
//    double MnewRad =  (180 + self.bearing) * M_PI / 180.0f;
//    needleImage.transform = CGAffineTransformMakeRotation(MnewRad);
//    NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, MoldRad, newHeading.trueHeading, MnewRad);
    
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
