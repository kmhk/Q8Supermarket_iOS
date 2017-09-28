//
//  MyAccountViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "MyAccountViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "ForgotPasswordViewController.h"
#import <FacebookSDK/FBLoginView.h>
#import <FacebookSDK/FBRequest.h>
#import <FacebookSDK/FBSession.h>
#import "OAuth.h"
#import "MBProgressHUD.h"
#import "CompanyViewController.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
@interface MyAccountViewController ()

@end

@implementation MyAccountViewController
@synthesize txtPassword;
@synthesize txtUserName;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)didPush{
    if ([Setting sharedInstance].pushInfo != Nil && [Setting sharedInstance].lastViewController == self){
        NSString *pushStr = [Setting sharedInstance].pushInfo;
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSDictionary *dic = [parser objectWithString:pushStr];
        NSString *alertString;
        NSString *titleString;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            titleString = @"Push Notification";
        else
            titleString = @" رساله تنبيه";
        int notificationType = [[dic objectForKey:@"notificationID"] intValue];
        switch (notificationType) {
            case 1:
            {
                NSString *str = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"CompanyID"] intValue]];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    alertString = [NSString stringWithFormat:@"New offer is added in %@",[[Setting sharedInstance] getCompanyName:str]];
                else
                    alertString = [NSString stringWithFormat:@" تم اضافه عرض جديد لـ %@",[[Setting sharedInstance] getCompanyName:str]];
            }
                break;
            case 2:
            {
                NSString *str = [dic objectForKey:@"FriendName"];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    alertString = [NSString stringWithFormat:@"Friend Request was sent from %@", str];
                else
                    alertString = [NSString stringWithFormat:@" تم ارسال طلب صداقة جديد من %@", str];
            }
                break;
            case 3:
            {
                NSString *str = [dic objectForKey:@"Sender"];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    alertString = [NSString stringWithFormat:@"New List was sent from %@", str];
                else
                    alertString = [NSString stringWithFormat:@" تم ارسال قائمة جديدة من %@", str];
            }
                break;
            default:
            {
                alertString = [Setting sharedInstance].pushDefaultAlertString;return;
            }
                break;
        }
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:titleString
                                                    message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [mes show];
    }
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        if ([Setting sharedInstance].pushInfo != nil) {
            /*  notification type 1 : new offer   */
            NSString *pushStr = [Setting sharedInstance].pushInfo;
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *dic = [parser objectWithString:pushStr];
            if ([[dic objectForKey:@"notificationID"] intValue] == 1){
                NSString *companyID = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"CompanyID"]intValue]];
                CompanyObject *obj;
                for (int i = 0; i < [Setting sharedInstance].arrayCompany.count; i++){
                    CompanyObject *obj1 = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
                    if ([companyID isEqualToString:obj1.companyID]) {
                        obj = obj1;
                        break;
                    }
                }

            UINavigationController *navigationController;
            
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
                [[Setting sharedInstance].tabBarController setSelectedIndex:0];
                navigationController = (UINavigationController*)[[Setting sharedInstance].tabBarController selectedViewController];
            }
            else{
                [[Setting sharedInstance].tabBarController setSelectedIndex:4];
                navigationController = (UINavigationController*)[[Setting sharedInstance].tabBarController selectedViewController];
            }
            
            CompanyViewController *companyVC;
            NSArray *array = [navigationController viewControllers];
            for (int i = 0; i < array.count; i++) {
                UIViewController *vc = [array objectAtIndex:i];
                NSLog(@"%@", NSStringFromClass([vc class]));
                if ([NSStringFromClass([vc class]) isEqualToString:@"CompanyViewController"])
                {
                    companyVC = (CompanyViewController*)vc;
                    companyVC.selCompany = obj;
                    break;
                    
                }
            }
            if (companyVC == nil)
            {
                UIViewController *uvc = [array objectAtIndex:0];
                UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
                CompanyViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"CompanyView"];
                // CompanyObject *comObj = [[Setting sharedInstance].arrayCompany objectAtIndex:tapGesture.view.tag - 1];
                // VC.selCompany = comObj;
                VC.selCompany = obj;
                [uvc.navigationController pushViewController:VC animated:YES];
            }
            else{
                [navigationController popToViewController:companyVC animated:YES];}
            /* -------------notificatin type 1------------- */
            }
            else if ([[dic objectForKey:@"notificationID"] intValue] == 2){
                FriendObject *friendObj = [[FriendObject alloc]init];
                friendObj.friendID = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"FriendID"]intValue]];
                NSString *cityID = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"CityID"]intValue]];
                friendObj.friendCity = [[Setting sharedInstance] getCityName:cityID];
                friendObj.friendName = [dic objectForKey:@"FriendName"];
                friendObj.friendMobile = [dic objectForKey:@"MobileNo"];
                friendObj.friendEmail = [dic objectForKey:@"Email"];
                UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
                AcceptRequestViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"AcceptRequestView"];
                
                VC.obj = friendObj;
                [self.navigationController pushViewController:VC animated:YES];
            }
            else if ([[dic objectForKey:@"notificationID"] intValue] == 3){
                UINavigationController *navigationController;
                
                [[Setting sharedInstance].tabBarController setSelectedIndex:2];
                navigationController = (UINavigationController*)[[Setting sharedInstance].tabBarController selectedViewController];
                MyListViewController *listVC = nil;
                
                NSArray *array = [navigationController viewControllers];
                listVC = (MyListViewController*)[array objectAtIndex:0];
                [navigationController popToViewController:listVC animated:YES];
            }
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didPush)
                                                 name:@"PushDid"
                                               object:nil];
	// Do any additional setup after loading the view.
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    txtUserName.text = @"";
    txtPassword.text = @"";
    soapResults = Nil;
    recordResults = FALSE;
    self.btnGmail.hidden = YES;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        self.lb_title.text = @"My Account";
        self.txtUserName.placeholder = @"Username";
        self.txtPassword.placeholder = @"Password";
        self.txtUserName.textAlignment = NSTextAlignmentLeft;
        self.txtPassword.textAlignment = NSTextAlignmentLeft;
        [self.btnForgot setTitle:@"Forgot password?" forState:UIControlStateNormal];

        [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_login.png"] forState:UIControlStateNormal];
        [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_login.png"] forState:UIControlStateHighlighted];
        [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_login.png"] forState:UIControlStateSelected];
        
        [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
        [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateHighlighted];
        [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateSelected];
        
        [self.btnFacebook setBackgroundImage:[UIImage imageNamed:@"btn_fb_login.png"] forState:UIControlStateNormal];
        [self.btnFacebook setBackgroundImage:[UIImage imageNamed:@"btn_fb_login.png"] forState:UIControlStateHighlighted];
        [self.btnFacebook setBackgroundImage:[UIImage imageNamed:@"btn_fb_login.png"] forState:UIControlStateSelected];
        
        [self.btnTwitter setBackgroundImage:[UIImage imageNamed:@"btn_twitter_login.png"] forState:UIControlStateNormal];
        [self.btnTwitter setBackgroundImage:[UIImage imageNamed:@"btn_twitter_login.png"] forState:UIControlStateHighlighted];
        [self.btnTwitter setBackgroundImage:[UIImage imageNamed:@"btn_twitter_login.png"] forState:UIControlStateSelected];
        
        
    }
    else{
        self.lb_title.text = @"حسابي";
        self.txtUserName.placeholder = @"اسم المستخدم";
        self.txtPassword.placeholder = @"كلمة المرور";
        self.txtUserName.textAlignment = NSTextAlignmentRight;
        self.txtPassword.textAlignment = NSTextAlignmentRight;
        
        [self.btnForgot setTitle:@"نسيت كلمة المرور؟" forState:UIControlStateNormal];
        [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"arab_login.png"] forState:UIControlStateNormal];
        [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"arab_login.png"] forState:UIControlStateHighlighted];
        [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"arab_login.png"] forState:UIControlStateSelected];
        
        [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"arab_register.png"] forState:UIControlStateNormal];
        [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"arab_register.png"] forState:UIControlStateHighlighted];
        [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"arab_register.png"] forState:UIControlStateSelected];
        
        [self.btnFacebook setBackgroundImage:[UIImage imageNamed:@"arab_fb_login.png"] forState:UIControlStateNormal];
        [self.btnFacebook setBackgroundImage:[UIImage imageNamed:@"arab_fb_login.png"] forState:UIControlStateHighlighted];
        [self.btnFacebook setBackgroundImage:[UIImage imageNamed:@"arab_fb_login.png"] forState:UIControlStateSelected];
        
        [self.btnTwitter setBackgroundImage:[UIImage imageNamed:@"arab_twitter_login.png"] forState:UIControlStateNormal];
        [self.btnTwitter setBackgroundImage:[UIImage imageNamed:@"arab_twitter_login.png"] forState:UIControlStateHighlighted];
        [self.btnTwitter setBackgroundImage:[UIImage imageNamed:@"arab_twitter_login.png"] forState:UIControlStateSelected];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnList:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
    
    // Session is open
    FriendViewController *c = [mainstoryboard instantiateViewControllerWithIdentifier:@"FriendManageView"];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    c.navigationController.navigationBarHidden = YES;
    c.prevView = self;
    c.viewName = @"none";
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)onForgot:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
    ForgotPasswordViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"ForgotPasswordView"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onBtnGmail:(id)sender {
}

