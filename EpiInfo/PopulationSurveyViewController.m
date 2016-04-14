//
//  PopulationSurveyViewController.m
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//

#import "PopulationSurveyViewController.h"
#import "PopulationSurveyView.h"
#import "PopulationSurveySampleSizeCompute.h"
#import "ButtonRight.h"
#import "ButtonLeft.h"

@interface PopulationSurveyViewController ()
@property (nonatomic, weak) IBOutlet PopulationSurveyView *populationSurveyView;
@end

@implementation PopulationSurveyViewController
@synthesize populationSizeField = _populationSizeField;
@synthesize expectedFrequencyField = _expectedFrequencyField;
@synthesize confidenceLimitsField = _confidenceLimitsField;
@synthesize designEffectField = _designEffectField;
@synthesize clustersField = _clustersField;
@synthesize clusterSize80 = _clusterSize80;
@synthesize totalSample80 = _totalSample80;
@synthesize clusterSize90 = _clusterSize90;
@synthesize totalSample90 = _totalSample90;
@synthesize clusterSize95 = _clusterSize95;
@synthesize totalSample95 = _totalSample95;
@synthesize clusterSize97 = _clusterSize97;
@synthesize totalSample97 = _totalSample97;
@synthesize clusterSize99 = _clusterSize99;
@synthesize totalSample99 = _totalSample99;
@synthesize clusterSize999 = _clusterSize999;
@synthesize totalSample999 = _totalSample999;
@synthesize clusterSize9999 = _clusterSize9999;
@synthesize totalSample9999 = _totalSample9999;
@synthesize expectedFrequencySlider = _expectedFrequencySlider;
@synthesize confidenceLimitsSlider = _confidenceLimitsSlider;
@synthesize expectedFrequencyStepper = _expectedFrequencyStepper;
@synthesize confidenceLimitStepper = _confidenceLimitStepper;

//iPad
@synthesize sliderLabel1, sliderLabel2;
//

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
    scrollViewFrame = CGRectMake(0, 43, 768,1048);
    [self.epiInfoScrollView0 setScrollEnabled:NO];
    
    self.designEffectField.returnKeyType = UIReturnKeyNext;
    self.clustersField.returnKeyType = UIReturnKeyDone;
    self.populationSizeField.returnKeyType = UIReturnKeyDone;
    self.populationSizeField.delegate = self;
    self.designEffectField.delegate = self;
    self.clustersField.delegate = self;
    
    [[self designEffectField] setTag:1];
    
    NSObject *id = [[NSObject alloc] init];
    [self compute:id];
    
    //iPad
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"textured-Bar.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:124/255.0 green:177/255.0 blue:55/255.0 alpha:1.0]];
    
