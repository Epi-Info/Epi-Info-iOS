//
//  EpiInfoTextField.m
//  EpiInfo
//
//  Created by John Copeland on 12/31/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "EpiInfoTextField.h"
#import "EnterDataView.h"

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
    @try {
        [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    } @catch (NSException *exception) {
        //
    } @finally {
        //
    }
    
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

- (void)setIsEnabled:(BOOL)isEnabled
{
    [self setEnabled:isEnabled];
    [self setAlpha:0.5 + 0.5 * (int)isEnabled];
}

- (void)selfFocus
{
    if ([self isEnabled])
        [self becomeFirstResponder];
    
    CGPoint pt = self.frame.origin;
    [(EnterDataView *)[[self superview] superview] setContentOffset:pt animated:YES];
    if ([(EnterDataView *)[[self superview] superview] contentOffset].x == pt.x && [(UIScrollView *)[self superview] contentOffset].y == pt.y)
        NSLog(@"Scrolled to point %f, %f", pt.x, pt.y);
    else
    {
        NSLog(@"Couldn't scroll to point %f, %f", pt.x, pt.y);
        NSLog(@"Scrolling to bottom instead.");
        pt = CGPointMake(0, [(EnterDataView *)[[self superview] superview] contentSize].height - [(EnterDataView *)[[self superview] superview] bounds].size.height);
        [(EnterDataView *)[[self superview] superview] setContentOffset:pt animated:YES];
    }
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
