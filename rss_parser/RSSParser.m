//
//  RSSParser.m
//  stocksfield
//
//  Created by Alex Antonyuk on 4/19/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RSSParser.h"

#define kItemNodeName			@"item"
#define kTitleNodeName			@"title"
#define kDescriptionNodeName	@"description"
#define kLinkNodeName			@"link"
#define kPubDateNodeName		@"pudDate"

@interface RSSParser() <NSXMLParserDelegate, DataLoaderDelegate> {
	BOOL parsingElement;
}

@property (strong, nonatomic) NSXMLParser* parser;
@property (strong, nonatomic) NSMutableArray* items;

@property (strong, nonatomic) RSSItem* currentItem;
@property (strong, nonatomic) NSMutableString* currentElementValue;

@property (strong, nonatomic) DataLoader* dataLoader;
@property (readonly, nonatomic) NSSet* subNodes;

@end

@implementation RSSParser

@synthesize dataLoader = _dataLoader;

@synthesize delegate = _delegate;
@synthesize parser = _parser;
@synthesize items = _items;
@synthesize currentItem = _currentItem;
@synthesize currentElementValue = _currentElementValue;
@synthesize subNodes = _subNodes;

- (NSSet*)
subNodes
{
	if (!_subNodes) {
		_subNodes = [NSSet setWithObjects:kItemNodeName, kTitleNodeName, kDescriptionNodeName, kLinkNodeName, kPubDateNodeName, nil];
	}
	return _subNodes;
}

- (id)
init
{
	if (self = [super init]) {
		parsingElement = NO;
		_items = [NSMutableArray array];
		_currentElementValue = [NSMutableString string];
	}
	
	return self;
}

- (void)
parseURL:(NSURL *)url
{
	self.dataLoader = [[DataLoader alloc] init];
	self.dataLoader.delegate = self;
	[self.dataLoader loadURL:url];
}

#pragma mark - DataLoader Delegate

- (void)
dataLoaderDidLoadData:(NSData *)data
{
	self.parser = [[NSXMLParser alloc] initWithData:data];
	self.parser.delegate = self;
	[self.parser parse];
	
	[self.delegate rssParserDidParsreData:self.items];
}

- (void)
dataLoaderDidFail:(NSError *)error
{
	[self.delegate rssParserDidFail:error];
}

#pragma mark - XMLParser Delegate

- (void)
parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:kItemNodeName]) {
		parsingElement = YES;
		self.currentItem = [[RSSItem alloc] init];
	}else if ([self.subNodes containsObject:elementName]) {
		[self.currentElementValue setString:@""];
		parsingElement = YES;
	}
}

- (void)
parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:kItemNodeName]) {
		[self.items addObject:self.currentItem];
		self.currentItem = nil;
	}
	if (parsingElement) {
		if ([self.subNodes containsObject:elementName]) {
			[self.currentItem setValue:self.currentElementValue forKey:elementName];
			parsingElement = NO;
		}
	}
}

- (void)
parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (parsingElement) {
		[self.currentElementValue appendString:string];
	}
}

@end
