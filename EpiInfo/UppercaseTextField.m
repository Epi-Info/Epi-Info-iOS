//
//  UppercaseTextField.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "UppercaseTextField.h"
#import "EnterDataView.h"
@implementation UppercaseTextField
@synthesize columnName = _columnName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    }
    return self;
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
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    
    return [super resignFirstResponder];
}

- (NSString *)epiInfoControlValue
{
    return [self text];
}

- (void)assignValue:(NSString *)value
{
    [self setText:[value uppercaseString]];
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    [self setEnabled:isEnabled];
    [self setAlpha:0.5 + 0.5 * (int)isEnabled];
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
