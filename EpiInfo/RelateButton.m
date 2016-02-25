//
//  RelateButton.m
//  EpiInfo
//
//  Created by John Copeland on 2/25/16.
//

#import "RelateButton.h"

@implementation RelateButton

- (void)setRelatedViewName:(NSString *)rvn
{
    relatedViewName = rvn;
}
- (NSString *)relatedViewName
{
    return relatedViewName;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setImage:[UIImage imageNamed:@"PlainPurpleButton.png"] forState:UIControlStateNormal];
    [self setClipsToBounds:YES];
    [self addTarget:self action:@selector(selfPressed:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [titleButton setTitle:title forState:state];
    [titleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [titleButton addTarget:self action:@selector(titleButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:titleButton];
}

- (void)titleButtonPressed:(UIButton *)sender
{
    [self setHighlighted:YES];
}

- (void)titleButtonReleased:(UIButton *)sender
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self setHighlighted:NO];
}

- (void)selfPressed:(UIButton *)sender
{
    NSLog(@"Load table %@", relatedViewName);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
