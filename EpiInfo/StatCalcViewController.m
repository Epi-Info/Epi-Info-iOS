//
//  StatCalcViewController.m
//  StatCalc
//
//  Created by John Copeland on 10/4/12.
//

#import "StatCalcViewController.h"
#import "StatCalc2x2ViewController.h"
#import "MatchedPairCalculatorViewController.h"
#import "PopulationSurveyViewController.h"
#import "BlurryView.h"

@interface StatCalcViewController ()

@end

@implementation StatCalcViewController
-(BlurryView *)blurryView
{
    return blurryView;
}
-(BlurryView *)blurryView2
{
    return blurryView2;
}
- (CGRect)frameOfButtonPressed
{
    return frameOfButtonPressed;
}
- (UIButton *)buttonPressed
{
    return buttonPressed;
}
- (void)setImageFileToUseInSegue:(NSString *)imageFile
{
    imageFileToUseInSegue = imageFile;
}
- (NSString *)imageFileToUseInSegue
{
    return imageFileToUseInSegue;
}

//iPad
-(void)viewDidLoad
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Change the standard NavigationController "Back" button to an "X"
        customBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [customBackButton setImage:[UIImage imageNamed:@"StAndrewXButtonWhite.png"] forState:UIControlStateNormal];
        [customBackButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
        [customBackButton.layer setMasksToBounds:YES];
        [customBackButton.layer setCornerRadius:8.0];
        [customBackButton setTitle:@"Back to previous screen" forState:UIControlStateNormal];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        UIBarButtonItem *backToMainMenu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(popCurrentViewController)];
        [backToMainMenu setAccessibilityLabel:@"Close"];
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        button1Frame = CGRectMake(84, 210, 600, 48);
        button2Frame = CGRectMake(84, 266, 600, 48);
        button3Frame = CGRectMake(84, 322, 600, 48);
        button4Frame = CGRectMake(84, 378, 600, 48);
        button5Frame = CGRectMake(84, 434, 600, 48);
        button6Frame = CGRectMake(84, 562, 600, 48);
        button7Frame = CGRectMake(84, 618, 600, 48);
        button8Frame = CGRectMake(84, 674, 600, 48);
    }
    else
    {
        // Change the standard NavigationController "Back" button to an "X"
        customBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [customBackButton setBackgroundColor:[UIColor redColor]];
//        [customBackButton setImage:[UIImage new] forState:UIControlStateNormal];
//        [customBackButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
        [customBackButton.layer setMasksToBounds:YES];
        [customBackButton.layer setCornerRadius:8.0];
        [customBackButton setTitle:@"Back to previous screen" forState:UIControlStateNormal];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        UIBarButtonItem *backToMainMenu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(popCurrentViewController)];
        [backToMainMenu setAccessibilityLabel:@"Close"];
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        button1Frame = CGRectMake(30, 65, 260, 44);
        button2Frame = CGRectMake(30, 116, 260, 44);
        button3Frame = CGRectMake(30, 167, 260, 44);
        button4Frame = CGRectMake(30, 218, 260, 44);
        button5Frame = CGRectMake(30, 269, 260, 44);
        button6Frame = CGRectMake(30, 320, 260, 44);
    }
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1.0];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"textured-Bar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0]];
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], UITextAttributeTextColor, nil]];
//  Deprecation replacement
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];

    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        headerFrame = CGRectMake(0, 0, [self.view frame].size.width, 100);
        subHeaderFrame = CGRectMake(0, 100, [self.view frame].size.width, 50);
    }
    else
    {
        headerFrame = CGRectMake(0, 0, [self.view frame].size.height, 100);
        subHeaderFrame = CGRectMake(0, 100, [self.view frame].size.height, 50);
    }
    headerLabel = [[UILabel alloc] initWithFrame:headerFrame];
    headerLabel.backgroundColor = [[UIColor alloc] initWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:0.0];
    [headerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [headerLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:56.0]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setText:@"StatCalc"];
    
    subHeaderLabel = [[UILabel alloc] initWithFrame:subHeaderFrame];
    subHeaderLabel.backgroundColor = [UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:0.0];
    [subHeaderLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [subHeaderLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:28]];
    [subHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [subHeaderLabel setText:@"Statistical Calculators from Epi Info"];
    
    buttonBox = [[UIView alloc] initWithFrame:CGRectMake(74, 200, 620, 292)];
    buttonBox.backgroundColor = [UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0];
    [buttonBox.layer setCornerRadius:12.0];
    buttonWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(76, 202, 616, 288)];
    buttonWhiteBox.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [buttonWhiteBox.layer setCornerRadius:10.0];
    
    powerBox = [[UIView alloc] initWithFrame:CGRectMake(74, 552, 620, 180)];
    powerBox.backgroundColor = [UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0];
    [powerBox.layer setCornerRadius:12.0];
    powerWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(76, 554, 616, 176)];
    powerWhiteBox.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [powerWhiteBox.layer setCornerRadius:10.0];
    
//    CGRect powerSectionHeaderFrame = CGRectMake(74, 522, 620, 30);
    powerSectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(74, 522 + 120, 620, 30)];
    [powerSectionHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [powerSectionHeaderLabel setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
    [powerSectionHeaderLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0]];
    [powerSectionHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [powerSectionHeaderLabel setText:@"Sample Size and Power"];
    
    CGRect cdcImageFrame = CGRectMake(2, [self.view frame].size.height - 146, (450.0 / 272.0) * 100.0, 100.0);
    cdcImageView = [[UIImageView alloc] initWithFrame:cdcImageFrame];
    
    // Convert color image to black and white
    UIImage *cdcImage = [UIImage imageNamed:@"CDCLogo.jpeg"];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef contextRef = CGBitmapContextCreate(nil, cdcImage.size.width, cdcImage.size.height, 8, cdcImage.size.width, colorSpace, kCGImageAlphaNone);
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    CGContextSetShouldAntialias(contextRef, NO);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cdcImage.size.width, cdcImage.size.height), [cdcImage CGImage]);
    CGImageRef bwImage = CGBitmapContextCreateImage(contextRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    UIImage *bwCDCImage = [UIImage imageWithCGImage:bwImage];
    CGImageRelease(bwImage);
    
    [cdcImageView setImage:bwCDCImage];
    [cdcImageView setAlpha:0.2];
    
    CGRect hhsImageFrame = CGRectMake(-2.0 - (300.0 / 293.0) * 100.0 + [self.view frame].size.width, [self.view frame].size.height - 146, (300.0 / 293.0) * 100.0, 100.0);
    hhsImageView = [[UIImageView alloc] initWithFrame:hhsImageFrame];
    UIImage *hhsImage = [UIImage imageNamed:@"HHSLogo.jpeg"];
    [hhsImageView setImage:hhsImage];
    [hhsImageView setAlpha:0.2];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [cdcImageView setImage:nil];
        [hhsImageView setImage:nil];
    }
    
