//
//  EnvibusMainViewController.h
//  EnvibusV0
//
//  Created by bo on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import "EnvibusAppDelegate.h"
#import "EnvibusFlipsideViewController.h"
#import "EnvibusMainContentController.h"
#import <CoreData/CoreData.h>

@interface EnvibusMainViewController : UIViewController <UIScrollViewDelegate, EnvibusFlipsideViewControllerDelegate>{
    BOOL pageControlUsed;
    UIScrollView *scrollView;
    NSMutableArray *viewControllers;
    NSManagedObjectContext *managedObjectContext;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (retain, nonatomic) NSMutableArray *viewControllers;
@property (retain, nonatomic) NSArray *stationArray;

@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
- (void) loadViewWithPage:(int)page;
- (IBAction)changPage:(id)sender;
@end
