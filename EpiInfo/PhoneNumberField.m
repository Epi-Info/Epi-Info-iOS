//
//  PhoneNumberField.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "PhoneNumberField.h"
#import "EnterDataView.h"

@implementation PhoneNumberField
@synthesize columnName = _columnName;
@synthesize isReadOnly = _isReadOnly;
@synthesize elementLabel = _elementLabel;

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
    validSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
    for (int i = 0; i < self.text.length; i++)
    {
        if ([[self.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
            self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
    }
    self.text = [self.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
}

- (NSString *)value
{
    if ([self.text length] == 0)
        return @"NULL";
    return self.text;
}

- (void)setFormFieldValue:(NSString *)formFieldValue
{
    if ([formFieldValue isEqualToString:@"(null)"])
        return;
    
    [self setText:formFieldValue];
}

- (BOOL)becomeFirstResponder
{
    NSLog(@"%@ becoming first responder", self.columnName);
    [(EnterDataView *)[[self superview] superview] fieldBecameFirstResponder:self];
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    NSLog(@"%@ resigning first responder", self.columnName);
    BOOL retVal = [super resignFirstResponder];
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    
    return retVal;
}

- (NSString *)epiInfoControlValue
{
    return [self text];
}

- (void)assignValue:(NSString *)value
{
    [self setText:value];
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    [self setEnabled:isEnabled];
    [self setAlpha:0.5 + 0.5 * (int)isEnabled];
    if (self.elementLabel)
        [self.elementLabel setAlpha:0.5 + 0.5 * (int)isEnabled];
}

- (void)setIsHidden:(BOOL)isHidden
{
    [self setEnabled:!isHidden];
    [self setAlpha:1.0 - 0.9 * (int)isHidden];
    if (self.elementLabel)
        [self.elementLabel setAlpha:1.0 - 0.9 * (int)isHidden];
}

- (void)selfFocus
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.1f];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self isEnabled])
                [self becomeFirstResponder];
            
            EnterDataView *myEdv = (EnterDataView *)[[self superview] superview];
            
            float yForBottom = [myEdv contentSize].height - [myEdv bounds].size.height;
            if (yForBottom < 0.0)
                yForBottom = 0.0;
            float selfY = self.frame.origin.y - 80.0f;
            
            CGPoint pt = CGPointMake(0.0f, selfY);
            if (selfY > yForBottom)
                pt = CGPointMake(0.0f, yForBottom);
            
            [myEdv setContentOffset:pt animated:YES];
        });
    });
}

- (void)reset
{
    [self setText:nil];
    [self setIsEnabled:YES];
}

- (void)resetDoNotEnable
{
    [self setText:nil];
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
