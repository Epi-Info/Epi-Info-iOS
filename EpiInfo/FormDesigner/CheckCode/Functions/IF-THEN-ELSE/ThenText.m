//
//  ThenText.m
//  EpiInfo
//
//  Created by John Copeland on 5/17/19.
//

#import "ThenText.h"

@implementation ThenText

- (id)initWithFrame:(CGRect)frame AndCallingButton:(nonnull UIButton *)cb
{
    self = [super initWithFrame:frame AndCallingButton:cb];
    if (self)
    {
        [titleLabel setText:@"THEN (when IF condition is true)"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
