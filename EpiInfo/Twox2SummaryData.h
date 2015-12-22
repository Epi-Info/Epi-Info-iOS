//
//  Twox2SummaryData.h
//  EpiInfo
//
//  Created by John Copeland on 1/14/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Twox2SummaryData : NSObject
- (void)compute:(NSArray *)stData summaryResults:(double[])suData;
- (void)computeSlowStuff:(NSArray *)stData summaryResults:(double[])suData;
- (void)computeExactOR:(NSArray *)stData summaryResults:(double[])suData;
@end
