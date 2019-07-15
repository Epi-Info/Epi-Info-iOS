//
//  ConditionText.m
//  EpiInfo
//
//  Created by John Copeland on 5/17/19.
//

#import "ConditionText.h"

@implementation ConditionText

- (id)initWithFrame:(CGRect)frame AndCallingButton:(nonnull UIButton *)cb
{
    self = [super initWithFrame:frame AndCallingButton:cb];
    if (self)
    {
        [titleLabel setText:@"IF Condition"];
        
        UIButton *equalsButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
        [equalsButton setBackgroundColor:[UIColor whiteColor]];
        [equalsButton setTitle:@"=" forState:UIControlStateNormal];
        [equalsButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [equalsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [equalsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [equalsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [equalsButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:equalsButton];
        
        UIButton *lessThanButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 4, 40, 40)];
        [lessThanButton setBackgroundColor:[UIColor whiteColor]];
        [lessThanButton setTitle:@"<" forState:UIControlStateNormal];
        [lessThanButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [lessThanButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [lessThanButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [lessThanButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [lessThanButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:lessThanButton];
        
        UIButton *greaterThanButton = [[UIButton alloc] initWithFrame:CGRectMake(96, 4, 40, 40)];
        [greaterThanButton setBackgroundColor:[UIColor whiteColor]];
        [greaterThanButton setTitle:@">" forState:UIControlStateNormal];
        [greaterThanButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [greaterThanButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [greaterThanButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [greaterThanButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [greaterThanButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:greaterThanButton];
        
        UIButton *missingButton = [[UIButton alloc] initWithFrame:CGRectMake(142, 4, 80, 40)];
        [missingButton setBackgroundColor:[UIColor whiteColor]];
        [missingButton setTitle:@"Missing" forState:UIControlStateNormal];
        [missingButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [missingButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [missingButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [missingButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [missingButton addTarget:self action:@selector(operatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [operatorView addSubview:missingButton];
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