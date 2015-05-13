//
//  FriendsViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 7/26/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import "FriendsViewController.h"
#import "SuitorsViewController.h"
#import "CompassViewController.h"

@interface FriendsViewController ()

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *requestFlag;

@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tap;

@property (nonatomic) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *friendsList;
@property (nonatomic, strong) NSMutableArray *suitorsList;

@property double sendLat;
@property double sendLong;


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
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    self.addFriendTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.friendsTable.delegate = self;
    self.friendsTable.dataSource = self;
    self.addFriendTextField.delegate = self;
    // Do any additional setup after loading the view.
    
    self.tap = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(dismissKeyboard)];
    
    [self.navItem setLeftBarButtonItem:self.left];
    
//    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
//    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeLeftGesture];
//    
//    UISwipeGestureRecognizer *swipeRightGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)];
//    swipeRightGesture.direction=UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRightGesture];

    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:self.tap];
}

-(void)handleSwipeRightGesture:(UIGestureRecognizer *) sender
{
    NSUInteger touches = sender.numberOfTouches;
    if (touches >=1)
    {
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            [self performSegueWithIdentifier:@"friendsToSettings" sender:self];
        }
    }
}

-(void)handleSwipeLeftGesture:(UIGestureRecognizer *) sender
{
    NSUInteger touches = sender.numberOfTouches;
    if (touches >=1)
    {
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            [self performSegueWithIdentifier:@"friendsToSuitors" sender:self];
        }
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.locationManager startUpdatingLocation];
    [self updateLocation];
    [self loadFriends];
    
    SuitorsViewController *uc = [self.pages objectAtIndex:2];
    uc.suitorsList = self.suitorsList;
    uc.username = self.username;
    uc.accessToken = self.accessToken;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.locationManager stopUpdatingLocation];
}

- (IBAction)addFriend:(id)sender {
    
    if (![[self.addFriendTextField text] isEqualToString:@"Add a friend"] ||
        ![[self.addFriendTextField text] isEqualToString:@"Success!"] ||
        ![[self.addFriendTextField text] isEqualToString:@"Failure!"]) {
        
        NSMutableURLRequest *addFriend = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend-2.herokuapp.com%@", @"/friends/add"]]];
        [addFriend setHTTPMethod:@"POST"];
        NSString *friendString = [NSString stringWithFormat:@"accessToken=%@&username=%@&friend_username=%@", self.accessToken, self.username, self.addFriendTextField.text];
        [addFriend setHTTPBody:[friendString dataUsingEncoding:NSUTF8StringEncoding]];
        NSError *error;
        NSURLResponse *response;
        NSData *addData = [NSURLConnection sendSynchronousRequest:addFriend returningResponse:&response error:&error];
        [self dismissKeyboard];
        if (addData) {
            self.addFriendTextField.text = @"Success!";
        } else {
            self.addFriendTextField.text = @"Failure!";
        }
    }
    
    
}

-(void)dismissKeyboard {
    for (UIGestureRecognizer *gesture in [self.view gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:gesture];
        }
    }
    [self.addFriendTextField resignFirstResponder];
    [self performSelector:@selector(defaultFieldText) withObject:nil afterDelay:1.5];
}

-(void)defaultFieldText {
    [self.addFriendTextField setText:@"Add a friend"];
}



- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
}

