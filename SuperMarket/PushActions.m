//
//  PushActions.m
//  SuperMarket
//
//  Created by phoenix on 3/4/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import "PushActions.h"
#import "Setting.h"

@implementation PushActions
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize areaObj;
@synthesize cityObj;
@synthesize measureObj;
@synthesize mainObj;
@synthesize subObj;
@synthesize braObj;
@synthesize comObj;
@synthesize pushType;
- (id)init
{
    self = [super init];
    
    return self;
}
-(void)pushArea{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    pushType = 6;
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    if ([[dic objectForKey:@"OperationType"]intValue] == 3){
        [self pushAreaTable];
        return;
    }
    int itemID = [[dic objectForKey:@"ItemID"] intValue];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<AreaGetRow xmlns=\"http://tempuri.org/\">\n"
                             "<ID>%d</ID>\n"
                             "<Language>%d</Language>\n"
                             "</AreaGetRow>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", itemID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=AreaGetRow"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/AreaGetRow" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
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
-(void)pushBranch{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    pushType = 2;
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    if ([[dic objectForKey:@"OperationType"]intValue] == 3){
        [self pushBranchTable];
        return;
    }
    int itemID = [[dic objectForKey:@"ItemID"] intValue];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CompanyBranchesGetRow xmlns=\"http://tempuri.org/\">\n"
                             "<ID>%d</ID>\n"
                             "<Language>%d</Language>\n"
                             "</CompanyBranchesGetRow>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", itemID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CompanyBranchesGetRow"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/CompanyBranchesGetRow" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
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
-(void)pushCity{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    pushType = 5;
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    if ([[dic objectForKey:@"OperationType"]intValue] == 3){
        [self pushCityTable];
        return;
    }
    int itemID = [[dic objectForKey:@"ItemID"] intValue];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CityGetRow xmlns=\"http://tempuri.org/\">\n"
                             "<ID>%d</ID>\n"
                             "<Language>%d</Language>\n"
                             "</CityGetRow>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", itemID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CityGetRow"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/CityGetRow" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
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
-(void)pushCompany{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    pushType = 1;
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    if ([[dic objectForKey:@"OperationType"]intValue] == 3){
        [self pushCompanyTable];
        return;
    }
    int itemID = [[dic objectForKey:@"ItemID"] intValue];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CompanyGetRow xmlns=\"http://tempuri.org/\">\n"
                             "<ID>%d</ID>\n"
                             "<Language>%d</Language>\n"
                             "</CompanyGetRow>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", itemID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CompanyGetRow"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/CompanyGetRow" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
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
-(void)pushMainCategory{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    pushType = 3;
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    if ([[dic objectForKey:@"OperationType"]intValue] == 3){
        [self pushMainCategoryTable];
        return;
    }
    int itemID = [[dic objectForKey:@"ItemID"] intValue];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<MainCategoryGetRow xmlns=\"http://tempuri.org/\">\n"
                             "<ID>%d</ID>\n"
                             "<Language>%d</Language>\n"
                             "</MainCategoryGetRow>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", itemID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MainCategoryGetRow"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/MainCategoryGetRow" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
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
-(void)pushMeasure{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    pushType = 7;
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    if ([[dic objectForKey:@"OperationType"]intValue] == 3){
        [self pushMeasureTable];
        return;
    }
    int itemID = [[dic objectForKey:@"ItemID"] intValue];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<MeasuresGetRow xmlns=\"http://tempuri.org/\">\n"
                             "<ID>%d</ID>\n"
                             "<Language>%d</Language>\n"
                             "</MeasuresGetRow>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", itemID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MeasuresGetRow"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/MeasuresGetRow" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
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
-(void)pushSubCategory{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    pushType = 4;
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    if ([[dic objectForKey:@"OperationType"]intValue] == 3){
        [self pushSubCategoryTable];
        return;
    }
    int itemID = [[dic objectForKey:@"ItemID"] intValue];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<SubCategoryGetRow xmlns=\"http://tempuri.org/\">\n"
                             "<ID>%d</ID>\n"
                             "<Language>%d</Language>\n"
                             "</SubCategoryGetRow>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", itemID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=SubCategoryGetRow"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/SubCategoryGetRow" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
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
    /* Company start*/
    if (pushType == 1){
    if ([elementName isEqualToString:@"CompanyGetRowResult"])
    {
        comObj = [[CompanyObject alloc]init];
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"NameAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"NameEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Email"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Phone"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Fax"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Logo"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"StateID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AreaID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OverallSort"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ProductSort"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OrderSort"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BigLogo"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AboutUsLogo"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"SloganEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"SloganAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    }
    /* Company end*/
    /* Branch start*/
    if (pushType == 2){
    if( [elementName isEqualToString:@"CompanyBranchesGetRowResult"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
        braObj = [[BranchObject alloc] init];
    }
    if ([elementName isEqualToString:@"ID"])
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
    if ([elementName isEqualToString:@"BranchNameAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BranchNameEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Email"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Phone"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Fax"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Sort"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"StateID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AreaID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Latitude"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Longitude"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    }/* Branch end*/
    /* main category start*/
    if (pushType == 3){
        if ([elementName isEqualToString:@"MainCategoryGetRowResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            mainObj = [[MainCategory alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"CatNameAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"CatNameEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }

    }
    /* sub category start*/
    if (pushType == 4){
        if ([elementName isEqualToString:@"SubCategoryGetRowResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            subObj = [[SubCategory alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"MainCatID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"SubCatAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"SubCatEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"CatMeasures"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
    }
    /* city start */
    if (pushType == 5){
        if ([elementName isEqualToString:@"CityGetRowResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            cityObj = [[State alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"StateNameAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"StateNameEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
    }
    /* area start */
    if (pushType == 6){
        if ([elementName isEqualToString:@"AreaGetRowResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            areaObj = [[Area alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"StateID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"AreaNameAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"AreaNameEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
    }
    /* measure start */
    if (pushType == 7){
        if ([elementName isEqualToString:@"MeasuresGetRowResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            
                measureObj = [[Measures alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"MeasureNameAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"MeasureNameEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
    }
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if( recordResults )
	{
		[soapResults appendString: string];
	}
}
bool errorPush = FALSE;
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ErrMessage"]){
        recordResults = FALSE;
        if (![soapResults isEqualToString:@""]){
            NSLog(@"push action error");
            errorPush = TRUE;
        }
        soapResults = nil;
    }
    /* Company start*/
    if (pushType == 1){
    if ([elementName isEqualToString:@"ID"])
    {
        recordResults = FALSE;
        comObj.companyID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"NameAr"])
    {
        recordResults = FALSE;
        comObj.companyNameAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"NameEn"])
    {
        recordResults = FALSE;
        comObj.companyNameEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Email"])
    {
        recordResults = FALSE;
        comObj.companyEmail = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Phone"])
    {
        recordResults = FALSE;
        comObj.companyPhone = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Fax"])
    {
        recordResults = FALSE;
        comObj.companyFax = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Logo"])
    {
        recordResults = FALSE;
        comObj.companyLogo = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"StateID"])
    {
        recordResults = FALSE;
        comObj.companyStateID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AreaID"])
    {
        recordResults = FALSE;
        comObj.companyAreaID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AddressAr"])
    {
        recordResults = FALSE;
        comObj.companyAddressAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AddressEn"])
    {
        recordResults = FALSE;
        comObj.companyAddressEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescAr"])
    {
        recordResults = FALSE;
        comObj.companyDescAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescEn"])
    {
        recordResults = FALSE;
        comObj.companyDescEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OverallSort"])
    {
        recordResults = FALSE;
        comObj.companyOverallSort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductSort"])
    {
        recordResults = FALSE;
        comObj.companyProductSort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OrderSort"])
    {
        recordResults = FALSE;
        comObj.companyOrderSort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"BigLogo"])
    {
        recordResults = FALSE;
        comObj.companyBigLogo = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AboutUsLogo"])
    {
        recordResults = FALSE;
        comObj.companyAboutUsLogo = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"SloganEn"])
    {
        recordResults = FALSE;
        comObj.companySloganEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"SloganAr"])
    {
        recordResults = FALSE;
        comObj.companySloganAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"CompanyGetRowResult"])
    {
        if (errorPush == TRUE)
            return;
        [self pushCompanyTable];
        errorPush = FALSE;
    }
    }
    /* Company end*/
    /* branch start*/
    if (pushType == 2){
        if( [elementName isEqualToString:@"CompanyBranchesGetRowResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            if (errorPush == TRUE)
                return;
            errorPush = FALSE;
            [self pushBranchTable];
        }
        
        if ([elementName isEqualToString:@"ID"]){
            recordResults = FALSE;
            braObj.branchID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"CompanyID"]){
            recordResults = FALSE;
            braObj.CompanyID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"BranchNameAr"])
        {
            recordResults = FALSE;
            braObj.NameAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"BranchNameEn"])
        {
            recordResults = FALSE;
            braObj.NameEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Email"])
        {
            recordResults = FALSE;
            braObj.Email = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Phone"])
        {
            recordResults = FALSE;
            braObj.Phone = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Fax"])
        {
            recordResults = FALSE;
            braObj.Fax = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            braObj.Sort = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"StateID"])
        {
            recordResults = FALSE;
            braObj.StateID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"AreaID"])
        {
            recordResults = FALSE;
            braObj.AreaID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"AddressEn"])
        {
            recordResults = FALSE;
            braObj.AddressEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"AddressAr"])
        {
            recordResults = FALSE;
            braObj.AddressAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Latitude"])
        {
            recordResults = FALSE;
            braObj.Latitude = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Longitude"])
        {
            recordResults = FALSE;
            braObj.Longitude = soapResults;
            soapResults = nil;
        }

    }
    /* branch end*/
    /* main category start */
    if (pushType == 3){
        
        if( [elementName isEqualToString:@"MainCategoryGetRowResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            if (errorPush == TRUE)
                return;
            errorPush = FALSE;
            [self pushMainCategoryTable];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            mainObj.mainCatID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"CatNameAr"])
        {
            recordResults = FALSE;
            mainObj.mainCatNameAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"CatNameEn"])
        {
            recordResults = FALSE;
            mainObj.mainCatNameEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            mainObj.sort = soapResults;
            soapResults = nil;
        }

    }
    /* main category end */
    /* sub category start */
    if (pushType == 4){
        
        if( [elementName isEqualToString:@"SubCategoryGetRowResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            if (errorPush == TRUE)
                return;
            errorPush = FALSE;
            [self pushSubCategoryTable];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            subObj.subCatID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"MainCatID"])
        {
            recordResults = FALSE;
            subObj.mainCatID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"SubCatAr"])
        {
            recordResults = FALSE;
            subObj.subCatAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"SubCatEn"])
        {
            recordResults = FALSE;
            subObj.subCatEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"CatMeasures"])
        {
            recordResults = FALSE;
            subObj.subCatMeasures = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            subObj.sort = soapResults;
            soapResults = nil;
        }
    }/* sub category end */
    /* city start */
    if (pushType == 5){
        
        if( [elementName isEqualToString:@"CityGetRowResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            if (errorPush == TRUE)
                return;
            errorPush = FALSE;
            [self pushCityTable];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            cityObj.stateID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"StateNameAr"])
        {
            recordResults = FALSE;
            cityObj.stateNameAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"StateNameEn"])
        {
            recordResults = FALSE;
            cityObj.stateNameEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            cityObj.sort = soapResults;
            soapResults = nil;
        }
    }/* city end */
    /* area start*/
    if (pushType == 6)
    {
        
        if( [elementName isEqualToString:@"AreaGetRowResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            if (errorPush == TRUE)
                return;
            errorPush = FALSE;
            [self pushAreaTable];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            areaObj.areaID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"StateID"])
        {
            recordResults = FALSE;
            areaObj.areaStateID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"AreaNameAr"])
        {
            recordResults = FALSE;
            areaObj.areaNameAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"AreaNameEn"])
        {
            recordResults = FALSE;
            areaObj.areaNameEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            areaObj.sort = soapResults;
            soapResults = nil;
        }
    }/* area end */
    /* measure start */
    if (pushType == 7){
        if( [elementName isEqualToString:@"MeasuresGetRowResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            if (errorPush == TRUE)
                return;
            errorPush = FALSE;
            [self pushMeasureTable];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            measureObj.measureID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"MeasureNameAr"])
        {
            recordResults = FALSE;
            measureObj.measureNameAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"MeasureNameEn"])
        {
            recordResults = FALSE;
            measureObj.measureNameEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            measureObj.sort = soapResults;
            soapResults = nil;
        }
    }/* measure end */
}
-(void)pushCompanyTable{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    int operType = [[dic objectForKey:@"OperationType"] intValue];
    
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
            if (operType == 1)//add
                querySQL = [NSString stringWithFormat: @"INSERT INTO Companies (ID, NameAr, NameEn, Email, Phone, Fax, Logo, StateID, AreaID, AddressAr, AddressEn, DescAr, DescEn, OverallSort, ProductSort, OrderSort, BigLogo, AboutUsLogo, SloganEn, SloganAr) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", comObj.companyID, comObj.companyNameAr, comObj.companyNameEn, comObj.companyEmail, comObj.companyPhone, comObj.companyFax, comObj.companyLogo, comObj.companyStateID, comObj.companyAreaID, comObj.companyAddressAr, comObj.companyAddressEn, comObj.companyDescAr, comObj.companyDescEn, comObj.companyOverallSort, comObj.companyProductSort, comObj.companyOrderSort, comObj.companyBigLogo, comObj.companyAboutUsLogo, comObj.companySloganEn, comObj.companySloganAr];
            else if (operType == 2)//update
                querySQL = [NSString stringWithFormat:@"UPDATE Companies SET NameAr = \"%@\", NameEn = \"%@\", Email = \"%@\", Phone = \"%@\", Fax = \"%@\", Logo = \"%@\", StateID = \"%@\", AreaID = \"%@\", AddressAr = \"%@\", AddressEn = \"%@\", DescAr = \"%@\", DescEn = \"%@\", OverallSort = \"%@\", ProductSort = \"%@\", OrderSort = \"%@\", BigLogo = \"%@\", AboutUsLogo = \"%@\", SloganEn = \"%@\", SloganAr = \"%@\" WHERE ID = \"%@\"", comObj.companyNameAr, comObj.companyNameEn, comObj.companyEmail, comObj.companyPhone, comObj.companyFax, comObj.companyLogo, comObj.companyStateID, comObj.companyAreaID, comObj.companyAddressAr, comObj.companyAddressEn, comObj.companyDescAr, comObj.companyDescEn, comObj.companyOverallSort, comObj.companyProductSort, comObj.companyOrderSort, comObj.companyBigLogo, comObj.companyAboutUsLogo, comObj.companySloganEn, comObj.companySloganAr, comObj.companyID];
            else if (operType == 3)//delete
                    querySQL = [NSString stringWithFormat: @"DELETE FROM Companies WHERE ID = \"%@\"", [dic objectForKey:@"ItemID"]];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"push action for company table is success");
                    
                }
                else
                    NSLog(@"push action for company table is failure");
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
            [self loadCompany];
        }
    }
}
-(void)pushBranchTable{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    int operType = [[dic objectForKey:@"OperationType"] intValue];
    
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
            if (operType == 1)//add
                querySQL = [NSString stringWithFormat: @"INSERT INTO Branches (ID, CompanyID, BranchNameAr, BranchNameEn, Email, Phone, Fax, Sort, StateID, AreaID, AddressEn, AddressAr, Latitude, Longitude) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", braObj.branchID, braObj.CompanyID, braObj.NameAr, braObj.NameEn, braObj.Email, braObj.Phone, braObj.Fax, braObj.Sort, braObj.StateID, braObj.AreaID, braObj.AddressEn, braObj.AddressAr, braObj.Latitude, braObj.Longitude];
            else if (operType == 2)//update
                querySQL = [NSString stringWithFormat:@"UPDATE Branches SET CompanyID = \"%@\", BranchNameAr = \"%@\", BranchNameEn = \"%@\", Email = \"%@\", Phone = \"%@\", Fax = \"%@\", Sort = \"%@\", StateID = \"%@\", AreaID = \"%@\", AddressEn = \"%@\", AddressAr = \"%@\", Latitude = \"%@\", Longitude = \"%@\" WHERE ID = \"%@\"", braObj.CompanyID, braObj.NameAr, braObj.NameEn, braObj.Email, braObj.Phone, braObj.Fax, braObj.Sort, braObj.StateID, braObj.AreaID, braObj.AddressEn, braObj.AddressAr, braObj.Latitude, braObj.Longitude, braObj.branchID];
            else if (operType == 3)//delete
                querySQL = [NSString stringWithFormat: @"DELETE FROM Branches WHERE ID = \"%@\"", [dic objectForKey:@"ItemID"]];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"push action for Branches table is success");
                    
                }
                else
                    NSLog(@"push action for Branches table is failure");
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }

}
-(void)pushAreaTable{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    int operType = [[dic objectForKey:@"OperationType"] intValue];
    
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
            if (operType == 1)//add
                querySQL = [NSString stringWithFormat: @"INSERT INTO Areas (ID, StateID, AreaNameAr, AreaNameEn, Sort) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", areaObj.areaID, areaObj.areaStateID, areaObj.areaNameAr, areaObj.areaNameEn, areaObj.sort];
            else if (operType == 2)//update
                querySQL = [NSString stringWithFormat:@"UPDATE Areas SET StateID = \"%@\", AreaNameAr = \"%@\", AreaNameEn = \"%@\", Sort = \"%@\" WHERE ID = \"%@\"", areaObj.areaStateID, areaObj.areaNameAr, areaObj.areaNameEn, areaObj.sort, areaObj.areaID];
            else if (operType == 3)//delete
                querySQL = [NSString stringWithFormat: @"DELETE FROM Areas WHERE ID = \"%@\"", [dic objectForKey:@"ItemID"]];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"push action for Areas table is success");
                    
                }
                else
                    NSLog(@"push action for Areas table is failure");
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
            [self loadArea];
        }
    }
}
-(void)pushCityTable{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    int operType = [[dic objectForKey:@"OperationType"] intValue];
    
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
            if (operType == 1)//add
                querySQL = [NSString stringWithFormat: @"INSERT INTO States (ID, StateNameAr, StateNameEn, Sort) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", cityObj.stateID, cityObj.stateNameAr, cityObj.stateNameEn, cityObj.sort];
            else if (operType == 2)//update
                querySQL = [NSString stringWithFormat:@"UPDATE States SET StateNameAr = \"%@\", StateNameEn = \"%@\", Sort = \"%@\" WHERE ID = \"%@\"", cityObj.stateNameAr, cityObj.stateNameEn, cityObj.sort, cityObj.stateID];
            else if (operType == 3)//delete
                querySQL = [NSString stringWithFormat: @"DELETE FROM States WHERE ID = \"%@\"", [dic objectForKey:@"ItemID"]];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"push action for States table is success");
                    
                }
                else
                    NSLog(@"push action for States table is failure");
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
            [self loadCity];
        }
    }
}
-(void)pushMainCategoryTable{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    int operType = [[dic objectForKey:@"OperationType"] intValue];
    
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
            if (operType == 1)//add
                querySQL = [NSString stringWithFormat: @"INSERT INTO MainCateogry (ID, CatNameAr, CatNameEn, Sort) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", mainObj.mainCatID, mainObj.mainCatNameAr, mainObj.mainCatNameEn, mainObj.sort];
            else if (operType == 2)//update
                querySQL = [NSString stringWithFormat:@"UPDATE MainCateogry SET CatNameAr = \"%@\", CatNameEn = \"%@\", Sort = \"%@\" WHERE ID = \"%@\"", mainObj.mainCatNameAr, mainObj.mainCatNameEn, mainObj.sort, mainObj.mainCatID];
            else if (operType == 3)//delete
                querySQL = [NSString stringWithFormat: @"DELETE FROM MainCateogry WHERE ID = \"%@\"", [dic objectForKey:@"ItemID"]];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"push action for MainCateogry table is success");
                    
                }
                else
                    NSLog(@"push action for MainCateogry table is failure");
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
            [self loadMainCategory];
        }
    }
}
-(void)pushMeasureTable{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    int operType = [[dic objectForKey:@"OperationType"] intValue];
    
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
            if (operType == 1)//add
                querySQL = [NSString stringWithFormat: @"INSERT INTO Measures (ID, MeasureNameAr, MeasureNameEn, Sort) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", measureObj.measureID, measureObj.measureNameAr, measureObj.measureNameEn, measureObj.sort];
            else if (operType == 2)//update
                querySQL = [NSString stringWithFormat:@"UPDATE Measures SET MeasureNameAr = \"%@\", MeasureNameEn = \"%@\", Sort = \"%@\" WHERE ID = \"%@\"", measureObj.measureNameAr, measureObj.measureNameEn, measureObj.sort, measureObj.measureID];
            else if (operType == 3)//delete
                querySQL = [NSString stringWithFormat: @"DELETE FROM Measures WHERE ID = \"%@\"", [dic objectForKey:@"ItemID"]];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"push action for Measures table is success");
                }
                else
                    NSLog(@"push action for Measures table is failure");
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
            [self loadMeasure];
        }
    }
}

