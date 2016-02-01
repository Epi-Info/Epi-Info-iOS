//
//  CohortSampleSizeViewController.m
//  EpiInfo
//
//  Created by John Copeland on 10/10/12.
//

#import "CohortSampleSizeViewController.h"
#import "PopulationSurveyView.h"
#import "CohortSampleSizeCompute.h"

@interface CohortSampleSizeViewController ()
@property (nonatomic, weak) IBOutlet PopulationSurveyView *populationSurveyView;
@end

@implementation CohortSampleSizeViewController
@synthesize powerField = _powerField;
@synthesize ratioField = _ratioField;
@synthesize unexposedField = _unexposedField;
@synthesize exposedField = _exposedField;
@synthesize riskRatioLabel = _riskRatioLabel;
@synthesize oddsRatioLabel = _oddsRatioLabel;
@synthesize exposedKelseyLabel = _exposedKelseyLabel;
@synthesize exposedFleissLabel = _exposedFleissLabel;
@synthesize exposedFleissCCLabel = _exposedFleissCCLabel;
@synthesize unexposedKelseyLabel = _unexposedKelseyLabel;
@synthesize unexposedFleissLabel = _unexposedFleissLabel;
@synthesize unexposedFleissCCLabel = _unexposedFleissCCLabel;
@synthesize totalKelseyLabel = _totalKelseyLabel;
@synthesize totalFleissLabel = _totalFleissLabel;
@synthesize totalFleissCCLabel = _totalFleissCCLabel;
@synthesize powerSlider = _powerSlider;
@synthesize unexposedSlider = _unexposedSlider;
@synthesize exposedSlider = _exposedSlider;
@synthesize powerStepper = _powerStepper;
@synthesize unexposedStepper = _unexposedStepper;
@synthesize exposedStepper = _exposedStepper;

@synthesize sliderLabel1, sliderLabel2, sliderLabel3;


-(void)setPopulationSurveyView:(PopulationSurveyView *)populationSurveyView
{
    _populationSurveyView = populationSurveyView;
    [self.populationSurveyView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.populationSurveyView action:@selector(pinch:)]];
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
    scrollViewFrame = CGRectMake(0, 40, 768, 920);
    [self.epiInfoScrollView0 setScrollEnabled:NO];
    
    self.ratioField.returnKeyType = UIReturnKeyDone;
    self.ratioField.delegate = self;

    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"textured-Bar.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:124/255.0 green:177/255.0 blue:55/255.0 alpha:1.0]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    self.title = @"Epi Info StatCalc";

  //  self.title = @"Cohort/Cross-Sectional";
