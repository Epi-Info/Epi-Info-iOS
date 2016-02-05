//
//  EpiInfoUniqueIDField.m
//  EpiInfo
//
//  Created by John Copeland on 6/2/14.
//

#import "EpiInfoUniqueIDField.h"
#import "EnterDataView.h"

@implementation EpiInfoUniqueIDField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setEnabled:NO];
        [self setText:nil];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    NSString *newText = text;
    if (text.length == 0)
        newText = [[@"{" stringByAppendingString:CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)))] stringByAppendingString:@"}"];
    [super setText:newText];
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
