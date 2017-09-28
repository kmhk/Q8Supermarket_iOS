//
//  PurchaseViewController.m
//  SuperMarket
//
//  Created by phoenix on 12/8/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "PurchaseViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "ProductObject.h"
#import "AsyncImageView.h"
#import "CompanyViewController.h"
#import "DetailViewController.h"
#import "ProductsWithCategory.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
@interface PurchaseViewController ()

@end

@implementation PurchaseViewController
@synthesize img_back;
@synthesize arrayCurrentFavorite;
@synthesize arrayExpireFavorite;
@synthesize tableState;
@synthesize favoriteTable;
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
    NSLog(@"%d", removeIndex);
    if(buttonIndex == 1)
    {
        if (tableState == TRUE){
            ProductsWithCategory *catObj = [arrayCurrentFavorite objectAtIndex:removeIndex];
            if (catObj.isCategory == FALSE){
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
                BOOL delFlag = FALSE;
                ProductsWithCategory *tmpObj1 = [arrayCurrentFavorite objectAtIndex:removeIndex - 1];
                ProductsWithCategory *tmpObj2 = [arrayCurrentFavorite objectAtIndex:removeIndex];
                if (removeIndex == arrayCurrentFavorite.count - 1) {
                    tmpObj2 = nil;
                }
                else
                    tmpObj2 = [arrayCurrentFavorite objectAtIndex:removeIndex + 1];
                
                if (tmpObj1.isCategory == TRUE){
                    if (tmpObj2 == nil || tmpObj2.isCategory == TRUE)
                        delFlag = TRUE;
                }
                
                [arrayCurrentFavorite removeObjectAtIndex:removeIndex];
                if (delFlag == TRUE)
                    [arrayCurrentFavorite removeObjectAtIndex:removeIndex - 1];
                
            }
        }
        else{
            ProductsWithCategory *catObj = [arrayExpireFavorite objectAtIndex:removeIndex];
            if (catObj.isCategory == FALSE){
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
                BOOL delFlag = FALSE;
                ProductsWithCategory *tmpObj1 = [arrayExpireFavorite objectAtIndex:removeIndex - 1];
                ProductsWithCategory *tmpObj2 = [arrayExpireFavorite objectAtIndex:removeIndex];
                if (removeIndex == arrayExpireFavorite.count - 1) {
                    tmpObj2 = nil;
                }
                else
                    tmpObj2 = [arrayExpireFavorite objectAtIndex:removeIndex + 1];
                
                if (tmpObj1.isCategory == TRUE){
                    if (tmpObj2 == nil || tmpObj2.isCategory == TRUE)
                        delFlag = TRUE;
                }
                
                [arrayExpireFavorite removeObjectAtIndex:removeIndex];
                if (delFlag == TRUE)
                    [arrayExpireFavorite removeObjectAtIndex:removeIndex - 1];
                
            }
        }
        
        [favoriteTable reloadData];
    }

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
    arrayCurrentFavorite = [[NSMutableArray alloc]init];
    arrayExpireFavorite = [[NSMutableArray alloc]init];
    tableState = TRUE;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float >= 7.0){
        CGRect tmpRect = self.favoriteTable.frame;
        tmpRect.size.height = self.view.frame.size.height - tmpRect.origin.y - 50;
        self.favoriteTable.frame = tmpRect;
    }
