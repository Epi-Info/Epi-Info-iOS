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
@synthesize isReadOnly = _isReadOnly;
@synthesize elementLabel = _elementLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (@available(iOS 11.0, *)) {
            [self setSmartQuotesType:UITextSmartQuotesTypeNo];
        } else {
            // Fallback on earlier versions
        }
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
    // Code for correcting bad single and double quote characters already in SQLite
    NSMutableArray *eightytwoeighteens = [[NSMutableArray alloc] init];
    for (int i = 0; i < value.length; i++)
    {
        if ([value characterAtIndex:i] == 8218)
            [eightytwoeighteens addObject:[NSNumber numberWithInteger:i]];
    }
    for (int i = (int)eightytwoeighteens.count - 1; i >= 0; i--)
    {
        NSNumber *num = [eightytwoeighteens objectAtIndex:i];
        value = [value stringByReplacingCharactersInRange:NSMakeRange([num integerValue], 1) withString:@""];
    }
    if ([eightytwoeighteens count] > 0)
    {
        if ([value containsString:[NSString stringWithFormat:@"%c%c", '\304', '\364']])
            value = [value stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c%c", '\304', '\364'] withString:@"'"];
        if ([value containsString:[NSString stringWithFormat:@"%c%c", '\304', '\371']])
            value = [value stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c%c", '\304', '\371'] withString:@"\""];
    }
    //
    [self setText:[value uppercaseString]];
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
    [self setAlpha:1.0 - 1.0 * (int)isHidden];
    if (self.elementLabel)
        [self.elementLabel setAlpha:1.0 - 1.0 * (int)isHidden];
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