//        Commented lines in this if-block were used to create a background image.
//    UIView *viewToSave = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
//    UIView *background = [[UIView alloc] initWithFrame:viewToSave.frame];
//    [background setBackgroundColor:[UIColor whiteColor]];
//    [viewToSave addSubview:background];
//    for (float i = 0.0; i < [self.view frame].size.height; i += 1.0)
//    {
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i, [self.view frame].size.width, 1)];
//        lineView.backgroundColor = [[UIColor alloc] initWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0 - i / [self.view frame].size.height];
//        [viewToSave addSubview:lineView];
//    }
//    UIGraphicsBeginImageContext(viewToSave.bounds.size);
//    [viewToSave.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *imageToSave = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSData *imageData = UIImagePNGRepresentation(imageToSave);
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/FadeDownS.png" atomically:YES];
//        To here
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        {
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
                fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - 600)];
            else
                fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.height, [self.view frame].size.width - 300)];
            [fadingColorView setImage:[UIImage imageNamed:@"FadeDown.png"]];
        }
        else
        {
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
                fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            else
                fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.height, [self.view frame].size.width)];
            [fadingColorView setImage:[UIImage imageNamed:@"iPadBackgroundWhite.png"]];
        }
        
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        [self.view addSubview:headerLabel];
        [self.view addSubview:subHeaderLabel];
        [self.view addSubview:buttonBox];
        [self.view addSubview:buttonWhiteBox];
        [self.view sendSubviewToBack:buttonWhiteBox];
        [self.view sendSubviewToBack:buttonBox];
        [self.view addSubview:powerBox];
        [self.view addSubview:powerWhiteBox];
        [self.view sendSubviewToBack:powerWhiteBox];
        [self.view sendSubviewToBack:powerBox];
        [self.view addSubview:powerSectionHeaderLabel];
        [self.view addSubview:cdcImageView];
        [self.view addSubview:hhsImageView];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.button1 setBackgroundColor:[UIColor whiteColor]];
            [self.button1.layer setCornerRadius:10.0];
            [self.button1.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button2 setBackgroundColor:[UIColor whiteColor]];
            [self.button2.layer setCornerRadius:10.0];
            [self.button2.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button3 setBackgroundColor:[UIColor whiteColor]];
            [self.button3.layer setCornerRadius:10.0];
            [self.button3.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button4 setBackgroundColor:[UIColor whiteColor]];
            [self.button4.layer setCornerRadius:10.0];
            [self.button4.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button5 setBackgroundColor:[UIColor whiteColor]];
            [self.button5.layer setCornerRadius:10.0];
            [self.button5.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button6 setBackgroundColor:[UIColor whiteColor]];
            [self.button6.layer setCornerRadius:10.0];
            [self.button6.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            
            blurryView = [BlurryView new];
//            [blurryView setFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y, button1Frame.size.width + 40, button6Frame.origin.y - button1Frame.origin.y + button6Frame.size.height + 40)];
//            [self.view addSubview:blurryView];
//            [blurryView setBlurTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
//            [blurryView setBlurTintColor:[UIColor clearColor]];
//            [blurryView.layer setCornerRadius:40.0];
            
            UIView *unblurryView = [[UIView alloc] initWithFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y, button1Frame.size.width + 40, button6Frame.origin.y - button1Frame.origin.y + button6Frame.size.height + 40)];
            [unblurryView setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:unblurryView];
            
            v1 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800), sqrtf(800), 76, 106)];
            v3 = [[UIView alloc] initWithFrame:CGRectMake(unblurryView.frame.size.width - sqrtf(800) - 76, sqrtf(800), 76, 106)];
            v2 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800) + 76 + (v3.frame.origin.x - (sqrtf(800) + 76)) / 2.0 - 76 / 2.0, sqrtf(800), 76, 106)];
            v4 = [[UIView alloc] initWithFrame:CGRectMake((v1.frame.origin.x + v1.frame.size.width) + (v2.frame.origin.x - (v1.frame.origin.x + v1.frame.size.width)) / 2.0 - 76.0 / 2.0, sqrtf(800) + 120, 76, 106)];
            v5 = [[UIView alloc] initWithFrame:CGRectMake((v2.frame.origin.x + v2.frame.size.width) + (v3.frame.origin.x - (v2.frame.origin.x + v2.frame.size.width)) / 2.0 - 76.0 / 2.0, sqrtf(800) + 120, 76, 106)];
            v6 = [[UIView alloc] initWithFrame:CGRectMake(v1.frame.origin.x, sqrtf(800), 76, 106)];
            UIView *v7 = [[UIView alloc] initWithFrame:CGRectMake(v2.frame.origin.x, sqrtf(800), 76, 106)];
            UIView *v8 = [[UIView alloc] initWithFrame:CGRectMake(v3.frame.origin.x, sqrtf(800), 76, 106)];
            UIView *v10 = [[UIView alloc] initWithFrame:CGRectMake(v7.frame.origin.x, v4.frame.origin.y + 120, 76, 106)];
            
            [v1 setBackgroundColor:[UIColor clearColor]];
            [v2 setBackgroundColor:[UIColor clearColor]];
            [v3 setBackgroundColor:[UIColor clearColor]];
            [v4 setBackgroundColor:[UIColor clearColor]];
            [v5 setBackgroundColor:[UIColor clearColor]];
            [v6 setBackgroundColor:[UIColor clearColor]];
            [v7 setBackgroundColor:[UIColor clearColor]];
            [v8 setBackgroundColor:[UIColor clearColor]];
            [v10 setBackgroundColor:[UIColor clearColor]];
            
            [unblurryView addSubview:v1];
            [unblurryView addSubview:v2];
            [unblurryView addSubview:v3];
            [unblurryView addSubview:v4];
            [unblurryView addSubview:v5];
            [unblurryView addSubview:v10];
            
            [self.button1 setFrame:CGRectMake(0, 0, 76, 76)];
            [self.button2 setFrame:CGRectMake(0, 0, 76, 76)];
            [self.button3 setFrame:CGRectMake(0, 0, 76, 76)];
            [self.button4 setFrame:CGRectMake(0, 0, 76, 76)];
            [self.button5 setFrame:CGRectMake(0, 0, 76, 76)];
            [self.button6 setFrame:CGRectMake(0, 0, 76, 76)];
            [self.button7 setFrame:CGRectMake(0, 0, 76, 76)];
            [self.button8 setFrame:CGRectMake(0, 0, 76, 76)];
            [self.button10 setFrame:CGRectMake(0, 0, 76, 76)];
            
            [self.button1.layer setCornerRadius:10.0];
            [self.button2.layer setCornerRadius:10.0];
            [self.button3.layer setCornerRadius:10.0];
            [self.button4.layer setCornerRadius:10.0];
            [self.button5.layer setCornerRadius:10.0];
            [self.button6.layer setCornerRadius:10.0];
            [self.button7.layer setCornerRadius:10.0];
            [self.button8.layer setCornerRadius:10.0];
            [self.button10.layer setCornerRadius:10.0];
            
            if ([[UIScreen mainScreen] scale] > 1.0)
            {
//                [self.button1 setBackgroundImage:[UIImage imageNamed:@"2x2_icon.png"] forState:UIControlStateNormal];
//                [self.button2 setBackgroundImage:[UIImage imageNamed:@"PMCC.png"] forState:UIControlStateNormal];
//                [self.button3 setBackgroundImage:[UIImage imageNamed:@"ChiSquare.png"] forState:UIControlStateNormal];
//                [self.button4 setBackgroundImage:[UIImage imageNamed:@"Poisson.png"] forState:UIControlStateNormal];
//                [self.button5 setBackgroundImage:[UIImage imageNamed:@"Binomial.png"] forState:UIControlStateNormal];
//                [self.button8 setBackgroundImage:[UIImage imageNamed:@"PopulationSS.png"] forState:UIControlStateNormal];
//                [self.button7 setBackgroundImage:[UIImage imageNamed:@"Cohort.png"] forState:UIControlStateNormal];
//                [self.button6 setBackgroundImage:[UIImage imageNamed:@"CaseControl.png"] forState:UIControlStateNormal];
//                [self.button10 setBackgroundImage:[UIImage imageNamed:@"GrowthButton.png"] forState:UIControlStateNormal];
                [self.button1 setBackgroundImage:[UIImage imageNamed:@"2x2_icon_6+.png"] forState:UIControlStateNormal];
                [self.button2 setBackgroundImage:[UIImage imageNamed:@"matched_pair_case_control_6+.png"] forState:UIControlStateNormal];
                [self.button3 setBackgroundImage:[UIImage imageNamed:@"chi_squared_icon_6+.png"] forState:UIControlStateNormal];
                [self.button4 setBackgroundImage:[UIImage imageNamed:@"poisson_icon_6+.png"] forState:UIControlStateNormal];
                [self.button5 setBackgroundImage:[UIImage imageNamed:@"binomial_icon_6+.png"] forState:UIControlStateNormal];
                [self.button8 setBackgroundImage:[UIImage imageNamed:@"population_survey_icon_blue_6+.png"] forState:UIControlStateNormal];
                [self.button7 setBackgroundImage:[UIImage imageNamed:@"cohort_icon_blue_6+.png"] forState:UIControlStateNormal];
                [self.button6 setBackgroundImage:[UIImage imageNamed:@"case_control_icon_blue_6+.png"] forState:UIControlStateNormal];
                [self.button10 setBackgroundImage:[UIImage imageNamed:@"growth_percentiles_icon_6+.png"] forState:UIControlStateNormal];
            }
            else
            {
//                [self.button1 setBackgroundImage:[UIImage imageNamed:@"2x2NR.png"] forState:UIControlStateNormal];
//                [self.button2 setBackgroundImage:[UIImage imageNamed:@"PMCCNR.png"] forState:UIControlStateNormal];
//                [self.button3 setBackgroundImage:[UIImage imageNamed:@"ChiSquareNR.png"] forState:UIControlStateNormal];
//                [self.button4 setBackgroundImage:[UIImage imageNamed:@"PoissonNR.png"] forState:UIControlStateNormal];
//                [self.button5 setBackgroundImage:[UIImage imageNamed:@"BinomialNR.png"] forState:UIControlStateNormal];
//                [self.button8 setBackgroundImage:[UIImage imageNamed:@"PopulationSSNR.png"] forState:UIControlStateNormal];
//                [self.button7 setBackgroundImage:[UIImage imageNamed:@"CohortNR.png"] forState:UIControlStateNormal];
//                [self.button6 setBackgroundImage:[UIImage imageNamed:@"CaseControlNR.png"] forState:UIControlStateNormal];
//                [self.button10 setBackgroundImage:[UIImage imageNamed:@"GrowthButtonNR.png"] forState:UIControlStateNormal];
                [self.button1 setBackgroundImage:[UIImage imageNamed:@"2x2_icon_6+.png"] forState:UIControlStateNormal];
                [self.button2 setBackgroundImage:[UIImage imageNamed:@"matched_pair_case_control_6+.png"] forState:UIControlStateNormal];
                [self.button3 setBackgroundImage:[UIImage imageNamed:@"chi_squared_icon_6+.png"] forState:UIControlStateNormal];
                [self.button4 setBackgroundImage:[UIImage imageNamed:@"poisson_icon_6+.png"] forState:UIControlStateNormal];
                [self.button5 setBackgroundImage:[UIImage imageNamed:@"binomial_icon_6+.png"] forState:UIControlStateNormal];
                [self.button8 setBackgroundImage:[UIImage imageNamed:@"population_survey_icon_blue_6+.png"] forState:UIControlStateNormal];
                [self.button7 setBackgroundImage:[UIImage imageNamed:@"cohort_icon_blue_6+.png"] forState:UIControlStateNormal];
                [self.button6 setBackgroundImage:[UIImage imageNamed:@"case_control_icon_blue_6+.png"] forState:UIControlStateNormal];
                [self.button10 setBackgroundImage:[UIImage imageNamed:@"growth_percentiles_icon_6+.png"] forState:UIControlStateNormal];
            }
            
            [self.button1 setClipsToBounds:YES];
            [self.button2 setClipsToBounds:YES];
            [self.button3 setClipsToBounds:YES];
            [self.button4 setClipsToBounds:YES];
            [self.button5 setClipsToBounds:YES];
            [self.button6 setClipsToBounds:YES];
            [self.button7 setClipsToBounds:YES];
            [self.button8 setClipsToBounds:YES];
            [self.button10 setClipsToBounds:YES];
            
            [self.button1 setBackgroundColor:[UIColor clearColor]];
            [self.button2 setBackgroundColor:[UIColor clearColor]];
            [self.button3 setBackgroundColor:[UIColor clearColor]];
            [self.button4 setBackgroundColor:[UIColor clearColor]];
            [self.button5 setBackgroundColor:[UIColor clearColor]];
            [self.button6 setBackgroundColor:[UIColor clearColor]];
            [self.button7 setBackgroundColor:[UIColor clearColor]];
            [self.button8 setBackgroundColor:[UIColor clearColor]];
            [self.button10 setBackgroundColor:[UIColor clearColor]];
            
            [self.button1 setTitle:@"Two by two by in tables" forState:UIControlStateNormal];
            [self.button2 setTitle:@"Pair matched case control table" forState:UIControlStateNormal];
            [self.button3 setTitle:@"Ky square for trend" forState:UIControlStateNormal];
            [self.button4 setTitle:@"Poisson" forState:UIControlStateNormal];
            [self.button5 setTitle:@"Binomial" forState:UIControlStateNormal];
            [self.button8 setTitle:@"Population survey" forState:UIControlStateNormal];
            [self.button7 setTitle:@"Cohort or cross sectional study" forState:UIControlStateNormal];
            [self.button6 setTitle:@"Unmatched case control study" forState:UIControlStateNormal];
            [self.button10 setTitle:@"Child growth percentiles" forState:UIControlStateNormal];
            
            [self.button1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button3 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button4 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button5 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button6 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button7 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button8 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button10 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            
            [v1 addSubview:self.button1];
            [v2 addSubview:self.button2];
            [v3 addSubview:self.button3];
            [v4 addSubview:self.button4];
            [v5 addSubview:self.button5];
            [v6 addSubview:self.button8];
            [v7 addSubview:self.button7];
            [v8 addSubview:self.button6];
            [v10 addSubview:self.button10];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 76, 16)];
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(-13, 80, 102, 16)];
            UILabel *label2b = [[UILabel alloc] initWithFrame:CGRectMake(-14, 96, 104, 16)];
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(-2, 80, 80, 16)];
            UILabel *label3b = [[UILabel alloc] initWithFrame:CGRectMake(0, 96, 76, 16)];
            UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 76, 16)];
            UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 76, 16)];
            UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(-4, 80, 84, 16)];
            UILabel *label6b = [[UILabel alloc] initWithFrame:CGRectMake(0, 96, 76, 16)];
            UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 76, 16)];
            UILabel *label7b = [[UILabel alloc] initWithFrame:CGRectMake(-24, 96, 124, 16)];
            UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(-8, 80, 92, 16)];
            UILabel *label8b = [[UILabel alloc] initWithFrame:CGRectMake(-12, 96, 100, 16)];
            UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 76, 16)];
            UILabel *label10b = [[UILabel alloc] initWithFrame:CGRectMake(-6, 96, 88, 16)];
            
            [label1 setBackgroundColor:[UIColor clearColor]];
            [label2 setBackgroundColor:[UIColor clearColor]];
            [label2b setBackgroundColor:[UIColor clearColor]];
            [label3 setBackgroundColor:[UIColor clearColor]];
            [label3b setBackgroundColor:[UIColor clearColor]];
            [label4 setBackgroundColor:[UIColor clearColor]];
            [label5 setBackgroundColor:[UIColor clearColor]];
            [label6 setBackgroundColor:[UIColor clearColor]];
            [label6b setBackgroundColor:[UIColor clearColor]];
            [label7 setBackgroundColor:[UIColor clearColor]];
            [label7b setBackgroundColor:[UIColor clearColor]];
            [label8 setBackgroundColor:[UIColor clearColor]];
            [label8b setBackgroundColor:[UIColor clearColor]];
            [label10 setBackgroundColor:[UIColor clearColor]];
            [label10b setBackgroundColor:[UIColor clearColor]];
            
            [label1 setText:@"2x2xn"];
            [label2 setText:@"Matched Pair"];
            [label2b setText:@"Case Control"];
            [label3 setText:@"ChiSquare"];
            [label3b setText:@"For Trend"];
            [label4 setText:@"Poisson"];
            [label5 setText:@"Binomial"];
            [label6 setText:@"Population"];
            [label6b setText:@"Survey"];
            [label7 setText:@"Cohort or"];
            [label7b setText:@"Cross Sectional"];
            [label8 setText:@"Unmatched"];
            [label8b setText:@"Case Control"];
            [label10 setText:@"Growth"];
            [label10b setText:@"Percentiles"];
            
            [label1 setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label2 setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label2b setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label3 setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label3b setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label4 setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label5 setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label6 setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label6b setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label7 setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label7b setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label8 setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label8b setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label10 setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [label10b setTextColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label2 setTextAlignment:NSTextAlignmentCenter];
            [label2b setTextAlignment:NSTextAlignmentCenter];
            [label3 setTextAlignment:NSTextAlignmentCenter];
            [label3b setTextAlignment:NSTextAlignmentCenter];
            [label4 setTextAlignment:NSTextAlignmentCenter];
            [label5 setTextAlignment:NSTextAlignmentCenter];
            [label6 setTextAlignment:NSTextAlignmentCenter];
            [label6b setTextAlignment:NSTextAlignmentCenter];
            [label7 setTextAlignment:NSTextAlignmentCenter];
            [label7b setTextAlignment:NSTextAlignmentCenter];
            [label8 setTextAlignment:NSTextAlignmentCenter];
            [label8b setTextAlignment:NSTextAlignmentCenter];
            [label10 setTextAlignment:NSTextAlignmentCenter];
            [label10b setTextAlignment:NSTextAlignmentCenter];
            
            [label1 setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label2 setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label2b setFont:[UIFont boldSystemFontOfSize:17.0]];
            [label3 setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label3b setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label4 setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label5 setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label6 setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label6b setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label7 setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label7b setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label8 setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label8b setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label10 setFont:[UIFont boldSystemFontOfSize:16.0]];
            [label10b setFont:[UIFont boldSystemFontOfSize:16.0]];
            
            [v1 addSubview:label1];
            [v2 addSubview:label2];
            [v2 addSubview:label2b];
            [v3 addSubview:label3];
            [v3 addSubview:label3b];
            [v4 addSubview:label4];
            [v5 addSubview:label5];
            [v6 addSubview:label6];
            [v6 addSubview:label6b];
            [v7 addSubview:label7];
            [v7 addSubview:label7b];
            [v8 addSubview:label8];
            [v8 addSubview:label8b];
            [v10 addSubview:label10];
            [v10 addSubview:label10b];
            
            [unblurryView setFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y, button1Frame.size.width + 40, v5.frame.origin.y + v5.frame.size.height + sqrtf(800) + 120)];
            
            [blurryView setFrame:CGRectMake(0, v5.frame.origin.y + v5.frame.size.height + 140, unblurryView.frame.size.width, 2)];
            [blurryView setBlurTintColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:0.6]];
            [blurryView.layer setCornerRadius:0.9];
            [unblurryView addSubview:blurryView];
            [unblurryView bringSubviewToFront:blurryView];
            
