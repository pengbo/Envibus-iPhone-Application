//
//  EnvibusFlipsideViewController.m
//  EnvibusV0
//
//  Created by bo on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "EnvibusFlipsideViewController.h"

@implementation EnvibusFlipsideViewController

@synthesize stationTable = _stationTable;
@synthesize delegate = _delegate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    EnvibusAppDelegate * delegate = (EnvibusAppDelegate *)[[UIApplication sharedApplication] delegate];
    _fetchedResultsController = [delegate fetchedResultsController];
                        
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    _stationTable.editing = YES;
}

- (void)viewDidUnload
{
    [self setStationTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* stations = [_fetchedResultsController fetchedObjects];
    return [stations count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Stations";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *MyIdentifier = @"direction";
    UITableViewCell *cell = [_stationTable dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:MyIdentifier] autorelease];
    }
    
    Station *station = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    NSData *imgdata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[station imgUrl]]];
    UIImage *image = [[UIImage alloc] initWithData:imgdata];
    cell.imageView.image = image;
    [imgdata release];
    [image release];
    cell.textLabel.text = [station name];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    cell.detailTextLabel.text = [station direction];    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    if(cell.detailTextLabel.text != nil){
        cell.detailTextLabel.text = [@"direction: " stringByAppendingString:cell.detailTextLabel.text];
    }
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[_fetchedResultsController managedObjectContext] deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
        
		NSError *error;
		if (![[_fetchedResultsController managedObjectContext] save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }
    [self.stationTable reloadData];
}

- (void)dealloc {
    [_stationTable release];
    [_managedObjectContext release];
    [super dealloc];
}
@end
