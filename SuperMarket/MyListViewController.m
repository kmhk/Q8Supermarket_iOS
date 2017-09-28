//
//  MyListViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "MyListViewController.h"
#import "NewListViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "ListTableItem.h"
#import "MBProgressHUD.h"
#import "CompanyViewController.h"
#import "AcceptRequestViewController.h"
#import "AppDelegate.h"
@interface MyListViewController ()

@end

@implementation MyListViewController
@synthesize arrayForTable;
@synthesize arrayItem;
@synthesize arrayList;
@synthesize myListTable;
@synthesize listStatus;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize errEncounter;
@synthesize myItem;
@synthesize listObj;
@synthesize listIndex;
@synthesize removeIndex;
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
                [self viewWillAppear:NO];
            }
        }
    }
    
    NSLog(@"%d", removeIndex);
    if(buttonIndex == 1)
    {
        if (removeIndex != -1){
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            ListTableItem *item = [arrayForTable objectAtIndex:removeIndex];
            for (int i = removeIndex; i < arrayForTable.count; i++) {
                ListTableItem *item1 = [arrayForTable objectAtIndex:i];
                if ([item1.listID isEqualToString:item.listID]){
                    [subArray addObject:item1];
                }
                else
                    break;
            }
            for (int j = 0; j < arrayList.count; j++)
            {
                MyListObject *obj = [arrayList objectAtIndex:j];
                if ([obj.listID isEqualToString:item.listID]){
                    [arrayList removeObjectAtIndex:j];
                    break;
                }
            }
            sqlite3_stmt    *statement;
            
            
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
            {
                
                NSString *querySQL;
                if (listStatus == FALSE)
                    querySQL = [NSString stringWithFormat: @"DELETE FROM MyList WHERE ID = \"%@\"", item.listID];
                else
                    querySQL = [NSString stringWithFormat: @"DELETE FROM ReceivedMyList WHERE ListID = \"%@\"", item.listID];
                
                const char *query_stmt = [querySQL UTF8String];
                
                if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"mylist remove success");
                        
                    }
                    sqlite3_finalize(statement);
                }
                if (listStatus == FALSE)
                    querySQL = [NSString stringWithFormat: @"DELETE FROM MyListItems WHERE ListID = \"%@\"", item.listID];
                else
                    querySQL = [NSString stringWithFormat: @"DELETE FROM ReceivedMyListItems WHERE ListID = \"%@\"", item.listID];
                query_stmt = [querySQL UTF8String];
                
                if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"mylistitems remove success");
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                sqlite3_close(projectDB);
            }
            if (subArray.count > 0)
            {    [arrayForTable removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(removeIndex, subArray.count)]];
                
            }
            /*    if (listStatus == true){
             UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Information"
             message:@"The list is removed from your InBox lists" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [mes show];
             }
             else{
             UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Information"
             message:@"The list is removed from your Sent lists" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [mes show];
             }*/
            [myListTable reloadData];
        }
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [Setting sharedInstance].isListSearch = FALSE;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didPush)
                                                 name:@"PushDid"
                                               object:nil];
	// Do any additional setup after loading the view.
    NSString *docsDir;
    NSArray *dirPaths;
    listStatus = TRUE;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    arrayList = [[NSMutableArray alloc]init];
    arrayForTable = [[NSMutableArray alloc]init];
    arrayItem = [[NSMutableArray alloc]init];
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        self.lb_header.text = @"My List";
        [self.lb_inbox setTitle:@"Inbox" forState:UIControlStateNormal];
        [self.lb_sent setTitle:@"Sent" forState:UIControlStateNormal];
        
    }
    else{
        self.lb_header.text = @"طلبات البيت";
        [self.lb_inbox setTitle:@"صندوق الوارد" forState:UIControlStateNormal];
        [self.lb_sent setTitle:@"المرسل" forState:UIControlStateNormal];
        
    }
