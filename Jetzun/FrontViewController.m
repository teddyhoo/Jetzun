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
#import <Parse/Parse.h>
#import <GPUberViewController.h>
#import "LocationShareModel.h"
#import "FrontViewController.h"
#import "VisitsAndTracking.h"
#import "JuroTextField.h"
#import <PulsingHaloLayer.h>
#import <UIColor+GPUberView.h>

@interface FrontViewController() <NSURLSessionDelegate,UITextViewDelegate,UITextFieldDelegate> {
    
    NSMutableData *_responseData;
    CLLocationManager *locationManager;
}

@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIButton *createAccountButton;
@property (nonatomic,strong) UIButton *makeAccountButton;
@property (nonatomic,strong) UILabel *createAccount;

@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *passWord;
@property (nonatomic,strong) UITextField *pickUserName;
@property (nonatomic,strong) UITextField *pickPassword;
@property (nonatomic,strong) UITextField *pickPasswordConfirm;
@property (nonatomic,strong) UITextField *emailAccount;
@property (nonatomic,strong) UIImageView *loginField;
@property (nonatomic,strong) UIImageView *passwordField;
@property (nonatomic,strong) PulsingHaloLayer *pulsingHalo;


@property (nonatomic,strong) VisitsAndTracking *sharedVisitsTracking;
@property (nonatomic,strong) UIImageView *jetzunLogo;
@end



@implementation FrontViewController

