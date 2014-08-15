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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.suitorsTable.dataSource = self;
    self.suitorsTable.delegate = self;
    // Do any additional setup after loading the view.
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%lu", (unsigned long)[self.suitorsList count]);
    return [self.suitorsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Cell identifier correlates to prototype in Storyboard
    static NSString *cellIdentifier = @"suitorCell";
    SuitorTableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Set a clear background so we can use an image instead
    cell.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;
    
    cell.suitorName.text = [self.suitorsList objectAtIndex:indexPath.row]; //objectForKey:@"username"];
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
    
    NSMutableURLRequest *addFriend = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com%@", @"/friends/reject"]]];
    [addFriend setHTTPMethod:@"POST"];
    NSString *friendString = [NSString stringWithFormat:@"accessToken=%@&username=%@&friend_username=%@", self.accessToken, self.username, [self.suitorsList objectAtIndex:hitIndex.row]];
    [addFriend setHTTPBody:[friendString dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *addData = [NSURLConnection sendSynchronousRequest:addFriend returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:addData options:nil error:&error];
    if ([dict objectForKey:@"success"]) {
        [self.suitorsTable beginUpdates];
        NSLog(@"Selected row: %d", hitIndex.row);
        [self.suitorsTable deleteRowsAtIndexPaths:@[hitIndex] withRowAnimation:UITableViewRowAnimationLeft];
        [self.suitorsList removeObjectAtIndex:hitIndex.row];
        [self.suitorsTable endUpdates];
    } else {
        NSLog(@"Error: cannot reject suitor request");
    }
}


- (IBAction)accept:(id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.suitorsTable];
    NSIndexPath *hitIndex = [self.suitorsTable indexPathForRowAtPoint:hitPoint];
    
    NSMutableURLRequest *addFriend = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com%@", @"/friends/add"]]];
    [addFriend setHTTPMethod:@"POST"];
    NSString *friendString = [NSString stringWithFormat:@"accessToken=%@&username=%@&friend_username=%@", self.accessToken, self.username, [self.suitorsList objectAtIndex:hitIndex.row]];
    [addFriend setHTTPBody:[friendString dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *addData = [NSURLConnection sendSynchronousRequest:addFriend returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:addData options:nil error:&error];
    if ([dict objectForKey:@"success"]) {
        [self.suitorsTable beginUpdates];
        NSLog(@"Selected row: %d", hitIndex.row);
        [self.suitorsTable deleteRowsAtIndexPaths:@[hitIndex] withRowAnimation:UITableViewRowAnimationRight];
        [self.suitorsList removeObjectAtIndex:hitIndex.row];
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
