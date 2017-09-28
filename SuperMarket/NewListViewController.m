//
//  NewListViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "NewListViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "MyListItem.h"
#import "MBProgressHUD.h"
#import "CompanyViewController.h"
#import "AcceptRequestViewController.h"
#import "AppDelegate.h"
@interface NewListViewController ()
@property (nonatomic, assign) BOOL fflag;
@end

@implementation NewListViewController
@synthesize fflag;
@synthesize toFriendView;
@synthesize friendTable;
@synthesize addlistTable;
@synthesize arrayMyList;
@synthesize arraySubCategories;
@synthesize measurePicker;
@synthesize selectionView;
@synthesize arrayMeasure;
@synthesize arrayQuantity;
@synthesize selMeasureIndex;
@synthesize selQuantyIndex;
@synthesize selItem;
@synthesize btn_done;
@synthesize mainNum;
@synthesize arrayCheckedFriends;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize errEncounter;
@synthesize friendIDs;
@synthesize subcatName;
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
    if (fflag == TRUE) {
        fflag = FALSE;
        return;
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
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
          //  [self onBtnCancel:Nil];
            return;
        }
        
    }
    else{
            [arrayCheckedFriends removeAllObjects];
            for (int i = 0; i < [Setting sharedInstance].arrayRealFriends.count; i++) {
                NSString *strChecked = @"no";
                [arrayCheckedFriends addObject:strChecked];
            }
            [self.view bringSubviewToFront:toFriendView];
            [friendTable reloadData];
            toFriendView.hidden = NO;
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    fflag = TRUE;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didPush)
                                                 name:@"PushDid"
                                               object:nil];
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
    if (ver_float >= 7.0){
        CGRect tmpRect = self.addlistTable.frame;
        tmpRect.size.height = self.view.frame.size.height - tmpRect.origin.y - 50;
        self.addlistTable.frame = tmpRect;
    }
