//
//  AboutUsViewController.m
//  SuperMarket
//
//  Created by phoenix on 1/23/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MBProgressHUD.h"
#import "Setting.h"
#import "CompanyViewController.h"
#import "AppDelegate.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize btnContact;
@synthesize btnInstagram;
@synthesize btnTwitter;
@synthesize fbButton;
@synthesize backImage;
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
                alertString = [Setting sharedInstance].pushDefaultAlertString;
                return;
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
                CompanyViewController *companyVC;
                
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
                
                 VC.selCompany = obj;
                [uvc.navigationController pushViewController:VC animated:YES];
            }
            else{
                companyVC.selCompany = obj;
                [navigationController popToViewController:companyVC animated:YES];
            }
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
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];

    CGRect tmpRect = self.tDescription.frame;
    if (IS_IPHONE_5){
        tmpRect.size.height = self.fbButton.frame.origin.y - tmpRect.origin.y - 50;
        if (ver_float >= 7.0) {
            tmpRect.size.height = self.fbButton.frame.origin.y - tmpRect.origin.y - 5;
        }
        
        [self.tDescription setFrame:tmpRect];
    }
    else if (IS_IPHONE_4) {
      //  tmpRect.origin.y -= 30;
        tmpRect.size.height = self.fbButton.frame.origin.y - tmpRect.origin.y - 50;
        if (ver_float >= 7.0) {
            tmpRect.size.height = self.fbButton.frame.origin.y - tmpRect.origin.y - 5;
        }
        [self.tDescription setFrame:tmpRect];
    }
    
    
    NSLog(@"Description text = %f, %f, %f, %f", self.fbButton.frame.origin.x, self.fbButton.frame.origin.y, self.fbButton.frame.size.width, self.fbButton.frame.size.height);
    
    NSLog(@"%f", tmpRect.size.height);
    
