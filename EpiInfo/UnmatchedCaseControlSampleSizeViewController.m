//
//  UnmatchedCaseControlSampleSizeViewController.m
//  EpiInfo
//
//  Created by John Copeland on 10/10/12.
//

#import "UnmatchedCaseControlSampleSizeViewController.h"
#import "EpiInfoScrollView.h"
#import "UnmatchedCaseControlSampleSizeCompute.h"

@interface UnmatchedCaseControlSampleSizeViewController ()
@property (nonatomic, weak) IBOutlet EpiInfoScrollView *populationSurveyView;
@end

@implementation UnmatchedCaseControlSampleSizeViewController
@synthesize powerField = _powerField;
@synthesize ratioField = _ratioField;
@synthesize controlsExposedField = _controlsExposedField;
@synthesize casesExposedField = _casesExposedField;
@synthesize oddsRatioLabel = _oddsRatioLabel;
@synthesize casesKelseyLabel = _casesKelseyLabel;
@synthesize casesFleissLabel = _casesFleissLabel;
@synthesize casesFleissCCLabel = _casesFleissCCLabel;
@synthesize controlsKelseyLabel = _controlsKelseyLabel;
@synthesize controlsFleissLabel = _controlsFleissLabel;
@synthesize controlsFleissCCLabel = _controlsFleissCCLabel;
@synthesize totalKelseyLabel = _totalKelseyLabel;
@synthesize totalFleissLabel = _totalFleissLabel;
@synthesize totalFleissCCLabel = _totalFleissCCLabel;
@synthesize powerSlider = _powerSlider;
@synthesize controlsExposedSlider = _controlsExposedSlider;
@synthesize casesExposedSlider = _casesExposedSlider;
@synthesize powerStepper = _powerStepper;
@synthesize controlsExposedStepper = _controlsExposedStepper;
@synthesize casesExposedStepper = _casesExposedStepper;

//iPad
@synthesize sliderLabel1, sliderLabel2, sliderLabel3;
//

-(void)setPopulationSurveyView:(EpiInfoScrollView *)populationSurveyView
{
    _populationSurveyView = populationSurveyView;
    self.populationSurveyView.minimumZoomScale = 1.0;
    self.populationSurveyView.maximumZoomScale = 2.0;
    self.populationSurveyView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomingView;
}

- (void)doubleTapAction
{
    if (self.populationSurveyView.zoomScale < 2.0)
        [self.populationSurveyView setZoomScale:2.0 animated:YES];
    else
        [self.populationSurveyView setZoomScale:1.0 animated:YES];
}

