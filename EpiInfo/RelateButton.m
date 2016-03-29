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
    [self setAccessibilityLabel:title];
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
//    NSLog(@"Load table %@", relatedViewName);
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
        edv = [[EnterDataView alloc] initWithFrame:CGRectMake(0, parentEDV.frame.size.height, parentEDV.frame.size.width, parentEDV.frame.size.height) AndURL:url AndRootViewController:[(EnterDataView *)parentEDV rootViewController] AndNameOfTheForm:relatedViewName AndPageToDisplay:1];
        rootViewController = [(EnterDataView *)edv rootViewController];
        
        [(EnterDataView *)edv setParentRecordGUID:[(EnterDataView *)parentEDV guidToSendToChild]];
        [(EnterDataView *)edv setParentEnterDataView:(EnterDataView *)parentEDV];
        [(EnterDataView *)edv setRelateButtonName:relateButtonName];
        
//        NSLog(@"Child form Check Code: %@", [(EnterDataView *)edv formCheckCodeString]);
        [ChildFormFieldAssignments parseForAssignStatements:[(EnterDataView *)edv formCheckCodeString] parentForm:(EnterDataView *)parentEDV childForm:(EnterDataView *)edv relateButtonName:relateButtonName];

        orangeBannerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, parentEDV.frame.size.height, parentEDV.frame.size.width, 36)];
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
        [xButton addTarget:self action:@selector(confirmDismissal) forControlEvents:UIControlEventTouchUpInside];
        [orangeBanner addSubview:xButton];
        
        UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 30, 30)];
        [uploadButton setBackgroundColor:[UIColor clearColor]];
        [uploadButton setImage:[UIImage imageNamed:@"UploadButton.png"] forState:UIControlStateNormal];
        [uploadButton setTitle:@"Upload data" forState:UIControlStateNormal];
        [uploadButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [uploadButton setAlpha:0.5];
        [uploadButton.layer setMasksToBounds:YES];
        [uploadButton.layer setCornerRadius:8.0];
        [uploadButton addTarget:self action:@selector(confirmUploadAllRecords) forControlEvents:UIControlEventTouchUpInside];
        [orangeBanner addSubview:uploadButton];
        
        UIButton *lineListButton = [[UIButton alloc] initWithFrame:CGRectMake(34, 2, 30, 30)];
        [lineListButton setBackgroundColor:[UIColor clearColor]];
        [lineListButton setImage:[UIImage imageNamed:@"LineList6060.png"] forState:UIControlStateNormal];
        [lineListButton setTitle:@"Show line listing" forState:UIControlStateNormal];
        [lineListButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [lineListButton setAlpha:0.5];
        [lineListButton.layer setMasksToBounds:YES];
        [lineListButton.layer setCornerRadius:8.0];
        [lineListButton addTarget:self action:@selector(lineListButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [orangeBanner addSubview:lineListButton];
        
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [orangeBannerBackground setFrame:CGRectMake(0, 0, parentEDV.frame.size.width, 36)];
            [edv setFrame:CGRectMake(0, 0, parentEDV.frame.size.width, parentEDV.frame.size.height)];
            [orangeBanner setFrame:[orangeBannerBackground frame]];
        } completion:^(BOOL finished){
        }];
    }
}

