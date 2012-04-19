//
//  RSSParser.h
//  stocksfield
//
//  Created by Alex Antonyuk on 4/19/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataLoader.h"
#import "RSSItem.h"

@protocol RSSParserDelegate <NSObject>

- (void)rssParserDidParsreData:(NSArray*)data;
@optional
- (void)rssParserDidFail:(NSError*)error;

@end

@interface RSSParser : NSObject

@property (weak, nonatomic) id<RSSParserDelegate> delegate;

- (void)parseURL:(NSURL*)url;

@end
