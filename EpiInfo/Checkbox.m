//
//  Checkbox.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "Checkbox.h"
#import "EnterDataView.h"

@implementation Checkbox
@synthesize columnName = _columnName;

- (void)setText:(NSString *)checkboxText
{
    NSLog(@"checkboxText = %@", checkboxText);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 30, 30)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        [self.layer setCornerRadius:4.0];
        value = NO;
        button = [[UIButton alloc] initWithFrame:CGRectMake(1, 1, 28, 28)];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button.layer setCornerRadius:3.0];
        [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)setCheckboxAccessibilityLabel:(NSString *)accessibilityLabel
{
    [button setAccessibilityLabel:accessibilityLabel];
}

- (BOOL)value
{
    return value;
}

- (void)setTrueFalse:(NSInteger)trueFalse
{
    if (trueFalse == 1)
    {
        value = YES;
        [button setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        value = NO;
        [button setBackgroundColor:[UIColor whiteColor]];
    }
}
- (void)setFormFieldValue:(NSString *)formFieldValue
{
    [self setTrueFalse:[formFieldValue integerValue]];
}

- (void)buttonPressed
{
    if ([[[self superview] superview] isKindOfClass:[EnterDataView class]])
        [(EnterDataView *)[[self superview] superview] checkboxChanged:self];
    if (value)
    {
        value = NO;
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        value = YES;
        [button setBackgroundColor:[UIColor clearColor]];
    }
    if ([[[self superview] superview] isKindOfClass:[EnterDataView class]])
        [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
}

- (void)reset
{
    value = NO;
    [button setBackgroundColor:[UIColor whiteColor]];
    [self setIsEnabled:YES];
}

- (void)resetDoNotEnable
{
    value = NO;
    [button setBackgroundColor:[UIColor whiteColor]];
}

- (UIButton *)myButton
{
    return button;
}

- (NSString *)epiInfoControlValue
{
    NSString *retVal = @"FALSE";
    if (value)
        retVal = @"TRUE";
    return retVal;
}

- (void)assignValue:(NSString *)val
{
    if ([val isEqualToString:@"TRUE"] || [val isEqualToString:@"(+)"])
        [self setTrueFalse:1];
    else
        [self setTrueFalse:0];
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    [button setEnabled:isEnabled];
    [self setAlpha:0.5 + 0.5 * (int)isEnabled];
}

- (void)selfFocus
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.1f];
        dispatch_async(dispatch_get_main_queue(), ^{
            float yForBottom = [(EnterDataView *)[[self superview] superview] contentSize].height - [(EnterDataView *)[[self superview] superview] bounds].size.height;
            float selfY = self.frame.origin.y - 80.0f;
            
            CGPoint pt = CGPointMake(0.0f, selfY);
            if (selfY > yForBottom)
                pt = CGPointMake(0.0f, yForBottom);
            
            [(EnterDataView *)[[self superview] superview] setContentOffset:pt animated:YES];
        });
    });
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