- (IBAction)onBtnFacebook:(id)sender {
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [FBSession setActiveSession:nil];
    
    FBSession *session1 = [FBSession activeSession];
    if (FBSession.activeSession.state != FBSessionStateCreatedTokenLoaded) {
        session1 = [[FBSession alloc] init];
        // Set the active session
        [FBSession setActiveSession:session1];
    }
    
    NSArray *permissions =
    [NSArray arrayWithObjects:@"basic_info", @"email", @"user_photos", @"friends_photos", nil];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        [ [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] setLabelText : @"Loading..." ] ;
    else
        [ [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] setLabelText : @"تحميل..." ] ;
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      // Respond to session state changes
                                      if ([session isOpen]) {
                                          
                                          
                                          
                                          [Setting sharedInstance].customer.AccessToken = session.accessToken;

                                          
                                          
                                          [FBRequestConnection startForMeWithCompletionHandler:
                                           ^(FBRequestConnection *connection, id result, NSError *error)
                                           {
                                               NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
                                               userInfo = (NSMutableDictionary*)result;
                                               NSString *username = [userInfo objectForKey:@"username"];
                                               //    [self.loadingIndicator stopAnimating];
                                               int myLang = 0;
                                               if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                                               {
                                                   myLang = 1;
                                               }
                                               else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                                                   myLang = 2;
                                               }
                                               [Setting sharedInstance].customer.Username = username;
                                               [Setting sharedInstance].customer.UserType = @"1";
                                               [Setting sharedInstance].customer.fullName = [userInfo objectForKey:@"name"];
                                               [Setting sharedInstance].customer.Email = [userInfo objectForKey:@"email"];
                                               
                                               NSString *soapMessage = [NSString stringWithFormat:
                                                                        @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                                                        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                                                        "<soap:Body>\n"
                                                                        "<CustomerLogin xmlns=\"http://tempuri.org/\">\n"
                                                                        "<Username>%@</Username>\n"
                                                                        "<Password>0</Password>\n"
                                                                        "<Language>%d</Language>\n"
                                                                        "</CustomerLogin>\n"
                                                                        "</soap:Body>\n"
                                                                        "</soap:Envelope>\n", [Setting sharedInstance].customer.Username, myLang];
                                               NSLog(@"soapMessage = %@\n", soapMessage);
                                               
                                               NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerLogin"];
                                               NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
                                               NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
                                               
                                               [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                                               [theRequest addValue: @"http://tempuri.org/CustomerLogin" forHTTPHeaderField:@"SOAPAction"];
                                               [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
                                               [theRequest setHTTPMethod:@"POST"];
                                               [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
                                               
                                               NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                                               if( theConnection )
                                               {
                                                   webData = [[NSMutableData alloc]init];
                                               }
                                               else
                                               {
                                                   NSLog(@"theConnection is NULL");
                                               }
                                               
                                             /*  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                               
                                               [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.Username forKey:@"Username"];
                                               [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.UserType forKey:@"UserType"];
                                               [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.AccessToken forKey:@"AccessToken"];
                                               [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"isLogin"];
                                               
                                               [[NSUserDefaults standardUserDefaults] synchronize];*/
                                               
                                           }];
                                          
                                          
                                          return;
                                          
                                      }
                                      else{
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      }
                                      
                                  }];
    
    

}

