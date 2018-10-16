//
//  EpiInfoScrollView.m
//  EpiInfo
//
//  Created by John Copeland on 10/12/12.
//

#import "EpiInfoScrollView.h"

@implementation EpiInfoScrollView

@synthesize scale = _scale;
@synthesize initialContentSize = _initialContentSize;

#define DEFAULT_SCALE 1.0
#define MAX_SCALE 2.0

-(CGFloat)scale
{
    if (!_scale || _scale < DEFAULT_SCALE)
        return DEFAULT_SCALE;
    else if (_scale > MAX_SCALE)
        return MAX_SCALE;
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

- (void)pinch:(UIPinchGestureRecognizer *)gesture BooleanVariable:(BOOL)bv
{
    NSLog(@"%f, %f", [self contentSize].width, self.contentSize.height);
    if ([gesture numberOfTouches] < 2)
        return;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
        lastPoint = [gesture locationInView:self];
    }
    
    // Scale
    CGFloat scale = 1.0 - (lastScale - gesture.scale);
    [self.layer setAffineTransform:CGAffineTransformScale([self.layer affineTransform], scale, scale)];
    self.contentSize = CGSizeMake(scale * self.contentSize.width, scale * self.contentSize.height);
    lastScale = gesture.scale;
    
    // Translate
    point = [gesture locationInView:self];
    [self.layer setAffineTransform:CGAffineTransformTranslate([self.layer affineTransform], point.x - lastPoint.x, point.y - lastPoint.y)];
    lastPoint = [gesture locationInView:self];
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    NSLog(@"pinch:gesture");
    return;
    if ([gesture numberOfTouches] < 2)
        return;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
        lastPoint = [gesture locationInView:self];
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)
    {
        float multiplier = round(100 * gesture.scale) / 100;
//        if ((self.scale > DEFAULT_SCALE && multiplier <= 1.0) || (self.scale < MAX_SCALE && multiplier >= 1.0))
        {
            self.contentSize = CGSizeMake(multiplier * self.contentSize.width, multiplier * self.contentSize.height);
        }
        int i = 0;
        int j = 0;
        for (UIView *view in self.subviews)
        {
            j = 0;
//            if ((self.scale > DEFAULT_SCALE && multiplier <= 1.0) || (self.scale < MAX_SCALE && multiplier >= 1.0))
            {
                [view setFrame:CGRectMake(multiplier * view.frame.origin.x, multiplier * view.frame.origin.y, multiplier * view.frame.size.width, multiplier * view.frame.size.height)];
                if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]])
                {
                    [(UILabel *)view setFont:[UIFont fontWithName:[(UILabel *)view font].fontName size:multiplier * [[(UILabel *)view font] pointSize]]];
                }
                if ([view.subviews count] > 0 && ![view isKindOfClass:[UITextField class]] && ![view isKindOfClass:[UIButton class]] && ![view isKindOfClass:[UISlider class]])
                {
                    for (UIView *subView in view.subviews)
                    {
                        [subView setFrame:CGRectMake(multiplier * subView.frame.origin.x, multiplier * subView.frame.origin.y, multiplier * subView.frame.size.width, multiplier * subView.frame.size.height)];
                        
                        if ([subView isKindOfClass:[UILabel class]] || [subView isKindOfClass:[UITextField class]])
                        {
                            [(UILabel *)subView setFont:[UIFont fontWithName:[(UILabel *)subView font].fontName size:multiplier * [[(UILabel *)subView font] pointSize]]];
                        }
                        j++;
                    }
                }
            }
            i++;
        }
        self.scale *= (1.0 * multiplier);
        gesture.scale = 1;
        //        [self setNeedsDisplay];
        
        // Translate
        point = [gesture locationInView:self];
        point = CGPointMake((1 / self.scale) * self.frame.size.width, (1 / self.scale) * self.frame.size.height);
//        [self setContentOffset:point animated:YES];
    }
}

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

- (void)initialInventoryOfSubviews
{
    NSArray *initialSubViews = self.subviews;
    Xs = [[NSMutableArray alloc] initWithCapacity:[initialSubViews count]];
    Ys = [[NSMutableArray alloc] initWithCapacity:[initialSubViews count]];
    Ws = [[NSMutableArray alloc] initWithCapacity:[initialSubViews count]];
    Hs = [[NSMutableArray alloc] initWithCapacity:[initialSubViews count]];
    for (int i = 0; i < [initialSubViews count]; i++)
    {
        [Xs setObject:[[NSNumber alloc] initWithFloat:[(UIView *)[initialSubViews objectAtIndex:i] frame].origin.x] atIndexedSubscript:i];
        [Ys setObject:[[NSNumber alloc] initWithFloat:[(UIView *)[initialSubViews objectAtIndex:i] frame].origin.y] atIndexedSubscript:i];
        [Ws setObject:[[NSNumber alloc] initWithFloat:[(UIView *)[initialSubViews objectAtIndex:i] frame].size.width] atIndexedSubscript:i];
        [Hs setObject:[[NSNumber alloc] initWithFloat:[(UIView *)[initialSubViews objectAtIndex:i] frame].size.height] atIndexedSubscript:i];
    }
}

@end
