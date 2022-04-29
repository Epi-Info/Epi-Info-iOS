//
//  RelateButton.m
//  EpiInfo
//
//  Created by John Copeland on 2/25/16.
//

#import "RelateButton.h"
#import "DataEntryViewController.h"
#import "EnterDataView.h"
#import "ConverterMethods.h"
#import "ChildFormFieldAssignments.h"
#include <sys/sysctl.h>

@implementation RelateButton

- (void)setRelatedViewName:(NSString *)rvn
{
    relatedViewName = rvn;
}
- (NSString *)relatedViewName
{
    return relatedViewName;
}

- (void)setRelateButtonName:(NSString *)rbn
{
    relateButtonName = rbn;
}
- (NSString *)relateButtonName
{
    return relateButtonName;
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
//    [self setImage:[UIImage imageNamed:@"PlainPurpleButton.png"] forState:UIControlStateNormal];
    [self setClipsToBounds:YES];
    [self addTarget:self action:@selector(selfPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(selfTouchedDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(selfDraggedOutside:) forControlEvents:UIControlEventTouchDragOutside];
    [self setBackgroundColor:[UIColor colorWithRed:230/255.0 green:231/255.0 blue:232/255.0 alpha:1.0]];
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextMoveToPoint(ctx, 3.0, 3.0);
    CGContextAddLineToPoint(ctx, self.frame.size.width - 3.0, 3.0);
    CGContextAddLineToPoint(ctx, self.frame.size.width - 3.0, self.frame.size.height - 3.0);
    CGContextAddLineToPoint(ctx, 3.0  , self.frame.size.height - 3.0);
    CGContextClosePath(ctx);
    CGContextSetRGBStrokeColor(ctx, 189/255.0, 190/255.0, 192/255.0, 1);
    CGContextStrokePath(ctx);
    touchBorderImageView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
    
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self setAccessibilityLabel:title];
    [self setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:state];
    [self setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
//    if (highlighted)
//        [self setBackgroundColor:[UIColor colorWithRed:209/255.0 green:211/255.0 blue:212/255.0 alpha:1.0]];
//    else
//        [self setBackgroundColor:[UIColor colorWithRed:230/255.0 green:231/255.0 blue:232/255.0 alpha:1.0]];
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

- (void)selfTouchedDown:(UIButton *)sender
{
    [self addSubview:touchBorderImageView];
}
- (void)selfDraggedOutside:(UIButton *)sender
{
    [touchBorderImageView removeFromSuperview];
}

- (void)selfPressed:(UIButton *)sender
{
//    NSLog(@"Load table %@", relatedViewName);
    [touchBorderImageView removeFromSuperview];
    if (!relatedViewName)
        return;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        NSString *path = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms/"] stringByAppendingString:relatedViewName] stringByAppendingString:@".xml"];
        NSString *_path = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms/_"] stringByAppendingString:relatedViewName] stringByAppendingString:@".xml"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path] && ![[NSFileManager defaultManager] fileExistsAtPath:_path])
        {
            return;
        }
        
        NSURL *url = [NSURL fileURLWithPath:_path];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_path])
            url = [NSURL fileURLWithPath:path];
        edv = [[EnterDataView alloc] initWithFrame:CGRectMake(0, parentEDV.frame.size.height, parentEDV.frame.size.width, parentEDV.frame.size.height) AndURL:url AndRootViewController:[(EnterDataView *)parentEDV rootViewController] AndNameOfTheForm:relatedViewName AndPageToDisplay:1 AndParentForm:(EnterDataView *)parentEDV];
        rootViewController = [(EnterDataView *)edv rootViewController];
        [[(DataEntryViewController *)rootViewController edv] setChildEnterDataView:(EnterDataView *)edv];
        
        [(DataEntryViewController *)rootViewController addNewSetOfPageDots:(EnterDataView *)edv];
        
        [(EnterDataView *)edv setParentRecordGUID:[(EnterDataView *)parentEDV guidToSendToChild]];
        [(EnterDataView *)edv setParentEnterDataView:(EnterDataView *)parentEDV];
        [(EnterDataView *)edv setRelateButtonName:relateButtonName];
        
//        NSLog(@"Child form Check Code: %@", [(EnterDataView *)edv formCheckCodeString]);
        [ChildFormFieldAssignments parseForAssignStatements:[(EnterDataView *)edv formCheckCodeString] parentForm:(EnterDataView *)parentEDV childForm:(EnterDataView *)edv relateButtonName:relateButtonName];

        orangeBannerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, parentEDV.frame.size.height, parentEDV.frame.size.width, 36)];
        [orangeBannerBackground setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [parentEDV.superview addSubview:orangeBannerBackground];
        
        [parentEDV.superview addSubview:edv];
        [parentEDV.superview bringSubviewToFront:edv];
        
        orangeBanner = [[UIView alloc] initWithFrame:[orangeBannerBackground frame]];
        [orangeBanner setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:0.95]];
        [parentEDV.superview addSubview:orangeBanner];
        [(EnterDataView *)edv setMyOrangeBanner:orangeBanner];
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, orangeBanner.frame.size.width - 120.0, 34)];
        [header setBackgroundColor:[UIColor clearColor]];
        [header setTextColor:[UIColor whiteColor]];
        [header setTextAlignment:NSTextAlignmentCenter];
        [orangeBanner addSubview:header];
        
        [(EnterDataView *)edv setPageBeingDisplayed:[NSNumber numberWithInt:1]];
        [header setText:[NSString stringWithFormat:@"%@", [(EnterDataView *)edv formName]]];
//        [header setText:[NSString stringWithFormat:@"%@, page %d of %lu", [(EnterDataView *)edv formName], [(EnterDataView *)edv pageBeingDisplayed].intValue, (unsigned long)[(EnterDataView *)edv pagesArray].count]];
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
        [xButton addTarget:self action:@selector(confirmDismissal) forControlEvents:UIControlEventTouchUpInside];
//        [orangeBanner addSubview:xButton];
        
        float formNavigationBarY = 0.0;
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = [NSString stringWithUTF8String:machine];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] || [platform isEqualToString:@"iPad2,7"]))
            formNavigationBarY = 8.0;
        UINavigationBar *formNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, formNavigationBarY, orangeBanner.frame.size.width, orangeBanner.frame.size.height - 4)];
        [formNavigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [formNavigationBar setShadowImage:[UIImage new]];
        [formNavigationBar setTranslucent:YES];
        formNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        closeFormBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(confirmDismissal)];
        [closeFormBarButtonItem setAccessibilityLabel:@"Close Child Form"];
        [closeFormBarButtonItem setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [formNavigationItem setRightBarButtonItem:closeFormBarButtonItem];
        deleteRecordBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(footerBarDelete)];
        [deleteRecordBarButtonItem setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [deleteRecordBarButtonItem setImageInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
        UIBarButtonItem *packageDataBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(confirmUploadAllRecords)];
        [packageDataBarButtonItem setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [packageDataBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        UIBarButtonItem *recordLookupBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(lineListButtonPressed)];
        [recordLookupBarButtonItem setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [recordLookupBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
        [formNavigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:packageDataBarButtonItem, recordLookupBarButtonItem, nil]];
        [formNavigationBar setItems:[NSArray arrayWithObject:formNavigationItem]];
        [orangeBanner addSubview:formNavigationBar];
        [[(DataEntryViewController *)self.rootViewController formNavigationItems] addObject:formNavigationItem];
        [[(DataEntryViewController *)self.rootViewController closeFormBarButtonItems] addObject:closeFormBarButtonItem];
        [[(DataEntryViewController *)self.rootViewController deleteRecordBarButtonItems] addObject:deleteRecordBarButtonItem];
        
        UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 30, 30)];
        [uploadButton setBackgroundColor:[UIColor clearColor]];
        [uploadButton setImage:[UIImage imageNamed:@"UploadButton.png"] forState:UIControlStateNormal];
        [uploadButton setTitle:@"Upload data" forState:UIControlStateNormal];
        [uploadButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [uploadButton setAlpha:0.5];
        [uploadButton.layer setMasksToBounds:YES];
        [uploadButton.layer setCornerRadius:8.0];
        [uploadButton addTarget:self action:@selector(confirmUploadAllRecords) forControlEvents:UIControlEventTouchUpInside];
//        [orangeBanner addSubview:uploadButton];
        
        UIButton *lineListButton = [[UIButton alloc] initWithFrame:CGRectMake(34, 2, 30, 30)];
        [lineListButton setBackgroundColor:[UIColor clearColor]];
        [lineListButton setImage:[UIImage imageNamed:@"LineList6060.png"] forState:UIControlStateNormal];
        [lineListButton setTitle:@"Show line listing" forState:UIControlStateNormal];
        [lineListButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [lineListButton setAlpha:0.5];
        [lineListButton.layer setMasksToBounds:YES];
        [lineListButton.layer setCornerRadius:8.0];
        [lineListButton addTarget:self action:@selector(lineListButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//        [orangeBanner addSubview:lineListButton];
        
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [orangeBannerBackground setFrame:CGRectMake(0, 0, parentEDV.frame.size.width, 36)];
            [edv setFrame:CGRectMake(0, 0, parentEDV.frame.size.width, parentEDV.frame.size.height)];
            [orangeBanner setFrame:[orangeBannerBackground frame]];
        } completion:^(BOOL finished){
//            [parentEDV.superview addSubview:edv];
//            [parentEDV.superview bringSubviewToFront:edv];
            NSLog(@"%@", [edv superview]);
            for (id v in [rootViewController.view subviews])
            {
                if ([v isKindOfClass:[UINavigationBar class]])
                {
                    [self.rootViewController.view bringSubviewToFront:v];
                    [(DataEntryViewController *)rootViewController resetHeaderAndFooterBars];
                    break;
                }
            }
        }];
    }
}

- (void)confirmDismissal
{
    // Replace deprecated UIAlertViews
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dismiss Child Form" message:@"Dismiss this form?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//    [alert show];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Dismiss Child Form" message:@"Dismiss this form?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self dismissForm];
    }];
    [alertC addAction:noAction];
    [alertC addAction:yesAction];
    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
