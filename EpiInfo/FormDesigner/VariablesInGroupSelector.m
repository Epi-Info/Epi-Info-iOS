//
//  VariablesInGroupSelector.m
//  EpiInfo
//
//  Created by John Copeland on 12/6/19.
//

#import "VariablesInGroupSelector.h"

@implementation VariablesInGroupSelector

- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov AndTextFieldToUpdate:(UITextField *)tftu
{
    self = [super initWithFrame:frame AndListOfValues:lov AndTextFieldToUpdate:tftu];
    if (self)
        [self setFrame:frame];
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [valueButtonView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.valueButton setFrame:CGRectMake(8, 8, valueButtonView.frame.size.width - 16, 48)];
    [self.tv setFrame:CGRectMake(self.tv.frame.origin.x, self.tv.frame.origin.y, self.valueButton.frame.size.width, self.tv.frame.size.height)];
    for (UIView *v in [self.valueButton subviews])
    {
        if ([v isKindOfClass:[DownTriangle class]])
        {
            [v setFrame:CGRectMake(self.valueButton.frame.size.width - 1.0 - v.frame.size.width, v.frame.origin.y, v.frame.size.width, v.frame.size.height)];
            break;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
