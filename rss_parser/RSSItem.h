//
//  RSSItem.h
//  stocksfield
//
//  Created by Alex Antonyuk on 4/19/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject

@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* link;
@property (copy, nonatomic) NSString* pubDate;
@property (copy, nonatomic) NSString* description;

@end
