//
//  compassViewController.h
//  Pointr
//
//  Created by Adam Gleichsner on 8/14/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface CompassViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *north;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *pointr;
@property double friendLat;
@property double friendLong;

@property (strong, nonatomic) NSString* friendName;


@end
