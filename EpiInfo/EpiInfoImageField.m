//
//  EpiInfoImageField.m
//  EpiInfo
//
//  Created by John Copeland on 1/17/18.
//

#import "EpiInfoImageField.h"

@implementation EpiInfoImageField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addTarget:self action:@selector(selfPressed:) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

- (void)selfPressed:(UIButton *)sender
{
    NSLog(@"Image Button Pressed");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