-(void)pushSubCategoryTable{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    
    NSString *pushStr = [Setting sharedInstance].pushInfo;
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];
    int operType = [[dic objectForKey:@"OperationType"] intValue];
    
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
            if (operType == 1)//add
                querySQL = [NSString stringWithFormat: @"INSERT INTO SubCategory (ID, MainCatID, SubCatAr, SubCatEn, Sort, CatMeasures) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", subObj.subCatID, subObj.mainCatID, subObj.subCatAr, subObj.subCatEn, subObj.sort, subObj.subCatMeasures];
            else if (operType == 2)//update
                querySQL = [NSString stringWithFormat:@"UPDATE SubCategory SET MainCatID = \"%@\", SubCatAr = \"%@\", SubCatEn = \"%@\", Sort = \"%@\", CatMeasures = \"%@\" WHERE ID = \"%@\"", subObj.mainCatID, subObj.subCatAr, subObj.subCatEn, subObj.sort, subObj.subCatMeasures, subObj.subCatID];
            else if (operType == 3)//delete
                querySQL = [NSString stringWithFormat: @"DELETE FROM SubCategory WHERE ID = \"%@\"", [dic objectForKey:@"ItemID"]];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"push action for SubCategory table is success");
                    
                }
                else
                    NSLog(@"push action for SubCategory table is failure");
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
            [self loadSubCategory];
        }
    }
}
- (void)loadArea{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        //Areas table checking...
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Areas ORDER BY Sort"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            [[Setting sharedInstance].Areas removeAllObjects];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                Area *obj = [[Area alloc]init];
                obj.areaID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                obj.areaStateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.areaNameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.areaNameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                obj.sort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                
                [[Setting sharedInstance].Areas addObject:obj];
                
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(projectDB);
    }
}
- (void)loadCity{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        [[Setting sharedInstance].Cities removeAllObjects];
        //Areas table checking...
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM States ORDER BY Sort"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                State *obj = [[State alloc]init];
                obj.stateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                obj.stateNameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.stateNameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.sort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                
                [[Setting sharedInstance].Cities addObject:obj];
                
            }
            sqlite3_finalize(statement);
            
        }
    }
}
- (void)loadMainCategory{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        //Areas table checking...
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM MainCateogry ORDER BY Sort"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            [[Setting sharedInstance].MainCategories removeAllObjects];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                MainCategory *obj = [[MainCategory alloc]init];
                obj.mainCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                obj.mainCatNameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.mainCatNameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.sort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                
                [[Setting sharedInstance].MainCategories addObject:obj];
                
            }
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(projectDB);
    }
}
- (void)loadSubCategory{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        //Areas table checking...
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM SubCategory ORDER BY Sort"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            [[Setting sharedInstance].SubCategories removeAllObjects];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                SubCategory *obj = [[SubCategory alloc]init];
                obj.subCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                obj.mainCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.subCatAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.subCatEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                obj.sort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                obj.subCatMeasures = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                
                [[Setting sharedInstance].SubCategories addObject:obj];
                
            }
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(projectDB);
    }
}
- (void)loadMeasure{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
   
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        //Areas table checking...
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Measures ORDER BY Sort"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
             [[Setting sharedInstance].arrayMeasures removeAllObjects];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                Measures *obj = [[Measures alloc]init];
                obj.measureID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                obj.measureNameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.measureNameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.sort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                
                [[Setting sharedInstance].arrayMeasures addObject:obj];
                
            }
            sqlite3_finalize(statement);
            
        }
        
        
        
        sqlite3_close(projectDB);
    }
}
- (void)loadCompany{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Companies"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) != SQLITE_ROW) {
                return;
            }
            else{
                [[Setting sharedInstance].arrayCompany removeAllObjects];
                CompanyObject *obj = [[CompanyObject alloc]init];
                obj.companyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                obj.companyNameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                obj.companyNameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                obj.companyEmail = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                obj.companyPhone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                obj.companyFax = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                obj.companyLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                obj.companyStateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                obj.companyAreaID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                obj.companyAddressAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                obj.companyAddressEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                obj.companyDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                obj.companyDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                obj.companyOverallSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                obj.companyProductSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                obj.companyOrderSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                obj.companyBigLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                obj.companyAboutUsLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                obj.companySloganEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                obj.companySloganAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
                
                
                [[Setting sharedInstance].arrayCompany addObject:obj];
                
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    CompanyObject *obj1 = [[CompanyObject alloc]init];
                    obj1.companyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    obj1.companyNameAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    obj1.companyNameEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    obj1.companyEmail = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    obj1.companyPhone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    obj1.companyFax = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    obj1.companyLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    obj1.companyStateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                    obj1.companyAreaID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                    obj1.companyAddressAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                    obj1.companyAddressEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                    obj1.companyDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                    obj1.companyDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                    obj1.companyOverallSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                    obj1.companyProductSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                    obj1.companyOrderSort = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                    obj1.companyBigLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                    obj1.companyAboutUsLogo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                    obj1.companySloganEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                    obj1.companySloganAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
                    
                    
                    [[Setting sharedInstance].arrayCompany addObject:obj1];
                    
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(projectDB);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushDid" object:self];
    }
}
@end
