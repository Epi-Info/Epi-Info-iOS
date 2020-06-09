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

- (void)setConnectedToBox:(BOOL)ctb
{
    connectedToBox = ctb;
}
- (BOOL)connectedToBox
{
    return connectedToBox;
}

- (void)setNotwo:(BOOL)no2
{
    notwo = no2;
}
- (BOOL)notwo
{
    return notwo;
}

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
        connectedToBox = NO;
        notwo = NO;
    }
    return self;
}

- (void)selfPressed
{
    DataEntryViewController *devc = (DataEntryViewController *)uivc;
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(devc.navigationController.view.frame.size.width, 30, 140, 40)];
    [menuView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *onOffButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 8, menuView.frame.size.width - 4, 40 - 16)];
    [onOffButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [onOffButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [onOffButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [onOffButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [onOffButton addTarget:self action:@selector(onOffButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [onOffButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    if (scannersEnabled)
    {
        [onOffButton setTitle:@"Hide Scanners" forState:UIControlStateNormal];
    }
    else
    {
        [onOffButton setTitle:@"Show Scanners" forState:UIControlStateNormal];
    }
    [menuView addSubview:onOffButton];
    
    float numberofbuttons = 1.0;
    
    if (connectedToBox)
    {
        float ypos = 40.0 * numberofbuttons;
        numberofbuttons += 1.0;
        [menuView setFrame:CGRectMake(menuView.frame.origin.x, menuView.frame.origin.y, menuView.frame.size.width, 40.0 * numberofbuttons)];
        UIButton *noValueButton = [[UIButton alloc] initWithFrame:CGRectMake(4, ypos + 8, onOffButton.frame.size.width, onOffButton.frame.size.height)];
        [noValueButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [noValueButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [noValueButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [noValueButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [noValueButton addTarget:self action:@selector(noValueButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [noValueButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        if (notwo)
        {
            [noValueButton setTitle:@"Box: No=0" forState:UIControlStateNormal];
            [noValueButton setAccessibilityLabel:@"Code No, as zero, on Box cloud"];
        }
        else
        {
            [noValueButton setTitle:@"Box: No=2" forState:UIControlStateNormal];
            [noValueButton setAccessibilityLabel:@"Code No, as two, on Box cloud"];
        }
        [menuView addSubview:noValueButton];
    }
    
    [menuView setFrame:CGRectMake(menuView.frame.origin.x, menuView.frame.origin.y, menuView.frame.size.width, 40.0 * numberofbuttons + 40.0)];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 40.0 * numberofbuttons + 8, onOffButton.frame.size.width, onOffButton.frame.size.height)];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [cancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [cancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [menuView addSubview:cancelButton];
    
//    [menuView setBackgroundColor:[UIColor orangeColor]];

    [devc.navigationController.view addSubview:menuView];

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [menuView setFrame:CGRectMake(devc.navigationController.view.frame.size.width - 140, 30, 140, menuView.frame.size.height)];
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
        [menuView setFrame:CGRectMake([menuView superview].frame.size.width, 30, 140, menuView.frame.size.height)];
    } completion:^(BOOL finished){
        [sender removeFromSuperview];
        [menuView removeFromSuperview];
    }];
}

- (void)noValueButtonPressed:(UIButton *)sender
{
    if (notwo)
        notwo = NO;
    else
        notwo = YES;
    
    UIView *menuView = [sender superview];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [menuView setFrame:CGRectMake([menuView superview].frame.size.width, 30, 140, menuView.frame.size.height)];
    } completion:^(BOOL finished){
        [sender removeFromSuperview];
        [menuView removeFromSuperview];
    }];
}

- (void)cancelButtonPressed:(UIButton *)sender
{
    UIView *menuView = [sender superview];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [menuView setFrame:CGRectMake([menuView superview].frame.size.width, 30, 140, menuView.frame.size.height)];
    } completion:^(BOOL finished){
        [sender removeFromSuperview];
        [menuView removeFromSuperview];
    }];
}
@end
