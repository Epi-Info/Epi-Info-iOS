//
//  ConditionalAssignmentView.m
//  EpiInfo
//
//  Created by John Copeland on 10/28/19.
//

#import "ConditionalAssignmentView.h"

@implementation ConditionalAssignmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrameForSubclass:CGRectMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2.0, 4, 4)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *selectVariableLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 256, 28)];
        [selectVariableLabel setText:@"Filter Variable:"];
        [selectVariableLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [selectVariableLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:selectVariableLabel];
        selectVariable = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 32, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectVariable setTag:3401];
        [selectVariable analysisStyle];
        [self addSubview:selectVariable];
        
        UILabel *selectOperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 96, 256, 28)];
        [selectOperatorLabel setText:@"Operator:"];
        [selectOperatorLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectOperatorLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [selectOperatorLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:selectOperatorLabel];
        selectOperator = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 124, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectOperator setTag:3402];
        [selectOperator analysisStyle];
        [self addSubview:selectOperator];
        [selectOperator setIsEnabled:NO];
        
        UILabel *selectValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 188, 256, 28)];
        [selectValueLabel setText:@"Value:"];
        [selectValueLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [selectValueLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:selectValueLabel];
        selectValue = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 216, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectValue setTag:3403];
        [selectValue analysisStyle];
        typeTextValue = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(4, 216, 300, 40)];
        [typeTextValue setBorderStyle:UITextBorderStyleRoundedRect];
        [typeTextValue setDelegate:self];
        [typeTextValue setReturnKeyType:UIReturnKeyDone];
        [typeTextValue setTag:3404];
        typeNumberValue = [[NumberField alloc] initWithFrame:CGRectMake(4, 216, 300, 40)];
        [typeNumberValue setBorderStyle:UITextBorderStyleRoundedRect];
        [typeNumberValue setDelegate:self];
        [typeNumberValue setReturnKeyType:UIReturnKeyDone];
        [typeNumberValue setTag:3405];
        [self addSubview:typeTextValue];
        [typeTextValue setIsEnabled:NO];
        
        listOfValues = [[NSMutableArray alloc] init];
        [listOfValues addObject:@""];
        filterList = [[UITableView alloc] initWithFrame:CGRectMake(typeNumberValue.frame.origin.x, typeNumberValue.frame.origin.y + 2.0 * typeNumberValue.frame.size.height + 4.0, typeNumberValue.frame.size.width, 2.4 * typeNumberValue.frame.size.height)];
        [filterList setDelegate:self];
        [filterList setDataSource:self];
        [self addSubview:filterList];

        float side = 40;
        UIButton *hideSelfButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - side - 4, self.frame.size.height - side - 4, side, side)];
        [hideSelfButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [hideSelfButton.layer setCornerRadius:2];
        [hideSelfButton setTitle:@">>>" forState:UIControlStateNormal];
        [hideSelfButton setAccessibilityLabel:@"Save filters and return to analysis screen"];
        [hideSelfButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [hideSelfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [hideSelfButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [hideSelfButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideSelfButton];
        
        addFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(4, hideSelfButton.frame.origin.y, 2.5 * side, side)];
        [addFilterButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [addFilterButton.layer setCornerRadius:2];
        [addFilterButton setTitle:@"Add Filter" forState:UIControlStateNormal];
        [addFilterButton setAccessibilityLabel:@"Add, filter"];
        [addFilterButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [addFilterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addFilterButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [addFilterButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addFilterButton];
        [addFilterButton setEnabled:NO];
        [addFilterButton setAlpha:0.5];
        
        addWithAndButton = [[UIButton alloc] initWithFrame:addFilterButton.frame];
        [addWithAndButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [addWithAndButton.layer setCornerRadius:2];
        [addWithAndButton setTitle:@"Add With AND" forState:UIControlStateNormal];
        [addWithAndButton setAccessibilityLabel:@"Add, with, and"];
        [addWithAndButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [addWithAndButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addWithAndButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [addWithAndButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
        [addWithAndButton setEnabled:NO];
        [addWithAndButton setAlpha:0.5];

        addWithOrButton = [[UIButton alloc] initWithFrame:CGRectMake(4 + 2.5 * side + 2, hideSelfButton.frame.origin.y, 2.5 * side, side)];
        [addWithOrButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [addWithOrButton.layer setCornerRadius:2];
        [addWithOrButton setTitle:@"Add With OR" forState:UIControlStateNormal];
        [addWithOrButton setAccessibilityLabel:@"Add, with, or"];
        [addWithOrButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [addWithOrButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addWithOrButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [addWithOrButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
        [addWithOrButton setEnabled:NO];
        [addWithOrButton setAlpha:0.5];

        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:frame];
            [hideSelfButton setFrame:CGRectMake(self.frame.size.width - side - 4, self.frame.size.height - side - 4, side, side)];
            [addFilterButton setFrame:CGRectMake(4, hideSelfButton.frame.origin.y, 2.5 * side, side)];
            [addWithAndButton setFrame:addFilterButton.frame];
            [addWithOrButton setFrame:CGRectMake(4 + 2.5 * side + 2, hideSelfButton.frame.origin.y, 2.5 * side, side)];
        }completion:nil];
    }
    return self;
}

@end
