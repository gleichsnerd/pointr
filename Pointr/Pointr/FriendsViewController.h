//
//  FriendsViewController.h
//  Pointr
//
//  Created by Adam Gleichsner on 7/26/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FriendsViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *username;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UITableView *friendsTable;
@property (weak, nonatomic) IBOutlet UILabel *friendlessText;
@property (weak, nonatomic) IBOutlet UITextField *addFriendTextField;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property NSUInteger pageIndex;
@property (strong, nonatomic) NSArray *pages;

@property (nonatomic, strong) UIBarButtonItem *left;
@property (nonatomic, strong) UIBarButtonItem *middle;
@property (nonatomic, strong) UIBarButtonItem *right;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;

@end
