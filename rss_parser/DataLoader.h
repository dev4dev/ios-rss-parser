//
//  DataLoader.h
//  stocksfield
//
//  Created by Alex Antonyuk on 4/19/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataLoaderDelegate <NSObject>

- (void)dataLoaderDidLoadData:(NSData*)data;
- (void)dataLoaderDidFail:(NSError*)error;

@end

@interface DataLoader : NSObject

@property (weak, nonatomic) id<DataLoaderDelegate> delegate;

- (void)loadURL:(NSURL*)url;
- (void)cancel;

@end