//    if (ver_float >= 7.0){
//        if (IS_IPHONE_5){
//        [favoriteTable setFrame:CGRectMake(20, 98, 279, 415)];
//        }
//    }
}
- (void )viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    [arrayCurrentFavorite removeAllObjects];
    [arrayExpireFavorite removeAllObjects];
    [[Setting sharedInstance] loadFavoriteListFromLocalDB:[Setting sharedInstance].customer.customerID];
    [[Setting sharedInstance] loadPurchaseListFromLocalDB:[Setting sharedInstance].customer.customerID];
    CGRect tmpRect;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        img_back.image = [UIImage imageNamed:@"favorite_tab_bg.png"];
        tmpRect = self.btn_current.frame;
        tmpRect.origin.x = 20;
        self.btn_current.frame = tmpRect;
        tmpRect = self.btn_expired.frame;
        tmpRect.origin.x = 172;
        self.btn_expired.frame = tmpRect;
    }
    else{
        img_back.image = [UIImage imageNamed:@"favorite_tab1_bg.png"];
        tmpRect = self.btn_current.frame;
        tmpRect.origin.x = 172;
        self.btn_current.frame = tmpRect;
        tmpRect = self.btn_expired.frame;
        tmpRect.origin.x = 20;
        self.btn_expired.frame = tmpRect;
    }
    
    NSString *companyID = @"";
    NSMutableArray *currentFavor = [[NSMutableArray alloc]init];
    NSMutableArray *expireFavor = [[NSMutableArray alloc]init];
        NSLog(@"%f, %f", self.btn_current.frame.origin.x, self.btn_expired.frame.origin.x);
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        self.lb_title.text = @"My Purchases";
        [self.btn_current setTitle:@"Current Offer" forState:UIControlStateNormal];
        [self.btn_expired setTitle:@"Expired Offer" forState:UIControlStateNormal];
        [self.img_section setImage:[UIImage imageNamed:@"favorite_header.png"]];
    }
    else{
        self.lb_title.text = @"مشترياتي";
        [self.btn_current setTitle:@"العروض الحالية" forState:UIControlStateNormal];
        [self.btn_expired setTitle:@"العروض المنتهية" forState:UIControlStateNormal];
        [self.img_section setImage:[UIImage imageNamed:@"arab_favorite_header.png"]];
    }

    NSLog(@"Purchase table = %f, %f, %f, %f", favoriteTable.frame.origin.x, favoriteTable.frame.origin.y, favoriteTable.frame.size.width, favoriteTable.frame.size.height);
    if ([Setting sharedInstance].myPurchaseList.count > 1){
        for (int i = 0; i < [Setting sharedInstance].myPurchaseList.count - 1; i++){
            ProductObject *tmpObj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
            ProductObject *firstObj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
            int index = i;
            for (int j = i + 1; j < [Setting sharedInstance].myPurchaseList.count; j++){
                ProductObject *secondObj = [[Setting sharedInstance].myPurchaseList objectAtIndex:j];
                NSString *sortNum1 = [[Setting sharedInstance] getSortNum:tmpObj.prodCompanyID withType:@"company"];
                NSString *sortNum2 = [[Setting sharedInstance] getSortNum:secondObj.prodCompanyID withType:@"company"];
                if ([sortNum1 intValue] > [sortNum2 intValue]) {
                    tmpObj = secondObj;
                    index = j;
                    
                }
            }
            
            [[Setting sharedInstance].myPurchaseList replaceObjectAtIndex:i withObject:tmpObj];
            [[Setting sharedInstance].myPurchaseList replaceObjectAtIndex:index withObject:firstObj];
            
        }
    }
    
    for (int i = 0; i < [Setting sharedInstance].myPurchaseList.count; i++)
    {
        ProductObject *obj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
        if ([[Setting sharedInstance] isFavoriteExist:obj.prodID] == TRUE) {
            obj.prodFavoriteProducts = @"true";
        }
        else
            obj.prodFavoriteProducts = @"";
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [df setLocale:locale];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [df setTimeZone:tz];
        obj.prodEndDate = [obj.prodEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDate *endDate = [df dateFromString:obj.prodEndDate];
        NSDate *today = [[NSDate alloc]init];
        
        if ([today compare:endDate] == NSOrderedAscending){
            [currentFavor addObject:obj];
        }
        else{
            [expireFavor addObject:obj];
        }
    }
    for (int i = 0; i < currentFavor.count; i++)
    {
        ProductsWithCategory *catObj = [[ProductsWithCategory alloc]init];
        ProductObject *obj = [currentFavor objectAtIndex:i];
        
        if (![companyID isEqualToString:obj.prodCompanyID])
        {
            catObj.isCategory = TRUE;
            catObj.obj = Nil;
            catObj.mainID = obj.prodMainCatID;
            catObj.subID = obj.prodSubCatID;
            catObj.companyID = obj.prodCompanyID;
            [arrayCurrentFavorite addObject:catObj];
            ProductsWithCategory *conObj = [[ProductsWithCategory alloc]init];
            conObj.isCategory = FALSE;
            conObj.obj = obj;
            [arrayCurrentFavorite addObject:conObj];
        }
        else
        {
            catObj.isCategory = FALSE;
            catObj.obj = obj;
            [arrayCurrentFavorite addObject:catObj];
        }
        companyID = obj.prodCompanyID;
        
    }
    companyID = @"";
    for (int i = 0; i < expireFavor.count; i++)
    {
        ProductsWithCategory *catObj = [[ProductsWithCategory alloc]init];
        ProductObject *obj = [expireFavor objectAtIndex:i];
        
        if (![companyID isEqualToString:obj.prodCompanyID])
        {
            catObj.isCategory = TRUE;
            catObj.obj = Nil;
            catObj.mainID = obj.prodMainCatID;
            catObj.subID = obj.prodSubCatID;
            catObj.companyID = obj.prodCompanyID;
            [arrayExpireFavorite addObject:catObj];
            ProductsWithCategory *conObj = [[ProductsWithCategory alloc]init];
            conObj.isCategory = FALSE;
            conObj.obj = obj;
            [arrayExpireFavorite addObject:conObj];
        }
        else
        {
            catObj.isCategory = FALSE;
            catObj.obj = obj;
            [arrayExpireFavorite addObject:catObj];
        }
        companyID = obj.prodCompanyID;
        
    }
    [favoriteTable reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnCurrentOffer:(id)sender {
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        img_back.image = [UIImage imageNamed:@"favorite_tab_bg.png"];
    else
        img_back.image = [UIImage imageNamed:@"favorite_tab1_bg.png"];
    tableState = TRUE;
    [favoriteTable reloadData];
}

- (IBAction)onBtnExpiredOffer:(id)sender {
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        img_back.image = [UIImage imageNamed:@"favorite_tab1_bg.png"];
    else
        img_back.image = [UIImage imageNamed:@"favorite_tab_bg.png"];
    tableState = FALSE;
    [favoriteTable reloadData];
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

- (IBAction)onBtnRemove:(id)sender {
    NSIndexPath *indexPath;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 7.0)
        indexPath = [favoriteTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    else
        indexPath = [favoriteTable indexPathForCell:(UITableViewCell *)[[[sender superview]superview]superview]];
    removeIndex = indexPath.row;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Confirmation" message:@"Are you sure you want to delete this product?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تأكيد الحذف ؟" message:@"هل انت متأكد من حذف هذا المنتج ؟" delegate:self cancelButtonTitle:@"الغاء" otherButtonTitles:@"موافق", nil];
        [alert show];
    }
   /*
    if (tableState == TRUE){
        ProductsWithCategory *catObj = [arrayCurrentFavorite objectAtIndex:indexPath.row];
        if (catObj.isCategory == FALSE){
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
            BOOL delFlag = FALSE;
            ProductsWithCategory *tmpObj1 = [arrayCurrentFavorite objectAtIndex:indexPath.row - 1];
            ProductsWithCategory *tmpObj2 = [arrayCurrentFavorite objectAtIndex:indexPath.row];
            if (indexPath.row == arrayCurrentFavorite.count - 1) {
                tmpObj2 = nil;
            }
            else
                tmpObj2 = [arrayCurrentFavorite objectAtIndex:indexPath.row + 1];
            
            if (tmpObj1.isCategory == TRUE){
                if (tmpObj2 == nil || tmpObj2.isCategory == TRUE)
                    delFlag = TRUE;
            }
            
            [arrayCurrentFavorite removeObjectAtIndex:indexPath.row];
            if (delFlag == TRUE)
                [arrayCurrentFavorite removeObjectAtIndex:indexPath.row - 1];
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Information"
                                                        message:@"The product is removed from your favorite list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
        }
    }
    else{
        ProductsWithCategory *catObj = [arrayExpireFavorite objectAtIndex:indexPath.row];
        if (catObj.isCategory == FALSE){
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
            BOOL delFlag = FALSE;
            ProductsWithCategory *tmpObj1 = [arrayExpireFavorite objectAtIndex:indexPath.row - 1];
            ProductsWithCategory *tmpObj2 = [arrayExpireFavorite objectAtIndex:indexPath.row];
            if (indexPath.row == arrayExpireFavorite.count - 1) {
                tmpObj2 = nil;
            }
            else
                tmpObj2 = [arrayExpireFavorite objectAtIndex:indexPath.row + 1];
            
            if (tmpObj1.isCategory == TRUE){
                if (tmpObj2 == nil || tmpObj2.isCategory == TRUE)
                    delFlag = TRUE;
            }
            
            [arrayExpireFavorite removeObjectAtIndex:indexPath.row];
            if (delFlag == TRUE)
                [arrayExpireFavorite removeObjectAtIndex:indexPath.row - 1];
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Information"
                                                        message:@"The product is removed from your favorite list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
        }
    }
    
    [favoriteTable reloadData];*/
}

- (IBAction)onBtnPurchase:(id)sender {
    NSIndexPath *indexPath;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 7.0)
        indexPath = [favoriteTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    else
        indexPath = [favoriteTable indexPathForCell:(UITableViewCell *)[[[sender superview]superview]superview]];
    
    ProductsWithCategory *catObj;
    if (tableState == TRUE){
        catObj = [arrayCurrentFavorite objectAtIndex:indexPath.row];
    }
    else
    {
        catObj = [arrayExpireFavorite objectAtIndex:indexPath.row];
    }
    
    
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
            [[Setting sharedInstance] addFavoriteProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID withDate:catObj.obj.prodAddPurchaseDate withCompany:catObj.obj.prodCompanyID withOffer:catObj.obj.OfferID];
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
    
    [favoriteTable reloadData];
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductsWithCategory *catObj;
    if (tableState == TRUE)
        catObj = [arrayCurrentFavorite objectAtIndex:indexPath.row];
    else
        catObj = [arrayExpireFavorite objectAtIndex:indexPath.row];
    if (catObj.isCategory == FALSE){
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
        DetailViewController *vc = [mainstoryboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
        if (tableState == TRUE)
            vc.ProductList = arrayCurrentFavorite;
        else
            vc.ProductList = arrayExpireFavorite;
        vc.indexRow = indexPath.row;
        vc.viewIndex = 3;
        [self presentViewController:vc animated:YES completion:Nil];
    }
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    ProductsWithCategory *catObj;
    if (tableState == TRUE)
        catObj = [arrayCurrentFavorite objectAtIndex:indexPath.row];
    else
        catObj = [arrayExpireFavorite objectAtIndex:indexPath.row];
    
    if (catObj.isCategory == TRUE)
    {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"CompanyNameCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CompanyNameCell"];
        UILabel *lb_company = (UILabel*)[cell viewWithTag:999];
        NSString *companyName = [[Setting sharedInstance] getCompanyName:catObj.companyID];
        lb_company.text = companyName;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            lb_company.textAlignment = NSTextAlignmentLeft;
        else
            lb_company.textAlignment = NSTextAlignmentRight;
        UIImageView *img_section = (UIImageView*)[cell viewWithTag:501];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            [img_section setImage:[UIImage imageNamed:@"favorite_header.png"]];
        else
            [img_section setImage:[UIImage imageNamed:@"arab_favorite_header.png"]];
    }
    else {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FavoriteCell"];
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
        UILabel *lb_prod_title = (UILabel*)[cell viewWithTag:102];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            lb_prod_title.text = obj.prodTitleEn;
            lb_prod_title.textAlignment = NSTextAlignmentLeft;
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            lb_prod_title.text = obj.prodTitleAr;
            lb_prod_title.textAlignment = NSTextAlignmentRight;
        }
        
        UILabel *lb_mainCat = (UILabel*)[cell viewWithTag:103];
        NSString *mainStr = [[Setting sharedInstance] getMainCategoryName:obj.prodMainCatID];
        lb_mainCat.text = mainStr;
        lb_mainCat.textAlignment = NSTextAlignmentLeft;
        
        UILabel *lb_addDate = (UILabel*)[cell viewWithTag:104];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        {
            lb_mainCat.textAlignment = NSTextAlignmentLeft;
            lb_addDate.text = [NSString stringWithFormat:@"Added: %@", obj.prodAddDate];
        }
        else{
            lb_mainCat.textAlignment = NSTextAlignmentRight;
            lb_addDate.text = [NSString stringWithFormat:@"التاريخ: %@", obj.prodAddDate];
        }
        
        
        UILabel *lb_date = (UILabel*)[cell viewWithTag:105];
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
            lb_date.text = [NSString stringWithFormat:@"From %@ To %@, or until stocks", startTimeStr, endTimeStr];
            
        }else{
            [df1 setDateFormat:@"MM/dd"];
            endTimeStr = [df1 stringFromDate:prodEndDate];
            lb_date.text = [NSString stringWithFormat:@"من %@ الي %@, أو حتي نفاد الكمية", startTimeStr, endTimeStr];
            
        }
        
        if (![obj.prodCurPrice isEqualToString:@""]){
            UILabel *lb_price = (UILabel*)[cell viewWithTag:106];
            lb_price.text = [NSString stringWithFormat:@"%@ KD", obj.prodCurPrice];
        }
        UIImageView *imgLine = (UIImageView*)[cell viewWithTag:120];
        imgLine.hidden = YES;
        UILabel *lb_orgPrice = (UILabel*)[cell viewWithTag:107];
        lb_orgPrice.hidden = YES;
        if (![obj.prodOrgPrice isEqualToString:@""]){
            lb_orgPrice.text = [NSString stringWithFormat:@"%@ KD", obj.prodOrgPrice];
            imgLine.hidden = NO;
            lb_orgPrice.hidden = NO;
        }
        UIButton *btnRemove = (UIButton*)[cell viewWithTag:108];
        NSString *imageStr;
        
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            imageStr = @"arab_remove_favorite.png";
        else
            imageStr = @"btn_remove_favorite.png";
        [btnRemove setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [btnRemove setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
        [btnRemove setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
        
        
        UIButton *btnPurchase = (UIButton*)[cell viewWithTag:109];

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
    if (tableState == TRUE)
        return arrayCurrentFavorite.count;
    else
        return arrayExpireFavorite.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableState == TRUE)
    {
        ProductsWithCategory *obj = [arrayCurrentFavorite objectAtIndex:indexPath.row];
        if (obj.isCategory == TRUE){
            return 41;
        }
        else
            return 94;
    }
    else{
        ProductsWithCategory *obj = [arrayExpireFavorite objectAtIndex:indexPath.row];
        if (obj.isCategory == TRUE){
            return 41;
        }
        else
            return 94;
    }
}
@end
