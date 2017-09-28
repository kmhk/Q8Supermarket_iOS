//
//  CompanyViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "CompanyViewController.h"
#import "AboutViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "ProductObject.h"
#import "ProductViewController.h"
#import "MBProgressHUD.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
@interface CompanyViewController ()

@end

@implementation CompanyViewController
@synthesize selCompany;
@synthesize BigLogo;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize errEncounter;
@synthesize currentofferArray;
@synthesize currentArray;
@synthesize expiredofferArray;
@synthesize expiredArray;
@synthesize offerObj;
@synthesize currentTable;
@synthesize expireTable;
@synthesize tablesView;
@synthesize curOfferSection;
@synthesize expOfferSection;

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
                if ([[dic objectForKey:@"ObjectType"]intValue] == 1){
                    [self.navigationController popViewControllerAnimated:YES];
                }
                return;
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

                self.selCompany = obj;
            [self viewWillAppear:NO];
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
    self.btnCancel.hidden = YES;
    self.searchBar.hidden = YES;
    self.searchBar.placeholder=@"search in offers";
    self.searchBar.backgroundColor=[UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage new];
    
    self.searchBar.delegate = self ;
    [self.searchBar setTranslucent:YES];
    //remove background of searchbar
    for (UIView *subview in self.searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        UITextField *searchField;
        for (UIView *subview in self.searchBar.subviews)
        {
            
            //this will work in iOS 7
            for (id sub in subview.subviews) {
                if([NSStringFromClass([sub class]) isEqualToString:@"UISearchBarTextField"])
                {
                    [sub setTextAlignment:NSTextAlignmentLeft];
//                    [sub setLeftViewMode:UITextFieldViewModeAlways];
//                    [sub setRightView:nil];
//                    [sub setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon.png"]]];

                }
            }
            //this will work for less than iOS 7
            if ([subview isKindOfClass:[UITextField class]]) {
                searchField = (UITextField *)subview;
                break;
            }
        }
        //for less than iOS 7
        if (searchField) {
            searchField.textAlignment = NSTextAlignmentLeft;
//            searchField.leftViewMode = UITextFieldViewModeAlways;
//            searchField.rightView = nil;
//            searchField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon.png"]];
        }
    }
    else{
        UITextField *searchField;
        for (UIView *subview in self.searchBar.subviews)
        {
            //this will work in iOS 7
            for (id sub in subview.subviews) {
                if([NSStringFromClass([sub class]) isEqualToString:@"UISearchBarTextField"])
                {
                    [sub setTextAlignment:NSTextAlignmentRight];
//                    [sub setRightViewMode:UITextFieldViewModeAlways];
//                    [sub setLeftView:nil];
//                    [sub setRightView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon.png"]]];
                }
            }
            //this will work for less than iOS 7
            if ([subview isKindOfClass:[UITextField class]]) {
                searchField = (UITextField *)subview;
                break;
            }
        }
        //for less than iOS 7
        if (searchField) {
            searchField.textAlignment = NSTextAlignmentRight;
//            searchField.rightViewMode = UITextFieldViewModeAlways;
//            searchField.leftView = nil;
//            searchField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon.png"]];
        }
    }
    
    CGRect tmpFrame = tablesView.frame;
    if (IS_IPHONE_4) {
        tmpFrame.size.height = 308;
    }
    else if (IS_IPHONE_5) {
        tmpFrame.size.height = 392;
    }
    
    self.btnCurrentOffers.userInteractionEnabled = YES;
    self.btnExpiredOffers.userInteractionEnabled = YES;
    
    [tablesView setFrame:tmpFrame];
    [curOfferSection setFrame:CGRectMake(curOfferSection.frame.origin.x, 0, curOfferSection.frame.size.width, curOfferSection.frame.size.height)];
    [self.btnCurrentOffers setFrame:CGRectMake(curOfferSection.frame.origin.x, 0, curOfferSection.frame.size.width, curOfferSection.frame.size.height)];
    [currentTable setFrame:CGRectMake(currentTable.frame.origin.x, curOfferSection.frame.size.height + 5, currentTable.frame.size.width, tmpFrame.size.height / 2 - curOfferSection.frame.size.height - 10)];
    
    NSLog(@"Current Offer table = %f, %f, %f, %f", currentTable.frame.origin.x, currentTable.frame.origin.y, currentTable.frame.size.width, currentTable.frame.size.height);
    
    [expOfferSection setFrame:CGRectMake(expOfferSection.frame.origin.x, tmpFrame.size.height / 2, expOfferSection.frame.size.width, expOfferSection.frame.size.height)];
    [self.btnExpiredOffers setFrame:CGRectMake(expOfferSection.frame.origin.x, tmpFrame.size.height / 2, expOfferSection.frame.size.width, expOfferSection.frame.size.height)];
    [expireTable setFrame:CGRectMake(expireTable.frame.origin.x, expOfferSection.frame.origin.y + expOfferSection.frame.size.height + 5, expireTable.frame.size.width, tmpFrame.size.height - expOfferSection.frame.origin.y - expOfferSection.frame.size.height - 10)];
    
    NSLog(@"Expired Offer table = %f, %f, %f, %f", expireTable.frame.origin.x, expireTable.frame.origin.y, expireTable.frame.size.width, expireTable.frame.size.height);
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
//    if (ver_float >= 7.0){
//        if (IS_IPHONE_5){
//            [expireTable setFrame:CGRectMake(expireTable.frame.origin.x, expireTable.frame.origin.y, expireTable.frame.size.width, expireTable.frame.size.height + 23)];
//        }
//        else
//        {
//            [expireTable setFrame:CGRectMake(expireTable.frame.origin.x, expireTable.frame.origin.y, expireTable.frame.size.width, expireTable.frame.size.height + 20)];
//        }
//
//    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    errEncounter  = FALSE;
	// Do any additional setup after loading the view.
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        [self.btnAbout setBackgroundImage:[UIImage imageNamed:@"btn_about_market.png"] forState:UIControlStateNormal];
        [self.btnAbout setBackgroundImage:[UIImage imageNamed:@"btn_about_market.png"] forState:UIControlStateHighlighted];
        [self.btnAbout setBackgroundImage:[UIImage imageNamed:@"btn_about_market.png"] forState:UIControlStateSelected];
        
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_nav_cancel.png"] forState:UIControlStateNormal];
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_nav_cancel.png"] forState:UIControlStateHighlighted];
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_nav_cancel.png"] forState:UIControlStateSelected];
        
        [self.btnCurrentOffers setBackgroundImage:[UIImage imageNamed:@"table_sec_currentoffer.png"] forState:UIControlStateNormal];
        [self.btnCurrentOffers setBackgroundImage:[UIImage imageNamed:@"table_sec_currentoffer.png"] forState:UIControlStateHighlighted];
        [self.btnCurrentOffers setBackgroundImage:[UIImage imageNamed:@"table_sec_currentoffer.png"] forState:UIControlStateSelected];
        
        [self.btnExpiredOffers setBackgroundImage:[UIImage imageNamed:@"table_expiredoffer.png"] forState:UIControlStateNormal];
        [self.btnExpiredOffers setBackgroundImage:[UIImage imageNamed:@"table_expiredoffer.png"] forState:UIControlStateHighlighted];
        [self.btnExpiredOffers setBackgroundImage:[UIImage imageNamed:@"table_expiredoffer.png"] forState:UIControlStateSelected];
        
        
    }
    else{
        [self.btnAbout setBackgroundImage:[UIImage imageNamed:@"arab_about_market.png"] forState:UIControlStateNormal];
        [self.btnAbout setBackgroundImage:[UIImage imageNamed:@"arab_about_market.png"] forState:UIControlStateHighlighted];
        [self.btnAbout setBackgroundImage:[UIImage imageNamed:@"arab_about_market.png"] forState:UIControlStateSelected];
        
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"arab_nav_cancel.png"] forState:UIControlStateNormal];
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"arab_nav_cancel.png"] forState:UIControlStateHighlighted];
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"arab_nav_cancel.png"] forState:UIControlStateSelected];
        
        [self.btnCurrentOffers setBackgroundImage:[UIImage imageNamed:@"arabtable_sec_currentoffer.png"] forState:UIControlStateNormal];
        [self.btnCurrentOffers setBackgroundImage:[UIImage imageNamed:@"arabtable_sec_currentoffer.png"] forState:UIControlStateHighlighted];
        [self.btnCurrentOffers setBackgroundImage:[UIImage imageNamed:@"arabtable_sec_currentoffer.png"] forState:UIControlStateSelected];
        
        [self.btnExpiredOffers setBackgroundImage:[UIImage imageNamed:@"arabtable_expiredoffer.png"] forState:UIControlStateNormal];
        [self.btnExpiredOffers setBackgroundImage:[UIImage imageNamed:@"arabtable_expiredoffer.png"] forState:UIControlStateHighlighted];
        [self.btnExpiredOffers setBackgroundImage:[UIImage imageNamed:@"arabtable_expiredoffer.png"] forState:UIControlStateSelected];
        
    }
    
    currentofferArray = [[NSMutableArray alloc]init];
    currentArray = [[NSMutableArray alloc]init];
    expiredofferArray = [[NSMutableArray alloc]init];
    expiredArray = [[NSMutableArray alloc]init];
    
    currentTable.backgroundColor = [UIColor clearColor];
    currentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    expireTable.backgroundColor = [UIColor clearColor];
    expireTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        self.lb_title.text = selCompany.companyNameEn;
    if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        self.lb_title.text = selCompany.companyNameAr;
    if (selCompany.companyBigLogo){
        NSRange pngRange = [selCompany.companyBigLogo rangeOfString:@".png"];
        NSRange jpgRange = [selCompany.companyBigLogo rangeOfString:@".jpg"];
        NSRange jpegRange = [selCompany.companyBigLogo rangeOfString:@".jpeg"];
        if (pngRange.location != NSNotFound || jpegRange.location
            != NSNotFound || jpgRange.location != NSNotFound){
            [BigLogo setImageURL:[NSURL URLWithString:selCompany.companyBigLogo]];
        }
    }
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    
    /*  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
     [df setLocale:locale];
     NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
     [df setTimeZone:timeZone];*/
    sqlite3_stmt    *statement;
    
    BOOL flag = TRUE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Offers where CompanyID = \"%@\"", selCompany.companyID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) != SQLITE_ROW) {
                flag = FALSE;
            }
            else{
                
                
                OfferObject *obj = [[OfferObject alloc]init];
                obj.offerID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                obj.offerCompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.offerTitleAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.offerTitleEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                obj.offerDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                obj.offerDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                obj.offerPhotoURL = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                obj.offerStartDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                obj.offerEndDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                obj.offerIsActive = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                obj.offerBranchList = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                obj.offerlastUpdateTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                obj.offerProducts = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                
                if ([obj.offerIsActive isEqualToString:@"true"])
                {
                    
                    NSString *endTimeStr = [obj.offerEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    NSDateFormatter *df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                    [df setLocale:locale];
                    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                    [df setTimeZone:tz];
                    NSDate *endDate = [df dateFromString:endTimeStr];
                    NSDate *today = [[NSDate alloc]init];
                    
                    if ([today compare:endDate] == NSOrderedAscending){
                        [currentofferArray addObject:obj];
                        [currentArray addObject:obj];
                    }
                    else{
                        if ([[Setting sharedInstance] checkAndDelete:endDate withOfferID:obj.offerID] == TRUE){
                        [expiredofferArray addObject:obj];
                        [expiredArray addObject:obj];
                        }
                    }
                }
                
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    OfferObject *obj1 = [[OfferObject alloc]init];
                    obj1.offerID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    obj1.offerCompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    obj1.offerTitleAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    obj1.offerTitleEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    obj1.offerDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    obj1.offerDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    obj1.offerPhotoURL = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    obj1.offerStartDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                    obj1.offerEndDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                    obj1.offerIsActive = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                    obj1.offerBranchList = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                    obj1.offerlastUpdateTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                    obj1.offerProducts = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                    
                    if ([obj1.offerIsActive isEqualToString:@"true"])
                    {
                        
                        NSString *endTimeStr = [obj1.offerEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        NSDateFormatter *df = [[NSDateFormatter alloc]init];
                        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                        [df setLocale:locale];
                        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                        [df setTimeZone:tz];
                        NSDate *endDate = [df dateFromString:endTimeStr];
                        NSDate *today = [[NSDate alloc]init];
                        
                        if ([today compare:endDate] == NSOrderedAscending){
                            [currentofferArray addObject:obj1];
                            [currentArray addObject:obj1];
                        }
                        else{
                            if ([[Setting sharedInstance] checkAndDelete:endDate withOfferID:obj1.offerID] == TRUE){
                                [expiredofferArray addObject:obj1];
                                [expiredArray addObject:obj1];
                            }
                        }
                    }
                    
                    
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(projectDB);
    }
    if ([Setting sharedInstance].pushInfo != nil){
        flag = false;
        [Setting sharedInstance].pushInfo = nil;
    }
    else
    {
        [self sortOffers:currentofferArray];
        [self sortOffers:currentArray];
        [self sortOffers:expiredofferArray];
        [self sortOffers:expiredArray];
        
        [currentTable reloadData];
        [expireTable reloadData];
    }
    if (flag == FALSE){
        NSDate *date = [[NSDate alloc]init];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [df stringFromDate:date];
        NSLog(@"date = %@", dateStr);
        [df setDateFormat:@"HH:mm:ss"];
        NSString *timeStr = [df stringFromDate:date];
        NSString *reqUpdateTimeStr = [NSString stringWithFormat:@"%@T%@", dateStr, timeStr];
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<GetCompanyOffers xmlns=\"http://tempuri.org/\">\n"
                                 "<CompanyID>%@</CompanyID>\n"
                                 "<LastUpdateTime>%@</LastUpdateTime>\n"
                                 "<CustomerID>%@</CustomerID>\n"
                                 "</GetCompanyOffers>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", selCompany.companyID, @"2013-07-15T00:00:00", [Setting sharedInstance].customer.customerID];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=GetCompanyOffers"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/GetCompanyOffers" forHTTPHeaderField:@"SOAPAction"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Loading..."];
        else
            [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"تحميل..."];
        
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
- (void)sortOffers:(NSMutableArray*)arrList{
    if (arrList.count > 1){
    for (int i = 0; i < arrList.count - 1; i++) {
        OfferObject *obj = [arrList objectAtIndex:i];
        OfferObject *replaceObj = obj;
        int repIndex = i;
        BOOL flag = FALSE;
        NSString *endTimeStr1 = [obj.offerEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [df setLocale:locale];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [df setTimeZone:tz];
        NSDate *Date1 = [df dateFromString:endTimeStr1];
        for (int j = i + 1; j < arrList.count; j++) {
            OfferObject *obj1 = [arrList objectAtIndex:j];
            NSString *endTimeStr2 = [obj1.offerEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            NSDateFormatter *df2 = [[NSDateFormatter alloc]init];
            [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [df2 setLocale:locale2];
            NSTimeZone *tz2 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            [df2 setTimeZone:tz2];
            NSDate *Date2 = [df2 dateFromString:endTimeStr2];

            
            if ([Date1 compare:Date2] == NSOrderedAscending){
                replaceObj = obj1;
                repIndex = j;
                flag = TRUE;
            }
        }
        if (flag == TRUE){
            [arrList replaceObjectAtIndex:i withObject:replaceObj];
            [arrList replaceObjectAtIndex:repIndex withObject:obj];
        }
    }
    }
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    self.btnCurrentOffers.userInteractionEnabled = YES;
    self.btnExpiredOffers.userInteractionEnabled = YES;
    CGRect tmpRect;
    if (_tableView == currentTable) {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"CurrentCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CurrentCell"];
        ;
        UILabel *lb_title = (UILabel*)[cell viewWithTag:101];
        UILabel *lb_prodText = (UILabel*)[cell viewWithTag:113];
        UILabel *lb_products = (UILabel*)[cell viewWithTag:102];
        OfferObject *obj = [currentArray objectAtIndex:indexPath.row];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        {
            lb_title.text = obj.offerTitleEn;
            lb_title.textAlignment = NSTextAlignmentLeft;
            lb_prodText.text = @"Product(s)";
            tmpRect = lb_prodText.frame;
            tmpRect.origin.x = 225;
            lb_prodText.frame = tmpRect;
            
            tmpRect = lb_products.frame;
            tmpRect.origin.x = 180;
            lb_products.frame = tmpRect;
            lb_products.textAlignment = NSTextAlignmentRight;
            
        }else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        {
            lb_title.text = obj.offerTitleAr;
            lb_title.textAlignment = NSTextAlignmentRight;
            lb_prodText.text = @"منتج";
            tmpRect = lb_prodText.frame;
            tmpRect.origin.x = 15;
            lb_prodText.frame = tmpRect;
            tmpRect = lb_products.frame;
            tmpRect.origin.x = 40;
            lb_products.frame = tmpRect;
            lb_products.textAlignment = NSTextAlignmentLeft;
        }
        
        if ([obj.offerProducts isEqualToString:@""]){
            lb_products.text = @"0";
            
        }
        else{
            lb_products.text = obj.offerProducts;
            
        }
    }
    else if (_tableView == expireTable){
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"ExpireCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpireCell"];
        
        UILabel *lb_title = (UILabel*)[cell viewWithTag:103];
        UILabel *lb_prodText = (UILabel*)[cell viewWithTag:114];
        UILabel *lb_products = (UILabel*)[cell viewWithTag:104];
        OfferObject *obj = [expiredArray objectAtIndex:indexPath.row];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        {
            lb_title.text = obj.offerTitleEn;
            lb_title.textAlignment = NSTextAlignmentLeft;
            lb_prodText.text = @"Product(s)";
            tmpRect = lb_prodText.frame;
            tmpRect.origin.x = 225;
            lb_prodText.frame = tmpRect;
            
            tmpRect = lb_products.frame;
            tmpRect.origin.x = 180;
            lb_products.frame = tmpRect;
            lb_products.textAlignment = NSTextAlignmentRight;
        }else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        {
            lb_title.text = obj.offerTitleAr;
            lb_title.textAlignment = NSTextAlignmentRight;
            lb_prodText.text = @"منتج";
            tmpRect = lb_prodText.frame;
            tmpRect.origin.x = 15;
            lb_prodText.frame = tmpRect;
            
            tmpRect = lb_products.frame;
            tmpRect.origin.x = 40;
            lb_products.frame = tmpRect;
            lb_products.textAlignment = NSTextAlignmentLeft;
        }
        
        if ([obj.offerProducts isEqualToString:@""])
            lb_products.text = @"0";
        else
            lb_products.text = obj.offerProducts;
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"offertable_cellbg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1001){
        return currentArray.count;
    }
    else if (tableView.tag == 1002)
        return expiredArray.count;
    return 0;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
    ProductViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"ProductsView"];
    if (tableView.tag == 1001){
        OfferObject *offObj = [currentArray objectAtIndex:indexPath.row];
        VC.selOffer = offObj;
        VC.companyName = self.lb_title.text;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if (tableView.tag == 1002){
        OfferObject *offObj = [expiredArray objectAtIndex:indexPath.row];
        VC.selOffer = offObj;
        VC.companyName = self.lb_title.text;
        [self.navigationController pushViewController:VC animated:YES];
    }
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<AddOfferVisit xmlns=\"http://tempuri.org/\">\n"
                             "<CompanyID>%@</CompanyID>\n"
                             "<OfferID>%@</OfferID>\n"
                             "<CustomerID>%@</CustomerID>\n"
                             "</AddOfferVisit>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", selCompany.companyID, VC.selOffer.offerID, [Setting sharedInstance].customer.customerID];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=AddOfferVisit"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/AddOfferVisit" forHTTPHeaderField:@"SOAPAction"];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCurrentOffers:(id)sender {
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [df stringFromDate:date];
    NSLog(@"date = %@", dateStr);
    [df setDateFormat:@"HH:mm:ss"];
    NSString *timeStr = [df stringFromDate:date];
    NSString *reqUpdateTimeStr = [NSString stringWithFormat:@"%@T%@", dateStr, timeStr];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetCompanyOffers xmlns=\"http://tempuri.org/\">\n"
                             "<CompanyID>%@</CompanyID>\n"
                             "<LastUpdateTime>%@</LastUpdateTime>\n"
                             "<CustomerID>%@</CustomerID>\n"
                             "</GetCompanyOffers>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", selCompany.companyID, @"2013-07-15T00:00:00", [Setting sharedInstance].customer.customerID];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=GetCompanyOffers"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/GetCompanyOffers" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Loading..."];
    else
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"تحميل..."];
    
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

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnSearch:(id)sender {
    self.btnback.hidden = YES;
    self.btnSearch.hidden = YES;
    self.btnShare.hidden = YES;
    self.btnCancel.hidden = NO;
    self.searchBar.hidden = NO;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        self.searchBar.placeholder = @"search in offers";
    else
        self.searchBar.placeholder = @"ابحث في العروض";
    [self.searchBar becomeFirstResponder];
}

- (IBAction)onBtnShare:(id)sender {
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

- (IBAction)onBtnAbout:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
    AboutViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"AboutView"];
    VC.selCompany = selCompany;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onExpiredOffers:(id)sender {
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [df stringFromDate:date];
    NSLog(@"date = %@", dateStr);
    [df setDateFormat:@"HH:mm:ss"];
    NSString *timeStr = [df stringFromDate:date];
    NSString *reqUpdateTimeStr = [NSString stringWithFormat:@"%@T%@", dateStr, timeStr];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetCompanyOffers xmlns=\"http://tempuri.org/\">\n"
                             "<CompanyID>%@</CompanyID>\n"
                             "<LastUpdateTime>%@</LastUpdateTime>\n"
                             "<CustomerID>%@</CustomerID>\n"
                             "</GetCompanyOffers>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", selCompany.companyID, @"2013-07-15T00:00:00", [Setting sharedInstance].customer.customerID];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=GetCompanyOffers"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/GetCompanyOffers" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Loading..."];
    else
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"تحميل..."];
    
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

