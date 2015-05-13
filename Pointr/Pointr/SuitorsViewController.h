//
//  SuitorsViewController.h
//  Pointr
//
//  Created by Adam Gleichsner on 8/9/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuitorsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *suitorsList;
@property (weak, nonatomic) IBOutlet UITableView *suitorsTable;
@property (weak, nonatomic) IBOutlet UILabel *suitorlessText;

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *username;

@property NSUInteger pageIndex;
@property (strong, nonatomic) NSArray *pages;

@property (nonatomic, strong) UIBarButtonItem *left;
@property (nonatomic, strong) UIBarButtonItem *middle;
@property (nonatomic, strong) UIBarButtonItem *right;
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end
