//
//  DateMathFunctionInput.m
//  EpiInfo
//
//  Created by John Copeland on 10/10/19.
//

#import "DateMathFunctionInput.h"

@implementation DateMathFunctionInput
- (void)removeSelf:(UIButton *)sender
{
    [super removeSelf:sender];
    if ([[[sender titleLabel] text] isEqualToString:@"Save"])
    {
        NSLog(@"Save button pressed");
    }
    else
    {
        NSLog(@"Cancel button pressed");
    }
}
@end
