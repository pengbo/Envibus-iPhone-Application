//
//  Utility.m
//  Envibus
//
//  Created by bo on 11-12-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities


//+ (NSArray *) fetchedResults:(NSManagedObjectContext *)context {
//    //NSManagedObjectContext * context = [self managedObjectContext];
//    NSEntityDescription *entityDescription = [NSEntityDescription
//                                              entityForName:@"Station" inManagedObjectContext:context];
//    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
//    [request setEntity:entityDescription];
//    
//    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"stationID" ascending:YES];
//    //[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    //[sortDescriptor release];
//    
//    NSError *error = nil;
//    NSArray *array = [context executeFetchRequest:request error:&error];
//    //TODO hanle error
//    
//    NSLog(@"array: %d",[array count]);
//    
//    return array;
//}

   

@end