//            blurryView2 = [BlurryView new];
//            [blurryView2 setFrame:CGRectMake(blurryView.frame.origin.x, powerBox.frame.origin.y, blurryView.frame.size.width, v6.frame.origin.y + v6.frame.size.height + sqrtf(800))];
//            [self.view addSubview:blurryView2];
//            [blurryView2 setBlurTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
//            [blurryView2 setBlurTintColor:[UIColor clearColor]];
//            [blurryView2.layer setCornerRadius:40.0];
            
            UIView *unblurryView2 = [[UIView alloc] initWithFrame:CGRectMake(unblurryView.frame.origin.x, powerBox.frame.origin.y + 120, unblurryView.frame.size.width, v6.frame.origin.y + v6.frame.size.height + sqrtf(800))];
            [unblurryView2 setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:unblurryView2];

            [unblurryView2 addSubview:v6];
            [unblurryView2 addSubview:v7];
            [unblurryView2 addSubview:v8];
            
            [buttonBox setBackgroundColor:[UIColor clearColor]];
            [buttonWhiteBox setBackgroundColor:[UIColor clearColor]];
            [powerBox setBackgroundColor:[UIColor clearColor]];
            [powerWhiteBox setBackgroundColor:[UIColor clearColor]];
        }
    }
    else
    {
        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
        if (self.view.frame.size.height > 500)
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5BackgroundWhite.png"]];
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4BackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        [self.view addSubview:cdcImageView];
        [self.view addSubview:hhsImageView];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
                [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.button1 setBackgroundColor:[UIColor whiteColor]];
            [self.button1.layer setCornerRadius:10.0];
            [self.button1.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button2 setBackgroundColor:[UIColor whiteColor]];
            [self.button2.layer setCornerRadius:10.0];
            [self.button2.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button3 setBackgroundColor:[UIColor whiteColor]];
            [self.button3.layer setCornerRadius:10.0];
            [self.button3.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button4 setBackgroundColor:[UIColor whiteColor]];
            [self.button4.layer setCornerRadius:10.0];
            [self.button4.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button5 setBackgroundColor:[UIColor whiteColor]];
            [self.button5.layer setCornerRadius:10.0];
            [self.button5.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button6 setBackgroundColor:[UIColor whiteColor]];
            [self.button6.layer setCornerRadius:10.0];
            [self.button6.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button7 setHidden:NO];
            [self.button7 setBackgroundColor:[UIColor whiteColor]];
            [self.button7.layer setCornerRadius:10.0];
            [self.button7.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button8 setHidden:NO];
            [self.button8 setBackgroundColor:[UIColor whiteColor]];
            [self.button8.layer setCornerRadius:10.0];
            [self.button8.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button9 setHidden:NO];
            [self.button9 setBackgroundColor:[UIColor whiteColor]];
            [self.button9.layer setCornerRadius:10.0];
            [self.button9.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.button10 setBackgroundColor:[UIColor whiteColor]];
            [self.button10.layer setCornerRadius:10.0];
            [self.button10.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            
            [self.phoneHeaderLabel setTextColor:[UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1.0]];
            
            blurryView = [BlurryView new];
            [blurryView setFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y, button1Frame.size.width + 40, button6Frame.origin.y - button1Frame.origin.y + button6Frame.size.height + 120 + 40)];
//            [self.view addSubview:blurryView];
//            [blurryView setBlurTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
//            [blurryView setBlurTintColor:[UIColor colorWithRed:31/255.0 green:112/255.0 blue:255/255.0 alpha:1.0]];
//            [blurryView setBlurTintColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
//            [blurryView setBlurTintColor:[UIColor clearColor]];
//            [blurryView.layer setCornerRadius:40.0];
            
            UIView *unblurryView = [[UIView alloc] initWithFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y, button1Frame.size.width + 40, button6Frame.origin.y - button1Frame.origin.y + button6Frame.size.height + 120 + 40)];
            [unblurryView setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:unblurryView];
            
            v1 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800), sqrtf(800), 60, 90)];
            v3 = [[UIView alloc] initWithFrame:CGRectMake(blurryView.frame.size.width - sqrtf(800) - 60, sqrtf(800), 60, 90)];
            v2 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800) + 60 + (v3.frame.origin.x - (sqrtf(800) + 60)) / 2.0 - 60 / 2.0, sqrtf(800), 60, 90)];
