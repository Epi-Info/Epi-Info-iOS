//
//  AnalysisFilterView.m
//  EpiInfo
//
//  Created by John Copeland on 8/8/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "AnalysisFilterView.h"
#import "AnalysisViewController.h"

@implementation AnalysisFilterView
{
    AnalysisViewController *avc;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.size.width, frame.origin.y, frame.size.width, frame.size.height)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //Add blueView and whiteView to create thin blue border line
        //Add all other views to whiteView
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
        [blueView setBackgroundColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0]];
        [blueView.layer setCornerRadius:10.0];
        [self addSubview:blueView];
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, blueView.frame.size.width - 4, blueView.frame.size.height - 4)];
        [whiteView setBackgroundColor:[UIColor whiteColor]];
        [whiteView.layer setCornerRadius:8];
        [blueView addSubview:whiteView];
        
        float side = 40;
        UIButton *hideSelfButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.frame.size.width - side - 4, whiteView.frame.size.height - side - 4, side, side)];
        [hideSelfButton setBackgroundColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0]];
        [hideSelfButton.layer setCornerRadius:10];
        [hideSelfButton setTitle:@">>>" forState:UIControlStateNormal];
        [hideSelfButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [hideSelfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [hideSelfButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [hideSelfButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:hideSelfButton];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:frame];
        }completion:nil];
    }
    return self;
}

- (id)initWithViewController:(UIViewController *)vc
{
    self = [self initWithFrame:CGRectMake(0, 50, vc.view.frame.size.width, vc.view.frame.size.height - 50)];
    avc = (AnalysisViewController *)vc;
    return self;
}

- (void)hideSelf
{
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [self setFrame:CGRectMake(self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    }completion:^(BOOL finished){[self removeSelfFromSuperview];}];
}

- (BOOL)removeSelfFromSuperview
{
    [self removeFromSuperview];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
