//
//  EpiInfoNumberFormatter.m
//  EpiInfo
//
//  Created by John Copeland on 9/12/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import "EpiInfoNumberFormatter.h"

@implementation EpiInfoNumberFormatter
- (id)initWithFloat:(float)value
{
    self = [super init];
    
    [self setExponentSymbol:@"e"];
    [self setPositiveFormat:@"###,###.##"];
    [self setNegativeFormat:@"-###,###.##"];
    if ((value > 0.0 && value < 100) || (value < 0.0 && value > -100))
    {
        [self setPositiveFormat:@"0.####"];
        [self setNegativeFormat:@"-0.####"];
    }
    if ((value > 0.0 && value < 0.001) || (value < 0.0 && value > -0.001) || value >= 1000000 || value <= -1000000)
    {
        [self setPositiveFormat:@"0.####E+0"];
        [self setNegativeFormat:@"-0.####E+0"];
    }
    
    return self;
}
@end
