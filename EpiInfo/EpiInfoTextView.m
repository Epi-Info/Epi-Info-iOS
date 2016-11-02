//
//  EpiInfoTextView.m
//  EpiInfo
//
//  Created by John Copeland on 12/31/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "EpiInfoTextView.h"
#import "EnterDataView.h"

@implementation EpiInfoTextView
@synthesize columnName = _columnName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    if (self.columnName)
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
