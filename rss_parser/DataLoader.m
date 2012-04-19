//
//  DataLoader.m
//  stocksfield
//
//  Created by Alex Antonyuk on 4/19/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "DataLoader.h"

@interface DataLoader() <NSURLConnectionDelegate>

@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSMutableData* data;

@end

@implementation DataLoader

@synthesize connection = _connection;
@synthesize data = _data;

@synthesize delegate = _delegate;

- (void)
loadURL:(NSURL *)url
{
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	if (self.connection) {
		self.data = [NSMutableData data];
	}
}

- (void)
cancel
{
	[self.connection cancel];
	self.connection = nil;
}

#pragma mark - URLConnection Delegate

- (void)
connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
	[self.data appendData:data];
}

- (void)
connectionDidFinishLoading:(NSURLConnection *)connection
{
	self.connection = nil;
	[self.delegate dataLoaderDidLoadData:self.data];
	self.data = nil;
}

- (void)
connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self.data setLength:0];
}

- (void)
connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.connection = nil;
	[self.delegate dataLoaderDidFail:error];
}

@end
