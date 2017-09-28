//
//  Setting.m
//  VideoUploading
//
//  Created by phoenix on 10/13/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "Setting.h"
#import "Measures.h"
#import "MainCategory.h"
#import "SubCategory.h"
#import "State.h"
#import "Area.h"
#import "CompanyObject.h"
#import <sqlite3.h>
static Setting *instance = nil;
@implementation Setting
{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@synthesize userEmail;
@synthesize myLanguage;
@synthesize arrayCompany;
@synthesize MainCategories;
@synthesize SubCategories;
@synthesize arrayMeasures;
@synthesize Areas;
@synthesize Cities;
@synthesize myFavoriteList;
@synthesize myPurchaseList;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize errEncounter;
@synthesize myFriend;
+ (Setting *)sharedInstance
{
    if (instance == nil)
    {
     instance = [[Setting alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    arrayCompany = [[NSMutableArray alloc]init];
    myFavoriteList = [[NSMutableArray alloc]init];
    myPurchaseList = [[NSMutableArray alloc]init];
    self.logoArray = [[NSMutableArray alloc]init];
    self.customer = [[CustomerObject alloc]init];
    self.arrayPendingFriends = [[NSMutableArray alloc]init];
    self.arrayRealFriends = [[NSMutableArray alloc]init];
    self.searchSubCatID = @"";
    self.lastViewController = nil;
    self.lastSelectedTabIndex = 0;
    return self;
}
- (void)registerDevice{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CustomerRegisterNew xmlns=\"http://tempuri.org/\">\n"
                             "<Name>Guest</Name>\n"
                             "<Email>info@q8supermarket.com</Email>\n"
                             "<MobileNumber>0000000</MobileNumber>\n"
                             "<MobileID>%@</MobileID>\n"
                             "<CityID>1</CityID>\n"
                             "<AreaID>1</AreaID>\n"
                             "<Address></Address>\n"
                             "<Username>%@</Username>\n"
                             "<Password>123456</Password>\n"
                             "<Language>1</Language>\n"
                             "<MobileType>2</MobileType>\n"
                             "<UserType>0</UserType>\n"
                             "<AccessToken></AccessToken>\n"
                             "</CustomerRegisterNew>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [Setting sharedInstance].deviceTokenString, [Setting sharedInstance].deviceTokenString];
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
- (void)customizeTabBar{
 //   UITabBar *tabBar = [Setting sharedInstance].tabBarController.tabBar;
  //  [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    self.ARtabBarController = [[MyTabBarViewController alloc]init];
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar_bg.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
        NSMutableArray *arabArray = [[NSMutableArray alloc]init];
        for (int i = newArray.count - 1; i >= 0; i--){
            UIViewController *vc = [newArray objectAtIndex:i];
            [arabArray addObject:vc];
        }
        [self.ARtabBarController setViewControllers:arabArray animated:YES];
        self.tabBarController = self.ARtabBarController;
        [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"المزيد"];
        [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"المفضلة"];
        [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@"طلبات البيت"];
        [[self.tabBarController.tabBar.items objectAtIndex:3] setTitle:@"البحث"];
        [[self.tabBarController.tabBar.items objectAtIndex:4] setTitle:@"العروض"];

    }
    else{
        self.ENtabBarController = self.tabBarController;
        [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Offers"];
        [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Search"];
        [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@"My List"];
        [[self.tabBarController.tabBar.items objectAtIndex:3] setTitle:@"Favorite"];
        [[self.tabBarController.tabBar.items objectAtIndex:4] setTitle:@"More"];

    }
}
- (void)addPurchaseProduct:(NSString*)customerID withProdID:(NSString*)prodID withDate:(NSString*)addDate withCompany:(NSString*)companyID withOffer:(NSString*)offerID{

    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO PurchasedProducts (CustomerID, ProductID, InsertDate, CompanyID, OfferID) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", customerID, prodID, addDate, companyID, offerID];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"purchase product insert success");
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }
}
- (void)removePurchaseProduct:(NSString*)customerID withProdID:(NSString*)prodID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM PurchasedProducts WHERE CustomerID = \"%@\" and ProductID = \"%@\"", customerID, prodID];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"purchase product remove success");
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }
}
- (void)sendPurchaseRequest:(ProductObject*)obj{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<PurchasesAddProduct xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%@</CustomerID>\n"
                             "<ProductID>%@</ProductID>\n"
                             "<Language>%d</Language>\n"
                             "</PurchasesAddProduct>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [Setting sharedInstance].customer.customerID, obj.prodID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=PurchasesAddProduct"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/PurchasesAddProduct" forHTTPHeaderField:@"SOAPAction"];
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
- (void)addFavoriteProduct:(NSString*)customerID withProdID:(NSString*)prodID withDate:(NSString*)addDate withCompany:(NSString*)companyID withOffer:(NSString*)offerID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];

    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO FavoriteProducts (CustomerID, ProductID, InsertDate, CompanyID, OfferID) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", customerID, prodID, addDate, companyID, offerID];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"favorite product insert success");
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }
}
- (void)removeFavoriteProduct:(NSString*)customerID withProdID:(NSString*)prodID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM FavoriteProducts WHERE CustomerID = \"%@\" and ProductID = \"%@\"", customerID, prodID];
            const char *query_stmt = [querySQL UTF8String];

            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"favorite product remove success");
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }

}
- (void)loadPurchaseListFromLocalDB:(NSString *)customerID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    self.myPurchaseList = nil;
    self.myPurchaseList = [[NSMutableArray alloc]init];
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM PurchasedProducts where CustomerID = \"%@\"", customerID];
            const char *query_stmt = [querySQL UTF8String];
            self.arrayPurchase = [[NSMutableArray alloc]init];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    ProductObject *obj = [[ProductObject alloc]init];
                    obj.prodID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    obj.prodAddPurchaseDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    obj.prodCompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    
                    [self.arrayPurchase addObject:obj];
                    
                    
                }
                sqlite3_finalize(statement);
            }
            for (int i = 0; i < self.arrayPurchase.count; i++) {
                ProductObject *obj = [self.arrayPurchase objectAtIndex:i];
                NSString *querySQL1 = [NSString stringWithFormat: @"SELECT * FROM Products where ID = \"%@\"", obj.prodID];
                const char *query_stmt1 = [querySQL1 UTF8String];
                
                if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        obj.OfferID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
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
                        obj.prodPurchasedProducts = @"true";
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                [self.myPurchaseList addObject:obj];
            }
            sqlite3_close(projectDB);
        }
        
    }
}
- (void)loadFavoriteListFromLocalDB:(NSString*)customerID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    self.myFavoriteList = nil;
    self.myFavoriteList = [[NSMutableArray alloc]init];
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM FavoriteProducts where CustomerID = \"%@\"", customerID];
            const char *query_stmt = [querySQL UTF8String];
            self.arrayFavorite = [[NSMutableArray alloc]init];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    ProductObject *obj = [[ProductObject alloc]init];
                    obj.prodID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    obj.prodAddDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    obj.prodCompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    
                    [self.arrayFavorite addObject:obj];
                    
                    
                }
                sqlite3_finalize(statement);
            }
            for (int i = 0; i < self.arrayFavorite.count; i++) {
                ProductObject *obj = [self.arrayFavorite objectAtIndex:i];
                NSString *querySQL1 = [NSString stringWithFormat: @"SELECT * FROM Products where ID = \"%@\"", obj.prodID];
                const char *query_stmt1 = [querySQL1 UTF8String];

                if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        obj.OfferID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
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
                        obj.prodFavoriteProducts = @"true";
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                [self.myFavoriteList addObject:obj];
            }
            sqlite3_close(projectDB);
        }

    }
    
}
- (NSString*)getMainCategoryName:(NSString *)mainCatID
{
    NSString* mainCatName;
    for (int i = 0; i < MainCategories.count; i++)
    {
        MainCategory *mainCat = [MainCategories objectAtIndex:i];
        if ([mainCat.mainCatID isEqualToString:mainCatID]){
            if ([myLanguage isEqualToString:@"En"])
                mainCatName = mainCat.mainCatNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                mainCatName = mainCat.mainCatNameAr;
            return mainCatName;
        }
    }
    return @"Unknown";
}
- (NSString*)getMeasureID:(NSString *)measureName
{

    for (int i = 0; i < arrayMeasures.count; i++)
    {
        Measures *measureData = [arrayMeasures objectAtIndex:i];
        NSString *mName;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            mName = measureData.measureNameEn;
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            mName = measureData.measureNameAr;
        
        if ([mName isEqualToString:measureName]){
            return measureData.measureID;
        }
    }
    return @"Unknown";
}

