/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
*/

#import <CoreLocation/CoreLocation.h> 
#import "FrontViewController.h"
#import "SWRevealViewController.h"
#import "VisitsAndTracking.h"

@interface FrontViewController() <NSURLSessionDelegate> {
    
    NSMutableData *_responseData;
    CLLocationManager *locationManager;
}

@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *passWord;

@end



@implementation FrontViewController

#pragma mark - View lifecycle
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callClientAuthenticationMethods];

    NSLog(@"calling Front View: %f, %f",self.view.frame.size.width,self.view.frame.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0,40, width, height)];
    [background setImage:[UIImage imageNamed:@"jetzun-back"]];
    [self.view addSubview:background];
    
    
    UILabel *userNameLabel;
    UILabel *passwordLabel;
    
    VisitsAndTracking *sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    NSString *deviceType = sharedVisitsTracking.deviceType;
    
    NSLog(@"device type: %@", deviceType);
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"omobol-signin-button"] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if ([sharedVisitsTracking.deviceType isEqualToString:@"iPhone5"]) {
        NSLog(@"adding view for 5");
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, width,height)];
        [backgroundView setImage:[UIImage imageNamed:@"omobol-login"]];
        [self.view addSubview:backgroundView];

        _userName = [[UITextField alloc]initWithFrame:CGRectMake(100,80,160,46)];
        [_userName setClearsOnBeginEditing:YES];
        [_userName setTextColor:[UIColor whiteColor]];
        
        [self.view addSubview:_userName];
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(100, 120, 160, 46)];
        [_passWord setClearsOnBeginEditing:YES];
        [_passWord setSecureTextEntry:YES];
        [self.view addSubview:_passWord];
        
        _loginButton.frame = CGRectMake(0, 240, width,70);
        [self.view addSubview:_loginButton];
        
        
    } else if ([deviceType isEqualToString:@"iPhone4"]) {
        NSLog(@"adding view for 4");

        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, width,height)];
        [backgroundView setImage:[UIImage imageNamed:@"login-bg-iphone4"]];
        [self.view addSubview:backgroundView];
        
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-160, height - 390, 90, 40)];
        passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-160, height - 340, 90, 40)];
        _loginButton.frame = CGRectMake(width/2-65, height - 280, 190,48);
        
        UIImageView *loginField = [[UIImageView alloc]initWithFrame:CGRectMake(userNameLabel.frame.origin.x + 100, userNameLabel.frame.origin.y, 180, 46)];
        [loginField setImage:[UIImage imageNamed:@"login-button-gray"]];
        [self.view addSubview:loginField];
        
        UIImageView *passwordField = [[UIImageView alloc]initWithFrame:CGRectMake(passwordLabel.frame.origin.x + 100, passwordLabel.frame.origin.y, 180, 46)];
        [passwordField setImage:[UIImage imageNamed:@"password-gray"]];
        [self.view addSubview:passwordField];
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(width/2,height - 390,180,26)];
        [_userName setClearsOnBeginEditing:YES];
        [_userName setTextColor:[UIColor whiteColor]];
        [self.view addSubview:_userName];
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(width/2, height - 340, 180, 26)];
        [_passWord setClearsOnBeginEditing:YES];
        [_passWord setSecureTextEntry:YES];
        [self.view addSubview:_passWord];
        
        
    } else if ([sharedVisitsTracking.deviceType isEqualToString:@"iPhone6P"]) {
        NSLog(@"adding view for 6p");

        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(30,300, 347,115)];
        [backgroundView setImage:[UIImage imageNamed:@"logo-jetzun800"]];
        [self.view addSubview:backgroundView];
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(100,80,160,46)];
        [_userName setClearsOnBeginEditing:YES];
        [_userName setTextColor:[UIColor whiteColor]];
        
        [self.view addSubview:_userName];
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(100, 120, 160, 46)];
        [_passWord setClearsOnBeginEditing:YES];
        [_passWord setSecureTextEntry:YES];
        [self.view addSubview:_passWord];
        
        _loginButton.frame = CGRectMake(0, 240, width,70);
        [self.view addSubview:_loginButton];
        
    } else if ([deviceType isEqualToString:@"iPhone6"]) {
        NSLog(@"adding view for 6");

        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, width,height)];
        [backgroundView setImage:[UIImage imageNamed:@"BG-login"]];
        [self.view addSubview:backgroundView];
        
        UIImageView *logoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 90, 100, 40)];
        [logoIcon setImage:[UIImage imageNamed:@"jetzun-back"]];
        [self.view addSubview:logoIcon];
        
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-160, height - 400, 100, 30)];
        passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-160, height - 350, 100, 30)];
        
        UIImageView *loginField = [[UIImageView alloc]initWithFrame:CGRectMake(userNameLabel.frame.origin.x + 100, userNameLabel.frame.origin.y, 220, 46)];
        
        [loginField setImage:[UIImage imageNamed:@"login-button-gray"]];
        [self.view addSubview:loginField];
        
        UIImageView *passwordField = [[UIImageView alloc]initWithFrame:CGRectMake(passwordLabel.frame.origin.x + 100, passwordLabel.frame.origin.y, 220, 46)];
        [passwordField setImage:[UIImage imageNamed:@"password-gray"]];
        [self.view addSubview:passwordField];
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(width/2,height - 400,160,46)];
        [_userName setClearsOnBeginEditing:YES];
        [_userName setTextColor:[UIColor whiteColor]];
        
        [self.view addSubview:_userName];
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(width/2, height - 350, 160, 46)];
        [_passWord setClearsOnBeginEditing:YES];
        [_passWord setSecureTextEntry:YES];
        [self.view addSubview:_passWord];
        
        
        _loginButton.frame = CGRectMake(width/2-65, height - 300, 230,48);
        [self.view addSubview:_loginButton];
        
    }

	self.title = NSLocalizedString(@"omobol for uber - scheduling", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
        style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;


}