-(void)viewDidLoad
{
    scrollViewFrame = CGRectMake(0, 40, 768, 960);
    [self.epiInfoScrollView0 setScrollEnabled:NO];
    
    self.ratioField.returnKeyType = UIReturnKeyDone;
    self.ratioField.delegate = self;
    
    //iPad
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"textured-Bar.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:124/255.0 green:177/255.0 blue:55/255.0 alpha:1.0]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    self.title = @"";
    //
   // self.title = @"Unmatched Case-Control";
//    CGRect frame = CGRectMake(0, 0, [self.title sizeWithFont:[UIFont boldSystemFontOfSize:20.0]].width, 44);
    // Deprecation replacement
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    self.navigationItem.titleView = label;
    label.text = self.title;
    
    [self.ratioField setText:@"3"];
    [self.controlsExposedSlider setValue:40];
    [self.casesExposedSlider setValue:60];
    [self.controlsExposedStepper setValue:[self.controlsExposedSlider value]];
    [self.sliderLabel2 setText:[[NSString alloc] initWithFormat:@"%0.1f",[self.controlsExposedSlider value]]];
    [self.casesExposedStepper setValue:[self.casesExposedSlider value]];
    [self.sliderLabel3 setText:[[NSString alloc] initWithFormat:@"%0.1f",[self.casesExposedSlider value]]];
    [self compute:self.casesExposedSlider];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Change the standard NavigationController "Back" button to an "X"
        customBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [customBackButton setImage:[UIImage imageNamed:@"StAndrewXButtonWhite.png"] forState:UIControlStateNormal];
        [customBackButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
        [customBackButton.layer setMasksToBounds:YES];
        [customBackButton.layer setCornerRadius:8.0];
        [customBackButton setTitle:@"Back to previous screen" forState:UIControlStateNormal];
//        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customBackButton]];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        UIBarButtonItem *backToMainMenu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(popCurrentViewController)];
        [backToMainMenu setAccessibilityLabel:@"Close"];
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        fadingColorView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [fadingColorView setImage:[UIImage imageNamed:@"iPadBackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        fadingColorView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, [self.view frame].size.height - 400.0, [self.view frame].size.width, 400.0)];
        [fadingColorView0 setImage:[UIImage imageNamed:@"FadeUpAndDown.png"]];
//        [self.view addSubview:fadingColorView0];
//        [self.view sendSubviewToBack:fadingColorView0];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
            [self.lowerNavigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:130/255.0 blue:126/255.0 alpha:1.0]];
        }
        
        int i = 0;
        for (UIView *v in [self.epiInfoScrollView0 subviews])
        {
            int j = 0;
            for (UIView *vi in [v subviews])
            {
                if ([vi isKindOfClass:[UILabel class]])
                {
                    if ([[(UILabel *)vi text] isEqualToString:@"Fleiss w/CC"])
                        [vi setAccessibilityLabel:@"Flice with continuity correction"];
                    if ([[(UILabel *)vi text] isEqualToString:@"Fleiss"])
                        [vi setAccessibilityLabel:@"Flice"];
                }
                j++;
            }
            i++;
        }
    }
    else
    {
        // Change the standard NavigationController "Back" button to an "X"
        customBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [customBackButton setImage:[UIImage imageNamed:@"StAndrewXButtonWhite.png"] forState:UIControlStateNormal];
        [customBackButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
        [customBackButton.layer setMasksToBounds:YES];
        [customBackButton.layer setCornerRadius:8.0];
        [customBackButton setTitle:@"Back to previous screen" forState:UIControlStateNormal];
//        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customBackButton]];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        UIBarButtonItem *backToMainMenu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(popCurrentViewController)];
        [backToMainMenu setAccessibilityLabel:@"Close"];
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        //Set the size of the scrolling area
        self.populationSurveyView.contentSize = CGSizeMake(320, 500);
        self.populationSurveyView.initialContentSize = CGSizeMake(320, 500);

        //Determine the size of the phone.
        fourInchPhone = (self.view.frame.size.height > 500);
        
        //No first responder at load time
        hasAFirstResponder = NO;
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.populationSurveyView.frame.size.width, self.populationSurveyView.frame.size.height)];
        
        //Configure initial iPhone layout
        [self.phoneTitleLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneTitleLabel.layer setCornerRadius:10.0];
        [self.phoneTitleLabel setTextColor:[UIColor whiteColor]];
        [self.phoneKelseyLabel setBackgroundColor:[UIColor clearColor]];
        [self.phoneFleissLabel setBackgroundColor:[UIColor clearColor]];
        [self.phoneFleissWithCCLabel setBackgroundColor:[UIColor clearColor]];
        
        //Build the box for Odds Ratio (and Risk Ratio if Cohort Calculator)
        [self.phoneOddsRatioLabel setFrame:CGRectMake(0, 0, 66, 21)];
        [self.oddsRatioLabel setFrame:CGRectMake(0, 21, 66, 21)];
        phoneOddsRatioView = [[UIView alloc] initWithFrame:CGRectMake(127, 334, 66, 42)];
        [phoneOddsRatioView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneOddsRatioView.layer setCornerRadius:10.0];
        [self.populationSurveyView addSubview:phoneOddsRatioView];
        phoneOddsRatioViewWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 20, 62, 20)];
        [phoneOddsRatioViewWhiteBox setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsRatioViewWhiteBox.layer setCornerRadius:8.0];
        [phoneOddsRatioView addSubview:phoneOddsRatioViewWhiteBox];
        phoneOddsRatioViewExtraWhite = [[UIView alloc] initWithFrame:CGRectMake(2, 20, 62, 10)];
        [phoneOddsRatioViewExtraWhite setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsRatioView addSubview:phoneOddsRatioViewExtraWhite];
        [phoneOddsRatioView addSubview:self.phoneOddsRatioLabel];
        [self.phoneOddsRatioLabel setTextColor:[UIColor whiteColor]];
        [phoneOddsRatioView addSubview:self.oddsRatioLabel];
        
        //Build the Results View
        phoneResultsView = [[UIView alloc] initWithFrame:CGRectMake(18, 395, 4 + 3 * 67 + 70, 84)];        
        [phoneResultsView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneResultsView.layer setCornerRadius:10.0];
        [self.populationSurveyView addSubview:phoneResultsView];
        [self.phoneKelseyLabel setFrame:CGRectMake(87 - 18, 395 - 395, 67, 21)];
        [self.phoneFleissLabel setFrame:CGRectMake(154 - 18, 395 - 395, 67, 21)];
        [self.phoneFleissLabel setAccessibilityLabel:@"Flice"];
        [self.phoneFleissWithCCLabel setFrame:CGRectMake(221 - 18, 395 - 395, 70, 21)];
        [self.phoneFleissWithCCLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [self.phoneFleissWithCCLabel setAccessibilityLabel:@"Flice with continuity correction"];
        [self.phoneExposedOrCasesResultsLabel setTextColor:[UIColor whiteColor]];
        [self.phoneUnexposedOrControlsResultsLabel setTextColor:[UIColor whiteColor]];
        [self.phoneTotalResultsLabel setTextColor:[UIColor whiteColor]];
        [self.phoneExposedOrCasesResultsLabel setFrame:CGRectMake(20 - 18, 416 - 395, 67, 21)];
        [self.casesKelseyLabel setFrame:CGRectMake(87 - 18, 416 - 395, 67, 21)];
        [self.casesFleissLabel setFrame:CGRectMake(154 - 18, 416 - 395, 67, 21)];
        [self.casesFleissCCLabel setFrame:CGRectMake(221 - 18, 416 - 395, 70, 21)];
        [self.phoneUnexposedOrControlsResultsLabel setFrame:CGRectMake(20 - 18, 437 - 395, 67, 21)];
        [self.controlsKelseyLabel setFrame:CGRectMake(87 - 18, 437 - 395, 67, 21)];
        [self.controlsFleissLabel setFrame:CGRectMake(154 - 18, 437 - 395, 67, 21)];
        [self.controlsFleissCCLabel setFrame:CGRectMake(221 - 18, 437 - 395, 70, 21)];
        [self.phoneTotalResultsLabel setFrame:CGRectMake(20 - 18, 458 - 395, 67, 21)];
        [self.totalKelseyLabel setFrame:CGRectMake(87 - 18, 458 - 395, 67, 21)];
        [self.totalFleissLabel setFrame:CGRectMake(154 - 18, 458 - 395, 67, 21)];
        [self.totalFleissCCLabel setFrame:CGRectMake(221 - 18, 458 - 395, 67, 21)];
        phoneResultsWhitebox1 = [[UIView alloc] initWithFrame:CGRectMake(87 - 17, 416 - 394, 65, 19)];
        phoneResultsWhitebox2 = [[UIView alloc] initWithFrame:CGRectMake(154 - 17, 416 - 394, 65, 19)];
        phoneResultsWhitebox3 = [[UIView alloc] initWithFrame:CGRectMake(221 - 17, 416 - 394, 69, 19)];
        phoneResultsWhitebox4 = [[UIView alloc] initWithFrame:CGRectMake(87 - 17, 437 - 394, 65, 19)];
        phoneResultsWhitebox5 = [[UIView alloc] initWithFrame:CGRectMake(154 - 17, 437 - 394, 65, 19)];
        phoneResultsWhitebox6 = [[UIView alloc] initWithFrame:CGRectMake(221 - 17, 437 - 394, 69, 19)];
        phoneResultsWhitebox7 = [[UIView alloc] initWithFrame:CGRectMake(87 - 17, 458 - 394, 65, 18)];
        phoneResultsWhitebox8 = [[UIView alloc] initWithFrame:CGRectMake(154 - 17, 458 - 394, 65, 18)];
        phoneResultsWhitebox9 = [[UIView alloc] initWithFrame:CGRectMake(221 - 17, 458 - 394, 69, 18)];
        phoneResultsExtraWhite1 = [[UIView alloc] initWithFrame:CGRectMake(221 - 17, 458 - 394, 69, 9)];
        phoneResultsExtraWhite2 = [[UIView alloc] initWithFrame:CGRectMake(221 - 17, 458 - 394, 30, 18)];
        [phoneResultsWhitebox1 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsWhitebox2 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsWhitebox3 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsWhitebox4 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsWhitebox5 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsWhitebox6 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsWhitebox7 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsWhitebox8 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsWhitebox9 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsWhitebox9.layer setCornerRadius:8.0];
        [phoneResultsExtraWhite1 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsExtraWhite2 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneResultsWhitebox1];
        [phoneResultsView addSubview:phoneResultsWhitebox2];
        [phoneResultsView addSubview:phoneResultsWhitebox3];
        [phoneResultsView addSubview:phoneResultsWhitebox4];
        [phoneResultsView addSubview:phoneResultsWhitebox5];
        [phoneResultsView addSubview:phoneResultsWhitebox6];
        [phoneResultsView addSubview:phoneResultsWhitebox7];
        [phoneResultsView addSubview:phoneResultsWhitebox8];
        [phoneResultsView addSubview:phoneResultsWhitebox9];
        [phoneResultsView addSubview:phoneResultsExtraWhite1];
        [phoneResultsView addSubview:phoneResultsExtraWhite2];
        [phoneResultsView addSubview:self.phoneKelseyLabel];
        [phoneResultsView addSubview:self.phoneFleissLabel];
        [phoneResultsView addSubview:self.phoneFleissWithCCLabel];
        [phoneResultsView addSubview:self.phoneExposedOrCasesResultsLabel];
        [phoneResultsView addSubview:self.casesKelseyLabel];
        [phoneResultsView addSubview:self.casesFleissLabel];
        [phoneResultsView addSubview:self.casesFleissCCLabel];
        [phoneResultsView addSubview:self.phoneUnexposedOrControlsResultsLabel];
        [phoneResultsView addSubview:self.controlsKelseyLabel];
        [phoneResultsView addSubview:self.controlsFleissLabel];
        [phoneResultsView addSubview:self.controlsFleissCCLabel];
        [phoneResultsView addSubview:self.phoneTotalResultsLabel];
        [phoneResultsView addSubview:self.totalKelseyLabel];
        [phoneResultsView addSubview:self.totalFleissLabel];
        [phoneResultsView addSubview:self.totalFleissCCLabel];
        
        blPower = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height) AndSlider:self.powerSlider];
        [self.populationSurveyView addSubview:blPower];
        brPower = [[ButtonRight alloc] initWithFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height) AndSlider:self.powerSlider];
        [self.populationSurveyView addSubview:brPower];
        
        blControlsExposed = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x - self.controlsExposedSlider.frame.size.height - 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height) AndSlider:self.controlsExposedSlider];
        [self.populationSurveyView addSubview:blControlsExposed];
        brControlsExposed = [[ButtonRight alloc] initWithFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x + self.controlsExposedSlider.frame.size.width + 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height) AndSlider:self.controlsExposedSlider];
        [self.populationSurveyView addSubview:brControlsExposed];
        
        blCasesExposed = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.casesExposedSlider.frame.origin.x - self.casesExposedSlider.frame.size.height - 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height) AndSlider:self.casesExposedSlider];
        [self.populationSurveyView addSubview:blCasesExposed];
        brCasesExposed = [[ButtonRight alloc] initWithFrame:CGRectMake(self.casesExposedSlider.frame.origin.x + self.casesExposedSlider.frame.size.width + 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height) AndSlider:self.casesExposedSlider];
        [self.populationSurveyView addSubview:brCasesExposed];
        
        //Add everything to the zoomingView
        for (UIView *view in self.populationSurveyView.subviews)
        {
            [zoomingView addSubview:view];
            //Remove all struts and springs
            [view setAutoresizingMask:UIViewAutoresizingNone];
        }
        [self.populationSurveyView addSubview:zoomingView];
        
        //Add double-tap zooming
