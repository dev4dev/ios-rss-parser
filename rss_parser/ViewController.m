//
//  ViewController.m
//  rss_parser
//
//  Created by Alex Antonyuk on 4/19/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "ViewController.h"
#import "RSSParser.h"

@interface ViewController () <RSSParserDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) RSSParser* parser;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) NSArray* items;

@end

@implementation ViewController

@synthesize parser = _parser;
@synthesize tableView = _tableView;
@synthesize items = _items;



- (void)
viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.items = [NSArray array];
	
	NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
	
	self.parser = [[RSSParser alloc] init];
	self.parser.delegate = self;
	[self.parser parseURL:url];
}

- (void)
viewDidUnload
{
	self.parser = nil;
	self.items = nil;
	self.tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - RSSParser Delegate

- (void)
rssParserDidFail:(NSError *)error
{
	NSLog(@"oops %@", error);
}

- (void)
rssParserDidParsreData:(NSArray *)data
{
	if (data.count > 0) {
		[data enumerateObjectsUsingBlock:^(RSSItem* obj, NSUInteger idx, BOOL *stop) {
			NSLog(@"%@", obj.title);
		}];
		self.items = data;
		[self.tableView reloadData];
	}else {
		NSLog(@"there are no items in feed");
	}
}

#pragma mark - TableView DataSource

- (NSInteger)
tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count;
}

#pragma mark - TableView Delegate

- (UITableViewCell*)
tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdent = @"FeedCell";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	if (!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
	}
	
	RSSItem* item = [self.items objectAtIndex:indexPath.row];
	cell.textLabel.text = item.title;
	
	return cell;
}

- (void)
tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RSSItem* item = [self.items objectAtIndex:indexPath.row];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.link]];
}

@end
