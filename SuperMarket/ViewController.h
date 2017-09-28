//
//  ViewController.h
//  SuperMarket
//
//  Created by phoenix on 10/30/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Area.h"
#import "State.h"
#import "Measures.h"
#import "MainCategory.h"
#import "SubCategory.h"
#import <sqlite3.h>
@interface ViewController : UIViewController
{
    sqlite3 *projectDB;
    NSString *databasePath;
}
- (IBAction)onBtnArab:(id)sender;
- (IBAction)onBtnEnglish:(id)sender;
@property (nonatomic, strong) NSMutableArray *arrayRequest;
@property (nonatomic, strong) NSMutableArray *arrayResponse;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property (weak, nonatomic) IBOutlet UIButton *btnEnglish;
@property (weak, nonatomic) IBOutlet UIButton *btnArab;
@property (nonatomic, strong) NSString *responseType;
@property (nonatomic, strong) Area *areaObj;
@property (nonatomic, strong) State *cityObj;
@property (nonatomic, strong) Measures *measureObj;
@property (nonatomic, strong) MainCategory *mainObj;
@property (nonatomic, strong) SubCategory *subObj;
@property (nonatomic, assign) int responseNum;
@property (nonatomic, strong) UIImageView *statusView;
@end