//    CGRect frame = CGRectMake(0, 0, [self.title sizeWithFont:[UIFont boldSystemFontOfSize:20.0]].width, 44);
    // Deprecation replacement
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    self.navigationItem.titleView = label;
    label.text = self.title;
    
    [self.ratioField setText:@"2"];
    [self.unexposedSlider setValue:40];
    [self.exposedSlider setValue:60];
    [self.unexposedStepper setValue:[self.unexposedSlider value]];
    [self.sliderLabel2 setText:[[NSString alloc] initWithFormat:@"%0.1f",[self.unexposedSlider value]]];
    [self.exposedStepper setValue:[self.exposedSlider value]];
    [self.sliderLabel3 setText:[[NSString alloc] initWithFormat:@"%0.1f",[self.exposedSlider value]]];
    [self compute:self.exposedSlider];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Change the standard NavigationController "Back" button to an "X"
        customBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [customBackButton setImage:[UIImage imageNamed:@"StAndrewXButtonWhite.png"] forState:UIControlStateNormal];
        [customBackButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
        [customBackButton.layer setMasksToBounds:YES];
        [customBackButton.layer setCornerRadius:8.0];
        [customBackButton setTitle:@"Back to previous screen" forState:UIControlStateNormal];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customBackButton]];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        fadingColorView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [fadingColorView setImage:[UIImage imageNamed:@"iPadBackground.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        fadingColorView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, [self.view frame].size.height - 400.0, [self.view frame].size.width, 400.0)];
        [fadingColorView0 setImage:[UIImage imageNamed:@"FadeUpAndDown.png"]];
//        [self.view addSubview:fadingColorView0];
//        [self.view sendSubviewToBack:fadingColorView0];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
            [self.lowerNavigationBar setBarTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
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
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customBackButton]];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        //Set the size of the scrolling area
        self.populationSurveyView.contentSize = CGSizeMake(320, 500);
        
        //Determine the size of the phone.
        fourInchPhone = (self.view.frame.size.height > 500);
        
        //No first responder at load time
        hasAFirstResponder = NO;
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.populationSurveyView.frame.size.width, self.populationSurveyView.frame.size.height)];
        
        //Configure initial iPhone layout
        [self.phoneTitleLabel setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.phoneTitleLabel.layer setCornerRadius:10.0];
        [self.phoneTitleLabel setTextColor:[UIColor whiteColor]];
        [self.phoneTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [self.phoneKelseyLabel setBackgroundColor:[UIColor clearColor]];
        [self.phoneFleissLabel setBackgroundColor:[UIColor clearColor]];
        [self.phoneFleissWithCCLabel setBackgroundColor:[UIColor clearColor]];
        [self.phoneFleissWithCCLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        
        //Build the box for Odds Ratio (and Risk Ratio if Cohort Calculator)
        [self.phoneOddsRatioLabel setFrame:CGRectMake(0, 0, 66, 21)];
        [self.oddsRatioLabel setFrame:CGRectMake(0, 21, 66, 21)];
        phoneOddsRatioView = [[UIView alloc] initWithFrame:CGRectMake(170, 334, 66, 42)];
        [phoneOddsRatioView setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
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
        
        [self.phoneRiskRatioLabel setFrame:CGRectMake(0, 0, 66, 21)];
        [self.riskRatioLabel setFrame:CGRectMake(0, 21, 66, 21)];
        phoneRiskRatioView = [[UIView alloc] initWithFrame:CGRectMake(84, 334, 66, 42)];
        [phoneRiskRatioView setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [phoneRiskRatioView.layer setCornerRadius:10.0];
        [self.populationSurveyView addSubview:phoneRiskRatioView];
        phoneRiskRatioViewWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 20, 62, 20)];
        [phoneRiskRatioViewWhiteBox setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskRatioViewWhiteBox.layer setCornerRadius:8.0];
        [phoneRiskRatioView addSubview:phoneRiskRatioViewWhiteBox];
        phoneRiskRatioViewExtraWhite = [[UIView alloc] initWithFrame:CGRectMake(2, 20, 62, 10)];
        [phoneRiskRatioViewExtraWhite setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskRatioView addSubview:phoneRiskRatioViewExtraWhite];
        [phoneRiskRatioView addSubview:self.phoneRiskRatioLabel];
        [self.phoneRiskRatioLabel setTextColor:[UIColor whiteColor]];
        [phoneRiskRatioView addSubview:self.riskRatioLabel];
        
        //Build the Results View
        phoneResultsView = [[UIView alloc] initWithFrame:CGRectMake(18, 395, 4 + 3 * 67 + 70, 84)];
        [phoneResultsView setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [phoneResultsView.layer setCornerRadius:10.0];
        [self.populationSurveyView addSubview:phoneResultsView];
        [self.phoneKelseyLabel setFrame:CGRectMake(87 - 18, 395 - 395, 67, 21)];
        [self.phoneFleissLabel setFrame:CGRectMake(154 - 18, 395 - 395, 67, 21)];
        [self.phoneFleissLabel setAccessibilityLabel:@"Flice"];
        [self.phoneFleissWithCCLabel setFrame:CGRectMake(221 - 18, 395 - 395, 70, 21)];
        [self.phoneFleissWithCCLabel setAccessibilityLabel:@"Flice with continuity correction"];
        [self.phoneExposedOrCasesResultsLabel setTextColor:[UIColor whiteColor]];
        [self.phoneUnexposedOrControlsResultsLabel setTextColor:[UIColor whiteColor]];
        [self.phoneUnexposedOrControlsResultsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [self.phoneTotalResultsLabel setTextColor:[UIColor whiteColor]];
        [self.phoneExposedOrCasesResultsLabel setFrame:CGRectMake(20 - 18, 416 - 395, 67, 21)];
        [self.exposedKelseyLabel setFrame:CGRectMake(87 - 18, 416 - 395, 67, 21)];
        [self.exposedFleissLabel setFrame:CGRectMake(154 - 18, 416 - 395, 67, 21)];
        [self.exposedFleissCCLabel setFrame:CGRectMake(221 - 18, 416 - 395, 70, 21)];
        [self.phoneUnexposedOrControlsResultsLabel setFrame:CGRectMake(20 - 18, 437 - 395, 67, 21)];
        [self.unexposedKelseyLabel setFrame:CGRectMake(87 - 18, 437 - 395, 67, 21)];
        [self.unexposedFleissLabel setFrame:CGRectMake(154 - 18, 437 - 395, 67, 21)];
        [self.unexposedFleissCCLabel setFrame:CGRectMake(221 - 18, 437 - 395, 70, 21)];
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
        [phoneResultsView addSubview:self.exposedKelseyLabel];
        [phoneResultsView addSubview:self.exposedFleissLabel];
        [phoneResultsView addSubview:self.exposedFleissCCLabel];
        [phoneResultsView addSubview:self.phoneUnexposedOrControlsResultsLabel];
        [phoneResultsView addSubview:self.unexposedKelseyLabel];
        [phoneResultsView addSubview:self.unexposedFleissLabel];
        [phoneResultsView addSubview:self.unexposedFleissCCLabel];
        [phoneResultsView addSubview:self.phoneTotalResultsLabel];
        [phoneResultsView addSubview:self.totalKelseyLabel];
        [phoneResultsView addSubview:self.totalFleissLabel];
        [phoneResultsView addSubview:self.totalFleissCCLabel];
        
        //Add stepper arrows to sliders
        blPower = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height) AndSlider:self.powerSlider];
        [self.populationSurveyView addSubview:blPower];
        brPower = [[ButtonRight alloc] initWithFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height) AndSlider:self.powerSlider];
        [self.populationSurveyView addSubview:brPower];
        
        blUnexposed = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.unexposedSlider.frame.origin.x - self.unexposedSlider.frame.size.height - 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height) AndSlider:self.unexposedSlider];
        [self.populationSurveyView addSubview:blUnexposed];
        brUnexposed = [[ButtonRight alloc] initWithFrame:CGRectMake(self.unexposedSlider.frame.origin.x + self.unexposedSlider.frame.size.width + 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height) AndSlider:self.unexposedSlider];
        [self.populationSurveyView addSubview:brUnexposed];
        
        blExposed = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.exposedSlider.frame.origin.x - self.exposedSlider.frame.size.height - 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height) AndSlider:self.exposedSlider];
        [self.populationSurveyView addSubview:blExposed];
        brExposed = [[ButtonRight alloc] initWithFrame:CGRectMake(self.exposedSlider.frame.origin.x + self.exposedSlider.frame.size.width + 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height) AndSlider:self.exposedSlider];
        [self.populationSurveyView addSubview:brExposed];
        
        //Add everything to the zoomingView
        for (UIView *view in self.populationSurveyView.subviews)
        {
            [zoomingView addSubview:view];
            //Remove all struts and springs
            [view setAutoresizingMask:UIViewAutoresizingNone];
        }
        [self.populationSurveyView addSubview:zoomingView];
        
        //Add double-tap zooming
        //Don't add because of stepper arrows.
