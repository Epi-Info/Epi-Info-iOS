//
//  PhoneNumberField.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "PhoneNumberField.h"

@implementation PhoneNumberField
@synthesize columnName = _columnName;

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
  return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
  NSLog(@"%@ resigning first responder", self.columnName);
  return [super resignFirstResponder];
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