//        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
//       [tgr setNumberOfTapsRequired:2];
//        [tgr setNumberOfTouchesRequired:1];
//        [self.populationSurveyView addGestureRecognizer:tgr];
        
        [self.populationSurveyView setShowsVerticalScrollIndicator:NO];
        [self.populationSurveyView setShowsHorizontalScrollIndicator:NO];
        [self.populationSurveyView setShowsVerticalScrollIndicator:YES];
        [self.populationSurveyView setShowsHorizontalScrollIndicator:YES];
        
        [self.powerSlider setMinimumTrackTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.powerSlider setMaximumTrackTintColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self.controlsExposedSlider setMinimumTrackTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.controlsExposedSlider setMaximumTrackTintColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self.casesExposedSlider setMinimumTrackTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.casesExposedSlider setMaximumTrackTintColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        
        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
        if (self.view.frame.size.height > 500)
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5BackgroundWhite.png"]];
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4BackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        [self.phoneConfidenceLevelLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneConfidenceLevelValue setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phonePowerLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phonePowerPercentLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.powerField setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneRatioLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneControlsOrUnexposedLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneControlsOrUnexposedPercentLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneCasesOrExposedLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneCasesOrExposedPercentLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.controlsExposedField setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.casesExposedField setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneConfidenceLevelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [self.phoneConfidenceLevelValue setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phonePowerLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phonePowerPercentLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.powerField setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneRatioLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneControlsOrUnexposedLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(self.phoneControlsOrUnexposedLabel.frame.origin.x, self.phoneControlsOrUnexposedLabel.frame.origin.y, self.phoneControlsOrUnexposedLabel.frame.size.width + 66.0, self.phoneControlsOrUnexposedLabel.frame.size.height)];
        [self.phoneControlsOrUnexposedPercentLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneCasesOrExposedLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneCasesOrExposedPercentLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.controlsExposedField setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.casesExposedField setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneControlsOrUnexposedLabel setText:@"Percent of controls exposed:"];
        [self.phoneCasesOrExposedLabel setText:@"Percent of cases exposed:"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/CaseControlSSScreenPad.png" atomically:YES];
//    To here
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 308.5, 2, 617, 530)];
                [self.subView2 setFrame:CGRectMake(50, self.view.frame.size.height - 254, 280, 168)];
                [self.subView3 setFrame:CGRectMake(self.view.frame.size.width - 597, self.view.frame.size.height - 274, 557, 234)];
            }];
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            for (UIView *v in [self.lowerNavigationBar subviews])
            {
                if ([v isKindOfClass:[UIButton class]])
                {
                    [(UIButton *)v setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
        }
    }
    else
    {
        //Place all iPhone subviews in the proper position
        [UIView animateWithDuration:0.3 animations:^{
            [self.phoneTitleLabel setFrame:CGRectMake(20 * self.populationSurveyView.scale, 20 * self.populationSurveyView.scale, 274 * self.populationSurveyView.scale, 42 * self.populationSurveyView.scale)];
            [self.phoneConfidenceLevelLabel setFrame:CGRectMake(20, 70, 161, 21)];
            [self.phoneConfidenceLevelValue setFrame:CGRectMake(198, 70, 84, 21)];
            [self.phonePowerLabel setFrame:CGRectMake(20, 99, 161, 21)];
            [self.powerField setFrame:CGRectMake(204, 95, 70, 30)];
            [self.phonePowerPercentLabel setFrame:CGRectMake(274, 99, 15, 21)];
            [self.powerSlider setFrame:CGRectMake(40, 128, 211, 23)];
            [self.phoneRatioLabel setFrame:CGRectMake(20, 162, 173, 21)];
            [self.ratioField setFrame:CGRectMake(205, 158, 70, 30)];
            [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(20, 195, 173, 21)];
            [self.controlsExposedField setFrame:CGRectMake(205, 191, 70, 30)];
            [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(275, 195, 15, 21)];
            [self.controlsExposedSlider setFrame:CGRectMake(40, 220, 211, 23)];
            [self.phoneCasesOrExposedLabel setFrame:CGRectMake(20, 252, 161, 21)];
            [self.casesExposedField setFrame:CGRectMake(205, 248, 70, 30)];
            [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(275, 252, 15, 21)];
            [self.casesExposedSlider setFrame:CGRectMake(40, 286, 211, 23)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                [self.powerSlider setFrame:CGRectMake(self.powerSlider.frame.origin.x, self.powerSlider.frame.origin.y - 8.0, self.powerSlider.frame.size.width, self.powerSlider.frame.size.height)];
            }
            [blPower setFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
            [brPower setFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
            [blControlsExposed setFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x - self.controlsExposedSlider.frame.size.height - 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height)];
            [brControlsExposed setFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x + self.controlsExposedSlider.frame.size.width + 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height)];
            [blCasesExposed setFrame:CGRectMake(self.casesExposedSlider.frame.origin.x - self.casesExposedSlider.frame.size.height - 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height)];
            [brCasesExposed setFrame:CGRectMake(self.casesExposedSlider.frame.origin.x + self.casesExposedSlider.frame.size.width + 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height)];
        }];
        
        //Re-orient iPhone views if Landscape
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            //Re-size the zoomingView
            [zoomingView setFrame:CGRectMake(0, 0, self.populationSurveyView.frame.size.width, self.populationSurveyView.frame.size.height)];
            [UIView animateWithDuration:0.3 animations:^{
                //Compress the text inputs
                [self.phoneTitleLabel setFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 42)];
                [self.phoneConfidenceLevelLabel setFrame:CGRectMake(20, 60, 161, 21)];
                [self.phoneConfidenceLevelValue setFrame:CGRectMake(140, 60, 84, 21)];
                [self.phoneRatioLabel setFrame:CGRectMake(20, 89, 173, 21)];
                [self.ratioField setFrame:CGRectMake(175, 85, 50, 30)];
                
                if (fourInchPhone)
                {
                    //Set the size of the scrolling area
                    if (hasAFirstResponder)
                    {
                        self.populationSurveyView.contentSize = CGSizeMake(548, 290);
                        self.populationSurveyView.initialContentSize = CGSizeMake(548, 290);
                    }
                    else
                    {
                        self.populationSurveyView.contentSize = CGSizeMake(548, 250);
                        self.populationSurveyView.initialContentSize = CGSizeMake(548, 250);
                    }
                    
                    //Move the sliders to the right in landscape orientation
                    [self.phonePowerLabel setFrame:CGRectMake(300, 60, 161, 21)];
                    [self.powerField setFrame:CGRectMake(445, 54, 70, 30)];
                    [self.phonePowerPercentLabel setFrame:CGRectMake(515, 60, 15, 21)];
                    [self.powerSlider setFrame:CGRectMake(320, 89, 191, 23)];
                    [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(300, 121, 173, 21)];
                    [self.controlsExposedField setFrame:CGRectMake(445, 117, 70, 30)];
                    [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(515, 121, 15, 21)];
                    [self.controlsExposedSlider setFrame:CGRectMake(320, 146, 191, 23)];
                    [self.phoneCasesOrExposedLabel setFrame:CGRectMake(300, 178, 161, 21)];
                    [self.casesExposedField setFrame:CGRectMake(445, 174, 70, 30)];
                    [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(515, 178, 15, 21)];
                    [self.casesExposedSlider setFrame:CGRectMake(320, 203, 191, 23)];
                    
                    //Move the sample size results
                    [phoneResultsView setFrame:CGRectMake(10, 167, 275, 84)];
                    
                    //Move the Odds Ratio result
                    [phoneOddsRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 - 33, 120, 66, 42)];
                }
                else
                {
                    //Set the size of the scrolling area
                    self.populationSurveyView.contentSize = CGSizeMake(480, 340);
                    self.populationSurveyView.initialContentSize = CGSizeMake(480, 340);
                    
                    //Move the sliders to the right in landscape orientation
                    [self.phonePowerLabel setFrame:CGRectMake(240, 60, 161, 21)];
                    [self.powerField setFrame:CGRectMake(384, 54, 70, 30)];
                    [self.phonePowerPercentLabel setFrame:CGRectMake(454, 60, 15, 21)];
                    [self.powerSlider setFrame:CGRectMake(260, 89, 171, 23)];
                    [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(240, 121, 173, 21)];
                    [self.controlsExposedField setFrame:CGRectMake(384, 117, 70, 30)];
                    [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(454, 121, 15, 21)];
                    [self.controlsExposedSlider setFrame:CGRectMake(260, 146, 171, 23)];
                    [self.phoneCasesOrExposedLabel setFrame:CGRectMake(240, 178, 161, 21)];
                    [self.casesExposedField setFrame:CGRectMake(384, 174, 70, 30)];
                    [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(454, 178, 15, 21)];
                    [self.casesExposedSlider setFrame:CGRectMake(260, 203, 171, 23)];
                    
                    //Move the sample size results
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 137.5, 230, 275, 84)];
                    
                    //Move the Odds Ratio result
                    [phoneOddsRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 - 33, 135, 66, 42)];
                }
                [blPower setFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [brPower setFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [blControlsExposed setFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x - self.controlsExposedSlider.frame.size.height - 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height)];
                [brControlsExposed setFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x + self.controlsExposedSlider.frame.size.width + 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height)];
                [blCasesExposed setFrame:CGRectMake(self.casesExposedSlider.frame.origin.x - self.casesExposedSlider.frame.size.height - 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height)];
                [brCasesExposed setFrame:CGRectMake(self.casesExposedSlider.frame.origin.x + self.casesExposedSlider.frame.size.width + 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height)];
            }];
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, [zoomingView sizeThatFits:self.view.frame.size].width, [zoomingView sizeThatFits:self.view.frame.size].height)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        hasAFirstResponder = NO;
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && fourInchPhone)
        {
            float zs = [self.populationSurveyView zoomScale];
            [self.populationSurveyView setZoomScale:1.0 animated:YES];
            self.populationSurveyView.contentSize = CGSizeMake(548, 250);
            self.populationSurveyView.initialContentSize = CGSizeMake(548, 250);
            [self.populationSurveyView setZoomScale:zs animated:YES];
        }
    }
    
