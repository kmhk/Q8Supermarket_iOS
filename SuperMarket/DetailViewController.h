//
//  DetailViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/23/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ProductObject.h"
#import "ProductsWithCategory.h"
@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet AsyncImageView *img_product;
@property (weak, nonatomic) IBOutlet UILabel *lb_productName;
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *lb_percent;
@property (weak, nonatomic) IBOutlet UITextView *lb_prodDescription;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;

@property (weak, nonatomic) IBOutlet UILabel *lb_Price;
@property (weak, nonatomic) IBOutlet UILabel *lb_orgPrice;
@property (weak, nonatomic) IBOutlet UIButton *btn_purchase;
@property (weak, nonatomic) IBOutlet UIButton *btn_favorite;

@property (weak, nonatomic) IBOutlet UIImageView *img_line;
@property (nonatomic, strong) NSMutableArray *ProductList;
@property (nonatomic, assign) int indexRow;
@property (nonatomic, assign) int viewIndex;
- (IBAction)onPurchase:(id)sender;

- (IBAction)onClose:(id)sender;
- (IBAction)onFavorite:(id)sender;

@end