//            v4 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800), sqrtf(800) + 110, 60, 90)];
            v4 = [[UIView alloc] initWithFrame:v3.frame];
            v5 = [[UIView alloc] initWithFrame:CGRectMake(v1.frame.origin.x, sqrtf(800) + 110, 60, 90)];
//            v5 = [[UIView alloc] initWithFrame:CGRectMake(v1.frame.origin.x + v1.frame.size.width + (v2.frame.origin.x - (v1.frame.origin.x + v1.frame.size.width)) / 2.0 - 30.0, sqrtf(800) + 110, 60, 90)];
//            v6 = [[UIView alloc] initWithFrame:CGRectMake(v2.frame.origin.x + v2.frame.size.width + (v4.frame.origin.x - (v2.frame.origin.x + v2.frame.size.width)) / 2.0 - 30.0, sqrtf(800) + 110, 60, 90)];
            v6 = [[UIView alloc] initWithFrame:CGRectMake(v2.frame.origin.x, v5.frame.origin.y, 60, 90)];
            UIView *v7 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800), sqrtf(800) + 240, 60, 90)];
            UIView *v8 = [[UIView alloc] initWithFrame:CGRectMake(v2.frame.origin.x, sqrtf(800) + 240, 60, 90)];
            UIView *v9 = [[UIView alloc] initWithFrame:CGRectMake(v3.frame.origin.x, sqrtf(800) + 240, 60, 90)];
//            UIView *v10 = [[UIView alloc] initWithFrame:CGRectMake(v6.frame.origin.x + 62, v6.frame.origin.y, 60, 90)];
            UIView *v10 = [[UIView alloc] initWithFrame:CGRectMake(v4.frame.origin.x, v6.frame.origin.y, 60, 90)];

            [v1 setBackgroundColor:[UIColor clearColor]];
            [v2 setBackgroundColor:[UIColor clearColor]];
            [v3 setBackgroundColor:[UIColor clearColor]];
            [v4 setBackgroundColor:[UIColor clearColor]];
            [v5 setBackgroundColor:[UIColor clearColor]];
            [v6 setBackgroundColor:[UIColor clearColor]];
            [v7 setBackgroundColor:[UIColor clearColor]];
            [v8 setBackgroundColor:[UIColor clearColor]];
            [v9 setBackgroundColor:[UIColor clearColor]];
            [v10 setBackgroundColor:[UIColor clearColor]];
            
            [unblurryView addSubview:v1];
            [unblurryView addSubview:v2];
