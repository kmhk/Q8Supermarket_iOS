//
//  ProductViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/16/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ProductViewController.h"
#import "FriendViewController.h"
#import "DetailViewController.h"
#import "PPRevealSideViewController.h"
#import "MBProgressHUD.h"
#import "Setting.h"
#import "CompanyViewController.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
@interface ProductViewController ()
@property (nonatomic, assign) BOOL errEncounter;
@property (nonatomic, assign) int categories;
@end

@implementation ProductViewController
@synthesize selOffer;
@synthesize arrayProduct;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize productObj;
@synthesize errEncounter;
@synthesize table_Products;
@synthesize lb_endDate;
@synthesize lb_OfferDesc;
@synthesize lb_OfferTitle;
@synthesize lb_remainDays;
@synthesize lb_startDate;
@synthesize lb_title;
@synthesize searchBar;
@synthesize offerStartDate;
@synthesize offerStopDate;
@synthesize categories;
@synthesize arrayProductsWithCategory;
@synthesize progressBar;
@synthesize progressBarBg;
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

            UINavigationController *navigationController = self.navigationController;
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
            [self.navigationController popToViewController:companyVC animated:YES];
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
    
    if (ver_float >= 7.0){
        CGRect tmpRect = self.table_Products.frame;
        tmpRect.size.height = self.view.frame.size.height - tmpRect.origin.y - 50;
        self.table_Products.frame = tmpRect;
    }

    
 }
