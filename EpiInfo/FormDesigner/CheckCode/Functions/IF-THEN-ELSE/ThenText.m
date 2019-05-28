//
//  ThenText.m
//  EpiInfo
//
//  Created by John Copeland on 5/17/19.
//

#import "ThenText.h"

@implementation ThenText

- (id)initWithFrame:(CGRect)frame AndCallingButton:(nonnull UIButton *)cb
{
    self = [super initWithFrame:frame AndCallingButton:cb];
    if (self)
    {
        [titleLabel setText:@"THEN (when IF condition is true)"];
        
        UIButton *enableButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, 80, 40)];
        [enableButton setBackgroundColor:[UIColor whiteColor]];
        [enableButton setTitle:@"Enable" forState:UIControlStateNormal];
        [enableButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [enableButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [enableButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [enableButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [enableButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:enableButton];
        
        UIButton *disableButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 4, 80, 40)];
        [disableButton setBackgroundColor:[UIColor whiteColor]];
        [disableButton setTitle:@"Disable" forState:UIControlStateNormal];
        [disableButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [disableButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [disableButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [disableButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [disableButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:disableButton];
        
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(176, 4, 80, 40)];
        [clearButton setBackgroundColor:[UIColor whiteColor]];
        [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [clearButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [clearButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [clearButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [clearButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [clearButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:clearButton];
        
        UIButton *assignButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 50, 80, 40)];
        [assignButton setBackgroundColor:[UIColor whiteColor]];
        [assignButton setTitle:@"Assign" forState:UIControlStateNormal];
        [assignButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [assignButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [assignButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [assignButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [assignButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:assignButton];
        
        UIButton *equalsButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 50, 40, 40)];
        [equalsButton setBackgroundColor:[UIColor whiteColor]];
        [equalsButton setTitle:@"=" forState:UIControlStateNormal];
        [equalsButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [equalsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [equalsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [equalsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [equalsButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:equalsButton];
        
        UIButton *concatenateButton = [[UIButton alloc] initWithFrame:CGRectMake(136, 50, 40, 40)];
        [concatenateButton setBackgroundColor:[UIColor whiteColor]];
        [concatenateButton setTitle:@"&" forState:UIControlStateNormal];
        [concatenateButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [concatenateButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [concatenateButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [concatenateButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [concatenateButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:concatenateButton];
        
        UIButton *openParenButton = [[UIButton alloc] initWithFrame:CGRectMake(182, 50, 40, 40)];
        [openParenButton setBackgroundColor:[UIColor whiteColor]];
        [openParenButton setTitle:@"(" forState:UIControlStateNormal];
        [openParenButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [openParenButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [openParenButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [openParenButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [openParenButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:openParenButton];
        
        UIButton *commaButton = [[UIButton alloc] initWithFrame:CGRectMake(228, 50, 40, 40)];
        [commaButton setBackgroundColor:[UIColor whiteColor]];
        [commaButton setTitle:@"," forState:UIControlStateNormal];
        [commaButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [commaButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [commaButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [commaButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [commaButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:commaButton];
        
        UIButton *closeParenButton = [[UIButton alloc] initWithFrame:CGRectMake(274, 50, 40, 40)];
        [closeParenButton setBackgroundColor:[UIColor whiteColor]];
        [closeParenButton setTitle:@")" forState:UIControlStateNormal];
        [closeParenButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [closeParenButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [closeParenButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [closeParenButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [closeParenButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:closeParenButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
