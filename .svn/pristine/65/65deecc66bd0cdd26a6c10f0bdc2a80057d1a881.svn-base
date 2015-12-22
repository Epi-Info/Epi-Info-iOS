//
//  ConverterMethods.m
//  EpiInfo
//
//  Created by John Copeland on 5/20/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import "ConverterMethods.h"

@implementation ConverterMethods
+ (NSString *)hexArrayToDecArray:(NSData *)hexes
{
    NSString *hex = [[[[NSString stringWithFormat:@"%@", hexes] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSString *dec = @"{";
    
    int i = 0;
    while (i < hex.length)
    {
        if (i > 0)
            dec = [dec stringByAppendingString:@","];
        dec = [dec stringByAppendingString:[NSString stringWithFormat:@" %d", [self hexToDec:[hex substringWithRange:NSMakeRange(i, 2)]]]];
        i += 2;
    }
    dec = [dec stringByAppendingString:@" }"];

    return dec;
}

+ (int)hexToDec:(NSString *)hex
{
    unsigned result;
    [[NSScanner scannerWithString:hex] scanHexInt:&result];
    return result;
}
@end
