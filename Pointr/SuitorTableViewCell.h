//
//  SuitorTableViewCell.h
//  Pointr
//
//  Created by Adam Gleichsner on 8/10/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuitorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *suitorName;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;

//@property (nonatomic, strong) NSString *accessToken;
//@property (nonatomic, strong) NSString *username;
//@property (nonatomic, strong) NSString *friendName;

@end
