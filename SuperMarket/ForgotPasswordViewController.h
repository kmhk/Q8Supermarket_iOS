//
//  ForgotPasswordViewController.h
//  SuperMarket
//
//  Created by phoenix on 1/21/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
- (IBAction)onSend:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onBtnList:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UITextField *tEmail;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@end
