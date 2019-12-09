//
//  VariablesInGroupSelector.m
//  EpiInfo
//
//  Created by John Copeland on 12/6/19.
//

#import "VariablesInGroupSelector.h"
#import "FormDesigner.h"

@implementation VariablesInGroupSelector
{
    FormDesigner *fd;
}

- (void)setFD:(UIView *)mfd
{
    fd = (FormDesigner *)mfd;
}

- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov AndTextFieldToUpdate:(UITextField *)tftu
{
    self = [super initWithFrame:frame AndListOfValues:lov AndTextFieldToUpdate:tftu];
    if (self)
        [self setFrame:frame];
    [self.tv setAllowsMultipleSelection:YES];
    return self;
}

- (void)valueButtonPressed:(id)sender
{
    [super valueButtonPressed:sender];
    float tvX = self.tv.frame.origin.x;
    float tvY = self.tv.frame.origin.y;
    float tvWidth = self.tv.frame.size.width;
    UIButton *closeTVButton = [[UIButton alloc] initWithFrame:CGRectMake(tvX, tvY - 32.0, tvWidth, 32.0)];
    [closeTVButton setBackgroundColor:[UIColor whiteColor]];
    [closeTVButton setTitle:@"\tClose" forState:UIControlStateNormal];
    [closeTVButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [closeTVButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [closeTVButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [closeTVButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shield addSubview:closeTVButton];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)closeButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.tv setFrame:CGRectMake(topX, topY, self.valueButton.frame.size.width, 0)];
    } completion:^(BOOL finished){
        [self.tv setFrame:CGRectMake(self.valueButton.frame.origin.x, self.valueButton.frame.origin.y, self.valueButton.frame.size.width, 0)];
        [self.valueButton addSubview:self.tv];
        
        [shield removeFromSuperview];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.valueButton);
    }];
    [fd fieldResignedFirstResponder:self];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [valueButtonView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.valueButton setFrame:CGRectMake(8, 8, valueButtonView.frame.size.width - 16, 48)];
    [self.tv setFrame:CGRectMake(self.tv.frame.origin.x, self.tv.frame.origin.y, self.valueButton.frame.size.width, self.tv.frame.size.height)];
    for (UIView *v in [self.valueButton subviews])
    {
        if ([v isKindOfClass:[DownTriangle class]])
        {
            [v setFrame:CGRectMake(self.valueButton.frame.size.width - 1.0 - v.frame.size.width, v.frame.origin.y, v.frame.size.width, v.frame.size.height)];
            break;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
