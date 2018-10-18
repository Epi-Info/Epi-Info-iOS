//
//  FormFromGoogleSheetView.m
//  EpiInfo
//
//  Created by John Copeland on 10/18/18.
//

#import "FormFromGoogleSheetView.h"
#import "LegalValuesEnter.h"

@implementation FormFromGoogleSheetView

- (id)initWithFrame:(CGRect)frame andSender:(UIButton *)sender
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        float textViewX = 4.0;
        float textViewWidth = 312.0;
        for (UIView *v in [[sender superview] subviews])
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                if ([[[(UIButton *)v titleLabel] text] containsString:@"Open"])
                {
                    self.runButton = [[UIButton alloc] initWithFrame:v.frame];
                    [self.runButton.layer setMasksToBounds:YES];
                    [self.runButton.layer setCornerRadius:4.0];
                    [self.runButton.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
                    [self.runButton.layer setBorderWidth:1.0];
                    [self.runButton setTitle:@"Make Form" forState:UIControlStateNormal];
                    [self.runButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [self.runButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
                    [self.runButton addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
                    [self.runButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.runButton addTarget:self action:@selector(buttonDragged:) forControlEvents:UIControlEventTouchDragExit];
                    [self.runButton setTag:1011];
                    [self addSubview:self.runButton];
                }
                else if ([[[(UIButton *)v titleLabel] text] containsString:@"Manage"])
                {
                    self.dismissButton = [[UIButton alloc] initWithFrame:v.frame];
                    [self.dismissButton.layer setMasksToBounds:YES];
                    [self.dismissButton.layer setCornerRadius:4.0];
                    [self.dismissButton.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
                    [self.dismissButton.layer setBorderWidth:1.0];
                    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
                    [self.dismissButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [self.dismissButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
                    [self.dismissButton addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
                    [self.dismissButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.dismissButton addTarget:self action:@selector(buttonDragged:) forControlEvents:UIControlEventTouchDragExit];
                    [self.dismissButton setTag:1100];
                    [self addSubview:self.dismissButton];
                }
            }
            else if ([v isKindOfClass:[LegalValuesEnter class]])
            {
                textViewX = v.frame.origin.x;
                textViewWidth = v.frame.size.width;
            }
        }
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(textViewX, 4, textViewWidth, self.runButton.frame.origin.y - 8.0)];
        [backgroundView setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        sheetURL = [[UITextView alloc] initWithFrame:CGRectMake(1, 1, backgroundView.frame.size.width - 2.0, backgroundView.frame.size.height - 2.0)];
        [sheetURL setTextColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [sheetURL setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [sheetURL setText:@"Paste link to public Google sheet here."];
        [sheetURL setDelegate:self];
        [backgroundView addSubview:sheetURL];
        [self addSubview:backgroundView];
    }
    
    return self;
}

- (void)buttonPressed:(UIButton *)sender
{
    [sheetURL resignFirstResponder];
    [sender setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    if ([sender tag] == 1011)
    {
        [sheetURL setTextColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [sheetURL setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [sheetURL setText:@"Form generated from Google sheet. Dismiss this screen and return to \"Enter Data\" to open the form."];
    }
    else if ([sender tag] == 1100)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect sheetViewFrame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [self setFrame:sheetViewFrame];
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }
}

- (void)buttonTouchedDown:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
}
- (void)buttonDragged:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [sheetURL setText:@""];
    [sheetURL setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
    [sheetURL setTextColor:[UIColor blackColor]];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