//        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
//        [tgr setNumberOfTapsRequired:2];
//        [tgr setNumberOfTouchesRequired:1];
//        [self.populationSurveyView addGestureRecognizer:tgr];
        
        [self.populationSurveyView setShowsVerticalScrollIndicator:NO];
        [self.populationSurveyView setShowsHorizontalScrollIndicator:NO];
        [self.populationSurveyView setShowsVerticalScrollIndicator:YES];
        [self.populationSurveyView setShowsHorizontalScrollIndicator:YES];
        
        [self.powerSlider setMinimumTrackTintColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.powerSlider setMaximumTrackTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
        [self.unexposedSlider setMinimumTrackTintColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.unexposedSlider setMaximumTrackTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
        [self.exposedSlider setMinimumTrackTintColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.exposedSlider setMaximumTrackTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
        
        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
        if (self.view.frame.size.height > 500)
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5Background.png"]];
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4Background.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        [self.phoneConfidenceLevelLabel setTextColor:[UIColor whiteColor]];
        [self.phoneConfidenceLevelValue setTextColor:[UIColor whiteColor]];
        [self.phonePowerLabel setTextColor:[UIColor whiteColor]];
        [self.phonePowerPercentLabel setTextColor:[UIColor whiteColor]];
        [self.powerField setTextColor:[UIColor whiteColor]];
        [self.phoneRatioLabel setTextColor:[UIColor whiteColor]];
        [self.phoneControlsOrUnexposedLabel setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.phoneControlsOrUnexposedPercentLabel setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.phoneCasesOrExposedLabel setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.phoneCasesOrExposedPercentLabel setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.unexposedField setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.exposedField setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.phoneConfidenceLevelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [self.phoneConfidenceLevelValue setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phonePowerLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phonePowerPercentLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.powerField setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneRatioLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneControlsOrUnexposedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0]];
        [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(self.phoneControlsOrUnexposedLabel.frame.origin.x, self.phoneControlsOrUnexposedLabel.frame.origin.y, self.phoneControlsOrUnexposedLabel.frame.size.width + 66.0, self.phoneControlsOrUnexposedLabel.frame.size.height)];
        [self.phoneControlsOrUnexposedPercentLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneCasesOrExposedLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneCasesOrExposedPercentLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.unexposedField setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.exposedField setFont:[UIFont boldSystemFontOfSize:12.0]];
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/CohortSSScreenPad.png" atomically:YES];
//    To here
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 308.5, -4, 617, 530)];
                [self.subView2 setFrame:CGRectMake(-10, self.view.frame.size.height - 234, 501, 130)];
                [self.subView3 setFrame:CGRectMake(self.view.frame.size.width - 547, self.view.frame.size.height - 274, 557, 234)];
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
            [self.phoneTitleLabel setFrame:CGRectMake(20, 20, 274, 42)];
            [self.phoneConfidenceLevelLabel setFrame:CGRectMake(20, 70, 161, 21)];
            [self.phoneConfidenceLevelValue setFrame:CGRectMake(198, 70, 84, 21)];
            [self.phonePowerLabel setFrame:CGRectMake(20, 99, 161, 21)];
            [self.powerField setFrame:CGRectMake(204, 95, 70, 30)];
            [self.phonePowerPercentLabel setFrame:CGRectMake(274, 99, 15, 21)];
            [self.powerSlider setFrame:CGRectMake(40, 128, 211, 23)];
            [self.phoneRatioLabel setFrame:CGRectMake(20, 162, 173, 21)];
            [self.ratioField setFrame:CGRectMake(205, 158, 70, 30)];
            [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(20, 195, 185, 21)];
            [self.unexposedField setFrame:CGRectMake(205, 191, 70, 30)];
            [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(275, 195, 15, 21)];
            [self.unexposedSlider setFrame:CGRectMake(40, 220, 211, 23)];
            [self.phoneCasesOrExposedLabel setFrame:CGRectMake(20, 252, 180, 21)];
            [self.exposedField setFrame:CGRectMake(205, 248, 70, 30)];
            [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(275, 252, 15, 21)];
            [self.exposedSlider setFrame:CGRectMake(40, 286, 211, 23)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                [self.powerSlider setFrame:CGRectMake(self.powerSlider.frame.origin.x, self.powerSlider.frame.origin.y - 8.0, self.powerSlider.frame.size.width, self.powerSlider.frame.size.height)];
            }
            [blPower setFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
            [brPower setFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
            [blUnexposed setFrame:CGRectMake(self.unexposedSlider.frame.origin.x - self.unexposedSlider.frame.size.height - 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height)];
            [brUnexposed setFrame:CGRectMake(self.unexposedSlider.frame.origin.x + self.unexposedSlider.frame.size.width + 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height)];
            [blExposed setFrame:CGRectMake(self.exposedSlider.frame.origin.x - self.exposedSlider.frame.size.height - 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height)];
            [brExposed setFrame:CGRectMake(self.exposedSlider.frame.origin.x + self.exposedSlider.frame.size.width + 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height)];
        }];
        
        //Re-orient iPhone views if Landscape
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
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
                        self.populationSurveyView.contentSize = CGSizeMake(548, 290);
                    else
                        self.populationSurveyView.contentSize = CGSizeMake(548, 250);
                    
                    //Move the sliders to the right in landscape orientation
                    [self.phonePowerLabel setFrame:CGRectMake(300, 60, 161, 21)];
                    [self.powerField setFrame:CGRectMake(445, 54, 70, 30)];
                    [self.phonePowerPercentLabel setFrame:CGRectMake(515, 60, 15, 21)];
                    [self.powerSlider setFrame:CGRectMake(320, 89, 171, 23)];
                    [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(300, 121, 180, 21)];
                    [self.unexposedField setFrame:CGRectMake(445, 117, 70, 30)];
                    [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(515, 121, 15, 21)];
                    [self.unexposedSlider setFrame:CGRectMake(320, 146, 171, 23)];
                    [self.phoneCasesOrExposedLabel setFrame:CGRectMake(300, 178, 180, 21)];
                    [self.exposedField setFrame:CGRectMake(445, 174, 70, 30)];
                    [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(515, 178, 15, 21)];
                    [self.exposedSlider setFrame:CGRectMake(320, 203, 171, 23)];
                    
                    //Move the sample size results
                    [phoneResultsView setFrame:CGRectMake(10, 167, 275, 84)];
                    
                    //Move the Risk and Odds Ratio results
                    [phoneOddsRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 + 5, 120, 66, 42)];
                    [phoneRiskRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 - 71, 120, 66, 42)];
                }
                else
                {
                    //Set the size of the scrolling area
                    self.populationSurveyView.contentSize = CGSizeMake(480, 340);
                    
                    //Move the sliders to the right in landscape orientation
                    [self.phonePowerLabel setFrame:CGRectMake(240, 60, 161, 21)];
                    [self.powerField setFrame:CGRectMake(384, 54, 70, 30)];
                    [self.phonePowerPercentLabel setFrame:CGRectMake(454, 60, 15, 21)];
                    [self.powerSlider setFrame:CGRectMake(260, 89, 171, 23)];
                    [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(240, 121, 180, 21)];
                    [self.unexposedField setFrame:CGRectMake(384, 117, 70, 30)];
                    [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(454, 121, 15, 21)];
                    [self.unexposedSlider setFrame:CGRectMake(260, 146, 171, 23)];
                    [self.phoneCasesOrExposedLabel setFrame:CGRectMake(240, 178, 180, 21)];
                    [self.exposedField setFrame:CGRectMake(384, 174, 70, 30)];
                    [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(454, 178, 15, 21)];
                    [self.exposedSlider setFrame:CGRectMake(260, 203, 171, 23)];
                    
                    //Move the sample size results
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 137.5, 230, 275, 84)];
                    
                    //Move the Risk and Odds Ratio results
                    [phoneOddsRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 + 5, 135, 66, 42)];
                    [phoneRiskRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 - 71, 135, 66, 42)];
                }
                [blPower setFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [brPower setFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [blUnexposed setFrame:CGRectMake(self.unexposedSlider.frame.origin.x - self.unexposedSlider.frame.size.height - 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height)];
                [brUnexposed setFrame:CGRectMake(self.unexposedSlider.frame.origin.x + self.unexposedSlider.frame.size.width + 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height)];
                [blExposed setFrame:CGRectMake(self.exposedSlider.frame.origin.x - self.exposedSlider.frame.size.height - 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height)];
                [brExposed setFrame:CGRectMake(self.exposedSlider.frame.origin.x + self.exposedSlider.frame.size.width + 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height)];
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
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && fourInchPhone)
        {
            float zs = [self.populationSurveyView zoomScale];
            [self.populationSurveyView setZoomScale:1.0 animated:YES];
            self.populationSurveyView.contentSize = CGSizeMake(548, 250);
            [self.populationSurveyView setZoomScale:zs animated:YES];
        }
    }
    
    [self compute:textField];
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
    double percentExposed = [self.unexposedField.text doubleValue] / 100.0;
    double percentCasesExposure = [self.exposedField.text doubleValue] / 100.0;
    double oddsRatio = (percentCasesExposure / (1 - percentCasesExposure)) / (percentExposed / (1 - percentExposed));
    double riskRatio = percentCasesExposure / percentExposed;
    
    if (power > 0.0 && controlRatio > 0.0 && percentExposed >= 0.0 && percentCasesExposure >= 0.0)
    {
        CohortSampleSizeCompute *computer = [[CohortSampleSizeCompute alloc] init];
        int sizes[9];
        [computer Calculate:confidence VariableB:power VariableVR:controlRatio VariableV2:percentExposed VariableVOR:oddsRatio VariableV1:percentCasesExposure KelseyAndFleissValues:sizes];
        self.riskRatioLabel.text = [[NSString alloc] initWithFormat:@"%g", riskRatio];
        self.oddsRatioLabel.text = [[NSString alloc] initWithFormat:@"%g", oddsRatio];
        self.exposedKelseyLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[0]];
        self.exposedFleissLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[3]];
        self.exposedFleissCCLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[6]];
        self.unexposedKelseyLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[1]];
        self.unexposedFleissLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[4]];
        self.unexposedFleissCCLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[7]];
        self.totalKelseyLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[2]];
        self.totalFleissLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[5]];
        self.totalFleissCCLabel.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[8]];
    }
    else
    {
        self.riskRatioLabel.text = [[NSString alloc] initWithFormat:@""];
        self.oddsRatioLabel.text = [[NSString alloc] initWithFormat:@""];
        self.exposedKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
        self.exposedFleissLabel.text = [[NSString alloc] initWithFormat:@""];
        self.exposedFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
        self.unexposedKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
        self.unexposedFleissLabel.text = [[NSString alloc] initWithFormat:@""];
        self.unexposedFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
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
    else if ([self.unexposedField isFirstResponder])
        [self.unexposedField resignFirstResponder];
    else if ([self.exposedField isFirstResponder])
        [self.exposedField resignFirstResponder];
    
    self.powerField.text = [[NSString alloc] initWithFormat:@"80.0"];
    self.ratioField.text = [[NSString alloc] initWithFormat:@""];
    self.unexposedField.text = [[NSString alloc] initWithFormat:@""];
    self.exposedField.text = [[NSString alloc] initWithFormat:@""];
    self.riskRatioLabel.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioLabel.text = [[NSString alloc] initWithFormat:@""];
    self.exposedKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
    self.exposedFleissLabel.text = [[NSString alloc] initWithFormat:@""];
    self.exposedFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
    self.unexposedKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
    self.unexposedFleissLabel.text = [[NSString alloc] initWithFormat:@""];
    self.unexposedFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
    self.totalKelseyLabel.text = [[NSString alloc] initWithFormat:@""];
    self.totalFleissLabel.text = [[NSString alloc] initWithFormat:@""];
    self.totalFleissCCLabel.text = [[NSString alloc] initWithFormat:@""];
    [self.powerSlider setValue:80];
    [self.unexposedSlider setValue:0];
    [self.exposedSlider setValue:0];
    [[self powerStepper] setValue:80];
    [[self unexposedStepper] setValue:0];
    [[self exposedStepper] setValue:0];
}

