//
//  TextFieldDisplay.m
//  EpiInfo
//
//  Created by John Copeland on 3/6/19.
//

#import "TextFieldDisplay.h"

@implementation TextFieldDisplay
@synthesize prompt = _prompt;
@synthesize field = _field;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.prompt = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, frame.size.width - 16, 20)];
        [self.prompt setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [self addSubview:self.prompt];
        self.field = [[UITextField alloc] initWithFrame:CGRectMake(8, 20, self.prompt.frame.size.width, frame.size.height - 20)];
        [self.field setBorderStyle:UITextBorderStyleLine];
        [self.field setEnabled:NO];
        [self addSubview:self.field];
    }
    return self;
}
- (void)checkTheBox
{
    [self.field setText:@"\u2713"];
    [self.field setFrame:CGRectMake(self.field.frame.origin.x, self.field.frame.origin.y, self.field.frame.size.height, self.field.frame.size.height)];
}
- (void)displayDate
{
    NSDate *today = [NSDate date];
    NSDateFormatter *fmtr = [[NSDateFormatter alloc] init];
    [fmtr setDateFormat:@"MM/dd/yyyy"];
    [self.field setText:[fmtr stringFromDate:today]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
