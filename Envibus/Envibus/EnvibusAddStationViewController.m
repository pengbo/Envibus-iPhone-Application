//
//  EnvibusAddStationViewController.m
//  EnvibusV0
//
//  Created by bo on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "EnvibusAddStationViewController.h"

@implementation EnvibusAddStationViewController

@synthesize managedObjectContext, doneButton, stationTable, stationSearchBar, stationArray,spinner;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    doneButton.enabled = false;
    stationSearchBar.delegate = self;
    stationTable.delegate = self;
    stationTable.dataSource = self;
    stationArray = [[NSMutableArray alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setStationSearchBar:nil];
    [self setStationTable:nil];
    [self setStationArray:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar { 
    [stationArray removeAllObjects];
      
    [spinner startAnimating];
    //spinner.hidden = NO;
    NSError * error = nil;
    NSString *url = [NSString stringWithFormat:URL_ENVIBUS_SEARCH, aSearchBar.text];
    HTMLParser * parser = 
        [[HTMLParser alloc] initWithContentsOfURL:
         [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] 
        encoding:NSISOLatin1StringEncoding error:&error];

    if (error) {
        [parser release];
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode * bodyNode = [parser body]; //Find the body tag
    if([[bodyNode findChildrenOfClass:TAG_HTML_RESULT] count] != 0){
        [self initResultData:bodyNode];
    }else{
        [self initFormData:bodyNode];
        [self.stationSearchBar resignFirstResponder];
        [self.stationTable reloadData];
    }
    
    [parser release];
    [spinner stopAnimating];
    //spinner.hidden = YES;

}


- (void) initResultData:(HTMLNode *) bodyNode{
    for(HTMLNode* div in [bodyNode findChildTags:TAG_HTML_DIV]){
        for (HTMLNode * aNode in [div findChildTags:TAG_HTML_A]){
            if([[aNode contents] isEqualToString:TAG_HTML_ACTUALISER]){
                NSString * href = [aNode getAttributeNamed:TAG_HTML_HREF];
                NSRange startRange = [href rangeOfString:URL_ENVIBUS_LIGNO];
                
                NSString *string = [href substringFromIndex:(startRange.location + startRange.length)];
                NSRange endRange = [string rangeOfString:@"&"];
                if(endRange.location != NSNotFound){
                    string = [string substringToIndex:(endRange.location)];
                }
                
                stationID = string;
                [self performSegueWithIdentifier:@"addViewSegue" sender:self];
                return;
            }
        }
    }   
}

- (void)initFormData:(HTMLNode *) bodyNode{
    for (HTMLNode *formulaire in [bodyNode findChildrenOfClass:TAG_HTML_FORMULAIRE]) {
        NSString * stationValue = NULL;   
        for (HTMLNode *tr in [formulaire findChildTags:TAG_HTML_TR]) {
            if( [[tr findChildTags:TAG_HTML_TR] count] > 0) {
                stationValue = [[tr findChildTag:TAG_HTML_INPUT] getAttributeNamed:TAG_HTML_VALUE];
                continue;
            }
            for (HTMLNode *td in [tr findChildTags:TAG_HTML_TD]) {
                if(td.firstChild != NULL && 
                   td.firstChild.firstChild != NULL &&
                   [td.firstChild.firstChild.tagName isEqualToString:TAG_HTML_IMG]){
                    
                    NSMutableDictionary * stationDic = [[NSMutableDictionary alloc] init];
                    NSString *imgUrl = [[td findChildTag:TAG_HTML_IMG] getAttributeNamed:TAG_HTML_SRC];
                    NSString *content = [td.nextSibling allContents];          
                    [stationDic setObject:imgUrl forKey:TAG_DIC_IMGURL];
                    [stationDic setObject:content forKey:TAG_DIC_CONTENT];
                    [stationDic setObject:stationValue forKey:TAG_DIC_ID];
                    [stationArray addObject:stationDic];
                }  
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [stationArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    stationID = [[stationArray objectAtIndex:indexPath.row] valueForKey:TAG_DIC_ID];
    doneButton.enabled = true;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Bus numbers and directions";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *MyIdentifier = @"searchCell";
    UITableViewCell *cell = [stationTable dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
    }
    NSMutableDictionary * content =  [stationArray objectAtIndex:indexPath.row];
     
    NSData *imgdata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[content valueForKey:TAG_DIC_IMGURL]]];
    UIImage *image = [[UIImage alloc] initWithData:imgdata];
    
    cell.imageView.image = image;
    
    [imgdata release];
    [image release];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = [content valueForKey:TAG_DIC_CONTENT];
    return cell;
}

- (void) saveStationData{
    NSManagedObjectContext *context = [(EnvibusAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    Station *station = (Station *)[NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
    
    [station setId:stationID];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
       
    }  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self saveStationData];
}

- (void)dealloc {
    [stationSearchBar release];
    [stationTable release];
    [stationArray release];
    [doneButton release];
    [spinner release];
    [super dealloc];
}

- (IBAction)cancelButtonClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
