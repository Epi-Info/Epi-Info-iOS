//
//  DateField.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "DateField.h"
#import "DatePicker.h"
#import "EnterDataView.h"

@implementation DateField
@synthesize columnName = _columnName;
@synthesize mirroringMe = _mirroringMe;
@synthesize templateFieldID = _templateFieldID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(textFieldAction) forControlEvents:UIControlEventEditingChanged];
        [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }
    return self;
}

- (void)textFieldAction
{
    int cursorPosition = (int)[self offsetFromPosition:[self endOfDocument] toPosition:[[self selectedTextRange] start]];
    if (self.text.length + cursorPosition == 0)
        return;
    
    NSCharacterSet *validSet;
    validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    if ([[self.text substringToIndex:1] stringByTrimmingCharactersInSet:validSet].length > 0)
        self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"#"];
    validSet = [NSCharacterSet characterSetWithCharactersInString:@"/0123456789"];
    for (int i = 1; i < self.text.length; i++)
    {
        if ([[self.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
            self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
    }
    self.text = [self.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    
    if (self.mirroringMe)
        [self.mirroringMe setText:[self text]];
}

- (void)setFormFieldValue:(NSString *)formFieldValue
{
    if ([formFieldValue isEqualToString:@"(null)"])
        return;
    
    [self setText:formFieldValue];
}

- (BOOL)becomeFirstResponder
{
    [(EnterDataView *)[[self superview] superview] fieldBecameFirstResponder:self];
    
    CGRect finalFrame = [[self superview] superview].frame;
    CGRect initialframe = CGRectMake(finalFrame.origin.x, finalFrame.origin.y - finalFrame.size.height, finalFrame.size.width, finalFrame.size.height);
    
    DatePicker *dp = [[DatePicker alloc] initWithFrame:initialframe AndDateField:self];
    [[[[self superview] superview] superview] addSubview:dp];
    [self resignFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [dp setFrame:finalFrame];
    } completion:^(BOOL finished){
    }];
    return NO;
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
