//
//  FormDesignerFieldDisplayPrompt.m
//  EpiInfo
//
//  Created by John Copeland on 4/10/19.
//

#import "FormDesignerFieldDisplayPrompt.h"

@implementation FormDesignerFieldDisplayPrompt

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setAccessibilityLabel:[NSString stringWithFormat:@"%@. Double tap to edit field properties.", text]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