-(void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    self.btnCancel.hidden = YES;
    [self.searchBar resignFirstResponder];
    self.searchBar.hidden = YES;
    self.btnback.hidden = NO;
    self.btnShare.hidden = NO;
    self.btnSearch.hidden = NO;
    CGRect tmpRect;
    NSLog(@"%f, %f, %f", self.lbDay.frame.origin.x, self.lbDay.frame.size.width, lb_remainDays.frame.origin.x);
    
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        lb_OfferTitle.text = selOffer.offerTitleEn;
        lb_OfferTitle.textAlignment = NSTextAlignmentLeft;
        lb_OfferDesc.text = selOffer.offerDescEn;
        lb_OfferTitle.textAlignment = NSTextAlignmentLeft;
        lb_OfferDesc.textAlignment = NSTextAlignmentLeft;
        self.searchBar.placeholder = @"Search in products";
        
        self.lbDay.text = @"days remaining";
        self.lbFrom.text = @"From:";
        self.lbTo.text = @"To:";
        
        tmpRect = self.lbFrom.frame;
        tmpRect.origin.x = 40;
        self.lbFrom.frame = tmpRect;
        
        tmpRect = self.lbTo.frame;
        tmpRect.origin.x = 169;
        self.lbTo.frame = tmpRect;
        
        tmpRect = lb_startDate.frame;
        tmpRect.origin.x = 81;
        lb_startDate.frame = tmpRect;
        
        tmpRect = lb_endDate.frame;
        tmpRect.origin.x = 194;
        lb_endDate.frame = tmpRect;
        
        tmpRect = self.lbDay.frame;
        tmpRect.origin.x = 183;
        self.lbDay.frame = tmpRect;
        
        tmpRect = lb_remainDays.frame;
        tmpRect.origin.x = 166;
        lb_remainDays.frame = tmpRect;
        
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        lb_OfferTitle.text = selOffer.offerTitleAr;
        lb_OfferDesc.text = selOffer.offerDescAr;
        lb_OfferTitle.textAlignment = NSTextAlignmentRight;
        lb_OfferDesc.textAlignment = NSTextAlignmentRight;
        self.searchBar.placeholder = @"ابحث في المنتجات";
        
        self.lbDay.text = @"لايام المتبقية";
        self.lbFrom.text = @"من :";
        self.lbTo.text = @"الي :";
        
        tmpRect = self.lbFrom.frame;
        tmpRect.origin.x = 240;
        self.lbFrom.frame = tmpRect;
        
        tmpRect = self.lbTo.frame;
        tmpRect.origin.x = 111;
        self.lbTo.frame = tmpRect;
        
        tmpRect = lb_startDate.frame;
        tmpRect.origin.x = 169;
        lb_startDate.frame = tmpRect;
        
        tmpRect = lb_endDate.frame;
        tmpRect.origin.x = 40;
        lb_endDate.frame = tmpRect;
        
        tmpRect = self.lbDay.frame;
        tmpRect.origin.x = 176;
        self.lbDay.frame = tmpRect;
        
        tmpRect = lb_remainDays.frame;
        tmpRect.origin.x = 216;
        lb_remainDays.frame = tmpRect;
    }
    lb_title.text = self.companyName;
    NSString *startTimeStr = [selOffer.offerStartDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSString *endTimeStr = [selOffer.offerEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:locale];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df setTimeZone:tz];
    offerStartDate = [df dateFromString:startTimeStr];
    [df setDateFormat:@"YYYY/MM/dd"];
    startTimeStr = [df stringFromDate:offerStartDate];
    lb_startDate.text = startTimeStr;
    
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
    [df1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df1 setLocale:locale1];
    NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df1 setTimeZone:tz1];
    offerStopDate = [df1 dateFromString:endTimeStr];
    [df1 setDateFormat:@"YYYY/MM/dd"];
    endTimeStr = [df1 stringFromDate:offerStopDate];
    lb_endDate.text = endTimeStr;
    NSDate *today = [[NSDate alloc]init];
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];
    [df2 setDateFormat:@"YYYY/MM/dd"];
    NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df2 setLocale:locale2];
    NSTimeZone *tz2 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df2 setTimeZone:tz2];
    NSString *strDay = [df2 stringFromDate:today];
    if ([today compare:offerStopDate] == NSOrderedAscending){
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        // Get conversion to months, days, hours, minutes
        unsigned int unitFlags = NSDayCalendarUnit;
        
        NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:today  toDate:offerStopDate  options:0];
        int after_days = [conversionInfo day];
        if (after_days == 0){
   /*         NSDateFormatter *df2 = [[NSDateFormatter alloc]init];
            [df2 setDateFormat:@"YYYY/MM/dd"];
            NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [df2 setLocale:locale2];
            NSTimeZone *tz2 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            [df2 setTimeZone:tz2];
            NSString *strDay = [df2 stringFromDate:today];
            if (![strDay isEqualToString:endTimeStr])*/
                after_days = 1;
        }
        
        lb_remainDays.text = [NSString stringWithFormat:@"%d", after_days];
        
        NSDateComponents *conversionInfo1 = [sysCalendar components:unitFlags fromDate:offerStartDate  toDate:offerStopDate  options:0];
        int duration_days = [conversionInfo1 day];
        if (duration_days <= after_days)
            progressBar.progress = 0;
        else
        {
            float days = (float)(duration_days - after_days) / duration_days;
            progressBar.progress = days;
        }
        
    }
    else{
        lb_remainDays.text = @"0";
        progressBar.progress = 1;
    }
    
    
    
    self.btnCancel.hidden = YES;
    self.searchBar.hidden = YES;
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
        }
    }
    [progressBar setProgressTintColor:[UIColor greenColor]];
    //   [progressBar setTrackImage:[UIImage imageNamed:@"progressbar.png"]];
    
    tmpRect = progressBar.frame;
    tmpRect.origin.y = progressBarBg.frame.origin.y + (progressBarBg.frame.size.height - tmpRect.size.height) / 2;
    [progressBar setFrame:tmpRect];
    table_Products.separatorStyle = UITableViewCellSeparatorStyleNone;
    table_Products.backgroundColor = [UIColor clearColor];

    
    NSLog(@"Product table = %f, %f, %f, %f", table_Products.frame.origin.x, table_Products.frame.origin.y, table_Products.frame.size.width, table_Products.frame.size.height);

    /*  [table_Products setBackgroundColor:[UIColor clearColor]];
     UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_back.png"]];
     [tempImageView setFrame:table_Products.frame];
     
     table_Products.backgroundView = tempImageView;*/
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
//    if (ver_float >= 7.0)
//    {
//        if (IS_IPHONE_5){
//            CGRect tmpRect = table_Products.frame;
//            tmpRect.size.height = 331;
//            [table_Products setFrame:tmpRect];
//        }
//    }
    
    [[Setting sharedInstance].myFavoriteList removeAllObjects];
    [[Setting sharedInstance].myPurchaseList removeAllObjects];
    [[Setting sharedInstance] loadFavoriteListFromLocalDB:[Setting sharedInstance].customer.customerID];
    [[Setting sharedInstance] loadPurchaseListFromLocalDB:[Setting sharedInstance].customer.customerID];
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    arrayProductsWithCategory = [[NSMutableArray alloc]init];
    BOOL flag = TRUE;
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Products where OfferID = \"%@\"", selOffer.offerID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) != SQLITE_ROW) {
                flag = FALSE;
            }
            else{
                
                arrayProduct = Nil;
                arrayProduct = [[NSMutableArray alloc]init];
                ProductObject *obj = [[ProductObject alloc]init];
                obj.prodID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                obj.OfferID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.prodCompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.prodQuantity = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                obj.prodMainCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                obj.prodMeasureID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                obj.prodSubCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                obj.prodOrgPrice = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                obj.prodCurPrice = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                obj.prodPhotoURL = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                obj.prodDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                obj.prodDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                obj.prodStartDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                obj.prodEndDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                obj.prodBranchList = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                obj.prodVisitsCount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                obj.prodTitleAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                obj.prodTitleEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                obj.prodIsActive = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                obj.prodlastUpdateTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
                
                [arrayProduct addObject:obj];
                
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    ProductObject *obj1 = [[ProductObject alloc]init];
                    obj1.prodID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    obj1.OfferID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    obj1.prodCompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    obj1.prodQuantity = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    obj1.prodMainCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    obj1.prodMeasureID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    obj1.prodSubCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    obj1.prodOrgPrice = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                    obj1.prodCurPrice = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                    obj1.prodPhotoURL = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                    obj1.prodDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                    obj1.prodDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                    obj1.prodStartDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                    obj1.prodEndDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                    obj1.prodBranchList = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                    obj1.prodVisitsCount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                    obj1.prodTitleAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                    obj1.prodTitleEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                    obj1.prodIsActive = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                    obj1.prodlastUpdateTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
                    [arrayProduct addObject:obj1];
                    
                    
                    
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(projectDB);
        if (flag == TRUE) {
            [self sortArrayProduct:arrayProduct];
            [table_Products reloadData];
        }
    }
    if (flag == FALSE){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<GetOfferProducts xmlns=\"http://tempuri.org/\">\n"
                                 "<OfferID>%@</OfferID>\n"
                                 "<LastUpdateTime>%@</LastUpdateTime>\n"
                                 "<CustomerID>%@</CustomerID>\n"
                                 "</GetOfferProducts>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", selOffer.offerID, @"2013-07-15T00:00:00", [Setting sharedInstance].customer.customerID];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=GetOfferProducts"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/GetOfferProducts" forHTTPHeaderField:@"SOAPAction"];
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

    [table_Products reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnSearch:(id)sender {
    self.btnback.hidden = YES;
    self.btnSearch.hidden = YES;
    self.btnShare.hidden = YES;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_nav_cancel.png"] forState:UIControlStateNormal];
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_nav_cancel.png"] forState:UIControlStateHighlighted];
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_nav_cancel.png"] forState:UIControlStateSelected];

    }
    else{
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"arab_nav_cancel.png"] forState:UIControlStateNormal];
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"arab_nav_cancel.png"] forState:UIControlStateHighlighted];
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"arab_nav_cancel.png"] forState:UIControlStateSelected];    

    }
    self.btnCancel.hidden = NO;
    self.searchBar.hidden = NO;
    self.searchBar.text = @"";
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
- (IBAction)onBtnCancel:(id)sender {
    self.btnCancel.hidden = YES;
    [self.searchBar resignFirstResponder];
    self.searchBar.hidden = YES;
    self.btnback.hidden = NO;
    self.btnShare.hidden = NO;
    self.btnSearch.hidden = NO;
    [arrayProductsWithCategory removeAllObjects];
    [self sortArrayProduct:arrayProduct];
    [table_Products reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    NSString *searchText = [self.searchBar.text lowercaseString];
    [arrayProductsWithCategory removeAllObjects];
    NSMutableArray *arraySearchResult = [[NSMutableArray alloc]init];
    for (int i = 0; i < arrayProduct.count; i++)
    {
        ProductObject *obj = [arrayProduct objectAtIndex:i];
        NSString *titleStr;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            titleStr = [obj.prodTitleEn lowercaseString];
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            titleStr = obj.prodTitleAr;
        
        if ([titleStr rangeOfString:searchText].location != NSNotFound) {
            [arraySearchResult addObject:obj];
        }
    }
    [self sortArrayProduct:arraySearchResult];
    [table_Products reloadData];
}

- (IBAction)onBtnFavorite:(id)sender {
    if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        NSIndexPath *indexPath;
        NSString *ver = [[UIDevice currentDevice] systemVersion];
        float ver_float = [ver floatValue];
        if (ver_float < 7.0)
            indexPath = [table_Products indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
        else
            indexPath = [table_Products indexPathForCell:(UITableViewCell *)[[[sender superview]superview]superview]];
        
        ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
        if (catObj.isCategory == FALSE){
            if ([catObj.obj.prodFavoriteProducts isEqualToString:@""]){
                catObj.obj.prodFavoriteProducts = @"true";
                NSDate *addDate = [[NSDate alloc]init];
                NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
                [df1 setDateFormat:@"dd/MM/yyyy"];
                NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                [df1 setLocale:locale1];
                NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                [df1 setTimeZone:tz1];
                catObj.obj.prodAddDate = [df1 stringFromDate:addDate];
                [[Setting sharedInstance].myFavoriteList addObject:catObj.obj];
                [[Setting sharedInstance] addFavoriteProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID withDate:catObj.obj.prodAddDate withCompany:catObj.obj.prodCompanyID withOffer:catObj.obj.OfferID];
                NSLog(@"prodCompanyID = %@", catObj.obj.prodCompanyID);
                [[Setting sharedInstance] sendFavoriteRequest:catObj.obj];
            }
            else{
                catObj.obj.prodFavoriteProducts = @"";
                catObj.obj.prodAddDate = @"";
                for (int i = 0; i < [Setting sharedInstance].myFavoriteList.count; i++){
                    ProductObject *obj = [[Setting sharedInstance].myFavoriteList objectAtIndex:i];
                    if ([obj.prodID isEqualToString:catObj.obj.prodID])
                    {
                        [[Setting sharedInstance].myFavoriteList removeObjectAtIndex:i];
                        [[Setting sharedInstance] removeFavoriteProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID];
                        break;
                    }
                }
            }
        }

        [table_Products reloadData];
    }
    else{
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add/remove favorite product." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }
        else
        {
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء تسجيل الدخول لإضافة/حذف المفضله" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
    }
}

- (IBAction)onBtnPurchase:(id)sender {
    if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        NSIndexPath *indexPath;
        NSString *ver = [[UIDevice currentDevice] systemVersion];
        float ver_float = [ver floatValue];
        if (ver_float < 7.0)
            indexPath = [table_Products indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
        else
            indexPath = [table_Products indexPathForCell:(UITableViewCell *)[[[sender superview]superview]superview]];
        ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
        
        if (catObj.isCategory == FALSE){
            if ([catObj.obj.prodPurchasedProducts isEqualToString:@""]){
                catObj.obj.prodPurchasedProducts = @"true";
                NSDate *addDate = [[NSDate alloc]init];
                NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
                [df1 setDateFormat:@"dd/MM/yyyy"];
                NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                [df1 setLocale:locale1];
                NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                [df1 setTimeZone:tz1];
                catObj.obj.prodAddPurchaseDate = [df1 stringFromDate:addDate];
                [[Setting sharedInstance].myPurchaseList addObject:catObj.obj];
                [[Setting sharedInstance] addPurchaseProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID withDate:catObj.obj.prodAddPurchaseDate withCompany:catObj.obj.prodCompanyID withOffer:catObj.obj.OfferID];
                [[Setting sharedInstance] sendPurchaseRequest:catObj.obj];
            }
            else{
                catObj.obj.prodPurchasedProducts = @"";
                catObj.obj.prodAddPurchaseDate = @"";
                for (int i = 0; i < [Setting sharedInstance].myPurchaseList.count; i++){
                    ProductObject *obj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
                    if ([obj.prodID isEqualToString:catObj.obj.prodID])
                    {
                        [[Setting sharedInstance].myPurchaseList removeObjectAtIndex:i];
                        [[Setting sharedInstance] removePurchaseProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID];
                        break;
                    }
                }
            }
        }

        [table_Products reloadData];
    }
    else{
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add/remove purchase product." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }
        else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء تسجيل الدخول لإضافة/حذف المشتريات" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
    if (catObj.isCategory == FALSE){
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
        DetailViewController *vc = [mainstoryboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
        vc.ProductList = arrayProductsWithCategory;
        vc.indexRow = indexPath.row;
        vc.viewIndex = 1;
        [self presentViewController:vc animated:YES completion:Nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
    if (catObj.isCategory == TRUE)
        return 45;
    else
        return 105;
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;

    ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
    if (catObj.isCategory == TRUE)
    {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"MainCategoryCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCategoryCell"];
        UILabel *lb_mainCat = (UILabel*)[cell viewWithTag:201];
        NSString *mainCatName = [[Setting sharedInstance] getMainCategoryName:catObj.mainID];
        lb_mainCat.text = mainCatName;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            lb_mainCat.textAlignment = NSTextAlignmentLeft;
        else
            lb_mainCat.textAlignment = NSTextAlignmentRight;
    }
    else {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductCell"];
        ProductObject *obj = catObj.obj;
    if (![obj.prodPhotoURL isEqualToString:@""]){
        AsyncImageView *img_product = (AsyncImageView*)[cell viewWithTag:111];
        [img_product setImageURL:[NSURL URLWithString:obj.prodPhotoURL]];
    }
        UIView *badge_view = (UIView*)[cell viewWithTag:119];
        if ([obj.prodOrgPrice isEqualToString:@""]) {
            badge_view.hidden = YES;
        }
        else{
            badge_view.hidden = NO;
            
        }
        UILabel *lb_percent = (UILabel*)[cell viewWithTag:112];
        UILabel *lb_prod_title = (UILabel*)[cell viewWithTag:113];
        UILabel *lb_date = (UILabel*)[cell viewWithTag:114];
        
        NSString *pro = @"%";
        int percents = (int)(([obj.prodOrgPrice floatValue] - [obj.prodCurPrice floatValue]) / [obj.prodOrgPrice floatValue] * 100);
        lb_percent.text = [pro stringByAppendingString:[NSString stringWithFormat:@"%d", percents]];
    
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        lb_prod_title.text = obj.prodTitleEn;
        lb_prod_title.textAlignment = NSTextAlignmentLeft;
        lb_date.textAlignment = NSTextAlignmentLeft;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        lb_prod_title.text = obj.prodTitleAr;
        lb_prod_title.textAlignment = NSTextAlignmentRight;
        lb_date.textAlignment = NSTextAlignmentRight;
    }
    
    
    NSString *startTimeStr = [obj.prodStartDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSString *endTimeStr = [obj.prodEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:locale];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df setTimeZone:tz];
    NSDate *prodStartDate = [df dateFromString:startTimeStr];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            [df setDateFormat:@"MMM dd"];
            startTimeStr = [df stringFromDate:prodStartDate];
        }
        else{
            [df setDateFormat:@"MM/dd"];
            startTimeStr = [df stringFromDate:prodStartDate];
        }
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
    [df1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df1 setLocale:locale1];
    NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df1 setTimeZone:tz1];
    NSDate *prodEndDate = [df1 dateFromString:endTimeStr];
        
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        {
            [df1 setDateFormat:@"MMM dd"];
            endTimeStr = [df1 stringFromDate:prodEndDate];
            lb_date.text = [NSString stringWithFormat:@"From %@ To %@, or until stocks", startTimeStr, endTimeStr];
        }
        else{
            [df1 setDateFormat:@"MM/dd"];
            endTimeStr = [df1 stringFromDate:prodEndDate];

            lb_date.text = [NSString stringWithFormat:@"من %@ الي %@, أو حتي نفاد الكمية", startTimeStr, endTimeStr];
        }
        

    if (![obj.prodCurPrice isEqualToString:@""]){
        UILabel *lb_price = (UILabel*)[cell viewWithTag:115];
        lb_price.text = [NSString stringWithFormat:@"%@ KD", obj.prodCurPrice];
    }
    UIImageView *imgLine = (UIImageView*)[cell viewWithTag:120];
    imgLine.hidden = YES;
    UILabel *lb_orgPrice = (UILabel*)[cell viewWithTag:116];
    lb_orgPrice.hidden = YES;
    if (![obj.prodOrgPrice isEqualToString:@""]){
        lb_orgPrice.text = [NSString stringWithFormat:@"%@ KD", obj.prodOrgPrice];
        imgLine.hidden = NO;
        lb_orgPrice.hidden = NO;
    }
    
    UIButton *btnFavor = (UIButton*)[cell viewWithTag:117];
        NSString *imageStr;
        if ([obj.prodFavoriteProducts isEqualToString:@""]){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            imageStr = @"arab_unsel_favorite.png";
            else
            imageStr = @"btn_unsel_favorite.png";
        }
        else{
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            imageStr = @"arab_sel_favorite.png";
            else
            imageStr = @"btn_sel_favorite.png";
        }
        [btnFavor setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [btnFavor setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
        [btnFavor setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
        
        
    UIButton *btnPurchase = (UIButton*)[cell viewWithTag:118];

        NSDate *today = [[NSDate alloc]init];
        if ([today compare:prodEndDate] != NSOrderedAscending){
            btnPurchase.userInteractionEnabled = NO;
            btnPurchase.alpha = 0.5;
        }
        else{
            btnPurchase.userInteractionEnabled = YES;
            btnPurchase.alpha = 1;
        }
        NSLog(@"%@, %@", today, prodEndDate);
        if ([obj.prodPurchasedProducts isEqualToString:@""]){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            imageStr = @"arab_unsel_purchase.png";
            else
            imageStr = @"btn_unsel_purchase.png";
        }
        else{
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            imageStr = @"arab_sel_purchase.png";
            else
            imageStr = @"btn_sel_purchase.png";
        }
        [btnPurchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [btnPurchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
        [btnPurchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrayProductsWithCategory.count;
    
}

-(void)sortArrayProduct:(NSMutableArray*)_arrayProduct{
    
    if (_arrayProduct.count > 1){
        for (int i = 0; i < _arrayProduct.count - 1; i++){
            ProductObject *tmpObj = [_arrayProduct objectAtIndex:i];
            ProductObject *firstObj = [_arrayProduct objectAtIndex:i];
            int index = i;
            for (int j = i + 1; j < _arrayProduct.count; j++){
                ProductObject *secondObj = [_arrayProduct objectAtIndex:j];
                NSString *sortNum1 = [[Setting sharedInstance] getSortNum:tmpObj.prodMainCatID withType:@"main"];
                NSString *sortNum2 = [[Setting sharedInstance] getSortNum:secondObj.prodMainCatID withType:@"main"];
                if ([sortNum1 intValue] >= [sortNum2 intValue]) {
                    if ([sortNum1 intValue] > [sortNum2 intValue]){
                        tmpObj = secondObj;
                        index = j;
                    }
                    else {
                            sortNum1 = [[Setting sharedInstance] getSortNum:tmpObj.prodSubCatID withType:@"sub"];
                            sortNum2 = [[Setting sharedInstance] getSortNum:secondObj.prodSubCatID withType:@"sub"];
                        
                            if (sortNum1 > sortNum2)
                            {
                                tmpObj = secondObj;
                                index = j;
                            }
                    }
                }
            }
            
            [_arrayProduct replaceObjectAtIndex:i withObject:tmpObj];
            [_arrayProduct replaceObjectAtIndex:index withObject:firstObj];
            
        }
    }
    int mainCategory = -1;
    for (int i = 0; i < _arrayProduct.count; i++){
        ProductObject *obj = [_arrayProduct objectAtIndex:i];
        ProductsWithCategory *catObj = [[ProductsWithCategory alloc]init];
        if ([[Setting sharedInstance] isFavoriteExist:obj.prodID] == FALSE)
        {
            obj.prodFavoriteProducts = @"";
        }
        else{
            obj.prodFavoriteProducts = @"true";
        }
        if ([[Setting sharedInstance] isPurchaseExist:obj.prodID] == FALSE)
        {
            obj.prodPurchasedProducts = @"";
        }
        else{
            obj.prodPurchasedProducts = @"true";
        }
        
        if (mainCategory != [obj.prodMainCatID intValue])
        {
            catObj.isCategory = TRUE;
            catObj.obj = Nil;
            catObj.mainID = obj.prodMainCatID;
            catObj.subID = obj.prodSubCatID;
            [arrayProductsWithCategory addObject:catObj];
            ProductsWithCategory *conObj = [[ProductsWithCategory alloc]init];
            conObj.isCategory = FALSE;
            conObj.obj = obj;
            [arrayProductsWithCategory addObject:conObj];
        }
        else
        {
            catObj.isCategory = FALSE;
            catObj.obj = obj;
            [arrayProductsWithCategory addObject:catObj];
        }
        mainCategory = [obj.prodMainCatID intValue];
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
	
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"ProductResult"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        if (!productObj)
            productObj = [[ProductObject alloc]init];
        
    }
    if ([elementName isEqualToString:@"ErrMessage"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    
    if ([elementName isEqualToString:@"GetOfferProductsResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        arrayProduct = Nil;
        arrayProduct = [[NSMutableArray alloc]init];
        
    }
    
    if ([elementName isEqualToString:@"ID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OfferID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Quantity"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"MainCatID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"MeasureID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"SubCatID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OrgPrice"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Price"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Photo"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"StartDate"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"EndDate"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BranchList"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"VisitsCount"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"TitleAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"TitleEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"IsActive"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"lastUpdateTime"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"FavoriteProducts"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"HomeOrderProducts"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"PurchasedProducts"])
    {
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
        if (![soapResults isEqualToString:@""])
            errEncounter = TRUE;
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"GetOfferProductsResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
        if (errEncounter == TRUE)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"The product data can't be fetched from server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
                [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"فشل السيرفر في الوصول الي بيانات المنتج" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self saveProductsInfo];
        [self sortArrayProduct:arrayProduct];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [table_Products reloadData];
	}
    if( [elementName isEqualToString:@"ProductResult"])
	{
		recordResults = FALSE;
        productObj.prodCompanyID = self.selOffer.offerCompanyID;
        [arrayProduct addObject:productObj];
        soapResults = nil;
        productObj = nil;
	}
    if ([elementName isEqualToString:@"ID"]){
        recordResults = FALSE;
        productObj.prodID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OfferID"])
    {
        recordResults = FALSE;
        productObj.OfferID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Quantity"])
    {
        recordResults = FALSE;
        productObj.prodQuantity = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"MainCatID"])
    {
        recordResults = FALSE;
        productObj.prodMainCatID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"MeasureID"])
    {
        recordResults = FALSE;
        productObj.prodMeasureID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"SubCatID"])
    {
        recordResults = FALSE;
        productObj.prodSubCatID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OrgPrice"])
    {
        recordResults = FALSE;
        productObj.prodOrgPrice = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Price"])
    {
        recordResults = FALSE;
        productObj.prodCurPrice = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Photo"])
    {
        recordResults = FALSE;
        productObj.prodPhotoURL = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescAr"])
    {
        recordResults = FALSE;
        productObj.prodDescAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescEn"])
    {
        recordResults = FALSE;
        productObj.prodDescEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"StartDate"])
    {
        recordResults = FALSE;
        productObj.prodStartDate = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"EndDate"])
    {
        recordResults = FALSE;
        productObj.prodEndDate = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"BranchList"])
    {
        recordResults = FALSE;
        productObj.prodBranchList = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"VisitsCount"])
    {
        recordResults = FALSE;
        productObj.prodVisitsCount = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"TitleAr"])
    {
        recordResults = FALSE;
        productObj.prodTitleAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"TitleEn"])
    {
        recordResults = FALSE;
        productObj.prodTitleEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"IsActive"])
    {
        recordResults = FALSE;
        productObj.prodIsActive = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"lastUpdateTime"])
    {
        recordResults = FALSE;
        productObj.prodlastUpdateTime = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FavoriteProducts"])
    {
        recordResults = FALSE;
        productObj.prodFavoriteProducts = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"HomeOrderProducts"])
    {
        recordResults = FALSE;
        productObj.prodHomeOrderProducts = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"PurchasedProducts"])
    {
        recordResults = FALSE;
        productObj.prodPurchasedProducts = soapResults;
        soapResults = nil;
    }
}
-(void)saveProductsInfo{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        for (int i = 0; i < arrayProduct.count; i++) {
            ProductObject *obj = [arrayProduct objectAtIndex:i];
            NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO Products (ID, OfferID, CompanyID, Quantity, MainCatID, MeasureID, SubCatID, OrgPrice, Price, Photo, DescAr, DescEn, StartDate, EndDate, BranchList, VisitsCount, TitleAr, TitleEn, IsActive, lastUpdateTime) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", obj.prodID, obj.OfferID, obj.prodCompanyID, obj.prodQuantity, obj.prodMainCatID, obj.prodMeasureID, obj.prodSubCatID, obj.prodOrgPrice, obj.prodCurPrice, obj.prodPhotoURL, obj.prodDescAr, obj.prodDescEn, obj.prodStartDate, obj.prodEndDate, obj.prodBranchList, obj.prodVisitsCount, obj.prodTitleAr, obj.prodTitleEn, obj.prodIsActive, obj.prodlastUpdateTime];
            
            const char *query_stmt1 = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Products success");
                    
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(projectDB);
    }
}
- (IBAction)onBtnShareIcon:(id)sender {
    NSMutableArray *arrayShareContent = [[NSMutableArray alloc]init];
    [arrayShareContent addObject:[NSString stringWithFormat:@"Company Name : %@\n", lb_title.text]];
    
    [arrayShareContent addObject:[NSString stringWithFormat:@"Offer Name : %@\n", lb_OfferTitle.text]];

    [arrayShareContent addObject:[NSString stringWithFormat:@"Offer Description : %@\n", lb_OfferDesc.text]];
    
    [arrayShareContent addObject:[NSString stringWithFormat:@"Start date : %@\n", lb_startDate.text]];
    
    [arrayShareContent addObject:[NSString stringWithFormat:@"End date : %@\n", lb_endDate.text]];
    
    for (int i = 0; i < arrayProduct.count; i++){
        ProductObject *obj = [arrayProduct objectAtIndex:i];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            [arrayShareContent addObject:[NSString stringWithFormat:@"\nProduct Name : %@\n", obj.prodTitleEn]];
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            [arrayShareContent addObject:[NSString stringWithFormat:@"Product Name : %@\n", obj.prodTitleAr]];
        }
        
        if (![obj.prodPhotoURL isEqualToString:@""]){
            [arrayShareContent addObject:[NSString stringWithFormat:@"Product Image : %@\n", obj.prodPhotoURL]];

        }
        if (![obj.prodOrgPrice isEqualToString:@""]) {
            [arrayShareContent addObject:[NSString stringWithFormat:@"Product Original Price : %@ KD\n", obj.prodOrgPrice]];
        }
        
        if (![obj.prodCurPrice isEqualToString:@""]){
            [arrayShareContent addObject:[NSString stringWithFormat:@"Product Current Price : %@ KD\n\n", obj.prodCurPrice]];
        }
        
    }
    self.activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact ];
    self.activityViewController = [[UIActivityViewController alloc]
                                   
                                   initWithActivityItems:arrayShareContent applicationActivities:nil];
    
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}
@end