//    if (ver_float >= 7.0){
//        if (IS_IPHONE_5){
//        [addlistTable setFrame:CGRectMake(13, 100, 293, 413)];
//        }
//    }
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    

    [self.tListName setValue:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    mainNum = 0;
    self.tListName.text = @"";
	// Do any additional setup after loading the view.
    CGRect tmpRect = selectionView.frame;
    tmpRect.origin.y = self.view.frame.size.height;
    [selectionView setFrame:tmpRect];
    arrayMyList = [[NSMutableArray alloc]init];
    toFriendView.hidden = YES;
    arraySubCategories = [[NSMutableArray alloc]init];
    for (int i = 0; i < [Setting sharedInstance].SubCategories.count; i++) {
        MyListItem *item = [[MyListItem alloc]init];
        SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
        item.isMainCategory = FALSE;
        item.isSelected = FALSE;
        item.isOpened =FALSE;
        item.itemID = obj.mainCatID;
        item.itemSubID = obj.subCatID;
        item.measureQuantity = @"";
        item.measureUnit = @"";
        item.selectedItems = 0;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
            item.itemName = obj.subCatEn;
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            item.itemName = obj.subCatAr;
        [arraySubCategories addObject:item];
    }
    for (int i = 0; i < [Setting sharedInstance].MainCategories.count; i++) {
        MainCategory *obj = [[Setting sharedInstance].MainCategories objectAtIndex:i];
        MyListItem *item = [[MyListItem alloc]init];
        item.isMainCategory = TRUE;
        item.selectedItems = 0;
        item.isSelected = FALSE;
        item.isOpened = FALSE;
        item.itemID = obj.mainCatID;
        item.itemSubID = @"";
        item.measureQuantity = @"";
        item.measureUnit = @"";
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
            item.itemName = obj.mainCatNameEn;
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            item.itemName = obj.mainCatNameAr;
        [arrayMyList addObject:item];
        
    }
    arrayQuantity = [[NSMutableArray alloc]init];
    for (int i = 1; i < 101; i++)
        [arrayQuantity addObject:[NSString stringWithFormat:@"%d", i]];
    arrayMeasure = [[NSMutableArray alloc]init];
    arrayCheckedFriends = [[NSMutableArray alloc]init];
    btn_done.alpha = 0.5;
    btn_done.userInteractionEnabled = NO;
    [[Setting sharedInstance].arrayPendingFriends removeAllObjects];
    [[Setting sharedInstance].arrayRealFriends removeAllObjects];
    [[Setting sharedInstance] getFriendsFromOnline];


}
- (void)viewWillAppear:(BOOL)animated{
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        self.tListName.textAlignment = NSTextAlignmentLeft;
    }
    else
        self.tListName.textAlignment = NSTextAlignmentRight;
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
    NSLog(@"new list table = %f, %f, %f, %f", addlistTable.frame.origin.x, addlistTable.frame.origin.y, addlistTable.frame.size.width, addlistTable.frame.size.height);
    [measurePicker setBackgroundColor:[UIColor whiteColor]];
    CGRect tmpRect;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        self.lb_header.text = @"Add New List";
        self.tListName.placeholder = @"Add list name...";
        [self.btn_done setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateNormal];
        [self.btn_done setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateSelected];
        [self.btn_done setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateHighlighted];

        [self.btn_add setBackgroundImage:[UIImage imageNamed:@"btn_add_measure.png"] forState:UIControlStateNormal];
        [self.btn_add setBackgroundImage:[UIImage imageNamed:@"btn_add_measure.png"] forState:UIControlStateSelected];
        [self.btn_add setBackgroundImage:[UIImage imageNamed:@"btn_add_measure.png"] forState:UIControlStateHighlighted];
        
        [self.btn_cancel setBackgroundImage:[UIImage imageNamed:@"btn_cancel_measure.png"] forState:UIControlStateNormal];
        [self.btn_cancel setBackgroundImage:[UIImage imageNamed:@"btn_cancel_measure.png"] forState:UIControlStateSelected];
        [self.btn_cancel setBackgroundImage:[UIImage imageNamed:@"btn_cancel_measure.png"] forState:UIControlStateHighlighted];
        
        [self.btn_can setBackgroundImage:[UIImage imageNamed:@"btn_cancel_friend.png"] forState:UIControlStateNormal];
        [self.btn_can setBackgroundImage:[UIImage imageNamed:@"btn_cancel_friend.png"] forState:UIControlStateSelected];
        [self.btn_can setBackgroundImage:[UIImage imageNamed:@"btn_cancel_friend.png"] forState:UIControlStateHighlighted];
        [self.btn_send setBackgroundImage:[UIImage imageNamed:@"btn_send_friend.png"] forState:UIControlStateNormal];
        [self.btn_send setBackgroundImage:[UIImage imageNamed:@"btn_send_friend.png"] forState:UIControlStateSelected];
        [self.btn_send setBackgroundImage:[UIImage imageNamed:@"btn_send_friend.png"] forState:UIControlStateHighlighted];
        
        tmpRect = self.btn_can.frame;
        tmpRect.origin.x = 160;
        self.btn_can.frame = tmpRect;

        tmpRect = self.btn_send.frame;
        tmpRect.origin.x = 34;
        self.btn_send.frame = tmpRect;

        [self.img_header setImage:[UIImage imageNamed:@"send_to_friend.png"]];
        
    }
    else{
        self.lb_header.text = @"   إضافة قائمة جديدة";
        self.tListName.placeholder = @"إضافة اسم القائمة...";
        [self.btn_done setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateNormal];
        [self.btn_done setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateSelected];
        [self.btn_done setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateHighlighted];
        
        [self.btn_add setBackgroundImage:[UIImage imageNamed:@"arab_add_measure.png"] forState:UIControlStateNormal];
        [self.btn_add setBackgroundImage:[UIImage imageNamed:@"arab_add_measure.png"] forState:UIControlStateSelected];
        [self.btn_add setBackgroundImage:[UIImage imageNamed:@"arab_add_measure.png"] forState:UIControlStateHighlighted];
        
        [self.btn_cancel setBackgroundImage:[UIImage imageNamed:@"arab_cancel_measure.png"] forState:UIControlStateNormal];
        [self.btn_cancel setBackgroundImage:[UIImage imageNamed:@"arab_cancel_measure.png"] forState:UIControlStateSelected];
        [self.btn_cancel setBackgroundImage:[UIImage imageNamed:@"arab_cancel_measure.png"] forState:UIControlStateHighlighted];
        [self.btn_can setBackgroundImage:[UIImage imageNamed:@"arab_cancel_friend.png"] forState:UIControlStateNormal];
        [self.btn_can setBackgroundImage:[UIImage imageNamed:@"arab_cancel_friend.png"] forState:UIControlStateSelected];
        [self.btn_can setBackgroundImage:[UIImage imageNamed:@"arab_cancel_friend.png"] forState:UIControlStateHighlighted];
        [self.btn_send setBackgroundImage:[UIImage imageNamed:@"arab_send_friend.png"] forState:UIControlStateNormal];
        [self.btn_send setBackgroundImage:[UIImage imageNamed:@"arab_send_friend.png"] forState:UIControlStateSelected];
        [self.btn_send setBackgroundImage:[UIImage imageNamed:@"arab_send_friend.png"] forState:UIControlStateHighlighted];
        
        tmpRect = self.btn_can.frame;
        tmpRect.origin.x = 34;
        self.btn_can.frame = tmpRect;
        
        tmpRect = self.btn_send.frame;
        tmpRect.origin.x = 160;
        self.btn_send.frame = tmpRect;

        
        [self.img_header setImage:[UIImage imageNamed:@"arabsend_to_friend.png"]];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        selQuantyIndex = row;
    }
    else if (component == 1)
        selMeasureIndex = row;

    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //I have taken two components thats why I have set frame of my "label" accordingly. you can set the frame of the label depends on number of components you have...
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 130, 45)];
    
    //For right alignment of text,You can set the UITextAlignmentRight of the label.
    //No need to set alignment to UITextAlignmentLeft because it is defaulted to picker data display behavior.
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        if (component == 1)
            [label setTextAlignment:NSTextAlignmentLeft];
        else
            [label setTextAlignment:NSTextAlignmentCenter];
    }
    else
    {
        if (component == 1)
            [label setTextAlignment:NSTextAlignmentRight];
        else
            [label setTextAlignment:NSTextAlignmentCenter];
    }
    label.opaque=NO;
    label.backgroundColor=[UIColor clearColor];
    label.textColor = [UIColor blackColor];
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    label.font = font;
    if(component == 0)
    {
        [label setText:[NSString stringWithFormat:@"%@",[arrayQuantity objectAtIndex:row]]];
    }
    else if(component == 1)
    {
        [label setText:[NSString stringWithFormat:@"%@", [arrayMeasure objectAtIndex:row]]];
    }
    return label;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return [arrayQuantity count];
    else if (component == 1)
        return [arrayMeasure count];
    return -1;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
        return [arrayQuantity objectAtIndex:row];
    else
        return [arrayMeasure objectAtIndex:row];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnDone:(id)sender {
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]) {
        fflag = TRUE;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"You must login to save your list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@" يجب عليك تسجيل الدخول لحفظ القائمة" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];

        }
    }
    else{
        if ([self.tListName.text isEqualToString:@""]) {
            fflag = TRUE;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Please enter your list name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
                [mes show];
            }else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@" الرجاء تسمية القائمة" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }
            return;
        }
        fflag = FALSE;
        [self.tListName resignFirstResponder];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Confirmation" message:@"Are you sure you want to send this list to your friends?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"إرسال تأكيد"
                                                            message:@"هل أنت متأكد أنك تريد إرسال هذه القائمة إلى أصدقائك؟" delegate:self cancelButtonTitle:@"الغاء" otherButtonTitles:@"موافق", nil];
            [alert show];
        }
      
    }
}

