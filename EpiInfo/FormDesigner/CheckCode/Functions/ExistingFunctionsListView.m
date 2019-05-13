//
//  ExistingFunctionsListView.m
//  EpiInfo
//
//  Created by John Copeland on 5/9/19.
//

#import "ExistingFunctionsListView.h"
#import "AssigningFunction.h"
#import "EnableDisableClear.h"

@implementation ExistingFunctionsListView

- (id)initWithFrame:(CGRect)frame AndFunctionsArray:(nonnull NSMutableArray *)functionsArray AndSender:(nonnull UIButton *)sender
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        assigningFunction = [sender superview];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 32)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [titleLabel setText:@"Choose Function to Edit"];
        [self addSubview:titleLabel];
        
        UIScrollView *uisv = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                            titleLabel.frame.size.height,
                                                                            frame.size.width,
                                                                            frame.size.height - titleLabel.frame.size.height)];
        float y = 0.0;
        for (int i = 0; i < [functionsArray count]; i++)
        {
            UIButton *functionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 60)];
            [functionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [functionButton setBackgroundColor:[UIColor whiteColor]];
            [[functionButton titleLabel] setNumberOfLines:0];
            [[functionButton titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
            [functionButton setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 8)];
            [functionButton setTitle:[NSString stringWithFormat:@"%@", [functionsArray objectAtIndex:i]] forState:UIControlStateNormal];
            [functionButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [functionButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [functionButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [functionButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [functionButton addTarget:self action:@selector(closeSelf:) forControlEvents:UIControlEventTouchUpInside];
            [uisv addSubview:functionButton];
            y += 60.0;
        }
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 60)];
        [cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [cancelButton setBackgroundColor:[UIColor whiteColor]];
        [cancelButton setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 8)];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [cancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [cancelButton addTarget:self action:@selector(closeSelf:) forControlEvents:UIControlEventTouchUpInside];
        [uisv addSubview:cancelButton];
        y += 60.0;

        if (y > uisv.frame.size.height)
            [uisv setContentSize:CGSizeMake(uisv.frame.size.width, y)];
        [self addSubview:uisv];
    }
    return self;
}

- (void)closeSelf:(UIButton *)sender
{
    if (![[[sender titleLabel] text] isEqualToString:@"Cancel"])
    {
        if ([assigningFunction isKindOfClass:[AssigningFunction class]])
            [(AssigningFunction *)assigningFunction loadFunctionToEdit:[[sender titleLabel] text]];
        if ([assigningFunction isKindOfClass:[EnableDisableClear class]])
            [(EnableDisableClear *)assigningFunction loadFunctionToEdit:[[sender titleLabel] text]];
    }
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
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
