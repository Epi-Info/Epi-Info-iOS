//
//  DateTimeField.m
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import "DateTimeField.h"
#import "EnterDataView.h"

@implementation DateTimeField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (BOOL)becomeFirstResponder
{
    [(EnterDataView *)[[self superview] superview] fieldBecameFirstResponder:self];
    
    return [super becomeFirstResponder];
    //    return NO;
}

- (BOOL)resignFirstResponder
{
    NSLog(@"%@ resigning first responder", self.columnName);
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    
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
