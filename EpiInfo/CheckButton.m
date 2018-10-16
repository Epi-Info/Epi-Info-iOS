//
//  CheckButton.m
//  EpiInfo
//
//  Created by John Copeland on 6/4/17.
//

#import "CheckButton.h"

@implementation CheckButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint   (ctx, CGRectGetMinX(rect) + 2, CGRectGetMaxY(rect) - 6);  // top left
    CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMaxY(rect) - 1);  // bottom left
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) - 1, CGRectGetMinY(rect) + 3);  // mid right
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) - 4, CGRectGetMinY(rect) + 1);  // mid right
    CGContextAddLineToPoint(ctx, CGRectGetMidX(rect) - 2, CGRectGetMaxY(rect) - 6);  // bottom left
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect) + 4, CGRectGetMaxY(rect) - 10);  // top left
    
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
    CGContextFillPath(ctx);
}
*/
@end
