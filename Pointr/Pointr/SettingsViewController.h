//
//  SettingsViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 5/10/15.
//  Copyright (c) 2015 Brushfire Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property NSUInteger pageIndex;
@property (strong, nonatomic) NSArray *pages;

@property (nonatomic, strong) UIBarButtonItem *left;
@property (nonatomic, strong) UIBarButtonItem *middle;
@property (nonatomic, strong) UIBarButtonItem *right;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@end