//
//  SendRequestViewController.m
//  SuperMarket
//
//  Created by phoenix on 1/22/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import "SendRequestViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "MBProgressHUD.h"
#import "CompanyViewController.h"
#import "Setting.h"
#import "MyListViewController.h"
#import "AcceptRequestViewController.h"
#import "AppDelegate.h"
@interface SendRequestViewController ()

@end

@implementation SendRequestViewController
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize tEmail;
@synthesize tFriendName;
@synthesize tMobile;
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
                if ([Setting sharedInstance].lastSelectedTabIndex == 0){
                    navigationController = self.navigationController;
                }
                else{
                    [[Setting sharedInstance].tabBarController setSelectedIndex:0];
                    navigationController = (UINavigationController*)[[Setting sharedInstance].tabBarController selectedViewController];
                }
            }
            else{
                if ([Setting sharedInstance].lastSelectedTabIndex == 4){
                    navigationController = self.navigationController;
                }
                else{
                    [[Setting sharedInstance].tabBarController setSelectedIndex:4];
                    navigationController = (UINavigationController*)[[Setting sharedInstance].tabBarController selectedViewController];
                }
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
            else
                [navigationController popToViewController:companyVC animated:YES];
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
    tEmail.text = @"";
    tMobile.text = @"";
    tFriendName.text = @"";
}
- (void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    self.errStatus = FALSE;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"btn_sendrequest.png"] forState:UIControlStateNormal];
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"btn_sendrequest.png"] forState:UIControlStateHighlighted];
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"btn_sendrequest.png"] forState:UIControlStateSelected];
        self.lb_title.text = @"Friend Request";
        tFriendName.placeholder = @"Friend Name";
        tEmail.placeholder = @"E-Mail";
        tMobile.placeholder = @"Mobile Number";
        self.lbOR.text = @"OR";
        self.lbOR1.text = @"OR";
    }
    else{
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"arab_sendrequest.png"] forState:UIControlStateNormal];
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"arab_sendrequest.png"] forState:UIControlStateHighlighted];
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"arab_sendrequest.png"] forState:UIControlStateSelected];
        self.lb_title.text = @"طلب صديق";
        tFriendName.placeholder = @"اسم الصديق";
        tEmail.placeholder = @"البريد الالكتروني";
        tMobile.placeholder = @"النقال";
        self.lbOR.text = @"أو";
        self.lbOR1.text = @"أو";
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect tmpRect = self.backView.frame;
    NSLog(@"%f", tmpRect.origin.y);
    if (textField == self.tMobile)
    {
        textField.keyboardType = UIKeyboardTypePhonePad;
        tmpRect.origin.y = -200;

    }
    else {
        tmpRect.origin.y = 0;
    }
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float >= 7.0) {
        tmpRect.origin.y += 20;
    }
    
    self.backView.frame = tmpRect;
    return TRUE;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGRect tmpRect = self.backView.frame;
    tmpRect.origin.y = 0;
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float >= 7.0) {
        tmpRect.origin.y = 20;
    }
    
    self.backView.frame = tmpRect;
    return TRUE;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSendRequest:(id)sender {
    CGRect tmpRect = self.backView.frame;
    tmpRect.origin.y = 0;
    self.backView.frame = tmpRect;
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add your friend." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"يجب عليك تسجيل الدخول لإضافة صديقك" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
        return;
    }
    [self.tEmail resignFirstResponder];
    [self.tMobile resignFirstResponder];
    [self.tFriendName resignFirstResponder];
    NSLog(@"%@, %@, %@", tEmail.text, tMobile.text, tFriendName.text);
    NSString *myLang;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = @"1";
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        myLang = @"2";
    }
    if (![tFriendName.text isEqualToString:@""]){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<FriendAddByUsername xmlns=\"http://tempuri.org/\">\n"
                                 "<CustomerID>%d</CustomerID>\n"
                                 "<Username>%@</Username>\n"
                                 "<Language>%@</Language>\n"
                                 "</FriendAddByUsername>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], self.tFriendName.text, myLang];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendAddByUsername"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/FriendAddByUsername" forHTTPHeaderField:@"SOAPAction"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Waiting..."];
        else
            [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"الرجاي الانتظار..."];
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if( theConnection )
        {
            webData = [[NSMutableData alloc]init];
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
        return;
    }
    if (![tEmail.text isEqualToString:@""]){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<FriendAddByEmail xmlns=\"http://tempuri.org/\">\n"
                                 "<CustomerID>%d</CustomerID>\n"
                                 "<Email>%@</Email>\n"
                                 "<Language>%@</Language>\n"
                                 "</FriendAddByEmail>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], self.tEmail.text, myLang];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendAddByEmail"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/FriendAddByEmail" forHTTPHeaderField:@"SOAPAction"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Waiting..."];
        else
            [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"الرجاي الانتظار..."];
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if( theConnection )
        {
            webData = [[NSMutableData alloc]init];
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
        return;
    }
    if (![tMobile.text isEqualToString:@""]){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<FriendAddByMobileNo xmlns=\"http://tempuri.org/\">\n"
                                 "<CustomerID>%d</CustomerID>\n"
                                 "<MobileNo>%@</MobileNo>\n"
                                 "<Language>%@</Language>\n"
                                 "</FriendAddByMobileNo>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], self.tMobile.text, myLang];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendAddByMobileNo"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/FriendAddByMobileNo" forHTTPHeaderField:@"SOAPAction"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Waiting..."];
        else
            [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"الرجاي الانتظار..."];
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if( theConnection )
        {
            webData = [[NSMutableData alloc]init];
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
        return;
    }
    
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
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    
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
            self.errStatus = TRUE;
            NSLog(@"error");
            [Setting sharedInstance].errString = soapResults;
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:[Setting sharedInstance].errString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
        }
        
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FriendAddByUsernameResponse"]){
        if (self.errStatus == FALSE){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Friend Request Sent Successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"تم ارسال طلبك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                [mes show];
            }
        }
        //[self.navigationController popViewControllerAnimated:YES];
    }
    if ([elementName isEqualToString:@"FriendAddByEmailResponse"]){
        if (self.errStatus == FALSE){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Friend Request Sent Successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"تم ارسال طلبك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                [mes show];
            }
        }

        //        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([elementName isEqualToString:@"FriendAddByMobileNoResponse"])
    {
        if (self.errStatus == FALSE){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Friend Request Sent Successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"تم ارسال طلبك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                [mes show];
            }
        }

        //      [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnList:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
    
    // Session is open
    FriendViewController *c = [mainstoryboard instantiateViewControllerWithIdentifier:@"FriendManageView"];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    c.navigationController.navigationBarHidden = YES;
    c.prevView = self;
    c.viewName = @"sendrequest";
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
@end
