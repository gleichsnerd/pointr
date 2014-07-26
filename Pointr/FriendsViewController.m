//
//  FriendsViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 7/26/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import "FriendsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface FriendsViewController ()

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *requestFlag;

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
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager startUpdatingLocation];
    CLLocationDegrees latitude = self.locationManager.location.coordinate.latitude;
    CLLocationDegrees longitude = self.locationManager.location.coordinate.longitude;
    [self.locationManager stopUpdatingLocation];
    
    self.requestFlag = @"location_update";
    NSMutableURLRequest *locationUpdate = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com%@", @"/user/location"]]];
    [locationUpdate setHTTPMethod:@"POST"];
    NSString *locationString = [NSString stringWithFormat:@"accessToken=%@&username=%@&latitude=%f&longitude=%f", self.accessToken, self.username, latitude, longitude];
    [locationUpdate setHTTPBody:[locationString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:locationUpdate delegate:self];
    if (!connection) {
        // Release the receivedData object.
        self.receivedData = nil;
        
        // Inform the user that the connection failed.
    }
    
    self.receivedData = [NSMutableData dataWithCapacity: 0];

}

- (IBAction)addFriend:(id)sender {
    
    self.requestFlag = @"add_friend";
    NSMutableURLRequest *addFriend = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com%@", @"/friends/add"]]];
    [addFriend setHTTPMethod:@"POST"];
    NSString *friendString = [NSString stringWithFormat:@"accessToken=%@&username=%@&friend_username=%@", self.accessToken, self.username, self.addFriendTextField.text];
    [addFriend setHTTPBody:[friendString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:addFriend delegate:self];
    if (!connection) {
        // Release the receivedData object.
        self.receivedData = nil;
        
        // Inform the user that the connection failed.
    }
    
    self.receivedData = [NSMutableData dataWithCapacity: 0];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - URL Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    connection = nil;
    self.receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSError *error;
    id returnData = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:&error];
    
    if ([returnData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *returnDict = returnData;
        
        if ([self.requestFlag isEqualToString:@"location_update"]) {
            if ([[returnDict objectForKey:@"success"] isEqualToNumber:[[NSNumber alloc] initWithInt:0]]) {
                NSLog(@"Error updating locaiton");
            }
        } else if ([self.requestFlag isEqualToString:@"add_friend"]) {
            if ([[returnDict objectForKey:@"success"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {
                self.addFriendTextField.text = @"Success!";
            } else {
                self.addFriendTextField.text = @"Failure!";
            }
        }
    }
    
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    connection = nil;
    self.receivedData = nil;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