//    [self compute:textField];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (IBAction)compute:(id)sender
{
    double confidence = 0.05;
    double power = [self.powerField.text doubleValue];
    double controlRatio = [self.ratioField.text doubleValue];
    double percentControlsExposed = [self.controlsExposedField.text doubleValue] / 100.0;
    double percentCasesExposed = [self.casesExposedField.text doubleValue] / 100.0;
    double oddsRatio = (percentCasesExposed / (1 - percentCasesExposed)) / (percentControlsExposed / (1 - percentControlsExposed));
    
    if (power > 0.0 && controlRatio > 0.0 && percentControlsExposed >= 0.0 && percentCasesExposed >= 0.0)
    {
        UnmatchedCaseControlSampleSizeCompute *computer = [[UnmatchedCaseControlSampleSizeCompute alloc] init];
        int sizes[9];
        [computer Calculate:confidence VariableB:power VariableVR:controlRatio VariableV2:percentControlsExposed VariableVOR:oddsRatio VariableV1:percentCasesExposed KelseyAndFleissValues:sizes];
        self.oddsRatioLabel.text = [[NSString alloc] initWithFormat:@"%g", oddsRatio];
        self.casesKelseyLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[0]];
        self.casesFleissLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[3]];
        self.casesFleissCCLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[6]];
        self.controlsKelseyLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[1]];
        self.controlsFleissLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[4]];
        self.controlsFleissCCLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[7]];
        self.totalKelseyLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[2]];
        self.totalFleissLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[5]];
        self.totalFleissCCLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[8]];
    }
    else
    {
        self.oddsRatioLabel.text = [[NSString alloc] initWithFormat:@""];
        self.casesKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
        self.casesFleissLabel.text = [[NSString alloc] initWithFormat:@""];
        self.casesFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
        self.controlsKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
        self.controlsFleissLabel.text = [[NSString alloc] initWithFormat:@""];
        self.controlsFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
        self.totalKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
        self.totalFleissLabel.text = [[NSString alloc] initWithFormat:@""];
        self.totalFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
    }
}