//    NSString *ver = [[UIDevice currentDevice] systemVersion];
//    float ver_float = [ver floatValue];
//    
//    if (ver_float >= 7.0){
//        if (IS_IPHONE_5){
//        [backImage setFrame:CGRectMake(0, 49, 320, 469)];
//        [fbButton setFrame:CGRectMake(10, 280, 300, 52)];
//        [btnTwitter setFrame:CGRectMake(10, 332, 300, 52)];
//        [btnInstagram setFrame:CGRectMake(10, 384, 300, 52)];
//            [btnContact setFrame:CGRectMake(10, 432, 300, 52)];}
//    }
    NSLog(@"backImage = %f, %f, %f, %f", backImage.frame.origin.x, self.backImage.frame.origin.y, self.backImage.frame.size.width, self.backImage.frame.size.height);
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    int myLang = 0;
    self.webBaseView.hidden = YES;
    
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = 1;
        self.lb_header.text = @"About Us";
        self.lb_title.textAlignment = NSTextAlignmentLeft;
        self.tDescription.textAlignment = NSTextAlignmentLeft;
        [fbButton setBackgroundImage:[UIImage imageNamed:@"fbbutton.png"] forState:UIControlStateNormal];
        [fbButton setBackgroundImage:[UIImage imageNamed:@"fbbutton.png"] forState:UIControlStateNormal];
        [fbButton setBackgroundImage:[UIImage imageNamed:@"fbbutton.png"] forState:UIControlStateNormal];
        
        [btnTwitter setBackgroundImage:[UIImage imageNamed:@"twitterbutton.png"] forState:UIControlStateNormal];
        [btnTwitter setBackgroundImage:[UIImage imageNamed:@"twitterbutton.png"] forState:UIControlStateNormal];
        [btnTwitter setBackgroundImage:[UIImage imageNamed:@"twitterbutton.png"] forState:UIControlStateNormal];
        
        [btnInstagram setBackgroundImage:[UIImage imageNamed:@"instagrambutton.png"] forState:UIControlStateNormal];
        [btnInstagram setBackgroundImage:[UIImage imageNamed:@"instagrambutton.png"] forState:UIControlStateNormal];
        [btnInstagram setBackgroundImage:[UIImage imageNamed:@"instagrambutton.png"] forState:UIControlStateNormal];
        
        [btnContact setBackgroundImage:[UIImage imageNamed:@"contactus.png"] forState:UIControlStateNormal];
        [btnContact setBackgroundImage:[UIImage imageNamed:@"contactus.png"] forState:UIControlStateNormal];
        [btnContact setBackgroundImage:[UIImage imageNamed:@"contactus.png"] forState:UIControlStateNormal];
        
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        myLang = 2;
        self.lb_header.text = @"من نحن";
        self.lb_title.textAlignment = NSTextAlignmentRight;
        self.tDescription.textAlignment = NSTextAlignmentRight;
        [fbButton setBackgroundImage:[UIImage imageNamed:@"arabfbbutton.png"] forState:UIControlStateNormal];
        [fbButton setBackgroundImage:[UIImage imageNamed:@"arabfbbutton.png"] forState:UIControlStateNormal];
        [fbButton setBackgroundImage:[UIImage imageNamed:@"arabfbbutton.png"] forState:UIControlStateNormal];
        
        [btnTwitter setBackgroundImage:[UIImage imageNamed:@"arabtwitterbutton.png"] forState:UIControlStateNormal];
        [btnTwitter setBackgroundImage:[UIImage imageNamed:@"arabtwitterbutton.png"] forState:UIControlStateNormal];
        [btnTwitter setBackgroundImage:[UIImage imageNamed:@"arabtwitterbutton.png"] forState:UIControlStateNormal];
        
        [btnInstagram setBackgroundImage:[UIImage imageNamed:@"arabinstagrambutton.png"] forState:UIControlStateNormal];
        [btnInstagram setBackgroundImage:[UIImage imageNamed:@"arabinstagrambutton.png"] forState:UIControlStateNormal];
        [btnInstagram setBackgroundImage:[UIImage imageNamed:@"arabinstagrambutton.png"] forState:UIControlStateNormal];
        
        [btnContact setBackgroundImage:[UIImage imageNamed:@"arabcontactus.png"] forState:UIControlStateNormal];
        [btnContact setBackgroundImage:[UIImage imageNamed:@"arabcontactus.png"] forState:UIControlStateNormal];
        [btnContact setBackgroundImage:[UIImage imageNamed:@"arabcontactus.png"] forState:UIControlStateNormal];
    
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<StaticPageGetRow xmlns=\"http://tempuri.org/\">\n"
                             "<ID>1</ID>\n"
                             "<Language>%d</Language>\n"
                             "</StaticPageGetRow>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", myLang];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=StaticPageGetRow"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/StaticPageGetRow" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
