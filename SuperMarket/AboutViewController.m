//
//  AboutViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/2/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "AboutViewController.h"
#import "Setting.h"
#import "CompanyViewController.h"
#import "BranchViewController.h"
#import "AcceptRequestViewController.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize selCompany;
@synthesize img_companyLogo;
@synthesize lb_aboutus;
@synthesize view_info;
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
                friendObj.friendCity = [[Setting sharedInstance] getCityName:cityID];friendObj.friendName = [dic objectForKey:@"FriendName"];
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
    CGRect tmpFrame;
    
    if (IS_IPHONE_4)
    {
        tmpFrame = view_info.frame;
        tmpFrame.origin.y += 20;
        [view_info setFrame:tmpFrame];
    }
    
    tmpFrame = self.lb_company_summary.frame;
    if (IS_IPHONE_4)
    {
        tmpFrame.origin.y = lb_aboutus.frame.origin.y + 30;
        tmpFrame.size.height = view_info.frame.origin.y - tmpFrame.origin.y - 10;
    }
    else if (IS_IPHONE_5){
        tmpFrame.origin.y = lb_aboutus.frame.origin.y + 50;
        tmpFrame.size.height = view_info.frame.origin.y - tmpFrame.origin.y - 20;
    }
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        lb_aboutus.text = @"About Us";
        self.lb_company_summary.textAlignment = NSTextAlignmentLeft;
    }
    else{
        lb_aboutus.text = @"من نحن";
        self.lb_company_summary.textAlignment = NSTextAlignmentRight;
    }
    [self.lb_company_summary setFrame:tmpFrame];
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
//    if (ver_float >= 7.0){
//        if (IS_IPHONE_5)
//        {[self.lb_company_summary setFrame:CGRectMake(8, 120, 304, 112)];
//        [self.view_info setFrame:CGRectMake(0, 252, 320, 247)];
//        }else{
//            [self.lb_company_summary setFrame:CGRectMake(8, 120, 304, 67)];
//            [self.view_info setFrame:CGRectMake(0, 192, 320, 247)];
//        }
//    }
//    else {
        if (IS_IPHONE_5)
        {
            [self.lb_company_summary setFrame:CGRectMake(8, 120, 304, 112)];
            [self.view_info setFrame:CGRectMake(0, 302, 320, 247)];
            if (ver_float >= 7.0){
                [self.lb_company_summary setFrame:CGRectMake(8, 140, 304, 112)];
                [self.view_info setFrame:CGRectMake(0, 272, 320, 247)];
            }
        }
        else{
            [self.lb_company_summary setFrame:CGRectMake(8, 100, 304, 67)];
            [self.view_info setFrame:CGRectMake(0, 222, 320, 247)];
            if (ver_float >= 7.0){
                [self.lb_company_summary setFrame:CGRectMake(8, 120, 304, 67)];
                [self.view_info setFrame:CGRectMake(0, 192, 320, 247)];
            }
        }
