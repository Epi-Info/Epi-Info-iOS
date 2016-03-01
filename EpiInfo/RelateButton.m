//
//  RelateButton.m
//  EpiInfo
//
//  Created by John Copeland on 2/25/16.
//

#import "RelateButton.h"
#import "DataEntryViewController.h"
#import "EnterDataView.h"

@implementation RelateButton

- (void)setRelatedViewName:(NSString *)rvn
{
    relatedViewName = rvn;
}
- (NSString *)relatedViewName
{
    return relatedViewName;
}

- (void)setRootViewController:(UIViewController *)rvc
{
    rootViewController = rvc;
}
- (UIViewController *)rootViewController
{
    return rootViewController;
}

- (void)setParentEDV:(UIView *)medv
{
    parentEDV = medv;
}
- (UIView *)parentEDV
{
    return parentEDV;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setImage:[UIImage imageNamed:@"PlainPurpleButton.png"] forState:UIControlStateNormal];
    [self setClipsToBounds:YES];
    [self addTarget:self action:@selector(selfPressed:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [titleButton setTitle:title forState:state];
    [titleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [titleButton addTarget:self action:@selector(titleButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:titleButton];
}

- (void)titleButtonPressed:(UIButton *)sender
{
    [self setHighlighted:YES];
}

- (void)titleButtonReleased:(UIButton *)sender
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self setHighlighted:NO];
}

- (void)selfPressed:(UIButton *)sender
{
    NSLog(@"Load table %@", relatedViewName);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        NSString *path = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms/"] stringByAppendingString:relatedViewName] stringByAppendingString:@".xml"];
        NSURL *url = [NSURL fileURLWithPath:path];
        edv = [[EnterDataView alloc] initWithFrame:CGRectMake(0, 0, parentEDV.frame.size.width, parentEDV.frame.size.height) AndURL:url AndRootViewController:[(EnterDataView *)parentEDV rootViewController] AndNameOfTheForm:relatedViewName AndPageToDisplay:1];
        rootViewController = [(EnterDataView *)edv rootViewController];

        orangeBannerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentEDV.frame.size.width, 36)];
        [orangeBannerBackground setBackgroundColor:[UIColor colorWithRed:221/255.0 green:85/225.0 blue:12/225.0 alpha:1.0]];
        [parentEDV.superview addSubview:orangeBannerBackground];
        
        [parentEDV.superview addSubview:edv];
        [parentEDV.superview bringSubviewToFront:edv];
        
        orangeBanner = [[UIView alloc] initWithFrame:[orangeBannerBackground frame]];
        [orangeBanner setBackgroundColor:[UIColor colorWithRed:221/255.0 green:85/225.0 blue:12/225.0 alpha:0.95]];
        [parentEDV.superview addSubview:orangeBanner];
        [(EnterDataView *)edv setMyOrangeBanner:orangeBanner];
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, orangeBanner.frame.size.width - 120.0, 34)];
        [header setBackgroundColor:[UIColor clearColor]];
        [header setTextColor:[UIColor whiteColor]];
        [header setTextAlignment:NSTextAlignmentCenter];
        [orangeBanner addSubview:header];
        
        [(EnterDataView *)edv setPageBeingDisplayed:[NSNumber numberWithInt:1]];
        [header setText:[NSString stringWithFormat:@"%@, page %d of %lu", [(EnterDataView *)edv formName], [(EnterDataView *)edv pageBeingDisplayed].intValue, (unsigned long)[(EnterDataView *)edv pagesArray].count]];
        float fontSize = 32.0;
        while ([header.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]}].width > 180)
            fontSize -= 0.1;
        [header setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]];
        
        UIButton *xButton = [[UIButton alloc] initWithFrame:CGRectMake(parentEDV.superview.frame.size.width - 32.0, 2, 30, 30)];
        [xButton setBackgroundColor:[UIColor clearColor]];
        [xButton setImage:[UIImage imageNamed:@"StAndrewXButton.png"] forState:UIControlStateNormal];
        [xButton setTitle:@"Close the form" forState:UIControlStateNormal];
        [xButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [xButton setAlpha:0.5];
        [xButton.layer setMasksToBounds:YES];
        [xButton.layer setCornerRadius:8.0];
        //            [xButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
        //            [xButton.layer setBorderWidth:1.0];
        [xButton addTarget:self action:@selector(confirmDismissal) forControlEvents:UIControlEventTouchUpInside];
        [orangeBanner addSubview:xButton];
    }
}