- (IBAction)onBtnTwitter:(id)sender {
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        [ [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] setLabelText : @"Loading..." ] ;
    else
        [ [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] setLabelText : @"تحميل..." ] ;
    
    oAuth = [[OAuth alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
    
   // [oAuth forget];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"twitter"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    TwitterDialog *td = [[TwitterDialog alloc] init];
    td.twitterOAuth = oAuth;
    td.delegate = self;
    td.logindelegate = self;
    
    [td show];
}
#pragma mark Twitter Delegates
- (void)twitterDidLogin {
    
    
    NSString *username = [oAuth valueForKey:@"screen_name"];
    NSString *token = [oAuth valueForKey:@"oauth_token"];
    NSString *secret = [oAuth valueForKey:@"oauth_token_secret"];
    
    [Setting sharedInstance].customer.AccessToken = token;
    
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        myLang = 2;
    }
    [Setting sharedInstance].customer.Username = username;
    [Setting sharedInstance].customer.UserType = @"2";
    [Setting sharedInstance].customer.fullName = @"0";
    [Setting sharedInstance].customer.Email = [NSString stringWithFormat:@"%@@gmail.com", username];
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CustomerLogin xmlns=\"http://tempuri.org/\">\n"
                             "<Username>%@</Username>\n"
                             "<Password>0</Password>\n"
                             "<Language>%d</Language>\n"
                             "</CustomerLogin>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [Setting sharedInstance].customer.Username, myLang];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerLogin"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/CustomerLogin" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection )
    {
        webData = [[NSMutableData alloc]init];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
   
   
   
}

-(void)twitterDidNotLogin:(BOOL)cancelled {
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"There was a unknown error authenticating with Twitter." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تحذير" message:@"حطأ غير معلوم في تأكيد البيانات مع تويتر" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
        [alert show];
        
    }
    [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
}
- (IBAction)onBtnRegister:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
    MyAccountViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"RegisterView"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onBtnLogin:(id)sender {
    [txtUserName resignFirstResponder];
    [txtPassword resignFirstResponder];
    if ([txtUserName.text isEqualToString:@""])
    {
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Please enter your username." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تحذير" message:@" الرجاء ادخال اسمك المستخدم" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    else if ([txtPassword.text isEqualToString:@""]){
        
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Please enter your password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تحذير" message:@" الرجاء ادخال كلمة المرور" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        myLang = 2;
    }
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CustomerLogin xmlns=\"http://tempuri.org/\">\n"
                             "<Username>%@</Username>\n"
                             "<Password>%@</Password>\n"
                             "<Language>%d</Language>\n"
                             "</CustomerLogin>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", txtUserName.text, txtPassword.text, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerLogin"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/CustomerLogin" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection )
	{
		webData = [[NSMutableData alloc]init];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
    [Setting sharedInstance].customer.UserType = @"0";
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"response XML = %@\n", theXML);
    
    xmlParser = Nil;
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    
   
	if( [elementName isEqualToString:@"CustomerID"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Name"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Email"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"MobileNumber"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"MobileID"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"CityID"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"AreaID"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Address"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Username"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Password"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"MobileType"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"UserType"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"AccessToken"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ErrMessage"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if( recordResults )
	{
		[soapResults appendString: string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
   if ([elementName isEqualToString:@"ErrMessage"]){
        recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            NSLog(@"error");
 
        }
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"CustomerID"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.customerID = soapResults;
        }
        soapResults = nil;
        
	}
    
    if( [elementName isEqualToString:@"Name"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.fullName = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"CustomerLoginResult"])
	{
		recordResults = FALSE;
        if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]) {
            int myLang = 0;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            {
                myLang = 1;
            }
            else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                myLang = 2;
            }
            NSString *soapMessage = [NSString stringWithFormat:
                                     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                     "<soap:Body>\n"
                                     "<CustomerGetProfile xmlns=\"http://tempuri.org/\">\n"
                                     "<CustomerID>%@</CustomerID>\n"
                                     "<Language>%d</Language>\n"
                                     "</CustomerGetProfile>\n"
                                     "</soap:Body>\n"
                                     "</soap:Envelope>\n", [Setting sharedInstance].customer.customerID, myLang];
            NSLog(@"soapMessage = %@\n", soapMessage);
            
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerGetProfile"];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/CustomerGetProfile" forHTTPHeaderField:@"SOAPAction"];
            [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
            if( theConnection )
            {
                webData = [[NSMutableData alloc]init];
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }

            //[self.navigationController popViewControllerAnimated:YES];
        }
        else if (![[Setting sharedInstance].customer.UserType isEqualToString:@"0"]){
            int myLang = 0;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            {
                myLang = 1;
            }
            else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                myLang = 2;
            }
            NSString *soapMessage = [NSString stringWithFormat:
                                     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                     "<soap:Body>\n"
                                     "<CustomerRegisterNew xmlns=\"http://tempuri.org/\">\n"
                                     "<Name>%@</Name>\n"
                                     "<Email>%@</Email>\n"
                                     "<MobileNumber></MobileNumber>\n"
                          //           "<MobileID>e19871093ae0910</MobileID>\n"
                                     "<MobileID>0</MobileID>\n"
                                     "<CityID>0</CityID>\n"
                                     "<AreaID>0</AreaID>\n"
                                     "<Address>0</Address>\n"
                                     "<Username>%@</Username>\n"
                                     "<Password>0</Password>\n"
                                     "<Language>%d</Language>\n"
                                     "<MobileType>2</MobileType>\n"
                                     "<UserType>%@</UserType>\n"
                                     "<AccessToken>%@</AccessToken>\n"
                                     "</CustomerRegisterNew>\n"
                                     "</soap:Body>\n"
                                     "</soap:Envelope>\n", [Setting sharedInstance].customer.fullName, [Setting sharedInstance].customer.Email, [Setting sharedInstance].customer.Username, myLang, [Setting sharedInstance].customer.UserType, [Setting sharedInstance].customer.AccessToken];
            NSLog(@"soapMessage = %@\n", soapMessage);
            
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerRegisterNew"];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/CustomerRegisterNew" forHTTPHeaderField:@"SOAPAction"];
            [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
            if( theConnection )
            {
                webData = [[NSMutableData alloc]init];
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }

        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Login failure." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"  فشل في تسجيل الدخول" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }
        }
        soapResults = nil;
	}
    if ([elementName isEqualToString:@"CustomerRegisterNewResult"]){
        recordResults = FALSE;
        if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
            int myLang = 0;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            {
                myLang = 1;
            }
            else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                myLang = 2;
            }
            NSString *soapMessage = [NSString stringWithFormat:
                                     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                     "<soap:Body>\n"
                                     "<CustomerLogin xmlns=\"http://tempuri.org/\">\n"
                                     "<Username>%@</Username>\n"
                                     "<Password>0</Password>\n"
                                     "<Language>%d</Language>\n"
                                     "</CustomerLogin>\n"
                                     "</soap:Body>\n"
                                     "</soap:Envelope>\n", [Setting sharedInstance].customer.Username, myLang];
            NSLog(@"soapMessage = %@\n", soapMessage);
            
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerLogin"];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/CustomerLogin" forHTTPHeaderField:@"SOAPAction"];
            [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
            if( theConnection )
            {
                webData = [[NSMutableData alloc]init];
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    }
    if( [elementName isEqualToString:@"Email"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Email = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"MobileNumber"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Mobile = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"MobileID"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.MobileID = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"CityID"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.StateID = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"AreaID"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.AreaID = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"Address"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Address = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"Username"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Username = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"Password"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Password = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"MobileType"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.MobileType = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"UserType"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            
            [Setting sharedInstance].customer.UserType = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"AccessToken"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            
            [Setting sharedInstance].customer.AccessToken = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"CustomerGetProfileResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.customerID forKey:@"customerID"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.fullName forKey:@"FullName"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.Email forKey:@"Email"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.Mobile forKey:@"Mobile"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.MobileID forKey:@"MobileID"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.StateID forKey:@"StateID"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.AreaID forKey:@"AreaID"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.Address forKey:@"Address"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.Username forKey:@"Username"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.Password forKey:@"Password"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.UserType forKey:@"UserType"];
        [[NSUserDefaults standardUserDefaults] setObject:[Setting sharedInstance].customer.AccessToken forKey:@"AccessToken"];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LastReceivedDate"];
        [[Setting sharedInstance] initInbox];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
	}

}

@end
