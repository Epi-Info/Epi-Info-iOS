//
//  DownTriangleAnalysisStyle.m
//  EpiInfo
//
//  Created by John Copeland on 9/18/19.
//

#import "DownTriangleAnalysisStyle.h"

@implementation DownTriangleAnalysisStyle
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMaxX(rect) * 0.2, CGRectGetMaxY(rect) * 0.4);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) * 0.8, CGRectGetMaxY(rect)  * 0.4);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) / 2.0, CGRectGetMaxY(rect) * 0.6);
    CGContextClosePath(ctx);
    CGContextSetRGBFillColor(ctx, 3/255.0, 36/255.0, 77/255.0, 1);
    CGContextFillPath(ctx);
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
}
@end
