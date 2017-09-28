//
//  SearchViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "SearchViewController.h"
#import "Setting.h"
#import "CompanyObject.h"
#import "State.h"
#import "Area.h"
#import "MainCategory.h"
#import "SubCategory.h"
#import "ProductsWithCategory.h"
#import "SearchResultViewController.h"
#import "MBProgressHUD.h"
#import "CompanyViewController.h"
#import "MyListViewController.h"
#import "AcceptRequestViewController.h"
#import "AppDelegate.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize productArray;
@synthesize searchResultArray;
@synthesize productObj;
@synthesize search_list;
@synthesize lb_header;
@synthesize tableView;
@synthesize searchBar;
@synthesize searchText;
@synthesize selectView;
@synthesize subCatID;
@synthesize supermarketID;
@synthesize mainCatID;
@synthesize cityID;
@synthesize priceFrom;
@synthesize priceTo;
@synthesize selectPicker;
@synthesize dataList;
@synthesize selectType;
@synthesize customerID;
@synthesize offerID;
@synthesize myLang;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize selIndex;
@synthesize selectedStatus;
@synthesize lb_pickerTitle;
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
    if ([Setting sharedInstance].pushInfo != nil) {
            if (buttonIndex == 0){
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
            
            CompanyViewController *companyVC = nil;
            
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
    else{
        if (buttonIndex == 0)
        {
            UITextField *txtAlert = [actionSheet textFieldAtIndex:0];
            if([txtAlert.text length]==0) {
                
                if (selectType == 3)
                    priceFrom = @"-1";
                else if (selectType == 4)
                    priceTo = @"-1";
                
                [selectedStatus replaceObjectAtIndex:selectType withObject:@"none"];
                selectType = -1;
                
            }
            else{
                if (selectType == 3)
                    priceFrom = txtAlert.text;
                else if (selectType == 4)
                    priceTo = txtAlert.text;
                
                [selectedStatus replaceObjectAtIndex:selectType withObject:txtAlert.text];
                selectType = -1;
            }
        }
        /*    else{
         
         if (selectType == 3)
         priceFrom = @"-1";
         else if (selectType == 4)
         priceTo = @"-1";
         [selectedStatus replaceObjectAtIndex:selectType withObject:@"none"];
         selectType = -1;
         
         }*/
        [tableView reloadData];

    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didPush)
                                                 name:@"PushDid"
                                               object:nil];
    [Setting sharedInstance].tabBarController.delegate = self;
	// Do any additional setup after loading the view.
    search_list = [[NSMutableArray alloc]init];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        [search_list addObject:@"Select All"];
        [search_list addObject:@"Select Supermarket"];
        [search_list addObject:@"Select Main-Category"];
        [search_list addObject:@"Select Sub-Category"];
        [search_list addObject:@"Price start from"];
        [search_list addObject:@"Price to"];
        [search_list addObject:@"Select City"];
    }else{
        [search_list addObject:@"Select All"];
        [search_list addObject:@"اختر السوبرماركت"];
        [search_list addObject:@"اختر القسم الرئيسي"];
        [search_list addObject:@"اختر القسم الفرعي"];
        [search_list addObject:@"السعر يبدأ من"];
        [search_list addObject:@"السعر الي"];
        [search_list addObject:@"اختر المدينة"];
    }
    selectedStatus = [[NSMutableArray alloc]init];
    for (int i = 0; i < search_list.count - 1; i++){
        NSString *isSelected = @"none";
        [selectedStatus addObject:isSelected];
    }

    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    CGRect tmpRect = selectView.frame;
    tmpRect.size.height -= 30;
    tmpRect.origin.y = self.view.frame.size.height;
    [selectView setFrame:tmpRect];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [Setting sharedInstance].lastSelectedTabIndex = [[Setting sharedInstance].tabBarController selectedIndex];
    [Setting sharedInstance].lastViewController = self;
    
       dataList = [[NSMutableArray alloc]init];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        [self.bnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
        [self.bnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateHighlighted];
        [self.bnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateSelected];
        
        [self.btnCan setBackgroundImage:[UIImage imageNamed:@"btn_cancel_measure.png"] forState:UIControlStateNormal];
        [self.btnCan setBackgroundImage:[UIImage imageNamed:@"btn_cancel_measure.png"] forState:UIControlStateHighlighted];
        [self.btnCan setBackgroundImage:[UIImage imageNamed:@"btn_cancel_measure.png"] forState:UIControlStateSelected];
        
        [self.btnDone setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateNormal];
        [self.btnDone setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateHighlighted];
        [self.btnDone setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateSelected];
    }
    else{
        [self.bnSearch setBackgroundImage:[UIImage imageNamed:@"arab_search.png"] forState:UIControlStateNormal];
        [self.bnSearch setBackgroundImage:[UIImage imageNamed:@"arab_search.png"] forState:UIControlStateHighlighted];
        [self.bnSearch setBackgroundImage:[UIImage imageNamed:@"arab_search.png"] forState:UIControlStateSelected];
        
        [self.btnCan setBackgroundImage:[UIImage imageNamed:@"arab_cancel_measure.png"] forState:UIControlStateNormal];
        [self.btnCan setBackgroundImage:[UIImage imageNamed:@"arab_cancel_measure.png"] forState:UIControlStateHighlighted];
        [self.btnCan setBackgroundImage:[UIImage imageNamed:@"arab_cancel_measure.png"] forState:UIControlStateSelected];
        
        [self.btnDone setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateNormal];
        [self.btnDone setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateHighlighted];
        [self.btnDone setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateSelected];
    }
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        lb_header.text = @"Search";
        searchBar.placeholder = @"Search...";
    }
    else{
        lb_header.text = @"بحث";
        searchBar.placeholder = @"بحث...";
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
    selectView.hidden = YES;
    [selectPicker setBackgroundColor:[UIColor whiteColor]];
    CGRect tmpRect = selectView.frame;
    tmpRect.size.height += 30;
    tmpRect.origin.y = self.view.frame.size.height;
    [selectView setFrame:tmpRect];
    selectType = -1;
    tmpRect = self.bnSearch.frame;
    if (IS_IPHONE_4) {
        tmpRect.origin.y = 360;
        [self.bnSearch setFrame:tmpRect];
        tmpRect = tableView.frame;
        tmpRect.size.height = 350 - tmpRect.origin.y;
        [tableView setFrame:tmpRect];
    }
    else if (IS_IPHONE_5){
        tmpRect.origin.y = 448;
        [self.bnSearch setFrame:tmpRect];
        tmpRect = tableView.frame;
        tmpRect.size.height = 438 - tmpRect.origin.y;
        [tableView setFrame:tmpRect];
    }
    UIImageView *bgTable = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchtablebg.png"]];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = bgTable;
    tableView.separatorColor = [UIColor clearColor];
    supermarketID = @"0";
    mainCatID = @"0";
    cityID = @"";
    priceFrom = @"-1";
    priceTo = @"-1";
    offerID = @"0";
    customerID = @"0";
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        myLang = 1;
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    soapResults = Nil;
    recordResults = FALSE;
    selIndex = -1;
    if ([[Setting sharedInstance].searchSubCatID isEqualToString:@""])
    {
        subCatID = @"0";
         [Setting sharedInstance].searchIndex = 1;
    }
    else
    {
        [Setting sharedInstance].searchIndex = 3;
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
        SearchResultViewController *vc = [mainstoryboard instantiateViewControllerWithIdentifier:@"SearchResultView"];
        [self.navigationController pushViewController:vc animated:YES];
      /*
        subCatID = [Setting sharedInstance].searchSubCatID;
        [self onBtnSearch:Nil];
        [search_list replaceObjectAtIndex:3 withObject:[[Setting sharedInstance] getSubCategoryName:subCatID]];
        [tableView reloadData];*/
        
    }
   
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //I have taken two components thats why I have set frame of my "label" accordingly. you can set the frame of the label depends on number of components you have...
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 45)];
    
    //For right alignment of text,You can set the UITextAlignmentRight of the label.
    //No need to set alignment to UITextAlignmentLeft because it is defaulted to picker data display behavior.
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        [label setTextAlignment:NSTextAlignmentLeft];
    }
    else
    {
        [label setTextAlignment:NSTextAlignmentRight];
    }
    label.opaque=NO;
    label.backgroundColor=[UIColor clearColor];
    label.textColor = [UIColor blackColor];
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    label.font = font;
    
    [label setText:[NSString stringWithFormat:@"%@", [dataList objectAtIndex:row]]];
    
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selIndex = row;
 
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataList count];
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [dataList objectAtIndex:row];
}
- (IBAction)onCancelButton:(id)sender {
    if (selectType == 0)
        supermarketID = @"0";
    else if (selectType == 1)
        mainCatID = @"0";
    else if (selectType == 2)
        subCatID = @"0";
    else if (selectType == 5)
        cityID = @"";

    [selectedStatus replaceObjectAtIndex:selectType withObject:@"none"];
    [tableView reloadData];
    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];
    
    CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
    
    selectView.frame = newFrame;
    [UIView commitAnimations];
    selectType = -1;
    selIndex = -1;
}
- (IBAction)onDone:(id)sender {
    
    if (selIndex == -1)
        selIndex = 0;
    if (selIndex != -1)
    {
        NSString *str = [selectedStatus objectAtIndex:selectType];
        if (selectType == 0){
            CompanyObject *obj = [[Setting sharedInstance].arrayCompany objectAtIndex:selIndex];
            supermarketID = obj.companyID;
            str = [[Setting sharedInstance] getCompanyName:supermarketID];
            
        }
        else if (selectType == 1)
        {
            MainCategory *obj = [[Setting sharedInstance].MainCategories objectAtIndex:selIndex];
            mainCatID = obj.mainCatID;
            str = [[Setting sharedInstance] getMainCategoryName:mainCatID];
        }
        else if (selectType == 2)
        {
            str = [dataList objectAtIndex:selIndex];
            for (int i = 0; i < [Setting sharedInstance].SubCategories.count; i++) {
                SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
                if ([[[Setting sharedInstance] getSubCategoryName:obj.subCatID] isEqualToString:str])
                {
                    subCatID = obj.subCatID;
                    break;
                }
            }

        }
        else if (selectType == 5)
        {
            State *obj = [[Setting sharedInstance].Cities objectAtIndex:selIndex];
            cityID = obj.stateID;
            str = [[Setting sharedInstance] getCityName:cityID];
        }
        [selectedStatus replaceObjectAtIndex:selectType withObject:str];
        [tableView reloadData];
    }

    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];
    
    CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
    
    selectView.frame = newFrame;
    [UIView commitAnimations];
        selectType = -1;
        selIndex = -1;
}

