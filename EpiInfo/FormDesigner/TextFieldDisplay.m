//
//  TextFieldDisplay.m
//  EpiInfo
//
//  Created by John Copeland on 3/6/19.
//

#import "TextFieldDisplay.h"
#import "DownTriangle.h"

@implementation TextFieldDisplay
@synthesize prompt = _prompt;
@synthesize field = _field;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.prompt = [[FormDesignerFieldDisplayPrompt alloc] initWithFrame:CGRectMake(8, 0, frame.size.width - 16, 20)];
        [self.prompt setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [self.prompt setAccessibilityLabel:[NSString stringWithFormat:@"%@: Double tap to edit field properties.", self.prompt.text]];
        [self addSubview:self.prompt];
        self.field = [[UITextField alloc] initWithFrame:CGRectMake(8, 20, self.prompt.frame.size.width, frame.size.height - 20)];
        [self.field setBorderStyle:UITextBorderStyleLine];
        [self.field setEnabled:NO];
        [self.field setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
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
- (void)displayYesNo
{
    [self.field setFrame:CGRectMake(self.field.frame.origin.x, self.field.frame.origin.y, self.frame.size.width / 2 - 4, 20)];
    UITextField *yesField = [[UITextField alloc] initWithFrame:CGRectMake(self.field.frame.origin.x, self.field.frame.origin.y + 20, self.field.frame.size.width, 20)];
    [yesField setBorderStyle:UITextBorderStyleLine];
    [yesField setEnabled:NO];
    [yesField setText:@"Yes"];
    [yesField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [self addSubview:yesField];
    UITextField *noField = [[UITextField alloc] initWithFrame:CGRectMake(yesField.frame.origin.x, yesField.frame.origin.y + 20, self.field.frame.size.width, 20)];
    [noField setBorderStyle:UITextBorderStyleLine];
    [noField setEnabled:NO];
    [noField setText:@"No"];
    [noField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [self addSubview:noField];
}
- (void)displayOption
{
    [self.field setFrame:CGRectMake(self.field.frame.origin.x, self.field.frame.origin.y, self.frame.size.width / 2 - 4, 20)];
    UITextField *yesField = [[UITextField alloc] initWithFrame:CGRectMake(self.field.frame.origin.x, self.field.frame.origin.y + 20, self.field.frame.size.width, 20)];
    [yesField setBorderStyle:UITextBorderStyleLine];
    [yesField setEnabled:NO];
    [yesField setText:@"\u25c9 Option"];
    [yesField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [self addSubview:yesField];
    UITextField *noField = [[UITextField alloc] initWithFrame:CGRectMake(yesField.frame.origin.x, yesField.frame.origin.y + 20, self.field.frame.size.width, 20)];
    [noField setBorderStyle:UITextBorderStyleLine];
    [noField setEnabled:NO];
    [noField setText:@"\u25cb Option"];
    [noField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [self addSubview:noField];
}
- (void)displayImage
{
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.field.frame.origin.x, self.field.frame.origin.y, self.field.frame.size.height, self.field.frame.size.height)];
    [imageButton setEnabled:NO];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"iconCDC_for_image_field"] forState:UIControlStateDisabled];
    [self addSubview:imageButton];
    [self.field removeFromSuperview];
}
- (void)displayLegalValues
{
    [self.field setFrame:CGRectMake(self.field.frame.origin.x, self.field.frame.origin.y, 0.75 * self.field.frame.size.width, self.field.frame.size.height)];
    DownTriangle *dt = [[DownTriangle alloc] initWithFrame:CGRectMake(self.field.frame.origin.x + self.field.frame.size.width - self.field.frame.size.height, self.field.frame.origin.y, self.field.frame.size.height, self.field.frame.size.height)];
    [dt setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
    [self addSubview:dt];
}
- (void)displayPageBreak
{
    [self.field setFrame:CGRectMake(8, 0, self.frame.size.width - 16.0, self.frame.size.height)];
    [self.prompt setFrame:CGRectMake(16, 4, self.frame.size.width - 32.0, self.frame.size.height - 8)];
    [self bringSubviewToFront:self.prompt];
    [self.prompt setText:@"Page Break"];
    [self.prompt setAccessibilityLabel:[NSString stringWithFormat:@"Page Break"]];
    [self.prompt setTextAlignment:NSTextAlignmentCenter];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
