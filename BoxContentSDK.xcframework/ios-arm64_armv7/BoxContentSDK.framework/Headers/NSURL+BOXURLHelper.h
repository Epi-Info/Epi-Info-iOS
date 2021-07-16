//
//  NSURL+BOXURLHelper.h
//  BoxContentSDK
//
//  Created on 2/25/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides query string parsing extensions to `NSURL`.
 */
@interface NSURL (BOXURLHelper)

/**
 * Returns the key value pairs in the URL's query string.
 * @return The key value pairs in the URL's query string.
 */
- (NSDictionary *)box_queryDictionary;

/**
 * Returns the key value pairs given a URL's query string.
 * @param queryString : The URL query string to be broken down into it's key-value pairs.
 *
 * @return The key value pairs in the provided query string.
 */
+ (NSDictionary *)box_queryDictionaryWithString:(NSString *)queryString;

@end