- (IBAction)onBtnCancel:(id)sender {
    self.btnCancel.hidden = YES;
    [self.searchBar resignFirstResponder];
    self.searchBar.hidden = YES;
    self.btnback.hidden = NO;
    self.btnShare.hidden = NO;
    self.btnSearch.hidden = NO;
    [currentArray removeAllObjects];
    [expiredArray removeAllObjects];
    for (int i = 0; i < currentofferArray.count; i++)
        [currentArray addObject:[currentofferArray objectAtIndex:i]];
    for (int j = 0; j < expiredofferArray.count; j++)
        [expiredArray addObject:[expiredofferArray objectAtIndex:j]];
    [currentTable reloadData];
    [expireTable reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    NSString *searchText = [searchBar.text lowercaseString];
    [currentArray removeAllObjects];
    [expiredArray removeAllObjects];
    for (int i = 0; i < currentofferArray.count; i++)
    {
        OfferObject *obj = [currentofferArray objectAtIndex:i];
        NSString *titleStr;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            titleStr = [obj.offerTitleEn lowercaseString];
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            titleStr = obj.offerTitleAr;
        
        if ([titleStr rangeOfString:searchText].location != NSNotFound) {
            [currentArray addObject:obj];
        }
    }
    for (int j = 0; j < expiredofferArray.count; j++)
    {
        OfferObject *obj = [expiredofferArray objectAtIndex:j];
        NSString *titleStr;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            titleStr = [obj.offerTitleEn lowercaseString];
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            titleStr = obj.offerTitleAr;
        if ([titleStr rangeOfString:searchText].location != NSNotFound) {
            [expiredArray addObject:obj];
        }
    }
    [currentTable reloadData];
    [expireTable reloadData];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    xmlParser = Nil;
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"OfferResult"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        if (!offerObj)
            offerObj = [[OfferObject alloc]init];
        
    }
    if ([elementName isEqualToString:@"ErrMessage"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    
    if ([elementName isEqualToString:@"GetCompanyOffersResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        currentofferArray = Nil;
        expiredofferArray = Nil;
        currentofferArray = [[NSMutableArray alloc]init];
        currentArray = [[NSMutableArray alloc]init];
        expiredofferArray = [[NSMutableArray alloc]init];
        expiredArray = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"ID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"CompanyID"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"TitleAr"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"TitleEn"]){
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
    if ([elementName isEqualToString:@"Photo"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"StartDate"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"EndDate"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"IsActive"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BranchList"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"lastUpdateTime"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"TotalProducts"]){
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
bool errEncounter = FALSE;
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ErrMessage"]){
        recordResults = FALSE;
        if (![soapResults isEqualToString:@""])
            errEncounter = TRUE;
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"GetCompanyOffersResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
        if (errEncounter == TRUE)
        {
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@" لا يمكن الوصول الي بيانات الشركة من خلال السيرفر" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"The company data can't be fetched from server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self saveOfferInfo];
        [self sortOffers:currentofferArray];
        [self sortOffers:currentArray];
        [self sortOffers:expiredofferArray];
        [self sortOffers:expiredArray];
        
        [currentTable reloadData];
        [expireTable reloadData];
      //  [self showCompanyLogo];
	}
    if( [elementName isEqualToString:@"OfferResult"])
	{
		recordResults = FALSE;
        if ([offerObj.offerIsActive isEqualToString:@"true"])
        {
            
            NSString *endTimeStr = [offerObj.offerEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [df setLocale:locale];
            NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            [df setTimeZone:tz];
            NSDate *endDate = [df dateFromString:endTimeStr];
            NSDate *today = [[NSDate alloc]init];
            
            if ([today compare:endDate] == NSOrderedAscending){
                [currentofferArray addObject:offerObj];
                [currentArray addObject:offerObj];
            }
            else{
                if ([[Setting sharedInstance] checkAndDelete:endDate withOfferID:offerObj.offerID] == TRUE){
                    [expiredofferArray addObject:offerObj];
                    [expiredArray addObject:offerObj];
                }
            }
        }
        soapResults = nil;
        offerObj = nil;
	}
    if ([elementName isEqualToString:@"ID"]){
        recordResults = FALSE;
        offerObj.offerID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"CompanyID"]){
        recordResults = FALSE;
        offerObj.offerCompanyID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"TitleAr"]){
        recordResults = FALSE;
        offerObj.offerTitleAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"TitleEn"]){
        recordResults = FALSE;
        offerObj.offerTitleEn = soapResults;
        soapResults = nil;
   }
    if ([elementName isEqualToString:@"DescAr"]){
        recordResults = FALSE;
        offerObj.offerDescAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescEn"]){
        recordResults = FALSE;
        offerObj.offerDescEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Photo"]){
        recordResults = FALSE;
        offerObj.offerPhotoURL = soapResults;
        soapResults = nil;
   }
    if ([elementName isEqualToString:@"StartDate"]){
        recordResults = FALSE;
        offerObj.offerStartDate = soapResults;
        soapResults = nil;
   }
    if ([elementName isEqualToString:@"EndDate"]){
        recordResults = FALSE;
        offerObj.offerEndDate = soapResults;
        soapResults = nil;
   }
    if ([elementName isEqualToString:@"IsActive"]){
        recordResults = FALSE;
        offerObj.offerIsActive = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"BranchList"]){
        recordResults = FALSE;
        offerObj.offerBranchList = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"lastUpdateTime"]){
        recordResults = FALSE;
        offerObj.offerlastUpdateTime = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"TotalProducts"]){
        recordResults = FALSE;
        offerObj.offerProducts = soapResults;
        soapResults = nil;
    }

}
-(void)saveOfferInfo{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        NSString *delStr = @"DELETE FROM Offers";
        const char *query_stmt_del = [delStr UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt_del, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Offer init");
                
            }
            sqlite3_finalize(statement);
        }
        
        for (int i = 0; i < currentofferArray.count; i++) {
            OfferObject *obj = [currentofferArray objectAtIndex:i];
            NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO Offers (ID, CompanyID, TitleAr, TitleEn, DescAr, DescEn, Photo, StartDate, EndDate, IsActive, BranchList, lastUpdateTime, totalProducts) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", obj.offerID, obj.offerCompanyID, obj.offerTitleAr, obj.offerTitleEn, obj.offerDescAr, obj.offerDescEn, obj.offerPhotoURL, obj.offerStartDate, obj.offerEndDate, obj.offerIsActive, obj.offerBranchList, obj.offerlastUpdateTime, obj.offerProducts];
            
            const char *query_stmt1 = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Offer success");
                    
                }
                sqlite3_finalize(statement);
            }
        }
        for (int i = 0; i < expiredofferArray.count; i++) {
            OfferObject *obj = [expiredofferArray objectAtIndex:i];
            NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO Offers (ID, CompanyID, TitleAr, TitleEn, DescAr, DescEn, Photo, StartDate, EndDate, IsActive, BranchList, lastUpdateTime, totalProducts) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", obj.offerID, obj.offerCompanyID, obj.offerTitleAr, obj.offerTitleEn, obj.offerDescAr, obj.offerDescEn, obj.offerPhotoURL, obj.offerStartDate, obj.offerEndDate, obj.offerIsActive, obj.offerBranchList, obj.offerlastUpdateTime, obj.offerProducts];
            
            const char *query_stmt1 = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Offer success");
                    
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(projectDB);
    }
}
@end
