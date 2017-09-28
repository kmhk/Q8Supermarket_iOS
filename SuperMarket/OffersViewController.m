//
//  OffersViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "OffersViewController.h"
#import "Setting.h"
#import "CompanyViewController.h"
#import "CompanyObject.h"
#import "AsyncImageView.h"
#import "SBJsonParser.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
@interface OffersViewController ()

@end

@implementation OffersViewController
@synthesize logoArray;
@synthesize scrollCompanies;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize companyObj;
@synthesize errEncounter;
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
            case 4:
            {
                [self showCompanyLogo];
                return;
            }
                break;
            default:
            {
                alertString = [Setting sharedInstance].pushDefaultAlertString;return;
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
            NSString *pushStr = [Setting sharedInstance].pushInfo;
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *dic = [parser objectWithString:pushStr];
            NSLog(@"%@", dic);
            if ([[dic objectForKey:@"notificationID"] intValue] == 1){
                UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
                CompanyViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"CompanyView"];
                NSString *companyID = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"CompanyID"]intValue]];
                CompanyObject *comObj;
                for (int i = 0; i < [Setting sharedInstance].arrayCompany.count; i++){
                    CompanyObject *obj1 = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
                    if ([companyID isEqualToString:obj1.companyID]) {
                        comObj = obj1;
                        break;
                    }
                }
                 VC.selCompany = comObj;
                [self.navigationController pushViewController:VC animated:YES];
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
    if (IS_IPHONE_4) {
        CGRect frm = self.backImg.frame;
        frm.size.height -= 20;
        [self.backImg setFrame:frm];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didPush)
                                                 name:@"PushDid"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        self.backImg.image = [UIImage imageNamed:@"offers_bg.png"];
    else
        self.backImg.image = [UIImage imageNamed:@"araboffers_bg.png"];
    errEncounter = FALSE;
	// Do any additional setup after loading the view.
    [Setting sharedInstance].arrayCompany = [[NSMutableArray alloc]init];
    logoArray = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == TRUE){
        [Setting sharedInstance].customer = [[CustomerObject alloc]init];
        [Setting sharedInstance].customer.customerID = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerID"];
        [Setting sharedInstance].customer.fullName = [[NSUserDefaults standardUserDefaults] objectForKey:@"FullName"];
        [Setting sharedInstance].customer.Email = [[NSUserDefaults standardUserDefaults] objectForKey:@"Email"];
        [Setting sharedInstance].customer.Mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"Mobile"];
        [Setting sharedInstance].customer.MobileID = [[NSUserDefaults standardUserDefaults] objectForKey:@"MobileID"];
        [Setting sharedInstance].customer.StateID = [[NSUserDefaults standardUserDefaults] objectForKey:@"StateID"];
        [Setting sharedInstance].customer.AreaID = [[NSUserDefaults standardUserDefaults] objectForKey:@"AreaID"];
        [Setting sharedInstance].customer.Address = [[NSUserDefaults standardUserDefaults] objectForKey:@"Address"];
        [Setting sharedInstance].customer.Username = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
        [Setting sharedInstance].customer.Password = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
        [Setting sharedInstance].customer.UserType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];
        [Setting sharedInstance].customer.AccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    }
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    BOOL flag = TRUE;
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Companies"];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) != SQLITE_ROW) {
                    flag = FALSE;
                }
                else{
                    [Setting sharedInstance].arrayCompany = [[NSMutableArray alloc]init];
                    CompanyObject *obj = [[CompanyObject alloc]init];
                    obj.companyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    obj.companyNameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    obj.companyNameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    obj.companyEmail = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    obj.companyPhone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    obj.companyFax = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    obj.companyLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    obj.companyStateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                    obj.companyAreaID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                    obj.companyAddressAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                    obj.companyAddressEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                    obj.companyDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                    obj.companyDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                    obj.companyOverallSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                    obj.companyProductSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                    obj.companyOrderSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                    obj.companyBigLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                    obj.companyAboutUsLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                    obj.companySloganEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                    obj.companySloganAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
                    
                    
                    [[Setting sharedInstance].arrayCompany addObject:obj];
                    
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        CompanyObject *obj1 = [[CompanyObject alloc]init];
                        obj1.companyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                        obj1.companyNameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        obj1.companyNameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                        obj1.companyEmail = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                        obj1.companyPhone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                        obj1.companyFax = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                        obj1.companyLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                        obj1.companyStateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                        obj1.companyAreaID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                        obj1.companyAddressAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                        obj1.companyAddressEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                        obj1.companyDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                        obj1.companyDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                        obj1.companyOverallSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                        obj1.companyProductSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                        obj1.companyOrderSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                        obj1.companyBigLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                        obj1.companyAboutUsLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                        obj1.companySloganEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                        obj1.companySloganAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
                        
                        
                        [[Setting sharedInstance].arrayCompany addObject:obj1];
                        
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
        if ([Setting sharedInstance].arrayCompany.count > 0)
            [self showCompanyLogo];
    }
    
    if (flag == FALSE){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<CompanyGetAll xmlns=\"http://tempuri.org/\" />\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n"
                                 ];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CompanyGetAll"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/CompanyGetAll" forHTTPHeaderField:@"SOAPAction"];
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)select_offers:(id)sender {
    NSLog(@"offset = %f", scrollCompanies.contentOffset.x);
    CGFloat offsetScroll = scrollCompanies.contentOffset.x;

    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
    CompanyViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"CompanyView"];
    CompanyObject *comObj = [[Setting sharedInstance].arrayCompany objectAtIndex:tapGesture.view.tag - 1];
    VC.selCompany = comObj;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)showCompanyLogo{
    
    NSLog(@"companies = %d", [Setting sharedInstance].arrayCompany.count);
    NSLog(@"measure = %d", [Setting sharedInstance].arrayMeasures.count);
    NSLog(@"areas = %d", [Setting sharedInstance].Areas.count);
    NSLog(@"maincategories = %d", [Setting sharedInstance].MainCategories.count);
    NSLog(@"subcategories = %d", [Setting sharedInstance].SubCategories.count);
    NSLog(@"cities = %d", [Setting sharedInstance].Cities.count);
    
    for (int i = 0; i< [Setting sharedInstance].arrayCompany.count - 1; i++){
        CompanyObject *obj = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
        for (int j = i + 1; j < [Setting sharedInstance].arrayCompany.count; j++){
            CompanyObject *obj1 = [[Setting sharedInstance].arrayCompany objectAtIndex:j];
            if ([obj.companyOverallSort integerValue] > [obj1.companyOverallSort integerValue])
            {
                [[Setting sharedInstance].arrayCompany removeObjectAtIndex:i];
                [[Setting sharedInstance].arrayCompany insertObject:obj1 atIndex:i];
                [[Setting sharedInstance].arrayCompany removeObjectAtIndex:j];
                [[Setting sharedInstance].arrayCompany insertObject:obj atIndex:j];
                obj = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
            }
        }
    }
    for (int ii = 0; ii < [Setting sharedInstance].logoArray.count; ii++){
        UIView *companyLogo = [[Setting sharedInstance].logoArray objectAtIndex:ii];
        [companyLogo removeFromSuperview];
    }
    [[Setting sharedInstance].logoArray removeAllObjects];
    
    for (int i = 0; i< [Setting sharedInstance].arrayCompany.count; i++){
        CompanyObject *aas = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
        NSLog(@"company sort : %d", [aas.companyOverallSort integerValue]);
        CGRect scrollFrame = scrollCompanies.frame;
        if (IS_IPHONE_5) {
            scrollFrame.origin.y = 210;
        }
        else if (IS_IPHONE_4)
        {
            NSString *ver = [[UIDevice currentDevice] systemVersion];
            float ver_float = [ver floatValue];
            
            if (ver_float >= 7.0){
                scrollFrame.origin.y = 155;
            }
            else{
                scrollFrame.origin.y = 135;
            }
        }
        [scrollCompanies setFrame:scrollFrame];
        
        UIView *companyLogoView = [[UIView alloc]initWithFrame:CGRectMake(10 + i * 300, 0, 300, 278)];
        AsyncImageView *imgBasicLogo = [[AsyncImageView alloc]initWithFrame:CGRectMake(12, 5, 285, 253)];
        CompanyObject *compObj = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
        [imgBasicLogo setImageURL:[NSURL URLWithString:compObj.companyLogo]];
        [companyLogoView addSubview:imgBasicLogo];
        
        UIImageView *imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 295, 278)];
        imgLogo.image = [UIImage imageNamed:@"logoCase.png"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(select_offers:)];
        tapGesture.delegate = self;
        imgLogo.userInteractionEnabled = YES;
        imgLogo.tag = i + 1;
        [imgLogo addGestureRecognizer:tapGesture];
        [companyLogoView addSubview:imgLogo];
        [logoArray addObject:imgLogo];
        UIImageView *imgPin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 121, 39)];
        imgPin.image = [UIImage imageNamed:@"company_pin.png"];
        [companyLogoView addSubview:imgPin];
        
        UILabel *lb_pin = [[UILabel alloc]initWithFrame:CGRectMake(17, 22, 91, 21)];
        if([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            lb_pin.textAlignment = NSTextAlignmentLeft;
            lb_pin.text = [NSString stringWithFormat:@"%@ offers", compObj.companyNameEn];
        }
        if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        {
            lb_pin.textAlignment = NSTextAlignmentRight;
            lb_pin.text = [NSString stringWithFormat:@"عروض %@", compObj.companyNameAr];
        }
        [lb_pin setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
        [lb_pin setTextColor:[UIColor whiteColor]];
        [lb_pin setBackgroundColor:[UIColor clearColor]];
        [companyLogoView addSubview:lb_pin];
        
        NSString *bottomStr;
        if([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            bottomStr = compObj.companySloganEn;
        }
        if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        {
            bottomStr = compObj.companySloganAr;
        }
        UILabel *lb_bottom1 = [[UILabel alloc]initWithFrame:CGRectMake(21, 219, 260, 21)];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            lb_bottom1.textAlignment = NSTextAlignmentLeft;
        else
            lb_bottom1.textAlignment = NSTextAlignmentRight;
        
        lb_bottom1.text = bottomStr;
        [lb_bottom1 setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
        [lb_bottom1 setTextColor:[UIColor whiteColor]];
        [lb_bottom1 setBackgroundColor:[UIColor clearColor]];
        [companyLogoView addSubview:lb_bottom1];
        
        
        UILabel *lb_bottom2 = [[UILabel alloc] initWithFrame:CGRectMake(21, 235, 260, 21)];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        {
            lb_bottom2.textAlignment = NSTextAlignmentLeft;
            lb_bottom2.text = @"Browse latest offers in supermarket";
        }
        else
        {
            lb_bottom2.textAlignment = NSTextAlignmentRight;
            lb_bottom2.text = @"تفقد أحدث العروض الخاصة بالسوبرماركت";
        }
        [lb_bottom2 setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
        [lb_bottom2 setTextColor:[UIColor orangeColor]];
        [lb_bottom2 setBackgroundColor:[UIColor clearColor]];
        [companyLogoView addSubview:lb_bottom2];
        
        [scrollCompanies addSubview:companyLogoView];
        [[Setting sharedInstance].logoArray addObject:companyLogoView];
    }
    [scrollCompanies setContentSize:CGSizeMake(320 + 300 * ([Setting sharedInstance].logoArray.count - 1), 278)];
    scrollCompanies.delegate = self;
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
-(void)saveCompanyInfo{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;

    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        for (int i = 0; i < [Setting sharedInstance].arrayCompany.count; i++) {
            CompanyObject *obj = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
            NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO Companies (ID, NameAr, NameEn, Email, Phone, Fax, Logo, StateID, AreaID, AddressAr, AddressEn, DescAr, DescEn, OverallSort, ProductSort, OrderSort, BigLogo, AboutUsLogo, SloganEn, SloganAr) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", obj.companyID, obj.companyNameAr, obj.companyNameEn, obj.companyEmail, obj.companyPhone, obj.companyFax, obj.companyLogo, obj.companyStateID, obj.companyAreaID, obj.companyAddressAr, obj.companyAddressEn, obj.companyDescAr, obj.companyDescEn, obj.companyOverallSort, obj.companyProductSort, obj.companyOrderSort, obj.companyBigLogo, obj.companyAboutUsLogo, obj.companySloganEn, obj.companySloganAr];
            
            const char *query_stmt1 = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Company success");
                    
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(projectDB);
    }
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"CompanyResult"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        if (!companyObj)
            companyObj = [[CompanyObject alloc]init];
        
    }
    if ([elementName isEqualToString:@"ID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"NameAr"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"NameEn"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Email"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;    }
    if ([elementName isEqualToString:@"Phone"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Fax"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Logo"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"StateID"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AreaID"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressAr"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressEn"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescAr"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescEn"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OverallSort"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ProductSort"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OrderSort"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BigLogo"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AboutUsLogo"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"SloganEn"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;    }
    if ([elementName isEqualToString:@"SloganAr"]){
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
    if ([elementName isEqualToString:@"CompanyGetAllResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        [Setting sharedInstance].arrayCompany = Nil;
        [Setting sharedInstance].arrayCompany = [[NSMutableArray alloc]init];
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
        if (![soapResults isEqualToString:@""])
            errEncounter = TRUE;
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"CompanyGetAllResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
        if (errEncounter == TRUE)
        {
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"The company data can't be fetched from server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            }else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"لا يمكن الوصول الي بيانات الشركة من خلال السيرفر" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self saveCompanyInfo];
        [self showCompanyLogo];
	}
	if( [elementName isEqualToString:@"CompanyResult"])
	{
		recordResults = FALSE;
        [[Setting sharedInstance].arrayCompany addObject:companyObj];
        soapResults = nil;
        companyObj = nil;
	}
    if ([elementName isEqualToString:@"ID"]){
        recordResults = FALSE;
        companyObj.companyID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"NameAr"]){
        recordResults = FALSE;
        companyObj.companyNameAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"NameEn"]){
        recordResults = FALSE;
        companyObj.companyNameEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Email"]){
        recordResults = FALSE;
        companyObj.companyEmail = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Phone"]){
        recordResults = FALSE;
        companyObj.companyPhone = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Fax"]){
        recordResults = FALSE;
        companyObj.companyFax = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Logo"]){
        recordResults = FALSE;
        companyObj.companyLogo = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"StateID"]){
        recordResults = FALSE;
        companyObj.companyStateID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AreaID"]){
        recordResults = FALSE;
        companyObj.companyAreaID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AddressAr"]){
        recordResults = FALSE;
        companyObj.companyAddressAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AddressEn"]){
        recordResults = FALSE;
        companyObj.companyAddressEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescAr"]){
        recordResults = FALSE;
        companyObj.companyDescAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescEn"]){
        recordResults = FALSE;
        companyObj.companyDescEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OverallSort"]){
        recordResults = FALSE;
        companyObj.companyOverallSort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductSort"]){
        recordResults = FALSE;
        companyObj.companyProductSort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OrderSort"]){
        recordResults = FALSE;
        companyObj.companyOrderSort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"BigLogo"]){
        recordResults = FALSE;
        companyObj.companyBigLogo = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AboutUsLogo"]){
        recordResults = FALSE;
        companyObj.companyAboutUsLogo = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"SloganEn"]){
        recordResults = FALSE;
        companyObj.companySloganEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"SloganAr"]){
        recordResults = FALSE;
        companyObj.companySloganAr= soapResults;
        soapResults = nil;
    }
    
}
@end
