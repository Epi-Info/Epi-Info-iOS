//
//  NewVariablesButton.m
//  EpiInfo
//
//  Created by John Copeland on 8/9/13.
//

#import "NewVariablesButton.h"

@implementation NewVariablesButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    for (UIView *v in self.subviews)
    {
        if ([v isKindOfClass:[UILabel class]])
        {
//            float widthWithFont = [[(UILabel *)v text] sizeWithFont:[UIFont systemFontOfSize:16.0]].width;
            // Deprecation replacement
            float widthWithFont = [[(UILabel *)v text] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}].width;
            [v setFrame:CGRectMake(0, frame.size.height / 2 - (widthWithFont + 8) / 2, 50, widthWithFont + 8)];
        }
        else
        {
            if (v.frame.origin.y == 0.0)
            {
                if (v.frame.size.height == 1.0)
                    [v setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height)];
                else
                    [v setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, frame.size.height)];
            }
            else
            {
                [v setFrame:CGRectMake(v.frame.origin.x, frame.size.height - 1, v.frame.size.width, v.frame.size.height)];
            }
        }
    }
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
