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
    // First set the string value in the FieldsAndStringValues object
    if (text != nil)
        [[(EnterDataView *)[[self superview] superview] fieldsAndStringValues] setObject:text forKey:[self.columnName lowercaseString]];
    
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
}

- (void)selfFocus
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.1f];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self isEnabled])
                [self becomeFirstResponder];
            
            float yForBottom = [(EnterDataView *)[[self superview] superview] contentSize].height - [(EnterDataView *)[[self superview] superview] bounds].size.height;
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
