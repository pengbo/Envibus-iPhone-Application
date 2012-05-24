//
//  EnvibusMainViewController.m
//  EnvibusV0
//
//  Created by bo on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "EnvibusMainViewController.h"

@implementation EnvibusMainViewController
@synthesize pageControl = _pageControl;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize scrollView, stationArray, viewControllers;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    EnvibusAppDelegate * delegate = (EnvibusAppDelegate *)[[UIApplication sharedApplication]delegate];
    _fetchedResultsController = [delegate fetchedResultsController];
    
    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    stationArray = [_fetchedResultsController fetchedObjects];
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [stationArray count]; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    // a page is the width of the scroll view
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [stationArray count], scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    _pageControl.currentPage = 0;
    [self loadViewWithPage:0];
    [self loadViewWithPage:1];
}

- (void)loadViewWithPage:(int)page
{
    if (page < 0 || page >= [stationArray count]){
        return;
    }
    
    // replace the placeholder if necessary
    EnvibusMainContentController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        controller = [myStoryboard instantiateViewControllerWithIdentifier:@"EnvibusMainContentController"];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [scrollView addSubview:controller.view];
        
        Station *station = [stationArray objectAtIndex:page];
        [controller initControllerView:station withContext:[_fetchedResultsController managedObjectContext]];
    }
    
}

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
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

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(EnvibusFlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
    
    for(UIView *subview in [scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    [self viewDidLoad];
          
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadViewWithPage:page - 1];
    [self loadViewWithPage:page];
    [self loadViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changPage:(id)sender {
    int page = _pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadViewWithPage:page - 1];
    [self loadViewWithPage:page];
    [self loadViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}

- (void)dealloc
{
    [_pageControl release];
    [_managedObjectContext release];
    [_fetchedResultsController release];
    [scrollView release];
    [super dealloc];
}
@end

