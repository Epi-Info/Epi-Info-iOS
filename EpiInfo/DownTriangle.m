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
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect) / 2.0);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect) / 2.0);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) / 2.0, CGRectGetMaxY(rect));
    CGContextClosePath(ctx);
    CGContextSetRGBFillColor(ctx, 88/255.0, 89/255.0, 91/255.0, 1);
    CGContextFillPath(ctx);
}
@end