- (IBAction)reset:(id)sender
{
    if ([self.powerField isFirstResponder])
        [self.powerField resignFirstResponder];
    else if ([self.ratioField isFirstResponder])
        [self.ratioField resignFirstResponder];
    else if ([self.controlsExposedField isFirstResponder])
        [self.controlsExposedField resignFirstResponder];
    else if ([self.casesExposedField isFirstResponder])
        [self.casesExposedField resignFirstResponder];
    
    self.powerField.text = [[NSString alloc] initWithFormat:@"80.0"];
    self.ratioField.text = [[NSString alloc] initWithFormat:@""];
    self.controlsExposedField.text = [[NSString alloc] initWithFormat:@""];
    self.casesExposedField.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioLabel.text = [[NSString alloc] initWithFormat:@""];
    self.casesKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
    self.casesFleissLabel.text = [[NSString alloc] initWithFormat:@""];
    self.casesFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
    self.controlsKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
    self.controlsFleissLabel.text = [[NSString alloc] initWithFormat:@""];
    self.controlsFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
    self.totalKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
    self.totalFleissLabel.text = [[NSString alloc] initWithFormat:@""];
    self.totalFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
    [self.powerSlider setValue:80];
    [self.controlsExposedSlider setValue:0];
    [self.casesExposedSlider setValue:0];
    [[self powerStepper] setValue:80];
    [[self controlsExposedStepper] setValue:0];
    [[self casesExposedStepper] setValue:0];
}