//    if (ver_float >= 7.0){
//        if (IS_IPHONE_5){
//        [myListTable setFrame:CGRectMake(20, 114, 280, 399)];
//        }
//    }
    removeIndex = -1;
    
    if (ver_float >= 7.0){
        CGRect tmpRect = self.myListTable.frame;
        tmpRect.size.height = self.view.frame.size.height - tmpRect.origin.y - 50;
        self.myListTable.frame = tmpRect;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    if ([Setting sharedInstance].pushInfo != Nil){
        listStatus = TRUE;
        
        [Setting sharedInstance].pushInfo = nil;
    }
     CGRect tmpRect;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        tmpRect = self.lb_inbox.frame;
        tmpRect.origin.x = 20;
        self.lb_inbox.frame = tmpRect;
        tmpRect = self.lb_sent.frame;
        tmpRect.origin.x = 172;
        self.lb_sent.frame = tmpRect;
    }else {
        tmpRect = self.lb_inbox.frame;
        tmpRect.origin.x = 172;
        self.lb_inbox.frame = tmpRect;
        tmpRect = self.lb_sent.frame;
        tmpRect.origin.x = 20;
        self.lb_sent.frame = tmpRect;
    }
    if (listStatus == TRUE){
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            self.backImg.image = [UIImage imageNamed:@"favorite_tab_bg.png"];
        else
            self.backImg.image = [UIImage imageNamed:@"favorite_tab1_bg.png"];
    }
    else{
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            self.backImg.image = [UIImage imageNamed:@"favorite_tab1_bg.png"];
        else
            self.backImg.image = [UIImage imageNamed:@"favorite_tab_bg.png"];
    }
    if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        if (listStatus == FALSE) {
            [self onBtnSent:NULL];
            return;
        }
    listIndex = 0;
    [arrayList removeAllObjects];
        
        NSLog(@"mylist table = %f, %f, %f, %f", myListTable.frame.origin.x, myListTable.frame.origin.y, myListTable.frame.size.width, myListTable.frame.size.height);
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ReceivedMyList WHERE CustomerID = \"%@\"", [Setting sharedInstance].customer.customerID];
        const char *query_stmt = [querySQL UTF8String];

        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                MyListObject *obj = [[MyListObject alloc]init];
                obj.listID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.listTitle = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.orderDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                obj.customerID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                obj.senderName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *queryString = [NSString stringWithFormat: @"SELECT * FROM ReceivedMyListItems WHERE ListID = %@ ORDER BY MainCatID", obj.listID];
                const char *query_stmt1 = [queryString UTF8String];
                sqlite3_stmt    *statement1;
                
                if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement1, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement1) == SQLITE_ROW)
                    {
                        MyListItem *objItem = [[MyListItem alloc]init];
                        objItem.itemID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 2)];
                        objItem.itemSubID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 3)];
                        objItem.measureUnit = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 4)];
                        objItem.measureQuantity = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 5)];
                        objItem.isDone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 6)];
                        objItem.itemName = [[Setting sharedInstance] getSubCategoryName:objItem.itemSubID];
                        [obj.items addObject:objItem];
                    }
                    sqlite3_finalize(statement1);
                }
                
                
                [arrayList addObject:obj];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(projectDB);
    }
        [self sortDone];
    NSString *receivedDate;
    receivedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastReceivedDate"];
    if (receivedDate == Nil){
/*      NSDate *addDate = [[NSDate alloc]init];
        NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
        [df1 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [df1 setLocale:locale1];
        NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [df1 setTimeZone:tz1];
        receivedDate = [df1 stringFromDate:addDate];
        receivedDate = [receivedDate stringByReplacingOccurrencesOfString:@" " withString:@"T"];*/
        receivedDate = @"2013-01-01T00:00:00";
    }
        NSLog(@"%f, %f", self.lb_inbox.frame.origin.x, self.lb_sent.frame.origin.x);
       
        
        
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<MyListGetInbox xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%d</CustomerID>\n"
                             "<LastReceiveDate>%@</LastReceiveDate>\n"
                             "</MyListGetInbox>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], receivedDate];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MyListGetInbox"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/MyListGetInbox" forHTTPHeaderField:@"SOAPAction"];
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
    
    [self.navigationController popViewControllerAnimated:YES];
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
//	[MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
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
    if ([elementName isEqualToString:@"MyListGetInboxResponse"]){
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
        [arrayItem removeAllObjects];
    }
    if ([elementName isEqualToString:@"MyInboxResult"]){
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
        listObj = [[MyListObject alloc]init];
        
    }
    if ([elementName isEqualToString:@"ListID"]){
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    
    if ([elementName isEqualToString:@"SenderID"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    
    if ([elementName isEqualToString:@"ListTitle"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    
    if ([elementName isEqualToString:@"SenderName"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    
    if ([elementName isEqualToString:@"MsgDate"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ListItems"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
        listObj.items = [[NSMutableArray alloc]init];
    }
    if ([elementName isEqualToString:@"MyListWebItem"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
        myItem = [[MyListItem alloc]init];
    }
    if ([elementName isEqualToString:@"MainCategoryID"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"SubCategoryID"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"MeasureUnitID"])
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
            [Setting sharedInstance].errString = soapResults;
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:[Setting sharedInstance].errString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
        }
        
        soapResults = nil;
   
    }

    if ([elementName isEqualToString:@"ListID"])
    {
        recordResults = FALSE;
        listObj.listID = soapResults;
        soapResults = Nil;
    }
    
    if ([elementName isEqualToString:@"SenderID"])
    {
        recordResults = FALSE;
        listObj.customerID = soapResults;
        soapResults = Nil;
    }
    
    if ([elementName isEqualToString:@"ListTitle"])
    {
        recordResults = FALSE;
        listObj.listTitle = soapResults;
        soapResults = Nil;
    }
    
    if ([elementName isEqualToString:@"SenderName"])
    {
        recordResults = FALSE;
        listObj.senderName = soapResults;
        soapResults = Nil;
    }
    
    if ([elementName isEqualToString:@"MsgDate"])
    {
        recordResults = FALSE;
        listObj.orderDate = soapResults;
        soapResults = Nil;
    }
    
    if ([elementName isEqualToString:@"MyInboxResult"]){
        recordResults = FALSE;
        soapResults = Nil;
        [arrayItem addObject:listObj];
    }
    
    if ([elementName isEqualToString:@"ListItems"]){
        
        recordResults = FALSE;
        
        soapResults = Nil;
        if ([self compareLocalDB:listObj.listID] == FALSE){
            [arrayItem replaceObjectAtIndex:listIndex withObject:listObj];
            [arrayList addObject:listObj];
        }
        listIndex++;
        if (listIndex < arrayItem.count){
            listObj = [arrayItem objectAtIndex:listIndex];
            NSString *mylang;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                mylang = @"1";
            else
                mylang = @"2";
            
            NSString *soapMessage = [NSString stringWithFormat:
                                     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                     "<soap:Body>\n"
                                     "<MyListGetReceivedList xmlns=\"http://tempuri.org/\">\n"
                                     "<ListID>%d</ListID>\n"
                                     "<Language>%d</Language>\n"
                                     "</MyListGetReceivedList>\n"
                                     "</soap:Body>\n"
                                     "</soap:Envelope>\n", [listObj.listID intValue], [mylang intValue]];
            NSLog(@"soapMessage = %@\n", soapMessage);
            
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MyListGetReceivedList"];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/MyListGetReceivedList" forHTTPHeaderField:@"SOAPAction"];
            [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
            //       [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Waiting..."];
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
            [arrayForTable removeAllObjects];
            listIndex = 0;
            for (int i = 0; i < arrayList.count; i++) {
                MyListObject *obj = [arrayList objectAtIndex:i];
                ListTableItem *item = [[ListTableItem alloc]init];
                item.itemName = obj.listTitle;
                item.orderDate = obj.orderDate;
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    item.receiversName = [NSString stringWithFormat:@"From : %@", obj.senderName];
                else
                    item.receiversName = [NSString stringWithFormat:@"من : %@", obj.senderName];
                item.items = @"";
                for (int j = 0; j < obj.items.count; j++){
                    MyListItem *objItem = [obj.items objectAtIndex:j];
                    NSString *itemName = [[Setting sharedInstance] getSubCategoryName:objItem.itemSubID];
                    item.items = [item.items stringByAppendingString:[NSString stringWithFormat:@"%@, ", itemName]];
                }
                if (item.items.length > 0) {
                    item.items = [item.items substringToIndex:item.items.length - 2];
                }
                NSLog(@"items = %@", item.items);
                item.isList = 1;
                item.isOpened = FALSE;
                item.isSelected = FALSE;
                item.listID = obj.listID;
                [arrayForTable addObject:item];
            }
            [self saveInBox];
            [myListTable reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }
    
    if ([elementName isEqualToString:@"MyListWebItem"])
    {
        recordResults = FALSE;
        soapResults = Nil;
        myItem.isDone = @"0";
        [listObj.items addObject:myItem];
    }
    if ([elementName isEqualToString:@"MainCategoryID"])
    {
        recordResults = FALSE;
        myItem.itemID = soapResults;
        soapResults = Nil;
    }
    if ([elementName isEqualToString:@"SubCategoryID"])
    {
        recordResults = FALSE;
        myItem.itemSubID = soapResults;
        soapResults = Nil;
    }
    if ([elementName isEqualToString:@"MeasureUnitID"])
    {
        recordResults = FALSE;
        myItem.measureUnit = soapResults;
        soapResults = Nil;
    }
    if ([elementName isEqualToString:@"Quantity"])
    {
        recordResults = FALSE;
        myItem.measureQuantity = soapResults;
        soapResults = Nil;
    }
    
    if ([elementName isEqualToString:@"MyListGetInboxResponse"]){
        recordResults = FALSE;
        soapResults = Nil;
        if ([self compareLocalDB:listObj.listID] == FALSE) {
            
        NSDate *addDate = [[NSDate alloc]init];
        NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
        [df1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [df1 setLocale:locale1];
        NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [df1 setTimeZone:tz1];
        NSString *receivedDate = [df1 stringFromDate:addDate];
        receivedDate = [receivedDate stringByReplacingOccurrencesOfString:@" " withString:@"T"];
        [[NSUserDefaults standardUserDefaults] setObject:receivedDate forKey:@"LastReceivedDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (arrayItem.count > 0){
            listObj = [arrayItem objectAtIndex:0];
            NSString *mylang;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                mylang = @"1";
            else
                mylang = @"2";
        
            NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<MyListGetReceivedList xmlns=\"http://tempuri.org/\">\n"
                                 "<ListID>%d</ListID>\n"
                                 "<Language>%d</Language>\n"
                                 "</MyListGetReceivedList>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [listObj.listID intValue], [mylang intValue]];
            NSLog(@"soapMessage = %@\n", soapMessage);
        
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MyListGetReceivedList"];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/MyListGetReceivedList" forHTTPHeaderField:@"SOAPAction"];
            [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
 //       [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Waiting..."];
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
            [arrayForTable removeAllObjects];
            listIndex = 0;
            for (int i = 0; i < arrayList.count; i++) {
                MyListObject *obj = [arrayList objectAtIndex:i];
                ListTableItem *item = [[ListTableItem alloc]init];
                item.itemName = obj.listTitle;
                item.orderDate = obj.orderDate;
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    item.receiversName = [NSString stringWithFormat:@"From : %@", obj.senderName];
                else
                    item.receiversName = [NSString stringWithFormat:@"من : %@", obj.senderName];
                
                item.items = @"";
                for (int j = 0; j < obj.items.count; j++){
                    MyListItem *objItem = [obj.items objectAtIndex:j];
                    NSString *itemName = [[Setting sharedInstance] getSubCategoryName:objItem.itemSubID];
                    item.items = [item.items stringByAppendingString:[NSString stringWithFormat:@"%@, ", itemName]];
                }
                if (item.items.length > 0) {
                    item.items = [item.items substringToIndex:item.items.length - 2];
                }
                NSLog(@"items = %@", item.items);
                item.isList = 1;
                item.isOpened = FALSE;
                item.isSelected = FALSE;
                item.listID = obj.listID;
                [arrayForTable addObject:item];
            }
            [self saveInBox];
            [myListTable reloadData];

                [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        }
        else{
            [arrayForTable removeAllObjects];
            listIndex = 0;
            for (int i = 0; i < arrayList.count; i++) {
                MyListObject *obj = [arrayList objectAtIndex:i];
                ListTableItem *item = [[ListTableItem alloc]init];
                item.itemName = obj.listTitle;
                item.orderDate = obj.orderDate;
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    item.receiversName = [NSString stringWithFormat:@"From : %@", obj.senderName];
                else
                    item.receiversName = [NSString stringWithFormat:@"من : %@", obj.senderName];
                item.items = @"";
                for (int j = 0; j < obj.items.count; j++){
                    MyListItem *objItem = [obj.items objectAtIndex:j];
                    NSString *itemName = [[Setting sharedInstance] getSubCategoryName:objItem.itemSubID];
                    item.items = [item.items stringByAppendingString:[NSString stringWithFormat:@"%@, ", itemName]];
                }
                if (item.items.length > 0) {
                    item.items = [item.items substringToIndex:item.items.length - 2];
                }
                NSLog(@"items = %@", item.items);
                item.isList = 1;
                item.isOpened = FALSE;
                item.isSelected = FALSE;
                item.listID = obj.listID;
                [arrayForTable addObject:item];
            }

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [myListTable reloadData];
        }
    }
    
}
-(BOOL)compareLocalDB:(NSString*)listID{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ReceivedMyList WHERE CustomerID = \"%@\" and ListID = \"%@\"", [Setting sharedInstance].customer.customerID, listID];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                sqlite3_finalize(statement);
                sqlite3_close(projectDB);
                return TRUE;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(projectDB);
        
    }
    return FALSE;
}
-(void)saveInBox
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        for (int i = 0; i < arrayItem.count; i++){
            MyListObject *obj = [arrayItem objectAtIndex:i];
            NSString *queryString = [NSString stringWithFormat: @"INSERT INTO ReceivedMyList (ListID, Title, OrderDate, CustomerID, SenderName) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", obj.listID, obj.listTitle, obj.orderDate, [Setting sharedInstance].customer.customerID, obj.senderName];
            const char *query_stmt_del = [queryString UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt_del, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"ReceivedMyList saved");
                
                }
                sqlite3_finalize(statement);
            }
            const char *query_stmt = [queryString UTF8String];
            

            for (int i = 0; i < obj.items.count; i++) {
                MyListItem *item = [obj.items objectAtIndex:i];
                    BOOL isDone = FALSE;
                
                    queryString = [NSString stringWithFormat: @"INSERT INTO ReceivedMyListItems (ListID, MainCatID, SubCatID, MeasureID, Quantity, IsDone) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\")", obj.listID, item.itemID, item.itemSubID, item.measureUnit, item.measureQuantity, isDone];
                
                    query_stmt = [queryString UTF8String];
                    sqlite3_stmt    *statement1;
                    if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement1, NULL) == SQLITE_OK)
                    {
                        if (sqlite3_step(statement1) == SQLITE_DONE)
                        {
                            NSLog(@"ReceivedMyListItem saved");
                            
                        }
                        sqlite3_finalize(statement1);
                    }
                
            }
        }
        sqlite3_close(projectDB);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnAdd:(id)sender {
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add your list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@" يجب عليك تسجيل الدخول لحفظ القائمة" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
    }
    else{
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
        NewListViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"NewListView"];
        [self.navigationController pushViewController:VC animated:YES];
    }
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

- (IBAction)onBtnSent:(id)sender {
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        self.backImg.image = [UIImage imageNamed:@"favorite_tab1_bg.png"];
    else
        self.backImg.image = [UIImage imageNamed:@"favorite_tab_bg.png"];
        if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
    listStatus = FALSE;
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM MyList WHERE CustomerID = \"%@\"", [Setting sharedInstance].customer.customerID];
        const char *query_stmt = [querySQL UTF8String];
        [arrayList removeAllObjects];
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                MyListObject *obj = [[MyListObject alloc]init];
                obj.listID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                obj.listTitle = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.orderDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.customerID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                obj.receiversName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *queryString = [NSString stringWithFormat: @"SELECT * FROM MyListItems WHERE ListID = %@ ORDER BY MainCatID", obj.listID];
                const char *query_stmt1 = [queryString UTF8String];
                sqlite3_stmt    *statement1;
                if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement1, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement1) == SQLITE_ROW)
                    {
                        MyListItem *objItem = [[MyListItem alloc]init];
                        objItem.itemID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 2)];
                        objItem.itemSubID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 3)];
                        objItem.measureUnit = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 4)];
                        objItem.measureQuantity = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 5)];
                        objItem.isDone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 6)];
                        objItem.itemName = [[Setting sharedInstance] getSubCategoryName:objItem.itemSubID];
                        [obj.items addObject:objItem];
                    }
                    sqlite3_finalize(statement1);
                }
               
                
                [arrayList addObject:obj];
            }
             sqlite3_finalize(statement);
        }
        sqlite3_close(projectDB);
    }
            [self sortDone];
    [arrayForTable removeAllObjects];
    for (int i = 0; i < arrayList.count; i++) {
        MyListObject *obj = [arrayList objectAtIndex:i];
        ListTableItem *item = [[ListTableItem alloc]init];
        item.itemName = obj.listTitle;
        item.orderDate = obj.orderDate;
        item.receiversName = [NSString stringWithFormat:@"To : %@", obj.receiversName];
        item.items = @"";
        for (int j = 0; j < obj.items.count; j++){
            MyListItem *objItem = [obj.items objectAtIndex:j];
            NSString *itemName = [[Setting sharedInstance] getSubCategoryName:objItem.itemSubID];
            item.items = [item.items stringByAppendingString:[NSString stringWithFormat:@"%@, ", itemName]];
        }
        if (item.items.length > 0) {
            item.items = [item.items substringToIndex:item.items.length - 2];
        }
        NSLog(@"items = %@", item.items);
        item.isList = 1;
        item.isOpened = FALSE;
        item.isSelected = FALSE;
        item.listID = obj.listID;
        [arrayForTable addObject:item];
    }
            [myListTable reloadData];
        }
}
- (void)sortDone{

    for (int j = 0; j < arrayList.count; j++){
        MyListObject *obj = [arrayList objectAtIndex:j];
        for (int k = obj.items.count - 1; k >= 0; k--){
            MyListItem *item = [obj.items objectAtIndex:k];
            for (int kk = k - 1; kk >= 0; kk--) {
                MyListItem *item1 = [obj.items objectAtIndex:kk];
                if ([item1.itemID isEqualToString:item.itemID]){
                    if ([item.isDone isEqualToString:@"0"] && [item1.isDone isEqualToString:@"1"]){
                        [obj.items replaceObjectAtIndex:k withObject:item1];
                        [obj.items replaceObjectAtIndex:kk withObject:item];
                        break;
                    }
                }
            }
        }
    }
}
- (IBAction)onBtnInbox:(id)sender {
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        self.backImg.image = [UIImage imageNamed:@"favorite_tab_bg.png"];
    else
        self.backImg.image = [UIImage imageNamed:@"favorite_tab1_bg.png"];
    
        if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
    listStatus = TRUE;
    listIndex = 0;
    [arrayList removeAllObjects];
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ReceivedMyList WHERE CustomerID = \"%@\"", [Setting sharedInstance].customer.customerID];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                MyListObject *obj = [[MyListObject alloc]init];
                obj.listID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.listTitle = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.orderDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                obj.customerID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                obj.senderName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *queryString = [NSString stringWithFormat: @"SELECT * FROM ReceivedMyListItems WHERE ListID = %@ ORDER BY MainCatID", obj.listID];
                const char *query_stmt1 = [queryString UTF8String];
                sqlite3_stmt    *statement1;
                if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement1, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement1) == SQLITE_ROW)
                    {
                        MyListItem *objItem = [[MyListItem alloc]init];
                        objItem.itemID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 2)];
                        objItem.itemSubID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 3)];
                        objItem.measureUnit = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 4)];
                        objItem.measureQuantity = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 5)];
                        objItem.isDone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement1, 6)];
                        objItem.itemName = [[Setting sharedInstance] getSubCategoryName:objItem.itemSubID];
                        [obj.items addObject:objItem];
                    }
                    sqlite3_finalize(statement1);
                }
                
                
                [arrayList addObject:obj];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(projectDB);
    }
            [self sortDone];
    NSString *receivedDate;
    receivedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastReceivedDate"];
    if (receivedDate == Nil){
        /*      NSDate *addDate = [[NSDate alloc]init];
         NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
         [df1 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
         NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
         [df1 setLocale:locale1];
         NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
         [df1 setTimeZone:tz1];
         receivedDate = [df1 stringFromDate:addDate];
         receivedDate = [receivedDate stringByReplacingOccurrencesOfString:@" " withString:@"T"];*/
        receivedDate = @"2013-01-01T00:00:00";
    }

    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<MyListGetInbox xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%d</CustomerID>\n"
                             "<LastReceiveDate>%@</LastReceiveDate>\n"
                             "</MyListGetInbox>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], receivedDate];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MyListGetInbox"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/MyListGetInbox" forHTTPHeaderField:@"SOAPAction"];
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
    
    [myListTable reloadData];
        }
}