- (void)updateLocation
{
    CLLocationDegrees latitude = self.locationManager.location.coordinate.latitude;
    CLLocationDegrees longitude = self.locationManager.location.coordinate.longitude;
    
    self.requestFlag = @"location_update";
    
    NSMutableURLRequest *locationUpdate = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend-2.herokuapp.com%@", @"/user/location"]]];
    [locationUpdate setHTTPMethod:@"POST"];
    NSString *locationString = [NSString stringWithFormat:@"accessToken=%@&username=%@&latitude=%f&longitude=%f", self.accessToken, self.username, latitude, longitude];
    [locationUpdate setHTTPBody:[locationString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSURLResponse *response;
    
    NSData *locationData = [NSURLConnection sendSynchronousRequest:locationUpdate returningResponse:&response error:&error];
    if (locationData) {
        NSLog(@"Location updated with values %f, %f.", latitude, longitude);
    } else {
        NSLog(@"Location update failure.");
    }
    
}

- (void)loadFriends
{
 
    self.friendsList = [NSMutableArray array];
    self.requestFlag = @"load_friends";
    NSMutableURLRequest *loadFriends = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend-2.herokuapp.com/user/friends?accessToken=%@&username=%@", self.accessToken, self.username]]];
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
                NSLog(@"Successfully loaded %lu friends", (unsigned long)[self.friendsList count]);
                NSLog(@"Successfully loaded %lu suitors", (unsigned long)[self.suitorsList count]);
                if ([self.friendsList count] == 0) {
                    self.friendlessText.hidden = false;
                } else {
                    self.friendlessText.hidden = true;
                }
            } else {
                NSLog(@"Failure loading friends");
            }
        }

    } else {
        NSLog(@"Incorrect data for friends list");
    }
    [self.friendsTable reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addFriend:self];
    [self dismissKeyboard];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //We need a section for each friend
    return [self.friendsList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //1 friend per section
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Put a gap between each friend
    return 10.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (IBAction)goToSuitors:(id)sender {
    [self performSegueWithIdentifier:@"friendsToSuitors" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Cell identifier correlates to prototype in Storyboard
    static NSString *cellIdentifier = @"friendCell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundView.frame = CGRectOffset(cell.backgroundView.frame, 50, 50);
    int cellColorIdx = 0;
    //Set a clear background so we can use an image instead
   
    if ([self.friendsList count] <= 4) {
        cellColorIdx = indexPath.section;
    } else {
        if (0 <= indexPath.section && indexPath.section < 1 * ([self.friendsList count]/5)) {
            cellColorIdx = 0;
        } else if (1 * ([self.friendsList count]/5) <= indexPath.section && indexPath.section < 2 * ([self.friendsList count]/5)) {
            cellColorIdx = 1;
        } else if (2 * ([self.friendsList count]/5) <= indexPath.section && indexPath.section < 3 * ([self.friendsList count]/5)) {
            cellColorIdx = 2;
        } else if (3 * ([self.friendsList count]/5) <= indexPath.section && indexPath.section < 4 * ([self.friendsList count]/5)) {
            cellColorIdx = 3;
        } else if (4 * ([self.friendsList count]/5) <= indexPath.section && indexPath.section < [self.friendsList count]) {
            cellColorIdx = 4;
        }
    }
    
    if (cellColorIdx == 0) {
        cell.backgroundColor = [UIColor colorWithRed:218/255.0f green:68/255.0f blue:83/255.0f alpha:1];
    } else if (cellColorIdx == 1) {
        cell.backgroundColor = [UIColor colorWithRed:233/255.0f green:87/255.0f blue:63/255.0f alpha:1];
    } else if (cellColorIdx == 2) {
        cell.backgroundColor = [UIColor colorWithRed:252/255.0f green:187/255.0f blue:66/255.0f alpha:1];
    } else if (cellColorIdx == 3) {
        cell.backgroundColor = [UIColor colorWithRed:133/255.0f green:205/255.0f blue:82/255.0f alpha:1];
    } else if (cellColorIdx == 4) {
        cell.backgroundColor = [UIColor colorWithRed:55/255.0f green:188/255.0f blue:155/255.0f alpha:1];
    }
    
    
    
    cell.opaque = NO;

    cell.textLabel.text = [[self.friendsList objectAtIndex:indexPath.section] objectForKey:@"username"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id preLat = [[self.friendsList objectAtIndex:indexPath.section] valueForKey:@"latitude"];
    id preLong = [[self.friendsList objectAtIndex:indexPath.section] objectForKey:@"longitude"];
    self.sendLat = [preLat doubleValue];
    self.sendLong = [preLong doubleValue];
    NSLog(@"Selected row %ld with username %@ and location (%f, %f)", (long)indexPath.section, [[self.friendsList objectAtIndex:indexPath.section] valueForKey:@"username"], self.sendLat, self. sendLong);
    
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
    } else if([segue.identifier isEqualToString:@"friendsToCompass"]) {
        CompassViewController *destination = [segue destinationViewController];
        destination.friendLat = self.sendLat;
        destination.friendLong = self.sendLong;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
