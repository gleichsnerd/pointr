//
//  SuitorsViewController.h
//  Pointr
//
//  Created by Adam Gleichsner on 8/9/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuitorsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *suitorsList;
@property (weak, nonatomic) IBOutlet UITableView *suitorsTable;

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *username;

@end