- (IBAction)resetBarButtonPressed:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        hasAFirstResponder = NO;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && fourInchPhone)
        {
            float zs = [self.populationSurveyView zoomScale];
            [self.populationSurveyView setZoomScale:1.0 animated:YES];
            self.populationSurveyView.contentSize = CGSizeMake(548, 250);
            if (zs > 1.0)
                [self.populationSurveyView setZoomScale:zs animated:YES];
        }
    }
    
    [self reset:sender];
}

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
    [self.unexposedStepper setValue:round(progressAsFloat * 10) / 10];
    self.sliderLabel2.text = newText;
    [self compute:sender];
    // [newText release];
}
-(IBAction) sliderChanged3:(id) sender{
    UISlider *slider3 = (UISlider *) sender;
    float progressAsFloat = (float)(slider3.value );
    NSString *newText =[[NSString alloc]
                        initWithFormat:@"%0.1f",progressAsFloat];
    [self.exposedStepper setValue:round(progressAsFloat * 10) / 10];
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
    [self.unexposedSlider setValue:currentValue];
    self.sliderLabel2.text = [[NSString alloc] initWithFormat:@"%0.1f", currentValue];
    [self compute:sender];
}

- (IBAction)stepperChanged3:(id)sender
{
    UIStepper *stepper = (UIStepper *) sender;
    double currentValue = [stepper value];
    [self.exposedSlider setValue:currentValue];
    self.sliderLabel3.text = [[NSString alloc] initWithFormat:@"%0.1f", currentValue];
    [self compute:sender];
}

