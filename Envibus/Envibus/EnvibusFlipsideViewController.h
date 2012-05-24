//
//  EnvibusFlipsideViewController.h
//  EnvibusV0
//
//  Created by bo on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnvibusAppDelegate.h"

@class EnvibusFlipsideViewController;

@protocol EnvibusFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(EnvibusFlipsideViewController *)controller;
@end

@interface EnvibusFlipsideViewController: 
        UIViewController<UITableViewDelegate,UITableViewDataSource>{
}

@property (assign, nonatomic) IBOutlet id <EnvibusFlipsideViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITableView *stationTable;

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (IBAction)done:(id)sender;

@end
