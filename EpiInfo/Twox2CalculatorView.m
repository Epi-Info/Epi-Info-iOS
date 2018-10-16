//
//  Twox2CalculatorView.m
//  StatCalc2x2
//
//  Created by John Copeland on 9/7/12.
//

#import "Twox2CalculatorView.h"

@implementation Twox2CalculatorView

@synthesize scale = _scale;

#define DEFAULT_SCALE 1.0

-(CGFloat)scale
{
    if (!_scale || _scale < 1.0)
        return DEFAULT_SCALE;
    else
        return _scale;
}

-(void)setScale:(CGFloat)scale
{
    if (scale != _scale)
    {
        _scale = scale;
        [self setNeedsDisplay];
    }
}
/*
-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)
    {
        self.scale *= (1.0 * gesture.scale);
        self.contentSize = CGSizeMake(self.scale * self.contentSize.width, self.scale * self.contentSize.height);
        gesture.scale = 1;
//        [self setNeedsDisplay];
    }
}
*/
-(void)setup
{
//    self.contentMode =  UIViewContentModeRedraw;
}

-(void)awakeFromNib
{
    [self setup];
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
