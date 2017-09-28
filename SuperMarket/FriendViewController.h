//
//  FriendViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ViewController.h"
#import "FriendObject.h"
@interface FriendViewController : ViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *beFriendTable;
- (IBAction)onAddNewFriend:(id)sender;
- (void)getFriendsFromOnline;
@property (weak, nonatomic) IBOutlet UIImageView *imgRequest;
@property (weak, nonatomic) IBOutlet UIImageView *imgFriends;

@property (nonatomic, assign) NSString *viewName;
@property (weak, nonatomic) IBOutlet UIButton *btnAddNewButton;
@property (nonatomic, strong) UIViewController *prevView;
@property (weak, nonatomic) IBOutlet UITableView *myFriendTable;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property(nonatomic, assign) 	BOOL errEncounter;
@property (nonatomic, strong) FriendObject *myFriend;
@end