#pragma mark - View lifecycle
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, width, height)];
    [background setImage:[UIImage imageNamed:@"login-BG-darkpurple"]];
    [self.view addSubview:background];
    
    UILabel *userNameLabel;
    UILabel *passwordLabel;
    
    _sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    NSString *deviceType = _sharedVisitsTracking.deviceType;
    
    NSLog(@"device type: %@", deviceType);
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login-red-200"] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if ([_sharedVisitsTracking.deviceType isEqualToString:@"iPhone5"]) {
        NSLog(@"adding view for 5");


        _jetzunLogo = [[UIImageView alloc]initWithFrame:CGRectMake(30,260, 240,80)];
        [_jetzunLogo setImage:[UIImage imageNamed:@"logo-jetzun800"]];
        [self.view addSubview:_jetzunLogo];
        
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(100,60,160,50)];
        [_userName setClearsOnBeginEditing:YES];
        [_userName setTextColor:[UIColor whiteColor]];
        
        [self.view addSubview:_userName];
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(100, 120, 160, 50)];
        [_passWord setClearsOnBeginEditing:YES];
        [_passWord setSecureTextEntry:YES];
        [self.view addSubview:_passWord];
        
        _loginButton.frame = CGRectMake(60, 180, 360,48);
        
        [self.view addSubview:_loginButton];
        _createAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _createAccountButton.frame = CGRectMake(0, 220, width, 60);
        [_createAccountButton setTitle:@"NEED ACCOUNT?" forState:UIControlStateNormal];
        
        [_createAccountButton addTarget:self
                                 action:@selector(createNewAccount)
                       forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_createAccountButton];
        
        _loginField = [[UIImageView alloc]initWithFrame:CGRectMake(20, _userName.frame.origin.y, 300, 45)];
        
        [_loginField setImage:[UIImage imageNamed:@"username-login-clean"]];
        [self.view addSubview:_loginField];
        
        
        _passwordField = [[UIImageView alloc]initWithFrame:CGRectMake(20, _passWord.frame.origin.y, 300, 45)];
        [_passwordField setImage:[UIImage imageNamed:@"password-593x68"]];
        [self.view addSubview:_passwordField];
        
        
    } else if ([_sharedVisitsTracking.deviceType isEqualToString:@"iPhone6P"]) {
        NSLog(@"adding view for 6p");

        _jetzunLogo = [[UIImageView alloc]initWithFrame:CGRectMake(30,300, 347,115)];
        [_jetzunLogo setImage:[UIImage imageNamed:@"logo-jetzun800"]];
        [self.view addSubview:_jetzunLogo];
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(100,60,260,40)];
        [_userName setClearsOnBeginEditing:YES];
        [_userName setFont:[UIFont fontWithName:@"Lato-Light" size:18]];
        [_userName setText:@""];
        [_userName setTextColor:[UIColor blackColor]];
        [_userName setBackgroundColor:[UIColor clearColor]];
        [_userName setAlpha:0.8];
        
        [self.view addSubview:_userName];
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(100, 120, 260, 40)];
        [_passWord setClearsOnBeginEditing:YES];
        [_passWord setSecureTextEntry:YES];
        [_passWord setBackgroundColor:[UIColor clearColor]];
        [_passWord setFont:[UIFont fontWithName:@"Lato-Light" size:18]];
        [_passWord setTextColor:[UIColor blackColor]];
        [_passWord setAlpha:0.8];
        
        [self.view addSubview:_passWord];
        
        _loginButton.frame = CGRectMake(120, 200, 200,50);
        [self.view addSubview:_loginButton];
        
        
        _createAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _createAccountButton.frame = CGRectMake(0, 260, width, 60);
        [_createAccountButton setTitle:@"NEED ACCOUNT?" forState:UIControlStateNormal];
        
        [_createAccountButton addTarget:self
                                 action:@selector(createNewAccount)
                       forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_createAccountButton];
        
        
        _loginField = [[UIImageView alloc]initWithFrame:CGRectMake(50, _userName.frame.origin.y, 300, 30)];
        
        [_loginField setImage:[UIImage imageNamed:@"username-login-clean"]];
        [self.view addSubview:_loginField];
        
        
        _passwordField = [[UIImageView alloc]initWithFrame:CGRectMake(50, _passWord.frame.origin.y, 300, 30)];
        [_passwordField setImage:[UIImage imageNamed:@"password-593x68"]];
        [self.view addSubview:_passwordField];
        
    } else if ([_sharedVisitsTracking.deviceType isEqualToString:@"iPhone6"]) {
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
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

-(void) createNewAccount {

    CGRect newFrame = CGRectMake(-400, _userName.frame.origin.y, _userName.frame.size.width, _userName.frame.size.height);
 
    _pickUserName = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2,60,260,40)];
    _pickPassword = [[UITextField  alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2,120, 260, 40)];
    _pickPasswordConfirm = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2, 180, 260, 40)];
    
    CGRect newFrame2 = CGRectMake(100, _pickUserName.frame.origin.y, _pickUserName.frame.size.width, _pickUserName.frame.size.height);
    
    CGRect newFrame3 = CGRectMake(100, _pickPassword.frame.origin.y, _pickPassword.frame.size.width, _pickPassword.frame.size.height);
    
    CGRect newFrame4 = CGRectMake(100, _pickPasswordConfirm.frame.origin.y, _pickPasswordConfirm.frame.size.width, _pickPasswordConfirm.frame.size.height);
    
    [_pickUserName setClearsOnBeginEditing:YES];
    [_pickUserName setFont:[UIFont fontWithName:@"Lato-Light" size:18]];
    [_pickUserName setText:@"Enter email address"];
    [_pickUserName setTextColor:[UIColor blackColor]];
    [_pickUserName setBackgroundColor:[UIColor whiteColor]];
    [_pickUserName setAlpha:0.8];
    [self.view addSubview:_pickUserName];
    
    [_pickPassword setClearsOnBeginEditing:YES];
    [_pickPassword setSecureTextEntry:YES];
    [_pickPassword setFont:[UIFont fontWithName:@"Lato-Light" size:18]];
    [_pickPassword setText:@"Password"];
    [_pickPassword setTextColor:[UIColor blackColor]];
    [_pickPassword setBackgroundColor:[UIColor whiteColor]];
    [_pickPassword setAlpha:0.8];
    [self.view addSubview:_pickPassword];
    
    [_pickPasswordConfirm setClearsOnBeginEditing:YES];
    [_pickPasswordConfirm setSecureTextEntry:YES];
    [_pickPasswordConfirm setFont:[UIFont fontWithName:@"Lato-Light" size:18]];
    [_pickPasswordConfirm setText:@"Confirm Pass"];
    [_pickPasswordConfirm setTextColor:[UIColor blackColor]];
    [_pickPasswordConfirm setBackgroundColor:[UIColor whiteColor]];
    [_pickPasswordConfirm setAlpha:0.8];
    [self.view addSubview:_pickPasswordConfirm];
    
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.3 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _userName.frame = newFrame;
        _passWord.frame = newFrame;
        _createAccount.frame = newFrame;
        _createAccountButton.frame = newFrame;
        _loginButton.frame = newFrame;
        
    } completion:^(BOOL finished) {
        
        _pickUserName.frame = newFrame2;
        _pickPassword.frame = newFrame3;
        _pickPasswordConfirm.frame = newFrame4;
        
        _makeAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeAccountButton.frame  = CGRectMake(_pickPasswordConfirm.frame.origin.x, _pickPassword.frame.origin.y+120, 240,40);
        [_makeAccountButton setBackgroundImage:[UIImage imageNamed:@"green-bg"] forState:UIControlStateNormal];
        [_makeAccountButton addTarget:self action:@selector(createNewAccountInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_makeAccountButton];
        
        UILabel *makeAccountLabel = [[UILabel alloc]initWithFrame:_makeAccountButton.frame];
        [makeAccountLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:18]];
        [makeAccountLabel setTextColor:[UIColor blackColor]];
        [makeAccountLabel setText:@"MAKE ACCOUNT"];
        [_makeAccountButton addSubview:makeAccountLabel];
        
    }];

}


