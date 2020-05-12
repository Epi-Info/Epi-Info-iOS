//
//  FunctionsMenuBarButtonItem.m
//  EpiInfo
//
//  Created by John Copeland on 5/12/20.
//

#import "FunctionsMenuBarButtonItem.h"
#import "DataEntryViewController.h"

@implementation FunctionsMenuBarButtonItem
@synthesize arrayOfScannerButtons = _arrayOfScannerButtons;

- (void)setUIVC:(UIViewController *)devc
{
    uivc = devc;
}

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    self = [super initWithImage:image style:style target:target action:action];
    if (self)
    {
        scannersEnabled = NO;
    }
    return self;
}

- (void)selfPressed
{
    DataEntryViewController *devc = (DataEntryViewController *)uivc;
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(devc.navigationController.view.frame.size.width, 30, 140, 40)];
    [menuView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *onOffButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 8, menuView.frame.size.width - 4, menuView.frame.size.height - 16)];
    [onOffButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [onOffButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [onOffButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [onOffButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [onOffButton addTarget:self action:@selector(onOffButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [onOffButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    if (scannersEnabled)
    {
        [onOffButton setTitle:@"Disable Scanner" forState:UIControlStateNormal];
    }
    else
    {
        [onOffButton setTitle:@"Enable Scanner" forState:UIControlStateNormal];
    }
    [menuView addSubview:onOffButton];
    
    [devc.navigationController.view addSubview:menuView];

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [menuView setFrame:CGRectMake(devc.navigationController.view.frame.size.width - 140, 30, 140, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)onOffButtonPressed:(UIButton *)sender
{
    if (scannersEnabled)
    {
        scannersEnabled = NO;
        for (UIButton *b in self.arrayOfScannerButtons)
            [b setAlpha:0.0];
    }
    else
    {
        scannersEnabled = YES;
        for (UIButton *b in self.arrayOfScannerButtons)
            [b setAlpha:1.0];
    }
    
    UIView *menuView = [sender superview];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [menuView setFrame:CGRectMake([menuView superview].frame.size.width, 30, 140, 40)];
    } completion:^(BOOL finished){
        [sender removeFromSuperview];
        [menuView removeFromSuperview];
    }];
}
@end