- (IBAction)resetBarButtonPressed:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        hasAFirstResponder = NO;
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && fourInchPhone)
        {
            self.populationSurveyView.contentSize = CGSizeMake(548, 250);
            self.populationSurveyView.initialContentSize = CGSizeMake(548, 250);
        }
    }
    
    [self reset:sender];
}

//iPad
-(IBAction) sliderChanged1:(id) sender{
    UISlider *slider1 = (UISlider *) sender;
    float progressAsFloat = (float)(slider1.value );
    NSString *newText =[[NSString alloc]
                        initWithFormat:@"%0.1f",progressAsFloat];
    [self.powerStepper setValue:round(progressAsFloat * 10) / 10];
    self.sliderLabel1.text = newText;
    [self compute:sender];
    // [newText release];
}
-(IBAction) sliderChanged2:(id) sender{
    UISlider *slider2 = (UISlider *) sender;
    float progressAsFloat = (float)(slider2.value );
    NSString *newText =[[NSString alloc]
                        initWithFormat:@"%0.1f",progressAsFloat];
    [self.controlsExposedStepper setValue:round(progressAsFloat * 10) / 10];
    self.sliderLabel2.text = newText;
    [self compute:sender];
    // [newText release];
}
-(IBAction) sliderChanged3:(id) sender{
    UISlider *slider3 = (UISlider *) sender;
    float progressAsFloat = (float)(slider3.value );
    NSString *newText =[[NSString alloc]
                        initWithFormat:@"%0.1f",progressAsFloat];
    [self.casesExposedStepper setValue:round(progressAsFloat * 10) / 10];
    self.sliderLabel3.text = newText;
    [self compute:sender];
    // [newText release];
}

- (IBAction)stepperChanged1:(id)sender
{
    UIStepper *stepper = (UIStepper *) sender;
    double currentValue = [stepper value];
    [self.powerSlider setValue:currentValue];
    self.sliderLabel1.text = [[NSString alloc] initWithFormat:@"%0.1f", currentValue];
    [self compute:sender];
}