//    CGRect frame = CGRectMake(0, 0, [self.title sizeWithFont:[UIFont boldSystemFontOfSize:20.0]].width, 44);
    // Deprecation replacement
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    self.navigationItem.titleView = label;
    label.text = @"Epi Info StatCalc";
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    //
    
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
        [backToMainMenu setTintColor:[UIColor whiteColor]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
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
        [backToMainMenu setTintColor:[UIColor whiteColor]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        fourInchPhone = (self.view.frame.size.height > 500);
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.populationSurveyView.frame.size.width, self.populationSurveyView.frame.size.height)];
        
        //Initial layout and coloring of all subviews in portrait orientation
        phonePortraitSize = CGSizeMake(320, 590);
        phoneLandscapeSize = CGSizeMake(550, 320);
        phoneLandscapeWithKeyboardSize = CGSizeMake(550, 510);
        self.populationSurveyView.contentSize = phonePortraitSize;

        phoneInputsViewFrame = CGRectMake(0, 0, 320, 264);
        phoneInputsBlueBoxFrame = CGRectMake(16, 17, 289, 262 - 16);
        phoneInputsWhiteBoxFrame = CGRectMake(18, 79, 285, phoneInputsBlueBoxFrame.size.height - 64);
        phoneInputsWhiteBox2Frame = CGRectMake(18, 79, 285, 50);
        phoneMainLabelFrame = CGRectMake(20, 19, 281, 21);
        phoneSecondLabelFrame = CGRectMake(20, 37, 281, 38);
        phonePopulationSizeLabelFrame = CGRectMake(20, 90, 93, 19);
        phonePopulationSizeFieldFrame = CGRectMake(136, 86, 141, 30);
        phoneExpectedFrequencyLabelFrame = CGRectMake(20, 122, 119, 19);
        phoneExpectedFrequencyFieldFrame = CGRectMake(191, 117, 62, 30);
        phoneExpectedFrequencyPercentLabelFrame = CGRectMake(261, 122, 16, 19);
        phoneExpectedFrequencySliderFrame = CGRectMake(50, 138, 221, 23);
        phoneConfidenceLimitsLabelFrame = CGRectMake(20, 159, 119, 19);
        phoneConfidenceLimitsFieldFrame = CGRectMake(191, 154, 62, 30);
        phoneConfidenceLimitsPercentLabelFrame = CGRectMake(261, 159, 16, 19);
        phoneConfidenceLimitsSliderFrame = CGRectMake(50, 174, 221, 23);
        phoneDesignEffectLabelFrame = CGRectMake(20, 203, 119, 19);
        phoneDesignEffectFieldFrame = CGRectMake(191, 199, 62, 30);
        phoneClustersLabelFrame = CGRectMake(20, 235, 119, 19);
        phoneClustersFieldFrame = CGRectMake(191, 230, 62, 30);
        
        phoneInputsView = [[UIView alloc] initWithFrame:phoneInputsViewFrame];
        phoneInputsBlueBoxView = [[UIView alloc] initWithFrame:phoneInputsBlueBoxFrame];
        [phoneInputsBlueBoxView setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [phoneInputsBlueBoxView.layer setCornerRadius:10.0];
        [phoneInputsView addSubview:phoneInputsBlueBoxView];
        
        phoneInputsWhiteBoxView = [[UIView alloc] initWithFrame:phoneInputsWhiteBoxFrame];
        [phoneInputsWhiteBoxView setBackgroundColor:[UIColor whiteColor]];
        [phoneInputsWhiteBoxView.layer setCornerRadius:8.0];
        [phoneInputsView addSubview:phoneInputsWhiteBoxView];
        
        phoneInputsWhiteBox2View = [[UIView alloc] initWithFrame:phoneInputsWhiteBox2Frame];
        [phoneInputsWhiteBox2View setBackgroundColor:[UIColor whiteColor]];
        [phoneInputsView addSubview:phoneInputsWhiteBox2View];
        
        [self.phoneMainLabel setFrame:phoneMainLabelFrame];
        [self.phoneMainLabel setTextColor:[UIColor whiteColor]];
        [phoneInputsView addSubview:self.phoneMainLabel];
        UIControl *mainLabelControl = [[UIControl alloc] initWithFrame:phoneMainLabelFrame];
        [mainLabelControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchDown];
        [phoneInputsView addSubview:mainLabelControl];
        
        [self.phoneSecondLabel setFrame:phoneSecondLabelFrame];
        [self.phoneSecondLabel setTextColor:[UIColor whiteColor]];
        [phoneInputsView addSubview:self.phoneSecondLabel];
        UIControl *secondLabelControl = [[UIControl alloc] initWithFrame:phoneSecondLabelFrame];
        [secondLabelControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchDown];
        [phoneInputsView addSubview:secondLabelControl];
        
        [self.phonePopulationSizeLabel setFrame:phonePopulationSizeLabelFrame];
        [self.phonePopulationSizeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [phoneInputsView addSubview:self.phonePopulationSizeLabel];
        
        [self.populationSizeField setFrame:phonePopulationSizeFieldFrame];
        [phoneInputsView addSubview:self.populationSizeField];
        
        [self.phoneExpectedFrequencyLabel setFrame:phoneExpectedFrequencyLabelFrame];
        [self.phoneExpectedFrequencyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [phoneInputsView addSubview:self.phoneExpectedFrequencyLabel];
        
        [self.expectedFrequencyField setFrame:phoneExpectedFrequencyFieldFrame];
        [phoneInputsView addSubview:self.expectedFrequencyField];
        
        [self.phoneExpectedFrequencyPercentLabel setFrame:phoneExpectedFrequencyPercentLabelFrame];
        [phoneInputsView addSubview:self.phoneExpectedFrequencyPercentLabel];
        
        [self.phoneExpectedFrequencySlider setFrame:phoneExpectedFrequencySliderFrame];
        [phoneInputsView addSubview:self.phoneExpectedFrequencySlider];
        
        [self.phoneConfidenceLimitsLabel setFrame:phoneConfidenceLimitsLabelFrame];
        [phoneInputsView addSubview:self.phoneConfidenceLimitsLabel];
        
        [self.confidenceLimitsField setFrame:phoneConfidenceLimitsFieldFrame];
        [phoneInputsView addSubview:self.confidenceLimitsField];
        
        [self.phoneConfidenceLimitsPercentLabel setFrame:phoneConfidenceLimitsPercentLabelFrame];
        [phoneInputsView addSubview:self.phoneConfidenceLimitsPercentLabel];
        
        [self.phoneConfidenceLimitsSlider setFrame:phoneConfidenceLimitsSliderFrame];
        [phoneInputsView addSubview:self.phoneConfidenceLimitsSlider];
        
        [self.phoneDesignEffectsLabel setFrame:phoneDesignEffectLabelFrame];
        [phoneInputsView addSubview:self.phoneDesignEffectsLabel];
        
        [self.designEffectField setFrame:phoneDesignEffectFieldFrame];
        [phoneInputsView addSubview:self.designEffectField];
        
        [self.phoneClustersLabel setFrame:phoneClustersLabelFrame];
        [phoneInputsView addSubview:self.phoneClustersLabel];
        
        [self.clustersField setFrame:phoneClustersFieldFrame];
        [phoneInputsView addSubview:self.clustersField];
        
        [self.populationSurveyView addSubview:phoneInputsView];
        
        float resultsX1 = 24.0;
        float resultsX2 = 105.0;
        float resultsX3 = 186;
        float resultsWidth = 50;
        float resultsHeight = 28;
        resultsX1 = 320 / 2.0 - 106;
        resultsX2 = resultsX1 + 81.0;
        resultsX3 = resultsX2 + 81.0;
        float resultsYDifference = 264.0;
        phoneConfidenceLevelLabelFrame = CGRectMake(resultsX1, 266 - 264.0, resultsWidth, resultsHeight);
        phoneClusterSizeLabelFrame = CGRectMake(resultsX2 - 9, 266 - 264.0, resultsWidth + 18, resultsHeight);
        phoneTotalSampleLabelFrame = CGRectMake(resultsX3, 266 - 264.0 - resultsHeight * 0.5, resultsWidth, resultsHeight * 2.0);
        phone80PercentLabelFrame = CGRectMake(resultsX1, 303 - resultsYDifference, resultsWidth, resultsHeight);
        phone90PercentLabelFrame = CGRectMake(resultsX1, 331 - resultsYDifference, resultsWidth, resultsHeight);
        phone95PercentLabelFrame = CGRectMake(resultsX1, 359 - resultsYDifference, resultsWidth, resultsHeight);
        phone97PercentLabelFrame = CGRectMake(resultsX1, 387 - resultsYDifference, resultsWidth, resultsHeight);
        phone99PercentLabelFrame = CGRectMake(resultsX1, 415 - resultsYDifference, resultsWidth, resultsHeight);
        phone999PercentLabelFrame = CGRectMake(resultsX1, 443 - resultsYDifference, resultsWidth, resultsHeight);
        phone9999PercentLabelFrame = CGRectMake(resultsX1, 471 - resultsYDifference, resultsWidth, resultsHeight);
        phoneClusterSize80Frame = CGRectMake(resultsX2, 303 - resultsYDifference, resultsWidth, resultsHeight);
        phoneClusterSize90Frame = CGRectMake(resultsX2, 331 - resultsYDifference, resultsWidth, resultsHeight);
        phoneClusterSize95Frame = CGRectMake(resultsX2, 359 - resultsYDifference, resultsWidth, resultsHeight);
        phoneClusterSize97Frame = CGRectMake(resultsX2, 387 - resultsYDifference, resultsWidth, resultsHeight);
        phoneClusterSize99Frame = CGRectMake(resultsX2, 415 - resultsYDifference, resultsWidth, resultsHeight);
        phoneClusterSize999Frame = CGRectMake(resultsX2, 443 - resultsYDifference, resultsWidth, resultsHeight);
        phoneClusterSize9999Frame = CGRectMake(resultsX2, 471 - resultsYDifference, resultsWidth, resultsHeight);
        phoneTotalSample80Frame = CGRectMake(resultsX3, 303 - resultsYDifference, resultsWidth, resultsHeight);
        phoneTotalSample90Frame = CGRectMake(resultsX3, 331 - resultsYDifference, resultsWidth, resultsHeight);
        phoneTotalSample95Frame = CGRectMake(resultsX3, 359 - resultsYDifference, resultsWidth, resultsHeight);
        phoneTotalSample97Frame = CGRectMake(resultsX3, 387 - resultsYDifference, resultsWidth, resultsHeight);
        phoneTotalSample99Frame = CGRectMake(resultsX3, 415 - resultsYDifference, resultsWidth, resultsHeight);
        phoneTotalSample999Frame = CGRectMake(resultsX3, 443 - resultsYDifference, resultsWidth, resultsHeight);
        phoneTotalSample9999Frame = CGRectMake(resultsX3, 471 - resultsYDifference, resultsWidth, resultsHeight);
        phoneResultsViewFrame = CGRectMake(0, 268, 320, 473 + resultsHeight - 264);
        phoneResultsBlueBoxFrame = CGRectMake(resultsX1 - 4, 0, resultsX3 - resultsX1 + resultsWidth + 8, phoneResultsViewFrame.size.height);
        
        phoneResultsView = [[UIView alloc] initWithFrame:phoneResultsViewFrame];
        [self.populationSurveyView addSubview:phoneResultsView];
        
        phoneResultsBlueBox = [[UIView alloc] initWithFrame:phoneResultsBlueBoxFrame];
        [phoneResultsBlueBox setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [phoneResultsBlueBox.layer setCornerRadius:10.0];
        [phoneResultsView addSubview:phoneResultsBlueBox];
        
        [self.phoneConfidenceLevelLabel setFrame:phoneConfidenceLevelLabelFrame];
        [self.phoneConfidenceLevelLabel setBackgroundColor:[UIColor clearColor]];
        [self.phoneConfidenceLevelLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.phoneConfidenceLevelLabel setText:@"Conf. Level"];
        [self.phoneConfidenceLevelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0]];
        [phoneResultsView addSubview:self.phoneConfidenceLevelLabel];
        [self.phoneClusterSizeLabel setFrame:phoneClusterSizeLabelFrame];
        [self.phoneClusterSizeLabel setBackgroundColor:[UIColor clearColor]];
        [self.phoneClusterSizeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0]];
        [self.phoneClusterSizeLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [phoneResultsView addSubview:self.phoneClusterSizeLabel];
        [self.phoneTotalSampleLabel setFrame:phoneTotalSampleLabelFrame];
        [self.phoneTotalSampleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.phoneTotalSampleLabel setBackgroundColor:[UIColor clearColor]];
        [phoneResultsView addSubview:self.phoneTotalSampleLabel];
        
        float whiteWidth = (phoneResultsBlueBoxFrame.size.width - 8.0) / 3.0;
        float whiteHeight = resultsHeight - 2.0;
        float whiteX1 = phoneResultsBlueBoxFrame.origin.x + 2.0;
        float whiteX2 = whiteX1 + whiteWidth + 2.0;
        float whiteX3 = whiteX2 + whiteWidth + 2.0;
        float whiteY = phone80PercentLabelFrame.origin.y + 2.0;
        phoneWhiteBox0 = [[UIView alloc] initWithFrame:CGRectMake(whiteX1, whiteY, whiteWidth, whiteHeight)];
        phoneWhiteBox1 = [[UIView alloc] initWithFrame:CGRectMake(whiteX2, whiteY, whiteWidth, whiteHeight)];
        phoneWhiteBox2 = [[UIView alloc] initWithFrame:CGRectMake(whiteX3, whiteY, whiteWidth, whiteHeight)];
        phoneWhiteBox3 = [[UIView alloc] initWithFrame:CGRectMake(whiteX1, whiteY + 1.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox4 = [[UIView alloc] initWithFrame:CGRectMake(whiteX2, whiteY + 1.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox5 = [[UIView alloc] initWithFrame:CGRectMake(whiteX3, whiteY + 1.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox6 = [[UIView alloc] initWithFrame:CGRectMake(whiteX1, whiteY + 2.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox7 = [[UIView alloc] initWithFrame:CGRectMake(whiteX2, whiteY + 2.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox8 = [[UIView alloc] initWithFrame:CGRectMake(whiteX3, whiteY + 2.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox9 = [[UIView alloc] initWithFrame:CGRectMake(whiteX1, whiteY + 3.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox10 = [[UIView alloc] initWithFrame:CGRectMake(whiteX2, whiteY + 3.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox11 = [[UIView alloc] initWithFrame:CGRectMake(whiteX3, whiteY + 3.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox12 = [[UIView alloc] initWithFrame:CGRectMake(whiteX1, whiteY + 4.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox13 = [[UIView alloc] initWithFrame:CGRectMake(whiteX2, whiteY + 4.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox14 = [[UIView alloc] initWithFrame:CGRectMake(whiteX3, whiteY + 4.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox15 = [[UIView alloc] initWithFrame:CGRectMake(whiteX1, whiteY + 5.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox16 = [[UIView alloc] initWithFrame:CGRectMake(whiteX2, whiteY + 5.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox17 = [[UIView alloc] initWithFrame:CGRectMake(whiteX3, whiteY + 5.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox18 = [[UIView alloc] initWithFrame:CGRectMake(whiteX1, whiteY + 6.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox18a = [[UIView alloc] initWithFrame:CGRectMake(whiteX1, whiteY + 6.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight / 2.0)];
        phoneWhiteBox18b = [[UIView alloc] initWithFrame:CGRectMake(whiteX1 + whiteWidth / 2.0, whiteY + 6.0 * (whiteHeight + 2.0), whiteWidth / 2.0, whiteHeight)];
        phoneWhiteBox19 = [[UIView alloc] initWithFrame:CGRectMake(whiteX2, whiteY + 6.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox20 = [[UIView alloc] initWithFrame:CGRectMake(whiteX3, whiteY + 6.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight)];
        phoneWhiteBox20a = [[UIView alloc] initWithFrame:CGRectMake(whiteX3, whiteY + 6.0 * (whiteHeight + 2.0), whiteWidth / 2.0, whiteHeight)];
        phoneWhiteBox20b = [[UIView alloc] initWithFrame:CGRectMake(whiteX3, whiteY + 6.0 * (whiteHeight + 2.0), whiteWidth, whiteHeight / 2.0)];
        [phoneWhiteBox0 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox1 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox2 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox3 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox4 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox5 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox6 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox7 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox8 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox9 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox10 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox11 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox12 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox13 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox14 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox15 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox16 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox17 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox18 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox18.layer setCornerRadius:8.0];
        [phoneWhiteBox18a setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox18b setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox19 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox20 setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox20.layer setCornerRadius:8.0];
        [phoneWhiteBox20a setBackgroundColor:[UIColor whiteColor]];
        [phoneWhiteBox20b setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox0];
        [phoneResultsView addSubview:phoneWhiteBox1];
        [phoneResultsView addSubview:phoneWhiteBox2];
        [phoneResultsView addSubview:phoneWhiteBox3];
        [phoneResultsView addSubview:phoneWhiteBox4];
        [phoneResultsView addSubview:phoneWhiteBox5];
        [phoneResultsView addSubview:phoneWhiteBox6];
        [phoneResultsView addSubview:phoneWhiteBox7];
        [phoneResultsView addSubview:phoneWhiteBox8];
        [phoneResultsView addSubview:phoneWhiteBox9];
        [phoneResultsView addSubview:phoneWhiteBox10];
        [phoneResultsView addSubview:phoneWhiteBox11];
        [phoneResultsView addSubview:phoneWhiteBox12];
        [phoneResultsView addSubview:phoneWhiteBox13];
        [phoneResultsView addSubview:phoneWhiteBox14];
        [phoneResultsView addSubview:phoneWhiteBox15];
        [phoneResultsView addSubview:phoneWhiteBox16];
        [phoneResultsView addSubview:phoneWhiteBox17];
        [phoneResultsView addSubview:phoneWhiteBox18];
        [phoneResultsView addSubview:phoneWhiteBox18a];
        [phoneResultsView addSubview:phoneWhiteBox18b];
        [phoneResultsView addSubview:phoneWhiteBox19];
        [phoneResultsView addSubview:phoneWhiteBox20];
        [phoneResultsView addSubview:phoneWhiteBox20a];
        [phoneResultsView addSubview:phoneWhiteBox20b];
        
        [self.phone80PercentLabel setFrame:phone80PercentLabelFrame];
        [self.phone90PercentLabel setFrame:phone90PercentLabelFrame];
        [self.phone95PercentLabel setFrame:phone95PercentLabelFrame];
        [self.phone97PercentLabel setFrame:phone97PercentLabelFrame];
        [self.phone99PercentLabel setFrame:phone99PercentLabelFrame];
        [self.phone999PercentLabel setFrame:phone999PercentLabelFrame];
        [self.phone9999PercentLabel setFrame:phone9999PercentLabelFrame];
        [phoneResultsView addSubview:self.phone80PercentLabel];
        [phoneResultsView addSubview:self.phone90PercentLabel];
        [phoneResultsView addSubview:self.phone95PercentLabel];
        [phoneResultsView addSubview:self.phone97PercentLabel];
        [phoneResultsView addSubview:self.phone99PercentLabel];
        [phoneResultsView addSubview:self.phone999PercentLabel];
        [phoneResultsView addSubview:self.phone9999PercentLabel];
        
        [self.clusterSize80 setFrame:phoneClusterSize80Frame];
        [self.clusterSize90 setFrame:phoneClusterSize90Frame];
        [self.clusterSize95 setFrame:phoneClusterSize95Frame];
        [self.clusterSize97 setFrame:phoneClusterSize97Frame];
        [self.clusterSize99 setFrame:phoneClusterSize99Frame];
        [self.clusterSize999 setFrame:phoneClusterSize999Frame];
        [self.clusterSize9999 setFrame:phoneClusterSize9999Frame];
        [phoneResultsView addSubview:self.clusterSize80];
        [phoneResultsView addSubview:self.clusterSize90];
        [phoneResultsView addSubview:self.clusterSize95];
        [phoneResultsView addSubview:self.clusterSize97];
        [phoneResultsView addSubview:self.clusterSize99];
        [phoneResultsView addSubview:self.clusterSize999];
        [phoneResultsView addSubview:self.clusterSize9999];
        
        [self.totalSample80 setFrame:phoneTotalSample80Frame];
        [self.totalSample90 setFrame:phoneTotalSample90Frame];
        [self.totalSample95 setFrame:phoneTotalSample95Frame];
        [self.totalSample97 setFrame:phoneTotalSample97Frame];
        [self.totalSample99 setFrame:phoneTotalSample99Frame];
        [self.totalSample999 setFrame:phoneTotalSample999Frame];
        [self.totalSample9999 setFrame:phoneTotalSample9999Frame];
        [phoneResultsView addSubview:self.totalSample80];
        [phoneResultsView addSubview:self.totalSample90];
        [phoneResultsView addSubview:self.totalSample95];
        [phoneResultsView addSubview:self.totalSample97];
        [phoneResultsView addSubview:self.totalSample99];
        [phoneResultsView addSubview:self.totalSample999];
        [phoneResultsView addSubview:self.totalSample9999];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.phoneExpectedFrequencySlider setFrame:CGRectMake(self.phoneExpectedFrequencySlider.frame.origin.x + 6.0, self.phoneExpectedFrequencySlider.frame.origin.y, self.phoneExpectedFrequencySlider.frame.size.width - 12.0, self.phoneExpectedFrequencySlider.frame.size.height)];
            [self.phoneConfidenceLimitsSlider setFrame:CGRectMake(self.phoneConfidenceLimitsSlider.frame.origin.x + 6.0, self.phoneConfidenceLimitsSlider.frame.origin.y, self.phoneConfidenceLimitsSlider.frame.size.width - 12.0, self.phoneConfidenceLimitsSlider.frame.size.height)];

            blPhoneExpectedFrequency = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.phoneExpectedFrequencySlider.frame.origin.x - self.phoneExpectedFrequencySlider.frame.size.height - 2, self.phoneExpectedFrequencySlider.frame.origin.y, self.phoneExpectedFrequencySlider.frame.size.height - 0.0, self.phoneExpectedFrequencySlider.frame.size.height - 0.0) AndSlider:self.phoneExpectedFrequencySlider];
            brPhoneExpectedFrequency = [[ButtonRight alloc] initWithFrame:CGRectMake(self.phoneExpectedFrequencySlider.frame.origin.x + self.phoneExpectedFrequencySlider.frame.size.width + 5, self.phoneExpectedFrequencySlider.frame.origin.y, self.phoneExpectedFrequencySlider.frame.size.height - 0.0, self.phoneExpectedFrequencySlider.frame.size.height - 0.0) AndSlider:self.phoneExpectedFrequencySlider];
            
            blPhoneConfidenceLimits = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.phoneConfidenceLimitsSlider.frame.origin.x - self.phoneConfidenceLimitsSlider.frame.size.height - 2, self.phoneConfidenceLimitsSlider.frame.origin.y, self.phoneConfidenceLimitsSlider.frame.size.height - 0.0, self.phoneConfidenceLimitsSlider.frame.size.height - 0.0) AndSlider:self.phoneConfidenceLimitsSlider];
            brPhoneConfidenceLimits = [[ButtonRight alloc] initWithFrame:CGRectMake(self.phoneConfidenceLimitsSlider.frame.origin.x + self.phoneConfidenceLimitsSlider.frame.size.width + 5, self.phoneConfidenceLimitsSlider.frame.origin.y, self.phoneConfidenceLimitsSlider.frame.size.height - 0.0, self.phoneConfidenceLimitsSlider.frame.size.height - 0.0) AndSlider:self.phoneConfidenceLimitsSlider];
        }
        else
        {
            blPhoneExpectedFrequency = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.phoneExpectedFrequencySlider.frame.origin.x - self.phoneExpectedFrequencySlider.frame.size.height - 5, self.phoneExpectedFrequencySlider.frame.origin.y, self.phoneExpectedFrequencySlider.frame.size.height, self.phoneExpectedFrequencySlider.frame.size.height) AndSlider:self.phoneExpectedFrequencySlider];
            brPhoneExpectedFrequency = [[ButtonRight alloc] initWithFrame:CGRectMake(self.phoneExpectedFrequencySlider.frame.origin.x + self.phoneExpectedFrequencySlider.frame.size.width + 5, self.phoneExpectedFrequencySlider.frame.origin.y, self.phoneExpectedFrequencySlider.frame.size.height, self.phoneExpectedFrequencySlider.frame.size.height) AndSlider:self.phoneExpectedFrequencySlider];
            
            blPhoneConfidenceLimits = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.phoneConfidenceLimitsSlider.frame.origin.x - self.phoneConfidenceLimitsSlider.frame.size.height - 5, self.phoneConfidenceLimitsSlider.frame.origin.y, self.phoneConfidenceLimitsSlider.frame.size.height, self.phoneConfidenceLimitsSlider.frame.size.height) AndSlider:self.phoneConfidenceLimitsSlider];
            brPhoneConfidenceLimits = [[ButtonRight alloc] initWithFrame:CGRectMake(self.phoneConfidenceLimitsSlider.frame.origin.x + self.phoneConfidenceLimitsSlider.frame.size.width + 5, self.phoneConfidenceLimitsSlider.frame.origin.y, self.phoneConfidenceLimitsSlider.frame.size.height, self.phoneConfidenceLimitsSlider.frame.size.height) AndSlider:self.phoneConfidenceLimitsSlider];
        }
        [self.populationSurveyView addSubview:blPhoneExpectedFrequency];
        [self.populationSurveyView addSubview:brPhoneExpectedFrequency];
        [self.populationSurveyView addSubview:blPhoneConfidenceLimits];
        [self.populationSurveyView addSubview:brPhoneConfidenceLimits];
        
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
//        [tgr setNumberOfTapsRequired:2];
//        [tgr setNumberOfTouchesRequired:1];
//        [self.populationSurveyView addGestureRecognizer:tgr];
        
        [self.populationSurveyView setShowsVerticalScrollIndicator:NO];
        [self.populationSurveyView setShowsHorizontalScrollIndicator:NO];
        [self.populationSurveyView setShowsVerticalScrollIndicator:YES];
        [self.populationSurveyView setShowsHorizontalScrollIndicator:YES];

        [self.phoneExpectedFrequencySlider setMinimumTrackTintColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.phoneExpectedFrequencySlider setMaximumTrackTintColor:[UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1.0]];
        [self.phoneConfidenceLimitsSlider setMinimumTrackTintColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.phoneConfidenceLimitsSlider setMaximumTrackTintColor:[UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1.0]];

        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
        if (self.view.frame.size.height > 500)
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5Background.png"]];
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4Background.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, self.view.frame.size.height - 400.0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(-20, 20, 608, 533)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 468, 25, 488, 439)];
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
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            float viewLeftMargin = phoneResultsBlueBoxFrame.origin.x;
            [UIView animateWithDuration:0.3 animations:^{
                [phoneResultsView setFrame:CGRectMake(phoneInputsViewFrame.size.width - viewLeftMargin, phoneMainLabelFrame.origin.y, phoneResultsViewFrame.size.width, phoneResultsViewFrame.size.height)];
                if (hasAFirstResponder)
                    self.populationSurveyView.contentSize = phoneLandscapeWithKeyboardSize;
                else
                    self.populationSurveyView.contentSize = phoneLandscapeSize;
            }];
        }
    }
    //Re-size the zoomingView
    [zoomingView setFrame:CGRectMake(0, 0, [zoomingView sizeThatFits:self.view.frame.size].width, [zoomingView sizeThatFits:self.view.frame.size].height + 40)];
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/PopulationSSScreenPad.png" atomically:YES];
//    To here
}

- (IBAction)textFieldBecameFirstResponder:(id)sender
{
    if (hasAFirstResponder)
        return;
    
    hasAFirstResponder = YES;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        [UIView animateWithDuration:0.3 animations:^{
            float zs = [self.populationSurveyView zoomScale];
            [self.populationSurveyView setZoomScale:1.0 animated:YES];
            [self.populationSurveyView setContentSize:phoneLandscapeWithKeyboardSize];
            if (zs > 1)
                [self.populationSurveyView setZoomScale:zs animated:YES];
        }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (textField != self.designEffectField)
        {
            hasAFirstResponder = NO;
            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
                [UIView animateWithDuration:0.3 animations:^{
                    float zs = [self.populationSurveyView zoomScale];
                    [self.populationSurveyView setZoomScale:1.0 animated:YES];
                    [self.populationSurveyView setContentSize:phoneLandscapeSize];
                    if (zs > 1)
                        [self.populationSurveyView setZoomScale:zs animated:YES];
                }];
        }
    }
    [textField resignFirstResponder];
    if (textField == self.designEffectField)
        [self.clustersField becomeFirstResponder];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self compute:textField];
    return YES;
}

//Method to hide the keyboard on iPhone
- (void)resignAllFirstResponders
{
    [self.view endEditing:YES];
    hasAFirstResponder = NO;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        [UIView animateWithDuration:0.3 animations:^{
            float zs = [self.populationSurveyView zoomScale];
            [self.populationSurveyView setZoomScale:1.0 animated:YES];
            [self.populationSurveyView setContentSize:phoneLandscapeSize];
            if (zs > 1)
                [self.populationSurveyView setZoomScale:zs animated:YES];
        }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
- (IBAction)compute:(id)sender
{
    int populationSize = [self.populationSizeField.text intValue];
    double expectedFrequency = [self.expectedFrequencyField.text doubleValue];
    double confidenceLimits = [self.confidenceLimitsField.text doubleValue];
    double designEffect = [self.designEffectField.text doubleValue];
    int clusters = [self.clustersField.text intValue];
    
    if (YES)
    {
        PopulationSurveySampleSizeCompute *computer = [[PopulationSurveySampleSizeCompute alloc] init];
        int sizes[7];
        [computer CalculateSampleSizes:populationSize ExpectedFrequency:expectedFrequency ConfidenceLimit:confidenceLimits DesignEffect:designEffect NumberOfClusters:clusters ClusterSizes:sizes];
        self.clusterSize80.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[0]];
        self.clusterSize90.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[1]];
        self.clusterSize95.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[2]];
        self.clusterSize97.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[3]];
        self.clusterSize99.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[4]];
        self.clusterSize999.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[5]];
        self.clusterSize9999.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[6]];
        self.totalSample80.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[0] * (double)clusters];
        self.totalSample90.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[1] * (double)clusters];
        self.totalSample95.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[2] * (double)clusters];
        self.totalSample97.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[3] * (double)clusters];
        self.totalSample99.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[4] * (double)clusters];
        self.totalSample999.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[5] * (double)clusters];
        self.totalSample9999.text = [[NSString alloc] initWithFormat:@"%g", (double)sizes[6] * (double)clusters];
    }
}

- (IBAction)reset:(id)sender
{
    self.populationSizeField.text = [[NSString alloc] initWithFormat:@"999999"];
    self.expectedFrequencyField.text = [[NSString alloc] initWithFormat:@"50"];
    self.confidenceLimitsField.text = [[NSString alloc] initWithFormat:@"5"];
    self.designEffectField.text = [[NSString alloc] initWithFormat:@"1.0"];
    self.clustersField.text = [[NSString alloc] initWithFormat:@"1"];
    [self.expectedFrequencySlider setValue:50.0];
    [self.confidenceLimitsSlider setValue:5.0];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.phoneExpectedFrequencySlider setValue:50.0];
        [self.phoneConfidenceLimitsSlider setValue:5.0];
    }
    [[self expectedFrequencyStepper] setValue:50.0];
    [[self confidenceLimitStepper] setValue:5.0];
    [self compute:sender];
}

//iPad
-(IBAction) sliderChanged1:(id) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.view endEditing:YES];
        hasAFirstResponder = NO;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
            [UIView animateWithDuration:0.3 animations:^{
                [self.populationSurveyView setContentSize:phoneLandscapeSize];
            }];
    }
    
    UISlider *slider1 = (UISlider *) sender;
    float progressAsFloat = (float)(slider1.value );
    NSString *newText =[[NSString alloc]
                        initWithFormat:@"%0.1f",progressAsFloat];
    [self.expectedFrequencyStepper setValue:round(progressAsFloat * 10) / 10];
    self.sliderLabel1.text = newText;
    [self compute:sender];
    // [newText release];
}
-(IBAction) sliderChanged2:(id) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.view endEditing:YES];
        hasAFirstResponder = NO;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
            [UIView animateWithDuration:0.3 animations:^{
                [self.populationSurveyView setContentSize:phoneLandscapeSize];
            }];
    }
    
    UISlider *slider2 = (UISlider *) sender;
    float progressAsFloat = (float)(slider2.value );
    NSString *newText =[[NSString alloc]
                        initWithFormat:@"%0.1f",progressAsFloat];
    [self.confidenceLimitStepper setValue:round(progressAsFloat * 10) / 10];
    self.sliderLabel2.text = newText;
    [self compute:sender];
    // [newText release];
}

- (IBAction)stepperChanged1:(id)sender
{
    UIStepper *stepper = (UIStepper *) sender;
    double currentValue = [stepper value];
    [self.expectedFrequencySlider setValue:currentValue];
    self.sliderLabel1.text = [[NSString alloc] initWithFormat:@"%0.1f", currentValue];
    [self compute:sender];
}

- (IBAction)stepperChanged2:(id)sender
{
    UIStepper *stepper = (UIStepper *) sender;
    double currentValue = [stepper value];
    [self.confidenceLimitsSlider setValue:currentValue];
    self.sliderLabel2.text = [[NSString alloc] initWithFormat:@"%0.1f", currentValue];
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
        return;
    }
    
    NSCharacterSet *validSet; // = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
/*
    if (theTextField.tag == 1 && theTextField.text.length - [theTextField.text stringByReplacingOccurrencesOfString:@"." withString:@""].length < 2)
        validSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    
    if ([[theTextField.text substringWithRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
    {
        theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1) withString:@""];
    }
    else
        [self compute:sender];
*/    
    if (theTextField.tag == 1)
    {
        validSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
        for (int i = 0; i < theTextField.text.length; i++)
        {
            if ([[theTextField.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
                theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
            if ([theTextField.text characterAtIndex:i] == '.')
                validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        theTextField.text = [theTextField.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    else
    {
        validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < theTextField.text.length; i++)
        {
            if ([[theTextField.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
                theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
        }
        theTextField.text = [theTextField.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    [self compute:sender];
    
    UITextPosition *newPosition = [sender positionFromPosition:[sender endOfDocument] offset:cursorPosition];
    [sender setSelectedTextRange:[sender textRangeFromPosition:newPosition toPosition:newPosition]];
}

- (IBAction)resetBarButtonPressed:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.view endEditing:YES];
        hasAFirstResponder = NO;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
            [UIView animateWithDuration:0.3 animations:^{
                float zs = [self.populationSurveyView zoomScale];
                [self.populationSurveyView setZoomScale:1.0 animated:YES];
                [self.populationSurveyView setContentSize:phoneLandscapeSize];
                if (zs > 1)
                    [self.populationSurveyView setZoomScale:zs animated:YES];
            }];
    }

    [self reset:sender];
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
                
                [self.subView1 setFrame:CGRectMake(80, 13, 608, 533)];
                [self.subView2 setFrame:CGRectMake(140, 446, 488, 439)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, self.view.frame.size.height - 400.0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(-20, 20, 608, 533)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 468, 25, 488, 439)];
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
                [phoneResultsView setFrame:phoneResultsViewFrame];
                self.populationSurveyView.contentSize = phonePortraitSize;
             }];
        }
        else
        {
            float viewLeftMargin = phoneResultsBlueBoxFrame.origin.x;
            [UIView animateWithDuration:0.3 animations:^{
                [phoneResultsView setFrame:CGRectMake(phoneInputsViewFrame.size.width - viewLeftMargin, phoneMainLabelFrame.origin.y, phoneResultsViewFrame.size.width, phoneResultsViewFrame.size.height)];
                if (hasAFirstResponder)
                    self.populationSurveyView.contentSize = phoneLandscapeWithKeyboardSize;
                else
                    self.populationSurveyView.contentSize = phoneLandscapeSize;
            }];
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, [zoomingView sizeThatFits:self.view.frame.size].width, [zoomingView sizeThatFits:self.view.frame.size].height + 40)];
        
        [self.populationSurveyView setZoomScale:zs animated:YES];
    }
}

- (void)popCurrentViewController
{
    //Method for the custom "Back" button on the NavigationController
    [self.navigationController popViewControllerAnimated:YES];
}
@end
