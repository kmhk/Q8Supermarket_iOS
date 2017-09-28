//
//  AboutUsViewController.h
//  SuperMarket
//
//  Created by phoenix on 1/23/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface AboutUsViewController : UIViewController<UIWebViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tDescription;
- (IBAction)onBtnFacebook:(id)sender;
- (IBAction)onBtnTwitter:(id)sender;
- (IBAction)onBtnInstagram:(id)sender;
- (IBAction)onBtnContactUS:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onClose:(id)sender;

- (IBAction)onShare:(id)sender;
@property (strong, nonatomic) NSString *urlstring;
@property (weak, nonatomic) IBOutlet UIView *webBaseView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_header;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnInstagram;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;
@property (nonatomic, strong) UIActivityViewController *activityViewController;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@end
