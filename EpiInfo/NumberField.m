//
//  NumberField.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "EpiInfo-Swift.h"
#import "NumberField.h"
#import "EnterDataView.h"

@implementation NumberField
@synthesize columnName = _columnName;
@synthesize nonNegative = _nonNegative;
@synthesize hasMaximum = _hasMaximum;
@synthesize hasMinimum = _hasMinimum;
@synthesize maximum = _maximum;
@synthesize minimum = _minimum;

- (NSObject *)checkcode
{
    return checkcode;
}
- (void)setCheckcode:(NSObject *)ccode
{
    checkcode = (CheckCode *)ccode;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setNonNegative:NO];
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
    
    NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
    [nsnf setMaximumFractionDigits:6];
    
    NSNumber *testFloat = [NSNumber numberWithFloat:1.1];
    NSString *testFloatString = [nsnf stringFromNumber:testFloat];
    
    if ([testFloatString characterAtIndex:1] == ',')
    {
        validSet = [NSCharacterSet characterSetWithCharactersInString:@"-,0123456789"];
        if ([[self.text substringToIndex:1] stringByTrimmingCharactersInSet:validSet].length > 0)
            self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"#"];
        if ([[self.text substringToIndex:1] isEqualToString:@","])
            validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        else
            validSet = [NSCharacterSet characterSetWithCharactersInString:@",0123456789"];
        for (int i = 1; i < self.text.length; i++)
        {
            if ([[self.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
                self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
            if ([self.text characterAtIndex:i] == ',')
                validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        self.text = [self.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    else
    {
        if (self.nonNegative)
            validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        else
            validSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
        if ([[self.text substringToIndex:1] stringByTrimmingCharactersInSet:validSet].length > 0)
            self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"#"];
        if ([[self.text substringToIndex:1] isEqualToString:@"."])
            validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        else
            validSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
        for (int i = 1; i < self.text.length; i++)
        {
            if ([[self.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
                self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
            if ([self.text characterAtIndex:i] == '.')
                validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        self.text = [self.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    if (self.hasMaximum)
        if ([self.text floatValue] > self.maximum)
            [self setText:[NSString stringWithFormat:@"%.2f", self.maximum]];
    if (self.hasMinimum)
        if ([self.text floatValue] < self.minimum)
            [self setText:[NSString stringWithFormat:@"%.2f", self.minimum]];
}

- (NSString *)value
{
    if ([self.text length] == 0)
        return @"NULL";
    
    NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
    [nsnf setMaximumFractionDigits:6];
    
    return [NSString stringWithFormat:@"%@", [nsnf numberFromString:[self text]]];
}

- (void)setFormFieldValue:(NSString *)formFieldValue
{
    if ([formFieldValue isEqualToString:@"(null)"])
        return;
    
    NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
    [nsnf setMaximumFractionDigits:6];
    
    NSNumber *testFloat = [NSNumber numberWithFloat:1.1];
    NSString *testFloatString = [nsnf stringFromNumber:testFloat];
    
    if ([testFloatString characterAtIndex:1] == ',')
        formFieldValue = [formFieldValue stringByReplacingOccurrencesOfString:@"." withString:@","];
    
    [self setText:formFieldValue];
}

- (BOOL)becomeFirstResponder
{
    NSLog(@"%@ becoming first responder", self.columnName);
    if ([[[self superview] superview] isKindOfClass:[EnterDataView class]])
        [(EnterDataView *)[[self superview] superview] fieldBecameFirstResponder:self];
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    NSLog(@"%@ resigning first responder", self.columnName);
    [(CheckCode *)checkcode ownerDidResign];
    if ([[[self superview] superview] isKindOfClass:[EnterDataView class]])
        [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    
    return [super resignFirstResponder];
}

- (NSString *)epiInfoControlValue
{
    return [self text];
}

- (void)assignValue:(NSString *)value
{
    [self setText:value];
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
