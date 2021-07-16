//
//  NSError+BOXAdditions.h
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (BOXContentSDKAdditions)

- (NSString *)box_localizedFailureReasonString;
- (NSString *)box_localizedShortFailureReasonString;
- (BOOL)isBlockedByShield;

@end