//            [blurryView addSubview:v3];
            [unblurryView addSubview:v4];
            [unblurryView addSubview:v5];
            [unblurryView addSubview:v6];
            [unblurryView addSubview:v7];
            [unblurryView addSubview:v8];
            [unblurryView addSubview:v9];
            [unblurryView addSubview:v10];
            
            [self.button1 setFrame:CGRectMake(0, 0, 60, 60)];
            [self.button2 setFrame:CGRectMake(0, 0, 60, 60)];
            [self.button3 setFrame:CGRectMake(0, 0, 60, 60)];
            [self.button4 setFrame:CGRectMake(0, 0, 60, 60)];
            [self.button5 setFrame:CGRectMake(0, 0, 60, 60)];
            [self.button6 setFrame:CGRectMake(0, 0, 60, 60)];
            [self.button7 setFrame:CGRectMake(0, 0, 60, 60)];
            [self.button8 setFrame:CGRectMake(0, 0, 60, 60)];
            [self.button9 setFrame:CGRectMake(0, 0, 60, 60)];
            [self.button10 setFrame:CGRectMake(0, 0, 60, 60)];
            
            [self.button1.layer setCornerRadius:10.0];
            [self.button2.layer setCornerRadius:10.0];
            [self.button3.layer setCornerRadius:10.0];
            [self.button4.layer setCornerRadius:10.0];
            [self.button5.layer setCornerRadius:10.0];
            [self.button6.layer setCornerRadius:10.0];
            [self.button7.layer setCornerRadius:10.0];
            [self.button8.layer setCornerRadius:10.0];
            [self.button9.layer setCornerRadius:10.0];
            [self.button10.layer setCornerRadius:10.0];
            
            if ([[UIScreen mainScreen] scale] > 1.0)
            {
                [self.button1 setBackgroundImage:[UIImage imageNamed:@"2x2_icon.png"] forState:UIControlStateNormal];
                [self.button2 setBackgroundImage:[UIImage imageNamed:@"matched_pair_case_control.png"] forState:UIControlStateNormal];
                [self.button3 setBackgroundImage:[UIImage imageNamed:@"Power.png"] forState:UIControlStateNormal];
                [self.button4 setBackgroundImage:[UIImage imageNamed:@"chi_squared_icon.png"] forState:UIControlStateNormal];
                [self.button5 setBackgroundImage:[UIImage imageNamed:@"poisson_icon.png"] forState:UIControlStateNormal];
                [self.button6 setBackgroundImage:[UIImage imageNamed:@"binomial_icon.png"] forState:UIControlStateNormal];
                [self.button7 setBackgroundImage:[UIImage imageNamed:@"population_survey_icon_blue.png"] forState:UIControlStateNormal];
                [self.button8 setBackgroundImage:[UIImage imageNamed:@"cohort_icon_blue.png"] forState:UIControlStateNormal];
                [self.button9 setBackgroundImage:[UIImage imageNamed:@"case_control_icon_blue.png"] forState:UIControlStateNormal];
                [self.button10 setBackgroundImage:[UIImage imageNamed:@"growth_percentiles_icon.png"] forState:UIControlStateNormal];
            }
            else
            {
                [self.button1 setBackgroundImage:[UIImage imageNamed:@"2x2_icon.png"] forState:UIControlStateNormal];
                [self.button2 setBackgroundImage:[UIImage imageNamed:@"matched_pair_case_control.png"] forState:UIControlStateNormal];
                [self.button3 setBackgroundImage:[UIImage imageNamed:@"Power.png"] forState:UIControlStateNormal];
                [self.button4 setBackgroundImage:[UIImage imageNamed:@"chi_squared_icon.png"] forState:UIControlStateNormal];
                [self.button5 setBackgroundImage:[UIImage imageNamed:@"poisson_icon.png"] forState:UIControlStateNormal];
                [self.button6 setBackgroundImage:[UIImage imageNamed:@"binomial_icon.png"] forState:UIControlStateNormal];
                [self.button7 setBackgroundImage:[UIImage imageNamed:@"population_survey_icon_blue.png"] forState:UIControlStateNormal];
                [self.button8 setBackgroundImage:[UIImage imageNamed:@"cohort_icon_blue.png"] forState:UIControlStateNormal];
                [self.button9 setBackgroundImage:[UIImage imageNamed:@"case_control_icon_blue.png"] forState:UIControlStateNormal];
                [self.button10 setBackgroundImage:[UIImage imageNamed:@"GrowthButtonNR.png"] forState:UIControlStateNormal];
            }
            
            [self.button1 setClipsToBounds:YES];
            [self.button2 setClipsToBounds:YES];
            [self.button3 setClipsToBounds:YES];
            [self.button4 setClipsToBounds:YES];
            [self.button5 setClipsToBounds:YES];
            [self.button6 setClipsToBounds:YES];
            [self.button7 setClipsToBounds:YES];
            [self.button8 setClipsToBounds:YES];
            [self.button9 setClipsToBounds:YES];
            [self.button10 setClipsToBounds:YES];
            
            [self.button1 setBackgroundColor:[UIColor clearColor]];
            [self.button2 setBackgroundColor:[UIColor clearColor]];
            [self.button3 setBackgroundColor:[UIColor clearColor]];
            [self.button4 setBackgroundColor:[UIColor clearColor]];
            [self.button5 setBackgroundColor:[UIColor clearColor]];
            [self.button6 setBackgroundColor:[UIColor clearColor]];
            [self.button7 setBackgroundColor:[UIColor clearColor]];
            [self.button8 setBackgroundColor:[UIColor clearColor]];
            [self.button9 setBackgroundColor:[UIColor clearColor]];
            [self.button10 setBackgroundColor:[UIColor clearColor]];
            
            [self.button1 setTitle:@"Two by two by in tables" forState:UIControlStateNormal];
            [self.button2 setTitle:@"Pair matched case control table" forState:UIControlStateNormal];
            [self.button3 setTitle:@"Sample size and power" forState:UIControlStateNormal];
            [self.button4 setTitle:@"Ky square for trend" forState:UIControlStateNormal];
            [self.button5 setTitle:@"Poisson" forState:UIControlStateNormal];
            [self.button6 setTitle:@"Binomial" forState:UIControlStateNormal];
            [self.button7 setTitle:@"Population survey" forState:UIControlStateNormal];
            [self.button8 setTitle:@"Cohort or cross sectional" forState:UIControlStateNormal];
            [self.button9 setTitle:@"Unmatched case control" forState:UIControlStateNormal];
            [self.button10 setTitle:@"Child growth percentiles" forState:UIControlStateNormal];
            
            [self.button1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button3 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button4 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button5 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button6 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button7 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button8 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button9 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.button10 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            
            [v1 addSubview:self.button1];
            [v2 addSubview:self.button2];
            [v3 addSubview:self.button3];
            [v4 addSubview:self.button4];
            [v5 addSubview:self.button5];
            [v6 addSubview:self.button6];
            [v7 addSubview:self.button7];
            [v8 addSubview:self.button8];
            [v9 addSubview:self.button9];
            [v10 addSubview:self.button10];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 60, 12)];
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(-10, 64, 80, 12)];
            UILabel *label2b = [[UILabel alloc] initWithFrame:CGRectMake(-8, 76, 76, 12)];
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(-4, 64, 68, 12)];
            UILabel *label3b = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, 60, 12)];
            UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(-4, 64, 68, 12)];
            UILabel *label4b = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, 60, 12)];
            UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 60, 12)];
            UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 60, 12)];
            UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(-4, 64, 68, 12)];
            UILabel *label7b = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, 60, 12)];
            UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(-8, 64, 76, 12)];
            UILabel *label8b = [[UILabel alloc] initWithFrame:CGRectMake(-15, 76, 90, 12)];
            UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(-5, 64, 70, 12)];
            UILabel *label9b = [[UILabel alloc] initWithFrame:CGRectMake(-8, 76, 76, 12)];
            UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 60, 12)];
            UILabel *label10b = [[UILabel alloc] initWithFrame:CGRectMake(-4, 76, 68, 12)];
            
            [label1 setBackgroundColor:[UIColor clearColor]];
            [label2 setBackgroundColor:[UIColor clearColor]];
            [label2b setBackgroundColor:[UIColor clearColor]];
            [label3 setBackgroundColor:[UIColor clearColor]];
            [label3b setBackgroundColor:[UIColor clearColor]];
            [label4 setBackgroundColor:[UIColor clearColor]];
            [label4b setBackgroundColor:[UIColor clearColor]];
            [label5 setBackgroundColor:[UIColor clearColor]];
            [label6 setBackgroundColor:[UIColor clearColor]];
            [label7 setBackgroundColor:[UIColor clearColor]];
            [label7b setBackgroundColor:[UIColor clearColor]];
            [label8 setBackgroundColor:[UIColor clearColor]];
            [label8b setBackgroundColor:[UIColor clearColor]];
            [label9 setBackgroundColor:[UIColor clearColor]];
            [label9b setBackgroundColor:[UIColor clearColor]];
            [label10 setBackgroundColor:[UIColor clearColor]];
            [label10b setBackgroundColor:[UIColor clearColor]];
            
            [label1 setText:@"2x2xn"];
            [label2 setText:@"Matched Pair"];
            [label2b setText:@"CaseControl"];
            [label3 setText:@"Sample"];
            [label3b setText:@"Size"];
            [label4 setText:@"ChiSquare"];
            [label4b setText:@"For Trend"];
            [label5 setText:@"Poisson"];
            [label6 setText:@"Binomial"];
            [label7 setText:@"Population"];
            [label7b setText:@"Survey"];
            [label8 setText:@"Cohort or"];
            [label8b setText:@"CrossSectional"];
            [label9 setText:@"Unmatched"];
            [label9b setText:@"CaseControl"];
            [label10 setText:@"Growth"];
            [label10b setText:@"Percentiles"];
            
            [label1 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label2 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label2b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label3 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label3b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label4 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label4b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label5 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label6 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label7 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label7b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label8 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label8b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label9 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label9b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label10 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [label10b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label2 setTextAlignment:NSTextAlignmentCenter];
            [label2b setTextAlignment:NSTextAlignmentCenter];
            [label3 setTextAlignment:NSTextAlignmentCenter];
            [label3b setTextAlignment:NSTextAlignmentCenter];
            [label4 setTextAlignment:NSTextAlignmentCenter];
            [label4b setTextAlignment:NSTextAlignmentCenter];
            [label5 setTextAlignment:NSTextAlignmentCenter];
            [label6 setTextAlignment:NSTextAlignmentCenter];
            [label7 setTextAlignment:NSTextAlignmentCenter];
            [label7b setTextAlignment:NSTextAlignmentCenter];
            [label8 setTextAlignment:NSTextAlignmentCenter];
            [label8b setTextAlignment:NSTextAlignmentCenter];
            [label9 setTextAlignment:NSTextAlignmentCenter];
            [label9b setTextAlignment:NSTextAlignmentCenter];
            [label10 setTextAlignment:NSTextAlignmentCenter];
            [label10b setTextAlignment:NSTextAlignmentCenter];
            
            [label1 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label2 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label2b setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label3 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label3b setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label4 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label4b setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label5 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label6 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label7 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label7b setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label8 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label8b setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label9 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label9b setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label10 setFont:[UIFont boldSystemFontOfSize:12.0]];
            [label10b setFont:[UIFont boldSystemFontOfSize:12.0]];
            
            [v1 addSubview:label1];
            [v2 addSubview:label2];
            [v2 addSubview:label2b];
            [v3 addSubview:label3];
            [v3 addSubview:label3b];
            [v4 addSubview:label4];
            [v4 addSubview:label4b];
            [v5 addSubview:label5];
            [v6 addSubview:label6];
            [v7 addSubview:label7];
            [v7 addSubview:label7b];
            [v8 addSubview:label8];
            [v8 addSubview:label8b];
            [v9 addSubview:label9];
            [v9 addSubview:label9b];
            [v10 addSubview:label10];
            [v10 addSubview:label10b];
            
            [blurryView setFrame:CGRectMake(0, v6.frame.origin.y + v6.frame.size.height, unblurryView.frame.size.width, 2)];
            [blurryView setBlurTintColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:0.6]];
            [blurryView.layer setCornerRadius:0.9];
            [unblurryView addSubview:blurryView];
            [unblurryView bringSubviewToFront:blurryView];
            
            UILabel *sampSizePow = [[UILabel alloc] initWithFrame:CGRectMake(0, blurryView.frame.origin.y + 8, blurryView.frame.size.width, 24)];
            [sampSizePow setTextAlignment:NSTextAlignmentCenter];
            [sampSizePow setFont:[UIFont boldSystemFontOfSize:16]];
            [sampSizePow setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [sampSizePow setText:@"Sample Size and Power"];
            [unblurryView addSubview:sampSizePow];
            NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
            if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
            {
                [sampSizePow setText:@"El Tamaño de la Muestra y El Poder"];
            }

//            [blurryView setFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y, button1Frame.size.width + 40, v8.frame.origin.y + v8.frame.size.height + sqrtf(800))];
            [unblurryView setFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y - 30, button1Frame.size.width + 40, v8.frame.origin.y + v8.frame.size.height + sqrtf(800))];
        }
        [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
        [self.phoneHeaderLabel setCenter:CGPointMake([self.view frame].size.width / 2.0, 30.0)];
        [self.phoneHeaderLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    self.title = @"";
//    CGRect frame = CGRectMake(0, 0, [self.title sizeWithFont:[UIFont boldSystemFontOfSize:20.0]].width, 44);
    // Deprecation replacement
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    self.navigationItem.titleView = label;
    label.text = self.title;
    
    //Hide or don't hide the back button
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self.navigationItem setHidesBackButton:NO];
    else
        [self.navigationItem setHidesBackButton:NO];
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [self.phoneHeaderLabel setText:@"StatCalc Calculadora Estadística"];
        [subHeaderLabel setText:@"Calculadora Estadística"];
        [powerSectionHeaderLabel setText:@"El Tamaño de la Muestra y El Poder"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [headerLabel setCenter:CGPointMake([self.view frame].size.width / 2.0, 50.0)];
            [subHeaderLabel setCenter:CGPointMake([self.view frame].size.width / 2.0, 125.0)];
        }];
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - 600)];
            headerFrame = CGRectMake(0, 0, [self.view frame].size.width, 100);
            subHeaderFrame = CGRectMake(0, 100, [self.view frame].size.width, 50);
            [UIView animateWithDuration:0.3 animations:^{
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [self.button1 setFrame:button1Frame];
                    [self.button2 setFrame:button2Frame];
                    [self.button3 setFrame:button3Frame];
                    [self.button4 setFrame:button4Frame];
                    [self.button5 setFrame:button5Frame];
                    [self.button6 setFrame:button6Frame];
                    [self.button7 setFrame:button7Frame];
                    [self.button8 setFrame:button8Frame];
                    
                    [buttonBox setFrame:CGRectMake(74, 200, 620, 292)];
                    [buttonWhiteBox setFrame:CGRectMake(76, 202, 616, 288)];
                    [powerBox setFrame:CGRectMake(74, 552, 620, 180)];
                    [powerWhiteBox setFrame:CGRectMake(76, 554, 616, 176)];
                    [powerSectionHeaderLabel setFrame:CGRectMake(74, 522 + 120, 620, 30)];
                }
                else
                {
//                    [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
//                    [blurryView setFrame:CGRectMake(64, 210, 640, 282.568542)];
//                    [blurryView2 setFrame:CGRectMake(64, 552, 640, 162.568542)];
                    [powerSectionHeaderLabel setFrame:CGRectMake(74, 522 + 120, 620, 30)];
                }
                
                [cdcImageView setFrame:CGRectMake(2, self.navigationController.navigationBar.frame.size.height + [self.view frame].size.height - 146.0, (450.0 / 272.0) * 100.0, 100.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 100.0 + [self.view frame].size.width, self.navigationController.navigationBar.frame.size.height + [self.view frame].size.height - 146, (300.0 / 293.0) * 100.0, 100.0)];
            }];
        }
        else
        {
            float xPos = self.view.frame.size.width / 2.0 - 20.0 - (button1Frame.size.width - 120.0);
            button1LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 50.0, button1Frame.size.width - 120.0, button1Frame.size.height);
            button2LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 2.0 + 50.0 + button1LandscapeFrame.size.height, button1LandscapeFrame.size.width, button1Frame.size.height);
            button3LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 4.0 + 50.0 + 2.0 * button1LandscapeFrame.size.height, button1LandscapeFrame.size.width, button1Frame.size.height);
            button4LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 6.0 + 50.0 + 3.0 * button1LandscapeFrame.size.height, button1LandscapeFrame.size.width, button1Frame.size.height);
            button5LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 8.0 + 50.0 + 4.0 * button1LandscapeFrame.size.height, button1LandscapeFrame.size.width, button1Frame.size.height);
            button6LandscapeFrame = CGRectMake(self.view.frame.size.width / 2.0 + 20.0, button2LandscapeFrame.origin.y, button1LandscapeFrame.size.width, button1Frame.size.height);
            button7LandscapeFrame = CGRectMake(self.view.frame.size.width / 2.0 + 20.0, button3LandscapeFrame.origin.y, button1LandscapeFrame.size.width, button1Frame.size.height);
            button8LandscapeFrame = CGRectMake(self.view.frame.size.width / 2.0 + 20.0, button4LandscapeFrame.origin.y, button1LandscapeFrame.size.width, button1Frame.size.height);
            [UIView animateWithDuration:0.3 animations:^{
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - 300)];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [self.button1 setFrame:button1LandscapeFrame];
                    [self.button2 setFrame:button2LandscapeFrame];
                    [self.button3 setFrame:button3LandscapeFrame];
                    [self.button4 setFrame:button4LandscapeFrame];
                    [self.button5 setFrame:button5LandscapeFrame];
                    [self.button6 setFrame:button6LandscapeFrame];
                    [self.button7 setFrame:button7LandscapeFrame];
                    [self.button8 setFrame:button8LandscapeFrame];
                    
                    [buttonBox setFrame:CGRectMake(button1LandscapeFrame.origin.x - 10.0, button1LandscapeFrame.origin.y - 10.0, button1LandscapeFrame.size.width + 20.0, button1LandscapeFrame.size.height * 5.0 + 8.0 + 20.0)];
                    [buttonWhiteBox setFrame:CGRectMake(button1LandscapeFrame.origin.x - 8.0, button1LandscapeFrame.origin.y - 8.0, button1LandscapeFrame.size.width + 16.0, button1LandscapeFrame.size.height * 5.0 + 8.0 + 16.0)];
                    [powerBox setFrame:CGRectMake(button6LandscapeFrame.origin.x - 10.0, button6LandscapeFrame.origin.y - 10.0, button6LandscapeFrame.size.width + 20.0, button6LandscapeFrame.size.height * 3.0 + 4.0 + 20.0)];
                    [powerWhiteBox setFrame:CGRectMake(button6LandscapeFrame.origin.x - 8.0, button6LandscapeFrame.origin.y - 8.0, button6LandscapeFrame.size.width + 16.0, button6LandscapeFrame.size.height * 3.0 + 4.0 + 16.0)];
                    [powerSectionHeaderLabel setFrame:CGRectMake(powerBox.frame.origin.x, powerBox.frame.origin.y - 30.0, powerBox.frame.size.width, 30.0)];
                }
                else
                {
                    [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
                    [blurryView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 320, 170, 640, 282.568542)];
                    [blurryView2 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 320, 512, 640, 162.568542)];
                    [powerSectionHeaderLabel setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 320, 522 - 40, 640, powerSectionHeaderLabel.frame.size.height)];
                }
                
                [cdcImageView setFrame:CGRectMake(2, self.navigationController.navigationBar.frame.size.height + [self.view frame].size.height - 146, (450.0 / 272.0) * 100.0, 100.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 100.0 + [self.view frame].size.width, self.navigationController.navigationBar.frame.size.height + [self.view frame].size.height - 146, (300.0 / 293.0) * 100.0, 100.0)];
            }];
        }
    }
    
    else
    {
        [self.phoneHeaderLabel setCenter:CGPointMake([self.view frame].size.width / 2.0, 30.0)];
        [UIView animateWithDuration:0.3 animations:^{
//            [self.phoneHeaderLabel setCenter:CGPointMake([self.view frame].size.width / 2.0, 30.0)];
        }];
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [UIView animateWithDuration:0.3 animations:^{
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [self.button1 setFrame:button1Frame];
                    [self.button2 setFrame:button2Frame];
                    [self.button3 setFrame:button3Frame];
                    [self.button4 setFrame:button4Frame];
                    [self.button5 setFrame:button5Frame];
                    [self.button6 setFrame:button6Frame];
                    
                    [self.view bringSubviewToFront:self.button1];
                    [self.view bringSubviewToFront:self.button2];
                    [self.view bringSubviewToFront:self.button3];
                    [self.view bringSubviewToFront:self.button4];
                    [self.view bringSubviewToFront:self.button5];
                    [self.view bringSubviewToFront:self.button6];
                }
                
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
//                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.button1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 281.0, 60, 280, 44)];
                [self.button2 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 281.0, 111, 280, 44)];
                [self.button3 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 281.0, 162, 280, 44)];
                [self.button4 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 60, 280, 44)];
                [self.button5 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 111, 280, 44)];
                [self.button6 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 162, 280, 44)];
                if (self.view.frame.size.width < 2.0 * self.button1.frame.size.width)
                {
                    [self.button1 setFrame:CGRectMake(1.0, 60, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button2 setFrame:CGRectMake(1.0, 111, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button3 setFrame:CGRectMake(1.0, 162, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button4 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 60, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button5 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 111, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button6 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 162, self.view.frame.size.width / 2.0 - 2.0, 44)];
                }
                
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
    }
//    Commented lines were used to create a screenshot image.
//    UIView *tmpV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    
//    UIImageView *barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.navigationController.navigationBar.bounds.size.height)];
//    UIGraphicsBeginImageContext(self.navigationController.navigationBar.bounds.size);
//    [self.navigationController.navigationBar.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *bar = UIGraphicsGetImageFromCurrentImageContext();
//    [barView setImage:bar];
//    UIGraphicsEndImageContext();
//    
//    UIImageView *screenView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height + 40)];
//    UIGraphicsBeginImageContext(screenView.bounds.size);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screen = UIGraphicsGetImageFromCurrentImageContext();
//    [screenView setImage:screen];
//    UIGraphicsEndImageContext();
//    
//    [tmpV addSubview:barView];
//    [tmpV addSubview:screenView];
//    
//    UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + self.navigationController.navigationBar.bounds.size.height));
//    [tmpV.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *imageToSave = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSData *imageData = UIImagePNGRepresentation(imageToSave);
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/StatCalcPad.png" atomically:YES];
//    To here
}
//

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    frameOfButtonPressed = [[(UIButton *)sender superview] frame];
    buttonPressed = (UIButton *)sender;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([segue.identifier isEqualToString:@"Show2x2Calculator"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"2x2Screen5.png"];
            else
                [self setImageFileToUseInSegue:@"2x2Screen4.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowMatchedPairCalculator"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"PMCCScreen5.png"];
            else
                [self setImageFileToUseInSegue:@"PMCCScreen4.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowSampleSizeAndPower"])
        {
            [self setImageFileToUseInSegue:@"SampleSizeScreen.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowChiSquareForTrendCalculator"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"ChiSquareScreen5.png"];
            else
                [self setImageFileToUseInSegue:@"ChiSquareScreen4.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowPoissonCalculator"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"PoissonScreen5.png"];
            else
                [self setImageFileToUseInSegue:@"PoissonScreen4.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowBinomialCalculator"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"BinomialScreen5.png"];
            else
                [self setImageFileToUseInSegue:@"BinomialScreen4.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowPopulationSurvey"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"PopulationSSScreen5.png"];
            else
                [self setImageFileToUseInSegue:@"PopulationSSScreen4.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowCohortStudy"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"CohortSSScreen5.png"];
            else
                [self setImageFileToUseInSegue:@"CohortSSScreen4.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowUnmatchedCaseControlStudy"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"CaseControlSSScreen5.png"];
            else
                [self setImageFileToUseInSegue:@"CaseControlSSScreen4.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowGrowthPercentiles"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"GrowthPercentileScreen5.png"];
            else
                [self setImageFileToUseInSegue:@"GrowthPercentileScreen4.png"];
        }
    }
    else
    {
        if ([segue.identifier isEqualToString:@"Show2x2Calculator"])
        {
            [self setImageFileToUseInSegue:@"2x2ScreenPad.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowMatchedPairCalculator"])
        {
            [self setImageFileToUseInSegue:@"PMCCScreenPad.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowSampleSizeAndPower"])
        {
            [self setImageFileToUseInSegue:@"PadSampleSizeAndPowerScreenshot.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowChiSquareForTrendCalculator"])
        {
            [self setImageFileToUseInSegue:@"ChiSquareScreenPad.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowPoissonCalculator"])
        {
            [self setImageFileToUseInSegue:@"PoissonScreenPad.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowBinomialCalculator"])
        {
            [self setImageFileToUseInSegue:@"BinomialScreenPad.png"];
        }
        else if ([segue.identifier isEqualToString:@"ShowPopulationSurveyCalculator"])
        {
            [self setImageFileToUseInSegue:@"PopulationSSScreenPad"];
        }
        else if ([segue.identifier isEqualToString:@"ShowCohortCalculator"])
        {
            [self setImageFileToUseInSegue:@"CohortSSScreenPad"];
        }
        else if ([segue.identifier isEqualToString:@"ShowUnmatchedCaseControlCalculator"])
        {
            [self setImageFileToUseInSegue:@"CaseControlSSScreenPad"];
        }
        else if ([segue.identifier isEqualToString:@"ShowGrowthPercentiles"])
        {
            [self setImageFileToUseInSegue:@"GrowthPercentileScreenPad"];
        }
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currentOrientationPortrait = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [headerLabel setCenter:CGPointMake([self.view frame].size.width / 2.0, 50.0)];
            [subHeaderLabel setCenter:CGPointMake([self.view frame].size.width / 2.0, 125.0)];
        }];
        if (currentOrientationPortrait)
        {
            [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - 600)];
            headerFrame = CGRectMake(0, 0, [self.view frame].size.width, 100);
            subHeaderFrame = CGRectMake(0, 100, [self.view frame].size.width, 50);
            [UIView animateWithDuration:0.3 animations:^{
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [self.button1 setFrame:button1Frame];
                    [self.button2 setFrame:button2Frame];
                    [self.button3 setFrame:button3Frame];
                    [self.button4 setFrame:button4Frame];
                    [self.button5 setFrame:button5Frame];
                    [self.button6 setFrame:button6Frame];
                    [self.button7 setFrame:button7Frame];
                    [self.button8 setFrame:button8Frame];
                    
                    [buttonBox setFrame:CGRectMake(74, 200, 620, 292)];
                    [buttonWhiteBox setFrame:CGRectMake(76, 202, 616, 288)];
                    [powerBox setFrame:CGRectMake(74, 552, 620, 180)];
                    [powerWhiteBox setFrame:CGRectMake(76, 554, 616, 176)];
                    [powerSectionHeaderLabel setFrame:CGRectMake(74, 522 + 120, 620, 30)];
                }
                else
                {
                    [blurryView setFrame:CGRectMake(64, 210, 640, 282.568542)];
                    [blurryView2 setFrame:CGRectMake(64, 552, 640, 162.568542)];
                    [powerSectionHeaderLabel setFrame:CGRectMake(74, 522 + 120, 620, 30)];
                }
                
                [cdcImageView setFrame:CGRectMake(2, self.navigationController.navigationBar.frame.size.height + [self.view frame].size.height - 146.0, (450.0 / 272.0) * 100.0, 100.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 100.0 + [self.view frame].size.width, self.navigationController.navigationBar.frame.size.height + [self.view frame].size.height - 146, (300.0 / 293.0) * 100.0, 100.0)];
            }];
        }
        else
        {
            float xPos = self.view.frame.size.width / 2.0 - 20.0 - (button1Frame.size.width - 120.0);
            button1LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 50.0, button1Frame.size.width - 120.0, button1Frame.size.height);
            button2LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 2.0 + 50.0 + button1LandscapeFrame.size.height, button1LandscapeFrame.size.width, button1Frame.size.height);
            button3LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 4.0 + 50.0 + 2.0 * button1LandscapeFrame.size.height, button1LandscapeFrame.size.width, button1Frame.size.height);
            button4LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 6.0 + 50.0 + 3.0 * button1LandscapeFrame.size.height, button1LandscapeFrame.size.width, button1Frame.size.height);
            button5LandscapeFrame = CGRectMake(xPos, subHeaderLabel.frame.origin.y + subHeaderLabel.frame.size.height + 8.0 + 50.0 + 4.0 * button1LandscapeFrame.size.height, button1LandscapeFrame.size.width, button1Frame.size.height);
            button6LandscapeFrame = CGRectMake(self.view.frame.size.width / 2.0 + 20.0, button2LandscapeFrame.origin.y, button1LandscapeFrame.size.width, button1Frame.size.height);
            button7LandscapeFrame = CGRectMake(self.view.frame.size.width / 2.0 + 20.0, button3LandscapeFrame.origin.y, button1LandscapeFrame.size.width, button1Frame.size.height);
            button8LandscapeFrame = CGRectMake(self.view.frame.size.width / 2.0 + 20.0, button4LandscapeFrame.origin.y, button1LandscapeFrame.size.width, button1Frame.size.height);
            [UIView animateWithDuration:0.3 animations:^{
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - 300)];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [self.button1 setFrame:button1LandscapeFrame];
                    [self.button2 setFrame:button2LandscapeFrame];
                    [self.button3 setFrame:button3LandscapeFrame];
                    [self.button4 setFrame:button4LandscapeFrame];
                    [self.button5 setFrame:button5LandscapeFrame];
                    [self.button6 setFrame:button6LandscapeFrame];
                    [self.button7 setFrame:button7LandscapeFrame];
                    [self.button8 setFrame:button8LandscapeFrame];
                    
                    [buttonBox setFrame:CGRectMake(button1LandscapeFrame.origin.x - 10.0, button1LandscapeFrame.origin.y - 10.0, button1LandscapeFrame.size.width + 20.0, button1LandscapeFrame.size.height * 5.0 + 8.0 + 20.0)];
                    [buttonWhiteBox setFrame:CGRectMake(button1LandscapeFrame.origin.x - 8.0, button1LandscapeFrame.origin.y - 8.0, button1LandscapeFrame.size.width + 16.0, button1LandscapeFrame.size.height * 5.0 + 8.0 + 16.0)];
                    [powerBox setFrame:CGRectMake(button6LandscapeFrame.origin.x - 10.0, button6LandscapeFrame.origin.y - 10.0, button6LandscapeFrame.size.width + 20.0, button6LandscapeFrame.size.height * 3.0 + 4.0 + 20.0)];
                    [powerWhiteBox setFrame:CGRectMake(button6LandscapeFrame.origin.x - 8.0, button6LandscapeFrame.origin.y - 8.0, button6LandscapeFrame.size.width + 16.0, button6LandscapeFrame.size.height * 3.0 + 4.0 + 16.0)];
                    [powerSectionHeaderLabel setFrame:CGRectMake(powerBox.frame.origin.x, powerBox.frame.origin.y - 30.0, powerBox.frame.size.width, 30.0)];
                }
                else
                {
                    [blurryView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 320, 170, 640, 282.568542)];
                    [blurryView2 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 320, 512, 640, 162.568542)];
                    [powerSectionHeaderLabel setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 320, powerSectionHeaderLabel.frame.origin.y - 40, 640, powerSectionHeaderLabel.frame.size.height)];
                }
                
                [cdcImageView setFrame:CGRectMake(2, self.navigationController.navigationBar.frame.size.height + [self.view frame].size.height - 146, (450.0 / 272.0) * 100.0, 100.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 100.0 + [self.view frame].size.width, self.navigationController.navigationBar.frame.size.height + [self.view frame].size.height - 146, (300.0 / 293.0) * 100.0, 100.0)];
            }];
        }
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.phoneHeaderLabel setCenter:CGPointMake([self.view frame].size.width / 2.0, 30.0)];
        }];
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.button1 setFrame:button1Frame];
                [self.button2 setFrame:button2Frame];
                [self.button3 setFrame:button3Frame];
                [self.button4 setFrame:button4Frame];
                [self.button5 setFrame:button5Frame];
                [self.button6 setFrame:button6Frame];
                
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.button1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 281.0, 60, 280, 44)];
                [self.button2 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 281.0, 111, 280, 44)];
                [self.button3 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 281.0, 162, 280, 44)];
                [self.button4 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 60, 280, 44)];
                [self.button5 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 111, 280, 44)];
                [self.button6 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 162, 280, 44)];
                if (self.view.frame.size.width < 2.0 * self.button1.frame.size.width)
                {
                    [self.button1 setFrame:CGRectMake(1.0, 60, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button2 setFrame:CGRectMake(1.0, 111, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button3 setFrame:CGRectMake(1.0, 162, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button4 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 60, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button5 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 111, self.view.frame.size.width / 2.0 - 2.0, 44)];
                    [self.button6 setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 1.0, 162, self.view.frame.size.width / 2.0 - 2.0, 44)];
                }
                
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
    }
}

- (void)popCurrentViewController
{
    //Method for the custom "Back" button on the NavigationController
    [self.navigationController popViewControllerAnimated:YES];
}
@end
