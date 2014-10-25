//
//  LoginRegisterViewController.m
//  Pointr
//
//  Created by Adam Gleichsner on 7/26/14.
//  Copyright (c) 2014 Brushfire Inc. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "BSHAppDelegate.h"
#import "FriendsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LoginRegisterViewController ()

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LoginRegisterViewController

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
    // Do any additional setup after loading the view.
//    [self.usernameTextField setAction:@selector(usernameNext:)];
    [self.usernameTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
    self.tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:self.tap];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager startUpdatingLocation];
    CLLocationDegrees latitude = self.locationManager.location.coordinate.latitude;
    CLLocationDegrees longitude = self.locationManager.location.coordinate.longitude;
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
//    [tap setCancelsTouchesInView:NO];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.usernameTextField isFirstResponder]) {
        [self.passwordTextField becomeFirstResponder];
    } else if([self.passwordTextField isFirstResponder]) {
        
        [self pointrLogIn:self];
        [self dismissKeyboard];
        
    }
    return YES;
}

- (IBAction)unwindToLoginViewController:(UIStoryboardSegue *)unwindSegue
{
}

-(void)dismissKeyboard {
    
    if ([self.usernameTextField isFirstResponder]) {
        [self.usernameTextField resignFirstResponder];
    } else if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
    
}

- (IBAction)pointrLogIn:(id)sender {
    
    self.loginButton.enabled = NO;
    self.registerButton.enabled = NO;
    NSMutableURLRequest *pointrLogin = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com%@", @"/user/login"]]];
    [pointrLogin setHTTPMethod:@"POST"];
    NSString *loginString = [NSString stringWithFormat:@"username=%@&password=%@", self.usernameTextField.text, self.passwordTextField.text];
    [pointrLogin setHTTPBody:[loginString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:pointrLogin delegate:self];
    if (!connection) {
        // Release the receivedData object.
        self.receivedData = nil;
        
        // Inform the user that the connection failed.
    }
    
    self.receivedData = [NSMutableData dataWithCapacity: 0];
    
}


- (IBAction)pointrRegister:(id)sender {
    
    self.loginButton.enabled = NO;
    self.registerButton.enabled = NO;
    
    BSHAppDelegate *appDelegate = (BSHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableURLRequest *pointrRegister = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pointr-backend.herokuapp.com%@", @"/user/register"]]];
    [pointrRegister setHTTPMethod:@"POST"];
    NSString *loginString = [NSString stringWithFormat:@"username=%@&password=%@&device=%@", self.usernameTextField.text, self.passwordTextField.text, appDelegate.getDeviceToken];
    [pointrRegister setHTTPBody:[loginString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:pointrRegister delegate:self];
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
        if ([[returnDict objectForKey:@"success"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {
            self.accessToken = [returnDict objectForKey:@"accessToken"];
            [self performSegueWithIdentifier:@"loginToFriends" sender:self];
        } else {
            if ([[returnDict objectForKey:@"message"] isEqualToString:@"INTERNAL ERROR"]) {
                self.errorMessage.text = @"We're locked in an epic battle between good and evil; come back later.";
            } else if ([[returnDict objectForKey:@"message"] isEqualToString:@"BAD PASSWORD"]) {
                self.errorMessage.text = @"Looks like you messed up your password, son.";
            } else if ([[returnDict objectForKey:@"message"] isEqualToString:@"BAD USERNAME"]) {
                self.errorMessage.text = @"Invalid username, bub.";
            } else if ([[returnDict objectForKey:@"message"] isEqualToString:@"USERNAME EXISTS"]) {
                self.errorMessage.text = @"Username is already taken, pal.";
            } else if ([[returnDict objectForKey:@"message"] isEqualToString:@"BAD ACCESS TOKEN"]) {
                self.errorMessage.text = @"Denied permission to update location, so no app for you.";
            } else if ([[returnDict objectForKey:@"message"] isEqualToString:@"USER NOT FOUND"]) {
                self.errorMessage.text = @"This user doesn't exist; did you mean to register?";
            } else {
                self.errorMessage.text = @"Couldn't communicate with server; please try again later.";
            }
        }
    }
    
    self.loginButton.enabled = YES;
    self.registerButton.enabled = YES;
    
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
     
     if ([[segue identifier] isEqualToString:@"loginToFriends"]) {
         FriendsViewController *destination = [segue destinationViewController];
         destination.accessToken = self.accessToken;
         destination.username = self.usernameTextField.text;
     }
     
 }


@end