- (IBAction)onBtnRemove:(id)sender {
    NSIndexPath *indexPath;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 7.0)
        indexPath = [myListTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    else
        indexPath = [myListTable indexPathForCell:(UITableViewCell *)[[[sender superview]superview]superview]];
    removeIndex = indexPath.row;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Confirmation" message:@"Are you sure you want to delete this list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تأكيد الحذف ؟"
                                                        message:@"هل أنت متأكد من حذف هذه القائمة ؟" delegate:self cancelButtonTitle:@"الغاء" otherButtonTitles:@"موافق", nil];
        [alert show];
    }
    /*
    NSIndexPath *indexPath;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 7.0)
        indexPath = [myListTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    else
        indexPath = [myListTable indexPathForCell:(UITableViewCell *)[[[sender superview]superview]superview]];
    NSMutableArray *subArray = [[NSMutableArray alloc]init];
    ListTableItem *item = [arrayForTable objectAtIndex:indexPath.row];
    for (int i = indexPath.row; i < arrayForTable.count; i++) {
        ListTableItem *item1 = [arrayForTable objectAtIndex:i];
        if ([item1.listID isEqualToString:item.listID]){
            [subArray addObject:item1];
        }
        else
            break;
    }
    for (int j = 0; j < arrayList.count; j++)
    {
        MyListObject *obj = [arrayList objectAtIndex:j];
        if ([obj.listID isEqualToString:item.listID]){
            [arrayList removeObjectAtIndex:j];
            break;
        }
    }
    sqlite3_stmt    *statement;
    
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        
        NSString *querySQL;
        if (listStatus == FALSE)
            querySQL = [NSString stringWithFormat: @"DELETE FROM MyList WHERE ID = \"%@\"", item.listID];
        else
            querySQL = [NSString stringWithFormat: @"DELETE FROM ReceivedMyList WHERE ListID = \"%@\"", item.listID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"mylist remove success");
                
            }
            sqlite3_finalize(statement);
        }
        if (listStatus == FALSE)
            querySQL = [NSString stringWithFormat: @"DELETE FROM MyListItems WHERE ListID = \"%@\"", item.listID];
        else
            querySQL = [NSString stringWithFormat: @"DELETE FROM ReceivedMyListItems WHERE ListID = \"%@\"", item.listID];
        query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"mylistitems remove success");
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(projectDB);
    }
    if (subArray.count > 0)
    {    [arrayForTable removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, subArray.count)]];
        
    }
    if (listStatus == true){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Information"
                                                    message:@"The list is removed from your InBox lists" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [mes show];
    }
    else{
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Information"
                                                    message:@"The list is removed from your Sent lists" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [mes show];
    }
    [myListTable reloadData];*/
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableItem *item = [arrayForTable objectAtIndex:indexPath.row];
    if (item.isList == 1){
        if (item.isOpened == TRUE){
            item.isOpened = FALSE;
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            for (int i = indexPath.row + 1; i < arrayForTable.count; i++) {
                ListTableItem *item1 = [arrayForTable objectAtIndex:i];
                if ([item1.listID isEqualToString:item.listID]){
                    [subArray addObject:item1];
                }
                else
                    break;
            }
            if (subArray.count > 0)
                [arrayForTable removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, subArray.count)]];
        }
        else{
            item.isOpened = TRUE;
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            MyListObject *obj;
            for (int i = 0; i < arrayList.count; i++){
                obj = [arrayList objectAtIndex:i];
                if ([obj.listID isEqualToString:item.listID])
                    break;
            }
            if (obj){
                NSString *mainCatString = @"-";
                ListTableItem *newItem;
                for (int j = 0; j < obj.items.count; j++) {
                    MyListItem *listItem = [obj.items objectAtIndex:j];

                    if (![listItem.itemID isEqualToString:mainCatString]){
                        mainCatString = listItem.itemID;
                        newItem = [[ListTableItem alloc]init];
                        newItem.itemName = [[Setting sharedInstance] getMainCategoryName:mainCatString];
                        newItem.orderDate = obj.orderDate;
                        newItem.receiversName = [NSString stringWithFormat:@"To : %@", obj.receiversName];
                        newItem.items = @"";
                        newItem.isList = 2;
                        newItem.isOpened = FALSE;
                        newItem.isSelected = FALSE;
                        newItem.listID = obj.listID;
                        newItem.itemID = listItem.itemID;
                        newItem.itemNumber = 1;
                        [subArray addObject:newItem];
                    }
                    else
                    {
                        if (![mainCatString isEqualToString:@"-"]){
                            newItem.itemNumber++;
                            [subArray replaceObjectAtIndex:subArray.count - 1 withObject:newItem];
                        }
                    }
                }
                if (subArray.count > 0)
                    [arrayForTable insertObjects:subArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, subArray.count)]];
            }
        }
    }
    if (item.isList == 2){
        if (item.isOpened == TRUE){
            item.isOpened = FALSE;
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            for (int i = indexPath.row + 1; i < arrayForTable.count; i++) {
                ListTableItem *item1 = [arrayForTable objectAtIndex:i];
                
                if ([item1.itemID isEqualToString:item.itemID]){
                    [subArray addObject:item1];
                }
                else
                    break;
            }
            if (subArray.count > 0)
                [arrayForTable removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, subArray.count)]];
        }
        else{
            item.isOpened = TRUE;
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            MyListObject *obj;
            for (int i = 0; i < arrayList.count; i++){
                obj = [arrayList objectAtIndex:i];
                if ([obj.listID isEqualToString:item.listID])
                    break;
            }
            if (obj){
                NSString *mainCatString = @"-";
                for (int j = 0; j < obj.items.count; j++) {
                    MyListItem *listItem = [obj.items objectAtIndex:j];
                    if ([listItem.itemID isEqualToString:item.itemID]){
                        ListTableItem *newItem = [[ListTableItem alloc]init];
                        newItem.itemName = [[Setting sharedInstance] getSubCategoryName:listItem.itemSubID];
                        newItem.isList = 3;
                        newItem.isOpened = FALSE;
                        newItem.isSelected = FALSE;
                        newItem.listID = obj.listID;
                        newItem.itemID = item.itemID;
                        newItem.itemSubID = listItem.itemSubID;
                        newItem.measureUnit = listItem.measureUnit;
                        newItem.measureQuantity = listItem.measureQuantity;
                        newItem.isDone = listItem.isDone;
                        [subArray addObject:newItem];
                    }
                }
                if (subArray.count > 0)
                    [arrayForTable insertObjects:subArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, subArray.count)]];
            }
        }
    }
    
    [myListTable reloadData];
    
}
int rowIndex = 0;
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"MyListCell"];
    if (cell == Nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyListCell"];
  /*  if (listStatus == TRUE){
        NSLog(@"Inbox table");
    }
    else{*/
        if (arrayForTable.count > 0){
            ListTableItem *item = [arrayForTable objectAtIndex:indexPath.row];
            if (item.isList == 1){
                cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"MyListCell"];
                if (cell == Nil)
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyListCell"];
            
                UILabel *lb_listName = (UILabel*)[cell viewWithTag:101];
                lb_listName.text = item.itemName;
                
                UILabel *lb_orderDate = (UILabel*)[cell viewWithTag:102];
                if (listStatus == TRUE) {
                    NSString *dateString = item.orderDate;
                    if ([dateString rangeOfString:@"T"].location != NSNotFound){
                        NSUInteger loc = [dateString rangeOfString:@"T"].location;
                        dateString = [dateString substringToIndex:loc];
                    }
                    //        dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc]init];
                    //        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                    [df setDateFormat:@"yyyy-MM-dd"];
                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                    [df setLocale:locale];
                    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                    [df setTimeZone:tz];
                    NSDate *msgDate = [df dateFromString:dateString];
                    [df setDateFormat:@"dd/MM/yyyy"];
                    dateString = [df stringFromDate:msgDate];
                    lb_orderDate.text = dateString;
                }
                else
                    lb_orderDate.text = item.orderDate;
                
                UILabel *lb_receivers = (UILabel*)[cell viewWithTag:103];
                lb_receivers.text = item.receiversName;
        
                UILabel *lb_items = (UILabel*)[cell viewWithTag:104];
                lb_items.text = item.items;
                
                UIImageView *imgView1 = (UIImageView*)[cell viewWithTag:106];
                UIImageView *imgView2 = (UIImageView*)[cell viewWithTag:107];

                if (item.isOpened == TRUE) {
                    imgView1.hidden = YES;
                    imgView2.hidden = NO;
                }
                else{
                    imgView1.hidden = NO;
                    imgView2.hidden = YES;
                }
                UIButton *btnClose = (UIButton*)[cell viewWithTag:105];
                NSLog(@"%f, %f, %f", btnClose.frame.origin.x, imgView1.frame.origin.x, imgView2.frame.origin.x);
                CGRect tmpRect;
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                {
                    lb_listName.textAlignment = NSTextAlignmentLeft;
                    lb_orderDate.textAlignment = NSTextAlignmentLeft;
                    lb_receivers.textAlignment = NSTextAlignmentLeft;
                    lb_items.textAlignment = NSTextAlignmentLeft;
                    
                    tmpRect = btnClose.frame;
                    tmpRect.origin.x = 3;
                    btnClose.frame = tmpRect;
                    
                    tmpRect = imgView1.frame;
                    tmpRect.origin.x = 256;
                    imgView1.frame = tmpRect;
                    [imgView1 setImage:[UIImage imageNamed:@"mylist_arrow.png"]];
                    
                    tmpRect = imgView2.frame;
                    tmpRect.origin.x = 242;
                    imgView2.frame = tmpRect;
                }
                else{
                    lb_listName.textAlignment = NSTextAlignmentRight;
                    lb_orderDate.textAlignment = NSTextAlignmentRight;
                    lb_receivers.textAlignment = NSTextAlignmentRight;
                    lb_items.textAlignment = NSTextAlignmentRight;
                    
                    tmpRect = btnClose.frame;
                    tmpRect.origin.x = 250;
                    btnClose.frame = tmpRect;
                    
                    tmpRect = imgView1.frame;
                    tmpRect.origin.x = 15;
                    imgView1.frame = tmpRect;
                    [imgView1 setImage:[UIImage imageNamed:@"mylist_arrow_r.png"]];
                    
                    tmpRect = imgView2.frame;
                    tmpRect.origin.x = 12;
                    imgView2.frame = tmpRect;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                rowIndex = 0;
                return cell;
            }
            else if (item.isList == 2){
                cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"MainCatCell"];
                if (cell == Nil)
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCatCell"];
                rowIndex++;
                UIImageView *imgView = (UIImageView*)[cell viewWithTag:111];
                if (rowIndex % 2 == 1)
                    imgView.image = [UIImage imageNamed:@"cell1.png"];
                else
                    imgView.image = [UIImage imageNamed:@"cell2.png"];
                
                
                UILabel *lb_listName = (UILabel*)[cell viewWithTag:112];
                lb_listName.text = item.itemName;
                
                UIImageView *imgView1 = (UIImageView*)[cell viewWithTag:113];
                UIImageView *imgView2 = (UIImageView*)[cell viewWithTag:114];
                UILabel *lbNum = (UILabel*)[cell viewWithTag:150];
                if (item.itemNumber == 0)
                    lbNum.text = @"";
                else
                    lbNum.text = [NSString stringWithFormat:@"%d", item.itemNumber];
                if (item.isOpened == TRUE) {
                    imgView1.hidden = YES;
                    imgView2.hidden = NO;
                }
                else{
                    imgView1.hidden = NO;
                    imgView2.hidden = YES;
                }
                CGRect tmpRect;
                NSLog(@"%f, %f, %f", lbNum.frame.origin.x, imgView1.frame.origin.x, imgView2.frame.origin.x);
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                    lb_listName.textAlignment = NSTextAlignmentLeft;
                    tmpRect = lbNum.frame;
                    tmpRect.origin.x = 211;
                    lbNum.frame = tmpRect;
                    
                    tmpRect = imgView1.frame;
                    tmpRect.origin.x = 245;
                    imgView1.frame = tmpRect;
                    [imgView1 setImage:[UIImage imageNamed:@"mylist_arrow.png"]];
                    
                    tmpRect = imgView2.frame;
                    tmpRect.origin.x = 238;
                    imgView2.frame = tmpRect;
                    
                }else{
                    lb_listName.textAlignment = NSTextAlignmentRight;
                    tmpRect = lbNum.frame;
                    tmpRect.origin.x = 35;
                    lbNum.frame = tmpRect;
                    
                    tmpRect = imgView1.frame;
                    tmpRect.origin.x = 20;
                    imgView1.frame = tmpRect;
                    [imgView1 setImage:[UIImage imageNamed:@"mylist_arrow_r.png"]];
                    
                    tmpRect = imgView2.frame;
                    tmpRect.origin.x = 17;
                    imgView2.frame = tmpRect;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if (item.isList == 3){
                cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"SubCatCell"];
                if (cell == Nil)
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SubCatCell"];
                CGRect tmpRect;
                UILabel *lb_ItemName = (UILabel*)[cell viewWithTag:121];
                lb_ItemName.text = item.itemName;
                
                NSString *unitString = [[Setting sharedInstance] getMeasure:item.measureUnit];
                NSString *qString = [NSString stringWithFormat:@"%d %@", [item.measureQuantity intValue], unitString];
                UILabel *lb_quantity = (UILabel*)[cell viewWithTag:122];
                lb_quantity.text = qString;
                
                UIButton *butDone = (UIButton*)[cell viewWithTag:123];
                UIButton *butSearch = (UIButton*)[cell viewWithTag:124];
                
                if (listStatus == FALSE)
                    butDone.hidden = YES;
                else{
                    butDone.hidden = NO;
                    if ([item.isDone intValue] == 0){
                        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
                            [butDone setBackgroundImage:[UIImage imageNamed:@"btn_graydone_mylist.png"] forState:UIControlStateNormal];
                        }
                        else{
                            [butDone setBackgroundImage:[UIImage imageNamed:@"arab_graydone_mylist.png"] forState:UIControlStateNormal];
                        }
                    }
                    else{
                        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
                            [butDone setBackgroundImage:[UIImage imageNamed:@"btn_list_done_mylist.png"] forState:UIControlStateNormal];
                        }
                        else{
                            [butDone setBackgroundImage:[UIImage imageNamed:@"arab_list_done_mylist.png"] forState:UIControlStateNormal];
                        }
                    }
                }
                NSLog(@"%f, %f, %f, %f", lb_ItemName.frame.origin.x, lb_quantity.frame.origin.x, butDone.frame.origin.x, butSearch.frame.origin.x);
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                    lb_ItemName.textAlignment = NSTextAlignmentLeft;
                    lb_quantity.textAlignment = NSTextAlignmentLeft;
                    tmpRect = lb_ItemName.frame;
                    tmpRect.origin.x = 36;
                    lb_ItemName.frame = tmpRect;
                    
                    tmpRect = lb_quantity.frame;
                    tmpRect.origin.x = 36;
                    lb_quantity.frame = tmpRect;
                    
                    tmpRect = butDone.frame;
                    tmpRect.origin.x = 181;
                    butDone.frame = tmpRect;
                    
                    tmpRect = butSearch.frame;
                    tmpRect.origin.x = 232;
                    butSearch.frame = tmpRect;
                    
                }else{
                    lb_ItemName.textAlignment = NSTextAlignmentRight;
                    lb_quantity.textAlignment = NSTextAlignmentRight;
                    
                    tmpRect = lb_ItemName.frame;
                    tmpRect.origin.x = 130;
                    lb_ItemName.frame = tmpRect;
                    
                    tmpRect = lb_quantity.frame;
                    tmpRect.origin.x = 130;
                    lb_quantity.frame = tmpRect;
                    
                    tmpRect = butDone.frame;
                    tmpRect.origin.x = 100;
                    butDone.frame = tmpRect;
                    
                    tmpRect = butSearch.frame;
                    tmpRect.origin.x = 50;
                    butSearch.frame = tmpRect;
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }
        }
        
  //  }
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return arrayForTable.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableItem *item = [arrayForTable objectAtIndex:indexPath.row];
    if (item.isList == 1){
        return 79;
    }
    if (item.isList == 2)
        return 40;
    if (item.isList == 3)
        return 49;
    return 0;
}
- (IBAction)Done:(id)sender {
    NSIndexPath *indexPath;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 7.0)
        indexPath = [myListTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    else
        indexPath = [myListTable indexPathForCell:(UITableViewCell *)[[[sender superview]superview]superview]];
    ListTableItem *item = [arrayForTable objectAtIndex:indexPath.row];
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if ([item.isDone isEqualToString:@"0"])
    {
        item.isDone = @"1";
        [arrayForTable replaceObjectAtIndex:indexPath.row withObject:item];
        int i = indexPath.row;
        for (i = indexPath.row + 1; i < arrayForTable.count; i++) {
            ListTableItem *item1 = [arrayForTable objectAtIndex:i];
            if ([item.listID isEqualToString:item1.listID] && item1.isList == 3){
                if ([item1.isDone isEqualToString:@"0"]) {
                    [arrayForTable replaceObjectAtIndex:i - 1 withObject:item1];
                    [arrayForTable replaceObjectAtIndex:i withObject:item];
                }
                else
                    break;
            }
            else
                break;
        }
        
    }
    else
    {
        item.isDone = @"0";
        [arrayForTable replaceObjectAtIndex:indexPath.row withObject:item];
        int i = indexPath.row;
        for (i = indexPath.row - 1; i > 0; i--) {
            ListTableItem *item1 = [arrayForTable objectAtIndex:i];
            if ([item.listID isEqualToString:item1.listID] && item1.isList == 3){
                if ([item1.isDone isEqualToString:@"1"]) {
                    [arrayForTable replaceObjectAtIndex:i + 1 withObject:item1];
                    [arrayForTable replaceObjectAtIndex:i withObject:item];
                }
                else
                    break;
            }
            else
                break;
        }
    }
    for (int i = 0; i < arrayList.count; i++){
        MyListObject *obj = [arrayList objectAtIndex:i];
        if ([obj.listID isEqualToString:item.listID]){
            for (int j = 0; j < obj.items.count; j++){
                MyListItem *itemList = [obj.items objectAtIndex:j];
                if ([itemList.itemID isEqualToString:item.itemID] && [itemList.itemSubID isEqualToString:item.itemSubID]) {
                    itemList.isDone = item.isDone;
                    break;
                }
            }
        }
    }
    [self sortDone];
    [myListTable reloadData];
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        
        NSString *querySQL;
        if (listStatus == TRUE)
            querySQL = [NSString stringWithFormat:@"UPDATE ReceivedMyListItems SET IsDone=\"%@\" WHERE ListID = \"%@\" and SubCatID = \"%@\"", item.isDone, item.listID, item.itemSubID];
        else
            querySQL = [NSString stringWithFormat:@"UPDATE MyListItems SET IsDone=\"%@\" WHERE ListID = \"%@\" and SubCatID = \"%@\"", item.isDone, item.listID, item.itemSubID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"isDone updated");
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(projectDB);
    }
}

- (IBAction)btnSearch:(id)sender {
    [Setting sharedInstance].isListSearch = TRUE;
    NSIndexPath *indexPath;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 7.0)
        indexPath = [myListTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    else
        indexPath = [myListTable indexPathForCell:(UITableViewCell *)[[[sender superview]superview]superview]];
    ListTableItem *item = [arrayForTable objectAtIndex:indexPath.row];
    [Setting sharedInstance].searchSubCatID = item.itemSubID;
    NSLog(@"catname: %@", [Setting sharedInstance].searchSubCatID);
    [Setting sharedInstance].searchIndex = 3;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        [[Setting sharedInstance].tabBarController setSelectedIndex:1];
    else
        [[Setting sharedInstance].tabBarController setSelectedIndex:3];
}
@end
