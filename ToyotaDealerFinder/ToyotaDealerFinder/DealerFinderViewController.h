//
//  DealerFinderViewController.h
//  ToyotaDealerFinder
//
//  Created by dev on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealerFinderViewController : UIViewController{
//---outlets---
    IBOutlet UITextField *zipCode;
    IBOutlet UIActivityIndicatorView *activityIndicator;
//---web service access---
NSMutableData *webData;
NSMutableString *soapResults;
NSURLConnection *conn;

//---xml parsing---
NSXMLParser *xmlParser;
BOOL *elementFound;
}

@property (nonatomic, retain) IBOutlet UITextField *zipCode;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)buttonClicked:(id)sender;


@end
