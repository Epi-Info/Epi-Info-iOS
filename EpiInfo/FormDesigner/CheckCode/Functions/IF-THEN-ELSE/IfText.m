//
//  IfText.m
//  EpiInfo
//
//  Created by John Copeland on 5/17/19.
//

#import "IfText.h"
#import "FormDesigner.h"

@implementation IfText

- (void)setDestinationOfText:(UITextView *)dot
{
    destinationOfText = dot;
}

- (void)setText:(NSString *)text
{
    [textView setText:text];
}

- (id)initWithFrame:(CGRect)frame AndCallingButton:(nonnull UIButton *)cb
{
    self = [super initWithFrame:frame];
    if (self)
    {
        formDesigner =[cb superview];
        while (![formDesigner isKindOfClass:[FormDesigner class]])
            formDesigner = [formDesigner superview];
        
        UIButton *resignButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [resignButton setBackgroundColor:[UIColor clearColor]];
        [resignButton addTarget:self action:@selector(textViewResign) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resignButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 32)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [titleLabel setText:@"IF Text"];
        [self addSubview:titleLabel];
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(4, titleLabel.frame.origin.y + titleLabel.frame.size.height, titleLabel.frame.size.width - 8, 128)];
        [textView.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
        [textView.layer setBorderWidth:1.0];
        [textView setClipsToBounds:YES];
        [textView setDelegate:self];
        if (@available(iOS 11.0, *)) {
            [textView setSmartQuotesType:UITextSmartQuotesTypeNo];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:textView];
        
        fflvLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, textView.frame.origin.y + textView.frame.size.height, frame.size.width - 16, 32)];
        [fflvLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [fflvLabel setTextAlignment:NSTextAlignmentLeft];
        [fflvLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [fflvLabel setText:[NSString stringWithFormat:@"Available Fields"]];
        [self addSubview:fflvLabel];
        
        fflvSelected = [[UITextField alloc] init];
        [fflvSelected addTarget:self action:@selector(FieldSelected:) forControlEvents:UIControlEventEditingChanged];
        fflv = [[FormFieldsLegalValues alloc] initWithFrame:CGRectMake(4, fflvLabel.frame.origin.y + fflvLabel.frame.size.height - 8, 300, 180)
                                            AndFormDesigner:formDesigner
                                       AndTextFieldToUpdate:fflvSelected];
        [fflv.picker selectRow:0 inComponent:0 animated:YES];
        [self addSubview:fflv];
        
        operatorView = [[UIView alloc] initWithFrame:CGRectMake(0, fflv.frame.origin.y + fflv.frame.size.height, frame.size.width, 94)];
        [self addSubview:operatorView];

        [operatorView setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];

        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4.0,
                                                                           self.frame.size.height - 40,
                                                                           self.frame.size.width / 4.0,
                                                                           32)];
        [closeButton setBackgroundColor:[UIColor whiteColor]];
        [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                          self.frame.size.height - 40,
                                                                          self.frame.size.width / 4.0,
                                                                          32)];
        [saveButton setBackgroundColor:[UIColor whiteColor]];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [saveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [saveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [saveButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
    }
    return self;
}

- (void)closeButtonPressed:(UIButton *)sender
{
    if ([[[sender titleLabel] text] isEqualToString:@"Save"] && [[textView text] length] > 0)
        [destinationOfText setText:[textView text]];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[sender superview] setFrame:CGRectMake([sender superview].frame.origin.x, -[sender superview].frame.size.height, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
        [[sender superview] removeFromSuperview];
    }];
}

- (void)textViewResign
{
    [textView resignFirstResponder];
}

- (void)FieldSelected:(UITextField *)uitv
{
    NSString *textViewString = [textView text];
    if ([textViewString length] > 0)
    {
        NSUInteger lastIndex = [textViewString length] - 1;
        if ([textViewString characterAtIndex:lastIndex] != ' ' && [textViewString characterAtIndex:lastIndex] != '\n')
        {
            textViewString = [textViewString stringByAppendingString:@" "];
        }
    }
    [textView setText:[textViewString stringByAppendingString:[uitv text]]];
}

- (void)operatorButtonPressed:(UIButton *)sender
{
    NSString *operation = [[sender titleLabel] text];
    NSString *textViewString = [textView text];
    if ([operation isEqualToString:@"Missing"])
        operation = @"(.)";
    else if ([operation isEqualToString:@"Yes/True"])
        operation = @"(+)";
    else if ([operation isEqualToString:@"No/False"])
        operation = @"(-)";
    if ([textViewString length] > 0)
    {
        NSUInteger lastIndex = [textViewString length] - 1;
        if ([textViewString characterAtIndex:lastIndex] != ' ' && [textViewString characterAtIndex:lastIndex] != '\n')
        {
            if (!([textViewString characterAtIndex:lastIndex] == '<' && [operation isEqualToString:@">"]))
                textViewString = [textViewString stringByAppendingString:@" "];
        }
    }
    [textView setText:[textViewString stringByAppendingString:[operation uppercaseString]]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
