//
//  SettingsViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 5/10/15.
//  Copyright (c) 2015 Brushfire Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsViewController.h"
#import "FriendsViewController.h"
#import "LoginRegisterViewController.h"

@implementation SettingsViewController

- (void) viewDidAppear:(BOOL)animated {
    FriendsViewController *fc = self.pages[1];
    [self.navItem setRightBarButtonItem:fc.left animated:YES];
    fc.left = nil;
}

- (IBAction)logout:(id)sender {
    
    for (LoginRegisterViewController *lc in [self.navigationController viewControllers]) {
        if ([lc isKindOfClass:[LoginRegisterViewController class]]) {
            [self.navigationController popToViewController:lc animated:YES];
        }            
    }
    
}


@end
