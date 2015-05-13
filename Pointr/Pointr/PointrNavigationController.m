//
//  BSHViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 7/25/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import "PointrNavigationController.h"

@interface PointrNavigationController ()

@end

@implementation PointrNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6) {
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    } else
    {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
    

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