- (NSString *)getMeasure:(NSString *)measureID{
    NSString* measure;
    for (int i = 0; i < arrayMeasures.count; i++)
    {
        Measures *measureData = [arrayMeasures objectAtIndex:i];
        if ([measureData.measureID isEqualToString:measureID]){
            if ([myLanguage isEqualToString:@"En"])
                measure = measureData.measureNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                measure = measureData.measureNameAr;
            return measure;
        }
    }
    return @"Unknown";
}
-(NSString *)getSubCategoryName:(NSString *)subCatID{
    NSString* subCatName;
    for (int i = 0; i < SubCategories.count; i++)
    {
        SubCategory *subCat = [SubCategories objectAtIndex:i];
        if ([subCat.subCatID isEqualToString:subCatID]){
            if ([myLanguage isEqualToString:@"En"])
                subCatName = subCat.subCatEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                subCatName = subCat.subCatAr;
            return subCatName;
        }
    }
    return @"Unknown";
}
-(NSString *)getCityName:(NSString *)cityID{
    NSString* cityName;
    for (int i = 0; i < SubCategories.count; i++)
    {
        State *city = [Cities objectAtIndex:i];
        if ([city.stateID isEqualToString:cityID]){
            if ([myLanguage isEqualToString:@"En"])
                cityName = city.stateNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                cityName = city.stateNameAr;
            return cityName;
        }
    }
    return @"Unknown";
}
-(NSString *)getAreaName:(NSString *)areaID{
    NSString* areaName;
    for (int i = 0; i < Areas.count; i++)
    {
        Area *area = [Areas objectAtIndex:i];
        if ([area.areaID isEqualToString:areaID]){
            if ([myLanguage isEqualToString:@"En"])
                areaName = area.areaNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                areaName = area.areaNameAr;
            return areaName;
        }
    }
    return @"Unknown";
}
- (NSString*)getCompanyName:(NSString*)companyID{
    NSString* companyName;
    for (int i = 0; i < arrayCompany.count; i++)
    {
        CompanyObject *obj = [arrayCompany objectAtIndex:i];
        if ([obj.companyID isEqualToString:companyID]){
            if ([myLanguage isEqualToString:@"En"])
                companyName = obj.companyNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                companyName = obj.companyNameAr;
            return companyName;
        }
    }
    return @"Unknown";
}
- (NSString*)getSortNum:(NSString*)ID withType:(NSString*)responseType;
{
    NSString *sortNum = @"Unknown";
    if ([responseType isEqualToString:@"main"])
    {
        for (int i = 0; i < MainCategories.count; i++)
        {
            MainCategory *obj = [MainCategories objectAtIndex:i];
            if ([obj.mainCatID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    if ([responseType isEqualToString:@"sub"])
    {
        for (int i = 0; i < SubCategories.count; i++)
        {
            SubCategory *obj = [SubCategories objectAtIndex:i];
            if ([obj.subCatID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    if ([responseType isEqualToString:@"area"])
    {
        for (int i = 0; i < Areas.count; i++)
        {
            Area *obj = [Areas objectAtIndex:i];
            if ([obj.areaID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    if ([responseType isEqualToString:@"city"])
    {
        for (int i = 0; i < Cities.count; i++)
        {
            State *obj = [Cities objectAtIndex:i];
            if ([obj.stateID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    if ([responseType isEqualToString:@"measure"])
    {
        for (int i = 0; i < arrayMeasures.count; i++)
        {
            Measures *obj = [arrayMeasures objectAtIndex:i];
            if ([obj.measureID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    if ([responseType isEqualToString:@"company"])
        
    {
        for (int i = 0; i < arrayCompany.count; i++) {
            CompanyObject *obj = [arrayCompany objectAtIndex:i];
            if ([obj.companyID isEqualToString:ID]){
                sortNum = obj.companyOverallSort;
                return sortNum;
            }
        }
    }
    return sortNum;
}
- (BOOL)isPurchaseExist:(NSString *)prodID{

    for (int i = 0; i < self.myPurchaseList.count; i++){
        ProductObject *obj = [self.myPurchaseList objectAtIndex:i];
        if ([obj.prodID isEqualToString:prodID])
            return TRUE;
    }
    return FALSE;
}
- (BOOL)isFavoriteExist:(NSString *)prodID{
    
    for (int i = 0; i < self.myFavoriteList.count; i++){
        ProductObject *obj = [self.myFavoriteList objectAtIndex:i];
        if ([obj.prodID isEqualToString:prodID])
            return TRUE;
    }
    return FALSE;
}

- (void)sendFavoriteRequest:(ProductObject*)obj{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<FavoriteAddProduct xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%@</CustomerID>\n"
                             "<ProductID>%@</ProductID>\n"
                             "<Language>%d</Language>\n"
                             "</FavoriteAddProduct>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [Setting sharedInstance].customer.customerID, obj.prodID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FavoriteAddProduct"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/FavoriteAddProduct" forHTTPHeaderField:@"SOAPAction"];
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
- (NSMutableArray*)getArraySubCategory:(NSString*)mainID{
    NSMutableArray *arraySubCategory = [[NSMutableArray alloc]init];
    for (int i = 0; i < [Setting sharedInstance].SubCategories.count; i++) {
        SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
        if ([obj.mainCatID isEqualToString:mainID]) {
            [arraySubCategory addObject:obj];
        }
    }
    
    return arraySubCategory;
}
-(BOOL)checkAndDelete:(NSDate*)endDate withOfferID:(NSString*)offerID{
    
    NSDate *today = [[NSDate alloc]init];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:locale];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df setTimeZone:tz];
    NSString *thisMonth = [df stringFromDate:today];
    [df setDateFormat:@"yyyy"];
    [df setTimeZone:tz];
    NSString *thisYear = [df stringFromDate:today];
    NSString *checkMonth;
    NSString *checkYear;
    int yearValue = [thisYear integerValue];
    switch ([thisMonth integerValue]) {
        case 1:
            checkMonth = @"12";
            yearValue--;
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 2:
            checkMonth = @"01";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 3:
            checkMonth = @"02";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 4:
            checkMonth = @"03";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 5:
            checkMonth = @"04";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 6:
            checkMonth = @"05";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 7:
            checkMonth = @"06";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 8:
            checkMonth = @"07";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 9:
            checkMonth = @"08";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 10:
            checkMonth = @"09";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 11:
            checkMonth = @"10";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
        case 12:
            checkMonth = @"11";
            checkYear = [NSString stringWithFormat:@"%d", yearValue];
            break;
            
        default:
            break;
    }
    NSString *checkDateString = [NSString stringWithFormat:@"%@/%@/01", checkYear, checkMonth];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSDate *checkDate = [df dateFromString:checkDateString];
    if ([checkDate compare:endDate] == NSOrderedAscending){
        return TRUE;
    }
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        NSString *delStr = [NSString stringWithFormat:@"DELETE FROM Offers WHERE ID = %@", offerID];
        const char *query_stmt_del = [delStr UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt_del, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Offer is removed");
                
            }
            sqlite3_finalize(statement);
        }
        delStr = [NSString stringWithFormat:@"DELETE FROM Products WHERE OfferID = %@", offerID];
        const char *query_stmt_del1 = [delStr UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt_del1, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Products is removed");
                
            }
            sqlite3_finalize(statement);
        }
        delStr = [NSString stringWithFormat:@"DELETE FROM FavoriteProducts WHERE OfferID = %@", offerID];
        const char *query_stmt_del2 = [delStr UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt_del2, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Products is removed");
                
            }
            sqlite3_finalize(statement);
        }
        delStr = [NSString stringWithFormat:@"DELETE FROM PurchasedProducts WHERE OfferID = %@", offerID];
        const char *query_stmt_del3 = [delStr UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt_del3, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Products is removed");
                
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(projectDB);
    }
    return FALSE;
}
- (void)initInbox{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
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

                    NSString  *listID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *queryString = [NSString stringWithFormat: @"DELETE FROM ReceivedMyListItems WHERE ListID = %@", listID];
                    const char *query_stmt1 = [queryString UTF8String];
                    sqlite3_stmt    *statement1;
                    
                    if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement1, NULL) == SQLITE_OK)
                    {
                        if (sqlite3_step(statement1) == SQLITE_DONE)
                        {
                            NSLog(@"init list Items");
                            
                        }
                        sqlite3_finalize(statement1);
                    }
                }
                sqlite3_finalize(statement);
            }
            querySQL = [NSString stringWithFormat: @"Delete From ReceiveMyList Where CustomerID = \"%@\"", [Setting sharedInstance].customer.customerID];
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"init Inbox");
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }
    
}
- (void)getFriendsFromOnline{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<FriendGetList xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%d</CustomerID>\n"
                             "<Language>%d</Language>\n"
                             "</FriendGetList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID intValue], myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendGetList"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/FriendGetList" forHTTPHeaderField:@"SOAPAction"];
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
    if ([elementName isEqualToString:@"FriendGetListResult"]){
        [[Setting sharedInstance].arrayPendingFriends removeAllObjects];
        [[Setting sharedInstance].arrayRealFriends removeAllObjects];
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"FriendListResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
        myFriend = [[FriendObject alloc]init];
    }
    
    if ([elementName isEqualToString:@"FriendID"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"FriendName"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"IsPendingRequest"]){
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
    if( [elementName isEqualToString:@"FriendGetListResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
        if (errEncounter == TRUE)
        {
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Getting friend list is failure." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            }else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"فشل في الوصول الي قائمة الأصدقاء" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }
            return;
        }

	}
    
    if ([elementName isEqualToString:@"FriendListResult"])
    {
        if (myFriend.isPending == TRUE)
            [[Setting sharedInstance].arrayPendingFriends addObject:myFriend];
        else
            [[Setting sharedInstance].arrayRealFriends addObject:myFriend];
        myFriend = nil;
        recordResults = FALSE;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FriendID"]){
        recordResults = FALSE;
        myFriend.friendID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FriendName"]){
        recordResults = FALSE;
        myFriend.friendName = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"IsPendingRequest"]){
        recordResults = FALSE;
        if ([soapResults isEqualToString:@"true"])
            myFriend.isPending = TRUE;
        else
            myFriend.isPending = FALSE;
        soapResults = nil;
    }
}
@end
