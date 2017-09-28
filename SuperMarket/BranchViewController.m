//
//  BranchViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/23/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "BranchViewController.h"
#import "Annotation.h"
#import "Setting.h"
#import "CompanyViewController.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
@interface BranchViewController ()

@end

@implementation BranchViewController
@synthesize branchObj;
@synthesize mapView;
@synthesize lb_title;
@synthesize selCompany;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize Branches;
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
                    UINavigationController *navigationController = self.navigationController;
                    NSArray *array = [navigationController viewControllers];
                    for (int i = 0; i < array.count; i++) {
                        UIViewController *vc = [array objectAtIndex:i];
                        NSLog(@"%@", NSStringFromClass([vc class]));
                        if ([NSStringFromClass([vc class]) isEqualToString:@"OffersViewController"])
                        {
                            [self.navigationController popToViewController:vc animated:YES];
                            break;
                        }
                    }
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
            UINavigationController *navigationController = self.navigationController;
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
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
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
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Branches WHERE CompanyID = \"%@\"", selCompany.companyID];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) != SQLITE_ROW) {
                    flag = FALSE;
                }
                else{
                    Branches = [[NSMutableArray alloc]init];
                    BranchObject *obj = [[BranchObject alloc]init];
                    obj.branchID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    obj.CompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    obj.NameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    obj.NameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    obj.Email = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    obj.Phone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    obj.Fax = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    obj.Sort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                    obj.StateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                    obj.AreaID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                    obj.AddressEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                    obj.AddressAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                    obj.Latitude = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                    obj.Longitude = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                    
                    [Branches addObject:obj];
                    
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        BranchObject *obj1 = [[BranchObject alloc]init];
                        obj1.branchID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                        obj1.CompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        obj1.NameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                        obj1.NameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                        obj1.Email = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                        obj1.Phone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                        obj1.Fax = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                        obj1.Sort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                        obj1.StateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                        obj1.AreaID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                        obj1.AddressEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                        obj1.AddressAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                        obj1.Latitude = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                        obj1.Longitude = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                        [Branches addObject:obj1];
                        
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
        if (flag == TRUE && Branches.count > 0)
            [self showMap];
    }
    int myLang = -1;
    if([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        lb_title.text = selCompany.companyNameEn;
        myLang = 1;
    }
    if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
    {
        lb_title.text = selCompany.companyNameAr;
        myLang = 2;
    }
    if (flag == FALSE){
    Branches = [[NSMutableArray alloc]init];
    //    mapView.hidden = YES;
    branchObj = [[BranchObject alloc] init];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CompanyBranchesGetBranches xmlns=\"http://tempuri.org/\">\n"
                             "<CompanyID>%@</CompanyID>\n"
                             "</CompanyBranchesGetBranches>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             , selCompany.companyID
                             ];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CompanyBranchesGetBranches"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/CompanyBranchesGetBranches" forHTTPHeaderField:@"SOAPAction"];
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    
	if( [elementName isEqualToString:@"CompanyBranchesGetBranchesResult"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
        [Branches removeAllObjects];
    }
    if ([elementName isEqualToString:@"BranchResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
        branchObj = [[BranchObject alloc] init];
    }
    if ([elementName isEqualToString:@"ID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"CompanyID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BranchNameAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BranchNameEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Email"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Phone"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Fax"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Sort"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"StateID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AreaID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Latitude"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Longitude"])
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
    
    if( [elementName isEqualToString:@"CompanyBranchesGetBranchesResult"])
	{
        recordResults = FALSE;
        soapResults = nil;
        if (Branches.count > 0) {
            BranchObject *obj = [Branches objectAtIndex:0];
            if (![obj.branchID isEqualToString:@""]) {
                [self saveBranchInfo];
                [self showMap];
            }
        }

    }
	if( [elementName isEqualToString:@"BranchResult"])
	{
		recordResults = FALSE;
        [Branches addObject:branchObj];
        soapResults = nil;
        branchObj = nil;
	}
    if ([elementName isEqualToString:@"ID"]){
        recordResults = FALSE;
        branchObj.branchID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"CompanyID"]){
        recordResults = FALSE;
        branchObj.CompanyID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"BranchNameAr"])
    {
        recordResults = FALSE;
        branchObj.NameAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"BranchNameEn"])
    {
        recordResults = FALSE;
        branchObj.NameEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Email"])
    {
        recordResults = FALSE;
        branchObj.Email = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Phone"])
    {
        recordResults = FALSE;
        branchObj.Phone = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Fax"])
    {
        recordResults = FALSE;
        branchObj.Fax = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Sort"])
    {
        recordResults = FALSE;
        branchObj.Sort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"StateID"])
    {
        recordResults = FALSE;
        branchObj.StateID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AreaID"])
    {
        recordResults = FALSE;
        branchObj.AreaID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AddressEn"])
    {
        recordResults = FALSE;
        branchObj.AddressEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AddressAr"])
    {
        recordResults = FALSE;
        branchObj.AddressAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Latitude"])
    {
        recordResults = FALSE;
        branchObj.Latitude = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Longitude"])
    {
        recordResults = FALSE;
        branchObj.Longitude = soapResults;
        soapResults = nil;
    }
}
-(void)showMap{
    if (Branches.count > 0){
        for (int i = 0; i < Branches.count; i++) {
            BranchObject *obj = [Branches objectAtIndex:i];
            CLLocationCoordinate2D branchPosition = CLLocationCoordinate2DMake([obj.Latitude doubleValue], [obj.Longitude doubleValue]);
            Annotation *addAnnotation = [[Annotation alloc] init];
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            {
                [addAnnotation setTitle:obj.NameEn];
                [addAnnotation setSubtitle:obj.AddressEn];
            }
            else if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                [addAnnotation setTitle:obj.NameAr];
                [addAnnotation setSubtitle:obj.AddressAr];
            }

            [addAnnotation setCoordinate:branchPosition];
            [mapView addAnnotation:addAnnotation];
        }
        BranchObject *obj = [Branches objectAtIndex:0];
        CLLocationCoordinate2D branchPosition = CLLocationCoordinate2DMake([obj.Latitude doubleValue], [obj.Longitude doubleValue]);
        [mapView setRegion:MKCoordinateRegionMake(branchPosition, MKCoordinateSpanMake(20.0 / 60.01 * 0.6, 20.0 / 42.5 * 0.6))];
    
//        [mapView set:branchPosition animated:YES];
    }
}
-(void)saveBranchInfo{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        for (int i = 0; i < Branches.count; i++) {
            BranchObject *obj = [Branches objectAtIndex:i];
            NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO Branches (ID, CompanyID, BranchNameAr, BranchNameEn, Email, Phone, Fax, Sort, StateID, AreaID, AddressEn, AddressAr, Latitude, Longitude) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", obj.branchID, obj.CompanyID, obj.NameAr, obj.NameEn, obj.Email, obj.Phone, obj.Fax, obj.Sort, obj.StateID, obj.AreaID, obj.AddressEn, obj.AddressAr, obj.Latitude, obj.Longitude];
            
            const char *query_stmt1 = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"branch success");
                    
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(projectDB);
    }
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];

    annView.pinColor = MKPinAnnotationColorRed;
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
}

@end