- (void) uberKit:(UberKit *)uberKit didReceiveAccessToken:(NSString *)accessToken
{
    NSLog(@"Received access token %@", accessToken);
    if(accessToken)
    {
        [uberKit getUserActivityWithCompletionHandler:^(NSArray *activities, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User activity %@", activities);
                 UberActivity *activity = [activities objectAtIndex:0];
                 NSLog(@"Last trip distance %f", activity.distance);
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
        
        [uberKit getUserProfileWithCompletionHandler:^(UberProfile *profile, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User's full name %@ %@", profile.first_name, profile.last_name);
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
    }
    else
    {
        NSLog(@"No auth token, try again");
    }
}

- (void) uberKit:(UberKit *)uberKit loginFailedWithError:(NSError *)error
{
    NSLog(@"Error in login %@", error);
}




- (void) callClientAuthenticationMethods
{
    UberKit *uberKit = [[UberKit alloc] initWithServerToken:@"gOuGroOd6TJdmR2-yEu3Y8hsx0yCgPoBQEUlWjeL"]; //Add your server token
    //[[UberKit sharedInstance] setServerToken:@"YOUR_SERVER_TOKEN"]; //Alternate initialization
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:37.7833 longitude:-122.4167];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:37.9 longitude:-122.43];
    
    [uberKit getProductsForLocation:location withCompletionHandler:^(NSArray *products, NSError *error)
     {
         if(!error)
         {
             UberProduct *product = [products objectAtIndex:0];
             
             for (UberProduct *product in products) {
                 NSLog(@"-------------------------------------------");
                 NSLog(@"Product: %@",product.display_name);
                 NSLog(@"-------------------------------------------");
                 NSLog(@"Description: %@",product.product_description);
                 NSLog(@"Capacity: %d",product.capacity);

             }
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getTimeForProductArrivalWithLocation:location withCompletionHandler:^(NSArray *times, NSError *error)
     {
         if(!error)
         {
             UberTime *time = [times objectAtIndex:0];
             //NSLog(@"Time for first %f", time.estimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPriceForTripWithStartLocation:location endLocation:endLocation  withCompletionHandler:^(NSArray *prices, NSError *error)
     {
         if(!error)
         {
             UberPrice *price = [prices objectAtIndex:0];
             //NSLog(@"Price for first %i", price.lowEstimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPromotionForLocation:location endLocation:endLocation withCompletionHandler:^(UberPromotion *promotion, NSError *error)
     {
         if(!error)
         {
             //NSLog(@"Promotion - %@", promotion.localized_value);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    
}


-(void)loginButtonClick {
    
    NSString *userName = _userName.text;
    NSString *password = _passWord.text;
    
    [_loginButton setAlpha:0.3];
    
    [[UberKit sharedInstance] setClientID:@"CrI6A2YCLiM3v-n4dYN04ERH4ZXg56vV"];
    [[UberKit sharedInstance] setClientSecret:@"gOuGroOd6TJdmR2-yEu3Y8hsx0yCgPoBQEUlWjeL"];
    [[UberKit sharedInstance] setRedirectURL:@"https://localhost"];
    [[UberKit sharedInstance] setApplicationName:@"Rideshare Manager"];
    //UberKit *uberKit = [[UberKit alloc] initWithClientID:@"YOUR_CLIENTID" ClientSecret:@"YOUR_CLIENT_SECRET" RedirectURL:@"YOUR_REDIRECT_URI" ApplicationName:@"YOUR_APPLICATION_NAME"]; // Alternate initialization
    UberKit *uberKit = [UberKit sharedInstance];
    uberKit.delegate = self;
    [uberKit startLogin];
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"uber://"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"uber://?action=setPickup&pickup=my_location"]];
        
    } else {
        
        NSLog(@"no uber");
    }
    
    if ([password isEqualToString:@""]) {
        NSLog(@"no password");
        password = @"dy2132";
    }
    
    
    NSUserDefaults *loginSetting = [NSUserDefaults standardUserDefaults];
    [loginSetting setObject:userName forKey:@"username"];
    [loginSetting setObject:password forKey:@"password"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pollingUpdates)
                                                 name:@"pollingCompleteWithChanges"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pollingFailed)
                                                 name:@"pollingFailed"
                                               object:nil];
}


-(void)pollingUpdates {
    
    [self.view removeFromSuperview];
}


-(void)pollingFailed {
    
    UILabel *labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(_loginButton.frame.origin.x, _loginButton.frame.origin.y-50, 300, 20)];
    [labelFailure setText:@"Failed to Login"];
    [labelFailure setTextColor:[UIColor redColor]];
    [labelFailure setFont:[UIFont fontWithName:@"Lato-Bold" size:20]];
    [self.view addSubview:labelFailure];
    
}

@end