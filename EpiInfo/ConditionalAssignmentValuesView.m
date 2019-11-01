//
//  ConditionalAssignmentValuesView.m
//  EpiInfo
//
//  Created by John Copeland on 10/30/19.
//

#import "ConditionalAssignmentValuesView.h"

@implementation ConditionalAssignmentValuesView

- (void)setFilterText:(NSString *)filterText
{
    if (filter)
    {
        [filter setText:[NSString stringWithString:filterText]];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrameForConditionalAssignment:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //Add blueView (that isn't actually blue here and whiteView to create thin blue border line
        //Add all other views to whiteView
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
        [blueView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
        [self addSubview:blueView];
        UIScrollView *whiteView = [[UIScrollView alloc] initWithFrame:CGRectMake(2, 2, blueView.frame.size.width - 4, blueView.frame.size.height - 4)];
        [whiteView setBackgroundColor:[UIColor whiteColor]];
        [blueView addSubview:whiteView];
        
        filter = [[EpiInfoTextView alloc] initWithFrame:CGRectMake(2, 0, whiteView.frame.size.width - 4, 128)];
        [whiteView addSubview:filter];
        [filter setText:@"Condition\ntext\nhere"];
        [filter setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [filter setIsEnabled:NO];
        
        UILabel *uil0 = [[UILabel alloc] initWithFrame:CGRectMake(2, filter.frame.size.height, filter.frame.size.width, 28)];
        [uil0 setText:@"Value when condition is true:"];
        [uil0 setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [uil0 setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [uil0 setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:uil0];
        trueValueLVE = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, uil0.frame.origin.y + uil0.frame.size.height, 300, 180) AndListOfValues:[NSMutableArray arrayWithArray:@[@"", @"Yes", @"No"]]];
        [trueValueLVE setTag:1201];
        [trueValueLVE analysisStyle];
        [whiteView addSubview:trueValueLVE];
        
        UILabel *uil1 = [[UILabel alloc] initWithFrame:CGRectMake(2, trueValueLVE.frame.origin.y + trueValueLVE.frame.size.height, filter.frame.size.width, 28)];
        [uil1 setText:@"Else value (optional):"];
        [uil1 setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [uil1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [uil1 setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:uil1];
        elseValueLVE = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, uil1.frame.origin.y + uil1.frame.size.height, 300, 180) AndListOfValues:[NSMutableArray arrayWithArray:@[@"", @"Yes", @"No"]]];
        [elseValueLVE setTag:1202];
        [elseValueLVE analysisStyle];
        [whiteView addSubview:elseValueLVE];

        float side = 40;
        saveButton = [[UIButton alloc] initWithFrame:CGRectMake(4, self.frame.size.height - side - 4, 2.5 * side, side)];
        [saveButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [saveButton.layer setCornerRadius:2];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setAccessibilityLabel:@"Save variable and return to new variables screen"];
        [saveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [saveButton addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:saveButton];
        
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 2.5 * side - 4, self.frame.size.height - side - 4, 2.5 * side, side)];
        [cancelButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [cancelButton.layer setCornerRadius:2];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setAccessibilityLabel:@"Cancel and return to new variables screen"];
        [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:cancelButton];
    }
    return self;
}

- (void)removeSelf:(UIButton *)sender
{
    [super removeSelf:sender];
    if ([[[sender titleLabel] text] isEqualToString:@"Save"])
    {
        NSString *firstArgument = @"";
        if ([firstArgument length] == 0)
            firstArgument = [trueValueLVE epiInfoControlValue];
        NSString *secondArgument = @"";
        if ([secondArgument length] == 0)
            secondArgument = [elseValueLVE epiInfoControlValue];
        if ([firstArgument length] == 0 || [firstArgument isEqualToString:@"NULL"] || [firstArgument isEqualToString:@"Literal Date"] || [secondArgument length] == 0 || [secondArgument isEqualToString:@"NULL"] || [secondArgument isEqualToString:@"Literal Date"])
            return;
        NSString *functionWithArguments = [NSString stringWithFormat:@"%@ = WHEN %@ THEN '%@' ELSE '%@' |~| %@", newVariableName, [filter text], firstArgument, secondArgument, newVariableType];
        [listOfNewVariables addObject:functionWithArguments];
        [newVariableList reloadData];
        [(NewVariablesView *)[[[newVariableList superview] superview] superview] addToListOfAllVariables:newVariableName];
    }
    else
    {
    }
}

- (void)hideSelf
{
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [self setFrame:CGRectMake(0, self.frame.size.height + 4.0, self.frame.size.width, self.frame.size.height)];
    }completion:^(BOOL finished){
        [self removeSelfFromSuperview];
    }];
}

- (BOOL)removeSelfFromSuperview
{
    [self removeFromSuperview];
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