-(void) createNewAccountInfo {
    
    [self createNewUserAccountWithName:_pickUserName.text andPassword:_pickPasswordConfirm.text andEmail:_pickUserName.text];
    
}


-(void) createNewUserAccountWithName:(NSString*)name
                         andPassword:(NSString*)password
                            andEmail:(NSString*)email {
    
    PFUser *user = [PFUser user];
    user.username = name;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Account successfully created");
            [_makeAccountButton removeFromSuperview];
            
            [PFUser logInWithUsernameInBackground:name
                                         password:password
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    
                                                    _createAccount = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 260, 40)];
                                                    [_createAccount setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
                                                    [_createAccount setTextColor:[UIColor greenColor]];
                                                    [_createAccount setText:@"Successful Login"];
                                                    [self.view addSubview:_createAccount];
                                                    
                                                    _sharedVisitsTracking.currentUser = user;
                                                    
                                                    NSLog(@"user info: %@",_sharedVisitsTracking.currentUser);
                                                
                                                } else {

                                                    _createAccount = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 260, 40)];
                                                    [_createAccount setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
                                                    [_createAccount setTextColor:[UIColor redColor]];
                                                    [_createAccount setText:@"Could not Login"];
                                                    [self.view addSubview:_createAccount];
                                                
                                                }
                                            }];
            
        } else {
            NSLog(@"Failed to create account");
        }
    }];
}


-(void)loginButtonClick {
    
    NSLog(@"login button clicked");
    
    NSString *userName = _userName.text;
    NSString *password = _passWord.text;
    
    [_loginButton setAlpha:0.3];
    
    if ([password isEqualToString:@""]) {
        userName = @"teddyhoo@hotmail.com";
        password = @"SusieQ";
    }
    
    NSLog(@"%@, pass: %@",userName,password);
    
    NSUserDefaults *loginSetting = [NSUserDefaults standardUserDefaults];
    [loginSetting setObject:userName forKey:@"username"];
    [loginSetting setObject:password forKey:@"password"];
    

    [PFUser logInWithUsernameInBackground:userName
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"successful login");
                                            
                                            [_passWord removeFromSuperview];
                                            [_userName removeFromSuperview];
                                            [_loginButton removeFromSuperview];
                                            [_createAccountButton removeFromSuperview];
                                            [_createAccount removeFromSuperview];
                                            [_loginField removeFromSuperview];
                                            [_passwordField removeFromSuperview];
                                            
                                            _sharedVisitsTracking.currentUser = user;
                                            
                                            CGRect newFrameLogo = CGRectMake(0, 40, 108, 32);
                                            [UIView animateWithDuration:1.8
                                                                  delay:0.2
                                                 usingSpringWithDamping:0.2
                                                  initialSpringVelocity:0.9
                                                                options:UIViewAnimationOptionCurveEaseIn
                                                             animations:^{
                                                                 
                                                                 _jetzunLogo.frame = newFrameLogo;
                                                                 
                                                } completion:^(BOOL finished) {
                                                    
                                                    _jetzunLogo.alpha = 1.0;
                                                    
                                                    NSLog(@"User ID: %@",user.objectId);
                                                    
                                                    LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
                                                    GPUberViewController *uber = [[GPUberViewController alloc]initWithServerToken:[_sharedVisitsTracking uberCredServer]];

                                                    uber.startLocation = sharedLocation.lastValidLocation;
                                                    uber.endLocation = CLLocationCoordinate2DMake(37.5570, -77.4740);
                                                    [uber showInViewController:self];
                                            
                                            }];
                                            
                                            
                                        } else {
                                            NSLog(@"failed login");
                                        }
                                    }];
    
}


- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    NSLog(@"Called %@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)keyboardWillShowNotification:(NSNotification *)notification {

}

- (void)keyboardWillHideNotification:(NSNotification *)notification {

}

- (void)updateTextViewContentInset {
    
}

- (void)keyboardDidShow:(NSNotification *)note {
    
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    
}

- (void)dismissKeyboard {
    
    
    
}


@end