//
//  SuitorTableViewCell.m
//  Pointr
//
//  Created by Adam Gleichsner on 8/10/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import "SuitorTableViewCell.h"

@implementation SuitorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (IBAction)accept:(id)sender {
//    NSMutableURLRequest *addFriend = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com%@", @"/friends/add"]]];
//    [addFriend setHTTPMethod:@"POST"];
//    NSString *friendString = [NSString stringWithFormat:@"accessToken=%@&username=%@&friend_username=%@", self.accessToken, self.username, self.friendName];
//    [addFriend setHTTPBody:[friendString dataUsingEncoding:NSUTF8StringEncoding]];
//    NSError *error;
//    NSURLResponse *response;
//    NSData *addData = [NSURLConnection sendSynchronousRequest:addFriend returningResponse:&response error:&error];
//    if (addData) {
//        self
//    } else {
//        self.addFriendTextField.text = @"Failure!";
//    }
//
//    
//}
//
//- (IBAction)reject:(id)sender {
//}

@end