- (IBAction)onBtnAdd:(id)sender {
}

- (IBAction)onBtnList:(id)sender {
    [self.tListName resignFirstResponder];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)onAddMeasure:(id)sender {
    
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
    }else{
        MyListItem *item = [arrayMyList objectAtIndex:selItem];
        item.isSelected = TRUE;
        item.measureQuantity = [arrayQuantity objectAtIndex:selQuantyIndex];
        item.measureUnit = [[Setting sharedInstance] getMeasureID:[arrayMeasure objectAtIndex:selMeasureIndex]];
        for (int i = 0; i < arrayMyList.count; i++) {
            MyListItem *item1 = [arrayMyList objectAtIndex:i];
            if (item1.isMainCategory == TRUE && [item1.itemID isEqualToString:item.itemID])
            {
                item1.selectedItems++;
                [arrayMyList replaceObjectAtIndex:i withObject:item1];
            }
        }
        [UIView beginAnimations:@"AdResize" context:nil];
        [UIView setAnimationDuration:0.7];
    
        CGRect newFrame = CGRectMake(selectionView.frame.origin.x, self.view.frame.size.height, selectionView.frame.size.width, selectionView.frame.size.height);
        
        selectionView.frame = newFrame;
        [UIView commitAnimations];
    btn_done.alpha = 1.0;
    btn_done.userInteractionEnabled = YES;
    [addlistTable reloadData];
    }
}
- (IBAction)onCancelMeasure:(id)sender {
    
    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];
    
    CGRect newFrame = CGRectMake(selectionView.frame.origin.x, self.view.frame.size.height, selectionView.frame.size.width, selectionView.frame.size.height);
    
    selectionView.frame = newFrame;
    [UIView commitAnimations];
}

