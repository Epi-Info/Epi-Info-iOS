//
//  CETextField.m
//  EpiInfo
//
//  Created by John Copeland on 5/6/19.
//

#import "CETextField.h"

@implementation CETextField

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
