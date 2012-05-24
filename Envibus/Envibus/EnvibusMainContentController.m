//
//  EnvibusMainContentController.m
//  Envibus
//
//  Created by bo on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "EnvibusMainContentController.h"

@implementation EnvibusMainContentController
@synthesize stationID, busImage, displayTableView, tableContents;

- (void)viewDidLoad
{
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    displayTableView.backgroundColor = [UIColor clearColor];
    displayTableView.opaque = NO;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    displayTableView.backgroundView = imageView;
    [imageView release];
    
    [super viewDidLoad];
}

- (void) initControllerView:(Station *) station withContext:(NSManagedObjectContext *)managedObjectContext{    
    NSError * error = nil;
    stationID = [station id];
    NSString *url = [NSString stringWithFormat:URL_ENVIBUS_FIND, stationID];
    HTMLParser * parser = 
    [[HTMLParser alloc] initWithContentsOfURL:
     [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] encoding:NSISOLatin1StringEncoding error:&error];
    
    if (error) {
        [parser release];
        NSLog(@"Error: %@", error);
        return;
    }
    
    for (HTMLNode *result in [[parser body] findChildrenOfClass:TAG_HTML_RESULT]) {
        //set station name
        NSArray *previousSpans = [[result previousSibling] findChildTags:@"span"];
        [station setName:[[previousSpans objectAtIndex:SPIN_INDEX_OF_STATION_NAME] contents]];
        
        //set bus direction
        HTMLNode *direction = [result findChildTag:@"b"];
        [station setDirection:[direction allContents]];
        
        NSDictionary *infodic = [[NSDictionary alloc]initWithObjectsAndKeys: 
                                 [direction contents],@"Direction",
                                 [[previousSpans objectAtIndex:SPIN_INDEX_OF_CURRENT_TIME] contents],@"Current Time",
                                 [[previousSpans objectAtIndex:SPIN_INDEX_OF_STATION_NAME] contents],@"StationName",
                                 nil];
        
        NSMutableArray *timeArray = [[NSMutableArray alloc] init];
        NSArray *spans = [result findChildTags:@"span"];
        for (HTMLNode * span in spans){
            [timeArray addObject:[span contents]];
        }
        
        HTMLNode *img = [result findChildTag:TAG_HTML_IMG];
        [station setImgUrl:[img getAttributeNamed:TAG_HTML_SRC]];
        
        NSData *imgdata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[img getAttributeNamed:TAG_HTML_SRC]]];
        busImage = [[UIImage alloc] initWithData:imgdata];
        [imgdata release];
        
        NSDictionary *dic =[[NSDictionary alloc]
                             initWithObjectsAndKeys:infodic,@"Information",timeArray,
                             @"Arrival Time",nil];
        self.tableContents =dic;
        [infodic release];
        [timeArray release];
        [dic release];
    }
    [parser release];
    
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableContents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{   
    return [[self.tableContents objectForKey:[[self.tableContents allKeys] objectAtIndex:section]] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.tableContents allKeys] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString * title = [[self.tableContents allKeys] objectAtIndex:indexPath.section];
    
    if([title isEqualToString:@"Information"]){
        NSString *MyIdentifier = @"info";
        cell = [displayTableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:MyIdentifier] autorelease];
        }
        NSDictionary *infoDic = [self.tableContents objectForKey:title];
        cell.textLabel.text = [[infoDic allKeys] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [infoDic objectForKey:cell.textLabel.text];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];                                         
        
    }else{
        NSString *MyIdentifier = @"time";
        cell = [displayTableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier] autorelease];
        }
        NSArray* timeArray = [self.tableContents objectForKey:title];
        cell.imageView.image = busImage;
        cell.textLabel.text = [timeArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (void)dealloc
{
    [displayTableView release];
    [tableContents release];
    [busImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDisplayTableView:nil];
    [self setTableContents:nil];
    [self setView:nil];
    [super viewDidUnload];
}
@end