- (IBAction)onBtnPlus:(id)sender {
    [self.tListName resignFirstResponder];
    NSIndexPath *indexPath;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 7.0)
        indexPath = [addlistTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    else
        indexPath = [addlistTable indexPathForCell:(UITableViewCell *)[[[sender superview]superview]superview]];
 
    
    MyListItem *item = [arrayMyList objectAtIndex:indexPath.row];
    if (item.isSelected == TRUE){
        item.isSelected = FALSE;
        int selItems = 0;
        for (int i = 0; i < arrayMyList.count; i++) {
            MyListItem *item1 = [arrayMyList objectAtIndex:i];
            if (item1.isMainCategory == TRUE && [item1.itemID isEqualToString:item.itemID])
            {
                item1.selectedItems--;
                [arrayMyList replaceObjectAtIndex:i withObject:item1];
            }
            if (item1.isSelected == TRUE)
                selItems++;
        }
        if (selItems == 0) {
            btn_done.alpha = 0.5;
            btn_done.userInteractionEnabled = NO;
        }
        [addlistTable reloadData];
    }
    else{
        [arrayMeasure removeAllObjects];
        selMeasureIndex = 0;
        selQuantyIndex = 0;
        selItem = indexPath.row;

        subcatName.text = item.itemName;
        for (int i = 0; i < arraySubCategories.count; i++) {
            SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
            if ([obj.subCatID isEqualToString:item.itemSubID]) {
                NSString *str = obj.subCatMeasures;
                NSArray *measures = [str componentsSeparatedByString:@","];
                for (int j = 0; j < measures.count; j++) {
                    NSString *unitStr = [measures objectAtIndex:j];
                    if (![[[Setting sharedInstance] getMeasure:unitStr] isEqualToString:@"Unknown"])
                        [arrayMeasure addObject:[[Setting sharedInstance] getMeasure:unitStr]];
                }
            }
        }
        [measurePicker reloadAllComponents];
        selectionView.hidden = NO;
        [self.view bringSubviewToFront:selectionView];
        [UIView beginAnimations:@"AdResize" context:nil];
        [UIView setAnimationDuration:0.7];
        
        CGRect newFrame = CGRectMake(selectionView.frame.origin.x, self.view.frame.size.height - selectionView.frame.size.height, selectionView.frame.size.width, selectionView.frame.size.height);
        
        selectionView.frame = newFrame;
        [UIView commitAnimations];
    }
   
}

