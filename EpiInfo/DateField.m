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
{
    DatePicker *dp;
}
@synthesize columnName = _columnName;
@synthesize isReadOnly = _isReadOnly;
@synthesize mirroringMe = _mirroringMe;
@synthesize templateFieldID = _templateFieldID;
@synthesize fieldLabel = _fieldLabel;
@synthesize elementLabel = _elementLabel;
@synthesize lower = _lower;
@synthesize upper = _upper;

- (id)initWithFrame:(CGRect)frame
{
    float minWidth = 110.0;
    if (frame.size.width < minWidth)
        frame = CGRectMake(frame.origin.x, frame.origin.y, minWidth, frame.size.height);
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
    // First remove midnight if necessary
    NSString *textToUse = [NSString stringWithString:text];
    if (textToUse != nil && textToUse.length > 3 && ![self isKindOfClass:[DateTimeField class]])
    {
        NSRange ran = NSMakeRange(text.length - 4, 4);
        if ([[text substringWithRange:ran] isEqualToString:@"0:00"])
            textToUse = [[text componentsSeparatedByString:@" "] objectAtIndex:0];
    }
    
    // Then set the string value in the FieldsAndStringValues object
    if (textToUse != nil)
    {
        @try {
            [[(EnterDataView *)[[self superview] superview] fieldsAndStringValues] setObject:textToUse forKey:[self.columnName lowercaseString]];
        } @catch (NSException *exception) {
        } @finally {
        }
    }
    
    [super setText:textToUse];
    
    @try {
        [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    } @catch (NSException *exception) {
    } @finally {
    }
    
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
    if (dp)
        if ([dp superview] == [[[self superview] superview] superview])
            return NO;
    @try {
        [(EnterDataView *)[[self superview] superview] fieldBecameFirstResponder:self];
    } @catch (NSException *exception) {
    } @finally {
    }
    
    CGRect finalFrame = [[self superview] superview].frame;
    CGRect initialframe = CGRectMake(finalFrame.origin.x, finalFrame.origin.y - finalFrame.size.height, finalFrame.size.width, finalFrame.size.height);
    
    dp = [[DatePicker alloc] initWithFrame:initialframe AndDateField:self];
    [[[[self superview] superview] superview] addSubview:dp];
    [self resignFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [dp setFrame:finalFrame];
    } completion:^(BOOL finished){
    }];
    return NO;
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
            
            float yForBottom = [(EnterDataView *)[[self superview] superview] contentSize].height - [(EnterDataView *)[[self superview] superview] bounds].size.height;
            if (yForBottom < 0.0)
                yForBottom = 0.0;
            float selfY = self.frame.origin.y - 80.0f;
            
            CGPoint pt = CGPointMake(0.0f, selfY);
            if (selfY > yForBottom)
                pt = CGPointMake(0.0f, yForBottom);
            
            [(EnterDataView *)[[self superview] superview] setContentOffset:pt animated:YES];
        });
        [NSThread sleepForTimeInterval:0.3f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [(EnterDataView *)[[self superview] superview] doResignAll];
        });
    });
}

- (void)reset
{
    [super setText:nil];
    [self setIsEnabled:YES];
}

- (void)resetDoNotEnable
{
    [super setText:nil];
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