- (void)confirmDismissal
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dismiss Child Form" message:@"Dismiss this form?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
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
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setNumberOfLines:0];
    [messageView addSubview:areYouSure];
    
    UILabel *decimalSeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 104, 142, 40)];
    [decimalSeparatorLabel setBackgroundColor:[UIColor clearColor]];
    [decimalSeparatorLabel setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
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
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [messageView addSubview:uiaiv];
    
    UIButton *iTunesButton = [[UIButton alloc] initWithFrame:CGRectMake(1, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y - ([(DataEntryViewController *)rootViewController openButton]).frame.size.height, 298, 40)];
    [iTunesButton setImage:[UIImage imageNamed:@"PackageForiTunesButton.png"] forState:UIControlStateNormal];
    [iTunesButton setTitle:@"Package for I tunes upload." forState:UIControlStateNormal];
    [iTunesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [iTunesButton.layer setMasksToBounds:YES];
    [iTunesButton.layer setCornerRadius:4.0];
    [iTunesButton addTarget:self action:@selector(prePackageData:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:iTunesButton];
    [iTunesButton setEnabled:NO];
    
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(1, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y - ([(DataEntryViewController *)rootViewController openButton]).frame.size.height + 42.0, 298, 40)];
    [emailButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
    [emailButton setTitle:@"Package and email" forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [emailButton.layer setMasksToBounds:YES];
    [emailButton.layer setCornerRadius:4.0];
    [emailButton addTarget:self action:@selector(prePackageData:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:emailButton];
    
    //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(1, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y - ([(DataEntryViewController *)rootViewController openButton]).frame.size.height + 84.0, 298, 40)];
    [yesButton setImage:[UIImage imageNamed:@"UploadDataToCloudButton.png"] forState:UIControlStateNormal];
    [yesButton setTitle:@"Upload to cloud" forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [yesButton.layer setMasksToBounds:YES];
    [yesButton.layer setCornerRadius:4.0];
    [yesButton addTarget:self action:@selector(uploadAllRecords:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:yesButton];
    
    //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(messageView.frame.size.width / 2.0 -  ([(DataEntryViewController *)rootViewController openButton]).frame.size.width / 2.0, ([(DataEntryViewController *)rootViewController openButton]).frame.origin.y + 88.0, ([(DataEntryViewController *)rootViewController openButton]).frame.size.width, ([(DataEntryViewController *)rootViewController openButton]).frame.size.height)];
    [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
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
            [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
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
            [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [areYouSure setText:[areYouSure.text stringByAppendingString:@"\nNo cloud connection credentials found for this table."]];
        [yesButton setEnabled:NO];
        [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
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
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
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
    [packageDataButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
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
        [packageDataButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
        [packageDataButton setTitle:@"Package and email" forState:UIControlStateNormal];
        [packageDataButton addTarget:self action:@selector(packageAndEmailData:) forControlEvents:UIControlEventTouchUpInside];
    }
    [messageView addSubview:packageDataButton];
    
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
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

- (void)packageAndEmailData:(UIButton *)sender
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
                        
                        while (sqlite3_column_name(statement, i))
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                            {
                                if (!idAlreadyAdded)
                                {
                                    [xmlFileText appendString:@""];
                                    [xmlFileText appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                                    [xmlFileText appendString:@"\">"];
                                }
                                idAlreadyAdded = YES;
                            }
                            i++;
                        }
                        
                        i = 0;
                        
                        while (sqlite3_column_name(statement, i))
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
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
                                NSString *value = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                                
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
                                NSString *stringValue = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
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
                                        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                                        NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dt];
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
        
        NSData *plainText = [xmlFileText dataUsingEncoding:NSASCIIStringEncoding];
        
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

- (void)showActivityIndicatorWhileCreatingPackageFile:(FeedbackView *)feedbackView
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [feedbackView setFrame:CGRectMake(10, 10, 300, 314)];
    } completion:^(BOOL finished){
    }];
    [feedbackView setBackgroundColor:[UIColor clearColor]];
    [feedbackView setBlurTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    [feedbackView.layer setCornerRadius:10.0];
    [dismissView addSubview:feedbackView];
    UIActivityIndicatorView *uiavPackage = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 280, 20, 20)];
    [feedbackView addSubview:uiavPackage];
    [uiavPackage setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiavPackage startAnimating];
    [dismissView bringSubviewToFront:feedbackView];
    
    feedbackView.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 40)];
    [feedbackView.percentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [feedbackView.percentLabel setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [feedbackView addSubview:feedbackView.percentLabel];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
            
        case 1:
            [self dismissForm];
            break;
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
