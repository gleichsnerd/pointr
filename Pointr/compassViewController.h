//
//  compassViewController.h
//  Pointr
//
//  Created by Adam Gleichsner on 8/14/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface compassViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pointr;

@end