- (IBAction)onBtnSend:(id)sender {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSDate *addDate = [[NSDate alloc]init];
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
    [df1 setDateFormat:@"dd/MM/yyyy"];
    NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df1 setLocale:locale1];
    NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df1 setTimeZone:tz1];
    NSString *orderDate = [df1 stringFromDate:addDate];
    NSString *receiversName = @"";
    friendIDs = @"";
  
    int sendNum = 0;
    for (int i = 0; i < arrayCheckedFriends.count; i++){
        NSString *checked = [arrayCheckedFriends objectAtIndex:i];
        if ([checked isEqualToString:@"yes"])
        {
            FriendObject *obj = [[Setting sharedInstance].arrayRealFriends objectAtIndex:i];
            receiversName = [receiversName stringByAppendingString:[NSString stringWithFormat:@"%@, ",obj.friendName]];
            friendIDs = [friendIDs stringByAppendingString:[NSString stringWithFormat:@"%@,", obj.friendID]];
            sendNum++;
        }
    }
    if (sendNum == 0){
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please select your friends to send this list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء اختيار صديق لارسال القائمة " delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            [mes show];
            
        }
        return;

    }
    NSString *requestStringForItems = @"";
    
    receiversName = [receiversName substringToIndex:receiversName.length - 2];
    friendIDs = [friendIDs substringToIndex:friendIDs.length - 1];
    
    NSLog(@"receiversName = %@", receiversName);
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        NSString *queryString = [NSString stringWithFormat: @"INSERT INTO MyList (Title, OrderDate, CustomerID, ReceiversList) VALUES (\"%@\", \"%@\", \"%@\", \"%@, me\")", self.tListName.text, orderDate, [Setting sharedInstance].customer.customerID, receiversName];
        const char *query_stmt_del = [queryString UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt_del, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"mylist success, when send");
                
            }
            sqlite3_finalize(statement);
        }
        queryString = [NSString stringWithFormat: @"SELECT * FROM MyList"];
        const char *query_stmt = [queryString UTF8String];
        NSString *listID;
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                listID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
        }
        for (int i = 0; i < arraySubCategories.count; i++) {
            MyListItem *item = [arraySubCategories objectAtIndex:i];
            if (item.isSelected == TRUE){
                BOOL isDone = FALSE;
                
                queryString = [NSString stringWithFormat: @"INSERT INTO MyListItems (ListID, MainCatID, SubCatID, MeasureID, Quantity, IsDone) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\")", listID, item.itemID, item.itemSubID, item.measureUnit, item.measureQuantity, isDone];
                
                query_stmt = [queryString UTF8String];
                
                if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"mylistitem success");
                        
                    }
                    sqlite3_finalize(statement);
                }
                requestStringForItems = [requestStringForItems stringByAppendingString:@"<MyListWebItem>\n"];
                requestStringForItems = [requestStringForItems stringByAppendingString:[NSString stringWithFormat:@"<MainCategoryID>%@</MainCategoryID>\n", item.itemID]];
                requestStringForItems = [requestStringForItems stringByAppendingString:[NSString stringWithFormat:@"<SubCategoryID>%@</SubCategoryID>\n", item.itemSubID]];
                requestStringForItems = [requestStringForItems stringByAppendingString:[NSString stringWithFormat:@"<MeasureUnitID>%@</MeasureUnitID>\n", item.measureUnit]];
                requestStringForItems = [requestStringForItems stringByAppendingString:[NSString stringWithFormat:@"<Quantity>%@</Quantity>\n", item.measureQuantity]];
                requestStringForItems = [requestStringForItems stringByAppendingString:@"</MyListWebItem>\n"];
            }
        }
        sqlite3_close(projectDB);
    }
    NSString *myLang;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = @"1";
    }
    else {
        myLang = @"2";
    }

    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<MyListCreateNew xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%d</CustomerID>\n"
                             "<ListTitle>%@</ListTitle>\n"
                             "<Language>%d</Language>\n"
                             "<ListItems>\n%@</ListItems>\n"
                             "</MyListCreateNew>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], self.tListName.text, [myLang intValue], requestStringForItems];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MyListCreateNew"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/MyListCreateNew" forHTTPHeaderField:@"SOAPAction"];
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
    toFriendView.hidden = YES;
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
	[MBProgressHUD hideHUDForView:self.view animated:YES];
    toFriendView.hidden = YES;
   
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
    if ([elementName isEqualToString:@"NewListID"]){
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
    if ([elementName isEqualToString:@"NewListID"])
    {
        NSString *onlineListID = soapResults;
        NSLog(@"online list id = %@\n", onlineListID);
        recordResults = FALSE;
        soapResults = Nil;
        
        if ([onlineListID class] != [NSNull class]){
            
            NSString *myLang;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                myLang = @"1";
            else
                myLang = @"2";
            NSString *soapMessage = [NSString stringWithFormat:
                                     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                     "<soap:Body>\n"
                                     "<MyListSendToFriends xmlns=\"http://tempuri.org/\">\n"
                                     "<ListID>%d</ListID>\n"
                                     "<Language>%d</Language>\n"
                                     "<FriendIDs>%@</FriendIDs>\n"
                                     "<SenderCustomerID>%@</SenderCustomerID>\n"
                                     "</MyListSendToFriends>\n"
                                     "</soap:Body>\n"
                                     "</soap:Envelope>\n", [onlineListID intValue], [myLang intValue], friendIDs, [Setting sharedInstance].customer.customerID];
            
            NSLog(@"soapMessage = %@\n", soapMessage);
            
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MyListSendToFriends"];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/MyListSendToFriends" forHTTPHeaderField:@"SOAPAction"];
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
    if ([elementName isEqualToString:@"MyListSendToFriendsResult"]){
        recordResults = FALSE;
        soapResults = Nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)onBtnCancel:(id)sender {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSDate *addDate = [[NSDate alloc]init];
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
    [df1 setDateFormat:@"dd/MM/yyyy"];
    NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df1 setLocale:locale1];
    NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df1 setTimeZone:tz1];
    NSString *orderDate = [df1 stringFromDate:addDate];
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        NSString *queryString = [NSString stringWithFormat: @"INSERT INTO MyList (Title, OrderDate, CustomerID, ReceiversList) VALUES (\"%@\", \"%@\", \"%@\", \"me\")", self.tListName.text, orderDate, [Setting sharedInstance].customer.customerID];
        const char *query_stmt_del = [queryString UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt_del, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"When cancel, list save success");
                
            }
            sqlite3_finalize(statement);
        }
       
        
        queryString = [NSString stringWithFormat: @"SELECT * FROM MyList"];
        const char *query_stmt = [queryString UTF8String];
        NSString *listID;
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                listID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
        }
         queryString = [NSString stringWithFormat: @"INSERT INTO ReceivedMyList (ListID, Title, OrderDate, CustomerID, SenderName) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"me\")", listID, self.tListName.text, orderDate, [Setting sharedInstance].customer.customerID];
        const char *query_stmt1 = [queryString UTF8String];
        if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"When cancel, list save success");
                
            }
            sqlite3_finalize(statement);
        }
        
        for (int i = 0; i < arraySubCategories.count; i++) {
            MyListItem *item = [arraySubCategories objectAtIndex:i];
            if (item.isSelected == TRUE){
                BOOL isDone = FALSE;
                
                queryString = [NSString stringWithFormat: @"INSERT INTO MyListItems (ListID, MainCatID, SubCatID, MeasureID, Quantity, IsDone) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\")", listID, item.itemID, item.itemSubID, item.measureUnit, item.measureQuantity, isDone];
                
                query_stmt = [queryString UTF8String];

                if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"When cancel, listitem save success");
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                queryString = [NSString stringWithFormat: @"INSERT INTO ReceivedMyListItems (ListID, MainCatID, SubCatID, MeasureID, Quantity, IsDone) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\")", listID, item.itemID, item.itemSubID, item.measureUnit, item.measureQuantity, isDone];
                
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
    toFriendView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tListName resignFirstResponder];
    if (tableView == friendTable){
        NSString *str = [arrayCheckedFriends objectAtIndex:indexPath.row];
        if ([str isEqualToString:@"no"])
            str = @"yes";
        else
            str = @"no";
        [arrayCheckedFriends replaceObjectAtIndex:indexPath.row withObject:str];
        
    }
    else {
    MyListItem *item = [arrayMyList objectAtIndex:indexPath.row];
    if (item.isMainCategory == TRUE) {
        if (item.isOpened == TRUE) {
            item.isOpened = FALSE;
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < arraySubCategories.count; i++) {
                MyListItem *item1 = [arraySubCategories objectAtIndex:i];
                if ([item1.itemID isEqualToString:item.itemID])
                    [subArray addObject:item1];
            }
            [arrayMyList removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, subArray.count)]];
        }
        else{
            item.isOpened = TRUE;
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < arraySubCategories.count; i++) {
                MyListItem *item1 = [arraySubCategories objectAtIndex:i];
                if ([item1.itemID isEqualToString:item.itemID])
                    [subArray addObject:item1];
            }
            [arrayMyList insertObjects:subArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, subArray.count)]];
        }
    }
    else{
        MyListItem *item = [arrayMyList objectAtIndex:indexPath.row];
        if (item.isSelected == TRUE){
            item.isSelected = FALSE;
            int selItems = 0;
            for (int i = 0; i < arrayMyList.count; i++) {
                MyListItem *item1 = [arrayMyList objectAtIndex:i];
                if (item1.isMainCategory == TRUE && [item1.itemID isEqualToString:item.itemID])
                {
                    item1.selectedItems--;
                    [arrayMyList replaceObjectAtIndex:i withObject:item1];
                }
                if (item1.isSelected == TRUE)
                    selItems++;
            }
            if (selItems == 0) {
                btn_done.alpha = 0.5;
                btn_done.userInteractionEnabled = NO;
            }
            [addlistTable reloadData];
        }
        else{
            [arrayMeasure removeAllObjects];
            selMeasureIndex = 0;
            selQuantyIndex = 0;
            selItem = indexPath.row;
            subcatName.text = item.itemName;
            for (int i = 0; i < arraySubCategories.count; i++) {
                SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
                if ([obj.subCatID isEqualToString:item.itemSubID]) {
                    NSString *str = obj.subCatMeasures;
                    NSArray *measures = [str componentsSeparatedByString:@","];
                    for (int j = 0; j < measures.count; j++) {
                        NSString *unitStr = [measures objectAtIndex:j];
                        if (![[[Setting sharedInstance] getMeasure:unitStr] isEqualToString:@"Unknown"])
                            [arrayMeasure addObject:[[Setting sharedInstance] getMeasure:unitStr]];
                    }
                }
            }
            [measurePicker reloadAllComponents];
            selectionView.hidden = NO;
            [self.view bringSubviewToFront:selectionView];
            [UIView beginAnimations:@"AdResize" context:nil];
            [UIView setAnimationDuration:0.7];
            
            CGRect newFrame = CGRectMake(selectionView.frame.origin.x, self.view.frame.size.height - selectionView.frame.size.height, selectionView.frame.size.width, selectionView.frame.size.height);
            
            selectionView.frame = newFrame;
            [UIView commitAnimations];
        }

    }
    
    mainNum = 0;
    }
    [tableView reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (_tableView == friendTable) {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
        FriendObject *obj = [[Setting sharedInstance].arrayRealFriends objectAtIndex:indexPath.row];
        UILabel *lb_friendName = (UILabel*)[cell viewWithTag:101];
        lb_friendName.text = obj.friendName;
        UIImageView *imgCheck = (UIImageView*)[cell viewWithTag:102];
        NSString *strChecked = [arrayCheckedFriends objectAtIndex:indexPath.row];
        if ([strChecked isEqualToString:@"no"])
            imgCheck.hidden = YES;
        else if ([strChecked isEqualToString:@"yes"])
            imgCheck.hidden = NO;
        CGRect tmpRect;
        tmpRect = imgCheck.frame;
        NSLog(@"%f, %f", self.btn_send.frame.origin.x, self.btn_can.frame.origin.x);
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            lb_friendName.textAlignment = NSTextAlignmentRight;
            tmpRect.origin.x = 20;
            imgCheck.frame = tmpRect;
        }
        else
        {
            lb_friendName.textAlignment = NSTextAlignmentLeft;
            tmpRect.origin.x = 230;
            imgCheck.frame = tmpRect;
            
        }
    }
    else if (_tableView == addlistTable){
        
        MyListItem *item = [arrayMyList objectAtIndex:indexPath.row];
        UILabel *lb_itemName;
        if (item.isMainCategory == TRUE){
            mainNum++;
            
            cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"MainItem"];
            if (cell == Nil)
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainItem"];
            UIImageView *bgCell = (UIImageView*)[cell viewWithTag:121];
            if (mainNum % 2 == 1) {
                bgCell.image = [UIImage imageNamed:@"cell1.png"];
            }
            else{
                bgCell.image = [UIImage imageNamed:@"cell2.png"];
            }
            lb_itemName = (UILabel*)[cell viewWithTag:101];
            lb_itemName.text = item.itemName;
            
            UIImageView *imgArrow1 = (UIImageView*)[cell viewWithTag:103];
            UIImageView *imgArrow2 = (UIImageView*)[cell viewWithTag:105];
            if (item.isOpened == TRUE) {
                imgArrow1.hidden = YES;
                imgArrow2.hidden = NO;
            }
            else{
                imgArrow1.hidden = NO;
                imgArrow2.hidden = YES;
            }
            UILabel *lbNum = (UILabel*)[cell viewWithTag:150];
            lbNum.textColor = [UIColor redColor];
            if (item.selectedItems > 0)
                lbNum.text = [NSString stringWithFormat:@"%d", item.selectedItems];
            else
                lbNum.text = @"";
            NSLog(@"%f, %f, %f, %f", lb_itemName.frame.origin.x, imgArrow1.frame.origin.x, imgArrow2.frame.origin.x, lbNum.frame.origin.x);
            CGRect tmpRect;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            {
                lb_itemName.textAlignment = NSTextAlignmentLeft;
                tmpRect = lb_itemName.frame;
                tmpRect.origin.x = 20;
                lb_itemName.frame = tmpRect;
                
                tmpRect = lbNum.frame;
                tmpRect.origin.x = 220;
                lbNum.frame = tmpRect;
                
                tmpRect = imgArrow1.frame;
                tmpRect.origin.x = 261;
                imgArrow1.frame = tmpRect;
                [imgArrow1 setImage:[UIImage imageNamed:@"mylist_arrow.png"]];
                
                tmpRect = imgArrow2.frame;
                tmpRect.origin.x = 254;
                imgArrow2.frame = tmpRect;
                
            }
            else{
                lb_itemName.textAlignment = NSTextAlignmentRight;
                tmpRect = lb_itemName.frame;
                tmpRect.origin.x = 50;
                lb_itemName.frame = tmpRect;
                
                tmpRect = lbNum.frame;
                tmpRect.origin.x = 40;
                lbNum.frame = tmpRect;
                
                tmpRect = imgArrow1.frame;
                tmpRect.origin.x = 17;
                imgArrow1.frame = tmpRect;
                [imgArrow1 setImage:[UIImage imageNamed:@"mylist_arrow_r.png"]];
                
                tmpRect = imgArrow2.frame;
                tmpRect.origin.x = 10;
                imgArrow2.frame = tmpRect;
            }
        }
        else{
             cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"SubItem"];
             if (cell == Nil)
                 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SubItem"];
            lb_itemName = (UILabel*)[cell viewWithTag:102];
            lb_itemName.text = item.itemName;
            UIButton *selButton = (UIButton*)[cell viewWithTag:104];
            if (item.isSelected == TRUE) {
                [selButton setBackgroundImage:[UIImage imageNamed:@"btn_close_mylist.png"] forState:UIControlStateNormal];
            }
            else
                [selButton setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
            
            NSLog(@"%f, %f", lb_itemName.frame.origin.x, selButton.frame.origin.x);
            CGRect tmpRect;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            {
                lb_itemName.textAlignment = NSTextAlignmentLeft;
                tmpRect = lb_itemName.frame;
                tmpRect.origin.x = 20;
                lb_itemName.frame = tmpRect;
                
                tmpRect = selButton.frame;
                tmpRect.origin.x = 220;
                selButton.frame = tmpRect;
            }
            else{
                lb_itemName.textAlignment = NSTextAlignmentRight;
                tmpRect = lb_itemName.frame;
                tmpRect.origin.x = 50;
                lb_itemName.frame = tmpRect;

                tmpRect = selButton.frame;
                tmpRect.origin.x = 20;
                selButton.frame = tmpRect;

            }
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == friendTable)
        return [Setting sharedInstance].arrayRealFriends.count;
    if (tableView == addlistTable)
        return arrayMyList.count;
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
}
@end
