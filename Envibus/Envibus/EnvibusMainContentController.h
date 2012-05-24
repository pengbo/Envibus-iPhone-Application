//
//  EnvibusMainContentController.h
//  Envibus
//
//  Created by bo on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "EnvibusAppDelegate.h"
#import <UIKit/UIKit.h>

//crab
#define SPIN_INDEX_OF_CURRENT_TIME 0
#define SPIN_INDEX_OF_STATION_NAME 1

@interface EnvibusMainContentController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSString *stationID;
    UIImage *busImage;
    NSDictionary *tableContents;
}

- (void) initControllerView:(Station *) station withContext:(NSManagedObjectContext *)managedObjectContext;

@property (retain, nonatomic) IBOutlet UITableView *displayTableView;
@property (nonatomic, retain) NSString *stationID;
@property (nonatomic, retain) UIImage *busImage;
@property (nonatomic, retain) NSDictionary *tableContents;
@end
