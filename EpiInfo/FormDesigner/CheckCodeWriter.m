//
//  CheckCodeWriter.m
//  EpiInfo
//
//  Created by John Copeland on 4/29/19.
//

#import "CheckCodeWriter.h"

@implementation CheckCodeWriter

- (id)initWithFrame:(CGRect)frame AndFieldName:(nonnull NSString *)fn AndFieldType:(nonnull NSString *)ft
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 32)];
        [firstLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [firstLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [firstLabel setTextAlignment:NSTextAlignmentCenter];
        [firstLabel setText:@"Check Code Builder"];
        [self addSubview:firstLabel];
        
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, frame.size.width / 2.0 - 4, 32)];
        [secondLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [secondLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [secondLabel setTextAlignment:NSTextAlignmentRight];
        [secondLabel setText:@"Field Name:"];
        [self addSubview:secondLabel];
        
        UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 + 4, 32, frame.size.width / 2.0 - 4, 32)];
        [thirdLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [thirdLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [thirdLabel setTextAlignment:NSTextAlignmentLeft];
        [thirdLabel setText:[NSString stringWithFormat:@"%@", fn]];
        [self addSubview:thirdLabel];

        UILabel *fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, frame.size.width / 2.0 - 4, 32)];
        [fourthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [fourthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [fourthLabel setTextAlignment:NSTextAlignmentRight];
        [fourthLabel setText:@"Field Type:"];
        [self addSubview:fourthLabel];
        
        UILabel *fifthLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 + 4, 64, frame.size.width / 2.0 - 4, 32)];
        [fifthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [fifthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [fifthLabel setTextAlignment:NSTextAlignmentLeft];
        [fifthLabel setText:[NSString stringWithFormat:@"%@", ft]];
        [self addSubview:fifthLabel];

        UILabel *sixthLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 96, frame.size.width - 16, 32)];
        [sixthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [sixthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [sixthLabel setTextAlignment:NSTextAlignmentLeft];
        [sixthLabel setText:@"Select when execution will occur:"];
        [self addSubview:sixthLabel];

        UIButton *beforeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 128, frame.size.width / 2.0, 32)];
        [beforeButton setBackgroundColor:[UIColor whiteColor]];
        [beforeButton setTitle:@"Before" forState:UIControlStateNormal];
        [beforeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [beforeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [beforeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [beforeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [beforeButton addTarget:self action:@selector(beforeOrAfterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [beforeButton setEnabled:NO];
        [self addSubview:beforeButton];
        
        UIButton *afterButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 128, frame.size.width / 2.0, 32)];
        [afterButton setBackgroundColor:[UIColor whiteColor]];
        [afterButton setTitle:@"After" forState:UIControlStateNormal];
        [afterButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [afterButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [afterButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [afterButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [afterButton addTarget:self action:@selector(beforeOrAfterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:afterButton];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, frame.size.height - 48.0, frame.size.width / 2.0, 32)];
        [closeButton setBackgroundColor:[UIColor whiteColor]];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
    }
    return self;
}

- (void)beforeOrAfterButtonPressed:(UIButton *)sender
{
    UIView *selectFunctionView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [selectFunctionView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:selectFunctionView];
    if ([[[sender titleLabel] text] isEqualToString:@"After"])
    {
        if (YES)
        {
            UIButton *differenceInYearsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, selectFunctionView.frame.size.width / 2.0, 32)];
            [differenceInYearsButton setBackgroundColor:[UIColor whiteColor]];
            [differenceInYearsButton setTitle:@"Years" forState:UIControlStateNormal];
            [differenceInYearsButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [differenceInYearsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [differenceInYearsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [differenceInYearsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [differenceInYearsButton addTarget:self action:@selector(functionSelectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [selectFunctionView addSubview:differenceInYearsButton];
            [selectFunctionView setTag:0];
        }
    }
    else
    {
        NSLog(@"Before button pressed");
    }
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, selectFunctionView.frame.size.height - 32, selectFunctionView.frame.size.width / 2.0, 32)];
    [closeButton setBackgroundColor:[UIColor whiteColor]];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [selectFunctionView addSubview:closeButton];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [selectFunctionView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)functionSelectionButtonPressed:(UIButton *)sender
{
    NSLog(@"%@", [[sender titleLabel] text]);
}

- (void)closeButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[sender superview] setFrame:CGRectMake([sender superview].frame.origin.x, -[sender superview].frame.size.height, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
        [[sender superview] removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