//    dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, -parentEDV.frame.size.height, parentEDV.frame.size.width, parentEDV.frame.size.height)];
//    
//    // Add the blurred image to an image view.
//    BlurryView *dismissImageView = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, dismissView.frame.size.width, dismissView.frame.size.height)];
//    [dismissImageView setBackgroundColor:[UIColor grayColor]];
//    [dismissImageView setAlpha:0.8];
//    [dismissView addSubview:dismissImageView];
//    
//    // The translucent white view on top of the blurred image.
//    BlurryView *windowView = [[BlurryView alloc] initWithFrame:dismissImageView.frame];
//    [windowView setBackgroundColor:[UIColor grayColor]];
//    [windowView setAlpha:0.6];
//    [dismissView addSubview:windowView];
//    
//    // The smaller and less-transparent white view for the message and buttons.
//    //    UIView *messageView = [[UIView alloc] initWithFrame:dismissImageView.frame];
//    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
//    [messageView setBackgroundColor:[UIColor whiteColor]];
//    [messageView setAlpha:0.7];
//    [messageView.layer setCornerRadius:8.0];
//    [dismissView addSubview:messageView];
//    
//    //    UILabel *areYouSure = [[UILabel alloc] initWithFrame:dismissView.frame];
//    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 36)];
//    [areYouSure setBackgroundColor:[UIColor clearColor]];
//    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
//    [areYouSure setText:@"Dismiss Form?"];
//    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
//    [areYouSure setTextAlignment:NSTextAlignmentCenter];
//    [messageView addSubview:areYouSure];
//    
//    //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
//    UIButton *yesButton = [[UIButton alloc] initWithFrame:([(DataEntryViewController *)rootViewController openButton]).frame];
//    [yesButton setImage:[UIImage imageNamed:@"YesButton.png"] forState:UIControlStateNormal];
//    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
//    [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    [yesButton.layer setMasksToBounds:YES];
//    [yesButton.layer setCornerRadius:4.0];
//    [yesButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
//    [dismissView addSubview:yesButton];
//    
//    //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
//    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(300 - yesButton.frame.size.width, yesButton.frame.origin.y, yesButton.frame.size.width, yesButton.frame.size.height)];
//    [noButton setImage:[UIImage imageNamed:@"NoButton.png"] forState:UIControlStateNormal];
//    [noButton setTitle:@"No" forState:UIControlStateNormal];
//    [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    [noButton.layer setMasksToBounds:YES];
//    [noButton.layer setCornerRadius:4.0];
//    [noButton addTarget:self action:@selector(doNotDismiss) forControlEvents:UIControlEventTouchUpInside];
//    [dismissView addSubview:noButton];
//    
//    [parentEDV.superview addSubview:dismissView];
//    [parentEDV.superview bringSubviewToFront:dismissView];
//    
//    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        [dismissView setFrame:CGRectMake(0, 0, parentEDV.superview.frame.size.width, parentEDV.superview.frame.size.height)];
//    } completion:^(BOOL finished){
//    }];
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
        for (id key in [(EnterDataView *)edv dictionaryOfPages])
        {
            [(EnterDataView *)[(NSDictionary *)[(EnterDataView *)edv dictionaryOfPages] objectForKey:key] removeFromSuperview];
        }
        
        // Fix for EM-624: child form values being preserved after child form dismissed
        for (id key in [(EnterDataView *)edv dictionaryOfFields])
        {
            [[(FieldsAndStringValues *)[(DataEntryViewController *)rootViewController fieldsAndStringValues] nsmd] removeObjectForKey:key];
        }
        //
        
        [edv removeFromSuperview];
        edv = nil;
        [orangeBannerBackground removeFromSuperview];
        [orangeBanner removeFromSuperview];
        orangeBanner = nil;
        
        [(EnterDataView *)[(DataEntryViewController *)rootViewController edv] setChildEnterDataView:nil];
        [(DataEntryViewController *)rootViewController childFormDismissed];
        [[(DataEntryViewController *)rootViewController formNavigationItems] removeLastObject];
        [[(DataEntryViewController *)rootViewController closeFormBarButtonItems] removeLastObject];
        [[(DataEntryViewController *)rootViewController deleteRecordBarButtonItems] removeLastObject];
        [(DataEntryViewController *)rootViewController popPageDots];

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