- (IBAction)textFieldAction:(id)sender
{
    int cursorPosition = [sender offsetFromPosition:[sender endOfDocument] toPosition:[[sender selectedTextRange] start]];
    
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
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && fourInchPhone)
    {
        float zs = [self.populationSurveyView zoomScale];
        [self.populationSurveyView setZoomScale:1.0 animated:YES];
        self.populationSurveyView.contentSize = CGSizeMake(548, 290);
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
                
                [self.subView1 setFrame:CGRectMake(76, -4, 617, 530)];
                [self.subView2 setFrame:CGRectMake(133, 440, 501, 130)];
                [self.subView3 setFrame:CGRectMake(106, 528, 557, 234)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 308.5, -4, 617, 530)];
                [self.subView2 setFrame:CGRectMake(-10, self.view.frame.size.height - 234, 501, 130)];
                [self.subView3 setFrame:CGRectMake(self.view.frame.size.width - 547, self.view.frame.size.height - 274, 557, 234)];
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
                
                [self.phoneTitleLabel setFrame:CGRectMake(20, 20, 274, 42)];
                [self.phoneConfidenceLevelLabel setFrame:CGRectMake(20, 70, 161, 21)];
                [self.phoneConfidenceLevelValue setFrame:CGRectMake(198, 70, 84, 21)];
                [self.phonePowerLabel setFrame:CGRectMake(20, 99, 161, 21)];
                [self.powerField setFrame:CGRectMake(204, 95, 70, 30)];
                [self.phonePowerPercentLabel setFrame:CGRectMake(274, 99, 15, 21)];
                [self.powerSlider setFrame:CGRectMake(40, 128, 211, 23)];
                [self.phoneRatioLabel setFrame:CGRectMake(20, 162, 173, 21)];
                [self.ratioField setFrame:CGRectMake(205, 158, 70, 30)];
                [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(20, 195, 180, 21)];
                [self.unexposedField setFrame:CGRectMake(205, 191, 70, 30)];
                [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(275, 195, 15, 21)];
                [self.unexposedSlider setFrame:CGRectMake(40, 220, 211, 23)];
                [self.phoneCasesOrExposedLabel setFrame:CGRectMake(20, 252, 180, 21)];
                [self.exposedField setFrame:CGRectMake(205, 248, 70, 30)];
                [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(275, 252, 15, 21)];
                [self.exposedSlider setFrame:CGRectMake(40, 286, 211, 23)];
                [phoneOddsRatioView setFrame:CGRectMake(170, 334, 66, 42)];
                [phoneRiskRatioView setFrame:CGRectMake(84, 334, 66, 42)];
                [phoneResultsView setFrame:CGRectMake(18, 395, 275, 84)];
                [blPower setFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [brPower setFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [blUnexposed setFrame:CGRectMake(self.unexposedSlider.frame.origin.x - self.unexposedSlider.frame.size.height - 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height)];
                [brUnexposed setFrame:CGRectMake(self.unexposedSlider.frame.origin.x + self.unexposedSlider.frame.size.width + 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height)];
                [blExposed setFrame:CGRectMake(self.exposedSlider.frame.origin.x - self.exposedSlider.frame.size.height - 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height)];
                [brExposed setFrame:CGRectMake(self.exposedSlider.frame.origin.x + self.exposedSlider.frame.size.width + 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height)];
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
                        self.populationSurveyView.contentSize = CGSizeMake(548, 290);
                    else
                        self.populationSurveyView.contentSize = CGSizeMake(548, 250);
                    
                    //Move the sliders to the right in landscape orientation
                    [self.phonePowerLabel setFrame:CGRectMake(300, 60, 161, 21)];
                    [self.powerField setFrame:CGRectMake(445, 54, 70, 30)];
                    [self.phonePowerPercentLabel setFrame:CGRectMake(515, 60, 15, 21)];
                    [self.powerSlider setFrame:CGRectMake(320, 89, 171, 23)];
                    [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(300, 121, 180, 21)];
                    [self.unexposedField setFrame:CGRectMake(445, 117, 70, 30)];
                    [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(515, 121, 15, 21)];
                    [self.unexposedSlider setFrame:CGRectMake(320, 146, 171, 23)];
                    [self.phoneCasesOrExposedLabel setFrame:CGRectMake(300, 178, 180, 21)];
                    [self.exposedField setFrame:CGRectMake(445, 174, 70, 30)];
                    [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(515, 178, 15, 21)];
                    [self.exposedSlider setFrame:CGRectMake(320, 203, 171, 23)];
                    
                    //Move the sample size results
                    [phoneResultsView setFrame:CGRectMake(10, 167, 275, 84)];
                    
                    //Move the Risk and Odds Ratio results
                    [phoneOddsRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 + 5, 120, 66, 42)];
                    [phoneRiskRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 - 71, 120, 66, 42)];
                }
                else
                {
                    //Set the size of the scrolling area
                    self.populationSurveyView.contentSize = CGSizeMake(480, 340);
                    
                    //Move the sliders to the right in landscape orientation
                    [self.phonePowerLabel setFrame:CGRectMake(240, 60, 161, 21)];
                    [self.powerField setFrame:CGRectMake(384, 54, 70, 30)];
                    [self.phonePowerPercentLabel setFrame:CGRectMake(454, 60, 15, 21)];
                    [self.powerSlider setFrame:CGRectMake(260, 89, 171, 23)];
                    [self.phoneControlsOrUnexposedLabel setFrame:CGRectMake(240, 121, 180, 21)];
                    [self.unexposedField setFrame:CGRectMake(384, 117, 70, 30)];
                    [self.phoneControlsOrUnexposedPercentLabel setFrame:CGRectMake(454, 121, 15, 21)];
                    [self.unexposedSlider setFrame:CGRectMake(260, 146, 171, 23)];
                    [self.phoneCasesOrExposedLabel setFrame:CGRectMake(240, 178, 180, 21)];
                    [self.exposedField setFrame:CGRectMake(384, 174, 70, 30)];
                    [self.phoneCasesOrExposedPercentLabel setFrame:CGRectMake(454, 178, 15, 21)];
                    [self.exposedSlider setFrame:CGRectMake(260, 203, 171, 23)];
                    
                    //Move the sample size results
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 137.5, 230, 275, 84)];
                    
                    //Move the Risk and Odds Ratio results
                    [phoneOddsRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 + 5, 135, 66, 42)];
                    [phoneRiskRatioView setFrame:CGRectMake(self.view.frame.size.width / 4.0 - 71, 135, 66, 42)];
                }
                [blPower setFrame:CGRectMake(self.powerSlider.frame.origin.x - self.powerSlider.frame.size.height - 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [brPower setFrame:CGRectMake(self.powerSlider.frame.origin.x + self.powerSlider.frame.size.width + 5, self.powerSlider.frame.origin.y, self.powerSlider.frame.size.height, self.powerSlider.frame.size.height)];
                [blUnexposed setFrame:CGRectMake(self.unexposedSlider.frame.origin.x - self.unexposedSlider.frame.size.height - 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height)];
                [brUnexposed setFrame:CGRectMake(self.unexposedSlider.frame.origin.x + self.unexposedSlider.frame.size.width + 5, self.unexposedSlider.frame.origin.y, self.unexposedSlider.frame.size.height, self.unexposedSlider.frame.size.height)];
                [blExposed setFrame:CGRectMake(self.exposedSlider.frame.origin.x - self.exposedSlider.frame.size.height - 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height)];
                [brExposed setFrame:CGRectMake(self.exposedSlider.frame.origin.x + self.exposedSlider.frame.size.width + 5, self.exposedSlider.frame.origin.y, self.exposedSlider.frame.size.height, self.exposedSlider.frame.size.height)];
            }];
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, [zoomingView sizeThatFits:self.view.frame.size].width, [zoomingView sizeThatFits:self.view.frame.size].height)];
        
        [self.populationSurveyView setZoomScale:zs animated:YES];
    }
}

- (void)popCurrentViewController
{
    //Method for the custom "Back" button on the NavigationController
    [self.navigationController popViewControllerAnimated:YES];
}
@end
