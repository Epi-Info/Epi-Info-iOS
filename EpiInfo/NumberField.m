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
@synthesize isReadOnly = _isReadOnly;
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
//    [(CheckCode *)checkcode ownerDidResign];
    BOOL retVal = [super resignFirstResponder];
    if ([[[self superview] superview] isKindOfClass:[EnterDataView class]])
    {
        @try {
            [[(EnterDataView *)[[self superview] superview] fieldsAndStringValues] setObject:self.text forKey:[self.columnName lowercaseString]];
            [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
        } @catch (NSException *exception) {
            //
        } @finally {
            //
        }
    }
    
    return retVal;
}

- (NSString *)epiInfoControlValue
{
    return [self text];
}

- (void)assignValue:(NSString *)value
{
    if (value != nil)
    {
        if ([value length] > 1)
        {
            if ([[value substringFromIndex:[value length] - 2] isEqualToString:@".0"])
            {
                value = [value substringToIndex:[value length] - 2];
            }
        }
        [[(EnterDataView *)[[self superview] superview] fieldsAndStringValues] setObject:value forKey:[self.columnName lowercaseString]];
    }
    [self setText:value];
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    [self setEnabled:isEnabled];
    [self setUserInteractionEnabled:isEnabled];
    [self setAlpha:0.5 + 0.5 * (int)isEnabled];
    [(EnterDataView *)[[self superview] superview] setElementListArrayIsEnabledForElement:self.columnName andIsEnabled:isEnabled];
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
    if (self.isReadOnly)
        [self setIsEnabled:NO];
    else
        [self setIsEnabled:YES];
}

- (void)resetDoNotEnable
{
    [self setText:nil];
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
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
