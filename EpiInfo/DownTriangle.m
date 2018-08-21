//
//  DownTriangle.m
//  EpiInfo
//
//  Created by John Copeland on 8/16/18.
//

#import "DownTriangle.h"

@implementation DownTriangle
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMaxX(rect) * 0.2, CGRectGetMaxY(rect) * 0.4);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) * 0.8, CGRectGetMaxY(rect)  * 0.4);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) / 2.0, CGRectGetMaxY(rect) * 0.6);
    CGContextClosePath(ctx);
    CGContextSetRGBFillColor(ctx, 88/255.0, 89/255.0, 91/255.0, 1);
    CGContextFillPath(ctx);
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
}
@end