- (void)lineListButtonPressed
{
    // Initialize a Line List View and move it into place
    EpiInfoLineListView *eillv = [[EpiInfoLineListView alloc] initWithFrame:CGRectMake(0, -parentEDV.superview.frame.size.height, parentEDV.superview.frame.size.width, parentEDV.superview.frame.size.height - orangeBanner.frame.origin.y) andFormName:[(EnterDataView *)edv formName] forChildForm:(EnterDataView *)edv];
    [parentEDV.superview addSubview:eillv];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [eillv setFrame:CGRectMake(0, orangeBanner.frame.origin.y, eillv.frame.size.width, eillv.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)confirmUploadAllRecords
{
    dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, -parentEDV.frame.size.height, parentEDV.frame.size.width, parentEDV.frame.size.height)];
    
    BlurryView *dismissImageView = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, dismissView.frame.size.width, dismissView.frame.size.height)];
    [dismissImageView setBackgroundColor:[UIColor grayColor]];
    [dismissImageView setAlpha:0.8];
    [dismissView addSubview:dismissImageView];
    
    // The translucent white view on top of the blurred image.
    BlurryView *windowView = [[BlurryView alloc] initWithFrame:dismissImageView.frame];
    [windowView setBackgroundColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:0.6]];
    [dismissView addSubview:windowView];
    
    // The smaller and less-transparent white view for the message and buttons.
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y + ([(DataEntryViewController *)rootViewController openButton]).frame.size.height + 90.0)];
    [messageView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7]];
    [messageView.layer setCornerRadius:8.0];
    [dismissView addSubview:messageView];
    
    //    UILabel *areYouSure = [[UILabel alloc] initWithFrame:dismissView.frame];
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 96)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setNumberOfLines:0];
    [messageView addSubview:areYouSure];
    
    UILabel *decimalSeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 104, 142, 40)];
    [decimalSeparatorLabel setBackgroundColor:[UIColor clearColor]];
    [decimalSeparatorLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [decimalSeparatorLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [decimalSeparatorLabel setTextAlignment:NSTextAlignmentLeft];
    [decimalSeparatorLabel setText:@"Decimal separator:"];
    [messageView addSubview:decimalSeparatorLabel];
    
    useDotForDecimal = YES;
    
    dotDecimalSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(150, 106, 34, 34)];
    [dotDecimalSeparatorView setBackgroundColor:[UIColor redColor]];
    [dotDecimalSeparatorView.layer setCornerRadius:10.0];
    [messageView addSubview:dotDecimalSeparatorView];
    
    UIButton *dotDecimalSeparatorButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, 26, 26)];
    [dotDecimalSeparatorButton setBackgroundColor:[UIColor whiteColor]];
    [dotDecimalSeparatorButton.layer setMasksToBounds:YES];
    [dotDecimalSeparatorButton setTitle:@"Use dot for decimal separator" forState:UIControlStateNormal];
    [dotDecimalSeparatorButton setImage:[UIImage imageNamed:@"Dot.png"] forState:UIControlStateNormal];
    [dotDecimalSeparatorButton.layer setCornerRadius:8.0];
    [dotDecimalSeparatorButton addTarget:self action:@selector(chooseDecimalSeparator:) forControlEvents:UIControlEventTouchUpInside];
    [dotDecimalSeparatorView addSubview:dotDecimalSeparatorButton];
    
    commaDecimalSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(186, 106, 34, 34)];
    [commaDecimalSeparatorView setBackgroundColor:[UIColor clearColor]];
    [commaDecimalSeparatorView.layer setCornerRadius:10.0];
    [messageView addSubview:commaDecimalSeparatorView];
    
    UIButton *commaDecimalSeparatorButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, 26, 26)];
    [commaDecimalSeparatorButton setBackgroundColor:[UIColor whiteColor]];
    [commaDecimalSeparatorButton.layer setMasksToBounds:YES];
    [commaDecimalSeparatorButton setTitle:@"Use comma for decimal separator" forState:UIControlStateNormal];
    [commaDecimalSeparatorButton setImage:[UIImage imageNamed:@"Comma.png"] forState:UIControlStateNormal];
    [commaDecimalSeparatorButton.layer setCornerRadius:8.0];
    [commaDecimalSeparatorButton addTarget:self action:@selector(chooseDecimalSeparator:) forControlEvents:UIControlEventTouchUpInside];
    [commaDecimalSeparatorView addSubview:commaDecimalSeparatorButton];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 80, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [messageView addSubview:uiaiv];
    
    UIButton *iTunesButton = [[UIButton alloc] initWithFrame:CGRectMake(1, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y - ([(DataEntryViewController *)rootViewController openButton]).frame.size.height, 298, 40)];
