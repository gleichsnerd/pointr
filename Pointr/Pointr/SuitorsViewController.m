//
//  SuitorsViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 8/9/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import "SuitorsViewController.h"
#import "SuitorTableViewCell.h"

@interface SuitorsViewController ()

@end

@implementation SuitorsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.suitorsTable.dataSource = self;
    self.suitorsTable.delegate = self;

//    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
//    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeLeftGesture];
    
}

-(void) viewWillAppear:(BOOL)animated {
    if ([self.suitorsList count] == 0) {
        self.suitorlessText.hidden = false;
    } else {
        self.suitorlessText.hidden = true;
    }
}


-(void)handleSwipeGesture:(UIGestureRecognizer *) sender
{
    NSUInteger touches = sender.numberOfTouches;
    if (touches >=1)
    {
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            [self performSegueWithIdentifier:@"unwindToFriends" sender:self];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //We will always have only 1 section
    return [self.suitorsList count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.; // you can have your own choice, of course
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Cell identifier correlates to prototype in Storyboard
    static NSString *cellIdentifier = @"suitorCell";
    SuitorTableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Set a clear background so we can use an image instead
    cell.backgroundColor = [UIColor colorWithRed:218/255.0f green:68/255.0f blue:83/255.0f alpha:1];
    cell.opaque = NO;
    
    cell.suitorName.text = [self.suitorsList objectAtIndex:indexPath.section]; //objectForKey:@"username"];
//    cell.accessToken = self.accessToken;
//    cell.username = self.username;
//    cell.friendName = [self.suitorsList objectAtIndex:indexPath.row];
    
    
    
    //    //Sets backgroundView to display an image instead of a solid color
    //    cell.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],@"lh_tab_w_arrow.png"]]];
    
    //Set the cell text to a blue color
    //    cell.textLabel.textColor = [UIColor colorWithRed:0/255.0f green: 87/255.0f blue: 141/255.0f alpha:1];
    //    cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255.0f green: 87/255.0f blue: 141/255.0f alpha:1];
    //
    //Print out relevant information regarting customer and his tours
    //    cell.textLabel.text = [[self.friendsList object] objectAtIndex:indexPath.row];
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu tours available", (unsigned long)[self.tableContent[1][indexPath.row] count]];
    
    return cell;
}
- (IBAction)reject:(id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.suitorsTable];
    NSIndexPath *hitIndex = [self.suitorsTable indexPathForRowAtPoint:hitPoint];
    NSIndexSet *hitSet = [[NSIndexSet alloc] initWithIndex:hitIndex.section];
    
    NSMutableURLRequest *addFriend = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend-2.herokuapp.com%@", @"/friends/reject"]]];
    [addFriend setHTTPMethod:@"POST"];
    NSString *friendString = [NSString stringWithFormat:@"accessToken=%@&username=%@&friend_username=%@", self.accessToken, self.username, [self.suitorsList objectAtIndex:hitIndex.section]];
    [addFriend setHTTPBody:[friendString dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *addData = [NSURLConnection sendSynchronousRequest:addFriend returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:addData options:nil error:&error];
    if ([dict objectForKey:@"success"]) {
        [self.suitorsTable beginUpdates];
        NSLog(@"Selected row: %d", hitIndex.row);
        [self.suitorsTable deleteSections:hitSet withRowAnimation:UITableViewRowAnimationLeft];
        [self.suitorsList removeObjectAtIndex:hitIndex.section];
        [self.suitorsTable endUpdates];
    } else {
        NSLog(@"Error: cannot reject suitor request");
    }
}


- (IBAction)accept:(id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.suitorsTable];
    NSIndexPath *hitIndex = [self.suitorsTable indexPathForRowAtPoint:hitPoint];
    NSIndexSet *hitSet = [[NSIndexSet alloc] initWithIndex:hitIndex.section];
    NSMutableURLRequest *addFriend = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend-2.herokuapp.com%@", @"/friends/add"]]];
    [addFriend setHTTPMethod:@"POST"];
    NSString *friendString = [NSString stringWithFormat:@"accessToken=%@&username=%@&friend_username=%@", self.accessToken, self.username, [self.suitorsList objectAtIndex:hitIndex.section]];
    [addFriend setHTTPBody:[friendString dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *addData = [NSURLConnection sendSynchronousRequest:addFriend returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:addData options:nil error:&error];
    if ([dict objectForKey:@"success"]) {
        [self.suitorsTable beginUpdates];
        NSLog(@"Selected row: %d", hitIndex.row);
        [self.suitorsTable deleteSections:hitSet withRowAnimation:UITableViewRowAnimationRight];
        [self.suitorsList removeObjectAtIndex:hitIndex.section];
        [self.suitorsTable endUpdates];
    } else {
        NSLog(@"Error: cannot accept suitor request");
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Setup array for transferrable content
    NSMutableArray *segueContent = [NSMutableArray array];
    
    //Copy content specific to the customer selected into array to be sent to the next controller
    
    //PASS DAT
    //    [self performSegueWithIdentifier:@"customerToTours" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
