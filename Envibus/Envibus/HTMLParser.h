#import <Foundation/Foundation.h>
#import <libxml/HTMLparser.h>
#import "HTMLNode.h"

@class HTMLNode;

@interface HTMLParser : NSObject 
{
@public
	htmlDocPtr _doc;
}

-(id)initWithContentsOfURL:(NSURL*)url error:(NSError**)error;
-(id)initWithData:(NSData*)data error:(NSError**)error;
-(id)initWithString:(NSString*)string error:(NSError**)error;
-(id)initWithContentsOfURL:(NSURL*)url encoding:(unsigned long)cFStringEncoding error:(NSError**)error;
-(id)initWithData:(NSData*)data encoding:(unsigned long)cFStringEncoding error:(NSError**)error;
//Returns the doc tag
-(HTMLNode*)doc;

//Returns the body tag
-(HTMLNode*)body;

//Returns the html tag
-(HTMLNode*)html;

@end