- (IBAction)stepperChanged2:(id)sender
{
    UIStepper *stepper = (UIStepper *) sender;
    double currentValue = [stepper value];
    [self.controlsExposedSlider setValue:currentValue];
    self.sliderLabel2.text = [[NSString alloc] initWithFormat:@"%0.1f", currentValue];
    [self compute:sender];
}

- (IBAction)stepperChanged3:(id)sender
{
    UIStepper *stepper = (UIStepper *) sender;
    double currentValue = [stepper value];
    [self.casesExposedSlider setValue:currentValue];
    self.sliderLabel3.text = [[NSString alloc] initWithFormat:@"%0.1f", currentValue];
    [self compute:sender];
}

- (IBAction)textFieldAction:(id)sender
{
    int cursorPosition = (int)[sender offsetFromPosition:[sender endOfDocument] toPosition:[[sender selectedTextRange] start]];
    
    UITextField *theTextField = (UITextField *)sender;
    
    if (theTextField.text.length + cursorPosition == 0)
    {
        [self compute:sender];
        UITextPosition *newPosition = [sender positionFromPosition:[sender endOfDocument] offset:cursorPosition];
        [sender setSelectedTextRange:[sender textRangeFromPosition:newPosition toPosition:newPosition]];
        return;
    }
    
    if (theTextField.text.length == 0)
    {
        [self compute:sender];
        return;
    }
    
    NSCharacterSet *validSet; // = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
/*
    if (theTextField.text.length - [theTextField.text stringByReplacingOccurrencesOfString:@"." withString:@""].length > 1)
        validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if ([[theTextField.text substringWithRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
    {
        theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1) withString:@""];
    }
    else
        [self compute:sender];
*/    
    validSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    for (int i = 0; i < theTextField.text.length; i++)
    {
        if ([[theTextField.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
            theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
        if ([theTextField.text characterAtIndex:i] == '.')
            validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    theTextField.text = [theTextField.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [self compute:sender];

    UITextPosition *newPosition = [sender positionFromPosition:[sender endOfDocument] offset:cursorPosition];
    [sender setSelectedTextRange:[sender textRangeFromPosition:newPosition toPosition:newPosition]];
}

- (IBAction)textFieldBecameFirstResponder:(id)sender
{
    hasAFirstResponder = YES;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && fourInchPhone)
    {
        float zs = [self.populationSurveyView zoomScale];
        [self.populationSurveyView setZoomScale:1.0 animated:YES];
        self.populationSurveyView.contentSize = CGSizeMake(548, 290);
        self.populationSurveyView.initialContentSize = CGSizeMake(548, 290);
        if (zs > 1)
            [self.populationSurveyView setZoomScale:zs animated:YES];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currentOrientationPortrait = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:scrollViewFrame];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setFrame:CGRectMake(0, [self.view frame].size.height - 400.0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:1];
                
                [self.subView1 setFrame:CGRectMake(76, 32, 617, 530)];
                [self.subView2 setFrame:CGRectMake(244, 464, 280, 168)];
                [self.subView3 setFrame:CGRectMake(106, 611, 557, 234)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 308.5, 2, 617, 530)];
                [self.subView2 setFrame:CGRectMake(50, self.view.frame.size.height - 254, 280, 168)];
                [self.subView3 setFrame:CGRectMake(self.view.frame.size.width - 597, self.view.frame.size.height - 274, 557, 234)];
            }];
        }
    }
    else
    {
        float zs = [self.populationSurveyView zoomScale];
        [self.populationSurveyView setZoomScale:1.0 animated:YES];
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                //Set the size of the scrolling area
                self.populationSurveyView.contentSize = CGSizeMake(320, 500);
                self.populationSurveyView.initialContentSize = CGSizeMake(320, 500);
                
                [self.phoneTitleLabel setFrame:CGRectMake(20, 20, 274, 42)];
                [self.phoneConfidenceLevelLabel setFrame:CGRectMake(20, 70, 161, 21)];
                [self.phoneConfidenceLevelValue setFrame:CGRectMake(198, 70, 84, 21)];
                [self.phonePowerLabel setFrame:CGRectMake(20, 99, 161, 21)];
                [self.powerField setFrame:CGRectMake(204, 95, 70, 30)];
                [self.phonePowerPercentLabel setFrame:CGRectMake(274, 99, 15, 21)];
                [self.powerSlider setFrame:CGRectMake(40, 128, 211, 23)];
                [self.phoneRatioLabel setFrame:CGRectMake(20, 162, 173, 21)];
                [self.ratioField setFrame:CGRectMake(205, 158, 70, 30)];
                [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(20, 195, 173, 21)];
                [self.controlsExposedField setFrame:CGRectMake(205, 191, 70, 30)];
                [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(275, 195, 15, 21)];
                [self.controlsExposedSlider setFrame:CGRectMake(40, 220, 211, 23)];
                [self.phoneCasesOrExposedLabel setFrame:CGRectMake(20, 252, 161, 21)];
                [self.casesExposedField setFrame:CGRectMake(205, 248, 70, 30)];
                [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(275, 252, 15, 21)];
                [self.casesExposedSlider setFrame:CGRectMake(40, 286, 211, 23)];
                [phoneOddsRatioView setFrame:CGRectMake(127, 334, 66, 42)];
                [blPower setFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [brPower setFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [blControlsExposed setFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x - self.controlsExposedSlider.frame.size.height - 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height)];
                [brControlsExposed setFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x + self.controlsExposedSlider.frame.size.width + 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height)];
                [blCasesExposed setFrame:CGRectMake(self.casesExposedSlider.frame.origin.x - self.casesExposedSlider.frame.size.height - 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height)];
                [brCasesExposed setFrame:CGRectMake(self.casesExposedSlider.frame.origin.x + self.casesExposedSlider.frame.size.width + 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height)];
                [phoneResultsView setFrame:CGRectMake(18, 395, 275, 84)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                //Compress the text inputs
                [self.phoneTitleLabel setFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 42)];
                [self.phoneConfidenceLevelLabel setFrame:CGRectMake(20, 60, 161, 21)];
                [self.phoneConfidenceLevelValue setFrame:CGRectMake(140, 60, 84, 21)];
                [self.phoneRatioLabel setFrame:CGRectMake(20, 89, 173, 21)];
                [self.ratioField setFrame:CGRectMake(175, 85, 50, 30)];
                
                if (fourInchPhone)
                {
                    //Set the size of the scrolling area
                    if (hasAFirstResponder)
                    {
                        self.populationSurveyView.contentSize = CGSizeMake(548, 290);
                        self.populationSurveyView.initialContentSize = CGSizeMake(548, 290);
                    }
                    else
                    {
                        self.populationSurveyView.contentSize = CGSizeMake(548, 250);
                        self.populationSurveyView.initialContentSize = CGSizeMake(548, 250);
                    }
                    
                    //Move the sliders to the right in landscape orientation
                    [self.phonePowerLabel setFrame:CGRectMake(300, 60, 161, 21)];
                    [self.powerField setFrame:CGRectMake(445, 54, 70, 30)];
                    [self.phonePowerPercentLabel setFrame:CGRectMake(515, 60, 15, 21)];
                    [self.powerSlider setFrame:CGRectMake(320, 89, 191, 23)];
                    [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(300, 121, 173, 21)];
                    [self.controlsExposedField setFrame:CGRectMake(445, 117, 70, 30)];
                    [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(515, 121, 15, 21)];
                    [self.controlsExposedSlider setFrame:CGRectMake(320, 146, 191, 23)];
                    [self.phoneCasesOrExposedLabel setFrame:CGRectMake(300, 178, 161, 21)];
                    [self.casesExposedField setFrame:CGRectMake(445, 174, 70, 30)];
                    [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(515, 178, 15, 21)];
                    [self.casesExposedSlider setFrame:CGRectMake(320, 203, 191, 23)];
                    
                    //Move the sample size results
                    [phoneResultsView setFrame:CGRectMake(10, 167, 275, 84)];
                    
                    //Move the Odds Ratio result
                    [phoneOddsRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 - 33, 120, 66, 42)];
                }
                else
                {
                    //Set the size of the scrolling area
                    self.populationSurveyView.contentSize = CGSizeMake(480, 340);
                    self.populationSurveyView.initialContentSize = CGSizeMake(480, 340);

                    //Move the sliders to the right in landscape orientation
                    [self.phonePowerLabel setFrame:CGRectMake(240, 60, 161, 21)];
                    [self.powerField setFrame:CGRectMake(384, 54, 70, 30)];
                    [self.phonePowerPercentLabel setFrame:CGRectMake(454, 60, 15, 21)];
                    [self.powerSlider setFrame:CGRectMake(260, 89, 171, 23)];
                    [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(240, 121, 173, 21)];
                    [self.controlsExposedField setFrame:CGRectMake(384, 117, 70, 30)];
                    [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(454, 121, 15, 21)];
                    [self.controlsExposedSlider setFrame:CGRectMake(260, 146, 171, 23)];
                    [self.phoneCasesOrExposedLabel setFrame:CGRectMake(240, 178, 161, 21)];
                    [self.casesExposedField setFrame:CGRectMake(384, 174, 70, 30)];
                    [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(454, 178, 15, 21)];
                    [self.casesExposedSlider setFrame:CGRectMake(260, 203, 171, 23)];

                    //Move the sample size results
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 137.5, 230, 275, 84)];
                    
                    //Move the Odds Ratio result
                    [phoneOddsRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 - 33, 135, 66, 42)];
                }
                [blPower setFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [brPower setFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [blControlsExposed setFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x - self.controlsExposedSlider.frame.size.height - 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height)];
                [brControlsExposed setFrame:CGRectMake(self.controlsExposedSlider.frame.origin.x + self.controlsExposedSlider.frame.size.width + 5, self.controlsExposedSlider.frame.origin.y, self.controlsExposedSlider.frame.size.height, self.controlsExposedSlider.frame.size.height)];
                [blCasesExposed setFrame:CGRectMake(self.casesExposedSlider.frame.origin.x - self.casesExposedSlider.frame.size.height - 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height)];
                [brCasesExposed setFrame:CGRectMake(self.casesExposedSlider.frame.origin.x + self.casesExposedSlider.frame.size.width + 5, self.casesExposedSlider.frame.origin.y, self.casesExposedSlider.frame.size.height, self.casesExposedSlider.frame.size.height)];
            }];
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, [zoomingView sizeThatFits:self.view.frame.size].width, [zoomingView sizeThatFits:self.view.frame.size].height)];
        
        if (zs > 1.0)
            [self.populationSurveyView setZoomScale:zs animated:YES];
    }
}

- (void)popCurrentViewController
{
    //Method for the custom "Back" button on the NavigationController
    [self.navigationController popViewControllerAnimated:YES];
}
@end
