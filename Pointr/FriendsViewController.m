//
//  FriendsViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 7/26/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import "FriendsViewController.h"
#import "SuitorsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface FriendsViewController ()

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *requestFlag;

@property (nonatomic, strong) NSMutableArray *friendsList;
@property (nonatomic, strong) NSMutableArray *suitorsList;

@end

@implementation FriendsViewController

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
    self.addFriendTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.friendsTable.delegate = self;
    self.friendsTable.dataSource = self;
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.view addGestureRecognizer:swipeLeftGesture];
    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionLeft;

    
}

-(void)handleSwipeGesture:(UIGestureRecognizer *) sender
{
    NSUInteger touches = sender.numberOfTouches;
    if (touches >=2)
    {
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            [self performSegueWithIdentifier:@"friendsToSuitors" sender:self];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateLocation];
    [self loadFriends];
    [self.friendsTable reloadData];
}

- (IBAction)addFriend:(id)sender {
    
    NSMutableURLRequest *addFriend = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com%@", @"/friends/add"]]];
    [addFriend setHTTPMethod:@"POST"];
    NSString *friendString = [NSString stringWithFormat:@"accessToken=%@&username=%@&friend_username=%@", self.accessToken, self.username, self.addFriendTextField.text];
    [addFriend setHTTPBody:[friendString dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *addData = [NSURLConnection sendSynchronousRequest:addFriend returningResponse:&response error:&error];
    if (addData) {
        self.addFriendTextField.text = @"Success!";
    } else {
        self.addFriendTextField.text = @"Failure!";
    }
    

    
}

- (void)updateLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager startUpdatingLocation];
    CLLocationDegrees latitude = self.locationManager.location.coordinate.latitude;
    CLLocationDegrees longitude = self.locationManager.location.coordinate.longitude;
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    
    self.requestFlag = @"location_update";
    NSMutableURLRequest *locationUpdate = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com%@", @"/user/location"]]];
    [locationUpdate setHTTPMethod:@"POST"];
    NSString *locationString = [NSString stringWithFormat:@"accessToken=%@&username=%@&latitude=%f&longitude=%f", self.accessToken, self.username, latitude, longitude];
    [locationUpdate setHTTPBody:[locationString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSURLResponse *response;
    
    NSData *locationData = [NSURLConnection sendSynchronousRequest:locationUpdate returningResponse:&response error:&error];
    if (locationData) {
        NSLog(@"Location updated.");
        if (true) {
            [self loadFriends];
        }
    } else {
        NSLog(@"Location update failure.");
        if (true) {
            [self loadFriends];
        }
    }
}

- (void)loadFriends
{
 
    self.friendsList = [NSMutableArray array];
    self.requestFlag = @"load_friends";
    NSMutableURLRequest *loadFriends = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com/user/friends?accessToken=%@&username=%@", self.accessToken, self.username]]];
    [loadFriends setHTTPMethod:@"GET"];
    NSError *error;
    NSURLResponse *response;
    NSData *friendData = [NSURLConnection sendSynchronousRequest:loadFriends returningResponse:&response error:&error];
    if (friendData) {
        id json = [NSJSONSerialization JSONObjectWithData:friendData options:nil error:&error];
        if ([json isKindOfClass:[NSDictionary class]]) {
            NSDictionary *friendDict = json;
            if ([friendDict valueForKey:@"success"]) {
                self.friendsList = [NSMutableArray arrayWithArray:[friendDict valueForKey:@"friends"]];
                self.suitorsList = [NSMutableArray arrayWithArray:[friendDict valueForKey:@"suitors"]];
                NSLog(@"Successfully loaded friends");
            } else {
                NSLog(@"Failure loading friends");
            }
        }

    } else {
        NSLog(@"Incorrect data for friends list");
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friendsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Cell identifier correlates to prototype in Storyboard
    static NSString *cellIdentifier = @"friendCell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Set a clear background so we can use an image instead
    cell.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;
    
    cell.textLabel.text = [self.friendsList objectAtIndex:indexPath.row]; //objectForKey:@"username"];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row %d", indexPath.row);
    [self performSegueWithIdentifier:@"friendsToCompass" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"friendsToSuitors"]) {
        SuitorsViewController *destination = [segue destinationViewController];
        destination.suitorsList = self.suitorsList;
        destination.username = self.username;
        destination.accessToken = self.accessToken;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
