//
//  EpiInfoTextField.m
//  EpiInfo
//
//  Created by John Copeland on 12/31/13.
//

#import "EpiInfoTextField.h"
#import "EnterDataView.h"
#import "DataEntryViewController.h"

@implementation EpiInfoTextField
@synthesize columnName = _columnName;
@synthesize isReadOnly = _isReadOnly;
@synthesize mirroringMe = _mirroringMe;
@synthesize checkcode = _checkcode;
@synthesize elementLabel = _elementLabel;
@synthesize maxLength = _maxLength;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setMaxLength:0];
        if (@available(iOS 11.0, *)) {
            [self setSmartQuotesType:UITextSmartQuotesTypeNo];
        } else {
            // Fallback on earlier versions
        }
        [self addTarget:self action:@selector(textFieldAction) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)textFieldAction
{
    if (self.maxLength > 0 && [self.text length] > self.maxLength)
        [super setText:[self.text substringToIndex:self.maxLength]];
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
    NSLog(@"%@ becoming first responder", self.columnName);
    @try {
        [(EnterDataView *)[[self superview] superview] fieldBecameFirstResponder:self];
    } @catch (NSException *exception) {
        //
    } @finally {
        //
    }
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    NSLog(@"%@ resigning first responder", self.columnName);
    BOOL retVal = [super resignFirstResponder];
    @try {
        [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
        [[(EnterDataView *)[[self superview] superview] fieldsAndStringValues] setObject:self.text forKey:[self.columnName lowercaseString]];
    } @catch (NSException *exception) {
        //
    } @finally {
        //
    }

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
    [self setText:value];
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    [self setEnabled:isEnabled];
    [self setUserInteractionEnabled:isEnabled];
    [self setAlpha:0.5 + 0.5 * (int)isEnabled];
    if (self.elementLabel)
        [self.elementLabel setAlpha:0.5 + 0.5 * (int)isEnabled];
    if ([[[self superview] superview] isKindOfClass:[EnterDataView class]])
        [(EnterDataView *)[[self superview] superview] setElementListArrayIsEnabledForElement:self.columnName andIsEnabled:isEnabled];
}

- (void)setIsHidden:(BOOL)isHidden
{
    [self setEnabled:!isHidden];
    [self setUserInteractionEnabled:!isHidden];
    [self setAlpha:1.0 - 1.0 * (int)isHidden];
    if (self.elementLabel)
        [self.elementLabel setAlpha:1.0 - 1.0 * (int)isHidden];
    if ([[[self superview] superview] isKindOfClass:[EnterDataView class]])
        [(EnterDataView *)[[self superview] superview] setElementListArrayIsEnabledForElement:self.columnName andIsEnabled:!isHidden];
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

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (self.maxLength > 0 && text && [text length] > self.maxLength)
        [super setText:[text substringToIndex:self.maxLength]];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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
