//
//  PurchaseViewController.h
//  SuperMarket
//
//  Created by phoenix on 12/8/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (IBAction)onBtnCurrentOffer:(id)sender;
- (IBAction)onBtnExpiredOffer:(id)sender;
- (IBAction)onBtnList:(id)sender;
- (IBAction)onBtnRemove:(id)sender;
- (IBAction)onBtnPurchase:(id)sender;
- (IBAction)onBtnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *img_section;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_current;
@property (weak, nonatomic) IBOutlet UIButton *btn_expired;

@property (weak, nonatomic) IBOutlet UIImageView *img_back;
@property (weak, nonatomic) IBOutlet UITableView *favoriteTable;
@property (nonatomic, strong) NSMutableArray *arrayCurrentFavorite;
@property (nonatomic, strong) NSMutableArray *arrayExpireFavorite;
@property (nonatomic, assign) BOOL tableState;
@property (nonatomic, assign) int removeIndex;
@end
