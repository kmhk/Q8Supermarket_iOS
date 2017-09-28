//
//  SearchResultViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/24/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "SearchResultViewController.h"
#import "FriendViewController.h"
#import "PPRevealSideViewController.h"
#import "ProductsWithCategory.h"
#import "DetailViewController.h"
#import "Setting.h"
#import "CompanyViewController.h"
#import "MBProgressHUD.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
@interface SearchResultViewController ()

@end

@implementation SearchResultViewController
@synthesize arrayProductsWithCategory;
@synthesize lb_title;
@synthesize table_Products;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize productObj;
@synthesize productArray;
@synthesize searchResultArray;
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
- (void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    if ([Setting sharedInstance].searchIndex == 3) {
        int myLang;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            myLang = 1;
        else
            myLang = 2;
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<SearchProducts xmlns=\"http://tempuri.org/\">\n"
                                 "<CompanyID>0</CompanyID>\n"
                                 "<OfferID>0</OfferID>\n"
                                 "<MainCategorID>0</MainCategorID>\n"
                                 "<SubCategoryID>%@</SubCategoryID>\n"
                                 "<SearchKeyword></SearchKeyword>\n"
                                 "<PriceFrom>-1</PriceFrom>\n"
                                 "<PriceTo>-1</PriceTo>\n"
                                 "<CityList></CityList>\n"
                                 "<CustomerID>%@</CustomerID>\n"
                                 "<Language>%d</Language>\n"
                                 "</SearchProducts>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [Setting sharedInstance].searchSubCatID, [Setting sharedInstance].customer.customerID, myLang];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=SearchProducts"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/SearchProducts" forHTTPHeaderField:@"SOAPAction"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Searching..."];
        
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if( theConnection )
        {
            webData = [[NSMutableData alloc]init];
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
    }else{
    int resNum = 0;
    [Setting sharedInstance].searchIndex = 2;
    for (int i = 0; i < arrayProductsWithCategory.count; i++)
    {
        ProductsWithCategory *obj = [arrayProductsWithCategory objectAtIndex:i];
        if (obj.isCategory == FALSE)
            resNum++;
    }
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            lb_title.text = [NSString stringWithFormat:@"SearchResult(%d)", resNum];
        else
            lb_title.text = [NSString stringWithFormat:@"نتائج البحث(%d)", resNum];
    /*    [table_Products setBackgroundColor:[UIColor clearColor]];
     UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_back.png"]];
     [tempImageView setFrame:table_Products.frame];
     table_Products.backgroundView = tempImageView;*/
    table_Products.separatorStyle = UITableViewCellSeparatorStyleNone;
    table_Products.backgroundColor = [UIColor clearColor];
    
    NSLog(@"Search Result table = %f, %f, %f, %f", table_Products.frame.origin.x, table_Products.frame.origin.y, table_Products.frame.size.width, table_Products.frame.size.height);
    [[Setting sharedInstance].myFavoriteList removeAllObjects];
    [[Setting sharedInstance].myPurchaseList removeAllObjects];
    [[Setting sharedInstance] loadFavoriteListFromLocalDB:[Setting sharedInstance].customer.customerID];
    [[Setting sharedInstance] loadPurchaseListFromLocalDB:[Setting sharedInstance].customer.customerID];
    for (int i = 0; i < arrayProductsWithCategory.count; i++){
        ProductsWithCategory *obj = [arrayProductsWithCategory objectAtIndex:i];
        if (obj.isCategory == FALSE){
            if ([[Setting sharedInstance] isFavoriteExist:obj.obj.prodID] == FALSE)
            {
                obj.obj.prodFavoriteProducts = @"";
            }
            else{
                obj.obj.prodFavoriteProducts = @"true";
            }
            if ([[Setting sharedInstance] isPurchaseExist:obj.obj.prodID] == FALSE)
            {
                obj.obj.prodPurchasedProducts = @"";
            }
            else{
                obj.obj.prodPurchasedProducts = @"true";
            }
        }
    }
    [table_Products reloadData];
    }
    [Setting sharedInstance].searchSubCatID = @"";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                [[Setting sharedInstance] addPurchaseProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID withDate:catObj.obj.prodAddDate withCompany:catObj.obj.prodCompanyID withOffer:catObj.obj.OfferID];
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

- (IBAction)onFriend:(id)sender {
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

- (IBAction)onBack:(id)sender {
    if ([Setting sharedInstance].isListSearch == TRUE){
        [Setting sharedInstance].isListSearch = FALSE;
        [[Setting sharedInstance].tabBarController setSelectedIndex:2];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
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
        NSString *pro = @"%";
        int percents = (int)(([obj.prodOrgPrice floatValue] - [obj.prodCurPrice floatValue]) / [obj.prodOrgPrice floatValue] * 100);
        lb_percent.text = [pro stringByAppendingString:[NSString stringWithFormat:@"%d", percents]];
        UILabel *lb_prod_title = (UILabel*)[cell viewWithTag:113];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            lb_prod_title.text = obj.prodTitleEn;
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            lb_prod_title.text = obj.prodTitleAr;
        }
        
        UILabel *lb_date = (UILabel*)[cell viewWithTag:114];
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
        
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            [df1 setDateFormat:@"MMM dd"];
            endTimeStr = [df1 stringFromDate:prodEndDate];
            
            lb_prod_title.textAlignment = NSTextAlignmentLeft;
            lb_date.textAlignment = NSTextAlignmentLeft;
            lb_date.text = [NSString stringWithFormat:@"From %@ To %@, or until stocks", startTimeStr, endTimeStr];

        }
        else{
            [df1 setDateFormat:@"MM/dd"];
            endTimeStr = [df1 stringFromDate:prodEndDate];
            
            lb_date.textAlignment = NSTextAlignmentRight;
            lb_prod_title.textAlignment = NSTextAlignmentRight;
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
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                imageStr = @"btn_unsel_favorite.png";
            }
            else{
                imageStr = @"arab_unsel_favorite.png";
            }

        }
        else{
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                imageStr = @"btn_sel_favorite.png";
            }
            else{
                imageStr = @"arab_sel_favorite.png";
            }
            
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
            btnPurchase.alpha = 1.0;
        }
        if ([obj.prodPurchasedProducts isEqualToString:@""]){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                imageStr = @"btn_unsel_purchase.png";
            }
            else{
                imageStr = @"arab_unsel_purchase.png";
            }
            
        }
        else{
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                imageStr = @"btn_sel_purchase.png";
            }
            else{
                imageStr = @"arab_sel_purchase.png";
            }
            
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
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"SearchResult"])
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
    
    if ([elementName isEqualToString:@"SearchProductsResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        searchResultArray = Nil;
        searchResultArray = [[NSMutableArray alloc]init];
        
    }
    
    if ([elementName isEqualToString:@"CategoryID"])
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
    if ([elementName isEqualToString:@"CategoryName"])
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
    if ([elementName isEqualToString:@"ProductID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ProductPhoto"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ProductTitle"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ProductDescription"])
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
    if ([elementName isEqualToString:@"CurrentPrice"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OldPrice"])
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
    if ([elementName isEqualToString:@"MeasureUnit"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"IsPurchsedByCustomer"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"IsAddedToFavorite"])
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
        if (![soapResults isEqualToString:@""]){
            [Setting sharedInstance].errString = soapResults;
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:[Setting sharedInstance].errString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
        }
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"SearchProductsResponse"])
	{
		recordResults = FALSE;
        soapResults = nil;
        [self sortArrayProduct:searchResultArray];
        arrayProductsWithCategory = productArray;
        [self saveProductsInfo];
        int resNum = 0;
        [Setting sharedInstance].searchIndex = 2;
        for (int i = 0; i < arrayProductsWithCategory.count; i++)
        {
            ProductsWithCategory *obj = [arrayProductsWithCategory objectAtIndex:i];
            if (obj.isCategory == FALSE)
                resNum++;
        }
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            lb_title.text = [NSString stringWithFormat:@"SearchResult(%d)", resNum];
        else
            lb_title.text = [NSString stringWithFormat:@"نتائج البحث(%d)", resNum];
        /*    [table_Products setBackgroundColor:[UIColor clearColor]];
         UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_back.png"]];
         [tempImageView setFrame:table_Products.frame];
         table_Products.backgroundView = tempImageView;*/
        table_Products.separatorStyle = UITableViewCellSeparatorStyleNone;
        table_Products.backgroundColor = [UIColor clearColor];
        
        NSLog(@"Search Result table = %f, %f, %f, %f", table_Products.frame.origin.x, table_Products.frame.origin.y, table_Products.frame.size.width, table_Products.frame.size.height);
        [[Setting sharedInstance].myFavoriteList removeAllObjects];
        [[Setting sharedInstance].myPurchaseList removeAllObjects];
        [[Setting sharedInstance] loadFavoriteListFromLocalDB:[Setting sharedInstance].customer.customerID];
        [[Setting sharedInstance] loadPurchaseListFromLocalDB:[Setting sharedInstance].customer.customerID];
        for (int i = 0; i < arrayProductsWithCategory.count; i++){
            ProductsWithCategory *obj = [arrayProductsWithCategory objectAtIndex:i];
            if (obj.isCategory == FALSE){
                if ([[Setting sharedInstance] isFavoriteExist:obj.obj.prodID] == FALSE)
                {
                    obj.obj.prodFavoriteProducts = @"";
                }
                else{
                    obj.obj.prodFavoriteProducts = @"true";
                }
                if ([[Setting sharedInstance] isPurchaseExist:obj.obj.prodID] == FALSE)
                {
                    obj.obj.prodPurchasedProducts = @"";
                }
                else{
                    obj.obj.prodPurchasedProducts = @"true";
                }
            }
        }
        [table_Products reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
	}
    if( [elementName isEqualToString:@"SearchResult"])
	{
		recordResults = FALSE;
        [searchResultArray addObject:productObj];
        soapResults = nil;
        productObj = nil;
	}
    
    if ([elementName isEqualToString:@"CategoryID"])
    {
        recordResults = FALSE;
        productObj.prodMainCatID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"CategoryName"])
    {
        recordResults = FALSE;
        soapResults = nil;
    }
    
    if ([elementName isEqualToString:@"CompanyID"])
    {
        recordResults = FALSE;
        productObj.prodCompanyID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OfferID"])
    {
        recordResults = FALSE;
        productObj.OfferID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductID"])
    {
        recordResults = FALSE;
        productObj.prodID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductPhoto"])
    {
        recordResults = FALSE;
        productObj.prodPhotoURL = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductTitle"])
    {
        recordResults = FALSE;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            productObj.prodTitleAr = soapResults;
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            productObj.prodTitleEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductDescription"])
    {
        recordResults = FALSE;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            productObj.prodDescAr = soapResults;
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
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
    if ([elementName isEqualToString:@"CurrentPrice"])
    {
        recordResults = FALSE;
        productObj.prodCurPrice = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OldPrice"])
    {
        recordResults = FALSE;
        productObj.prodOrgPrice = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Quantity"])
    {
        recordResults = FALSE;
        productObj.prodQuantity = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"MeasureUnit"])
    {
        recordResults = FALSE;
        productObj.prodMeasureID = [[Setting sharedInstance] getMeasureID:soapResults];
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"IsPurchsedByCustomer"])
    {
        recordResults = FALSE;
        if ([soapResults isEqualToString:@"true"])
            productObj.prodPurchasedProducts = soapResults;
        else
            productObj.prodPurchasedProducts = @"";
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"IsAddedToFavorite"])
    {
        recordResults = FALSE;
        if ([soapResults isEqualToString:@"true"])
            productObj.prodFavoriteProducts = soapResults;
        else
            productObj.prodFavoriteProducts = @"";
        soapResults = nil;
    }
}
-(void)saveProductsInfo{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        for (int i = 0; i < searchResultArray.count; i++) {
            ProductObject *obj = [searchResultArray objectAtIndex:i];
            BOOL flag = TRUE;
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Products WHERE ID = \"%@\"", obj.prodID];
            
            const char *query_stmt1 = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) != SQLITE_ROW)
                {
                    flag = FALSE;
                    
                }
                sqlite3_finalize(statement);
            }
            if (flag == FALSE) {
                querySQL = [NSString stringWithFormat: @"INSERT INTO Products (ID, OfferID, Quantity, MainCatID, MeasureID, SubCatID, OrgPrice, Price, Photo, DescAr, DescEn, StartDate, EndDate, BranchList, VisitsCount, TitleAr, TitleEn, IsActive, lastUpdateTime) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", obj.prodID, obj.OfferID, obj.prodQuantity, obj.prodMainCatID, obj.prodMeasureID, obj.prodSubCatID, obj.prodOrgPrice, obj.prodCurPrice, obj.prodPhotoURL, obj.prodDescAr, obj.prodDescEn, obj.prodStartDate, obj.prodEndDate, obj.prodBranchList, obj.prodVisitsCount, obj.prodTitleAr, obj.prodTitleEn, obj.prodIsActive, obj.prodlastUpdateTime];
                
                query_stmt1 = [querySQL UTF8String];
                
                if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"Products success");
                        
                    }
                    sqlite3_finalize(statement);
                }
            }
            flag = TRUE;
        }
        sqlite3_close(projectDB);
    }
}
-(void)sortArrayProduct:(NSMutableArray*)_arrayProduct{
    if (searchResultArray.count > 1){
        for (int i = 0; i < searchResultArray.count - 1; i++){
            ProductObject *tmpObj = [searchResultArray objectAtIndex:i];
            ProductObject *firstObj = [searchResultArray objectAtIndex:i];
            int index = i;
            for (int j = i + 1; j < searchResultArray.count; j++){
                ProductObject *secondObj = [searchResultArray objectAtIndex:j];
                NSString *sortNum1 = [[Setting sharedInstance] getSortNum:tmpObj.prodMainCatID withType:@"main"];
                NSString *sortNum2 = [[Setting sharedInstance] getSortNum:secondObj.prodMainCatID withType:@"main"];
                if ([sortNum1 intValue] > [sortNum2 intValue]) {
                    tmpObj = secondObj;
                    index = j;
                    
                }
            }
            
            [searchResultArray replaceObjectAtIndex:i withObject:tmpObj];
            [searchResultArray replaceObjectAtIndex:index withObject:firstObj];
            
        }
    }
    int mainCategory = -1;
    productArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < searchResultArray.count; i++){
        ProductObject *obj = [searchResultArray objectAtIndex:i];
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
            [productArray addObject:catObj];
            ProductsWithCategory *conObj = [[ProductsWithCategory alloc]init];
            conObj.isCategory = FALSE;
            conObj.obj = obj;
            [productArray addObject:conObj];
        }
        else
        {
            catObj.isCategory = FALSE;
            catObj.obj = obj;
            [productArray addObject:catObj];
        }
        mainCategory = [obj.prodMainCatID intValue];
    }
    
}
@end