//    [iTunesButton setImage:[UIImage imageNamed:@"PackageForiTunesButton.png"] forState:UIControlStateNormal];
    //    [iTunesButton setImage:[UIImage imageNamed:@"PackageForiTunesButton.png"] forState:UIControlStateNormal];
    [iTunesButton setTitle:@"Package Data for Upload to iTunes" forState:UIControlStateNormal];
    [iTunesButton setAccessibilityLabel:@"Package for I tunes upload."];
    [iTunesButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [iTunesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [iTunesButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [iTunesButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [iTunesButton.layer setMasksToBounds:YES];
    [iTunesButton.layer setCornerRadius:4.0];
    //    [iTunesButton addTarget:self action:@selector(packageDataForiTunes:) forControlEvents:UIControlEventTouchUpInside];
    [iTunesButton addTarget:self action:@selector(prePackageData:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:iTunesButton];
    [iTunesButton setEnabled:NO];
    [iTunesButton setAlpha:0.0];
    
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(1, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y - ([(DataEntryViewController *)rootViewController openButton]).frame.size.height + 42.0, 298, 40)];
//    [emailButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
    //    [emailButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
    [emailButton setTitle:@"Package and Email Data" forState:UIControlStateNormal];
    [emailButton setAccessibilityLabel:@"Package and email data"];
    [emailButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [emailButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [emailButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [emailButton.layer setMasksToBounds:YES];
    [emailButton.layer setCornerRadius:4.0];
    [emailButton addTarget:self action:@selector(prePackageData:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:emailButton];
    
    UIButton *csvButton = [[UIButton alloc] initWithFrame:CGRectMake(1, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y - ([(DataEntryViewController *)rootViewController openButton]).frame.size.height + 42.0 + 42.0, 298, 40)];
    //    [emailButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
    //    [emailButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
    [csvButton setTitle:@"Email CSV File (Not Encrypted)" forState:UIControlStateNormal];
    [csvButton setAccessibilityLabel:@"Email CSV File (Not Encrypted)"];
    [csvButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [csvButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [csvButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [csvButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [csvButton.layer setMasksToBounds:YES];
    [csvButton.layer setCornerRadius:4.0];
    [csvButton addTarget:self action:@selector(emailDataAsCSV:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:csvButton];

    //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(1, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y - ([(DataEntryViewController *)rootViewController openButton]).frame.size.height + 84.0, 298, 40)];
//    [yesButton setImage:[UIImage imageNamed:@"UploadDataToCloudButton.png"] forState:UIControlStateNormal];
    [yesButton setTitle:@"Upload Data to Cloud" forState:UIControlStateNormal];
    [yesButton setAccessibilityLabel:@"Upload to cloud"];
    [yesButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [yesButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [yesButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [yesButton.layer setMasksToBounds:YES];
    [yesButton.layer setCornerRadius:4.0];
    [yesButton addTarget:self action:@selector(uploadAllRecords:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:yesButton];
    [yesButton setAlpha:0.0];
    
    //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(messageView.frame.size.width / 2.0 -  ([(DataEntryViewController *)rootViewController openButton]).frame.size.width / 2.0, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y + 88.0, ([(DataEntryViewController *)rootViewController openButton]).frame.size.width, ([(DataEntryViewController *)rootViewController openButton]).frame.size.height)];
//    [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [noButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [noButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [noButton.layer setMasksToBounds:YES];
    [noButton.layer setCornerRadius:4.0];
    [noButton addTarget:self action:@selector(doNotDismiss) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:noButton];
    
    [parentEDV.superview addSubview:dismissView];
    [parentEDV.superview bringSubviewToFront:dismissView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        int numberOfRecordsToUpload = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(*) as n from %@", ((EnterDataView *)edv).formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    numberOfRecordsToUpload = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        recordsToBeWrittenToPackageFile = numberOfRecordsToUpload;
        if (numberOfRecordsToUpload > 0)
        {
            [areYouSure setText:[NSString stringWithFormat:@"Local table contains %d records.", numberOfRecordsToUpload]];
            [emailButton setEnabled:YES];
            [yesButton setEnabled:YES];
//            [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
        }
        else
        {
            [areYouSure setText:[NSString stringWithFormat:@"Local table contains no rows."]];
            [emailButton setEnabled:NO];
            [yesButton setEnabled:NO];
            [noButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
            return;
        }
    }
    else
    {
        [areYouSure setText:[NSString stringWithFormat:@"Local table does not yet exist for this form."]];
        [emailButton setEnabled:NO];
        [yesButton setEnabled:NO];
        [noButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
        return;
    }
    
    // Check whether credentials exist for this form
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase/Clouds.db"];
        int credentialsExistForThisForm = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(*) as n from Clouds where FormName = '%@'", ((EnterDataView *)edv).formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    credentialsExistForThisForm = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (credentialsExistForThisForm > 0)
        {
            // Create the todoService - this creates the Mobile Service client inside the wrapped service
            //            [self setEpiinfoService:[QSEpiInfoService defaultService]];
            
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = [NSString stringWithFormat:@"select * from Clouds where FormName = '%@'", ((EnterDataView *)edv).formName];
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)] isEqualToString:@"MSAzure"])
                        {
                        }
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
        }
        else
        {
            [areYouSure setText:[areYouSure.text stringByAppendingString:@"\nNo cloud connection credentials found for this table."]];
            [yesButton setEnabled:NO];
//            [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [areYouSure setText:[areYouSure.text stringByAppendingString:@"\nNo cloud connection credentials found for this table."]];
        [yesButton setEnabled:NO];
//        [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
    }
    
    // Check for internet connectivity
    Reachability *reachability;
    @try {
        //        reachability = [Reachability reachabilityWithHostName:[NSString stringWithFormat:@"%@", [[self.epiinfoService.applicationURL substringToIndex:self.epiinfoService.applicationURL.length - 1] substringFromIndex:8]]];
    }
    @catch (NSException *exception) {
        reachability = [Reachability reachabilityWithHostName:@"www.cdc.gov"];
    }
    @finally {
    }
    reachability = [Reachability reachabilityWithHostName:@"www.cdc.gov"];
    NetworkStatus *remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable)
    {
        //        NSLog(@"%@", [[self.epiinfoService.applicationURL substringToIndex:self.epiinfoService.applicationURL.length - 1] substringFromIndex:8]);
        [areYouSure setText:[areYouSure.text stringByAppendingString:@"\nNo internet connection. Cannot upload or email records at this time."]];
        [emailButton setEnabled:NO];
        [yesButton setEnabled:NO];
        [noButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [dismissView setFrame:CGRectMake(0, 0, parentEDV.superview.frame.size.width, parentEDV.superview.frame.size.height)];
        } completion:^(BOOL finished){
        }];
        return;
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [dismissView setFrame:CGRectMake(0, 0, parentEDV.superview.frame.size.width, parentEDV.superview.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)prePackageData:(UIButton *)sender
{
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(sender.frame.origin.x + sender.frame.size.width / 2.0, sender.frame.origin.y + sender.frame.size.height / 2.0, 0, 0)];
    [messageView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [messageView.layer setCornerRadius:8.0];
    [dismissView addSubview:messageView];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setNumberOfLines:0];
    [areYouSure setText:@"Specify a password for encrypted data file:"];
    [messageView addSubview:areYouSure];
    
    EpiInfoTextField *eitf = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [eitf setBorderStyle:UITextBorderStyleRoundedRect];
    [eitf setDelegate:self];
    [eitf setReturnKeyType:UIReturnKeyDone];
    [eitf setColumnName:@"None"];
    [eitf setSecureTextEntry:YES];
    [messageView addSubview:eitf];
    
    UIButton *packageDataButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [packageDataButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [packageDataButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [packageDataButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [packageDataButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [packageDataButton.layer setMasksToBounds:YES];
    [packageDataButton.layer setCornerRadius:4.0];
    if ([sender.titleLabel.text isEqualToString:@"Package for I tunes upload."])
    {
        [packageDataButton setImage:[UIImage imageNamed:@"PackageForiTunesButton.png"] forState:UIControlStateNormal];
        [packageDataButton setTitle:@"Package for I tunes upload." forState:UIControlStateNormal];
        [packageDataButton addTarget:self action:@selector(packageDataForiTunes:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
//        [packageDataButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
        [packageDataButton setTitle:@"Package and Email Data" forState:UIControlStateNormal];
        [packageDataButton setAccessibilityLabel:@"Package and email"];
        [packageDataButton addTarget:self action:@selector(packageAndEmailData:) forControlEvents:UIControlEventTouchUpInside];
    }
    [messageView addSubview:packageDataButton];
    
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [noButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [noButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [noButton.layer setMasksToBounds:YES];
    [noButton.layer setCornerRadius:4.0];
    [noButton addTarget:self action:@selector(dismissPrePackageDataView:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:noButton];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [messageView setFrame:CGRectMake(10, 10, 300, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y + ([(DataEntryViewController *)rootViewController openButton]).frame.size.height + 90.0)];
        [areYouSure setFrame:CGRectMake(10, 10, 280, 96)];
        [eitf setFrame:CGRectMake(2, 96, 296, 40)];
        [packageDataButton setFrame:CGRectMake(1, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y + 42.0 - ([(DataEntryViewController *)rootViewController openButton]).frame.size.height, 298, 40)];
        [noButton setFrame:CGRectMake(messageView.frame.size.width / 2.0 -  ([(DataEntryViewController *)rootViewController openButton]).frame.size.width / 2.0, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y + 46.0, ([(DataEntryViewController *)rootViewController openButton]).frame.size.width, ([(DataEntryViewController *)rootViewController openButton]).frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)chooseDecimalSeparator:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Use dot for decimal separator"])
    {
        useDotForDecimal = YES;
        [dotDecimalSeparatorView setBackgroundColor:[UIColor redColor]];
        [commaDecimalSeparatorView setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        useDotForDecimal = NO;
        [dotDecimalSeparatorView setBackgroundColor:[UIColor clearColor]];
        [commaDecimalSeparatorView setBackgroundColor:[UIColor redColor]];
    }
}

- (void)dismissPrePackageDataView:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[sender superview] setFrame:CGRectMake([sender superview].frame.origin.x, -[sender superview].frame.size.height, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
        [[sender superview] removeFromSuperview];
    }];
}

- (void)oldPackageAndEmailDaga:(UIButton *)sender
{
    NSDate *dateObject = [NSDate date];
    BOOL dmy = ([[[dateObject descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[dateObject descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
    
    if (!mailComposerShown)
    {
        NSString *userPassword;
        for (UIView *v in [[sender superview] subviews])
            if ([v isKindOfClass:[UITextField class]])
                userPassword = [(UITextField *)v text];
        if ([userPassword length] == 0)
            return;
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *docFile = [path stringByAppendingPathComponent:[((EnterDataView *)edv).formName stringByAppendingString:@".epi7"]];
        NSString *tmpPath = NSTemporaryDirectory();
        NSString *tmpFile = [tmpPath stringByAppendingPathComponent:[((EnterDataView *)edv).formName stringByAppendingString:@".xml"]];
        
        // Connect to sqlite and assemble XML
        NSMutableString *xmlFileText = [NSMutableString stringWithString:@"<SurveyResponses>"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
        {
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = @"select GlobalRecordID, FKEY";
                for (int k = 0; k < ((EnterDataView *)edv).pagesArray.count; k++)
                    for (int l = 0; l < [(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:k] count]; l++)
                        selStmt = [[selStmt stringByAppendingString:@", "] stringByAppendingString:[(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:k] objectAtIndex:l]];
                selStmt = [NSString stringWithFormat:@"%@ from %@", selStmt, ((EnterDataView *)edv).formName];
                
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    // Give user feedback that package is building.
                    FeedbackView *feedbackView = [[FeedbackView alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
                    [feedbackView setTotalRecords:recordsToBeWrittenToPackageFile];
                    NSThread *activityIndicatorThread = [[NSThread alloc] initWithTarget:self selector:@selector(showActivityIndicatorWhileCreatingPackageFile:) object:feedbackView];
                    [activityIndicatorThread start];
                    int recordTracker = 0;
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        [feedbackView setTag:++recordTracker];
                        [xmlFileText appendString:@"\n\t<SurveyResponse SurveyResponseID=\""];
                        
                        int i = 0;
                        BOOL idAlreadyAdded = NO;
                        BOOL fkeyAlreadyAdded = NO;
                        
                        while (sqlite3_column_name(statement, i))
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                            {
                                if (!idAlreadyAdded)
                                {
                                    [xmlFileText appendString:@""];
                                    [xmlFileText appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                                    [xmlFileText appendString:@"\""];
                                }
                                idAlreadyAdded = YES;
                            }
                            if ([[columnName lowercaseString] isEqualToString:@"fkey"])
                            {
                                if (!fkeyAlreadyAdded)
                                {
                                    [xmlFileText appendString:@" fkey=\""];
                                    [xmlFileText appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                                    [xmlFileText appendString:@"\">"];
                                }
                                fkeyAlreadyAdded = YES;
                            }
                            i++;
                        }
                        
                        i = 0;
                        
                        while (sqlite3_column_name(statement, i))
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"] || [[columnName lowercaseString] isEqualToString:@"fkey"])
                            {
                                i++;
                                continue;
                            }
                            if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:0] objectAtIndex:0] lowercaseString]])
                            {
                                [xmlFileText appendString:@"\n\t<Page PageId=\""];
                                [xmlFileText appendString:[((EnterDataView *)edv).pageIDs objectAtIndex:0]];
                                [xmlFileText appendString:@"\">"];
                            }
                            for (int j = 1; j < ((EnterDataView *)edv).pagesArray.count; j++)
                            {
                                if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:j] objectAtIndex:0] lowercaseString]])
                                {
                                    [xmlFileText appendString:@"\n\t</Page>\n\t<Page PageId=\""];
                                    [xmlFileText appendString:[((EnterDataView *)edv).pageIDs objectAtIndex:j]];
                                    [xmlFileText appendString:@"\">"];
                                }
                            }
                            
                            if ([((EnterDataView *)edv).checkboxes objectForKey:columnName])
                            {
                                switch (sqlite3_column_int(statement, i))
                                {
                                    case (1):
                                    {
                                        [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                        [xmlFileText appendString:columnName];
                                        [xmlFileText appendString:@"\">"];
                                        [xmlFileText appendString:@"true"];
                                        [xmlFileText appendString:@"</"];
                                        [xmlFileText appendString:@"ResponseDetail"];
                                        [xmlFileText appendString:@">"];
                                        break;
                                    }
                                    default:
                                    {
                                        [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                        [xmlFileText appendString:columnName];
                                        [xmlFileText appendString:@"\">"];
                                        [xmlFileText appendString:@"false"];
                                        [xmlFileText appendString:@"</"];
                                        [xmlFileText appendString:@"ResponseDetail"];
                                        [xmlFileText appendString:@">"];
                                        break;
                                    }
                                }
                            }
                            else if (sqlite3_column_type(statement, i) == 1)
                            {
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)]];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else if (sqlite3_column_type(statement, i) == 2)
                            {
                                NSString *value = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                                
                                NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
                                [nsnf setMaximumFractionDigits:6];
                                
                                if (!useDotForDecimal)
                                    value = [value stringByReplacingOccurrencesOfString:@"." withString:@","];
                                
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:value];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] isEqualToString:@"(null)"])
                            {
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:@""];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else
                            {
                                NSString *stringValue = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                                @try {
                                    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
                                    if (dmy)
                                    {
                                        [nsdf setDateFormat:@"dd/MM/yyyy"];
                                    }
                                    else
                                    {
                                        [nsdf setDateFormat:@"MM/dd/yyyy"];
                                    }
                                    NSDate *dt = [nsdf dateFromString:stringValue];
                                    if (dt)
                                    {
                                        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                                        NSDateComponents *components = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:dt];
                                        stringValue = [NSString stringWithFormat:@"%d-%d-%d", (int)[components year], (int)[components month], (int)[components day]];
                                    }
                                    NSLog(@"%@", stringValue);
                                }
                                @catch (NSException *exception) {
                                    NSLog(@"%@", exception);
                                }
                                @finally {
                                    //
                                }
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:stringValue];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            i++;
                        }
                        [xmlFileText appendString:@"\n\t</Page>\n\t</SurveyResponse>"];
                    }
                    [feedbackView removeFromSuperview];
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
        }
        
        [xmlFileText appendString:@"</SurveyResponses>"];
        //        NSLog(@"%@", xmlFileText);
        
        [xmlFileText writeToFile:tmpFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        CCCryptorRef thisEncipher = NULL;
        
        //    const unsigned char bytes[] = {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610};
        //    NSData *iv = [NSData dataWithBytes:bytes length:16];
        //    NSLog(@"%@:%s", iv, (const void *)iv.bytes);
        
        NSString *password = userPassword;
        float passwordLength = (float)password.length;
        float sixteens = 16.0 / passwordLength;
        if (sixteens > 1.0)
            for (int i = 0; i < (int)sixteens; i++)
                password = [password stringByAppendingString:password];
        password = [password substringToIndex:16];
        //    NSLog(@"%@", [password dataUsingEncoding:NSUTF8StringEncoding]);
        NSLog(@"%@", [ConverterMethods hexArrayToDecArray:[@"0000000000000000" dataUsingEncoding:NSUTF8StringEncoding]]);
        CCCryptorStatus result = CCCryptorCreate(kCCEncrypt,
                                                 kCCAlgorithmAES128,
                                                 kCCOptionPKCS7Padding, // 0x0000 or kCCOptionPKCS7Padding
                                                 (const void *)[password dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                                 [password dataUsingEncoding:NSUTF8StringEncoding].length,
                                                 (const void *)[@"0000000000000000" dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                                 &thisEncipher
                                                 );
        
        uint8_t *bufferPtr = NULL;
        size_t bufferPtrSize = 0;
        size_t remainingBytes = 0;
        size_t movedBytes = 0;
        size_t plainTextBufferSize = 0;
        size_t totalBytesWritten = 0;
        uint8_t *ptr;
        
        NSData *plainText = [xmlFileText dataUsingEncoding:NSUTF8StringEncoding];
        
        plainTextBufferSize = [plainText length];
        bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
        bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        ptr = bufferPtr;
        remainingBytes = bufferPtrSize;
        
        result = CCCryptorUpdate(thisEncipher,
                                 (const void *)[plainText bytes],
                                 plainTextBufferSize,
                                 ptr,
                                 remainingBytes,
                                 &movedBytes
                                 );
        
        ptr += movedBytes;
        remainingBytes -= movedBytes;
        totalBytesWritten += movedBytes;
        
        result = CCCryptorFinal(thisEncipher,
                                ptr,
                                remainingBytes,
                                &movedBytes
                                );
        
        totalBytesWritten += movedBytes;
        
        if (thisEncipher)
        {
            (void) CCCryptorRelease(thisEncipher);
            thisEncipher = NULL;
        }
        
        if (result == kCCSuccess)
        {
            MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
            [composer setMailComposeDelegate:self];
            //            NSData *encryptedData = [NSData dataWithBytes:thisEncipher length:numBytesEncrypted];
            NSData *encryptedData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
            [[@"APPLE" stringByAppendingString:[encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]] writeToFile:docFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
            
            if (bufferPtr)
                free(bufferPtr);
            [composer addAttachmentData:[NSData dataWithContentsOfFile:docFile] mimeType:@"text/plain" fileName:[((EnterDataView *)edv).formName stringByAppendingString:@".epi7"]];
            [composer setSubject:@"Epi Info Data"];
            [composer setMessageBody:@"Here is some Epi Info data." isHTML:NO];
            [(DataEntryViewController *)rootViewController presentViewController:composer animated:YES completion:^(void){
                mailComposerShown = YES;
            }];
            //            free(buffer);
            [self dismissPrePackageDataView:sender];
            return;
        }
        
        
        if (result == kCCSuccess)
        {
            NSData *encryptedData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
            [[@"APPLE" stringByAppendingString:[encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]] writeToFile:docFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
            return;
        }
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        [composer addAttachmentData:[NSData dataWithContentsOfFile:docFile] mimeType:@"text/plain" fileName:[((EnterDataView *)edv).formName stringByAppendingString:@".epi7"]];
        [composer setSubject:@"Epi Info Data"];
        [composer setMessageBody:@"Here is some Epi Info data." isHTML:NO];
        [(DataEntryViewController *)rootViewController presentViewController:composer animated:YES completion:^(void){
            mailComposerShown = YES;
        }];
    }
}
- (void)packageAndEmailData:(UIButton *)sender
{
    NSDate *dateObject = [NSDate date];
    BOOL dmy = ([[[dateObject descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[dateObject descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
    
    BOOL formHasImages = NO;
    
    if (!mailComposerShown)
    {
        NSString *userPassword;
        for (UIView *v in [[sender superview] subviews])
            if ([v isKindOfClass:[UITextField class]])
                userPassword = [(UITextField *)v text];
        if ([userPassword length] == 0)
            return;
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *docFile = [path stringByAppendingPathComponent:[((EnterDataView *)edv).formName stringByAppendingString:@".epi7"]];
        NSString *tmpPath = NSTemporaryDirectory();
        NSString *tmpFile = [tmpPath stringByAppendingPathComponent:[((EnterDataView *)edv).formName stringByAppendingString:@".xml"]];
        
        // Connect to sqlite and assemble XML
        NSMutableString *xmlFileText = [NSMutableString stringWithString:@"<SurveyResponses>"];
        
        FeedbackView *feedbackView = [[FeedbackView alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
        {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
            {
                if ([[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:((EnterDataView *)edv).formName]])
                {
                    formHasImages = YES;
                }
            }
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = @"select GlobalRecordID, FKEY";
                for (int k = 0; k < ((EnterDataView *)edv).pagesArray.count; k++)
                    for (int l = 0; l < [(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:k] count]; l++)
                        selStmt = [[selStmt stringByAppendingString:@", "] stringByAppendingString:[(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:k] objectAtIndex:l]];
                selStmt = [NSString stringWithFormat:@"%@ from %@", selStmt, ((EnterDataView *)edv).formName];
                
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    // Give user feedback that package is building.
                    [feedbackView setTotalRecords:recordsToBeWrittenToPackageFile];
                    NSThread *activityIndicatorThread = [[NSThread alloc] initWithTarget:self selector:@selector(showActivityIndicatorWhileCreatingPackageFile:) object:feedbackView];
                    [activityIndicatorThread start];
                    int recordTracker = 0;
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        [feedbackView setTag:++recordTracker];
                        [xmlFileText appendString:@"\n\t<SurveyResponse SurveyResponseID=\""];
                        
                        int i = 0;
                        BOOL idAlreadyAdded = NO;
                        BOOL fkeyAlreadyAdded = NO;
                        
                        while (sqlite3_column_name(statement, i))
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                            {
                                if (!idAlreadyAdded)
                                {
                                    [xmlFileText appendString:@""];
                                    [xmlFileText appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                                    [xmlFileText appendString:@"\""];
                                }
                                idAlreadyAdded = YES;
                            }
                            if ([[columnName lowercaseString] isEqualToString:@"fkey"])
                            {
                                if (!fkeyAlreadyAdded)
                                {
                                    [xmlFileText appendString:@" fkey=\""];
                                    [xmlFileText appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                                    [xmlFileText appendString:@"\">"];
                                }
                                fkeyAlreadyAdded = YES;
                            }
                            i++;
                        }
                        
                        i = 0;
                        
                        while (sqlite3_column_name(statement, i))
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"] || [[columnName lowercaseString] isEqualToString:@"fkey"])
                            {
                                i++;
                                continue;
                            }
                            BOOL isOptionField = NO;
                            NSDictionary *nsdof = [((EnterDataView *)edv).dictionaryOfFields nsmd];
                            id controlField = [nsdof objectForKey:[columnName lowercaseString]];
                            if (controlField == nil)
                            {
                                for (id key in [((EnterDataView *)edv) dictionaryOfPages])
                                {
                                    EnterDataView *ev = (EnterDataView *)[[((EnterDataView *)edv) dictionaryOfPages] objectForKey:key];
                                    nsdof = [ev.dictionaryOfFields nsmd];
                                    controlField = [nsdof objectForKey:[columnName lowercaseString]];
                                    if (controlField != nil)
                                        break;
                                }
                            }
                            if ([controlField isKindOfClass:[EpiInfoOptionField class]])
                                isOptionField = YES;
                            if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:0] objectAtIndex:0] lowercaseString]])
                            {
                                [xmlFileText appendString:@"\n\t<Page PageId=\""];
                                [xmlFileText appendString:[((EnterDataView *)edv).pageIDs objectAtIndex:0]];
                                [xmlFileText appendString:@"\">"];
                            }
                            for (int j = 1; j < ((EnterDataView *)edv).pagesArray.count; j++)
                            {
                                if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:j] objectAtIndex:0] lowercaseString]])
                                {
                                    [xmlFileText appendString:@"\n\t</Page>\n\t<Page PageId=\""];
                                    [xmlFileText appendString:[((EnterDataView *)edv).pageIDs objectAtIndex:j]];
                                    [xmlFileText appendString:@"\">"];
                                }
                            }
                            
                            if ([((EnterDataView *)edv).checkboxes objectForKey:columnName])
                            {
                                switch (sqlite3_column_int(statement, i))
                                {
                                    case (1):
                                    {
                                        [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                        [xmlFileText appendString:columnName];
                                        [xmlFileText appendString:@"\">"];
                                        [xmlFileText appendString:@"true"];
                                        [xmlFileText appendString:@"</"];
                                        [xmlFileText appendString:@"ResponseDetail"];
                                        [xmlFileText appendString:@">"];
                                        break;
                                    }
                                    default:
                                    {
                                        [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                        [xmlFileText appendString:columnName];
                                        [xmlFileText appendString:@"\">"];
                                        [xmlFileText appendString:@"false"];
                                        [xmlFileText appendString:@"</"];
                                        [xmlFileText appendString:@"ResponseDetail"];
                                        [xmlFileText appendString:@">"];
                                        break;
                                    }
                                }
                            }
                            else if (sqlite3_column_type(statement, i) == 1)
                            {
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)]];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else if (sqlite3_column_type(statement, i) == 2)
                            {
                                NSString *value = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                                
                                NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
                                [nsnf setMaximumFractionDigits:6];
                                
                                if (!useDotForDecimal)
                                    value = [value stringByReplacingOccurrencesOfString:@"." withString:@","];
                                
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:value];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] isEqualToString:@"(null)"])
                            {
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:@""];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else
                            {
                                NSString *stringValue = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                                @try {
                                    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
                                    if (dmy)
                                    {
                                        [nsdf setDateFormat:@"dd/MM/yyyy"];
                                    }
                                    else
                                    {
                                        [nsdf setDateFormat:@"MM/dd/yyyy"];
                                    }
                                    NSDate *dt = [nsdf dateFromString:stringValue];
                                    if (dt)
                                    {
                                        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                                        NSDateComponents *components = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:dt];
                                        stringValue = [NSString stringWithFormat:@"%d-%d-%d", (int)[components year], (int)[components month], (int)[components day]];
                                    }
                                    NSLog(@"%@", stringValue);
                                }
                                @catch (NSException *exception) {
                                    NSLog(@"%@", exception);
                                }
                                @finally {
                                    //
                                }
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                if (isOptionField)
                                {
                                    if ([stringValue isEqualToString:[NSString stringWithFormat:@"%d", [stringValue intValue]]])
                                    {
                                        int stringValueIntValue = [stringValue intValue];
                                        stringValue = [NSString stringWithFormat:@"%d", stringValueIntValue - 0];
                                    }
                                }
                                if ([controlField isKindOfClass:[EpiInfoImageField class]] && stringValue && [stringValue length] > 0)
                                {
                                    [xmlFileText appendString:@"/sdcard/Download/EpiInfo/Images/"];
                                    //[xmlFileText appendString:[NSString stringWithFormat:@"%@\\", ((EnterDataView *)edv).formName]];
                                }
                                [xmlFileText appendString:stringValue];
                                if ([controlField isKindOfClass:[EpiInfoImageField class]] && stringValue && [stringValue length] > 0)
                                    [xmlFileText appendString:@".jpg"];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            i++;
                        }
                        [xmlFileText appendString:@"\n\t</Page>\n\t</SurveyResponse>"];
                    }
                    [feedbackView removeFromSuperview];
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
        }
        
        [xmlFileText appendString:@"</SurveyResponses>"];
        //        NSLog(@"%@", xmlFileText);
        
        [xmlFileText writeToFile:tmpFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        CCCryptorRef thisEncipher = NULL;
        
        //    const unsigned char bytes[] = {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610};
        //    NSData *iv = [NSData dataWithBytes:bytes length:16];
        //    NSLog(@"%@:%s", iv, (const void *)iv.bytes);
        
        NSString *password = userPassword;
        
        NSString *keyString = INITVECTOR;
        NSString *saltString = PASSWORDSALT;

        NSMutableData *keyArray = [[NSMutableData alloc] init];
        unsigned char key_whole_byte;
        char key_byte_chars[3] = {'\0', '\0', '\0'};
        for (int i = 0; i < [keyString length] / 2; i++)
        {
            key_byte_chars[0] = [keyString characterAtIndex:i*2];
            key_byte_chars[1] = [keyString characterAtIndex:i*2+1];
            key_whole_byte = strtol(key_byte_chars, NULL, 16);
            [keyArray appendBytes:&key_whole_byte length:1];
        }
        
        NSMutableData *saltArray = [[NSMutableData alloc] init];
        unsigned char salt_whole_byte;
        char salt_byte_chars[3] = {'\0', '\0', '\0'};
        for (int i = 0; i < [saltString length] / 2; i++)
        {
            salt_byte_chars[0] = [saltString characterAtIndex:i*2];
            salt_byte_chars[1] = [saltString characterAtIndex:i*2+1];
            salt_whole_byte = strtol(salt_byte_chars, NULL, 16);
            [saltArray appendBytes:&salt_whole_byte length:1];
        }
        
        unsigned char key[16];
        CCKeyDerivationPBKDF(kCCPBKDF2, [password dataUsingEncoding:NSUTF8StringEncoding].bytes, [password dataUsingEncoding:NSUTF8StringEncoding].length, saltArray.bytes, saltArray.length, kCCPRFHmacAlgSHA1, 1000, key, 16);
        NSData *keyData = [NSData dataWithBytes:(const void *)key length:sizeof(unsigned char)*16];
        
        CCCryptorStatus result = CCCryptorCreate(kCCEncrypt,
                                                 kCCAlgorithmAES128,
                                                 kCCOptionPKCS7Padding, // 0x0000 or kCCOptionPKCS7Padding
                                                 keyData.bytes, //(const void *)[password dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                                 keyData.length, //[password dataUsingEncoding:NSUTF8StringEncoding].length,
                                                 keyArray.bytes, //(const void *)[LEGACYKEY dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                                 &thisEncipher
                                                 );

        uint8_t *bufferPtr = NULL;
        size_t bufferPtrSize = 0;
        size_t remainingBytes = 0;
        size_t movedBytes = 0;
        size_t plainTextBufferSize = 0;
        size_t totalBytesWritten = 0;
        uint8_t *ptr;
        
        NSData *plainText = [xmlFileText dataUsingEncoding:NSUTF8StringEncoding];
        
        plainTextBufferSize = [plainText length];
        bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
        bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        ptr = bufferPtr;
        remainingBytes = bufferPtrSize;
        
        result = CCCryptorUpdate(thisEncipher,
                                 (const void *)[plainText bytes],
                                 plainTextBufferSize,
                                 ptr,
                                 remainingBytes,
                                 &movedBytes
                                 );
        
        ptr += movedBytes;
        remainingBytes -= movedBytes;
        totalBytesWritten += movedBytes;
        
        result = CCCryptorFinal(thisEncipher,
                                ptr,
                                remainingBytes,
                                &movedBytes
                                );
        
        totalBytesWritten += movedBytes;
        
        if (thisEncipher)
        {
            (void) CCCryptorRelease(thisEncipher);
            thisEncipher = NULL;
        }
        
        if (result == kCCSuccess)
        {
            MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
            [composer setMailComposeDelegate:self];
            //            NSData *encryptedData = [NSData dataWithBytes:thisEncipher length:numBytesEncrypted];
            NSData *encryptedData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
            [[encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn] writeToFile:docFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
            
            if (bufferPtr)
                free(bufferPtr);
            [composer addAttachmentData:[NSData dataWithContentsOfFile:docFile] mimeType:@"text/plain" fileName:[((EnterDataView *)edv).formName stringByAppendingString:@".epi7"]];
            if (formHasImages)
            {
                NSArray *ls = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:((EnterDataView *)edv).formName] error:nil];
                for (id file in ls)
                {
                    [composer addAttachmentData:[NSData dataWithContentsOfFile:[[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:((EnterDataView *)edv).formName] stringByAppendingString:[NSString stringWithFormat:@"/%@", file]]] mimeType:@"image/jpeg" fileName:(NSString *)file];
                }
            }
            [composer setSubject:@"Epi Info Data"];
            [composer setMessageBody:@"Here is some Epi Info data." isHTML:NO];
            [(DataEntryViewController *)rootViewController presentViewController:composer animated:YES completion:^(void){
                mailComposerShown = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (feedbackView)
                    {
                        if ([feedbackView superview])
                        {
                            [feedbackView removeFromSuperview];
                        }
                    }
                });
            }];
            //            free(buffer);
            [self dismissPrePackageDataView:sender];
            return;
        }
        
        
        if (result == kCCSuccess)
        {
            NSData *encryptedData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
            [[encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn] writeToFile:docFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
            return;
        }
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        [composer addAttachmentData:[NSData dataWithContentsOfFile:docFile] mimeType:@"text/plain" fileName:[((EnterDataView *)edv).formName stringByAppendingString:@".epi7"]];
        [composer setSubject:@"Epi Info Data"];
        [composer setMessageBody:@"Here is some Epi Info data." isHTML:NO];
        [(DataEntryViewController *)rootViewController presentViewController:composer animated:YES completion:^(void){
            mailComposerShown = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (feedbackView)
                {
                    if ([feedbackView superview])
                    {
                        [feedbackView removeFromSuperview];
                    }
                }
            });
        }];
    }
}

- (void)emailDataAsCSV:(UIButton *)sender
{
    NSDate *dateObject = [NSDate date];
    BOOL dmy = ([[[dateObject descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[dateObject descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
    
    BOOL formHasImages = NO;
    
    if (!mailComposerShown)
    {
        NSString *tmpPath = NSTemporaryDirectory();
        NSString *tmpFile = [tmpPath stringByAppendingPathComponent:[((EnterDataView *)edv).formName stringByAppendingString:@".csv"]];
        
        NSMutableString *csvVariablesText = [[NSMutableString alloc] init];
        NSMutableString *csvDataText = [[NSMutableString alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
        {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
            {
                if ([[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:((EnterDataView *)edv).formName]])
                {
                    formHasImages = YES;
                }
            }
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = @"select GlobalRecordID";
                for (int k = 0; k < ((EnterDataView *)edv).pagesArray.count; k++)
                    for (int l = 0; l < [(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:k] count]; l++)
                        selStmt = [[selStmt stringByAppendingString:@", "] stringByAppendingString:[(NSMutableArray *)[((EnterDataView *)edv).pagesArray objectAtIndex:k] objectAtIndex:l]];
                selStmt = [NSString stringWithFormat:@"%@ from %@", selStmt, ((EnterDataView *)edv).formName];
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    // Give user feedback that package is building.
                    int row = -1;
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        row++;
                        [csvDataText appendString:@"\n"];
                        
                        int i = 0;
                        
                        while (sqlite3_column_name(statement, i))
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            BOOL isOptionField = NO;
                            NSDictionary *nsdof = [((EnterDataView *)edv).dictionaryOfFields nsmd];
                            id controlField = [nsdof objectForKey:[columnName lowercaseString]];
                            if (controlField == nil)
                            {
                                for (id key in [((EnterDataView *)edv) dictionaryOfPages])
                                {
                                    EnterDataView *ev = (EnterDataView *)[[((EnterDataView *)edv) dictionaryOfPages] objectForKey:key];
                                    nsdof = [ev.dictionaryOfFields nsmd];
                                    controlField = [nsdof objectForKey:[columnName lowercaseString]];
                                    if (controlField != nil)
                                        break;
                                }
                            }
                            if ([controlField isKindOfClass:[EpiInfoOptionField class]])
                                isOptionField = YES;
                            if (row == 0)
                            {
                                if (i > 0)
                                    [csvVariablesText appendFormat:@",\"%@\"", columnName];
                                else
                                    [csvVariablesText appendFormat:@"\"%@\"", columnName];
                            }
                            if ([((EnterDataView *)edv).checkboxes objectForKey:columnName])
                            {
                                switch (sqlite3_column_int(statement, i))
                                {
                                    case (1):
                                    {
                                        if (i > 0)
                                            [csvDataText appendFormat:@",true"];
                                        else
                                            [csvDataText appendFormat:@"true"];
                                        break;
                                    }
                                    default:
                                    {
                                        if (i > 0)
                                            [csvDataText appendFormat:@",false"];
                                        else
                                            [csvDataText appendFormat:@"false"];
                                        break;
                                    }
                                }
                            }
                            else if ([[((EnterDataView *)edv).dictionaryOfCommentLegals objectForKey:columnName] isKindOfClass:[CommentLegal class]])
                            {
                                NSString *dataValue = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                                if ([dataValue isEqualToString:@"(null)"])
                                {
                                    if (i > 0)
                                        [csvDataText appendFormat:@","];
                                    else
                                        [csvDataText appendFormat:@""];
                                }
                                else if ([dataValue containsString:@"-"])
                                {
                                    int dashPos = (int)[dataValue rangeOfString:@"-"].location;
                                    NSString *clValue = [dataValue substringToIndex:dashPos];
                                    if (i > 0)
                                        [csvDataText appendFormat:@",\"%@\"", clValue];
                                    else
                                        [csvDataText appendFormat:@"\"%@\"", clValue];
                                }
                                else
                                {
                                    if (i > 0)
                                        [csvDataText appendFormat:@",\"%@\"", dataValue];
                                    else
                                        [csvDataText appendFormat:@"\"%@\"", dataValue];
                                }
                            }
                            else if (sqlite3_column_type(statement, i) == 1)
                            {
                                if (i > 0)
                                    [csvDataText appendFormat:@",%@", [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)]];
                                else
                                    [csvDataText appendFormat:@"%@", [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)]];
                            }
                            else if (sqlite3_column_type(statement, i) == 2)
                            {
                                NSString *value = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                                
                                NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
                                [nsnf setMaximumFractionDigits:6];
                                if (!useDotForDecimal)
                                    value = [value stringByReplacingOccurrencesOfString:@"." withString:@","];
                                if (i > 0)
                                    [csvDataText appendFormat:@",\"%@\"", value];
                                else
                                    [csvDataText appendFormat:@"\"%@\"", value];
                            }
                            else if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] isEqualToString:@"(null)"])
                            {
                                if (i > 0)
                                    [csvDataText appendFormat:@","];
                                else
                                    [csvDataText appendFormat:@""];
                            }
                            else
                            {
                                NSString *stringValue = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                                // New code for correcting single and double quote characters
                                NSMutableArray *eightytwoeighteens = [[NSMutableArray alloc] init];
                                for (int i = 0; i < stringValue.length; i++)
                                {
                                    if ([stringValue characterAtIndex:i] == 8218)
                                        [eightytwoeighteens addObject:[NSNumber numberWithInteger:i]];
                                }
                                for (int i = (int)eightytwoeighteens.count - 1; i >= 0; i--)
                                {
                                    NSNumber *num = [eightytwoeighteens objectAtIndex:i];
                                    stringValue = [stringValue stringByReplacingCharactersInRange:NSMakeRange([num integerValue], 1) withString:@""];
                                }
                                if ([eightytwoeighteens count] > 0)
                                {
                                    if ([stringValue containsString:[NSString stringWithFormat:@"%c%c", '\304', '\364']])
                                        stringValue = [stringValue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c%c", '\304', '\364'] withString:@"'"];
                                    if ([stringValue containsString:[NSString stringWithFormat:@"%c%c", '\304', '\371']])
                                        stringValue = [stringValue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c%c", '\304', '\371'] withString:@"\""];
                                }
                                @try {
                                    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
                                    if (dmy)
                                    {
                                        [nsdf setDateFormat:@"dd/MM/yyyy"];
                                    }
                                    else
                                    {
                                        [nsdf setDateFormat:@"MM/dd/yyyy"];
                                    }
                                    NSDate *dt = [nsdf dateFromString:stringValue];
                                    if (dt)
                                    {
                                        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                                        NSDateComponents *components = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:dt];
                                        stringValue = [NSString stringWithFormat:@"%d-%d-%d", (int)[components year], (int)[components month], (int)[components day]];
                                    }
                                    NSLog(@"%@", stringValue);
                                }
                                @catch (NSException *exception) {
                                    NSLog(@"%@", exception);
                                }
                                @finally {
                                    //
                                }
                                if (isOptionField)
                                {
                                    if ([stringValue isEqualToString:[NSString stringWithFormat:@"%d", [stringValue intValue]]])
                                    {
                                        int stringValueIntValue = [stringValue intValue];
                                        stringValue = [NSString stringWithFormat:@"%d", stringValueIntValue - 0];
                                    }
                                }
                                if (i > 0)
                                    [csvDataText appendFormat:@","];
                                if ([controlField isKindOfClass:[EpiInfoImageField class]])
                                {
                                    [csvDataText appendString:@"EpiInfo\\Images\\"];
                                    [csvDataText appendString:[NSString stringWithFormat:@"%@\\", ((EnterDataView *)edv).formName]];
                                }
                                [csvDataText appendFormat:@"\"%@\"", stringValue];
                                if ([controlField isKindOfClass:[EpiInfoImageField class]])
                                {
                                    [csvDataText appendString:@".jpg"];
                                }
                            }
                            
                            i++;
                        }
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
        }
        
        NSString *wholeCSVString = [csvVariablesText stringByAppendingString:csvDataText];
        [wholeCSVString writeToFile:tmpFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        if (YES)
        {
            MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
            [composer setMailComposeDelegate:self];
            
            [composer addAttachmentData:[NSData dataWithContentsOfFile:tmpFile] mimeType:@"text/plain" fileName:[((EnterDataView *)edv).formName stringByAppendingString:@".csv"]];
            if (formHasImages)
            {
                NSArray *ls = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:((EnterDataView *)edv).formName] error:nil];
                for (id file in ls)
                {
                    [composer addAttachmentData:[NSData dataWithContentsOfFile:[[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:((EnterDataView *)edv).formName] stringByAppendingString:[NSString stringWithFormat:@"/%@", file]]] mimeType:@"image/jpeg" fileName:(NSString *)file];
                }
            }
            [composer setSubject:@"Epi Info Data"];
            [composer setMessageBody:@"Here is some Epi Info data." isHTML:NO];
            [(DataEntryViewController *)rootViewController presentViewController:composer animated:YES completion:^(void){
                mailComposerShown = YES;
            }];
            return;
        }
    }
}

- (void)showActivityIndicatorWhileCreatingPackageFile:(FeedbackView *)feedbackView
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [feedbackView setFrame:CGRectMake(10, 10, 300, 314)];
        });
    } completion:^(BOOL finished){
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [feedbackView setBackgroundColor:[UIColor clearColor]];
        [feedbackView setBlurTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
        [feedbackView.layer setCornerRadius:10.0];
        [dismissView addSubview:feedbackView];
        UIActivityIndicatorView *uiavPackage = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 280, 20, 20)];
        [feedbackView addSubview:uiavPackage];
        [uiavPackage setColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [uiavPackage startAnimating];
        [dismissView bringSubviewToFront:feedbackView];
        
        feedbackView.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 40)];
        [feedbackView.percentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
        [feedbackView.percentLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [feedbackView addSubview:feedbackView.percentLabel];
    });
}

- (void)uploadAllRecords:(UIButton *)sender
{
    NSLog(@"uploadAllRecords sender: %@", sender);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// <MFMailComposeViewControllerDelegate> delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            //            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [(DataEntryViewController *)rootViewController dismissViewControllerAnimated:YES completion:^{
    }];
    mailComposerShown = NO;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 0:
//            break;
//
//        case 1:
//            [self dismissForm];
//            break;
//    }
//}

- (void)footerBarDelete
{
    for (int i = (int)[self.rootViewController.view subviews].count - 1; i >= 0; i--)
    {
        id v = [[self.rootViewController.view subviews] objectAtIndex:i];
        if ([v isKindOfClass:[EnterDataView class]])
        {
            UIButton *button = [[UIButton alloc] init];
            [button setTag:7];
            [(EnterDataView *)v confirmSubmitOrClear:button];
            break;
        }
    }
}

- (void)selfFocus
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.1f];
        dispatch_async(dispatch_get_main_queue(), ^{
            float yForBottom = [(EnterDataView *)[[self superview] superview] contentSize].height - [(EnterDataView *)[[self superview] superview] bounds].size.height;
            if (yForBottom < 0.0)
                yForBottom = 0.0;
            float selfY = self.frame.origin.y - 80.0f;
            
            CGPoint pt = CGPointMake(0.0f, selfY);
            if (selfY > yForBottom)
                pt = CGPointMake(0.0f, yForBottom);
            
            [(EnterDataView *)[[self superview] superview] setContentOffset:pt animated:YES];
        });
    });
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextMoveToPoint(ctx, 2.0, 2.0);
    CGContextAddLineToPoint(ctx, rect.size.width - 2.0, 2.0);
    CGContextAddLineToPoint(ctx, rect.size.width - 2.0, rect.size.height - 2.0);
    CGContextAddLineToPoint(ctx, 2.0  , rect.size.height - 2.0);
    CGContextClosePath(ctx);
    CGContextSetRGBStrokeColor(ctx, 189/255.0, 190/255.0, 192/255.0, 1);
    CGContextStrokePath(ctx);
}

@end