- (void)confirmDismissal
{
    dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, -parentEDV.frame.size.height, parentEDV.frame.size.width, parentEDV.frame.size.height)];
    
    // Add the blurred image to an image view.
    BlurryView *dismissImageView = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, dismissView.frame.size.width, dismissView.frame.size.height)];
    [dismissImageView setBackgroundColor:[UIColor grayColor]];
    [dismissImageView setAlpha:0.8];
    [dismissView addSubview:dismissImageView];
    
    // The translucent white view on top of the blurred image.
    BlurryView *windowView = [[BlurryView alloc] initWithFrame:dismissImageView.frame];
    [windowView setBackgroundColor:[UIColor grayColor]];
    [windowView setAlpha:0.6];
    [dismissView addSubview:windowView];
    
    // The smaller and less-transparent white view for the message and buttons.
    //    UIView *messageView = [[UIView alloc] initWithFrame:dismissImageView.frame];
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
    [messageView setBackgroundColor:[UIColor whiteColor]];
    [messageView setAlpha:0.7];
    [messageView.layer setCornerRadius:8.0];
    [dismissView addSubview:messageView];
    
    //    UILabel *areYouSure = [[UILabel alloc] initWithFrame:dismissView.frame];
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 36)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setText:@"Dismiss Form?"];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
    [areYouSure setTextAlignment:NSTextAlignmentCenter];
    [messageView addSubview:areYouSure];
    
    //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *yesButton = [[UIButton alloc] initWithFrame:([(DataEntryViewController *)rootViewController openButton]).frame];
    [yesButton setImage:[UIImage imageNamed:@"YesButton.png"] forState:UIControlStateNormal];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [yesButton.layer setMasksToBounds:YES];
    [yesButton.layer setCornerRadius:4.0];
    [yesButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
    [dismissView addSubview:yesButton];
    
    //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(300 - yesButton.frame.size.width, yesButton.frame.origin.y, yesButton.frame.size.width, yesButton.frame.size.height)];
    [noButton setImage:[UIImage imageNamed:@"NoButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [noButton.layer setMasksToBounds:YES];
    [noButton.layer setCornerRadius:4.0];
    [noButton addTarget:self action:@selector(doNotDismiss) forControlEvents:UIControlEventTouchUpInside];
    [dismissView addSubview:noButton];
    
    [parentEDV.superview addSubview:dismissView];
    [parentEDV.superview bringSubviewToFront:dismissView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [dismissView setFrame:CGRectMake(0, 0, parentEDV.superview.frame.size.width, parentEDV.superview.frame.size.height)];
        //        [dismissImageView setFrame:CGRectMake(-20, -20, self.view.frame.size.width + 36, self.view.frame.size.height +36)];
        //        [windowView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //        [messageView setFrame:CGRectMake(10, 10, 300, openButton.frame.origin.y + openButton.frame.size.height)];
        //        [areYouSure setFrame:CGRectMake(10, 10, 280, 36)];
        //        [yesButton setFrame:openButton.frame];
        //        [noButton setFrame:CGRectMake(300 - openButton.frame.size.width, openButton.frame.origin.y, openButton.frame.size.width, openButton.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)dismissForm;
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [parentEDV.superview.layer setTransform:rotate];
    } completion:^(BOOL finished){
        for (UIView *v in [dismissView subviews])
        {
            if ([v isKindOfClass:[UIImageView class]])
                [(UIImageView *)v setImage:nil];
            [v removeFromSuperview];
        }
        [dismissView removeFromSuperview];
        dismissView = nil;
        if ([((EnterDataView *)edv).updateLocationThread isExecuting])
            [((EnterDataView *)edv).updateLocationThread cancel];
        [edv removeFromSuperview];
        edv = nil;
        [orangeBannerBackground removeFromSuperview];
        [orangeBanner removeFromSuperview];
        orangeBanner = nil;
        
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [parentEDV.superview.layer setTransform:rotate];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
            [parentEDV.superview.layer setTransform:rotate];
        } completion:^(BOOL finished){
        }];
    }];
}

- (void)doNotDismiss
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        //        [dismissView setFrame:CGRectMake(288, 2, 30, 30)];
        [dismissView setFrame:CGRectMake(0, -parentEDV.superview.frame.size.height, parentEDV.superview.frame.size.width, parentEDV.superview.frame.size.height)];
        //        for (UIView *v in [dismissView subviews])
        //            [v setFrame:CGRectMake(0, 0, 30, 30)];
    } completion:^(BOOL finished){
        [dismissView removeFromSuperview];
        dismissView = nil;
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
