//
//  EnvibusAddStationViewController.h
//  EnvibusV0
//
//  Created by bo on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnvibusAppDelegate.h"

@interface EnvibusAddStationViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>{
@private
    NSMutableArray * stationArray;
    NSString * stationID;
    IBOutlet UIActivityIndicatorView *spinner;
}

-(void)initResultData:(HTMLNode*)bodyNode;
-(void)initFormData:(HTMLNode*)bodyNode;
-(void)saveStationData;

@property (nonatomic, retain) NSMutableArray *stationArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) IBOutlet UISearchBar *stationSearchBar;
@property (retain, nonatomic) IBOutlet UITableView *stationTable;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)cancelButtonClick:(id)sender;


@end