//    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Waiting..."];
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
  //  [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    if ([elementName isEqualToString:@"PageTitleAr"]){
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"PageContentAr"]){
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"PageTitleEN"]){
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"PageContentEN"]){
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
  //          [Setting sharedInstance].errString = soapResults;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            {
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Description getting failture." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
                [mes show];
            }
            else
            {
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@" خطأ في الوصول الي المعلومات" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }
        }
        
        soapResults = nil;
    }
    
    if ([elementName isEqualToString:@"PageTitleAr"]){
        recordResults = false;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        {
            self.lb_title.text = soapResults;
        }
        soapResults = Nil;
    }
    if ([elementName isEqualToString:@"PageContentAr"]){
        recordResults = false;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        {
            NSString *stringAbout = soapResults;
            stringAbout = [stringAbout stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
            stringAbout = [stringAbout stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            while ([stringAbout rangeOfString:@"\n\n"].location != NSNotFound) {
                stringAbout = [stringAbout stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
            }
            
            self.tDescription.text = stringAbout;
        }
        soapResults = Nil;
    }
    if ([elementName isEqualToString:@"PageTitleEN"]){
        recordResults = false;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        {
            self.lb_title.text = soapResults;
        }
        soapResults = Nil;
    }
    if ([elementName isEqualToString:@"PageContentEN"]){
        recordResults = false;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        {
            NSString *stringAbout = soapResults;
            stringAbout = [stringAbout stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
            stringAbout = [stringAbout stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            while ([stringAbout rangeOfString:@"\n\n"].location != NSNotFound) {
                stringAbout = [stringAbout stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
            }
            
            self.tDescription.text = stringAbout;
            
        }
        soapResults = Nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnFacebook:(id)sender {
    self.urlstring = @"https://www.facebook.com/q8Supermarket";
    NSURL *url = [NSURL URLWithString:self.urlstring];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webBaseView.hidden = NO;
[ [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] setLabelText : @"Loading..." ] ;
}

- (IBAction)onBtnTwitter:(id)sender {
    self.urlstring = @"https://twitter.com/q8supermarket";
    NSURL *url = [NSURL URLWithString:self.urlstring];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webBaseView.hidden = NO;
    [ [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] setLabelText : @"Loading..." ] ;
}

- (IBAction)onBtnInstagram:(id)sender {
    self.urlstring = @"http://instagram.com/q8supermarket";
    NSURL *url = [NSURL URLWithString:self.urlstring];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webBaseView.hidden = NO;
    [ [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] setLabelText : @"Loading..." ] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[self.loadingIndicator stopAnimating];
    [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
}

- (IBAction)onBtnContactUS:(id)sender {
    if([MFMailComposeViewController canSendMail]){
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *ver = [[UIDevice currentDevice] systemVersion];
        float ver_float = [ver floatValue];
        
//        if (ver_float >= 7.0){
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//            if (IS_IPHONE_5)
//                [appDelegate.window setFrame:CGRectMake(0, 0, 320, 568)];
//            else if (IS_IPHONE_4)
//                [appDelegate.window setFrame:CGRectMake(0, 0, 320, 480)];
//        }
        
        MFMailComposeViewController *mail=[[MFMailComposeViewController alloc]init];
        mail.mailComposeDelegate=self;
        NSArray *arr = [[NSArray alloc]initWithObjects:@"info@q8supermarket.com", nil];
        [mail setToRecipients:arr];
         [self presentViewController:mail animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Message cannot be sent");
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            
            NSLog(@"cancelled");
        }
            break;
        case MFMailComposeResultSaved:
        {
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@" تم حفظ ارسال البريد" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Sending Email is saved." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [mes show];
            }
        }
            break;
        case MFMailComposeResultSent:
        {
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@" تم ارسال البريد" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"The Email is sent." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [mes show];
            }
        }            break;
        case MFMailComposeResultFailed:
        {
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@" فشل في ارسال البريد" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Sending email is failed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [mes show];
            }
        }            break;
        default:
        {
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"لم يتم ارسال البريد" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"The email is not sent." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [mes show];
            }
        }            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
//    if (ver_float >= 7.0){
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        if (IS_IPHONE_5)
//            [appDelegate.window setFrame:CGRectMake(0, 20, 320, 548)];
//        else if (IS_IPHONE_4)
//            [appDelegate.window setFrame:CGRectMake(0, 20, 320, 460)];
//    }
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClose:(id)sender {
    self.webBaseView.hidden = YES;
    self.urlstring = @"";
     [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
}

- (IBAction)onShare:(id)sender {
    NSMutableArray *arrayShareContent = [[NSMutableArray alloc]init];

        [arrayShareContent addObject:@"Facebook : facebook.com/q8supermarket\n"];
        [arrayShareContent addObject:@"Twitter : @q8supermarket\n"];
        [arrayShareContent addObject:@"Instagram : @q8supermarket\n"];
        [arrayShareContent addObject:@"Contact Us : info@supermarket.com\n"];
    
    self.activityViewController = [[UIActivityViewController alloc]
                                   
                                   initWithActivityItems:arrayShareContent applicationActivities:nil];
    
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}
@end
