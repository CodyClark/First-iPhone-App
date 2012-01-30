//
//  DealerFinderViewController.m
//  ToyotaDealerFinder
//
//  Created by dev on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DealerFinderViewController.h"

@implementation DealerFinderViewController
@synthesize zipCode;
@synthesize activityIndicator;

- (void)viewDidUnload {
    [self setZipCode:nil];
    [self setActivityIndicator:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
- (IBAction)buttonClicked:(id)sender {
    
    //SOAP to access the web service
    /*NSString *soapMsg = 
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<soap:Body>"
     "<getDealers xmlns=\"http://services.tmsbuyatoyota.com/\">"
     "<zipCode>%@</zipCode>"
     "<maxDealers>1</maxDealers>"
     "</getDealers>"
     "</soap:Body>"
     "</soap:Envelope>",  zipCode.text
     ]; 
    
    NSURL *url = [NSURL URLWithString: 
                  @"http://services.tmsbuyatoyota.com/dealers.asmx"];
    NSMutableURLRequest *req = 
    [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = 
    [NSString stringWithFormat:@"%d", [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8"  
forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/getDealers"
forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength 
forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];*/
    
    
    //POST TO WEB SERVICE
    NSString *postString = 
    [NSString stringWithFormat:@"zipCode=%@&maxDealers=1", 
     zipCode.text];
   // NSLog(postString);
    
    NSURL *url = [NSURL URLWithString: 
                  @"http://services.tmsbuyatoyota.com/dealers.asmx/getDealers"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = 
    [NSString stringWithFormat:@"%d", [postString length]];
    
    [req addValue:@"application/x-www-form-urlencoded" 
forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [postString 
                       dataUsingEncoding:NSUTF8StringEncoding]];
    
    [activityIndicator startAnimating];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }        

[activityIndicator startAnimating];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response {
    [webData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data {
    [webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {
    
    //These are no longer allowed with ARC because ti does memory management for you
    
    //[webData release];
    //[connection release];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    NSLog(@"DONE. Received Bytes: %d", [webData length]);
    NSString *theXML = [[NSString alloc] 
                        initWithBytes: [webData mutableBytes] 
                        length:[webData length] 
                        encoding:NSUTF8StringEncoding];
    //---shows the XML---
    NSLog(theXML);
    
    [activityIndicator stopAnimating];   
    
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];

    //[connection release];
    //[webData release];
}


-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    
    if( [elementName isEqualToString:@"dealer"]){
        if(!soapResults){
            NSString *name=[attributeDict objectForKey:@"dealer_name"];
           NSLog(@"Dealer Name:");
            NSLog(name);
            soapResults = [[NSMutableString alloc] init];

        }
        elementFound = YES;
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementFound)
    {
        NSLog(string);
        [soapResults appendString: string];
    }
}

-(void)parser:(NSXMLParser *)parser 
didEndElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"dealer"])
    {
        //---displays the country---
        NSLog(soapResults);
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Dealer found!" 
                              
                              message:@"This will be dealership" 
                              delegate:self  
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil];
        [alert show];
        [soapResults setString:@""];
        elementFound = FALSE; 
    }
}



@end