//    }
   
}
- (void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    if([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        self.lb_title.text = selCompany.companyNameEn;
    if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        self.lb_title.text = selCompany.companyNameAr;
    /*
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
     NSString *querySQL;
     if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
     querySQL = [NSString stringWithFormat: @"SELECT DescEn, AddressEn, Email, Phone, Fax FROM Companies WHERE NameEn=\"%@\"", self.companyName];
     else
     querySQL = [NSString stringWithFormat: @"SELECT DescAr, AddressAr, Email, Phone, Fax FROM Companies WHERE NameAr=\"%@\"", self.companyName];
     const char *query_stmt = [querySQL UTF8String];
     
     if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
     {
     if (sqlite3_step(statement) != SQLITE_ROW) {
     NSLog(@"not matched");
     UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
     message:@"Please create new project." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     
     [mes show];
     }
     else{
     self.lb_company_summary.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
     self.lb_address.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
     self.lb_email.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
     self.lb_telephone.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
     self.lb_fax.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
     
     }
     sqlite3_finalize(statement);
     }
     sqlite3_close(projectDB);
     }
     
     }
     */
    CGRect tmpRect;
    if([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        self.lb_company_summary.text = selCompany.companyDescEn;
        self.lb_address.text = selCompany.companyAddressEn;
        self.lb_address.textAlignment = NSTextAlignmentLeft;
        self.lb_telephone.textAlignment = NSTextAlignmentLeft;
        self.lb_fax.textAlignment = NSTextAlignmentLeft;
        self.lb_email.textAlignment = NSTextAlignmentLeft;
        self.lbBranch.textAlignment = NSTextAlignmentLeft;
        tmpRect = self.lbTel.frame;
        tmpRect.origin.x = 25;
        self.lbTel.frame = tmpRect;
        self.lbTel.text = @"Tel :";
        
        tmpRect = self.lbFax.frame;
        tmpRect.origin.x = 25;
        self.lbFax.frame = tmpRect;
        self.lbFax.text = @"Fax :";
        
        tmpRect = self.lbEmail.frame;
        tmpRect.origin.x = 25;
        self.lbEmail.frame = tmpRect;
        self.lbEmail.text = @"EMail :";
        
        tmpRect = self.lbAddress.frame;
        tmpRect.origin.x = 25;
        self.lbAddress.frame = tmpRect;
        self.lbAddress.text = @"Address";
        
        tmpRect = self.lbBranch.frame;
        tmpRect.origin.x = 25;
        self.lbBranch.frame = tmpRect;
        self.lbBranch.text = @"Branches";
        
        tmpRect = self.img_branches.frame;
        tmpRect.origin.x = 225;
        self.img_branches.frame = tmpRect;
        
        tmpRect = self.lb_telephone.frame;
        tmpRect.origin.x = 70;
        self.lb_telephone.frame = tmpRect;
        
        tmpRect = self.lb_fax.frame;
        tmpRect.origin.x = 70;
        self.lb_fax.frame = tmpRect;
        
        tmpRect = self.lb_email.frame;
        tmpRect.origin.x = 70;
        self.lb_email.frame = tmpRect;
        
    }
    if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        self.lb_company_summary.text = selCompany.companyDescAr;
        self.lb_address.text = selCompany.companyAddressAr;
        self.lb_address.textAlignment = NSTextAlignmentRight;
        self.lb_telephone.textAlignment = NSTextAlignmentRight;
        self.lb_fax.textAlignment = NSTextAlignmentRight;
        self.lb_email.textAlignment = NSTextAlignmentRight;
        self.lbBranch.textAlignment = NSTextAlignmentRight;
        tmpRect = self.lbTel.frame;
        tmpRect.origin.x = 260;
        self.lbTel.frame = tmpRect;
        self.lbTel.text = @"الهاتف :";
        
        tmpRect = self.lbFax.frame;
        tmpRect.origin.x = 260;
        self.lbFax.frame = tmpRect;
        self.lbFax.text = @"الفاكس :";
        
        tmpRect = self.lbEmail.frame;
        tmpRect.origin.x = 210;
        tmpRect.size.width = 130;
        self.lbEmail.frame = tmpRect;
        self.lbEmail.text = @"البريد الالكتروني :";
        
        tmpRect = self.lbAddress.frame;
        tmpRect.origin.x = 255;
        self.lbAddress.frame = tmpRect;
        self.lbAddress.text = @"العنوان";
        
        tmpRect = self.lbBranch.frame;
        tmpRect.origin.x = 220;
        self.lbBranch.frame = tmpRect;
        self.lbBranch.text = @"الفروع";
        
        tmpRect = self.img_branches.frame;
        tmpRect.origin.x = 25;
        self.img_branches.frame = tmpRect;
        
        tmpRect = self.lb_telephone.frame;
        tmpRect.origin.x = 15;
        self.lb_telephone.frame = tmpRect;
        
        tmpRect = self.lb_fax.frame;
        tmpRect.origin.x = 15;
        self.lb_fax.frame = tmpRect;
        
        tmpRect = self.lb_email.frame;
        tmpRect.origin.x = 15;
        tmpRect.size.width = 190;
        self.lb_email.frame = tmpRect;
    }
    self.lb_email.text = selCompany.companyEmail;
    self.lb_telephone.text = selCompany.companyPhone;
    self.lb_fax.text = selCompany.companyFax;
    [img_companyLogo setImageURL:[NSURL URLWithString:selCompany.companyAboutUsLogo]];
    NSLog(@"view info text = %f, %f, %f, %f", view_info.frame.origin.x, view_info.frame.origin.y, view_info.frame.size.width, view_info.frame.size.height);
    
    NSLog(@"Summary text = %f, %f, %f, %f", self.lb_company_summary.frame.origin.x, self.lb_company_summary.frame.origin.y, self.lb_company_summary.frame.size.width, self.lb_company_summary.frame.size.height);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBranch:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
    BranchViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"BranchView"];
    VC.selCompany = selCompany;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)btnEMail:(id)sender {
    if([MFMailComposeViewController canSendMail]){
        
        MFMailComposeViewController *mail=[[MFMailComposeViewController alloc]init];
        mail.mailComposeDelegate=self;
        NSArray *array = [[NSArray alloc]initWithObjects:selCompany.companyEmail, nil];
        [mail setToRecipients:array];
        [self presentViewController:mail animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Message cannot be sent");
    }
}

- (IBAction)OnBtnTelNum:(id)sender {
    NSString *phoneNum = selCompany.companyPhone;
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"|" withString:@"-"];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *arrayNum = [phoneNum componentsSeparatedByString:@"-"];
    if (arrayNum.count > 0)
    {
     NSString *firstPhone = [arrayNum objectAtIndex:0];
        NSLog(@"phone = %@", firstPhone);
        NSString *phoneNumber = [@"tel://" stringByAppendingString:firstPhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnShare:(id)sender {
    NSMutableArray *arrayShareContent = [[NSMutableArray alloc]init];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        [arrayShareContent addObject:[NSString stringWithFormat:@"Company Name : %@\n", selCompany.companyNameEn]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"Company Description : %@\n", selCompany.companyDescEn]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"Tel : %@\n", selCompany.companyPhone]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"Fax : %@\n", selCompany.companyFax]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"E-Mail : %@\n", selCompany.companyEmail]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"Address : %@\n", selCompany.companyAddressEn]];
    }
    else{
        [arrayShareContent addObject:[NSString stringWithFormat:@"Company Name : %@\n", selCompany.companyNameAr]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"Company Description : %@\n", selCompany.companyDescAr]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"Tel : %@\n", selCompany.companyPhone]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"Fax : %@\n", selCompany.companyFax]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"E-Mail : %@\n", selCompany.companyEmail]];
        [arrayShareContent addObject:[NSString stringWithFormat:@"Address : %@\n", selCompany.companyAddressAr]];
    }
    self.activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact ];
    self.activityViewController = [[UIActivityViewController alloc]
                                   
                                   initWithActivityItems:arrayShareContent applicationActivities:nil];
    
    [self presentViewController:self.activityViewController animated:YES completion:nil];
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
}

@end