- (IBAction)onBtnSearch:(id)sender {
    searchText = searchBar.text;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<SearchProducts xmlns=\"http://tempuri.org/\">\n"
                             "<CompanyID>%@</CompanyID>\n"
                             "<OfferID>%@</OfferID>\n"
                             "<MainCategorID>%@</MainCategorID>\n"
                             "<SubCategoryID>%@</SubCategoryID>\n"
                             "<SearchKeyword>%@</SearchKeyword>\n"
                             "<PriceFrom>%@</PriceFrom>\n"
                             "<PriceTo>%@</PriceTo>\n"
                             "<CityList>%@</CityList>\n"
                             "<CustomerID>%@</CustomerID>\n"
                             "<Language>%d</Language>\n"
                             "</SearchProducts>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", supermarketID, offerID, mainCatID, subCatID, searchText, priceFrom, priceTo, cityID, [Setting sharedInstance].customer.customerID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=SearchProducts"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/SearchProducts" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

-(void) searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
    //This'll Show The cancelButton with Animation
    [_searchBar setShowsCancelButton:YES animated:YES];
    //remaining Code'll go here
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) _searchBar
{
    _searchBar.text = @"";
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    searchText = searchBar.text;
    [searchBar resignFirstResponder];
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"SearchItemCell"];
    if (cell == Nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchItemCell"];
    
    UILabel *lb_item = (UILabel*)[cell viewWithTag:101];
    NSString *strItem;
    if (selectedStatus.count > 0) {
        NSString *selectedString = [selectedStatus objectAtIndex:indexPath.row];
        if ([selectedString isEqualToString:@"none"]) {
            strItem = [search_list objectAtIndex:indexPath.row + 1];
        }
        else
            strItem = selectedString;

    }

    else{
        strItem = [search_list objectAtIndex:indexPath.row + 1];
    }
/*    if (indexPath.row == 0){
        UIButton *btnArrow = (UIButton*)[cell viewWithTag:102];
        btnArrow.hidden = YES;
    }*/
    lb_item.text = strItem;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        lb_item.textAlignment = NSTextAlignmentLeft;
    else
        lb_item.textAlignment = NSTextAlignmentRight;
    
    UIButton *btArrow = (UIButton*)[cell viewWithTag:102];
    CGRect tmpRect;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        tmpRect = btArrow.frame;
        tmpRect.origin.x = 278;
        btArrow.frame = tmpRect;
        [btArrow setBackgroundImage:[UIImage imageNamed:@"btn_arrow.png"] forState:UIControlStateNormal];
        [btArrow setBackgroundImage:[UIImage imageNamed:@"btn_arrow.png"] forState:UIControlStateHighlighted];
        [btArrow setBackgroundImage:[UIImage imageNamed:@"btn_arrow.png"] forState:UIControlStateSelected];
        NSLog(@"%f", tmpRect.origin.x);
    }
    else
    {
        tmpRect = btArrow.frame;
        tmpRect.origin.x = 10;
        btArrow.frame = tmpRect;
        [btArrow setBackgroundImage:[UIImage imageNamed:@"btn_arrow_r.png"] forState:UIControlStateNormal];
        [btArrow setBackgroundImage:[UIImage imageNamed:@"btn_arrow_r.png"] forState:UIControlStateHighlighted];
        [btArrow setBackgroundImage:[UIImage imageNamed:@"btn_arrow_r.png"] forState:UIControlStateSelected];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return search_list.count - 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height / 6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [searchBar resignFirstResponder];
    searchText = searchBar.text;
    selectView.hidden = NO;
    int index = -1;
    switch (indexPath.row + 1) {
        case 0:
        {
            supermarketID = @"0";
            mainCatID = @"0";
            subCatID = @"0";
            cityID = @"";
            priceFrom = @"-1";
            priceTo = @"-1";
            offerID = @"0";
            customerID = @"0";
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                myLang = 1;
            else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                myLang = 2;
            soapResults = Nil;
            recordResults = FALSE;
            selIndex = -1;

        }
            break;
        case 1:
        {
            selectType = 0;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                lb_pickerTitle.text = @"Select SuperMarket";
            else
                lb_pickerTitle.text = @"اختر السوبرماركت";
            [dataList removeAllObjects];
            
            for (int i = 0; i < [Setting sharedInstance].arrayCompany.count; i++) {
                CompanyObject *obj = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    [dataList addObject:obj.companyNameEn];
                else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                    [dataList addObject:obj.companyNameAr];
                if ([obj.companyID isEqualToString:supermarketID] && ![supermarketID isEqualToString:@"0"])
                    index = i;
            }
            [selectPicker reloadAllComponents];
            
            if (index != -1) {
                [selectPicker selectRow:index inComponent:0 animated:YES];
            //    lb_pickerTitle.text = [dataList objectAtIndex:index];
            }
            else
            {
                [selectPicker selectRow:0 inComponent:0 animated:YES];
            }
            [UIView beginAnimations:@"AdResize" context:nil];
            [UIView setAnimationDuration:0.7];
            
            CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height - selectView.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
            
            selectView.frame = newFrame;
            [UIView commitAnimations];
        }
            break;
        case 2:
        {
            selectType = 1;
            [dataList removeAllObjects];
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                lb_pickerTitle.text = @"Select MainCategory";
            else
                lb_pickerTitle.text = @"اختر القسم الرئيسي";
            
            for (int i = 0; i < [Setting sharedInstance].MainCategories.count; i++) {
                MainCategory *obj = [[Setting sharedInstance].MainCategories objectAtIndex:i];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    [dataList addObject:obj.mainCatNameEn];
                else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                    [dataList addObject:obj.mainCatNameAr];
                if ([obj.mainCatID isEqualToString:mainCatID] && ![mainCatID isEqualToString:@"0"])
                    index = i;
            }
            [selectPicker reloadAllComponents];
            
            if (index != -1) {
                [selectPicker selectRow:index inComponent:0 animated:YES];
              //  lb_pickerTitle.text = [dataList objectAtIndex:index];
            }
            else
            {
                [selectPicker selectRow:0 inComponent:0 animated:YES];
            }
            [UIView beginAnimations:@"AdResize" context:nil];
            [UIView setAnimationDuration:0.7];
            
            CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height - selectView.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
            
            selectView.frame = newFrame;
            [UIView commitAnimations];
        }
            break;
        case 3:
        {
            selectType = 2;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                lb_pickerTitle.text = @"Select SubCategory";
            else
                lb_pickerTitle.text = @"اختر القسم الفرعي";
            
            [dataList removeAllObjects];
            if ([mainCatID isEqualToString:@"0"]){
                for (int i = 0; i < [Setting sharedInstance].SubCategories.count; i++) {
                    SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
                    
                    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                        [dataList addObject:obj.subCatEn];
                    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                        [dataList addObject:obj.subCatAr];
                    if ([obj.subCatID isEqualToString:subCatID] && ![subCatID isEqualToString:@"0"])
                        index = i;
                }
            }
            else{
                for (int i = 0; i < [Setting sharedInstance].SubCategories.count; i++) {
                    SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
                    if ([obj.mainCatID isEqualToString:mainCatID]) {
                        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                            [dataList addObject:obj.subCatEn];
                        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                            [dataList addObject:obj.subCatAr];
                        if ([obj.subCatID isEqualToString:subCatID] && ![subCatID isEqualToString:@"0"])
                            index = i;
                    }
                }
            }
            [selectPicker reloadAllComponents];
            
            if (index != -1) {
                [selectPicker selectRow:index inComponent:0 animated:YES];
            //    lb_pickerTitle.text = [dataList objectAtIndex:index];
            }
            else
            {
                [selectPicker selectRow:0 inComponent:0 animated:YES];
            }
            [UIView beginAnimations:@"AdResize" context:nil];
            [UIView setAnimationDuration:0.7];
            
            CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height - selectView.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
            
            selectView.frame = newFrame;
            [UIView commitAnimations];
        }
            break;
        case 4:
        {
            selectType = 3;
            
            UIAlertView *customAlertView;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                customAlertView = [[UIAlertView alloc]initWithTitle:@"Please enter price from:"
                                                                     message:@""
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:@"Cancel",nil];
            }
            else
            {
                customAlertView = [[UIAlertView alloc]initWithTitle:@"ادخل السعر ابتداء من:"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"موافق"
                                                  otherButtonTitles:@"الغاء",nil];
            }
            customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
             UITextField *txtField = [customAlertView textFieldAtIndex:0];
            txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            if (![priceFrom isEqualToString:@"-1"]){
               
                txtField.text = priceFrom;
            }
            [customAlertView show];

        }
            break;
        case 5:
        {
            selectType = 4;
            UIAlertView *customAlertView;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                customAlertView = [[UIAlertView alloc]initWithTitle:@"Please enter price to:"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:@"Cancel",nil];
            }
            else
            {

                customAlertView = [[UIAlertView alloc]initWithTitle:@"الرجاء ادخال اعلي سعر:"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"موافق"
                                                  otherButtonTitles:@"الغاء",nil];
            }
            customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *txtField = [customAlertView textFieldAtIndex:0];
            txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            if (![priceTo isEqualToString:@"-1"]){
                txtField.text = priceTo;
            }
            [customAlertView show];
        }
            break;
        case 6:
        {
            selectType = 5;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                lb_pickerTitle.text = @"Select City";
            else
                lb_pickerTitle.text = @"اختر المدينة";
            
            [dataList removeAllObjects];
            for (int i = 0; i < [Setting sharedInstance].Cities.count; i++) {
                State *obj = [[Setting sharedInstance].Cities objectAtIndex:i];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    [dataList addObject:obj.stateNameEn];
                else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                    [dataList addObject:obj.stateNameAr];
                if ([obj.stateID isEqualToString:cityID] && ![cityID isEqualToString:@"0"])
                    index = i;
            }
            [selectPicker reloadAllComponents];
            
            if (index != -1) {
                [selectPicker selectRow:index inComponent:0 animated:YES];
             //   lb_pickerTitle.text = [dataList objectAtIndex:index];
            }
            else
            {
                [selectPicker selectRow:0 inComponent:0 animated:YES];

            }
            [UIView beginAnimations:@"AdResize" context:nil];
            [UIView setAnimationDuration:0.7];
            
            CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height - selectView.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
            
            selectView.frame = newFrame;
            [UIView commitAnimations];
        }
            break;
            
        default:
            break;
    }
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
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyName] bundle:nil];
        SearchResultViewController *vc = [mainstoryboard instantiateViewControllerWithIdentifier:@"SearchResultView"];
        vc.arrayProductsWithCategory = productArray;
        [self saveProductsInfo];
        [Setting sharedInstance].searchIndex = 1;
        [self.navigationController pushViewController:vc animated:YES];
	}
    if( [elementName isEqualToString:@"SearchResult"])
	{
		recordResults = FALSE;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [df setLocale:locale];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [df setTimeZone:tz];
        NSDate *endDate = [df dateFromString:productObj.prodEndDate];
//        if ([[Setting sharedInstance] checkAndDelete:endDate withOfferID:productObj.OfferID] == TRUE)
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
                querySQL = [NSString stringWithFormat: @"INSERT INTO Products (ID, OfferID, CompanyID, Quantity, MainCatID, MeasureID, SubCatID, OrgPrice, Price, Photo, DescAr, DescEn, StartDate, EndDate, BranchList, VisitsCount, TitleAr, TitleEn, IsActive, lastUpdateTime) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", obj.prodID, obj.OfferID, obj.prodCompanyID, obj.prodQuantity, obj.prodMainCatID, obj.prodMeasureID, obj.prodSubCatID, obj.prodOrgPrice, obj.prodCurPrice, obj.prodPhotoURL, obj.prodDescAr, obj.prodDescEn, obj.prodStartDate, obj.prodEndDate, obj.prodBranchList, obj.prodVisitsCount, obj.prodTitleAr, obj.prodTitleEn, obj.prodIsActive, obj.prodlastUpdateTime];
            
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
