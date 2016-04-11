//
//  EpiInfoTextField.m
//  EpiInfo
//
//  Created by John Copeland on 12/31/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "EpiInfoTextField.h"

@implementation EpiInfoTextField
@synthesize columnName = _columnName;
@synthesize mirroringMe = _mirroringMe;
@synthesize checkcode = _checkcode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(textFieldAction) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)textFieldAction
{
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
  return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
  NSLog(@"%@ resigning first responder", self.columnName);
  return [super resignFirstResponder];
}

- (NSString *)epiInfoControlValue
{
    return [self text];
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
