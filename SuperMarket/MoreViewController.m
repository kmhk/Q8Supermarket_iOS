//
//  MoreViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "MoreViewController.h"
#import "MyAccountViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "RegisterViewController.h"
#import "LangViewController.h"
#import "PurchaseViewController.h"
#import "AboutUsViewController.h"
#import "CompanyViewController.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize myTableView;
@synthesize itemList;
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
            {
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
    itemList = [[NSMutableArray alloc]init];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        [itemList addObject:@"My Account"];
        [itemList addObject:@"My Purchases"];
        [itemList addObject:@"Change Language"];
        [itemList addObject:@"About Us"];
        [itemList addObject:@"Rate this App"];
    }
    else{
        [itemList addObject:@"حسابي"];
        [itemList addObject:@"مشترياتي"];
        [itemList addObject:@"تغيير اللغة"];
        [itemList addObject:@"من نحن"];
        [itemList addObject:@"قيم هذا البرنامج"];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        self.btnLogout.userInteractionEnabled = NO;
        self.btnLogout.alpha = 0.5;
    }
    else{
        self.btnLogout.userInteractionEnabled = YES;
        self.btnLogout.alpha = 1.0;
    }
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
    {
        self.lb_title.text = @"المزيد";
        [self.btnLogout setBackgroundImage:[UIImage imageNamed:@"arab_logout.png"] forState:UIControlStateNormal];
        [self.btnLogout setBackgroundImage:[UIImage imageNamed:@"arab_logout.png"] forState:UIControlStateHighlighted];
        [self.btnLogout setBackgroundImage:[UIImage imageNamed:@"arab_logout.png"] forState:UIControlStateSelected];
    }
    else
    {
        self.lb_title.text = @"More";
        [self.btnLogout setBackgroundImage:[UIImage imageNamed:@"btn_logout.png"] forState:UIControlStateNormal];
        [self.btnLogout setBackgroundImage:[UIImage imageNamed:@"btn_logout.png"] forState:UIControlStateHighlighted];
        [self.btnLogout setBackgroundImage:[UIImage imageNamed:@"btn_logout.png"] forState:UIControlStateSelected];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"MoreItemCell"];
    if (cell == Nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreItemCell"];
    
    UILabel *lb_item = (UILabel*)[cell viewWithTag:101];
    NSString *strItem = [itemList objectAtIndex:indexPath.row];
    
    lb_item.text = strItem;
    UIButton *button = (UIButton*)[cell viewWithTag:102];
    CGRect tmpRect;
    tmpRect = button.frame;
    NSLog(@"%f", tmpRect.origin.x);
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        lb_item.textAlignment = NSTextAlignmentLeft;
        [button setBackgroundImage:[UIImage imageNamed:@"mylist_arrow.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"mylist_arrow.png"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"mylist_arrow.png"] forState:UIControlStateSelected];
        tmpRect.origin.x = 265;
    }
    else{
        lb_item.textAlignment = NSTextAlignmentRight;
        [button setBackgroundImage:[UIImage imageNamed:@"mylist_arrow_r.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"mylist_arrow_r.png"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"mylist_arrow_r.png"] forState:UIControlStateSelected];
        tmpRect.origin.x = 10;
    }
    button.frame = tmpRect;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return itemList.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
            if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
                MyAccountViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"AccountView"];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else{

                RegisterViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"RegisterView"];
                    [self.navigationController pushViewController:VC animated:YES];

            }
        }
            break;
        case 1:
        {
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
            
            PurchaseViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"PurchaseView"];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:
        {/*
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                LangViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"LanguageView"];
                [self.navigationController pushViewController:VC animated:YES];*/
            [[Setting sharedInstance].tabBarController.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 3:
        {
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
            
            AboutUsViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"AboutUsView"];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 4:
        {
            #define YOUR_APP_STORE_ID 823629077 // Change this one to your app ID
            
//            static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
//            static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
//            
            static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
            static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
            
//            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f){
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:iOS7AppStoreURLFormat, YOUR_APP_STORE_ID]]]; // Would launch the app store and open the app ID popup
//            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:iOSAppStoreURLFormat, YOUR_APP_STORE_ID]]]; // Would launch the app store and open the app ID popup
                
//            }
            
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)onBtnLogout:(id)sender {
    [Setting sharedInstance].customer = [[CustomerObject alloc] init];
    [Setting sharedInstance].customer.customerID = @"0";

    self.btnLogout.userInteractionEnabled = NO;
    self.btnLogout.alpha = 0.5;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"customerID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FullName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mobile"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MobileID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"StateID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AreaID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Address"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Password"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserType"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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


@end
