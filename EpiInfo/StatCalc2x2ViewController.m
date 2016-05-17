//
//  StatCalc2x2ViewController.m
//  StatCalc2x2
//
//  Created by John Copeland on 9/7/12.
//

#import "StatCalc2x2ViewController.h"
#import "Twox2CalculatorView.h"
#import "Twox2Compute.h"
#import "Twox2StrataData.h"
#import "Twox2SummaryData.h"

@interface StatCalc2x2ViewController()
@property (nonatomic, weak) IBOutlet Twox2CalculatorView *twox2CalculatorView;
//@property (nonatomic) Twox2Compute *computer;
@end

@implementation StatCalc2x2ViewController

//@synthesize computer = _computer;
@synthesize yyString = _yyString;
@synthesize ynString = _ynString;
@synthesize nyString = _nyString;
@synthesize nnString = _nnString;
@synthesize yyField = _yyField;
@synthesize ynField = _ynField;
@synthesize nyField = _nyField;
@synthesize nnField = _nnField;
@synthesize orEstimate = _orEstimate;
@synthesize orLower = _orLower;
@synthesize orUpper = _orUpper;
@synthesize mleOR = _mleOR;
@synthesize mleLower = _mleLower;
@synthesize mleUpper = _mleUpper;
@synthesize fisherLower = _fisherLower;
@synthesize fisherUpper = _fisherUpper;
@synthesize rrEstimate = _rrEstimate;
@synthesize rrLower = _rrLower;
@synthesize rrUpper = _rrUpper;
@synthesize rdEstimate = _rdEstimate;
@synthesize rdLower = _rdLower;
@synthesize rdUpper = _rdUpper;
@synthesize uX2 = _uX2;
@synthesize uX2P = _uX2P;
@synthesize mhX2 = _mhX2;
@synthesize mhX2P = _mhX2P;
@synthesize cX2 = _cX2;
@synthesize cX2P = _cX2P;
@synthesize mpExact = _mpExact;
@synthesize fisherExact = _fisherExact;
@synthesize fisherExact2 = _fisherExact2;
@synthesize twox2CalculatorView = _twox2CalculatorView;
@synthesize phoneOutcomeLabel = _phoneOutcomeLabel;
@synthesize phoneExposureLabel = _phoneExposureLabel;

@synthesize computingAdjustedOR = _computingAdjustedOR;

@synthesize computeButton = _computeButton;
@synthesize clearButton = _clearButton;
@synthesize oddsBasedParametersLabel = _oddsBasedParametersLabel;
@synthesize oddsRatioLabel = _oddsRatioLabel;
@synthesize mleORLabel = _mleORLabel;
@synthesize riskBasedParametersLabel = _riskBasedParametersLabel;
@synthesize riskBasedEstimateLabel = _riskBasedEstimateLabel;
@synthesize riskBasedEstimateLowerLabel = _riskBasedEstimateLowerLabel;
@synthesize riskBasedEstimateUpperLabel = _riskBasedEstimateUpperLabel;
@synthesize relativeRiskLabel = _relativeRiskLabel;
@synthesize riskDifferenceLabel = _riskDifferenceLabel;
@synthesize statisticalTestsLabel = _statisticalTestsLabel;
@synthesize x2Label = _x2Label;
@synthesize twoTailedPLabel = _twoTailedPLabel;
@synthesize uncorrectedLabel = _uncorrectedLabel;
@synthesize mantelHaenszelLabel = _mantelHaenszelLabel;
@synthesize correctedLabel = _correctedLabel;
@synthesize oneTailedPLabel = _oneTailedPLabel;
@synthesize twoTailedPForExactTestsLabel = _twoTailedPForExactTestsLabel;
@synthesize midPExactLabel = _midPExactLabel;
@synthesize fisherExactLabel = _fisherExactLabel;

@synthesize stratum;


//ipad
@synthesize summaryView, strataView, ynView;
@synthesize crudeSEstimate, crudeSLower, crudeSUpper, adjustedSmleEstimate, adjustedSmleLower, adjustedSmleUpper, crudeSmleOR, crudeSmleLower, crudeSmleUpper, fisherSLower, fisherSUpper, adjustedSEstimate, adjustedSLower, adjustedSUpper, riskcrudeSEstimate, riskcrudeSLower, riskcrudeSUpper, riskadjSEstimate, riskadjcrudeSLower, riskadjSUpper, uSX2, uSX2P, mhSX2, mhSX2P;

@synthesize imageView1 = _imageView1;
@synthesize imageView2 = _imageView2;
//
- (int)stratum
{
    return stratum;
}
- (void)setStratum:(int)st
{
    stratum = st;
}

-(void)setTwox2CalculatorView:(Twox2CalculatorView *)twox2CalculatorView
{
    _twox2CalculatorView = twox2CalculatorView;
    self.twox2CalculatorView.minimumZoomScale = 1.0;
    self.twox2CalculatorView.maximumZoomScale = 2.0;
    self.twox2CalculatorView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomingView;
}

- (void)doubleTapAction
{
    if (self.twox2CalculatorView.zoomScale < 2.0)
        [self.twox2CalculatorView setZoomScale:2.0 animated:YES];
    else
        [self.twox2CalculatorView setZoomScale:1.0 animated:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.twox2CalculatorView setMinimumZoomScale:1.0];
    [self.twox2CalculatorView setMaximumZoomScale:5.0];
    [self.twox2CalculatorView setDelegate:self];
    return YES;
}

-(void)viewDidLoad
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
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
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
                [self setEdgesForExtendedLayout:UIRectEdgeNone];
            [[self navigationController] setTitle:@""];
        }
        fourInchPhone = (self.view.frame.size.height > 500);
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.twox2CalculatorView.frame.size.width, self.twox2CalculatorView.frame.size.height)];
        
        phoneOutcomeLabelFrame = CGRectMake(90, 40, 170, 14);
        phoneExposureLabelFrame = CGRectMake(30, 82, 59, 21);
        phoneYYFieldFrame = CGRectMake(77, 57, 60, 31);
        phoneYNFieldFrame = CGRectMake(213, 57, 60, 31);
        phoneNYFieldFrame = CGRectMake(77, 105, 60, 31);
        phoneNNFieldFrame = CGRectMake(213, 105, 60, 31);
        
        phoneInputsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 138)];
        [self.twox2CalculatorView addSubview:phoneInputsView];
        
        phoneOddsBasedParametersLabelFrame = CGRectMake(21, 181 - 32 - (181 - 34), 281, 21);
        phoneOREstimateLabelFrame = CGRectMake(115, 202 - 32 - (181 - 34), 51, 21);
        phoneORLowerLabelFrame = CGRectMake(185, 202 - 32 - (181 - 34), 42, 21);
        phoneORUpperLabelFrame = CGRectMake(250, 202 - 32 - (181 - 34), 42, 21);
        phoneOddsRatioLabelFrame = CGRectMake(21, 220 - 32 - (181 - 34), 89, 21);
        phoneOREstimateFrame = CGRectMake(115, 220 - 32 - (181 - 34), 42, 21);
        phoneORLowerFrame = CGRectMake(185, 220 - 32 - (181 - 34), 42, 21);
        phoneORUpperFrame = CGRectMake(250, 220 - 32 - (181 - 34), 42, 21);
        phoneMLEORLabelFrame = CGRectMake(21, 237 - 32 - (181 - 34), 89, 21);
        phoneMLEORFrame = CGRectMake(115, 237 - 32 - (181 - 34), 42, 21);
        phoneMLELowerFrame = CGRectMake(185, 237 - 32 - (181 - 34), 42, 21);
        phoneMLEUpperFrame = CGRectMake(250, 237 - 32 - (181 - 34), 42, 21);
        phoneFisherExactCILabelFrame = CGRectMake(21, 254 - 32 - (181 - 34), 89, 21);
        phoneFisherLowerFrame = CGRectMake(185, 254 - 32 - (181 - 34), 42, 21);
        phoneFisherUpperFrame = CGRectMake(250, 254 - 32 - (181 - 34), 42, 21);
        phoneAdjustedMHLabelFrame = CGRectMake(21, 272 - 32 - (181 - 34), 89, 21);
        phoneAdjustedMHEstimateFrame = CGRectMake(115, 272 - 32 - (181 - 34), 42, 21);
        phoneAdjustedMHLowerFrame = CGRectMake(185, 272 - 32 - (181 - 34), 42, 21);
        phoneAdjustedMHUpperFrame = CGRectMake(250, 272 - 32 - (181 - 34), 42, 21);
        phoneAdjustedMLELabelFrame = CGRectMake(21, 290 - 32 - (181 - 34), 89, 21);
        phoneAdjustedMLEEstimateFrame = CGRectMake(115, 290 - 32 - (181 - 34), 42, 21);
        phoneAdjustedMLELowerFrame = CGRectMake(185, 290 - 32 - (181 - 34), 42, 21);
        phoneAdjustedMLEUpperFrame = CGRectMake(250, 290 - 32 - (181 - 34), 42, 21);
        
        phoneOddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(0, 181 - 34, self.view.frame.size.width, 245 - (181 - 34) + 34)];
        [self.twox2CalculatorView addSubview:phoneOddsBasedParametersView];
        
        phoneRiskBasedParametersLabelFrame = CGRectMake(21, 283 - 32 - (283 - 34), 281, 21);
        phoneRiskEstimateLabelFrame = CGRectMake(115, 304 - 32 - (283 - 34), 51, 21);
        phoneRiskLowerLabelFrame = CGRectMake(185, 304 - 32 - (283 - 34), 42, 21);
        phoneRiskUpperLabelFrame = CGRectMake(250, 304 - 32 - (283 - 34), 42, 21);
        phoneRelativeRiskLabelFrame = CGRectMake(21, 322 - 32 - (283 - 34), 88, 21);
        phoneRREstimateFrame = CGRectMake(115, 322 - 32 - (283 - 34), 52, 21);
        phoneRRLowerFrame = CGRectMake(185, 322 - 32 - (283 - 34), 42, 21);
        phoneRRUpperFrame = CGRectMake(250, 322 - 32 - (283 - 34), 42, 21);
        phoneRiskDifferenceLabelFrame = CGRectMake(21, 339 - 32 - (283 - 34), 88, 21);
        phoneRDEstimateFrame = CGRectMake(115, 339 - 32 - (283 - 34), 51, 21);
        phoneRDLowerFrame = CGRectMake(185, 339 - 32 - (283 - 34), 42, 21);
        phoneRDUpperFrame = CGRectMake(250, 339 - 32 - (283 - 34), 42, 21);
        
        phoneRiskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(0, 286 - 34, self.view.frame.size.width, 330 - (283 - 34))];
        [self.twox2CalculatorView addSubview:phoneRiskBasedParametersView];
        
        phoneStatisticalTestsLabelFrame = CGRectMake(21, 369 - 32 - (369 - 34), 281, 21);
        phoneX2LabelFrame = CGRectMake(124, 390 - 32 - (369 - 34), 75, 21);
        phoneX2PLabelFrame = CGRectMake(227, 390 - 32 - (369 - 34), 75, 21);
        phoneUncorrectedLabelFrame = CGRectMake(21, 408 - 32 - (369 - 34), 112, 21);
        phoneUX2Frame = CGRectMake(124, 408 - 32 - (369 - 34), 75, 21);
        phoneUX2PFrame = CGRectMake(227, 408 - 32 - (369 - 34), 75, 21);
        phoneMantelHaenszelLabelFrame = CGRectMake(21, 425 - 32 - (369 - 34), 112, 21);
        phoneMHX2Frame = CGRectMake(124, 425 - 32 - (369 - 34), 75, 21);
        phoneMHX2PFrame = CGRectMake(227, 425 - 32 - (369 - 34), 75, 21);
        phoneCorrectedLabelFrame = CGRectMake(21, 444 - 32 - (369 - 34), 112, 21);
        phoneCX2Frame = CGRectMake(124, 444 - 32 - (369 - 34), 75, 21);
        phoneCX2PFrame = CGRectMake(227, 444 - 32 - (369 - 34), 75, 21);
        phone1TailedPLabelFrame = CGRectMake(124, 464 - 32 - (369 - 34), 75, 21);
        phone2TailedPLabelFrame = CGRectMake(227, 464 - 32 - (369 - 34), 75, 21);
        phoneMidPExactLabelFrame = CGRectMake(21, 482 - 32 - (369 - 34), 112, 21);
        phoneMPExactFrame = CGRectMake(124, 482 - 32 - (369 - 34), 75, 21);
        phoneFisherExactTestLabelFrame = CGRectMake(21, 501 - 32 - (369 - 34), 112, 21);
        phoneFisherExactFrame = CGRectMake(124, 501 - 32 - (369 - 34), 75, 21);
        phoneFisherExact2Frame = CGRectMake(227, 501 - 32 - (369 - 34), 75, 21);
        
        phoneStatisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(0, 374 - 34, self.view.frame.size.width, 491 - (369 - 34))];
        [self.twox2CalculatorView addSubview:phoneStatisticalTestsView];
    }
    
    scrollViewFrame = CGRectMake(43, 45, 768,977);
    computingFrame = [self.computingAdjustedOR frame];
    
    self.yyField.returnKeyType = UIReturnKeyNext;
    self.ynField.returnKeyType = UIReturnKeyNext;
    self.nyField.returnKeyType = UIReturnKeyNext;
    self.nnField.returnKeyType = UIReturnKeyDone;
    self.yyField.delegate = self;
    self.ynField.delegate = self;
    self.nyField.delegate = self;
    self.nnField.delegate = self;
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
    label.text = @"";
    self.navigationItem.titleView = label;
    //
    stratum = 0;
    Twox2StrataData *txt0 = [[Twox2StrataData alloc] init];
    Twox2StrataData *txt1 = [[Twox2StrataData alloc] init];
    Twox2StrataData *txt2 = [[Twox2StrataData alloc] init];
    Twox2StrataData *txt3 = [[Twox2StrataData alloc] init];
    Twox2StrataData *txt4 = [[Twox2StrataData alloc] init];
    strataData = [[NSArray alloc] initWithObjects:txt0, txt1, txt2, txt3, txt4, nil];

    NSArray *strataArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"Summary", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:strataArray];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [segmentedControl setWidth:40.0 forSegmentAtIndex:0];
        [segmentedControl setWidth:40.0 forSegmentAtIndex:1];
        [segmentedControl setWidth:40.0 forSegmentAtIndex:2];
        [segmentedControl setWidth:40.0 forSegmentAtIndex:3];
        [segmentedControl setWidth:40.0 forSegmentAtIndex:4];
        [segmentedControl setBounds:CGRectMake(160.0, 20.0, 320.0, 30.0)];
        [segmentedControl setCenter:CGPointMake(160.0, 15.0)];
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
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] != 2.0)
            for (UIView *v in self.subView1.subviews)
                if ([v isKindOfClass:[UIImageView class]])
                    [(UIImageView *)v setImage:[UIImage imageNamed:@"2x2TSmall"]];

        fadingColorView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [fadingColorView setImage:[UIImage imageNamed:@"iPadBackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        fadingColorView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, [self.view frame].size.height - 400.0, [self.view frame].size.width, 400.0)];
        [fadingColorView0 setImage:[UIImage imageNamed:@"FadeUpAndDown.png"]];
//        [self.view addSubview:fadingColorView0];
//        [self.view sendSubviewToBack:fadingColorView0];
       
        [segmentedControl setWidth:100.0 forSegmentAtIndex:0];
        [segmentedControl setWidth:100.0 forSegmentAtIndex:1];
        [segmentedControl setWidth:100.0 forSegmentAtIndex:2];
        [segmentedControl setWidth:100.0 forSegmentAtIndex:3];
        [segmentedControl setWidth:100.0 forSegmentAtIndex:4];
        [segmentedControl setBounds:CGRectMake(self.view.bounds.size.width / 2.0, 68.0, self.view.bounds.size.width, 50.0)];
        [segmentedControl setCenter:CGPointMake(self.view.bounds.size.width / 2.0, 68.0)];

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
            [self.lowerNavigationBar setBarTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
        }
    }
    [segmentedControl addTarget:self action:@selector(makeSegmentSelection:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSelectedSegmentIndex:0];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.twox2CalculatorView addSubview:segmentedControl];
    else
        [self.view addSubview:segmentedControl];
    
    adjustedMHLabel = [[UILabel alloc] initWithFrame:phoneAdjustedMHLabelFrame];
//    [adjustedMHLabel setCenter:CGPointMake([self.mleORLabel center].x, [self.mleORLabel center].y + 0.6 * [self.mleORLabel bounds].size.height)];
    [adjustedMHLabel setText:@"Adjusted (MH)"];
    [adjustedMHLabel setFont:[self.mleORLabel font]];
    [adjustedMHLabel setBackgroundColor:[UIColor clearColor]];
    [adjustedMHLabel setHidden:YES];
    [phoneOddsBasedParametersView addSubview:adjustedMHLabel];
    
    adjustedMLELabel = [[UILabel alloc] initWithFrame:phoneAdjustedMLELabelFrame];
//    [adjustedMLELabel setCenter:CGPointMake([self.mleORLabel center].x, [self.mleORLabel center].y + 1.5 * [self.mleORLabel bounds].size.height)];
    [adjustedMLELabel setText:@"Adjusted (MLE)"];
    [adjustedMLELabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
    [adjustedMLELabel setBackgroundColor:[UIColor clearColor]];
    [adjustedMLELabel setHidden:YES];
    [phoneOddsBasedParametersView addSubview:adjustedMLELabel];
    
    adjustedMHEstimate = [[UILabel alloc] initWithFrame:phoneAdjustedMHEstimateFrame];
//    [adjustedMHEstimate setCenter:CGPointMake([self.mleOR center].x, [self.mleOR center].y + 0.6 * [self.mleOR bounds].size.height)];
    [adjustedMHEstimate setFont:[self.mleOR font]];
    [adjustedMHEstimate setTextAlignment:NSTextAlignmentCenter];
    [adjustedMHEstimate setBackgroundColor:[UIColor clearColor]];
    [adjustedMHEstimate setHidden:YES];
    [phoneOddsBasedParametersView addSubview:adjustedMHEstimate];
    
    adjustedMHLower = [[UILabel alloc] initWithFrame:phoneAdjustedMHLowerFrame];
//    [adjustedMHLower setCenter:CGPointMake([self.mleLower center].x, [self.mleLower center].y + 0.6 * [self.mleLower bounds].size.height)];
    [adjustedMHLower setFont:[self.mleLower font]];
    [adjustedMHLower setTextAlignment:NSTextAlignmentCenter];
    [adjustedMHLower setBackgroundColor:[UIColor clearColor]];
    [adjustedMHLower setHidden:YES];
    [phoneOddsBasedParametersView addSubview:adjustedMHLower];
    
    adjustedMHUpper = [[UILabel alloc] initWithFrame:phoneAdjustedMHUpperFrame];
//    [adjustedMHUpper setCenter:CGPointMake([self.mleUpper center].x, [self.mleUpper center].y + 0.6 * [self.mleUpper bounds].size.height)];
    [adjustedMHUpper setFont:[self.mleUpper font]];
    [adjustedMHUpper setTextAlignment:NSTextAlignmentCenter];
    [adjustedMHUpper setBackgroundColor:[UIColor clearColor]];
    [adjustedMHUpper setHidden:YES];
    [phoneOddsBasedParametersView addSubview:adjustedMHUpper];
    
    adjustedMLEEstimate = [[UILabel alloc] initWithFrame:phoneAdjustedMLEEstimateFrame];
//    [adjustedMLEEstimate setCenter:CGPointMake([self.mleOR center].x, [self.mleOR center].y + 1.5 * [self.mleOR bounds].size.height)];
    [adjustedMLEEstimate setFont:[self.mleOR font]];
    [adjustedMLEEstimate setTextAlignment:NSTextAlignmentCenter];
    [adjustedMLEEstimate setBackgroundColor:[UIColor clearColor]];
    [adjustedMLEEstimate setHidden:YES];
    [phoneOddsBasedParametersView addSubview:adjustedMLEEstimate];
    
    adjustedMLELower = [[UILabel alloc] initWithFrame:phoneAdjustedMLELowerFrame];
//    [adjustedMLELower setCenter:CGPointMake([self.mleLower center].x, [self.mleLower center].y + 1.5 * [self.mleLower bounds].size.height)];
    [adjustedMLELower setFont:[self.mleLower font]];
    [adjustedMLELower setTextAlignment:NSTextAlignmentCenter];
    [adjustedMLELower setBackgroundColor:[UIColor clearColor]];
    [adjustedMLELower setHidden:YES];
    [phoneOddsBasedParametersView addSubview:adjustedMLELower];
    
    adjustedMLEUpper = [[UILabel alloc] initWithFrame:phoneAdjustedMLEUpperFrame];
//    [adjustedMLEUpper setCenter:CGPointMake([self.mleUpper center].x, [self.mleUpper center].y + 1.5 * [self.mleUpper bounds].size.height)];
    [adjustedMLEUpper setFont:[self.mleUpper font]];
    [adjustedMLEUpper setTextAlignment:NSTextAlignmentCenter];
    [adjustedMLEUpper setBackgroundColor:[UIColor clearColor]];
    [adjustedMLEUpper setHidden:YES];
    [phoneOddsBasedParametersView addSubview:adjustedMLEUpper];
    
    [self.computingAdjustedOR setHidden:YES];
    [self.computingAdjustedOR setFrame:CGRectMake([adjustedMLELower bounds].origin.x, [adjustedMLELower bounds].origin.y, [adjustedMLELower bounds].size.width - 15.0, [adjustedMLELower bounds].size.height - 15.0)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.computingAdjustedOR setCenter:CGPointMake(([adjustedMLEEstimate center].x + [adjustedMLELower center].x) / 2.0, [adjustedMLEEstimate center].y)];
    else
        [self.computingAdjustedOR setCenter:CGPointMake(([self.adjustedSmleEstimate center].x + [self.adjustedSmleLower center].x) / 2.0 + 43.0, [self.adjustedSmleLower center].y + 114.0)];
    [self.computingAdjustedOR setBackgroundColor:[UIColor clearColor]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        float x = 100.0;
        if (fourInchPhone)
            x = 0.0;
        self.twox2CalculatorView.contentSize = CGSizeMake(320, phoneStatisticalTestsView.frame.origin.y + phoneStatisticalTestsView.frame.size.height + x);
    }
    else
        self.twox2CalculatorView.contentSize = CGSizeMake(768, 1177);
    
    workerThread = [[NSThread alloc] initWithTarget:self selector:@selector(doSummaryStuff) object:nil];
    
//    [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    // Deprecation comment
    [segmentedControl setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.0]];
    [segmentedControl setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.0]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        blurryView = [BlurryView new];
        [blurryView setFrame:segmentedControl.frame];
        [self.view addSubview:blurryView];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            [blurryView setBlurTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6]];
        else
            [blurryView setBlurTintColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:203/255.0 alpha:0.6]];
        [blurryView.layer setCornerRadius:4.0];
        [self.view bringSubviewToFront:segmentedControl];
        [segmentedControl setBackgroundColor:[UIColor clearColor]];
    }
    
//    NSDictionary *segmentDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:18.0], UITextAttributeFont, [UIColor blackColor], UITextAttributeTextColor, nil];
    // Deprecation replacement
    NSDictionary *segmentDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:18.0], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    [segmentedControl setTitleTextAttributes:segmentDictionary forState:UIControlStateNormal];
//    NSDictionary *segmentSelectedDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:18.0], UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil];
    // Deprecation replacement
    NSDictionary *segmentSelectedDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:18.0], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [segmentedControl setTitleTextAttributes:segmentSelectedDictionary forState:UIControlStateHighlighted];
    
    NSArray *segs = [segmentedControl subviews];
    for (int i = 0; i < segs.count; i++)
    {
        UIView *v = (UIView*)[segs objectAtIndex:i];
        NSArray *subarr = [v subviews];
        for (int j = 0; j < subarr.count; j++)
        {
            if ([[subarr objectAtIndex:j] isKindOfClass:[UILabel class]])
            {
                UILabel *l = (UILabel*)[subarr objectAtIndex:j];
                if ([l.text isEqualToString:@"Summary"])
                {
                    summaryTabLines = l.numberOfLines;
                    summaryTabMode = l.lineBreakMode;
                    summaryTabFrame = l.frame;
                }
            }
        }
    }
    
    [self.subView2 sendSubviewToBack:self.imageView1];
    [self.subView4 sendSubviewToBack:self.imageView2];
    
    [self.twox2CalculatorView setScrollEnabled:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
        if (self.view.frame.size.height > 500)
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5BackgroundWhite.png"]];
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4BackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];

        [self.phoneOutcomeLabel setFrame:phoneOutcomeLabelFrame];
        [self.phoneExposureLabel setFrame:phoneExposureLabelFrame];
        [self.phoneExposureLabel setFrame:CGRectMake(self.phoneExposureLabel.frame.origin.x, self.phoneExposureLabel.frame.origin.y, self.phoneExposureLabel.frame.size.width, self.phoneExposureLabel.frame.size.height)];
        self.phoneExposureLabel.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.phoneExposureLabel setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
            [self.phoneOutcomeLabel setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
            [self.phoneExposureLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            [self.phoneOutcomeLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        }
        [self.yyField setFrame:phoneYYFieldFrame];
        [self.ynField setFrame:phoneYNFieldFrame];
        [self.nyField setFrame:phoneNYFieldFrame];
        [self.nnField setFrame:phoneNNFieldFrame];
        [phoneInputsView addSubview:self.phoneOutcomeLabel];
        [phoneInputsView addSubview:self.phoneExposureLabel];
        [phoneInputsView addSubview:self.yyField];
        [phoneInputsView addSubview:self.ynField];
        [phoneInputsView addSubview:self.nyField];
        [phoneInputsView addSubview:self.nnField];
        phoneInputsColorBoxBorder = 2.0;
        phoneInputsColorBox = [[UIView alloc] initWithFrame:CGRectMake(self.yyField.frame.origin.x - phoneInputsColorBoxBorder, self.yyField.frame.origin.y - phoneInputsColorBoxBorder, self.ynField.frame.origin.x + self.ynField.frame.size.width + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.x, self.nnField.frame.origin.y + self.nnField.frame.size.height + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.y)];
        [phoneInputsColorBox  setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
//        [phoneInputsColorBox  setBackgroundColor:[UIColor clearColor]];
        [phoneInputsColorBox.layer setCornerRadius:8.0];
        [phoneInputsView addSubview:phoneInputsColorBox];
        [phoneInputsView sendSubviewToBack:phoneInputsColorBox];
        BlurryView *blurryInputsView = [BlurryView new];
        [blurryInputsView setFrame:CGRectMake(0, 0, phoneInputsColorBox.frame.size.width, phoneInputsColorBox.frame.size.height)];
//        [phoneInputsColorBox addSubview:blurryInputsView];
        [blurryInputsView setBlurTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [blurryInputsView.layer setCornerRadius:8.0];
        
        [self.phoneOddsBasedParametersLabel setTextColor:[UIColor whiteColor]];
        [self.phoneOddsBasedParametersLabel setFrame:phoneOddsBasedParametersLabelFrame];
        [self.phoneOREstimateLabel setFrame:phoneOREstimateLabelFrame];
        [self.phoneORLowerLabel setFrame:phoneORLowerLabelFrame];
        [self.phoneORUpperLabel setFrame:phoneORUpperLabelFrame];
        [self.phoneOddsRatioLabel setFrame:phoneOddsRatioLabelFrame];
        [self.orEstimate setFrame:phoneOREstimateFrame];
        [self.orLower setFrame:phoneORLowerFrame];
        [self.orUpper setFrame:phoneORUpperFrame];
        [self.phoneMLEORLabel setFrame:phoneMLEORLabelFrame];
        [self.mleOR setFrame:phoneMLEORFrame];
        [self.mleLower setFrame:phoneMLELowerFrame];
        [self.mleUpper setFrame:phoneMLEUpperFrame];
        [self.phoneFisherExactCILabel setFrame:phoneFisherExactCILabelFrame];
        [self.fisherLower setFrame:phoneFisherLowerFrame];
        [self.fisherUpper setFrame:phoneFisherUpperFrame];
        [phoneOddsBasedParametersView addSubview:self.phoneOddsBasedParametersLabel];
        [phoneOddsBasedParametersView addSubview:self.phoneOREstimateLabel];
        [phoneOddsBasedParametersView addSubview:self.phoneORLowerLabel];
        [phoneOddsBasedParametersView addSubview:self.phoneORUpperLabel];
        [phoneOddsBasedParametersView addSubview:self.phoneOddsRatioLabel];
        [phoneOddsBasedParametersView addSubview:self.orEstimate];
        [phoneOddsBasedParametersView addSubview:self.orLower];
        [phoneOddsBasedParametersView addSubview:self.orUpper];
        [self.phoneMLEORLabel setAccessibilityLabel:@"M.L.E. Odds Ratio"];
        [phoneOddsBasedParametersView addSubview:self.phoneMLEORLabel];
        [phoneOddsBasedParametersView addSubview:self.mleOR];
        [phoneOddsBasedParametersView addSubview:self.mleLower];
        [phoneOddsBasedParametersView addSubview:self.mleUpper];
        [phoneOddsBasedParametersView addSubview:self.phoneFisherExactCILabel];
        [phoneOddsBasedParametersView addSubview:self.fisherLower];
        [phoneOddsBasedParametersView addSubview:self.fisherUpper];
        phoneOddsBasedParametersColorBox = [[UIView alloc] initWithFrame:CGRectMake(17, 0, self.orUpper.frame.origin.x + self.orUpper.frame.size.width - 3, phoneOddsBasedParametersView.frame.size.height - 36)];
        [phoneOddsBasedParametersColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneOddsBasedParametersColorBox.layer setCornerRadius:10.0];
        [phoneOddsBasedParametersView addSubview:phoneOddsBasedParametersColorBox];
        
        phoneOBPWhiteBox1 = [[UIView alloc] initWithFrame:CGRectMake(phoneOddsBasedParametersColorBox.frame.origin.x + 2, phoneOddsBasedParametersLabelFrame.size.height + phoneOddsBasedParametersLabelFrame.origin.y, 90, 17)];
        [phoneOBPWhiteBox1 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox1];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox1];
        
        phoneOBPWhiteBox2 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x + phoneOBPWhiteBox1.frame.size.width + 2, phoneOBPWhiteBox1.frame.origin.y, (phoneOddsBasedParametersColorBox.frame.size.width - phoneOBPWhiteBox1.frame.size.width - 6) / 3 - 1, 17)];
        [phoneOBPWhiteBox2 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox2];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox2];
        
        phoneOBPWhiteBox3 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox2.frame.origin.x + phoneOBPWhiteBox2.frame.size.width + 2, phoneOBPWhiteBox1.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 17)];
        [phoneOBPWhiteBox3 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox3];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox3];
        
        phoneOBPWhiteBox4 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox3.frame.origin.x + phoneOBPWhiteBox3.frame.size.width + 2, phoneOBPWhiteBox1.frame.origin.y, phoneOBPWhiteBox2.frame.size.width - 1, 17)];
        [phoneOBPWhiteBox4 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox4];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox4];
        
        phoneOBPWhiteBox5 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x, phoneOBPWhiteBox1.frame.origin.y + 19, phoneOBPWhiteBox1.frame.size.width, 16)];
        [phoneOBPWhiteBox5 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox5];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox5];
        
        phoneOBPWhiteBox6 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x + phoneOBPWhiteBox1.frame.size.width + 2, phoneOBPWhiteBox5.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox6 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox6];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox6];
        
        phoneOBPWhiteBox7 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox2.frame.origin.x + phoneOBPWhiteBox2.frame.size.width + 2, phoneOBPWhiteBox5.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox7 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox7];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox7];
        
        phoneOBPWhiteBox8 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox3.frame.origin.x + phoneOBPWhiteBox3.frame.size.width + 2, phoneOBPWhiteBox5.frame.origin.y, phoneOBPWhiteBox2.frame.size.width - 1, 16)];
        [phoneOBPWhiteBox8 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox8];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox8];
        
        phoneOBPWhiteBox9 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x, phoneOBPWhiteBox5.frame.origin.y + 18, phoneOBPWhiteBox1.frame.size.width, 16)];
        [phoneOBPWhiteBox9 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox9];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox9];
        
        phoneOBPWhiteBox10 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x + phoneOBPWhiteBox1.frame.size.width + 2, phoneOBPWhiteBox9.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox10 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox10];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox10];
        
        phoneOBPWhiteBox11 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox2.frame.origin.x + phoneOBPWhiteBox2.frame.size.width + 2, phoneOBPWhiteBox9.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox11 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox11];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox11];
        
        phoneOBPWhiteBox12 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox3.frame.origin.x + phoneOBPWhiteBox3.frame.size.width + 2, phoneOBPWhiteBox9.frame.origin.y, phoneOBPWhiteBox2.frame.size.width - 1, 16)];
        [phoneOBPWhiteBox12 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox12];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox12];
        
        phoneOBPWhiteBox13 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x, phoneOBPWhiteBox9.frame.origin.y + 18, phoneOBPWhiteBox1.frame.size.width, 16)];
        [phoneOBPWhiteBox13 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox13];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox13];
        [phoneOBPWhiteBox13 setHidden:YES];
        
        phoneOBPWhiteBox14 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x + phoneOBPWhiteBox1.frame.size.width + 2, phoneOBPWhiteBox13.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox14 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox14];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox14];
        [phoneOBPWhiteBox14 setHidden:YES];
        
        phoneOBPWhiteBox15 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox2.frame.origin.x + phoneOBPWhiteBox2.frame.size.width + 2, phoneOBPWhiteBox13.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox15 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox15];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox15];
        [phoneOBPWhiteBox15 setHidden:YES];
        
        phoneOBPWhiteBox16 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox3.frame.origin.x + phoneOBPWhiteBox3.frame.size.width + 2, phoneOBPWhiteBox13.frame.origin.y, phoneOBPWhiteBox2.frame.size.width - 1, 16)];
        [phoneOBPWhiteBox16 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox16];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox16];
        [phoneOBPWhiteBox16 setHidden:YES];
        
        phoneOBPWhiteBox17 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x, phoneOBPWhiteBox13.frame.origin.y + 18, phoneOBPWhiteBox1.frame.size.width, 16)];
        [phoneOBPWhiteBox17 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox17];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox17];
        [phoneOBPWhiteBox17 setHidden:YES];
        
        phoneOBPWhiteBox18 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x + phoneOBPWhiteBox1.frame.size.width + 2, phoneOBPWhiteBox17.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox18 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox18];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox18];
        [phoneOBPWhiteBox18 setHidden:YES];
        
        phoneOBPWhiteBox19 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox2.frame.origin.x + phoneOBPWhiteBox2.frame.size.width + 2, phoneOBPWhiteBox17.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox19 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox19];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox19];
        [phoneOBPWhiteBox19 setHidden:YES];
        
        phoneOBPWhiteBox20 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox3.frame.origin.x + phoneOBPWhiteBox3.frame.size.width + 2, phoneOBPWhiteBox17.frame.origin.y, phoneOBPWhiteBox2.frame.size.width - 1, 16)];
        [phoneOBPWhiteBox20 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox20];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox20];
        [phoneOBPWhiteBox20 setHidden:YES];
        
        phoneOBPBottomRowFrame1 = CGRectMake(phoneOBPWhiteBox1.frame.origin.x, phoneOBPWhiteBox9.frame.origin.y + 18, phoneOBPWhiteBox1.frame.size.width + 2 + phoneOBPWhiteBox2.frame.size.width + 2 + phoneOBPWhiteBox3.frame.size.width + 2 + phoneOBPWhiteBox4.frame.size.width, 16);
        
        phoneOBPBottomRowFrame2 = CGRectMake(phoneOBPWhiteBox1.frame.origin.x, phoneOBPWhiteBox17.frame.origin.y + 18, phoneOBPWhiteBox1.frame.size.width + 2 + phoneOBPWhiteBox2.frame.size.width + 2 + phoneOBPWhiteBox3.frame.size.width + 2 + phoneOBPWhiteBox4.frame.size.width, 16);
        
        phoneOBPBottomRow = [[UIView alloc] initWithFrame:phoneOBPBottomRowFrame1];
        [phoneOddsBasedParametersView addSubview:phoneOBPBottomRow];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPBottomRow];
        
        phoneOBPWhiteBox21 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, phoneOBPWhiteBox1.frame.size.width, 16)];
        [phoneOBPWhiteBox21 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPWhiteBox21.layer setCornerRadius:8.0];
        [phoneOBPBottomRow addSubview:phoneOBPWhiteBox21];
        phoneOBPExtraWhite1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, phoneOBPWhiteBox21.frame.size.width - 10, phoneOBPWhiteBox21.frame.size.height)];
        [phoneOBPExtraWhite1 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPBottomRow addSubview:phoneOBPExtraWhite1];
        [phoneOBPBottomRow sendSubviewToBack:phoneOBPExtraWhite1];
        phoneOBPExtraWhite3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 8)];
        [phoneOBPExtraWhite3 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPBottomRow addSubview:phoneOBPExtraWhite3];
        [phoneOBPBottomRow sendSubviewToBack:phoneOBPExtraWhite3];
        
        phoneOBPWhiteBox22 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.size.width + 2, 0, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox22 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPBottomRow addSubview:phoneOBPWhiteBox22];
        
        phoneOBPWhiteBox23 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox22.frame.origin.x + phoneOBPWhiteBox22.frame.size.width + 2, 0, phoneOBPWhiteBox2.frame.size.width, 16)];
        [phoneOBPWhiteBox23 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPBottomRow addSubview:phoneOBPWhiteBox23];
        
        phoneOBPWhiteBox24 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox23.frame.origin.x + phoneOBPWhiteBox23.frame.size.width + 2, 0, phoneOBPWhiteBox2.frame.size.width - 1, 16)];
        [phoneOBPWhiteBox24 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPWhiteBox24.layer setCornerRadius:8.0];
        [phoneOBPBottomRow addSubview:phoneOBPWhiteBox24];
        phoneOBPExtraWhite2 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox24.frame.origin.x, 0, 10, phoneOBPWhiteBox24.frame.size.height)];
        [phoneOBPExtraWhite2 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPBottomRow addSubview:phoneOBPExtraWhite2];
        [phoneOBPBottomRow sendSubviewToBack:phoneOBPExtraWhite2];
        phoneOBPExtraWhite4 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox24.frame.origin.x + 10, 0, phoneOBPWhiteBox24.frame.size.width - 10, 8)];
        [phoneOBPExtraWhite4 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPBottomRow addSubview:phoneOBPExtraWhite4];
        [phoneOBPBottomRow sendSubviewToBack:phoneOBPExtraWhite4];
        
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOddsBasedParametersColorBox];
        
        [self.phoneRiskBasedParametersLabel setTextColor:[UIColor whiteColor]];
        [self.phoneRiskBasedParametersLabel setFrame:phoneRiskBasedParametersLabelFrame];
        [self.phoneRiskEstimateLabel setFrame:phoneRiskEstimateLabelFrame];
        [self.phoneRiskLowerLabel setFrame:phoneRiskLowerLabelFrame];
        [self.phoneRiskUpperLabel setFrame:phoneRiskUpperLabelFrame];
        [self.phoneRelativeRiskLabel setFrame:phoneRelativeRiskLabelFrame];
        [self.rrEstimate setFrame:phoneRREstimateFrame];
        [self.rrLower setFrame:phoneRRLowerFrame];
        [self.rrUpper setFrame:phoneRRUpperFrame];
        [self.phoneRiskDifferenceLabel setFrame:phoneRiskDifferenceLabelFrame];
        [self.rdEstimate setFrame:phoneRDEstimateFrame];
        [self.rdLower setFrame:phoneRDLowerFrame];
        [self.rdUpper setFrame:phoneRDUpperFrame];
        [phoneRiskBasedParametersView addSubview:self.phoneRiskBasedParametersLabel];
        [phoneRiskBasedParametersView addSubview:self.phoneRiskEstimateLabel];
        [phoneRiskBasedParametersView addSubview:self.phoneRiskLowerLabel];
        [phoneRiskBasedParametersView addSubview:self.phoneRiskUpperLabel];
        [phoneRiskBasedParametersView addSubview:self.phoneRelativeRiskLabel];
        [phoneRiskBasedParametersView addSubview:self.rrEstimate];
        [phoneRiskBasedParametersView addSubview:self.rrLower];
        [phoneRiskBasedParametersView addSubview:self.rrUpper];
        [phoneRiskBasedParametersView addSubview:self.phoneRiskDifferenceLabel];
        [phoneRiskBasedParametersView addSubview:self.rdEstimate];
        [phoneRiskBasedParametersView addSubview:self.rdLower];
        [phoneRiskBasedParametersView addSubview:self.rdUpper];
        phoneRiskBasedParametersColorBox = [[UIView alloc] initWithFrame:CGRectMake(17, 0, self.rrUpper.frame.origin.x + self.rrUpper.frame.size.width - 3, phoneRiskBasedParametersView.frame.size.height - 3)];
        [phoneRiskBasedParametersColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneRiskBasedParametersColorBox.layer setCornerRadius:10.0];
        [phoneRiskBasedParametersView addSubview:phoneRiskBasedParametersColorBox];
        
        phoneRBPWhiteBox1 = [[UIView alloc] initWithFrame:CGRectMake(phoneRiskBasedParametersColorBox.frame.origin.x + 2, phoneRiskBasedParametersLabelFrame.size.height + phoneRiskBasedParametersLabelFrame.origin.y, 90, 17)];
        [phoneRBPWhiteBox1 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox1];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox1];
        
        phoneRBPWhiteBox2 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox1.frame.origin.x + phoneRBPWhiteBox1.frame.size.width + 2, phoneRBPWhiteBox1.frame.origin.y, (phoneRiskBasedParametersColorBox.frame.size.width - phoneRBPWhiteBox1.frame.size.width - 6) / 3 - 1, 17)];
        [phoneRBPWhiteBox2 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox2];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox2];
        
        phoneRBPWhiteBox3 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox2.frame.origin.x + phoneRBPWhiteBox2.frame.size.width + 2, phoneRBPWhiteBox1.frame.origin.y, phoneRBPWhiteBox2.frame.size.width, 17)];
        [phoneRBPWhiteBox3 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox3];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox3];
        
        phoneRBPWhiteBox4 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox3.frame.origin.x + phoneRBPWhiteBox3.frame.size.width + 2, phoneRBPWhiteBox1.frame.origin.y, phoneRBPWhiteBox2.frame.size.width - 1, 17)];
        [phoneRBPWhiteBox4 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox4];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox4];
        
        phoneRBPWhiteBox5 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox1.frame.origin.x, phoneRBPWhiteBox1.frame.origin.y + 19, phoneRBPWhiteBox1.frame.size.width, 16)];
        [phoneRBPWhiteBox5 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox5];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox5];
        
        phoneRBPWhiteBox6 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox1.frame.origin.x + phoneRBPWhiteBox1.frame.size.width + 2, phoneRBPWhiteBox5.frame.origin.y, phoneRBPWhiteBox2.frame.size.width, 16)];
        [phoneRBPWhiteBox6 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox6];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox6];
        
        phoneRBPWhiteBox7 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox2.frame.origin.x + phoneRBPWhiteBox2.frame.size.width + 2, phoneRBPWhiteBox5.frame.origin.y, phoneRBPWhiteBox2.frame.size.width, 16)];
        [phoneRBPWhiteBox7 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox7];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox7];
        
        phoneRBPWhiteBox8 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox3.frame.origin.x + phoneRBPWhiteBox3.frame.size.width + 2, phoneRBPWhiteBox5.frame.origin.y, phoneRBPWhiteBox2.frame.size.width - 1, 16)];
        [phoneRBPWhiteBox8 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox8];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox8];
        
        phoneRBPWhiteBox9 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox1.frame.origin.x, phoneRBPWhiteBox5.frame.origin.y + 18, phoneRBPWhiteBox1.frame.size.width, 16)];
        [phoneRBPWhiteBox9 setBackgroundColor:[UIColor whiteColor]];
        [phoneRBPWhiteBox9.layer setCornerRadius:8.0];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox9];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox9];
        phoneRBPExtraWhite1 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox9.frame.origin.x + 10, phoneRBPWhiteBox9.frame.origin.y, phoneRBPWhiteBox9.frame.size.width - 10, phoneRBPWhiteBox9.frame.size.height)];
        [phoneRBPExtraWhite1 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPExtraWhite1];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPExtraWhite1];
        phoneRBPExtraWhite3 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox9.frame.origin.x, phoneRBPWhiteBox9.frame.origin.y, 10, 8)];
        [phoneRBPExtraWhite3 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPExtraWhite3];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPExtraWhite3];
        
        phoneRBPWhiteBox10 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox1.frame.origin.x + phoneRBPWhiteBox1.frame.size.width + 2, phoneRBPWhiteBox9.frame.origin.y, phoneRBPWhiteBox2.frame.size.width, 16)];
        [phoneRBPWhiteBox10 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox10];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox10];
        
        phoneRBPWhiteBox11 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox2.frame.origin.x + phoneRBPWhiteBox2.frame.size.width + 2, phoneRBPWhiteBox9.frame.origin.y, phoneRBPWhiteBox2.frame.size.width, 16)];
        [phoneRBPWhiteBox11 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox11];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox11];
        
        phoneRBPWhiteBox12 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox3.frame.origin.x + phoneRBPWhiteBox3.frame.size.width + 2, phoneRBPWhiteBox9.frame.origin.y, phoneRBPWhiteBox2.frame.size.width - 1, 16)];
        [phoneRBPWhiteBox12 setBackgroundColor:[UIColor whiteColor]];
        [phoneRBPWhiteBox12.layer setCornerRadius:8.0];
        [phoneRiskBasedParametersView addSubview:phoneRBPWhiteBox12];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPWhiteBox12];
        phoneRBPExtraWhite2 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox12.frame.origin.x, phoneRBPWhiteBox12.frame.origin.y, 10, phoneRBPWhiteBox12.frame.size.height)];
        [phoneRBPExtraWhite2 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPExtraWhite2];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPExtraWhite2];
        phoneRBPExtraWhite4 = [[UIView alloc] initWithFrame:CGRectMake(phoneRBPWhiteBox12.frame.origin.x + 10, phoneRBPWhiteBox12.frame.origin.y, phoneOBPWhiteBox12.frame.size.width - 10, 8)];
        [phoneRBPExtraWhite4 setBackgroundColor:[UIColor whiteColor]];
        [phoneRiskBasedParametersView addSubview:phoneRBPExtraWhite4];
        [phoneRiskBasedParametersView sendSubviewToBack:phoneRBPExtraWhite4];

        [phoneRiskBasedParametersView sendSubviewToBack:phoneRiskBasedParametersColorBox];
        
        [self.phoneStatisticalTestsLabel setTextColor:[UIColor whiteColor]];
        [self.phoneStatisticalTestsLabel setFrame:phoneStatisticalTestsLabelFrame];
        [self.phoneX2Label setFrame:phoneX2LabelFrame];
        [self.phoneX2PLabel setFrame:phoneX2PLabelFrame];
        [self.phoneUncorrectedLabel setFrame:phoneUncorrectedLabelFrame];
        [self.uX2 setFrame:phoneUX2Frame];
        [self.uX2P setFrame:phoneUX2PFrame];
        [self.phoneMantelHaenszelLabel setFrame:phoneMantelHaenszelLabelFrame];
        [self.mhX2 setFrame:phoneMHX2Frame];
        [self.mhX2P setFrame:phoneMHX2PFrame];
        [self.phoneCorrectedLabel setFrame:phoneCorrectedLabelFrame];
        [self.cX2 setFrame:phoneCX2Frame];
        [self.cX2P setFrame:phoneCX2PFrame];
        [self.phone1TailedPLabel setFrame:phone1TailedPLabelFrame];
        [self.phone2TailedPLabel setFrame:phone2TailedPLabelFrame];
        [self.phoneMidPExactLabel setFrame:phoneMidPExactLabelFrame];
        [self.mpExact setFrame:phoneMPExactFrame];
        [self.phoneFisherExactTestLabel setFrame:phoneFisherExactTestLabelFrame];
        [self.fisherExact setFrame:phoneFisherExactFrame];
        [self.fisherExact2 setFrame:phoneFisherExact2Frame];
        [phoneStatisticalTestsView addSubview:self.phoneStatisticalTestsLabel];
        [self.phoneX2Label setAccessibilityLabel:@"Ky square"];
        [phoneStatisticalTestsView addSubview:self.phoneX2Label];
        [phoneStatisticalTestsView addSubview:self.phoneX2PLabel];
        [phoneStatisticalTestsView addSubview:self.phoneUncorrectedLabel];
        [phoneStatisticalTestsView addSubview:self.uX2];
        [phoneStatisticalTestsView addSubview:self.uX2P];
        [phoneStatisticalTestsView addSubview:self.phoneMantelHaenszelLabel];
        [phoneStatisticalTestsView addSubview:self.mhX2];
        [phoneStatisticalTestsView addSubview:self.mhX2P];
        [phoneStatisticalTestsView addSubview:self.phoneCorrectedLabel];
        [phoneStatisticalTestsView addSubview:self.cX2];
        [phoneStatisticalTestsView addSubview:self.cX2P];
        [phoneStatisticalTestsView addSubview:self.phone1TailedPLabel];
        [phoneStatisticalTestsView addSubview:self.phone2TailedPLabel];
        [phoneStatisticalTestsView addSubview:self.phoneMidPExactLabel];
        [phoneStatisticalTestsView addSubview:self.mpExact];
        [phoneStatisticalTestsView addSubview:self.phoneFisherExactTestLabel];
        [phoneStatisticalTestsView addSubview:self.fisherExact];
        [phoneStatisticalTestsView addSubview:self.fisherExact2];
        phoneStatisticalTestsColorBox = [[UIView alloc] initWithFrame:CGRectMake(17, 0, self.uX2P.frame.origin.x + self.uX2P.frame.size.width - 13, phoneStatisticalTestsView.frame.size.height)];
        [phoneStatisticalTestsColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneStatisticalTestsColorBox.layer setCornerRadius:10.0];
        [phoneStatisticalTestsView addSubview:phoneStatisticalTestsColorBox];
        
        float alteration = 12;
        phoneSTWhiteBox1 = [[UIView alloc] initWithFrame:CGRectMake(phoneStatisticalTestsColorBox.frame.origin.x + 2.0, 23, (phoneStatisticalTestsColorBox.frame.size.width - 8) / 3 + alteration, phoneOBPWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox1 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox1];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox1];
        
        phoneSTWhiteBox2 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox1.frame.origin.y, phoneSTWhiteBox1.frame.size.width - 1.5 * alteration, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox2 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox2];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox2];
        
        phoneSTWhiteBox3 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox1.frame.origin.y, phoneSTWhiteBox1.frame.size.width - 1.5 * alteration, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox3 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox3];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox3];
        
        phoneSTWhiteBox4 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox1.frame.origin.y + phoneSTWhiteBox1.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox4 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox4];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox4];
        
        phoneSTWhiteBox5 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox4.frame.origin.y, phoneSTWhiteBox2.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox5 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox5];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox5];
        
        phoneSTWhiteBox6 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox4.frame.origin.y, phoneSTWhiteBox3.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox6 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox6];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox6];
        
        phoneSTWhiteBox7 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox4.frame.origin.y + phoneSTWhiteBox4.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox7 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox7];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox7];
        
        phoneSTWhiteBox8 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox7.frame.origin.y, phoneSTWhiteBox2.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox8 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox8];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox8];
        
        phoneSTWhiteBox9 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox7.frame.origin.y, phoneSTWhiteBox3.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox9 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox9];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox9];
        
        phoneSTWhiteBox10 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox7.frame.origin.y + phoneSTWhiteBox7.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox10 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox10];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox10];
        
        phoneSTWhiteBox11 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox10.frame.origin.y, phoneSTWhiteBox2.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox11 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox11];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox11];
        
        phoneSTWhiteBox12 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox10.frame.origin.y, phoneSTWhiteBox3.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox12 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox12];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox12];
        
        phoneSTWhiteBox13 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox10.frame.origin.y + phoneSTWhiteBox10.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox13 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox13];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox13];
        
        phoneSTWhiteBox14 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox13.frame.origin.y, phoneSTWhiteBox2.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox14 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox14];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox14];
        
        phoneSTWhiteBox15 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox13.frame.origin.y, phoneSTWhiteBox3.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox15 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox15];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox15];
        
        phoneSTWhiteBox16 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox13.frame.origin.y + phoneSTWhiteBox13.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox16 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox16];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox16];
        
        phoneSTWhiteBox17 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox16.frame.origin.y, phoneSTWhiteBox2.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox17 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox17];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox17];
        
        phoneSTWhiteBox18 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox16.frame.origin.y, phoneSTWhiteBox3.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox18 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox18];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox18];
        
        phoneSTBottomRowFrame1 = CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox16.frame.origin.y + phoneSTWhiteBox16.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width + 2 + phoneSTWhiteBox2.frame.size.width + 2 + phoneSTWhiteBox3.frame.size.width, 16);
        
        phoneSTBottomRowFrame2 = CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox13.frame.origin.y + phoneSTWhiteBox13.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width + 2 + phoneSTWhiteBox2.frame.size.width + 2 + phoneSTWhiteBox3.frame.size.width, 16);
        
        phoneSTBottomRow = [[UIView alloc] initWithFrame:phoneSTBottomRowFrame1];
        [phoneStatisticalTestsView addSubview:phoneSTBottomRow];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTBottomRow];
        
        phoneSTWhiteBox19 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox19 setBackgroundColor:[UIColor whiteColor]];
        [phoneSTWhiteBox19.layer setCornerRadius:8.0];
        [phoneSTBottomRow addSubview:phoneSTWhiteBox19];
        phoneSTExtraWhite1 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox19.frame.origin.x + 10, phoneSTWhiteBox19.frame.origin.y, phoneSTWhiteBox19.frame.size.width - 10, phoneSTWhiteBox19.frame.size.height)];
        [phoneSTExtraWhite1 setBackgroundColor:[UIColor whiteColor]];
        [phoneSTBottomRow addSubview:phoneSTExtraWhite1];
        [phoneSTBottomRow sendSubviewToBack:phoneSTExtraWhite1];
        phoneSTExtraWhite3 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox19.frame.origin.x, phoneSTWhiteBox19.frame.origin.y, 10, 8)];
        [phoneSTExtraWhite3 setBackgroundColor:[UIColor whiteColor]];
        [phoneSTBottomRow addSubview:phoneSTExtraWhite3];
        [phoneSTBottomRow sendSubviewToBack:phoneSTExtraWhite3];
        
        phoneSTWhiteBox20 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.size.width + 2, 0, phoneSTWhiteBox2.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox20 setBackgroundColor:[UIColor whiteColor]];
        [phoneSTBottomRow addSubview:phoneSTWhiteBox20];
        
        phoneSTWhiteBox21 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox20.frame.origin.x + phoneSTWhiteBox20.frame.size.width + 2, 0, phoneSTWhiteBox3.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox21 setBackgroundColor:[UIColor whiteColor]];
        [phoneSTWhiteBox21.layer setCornerRadius:8.0];
        [phoneSTBottomRow addSubview:phoneSTWhiteBox21];
        phoneSTExtraWhite2 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox21.frame.origin.x, phoneSTWhiteBox21.frame.origin.y, 10, phoneSTWhiteBox21.frame.size.height)];
        [phoneSTExtraWhite2 setBackgroundColor:[UIColor whiteColor]];
        [phoneSTBottomRow addSubview:phoneSTExtraWhite2];
        [phoneSTBottomRow sendSubviewToBack:phoneSTExtraWhite2];
        phoneSTExtraWhite4 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox21.frame.origin.x + 10, phoneSTWhiteBox21.frame.origin.y, phoneSTWhiteBox21.frame.size.width - 10, 8)];
        [phoneSTExtraWhite4 setBackgroundColor:[UIColor whiteColor]];
        [phoneSTBottomRow addSubview:phoneSTExtraWhite4];
        [phoneSTBottomRow sendSubviewToBack:phoneSTExtraWhite4];

        [phoneStatisticalTestsView sendSubviewToBack:phoneStatisticalTestsColorBox];
        
        [self.view addSubview:segmentedControl];
        
        //Add everything to the zoomingView
        for (UIView *view in self.twox2CalculatorView.subviews)
        {
            [zoomingView addSubview:view];
            //Remove all struts and springs
            [view setAutoresizingMask:UIViewAutoresizingNone];
        }
        [self.twox2CalculatorView addSubview:zoomingView];
        
        //Add double-tap zooming
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
        [tgr setNumberOfTapsRequired:2];
        [tgr setNumberOfTouchesRequired:1];
        [self.twox2CalculatorView addGestureRecognizer:tgr];
        
        [self.twox2CalculatorView setShowsVerticalScrollIndicator:NO];
        [self.twox2CalculatorView setShowsHorizontalScrollIndicator:NO];
        [self.twox2CalculatorView setShowsVerticalScrollIndicator:YES];
        [self.twox2CalculatorView setShowsHorizontalScrollIndicator:YES];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            label.text = @"";
        }
        [self.yyField setAccessibilityLabel:@"Yes, yes"];
        [self.ynField setAccessibilityLabel:@"Yes, no"];
        [self.nyField setAccessibilityLabel:@"No, yes"];
        [self.nnField setAccessibilityLabel:@"No, no"];
    }
    else
    {
        [self.yyField setAccessibilityLabel:@"Yes, yes"];
        [self.ynField setAccessibilityLabel:@"Yes, no"];
        [self.nyField setAccessibilityLabel:@"No, yes"];
        [self.nnField setAccessibilityLabel:@"No, no"];
        
        int i = 0;
        for (UIView *v in [self.twox2CalculatorView subviews])
        {
            int j = 0;
            for (UIView *vi in [v subviews])
            {
                j++;
                if ([vi isKindOfClass:[UILabel class]])
                {
                    if ([[(UILabel *)vi text] isEqualToString:@"X2"])
                        [vi setAccessibilityLabel:@"Ky square"];
                    if ([[(UILabel *)vi text] isEqualToString:@"MLE OR"])
                        [vi setAccessibilityLabel:@"M.L.E. Odds Ratio"];
                }
            }
            i++;
        }
    }
    
    [self.clearButton setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[segmentedControl.subviews objectAtIndex:5] setTintColor:[UIColor blackColor]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -1, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 186.0, 37, 372, 311)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 643.0, 290, 643, 675)];
                [self.subView3 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 316.0, 20, 632, 632)];
                [self.subView4 setFrame:CGRectMake(20, 300, 388, 338)];
                
                [self.computingAdjustedOR setFrame:CGRectMake(self.view.frame.size.width / 2.0 - computingFrame.size.width / 2.0, self.view.frame.size.height / 2.0 - computingFrame.size.height / 2.0, computingFrame.size.width, computingFrame.size.height)];
                [segmentedControl setBounds:CGRectMake(self.view.bounds.size.width / 2.0, 68.0, self.view.bounds.size.height - 43.0, 50.0)];
                [segmentedControl setCenter:CGPointMake(self.view.bounds.size.width -25.0, self.view.frame.size.height / 2.0 + 21.0)];
                segmentedControl.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
                
                NSArray *segments = [segmentedControl subviews];
                for (int i = 0; i < segments.count; i++)
                {
                    UIView *v = (UIView*)[segments objectAtIndex:i];
                    NSArray *subarr = [v subviews];
                    for (int j = 0; j < subarr.count; j++)
                    {
                        if ([[subarr objectAtIndex:j] isKindOfClass:[UILabel class]])
                        {
                            UILabel *l = (UILabel*)[subarr objectAtIndex:j];
                            if ([l.text isEqualToString:@"Summary"])
                            {
                                [l setNumberOfLines:0];
                                [l setLineBreakMode:NSLineBreakByCharWrapping];
                                [l setFrame:CGRectMake(70, -50, 15, 150)];
                            }
                            l.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
                        }
                    }
                }
                
                [blurryView setFrame:segmentedControl.frame];
            }];
            
            [self.twox2CalculatorView setScrollEnabled:NO];
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
        [self.twox2CalculatorView setZoomScale:1.0 animated:YES];
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [segmentedControl setWidth:40.0 forSegmentAtIndex:0];
                [segmentedControl setWidth:40.0 forSegmentAtIndex:1];
                [segmentedControl setWidth:40.0 forSegmentAtIndex:2];
                [segmentedControl setWidth:40.0 forSegmentAtIndex:3];
                [segmentedControl setWidth:40.0 forSegmentAtIndex:4];
                [segmentedControl setBounds:CGRectMake(160.0, 20.0, 320.0, 30.0)];
                [segmentedControl setCenter:CGPointMake(160.0, 15.0)];
                [phoneInputsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 138)];
                [phoneOddsBasedParametersView setFrame:CGRectMake(0, 181 - 34, self.view.frame.size.width, 245 - (181 - 34) + 34)];
                [phoneRiskBasedParametersView setFrame:CGRectMake(0, 286 - 34, self.view.frame.size.width, 330 - (283 - 34))];
                if (stratum == 5)
                    [phoneRiskBasedParametersView setFrame:CGRectMake(0, 286, self.view.frame.size.width, 330 - (283 - 34))];
                [phoneStatisticalTestsView setFrame:CGRectMake(0, 374 - 34, self.view.frame.size.width, phoneStatisticalTestsView.frame.size.height)];
                if (stratum == 5)
                    [phoneStatisticalTestsView setFrame:CGRectMake(0, 374, self.view.frame.size.width, 488 - (369 - 34))];
                
                float x = 100.0;
                if (fourInchPhone)
                    x = 0.0;
                self.twox2CalculatorView.contentSize = CGSizeMake(320, phoneStatisticalTestsView.frame.origin.y + phoneStatisticalTestsView.frame.size.height + x);
            }];
            //Re-size the zoomingView
            if (fourInchPhone)
                [zoomingView setFrame:CGRectMake(0, 0, self.twox2CalculatorView.frame.size.width, self.twox2CalculatorView.frame.size.height)];
            else
                [zoomingView setFrame:CGRectMake(0, 0, self.twox2CalculatorView.frame.size.width, self.twox2CalculatorView.frame.size.height + 100)];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [segmentedControl setWidth:60.0 forSegmentAtIndex:0];
                [segmentedControl setWidth:60.0 forSegmentAtIndex:1];
                [segmentedControl setWidth:60.0 forSegmentAtIndex:2];
                [segmentedControl setWidth:60.0 forSegmentAtIndex:3];
                [segmentedControl setWidth:60.0 forSegmentAtIndex:4];
                [segmentedControl setBounds:CGRectMake(self.view.frame.size.width / 2.0, 20.0, self.view.frame.size.width, 30.0)];
                [segmentedControl setCenter:CGPointMake(self.view.frame.size.width / 2.0, 15.0)];
                [phoneInputsView setFrame:CGRectMake(-20, -8, self.view.frame.size.width, 138)];
                [phoneOddsBasedParametersView setFrame:CGRectMake(phoneStatisticalTestsView.frame.size.width + 20, 40, phoneOddsBasedParametersView.frame.size.width + 20, phoneOddsBasedParametersView.frame.size.height)];
                [phoneRiskBasedParametersView setFrame:CGRectMake(phoneOddsBasedParametersView.frame.origin.x, 45 + phoneOddsBasedParametersView.frame.size.height - 34, phoneRiskBasedParametersView.frame.size.width + 20, phoneRiskBasedParametersView.frame.size.height)];
                if (stratum == 5)
                    [phoneRiskBasedParametersView setFrame:CGRectMake(phoneOddsBasedParametersView.frame.origin.x, 45 + phoneOddsBasedParametersView.frame.size.height, phoneRiskBasedParametersView.frame.size.width + 20, phoneRiskBasedParametersView.frame.size.height)];
                [phoneStatisticalTestsView setFrame:CGRectMake(0, phoneInputsView.frame.size.height + 5, phoneStatisticalTestsView.frame.size.width + 20, phoneStatisticalTestsView.frame.size.height)];
                self.twox2CalculatorView.contentSize = CGSizeMake(phoneStatisticalTestsView.frame.size.width + phoneOddsBasedParametersView.frame.size.width, phoneInputsView.frame.size.height + phoneStatisticalTestsView.frame.size.height + 100);
                if (stratum == 5)
                    self.twox2CalculatorView.contentSize = CGSizeMake(phoneStatisticalTestsView.frame.size.width + phoneOddsBasedParametersView.frame.size.width, phoneInputsView.frame.size.height + phoneStatisticalTestsView.frame.size.height);
            }];
            
            [self.twox2CalculatorView setContentOffset:CGPointMake(0, 0) animated:YES];
            //Re-size the zoomingView
            [zoomingView setFrame:CGRectMake(0, 0, self.twox2CalculatorView.contentSize.width, self.twox2CalculatorView.contentSize.height)];
        }
    }
    fisherExactLabelFrame = self.fisherExactLabel.frame;
    fisherExact1Frame = self.fisherExact.frame;
    fisherExact2Frame = self.fisherExact2.frame;
    twoTailedPLabelFrame = self.phone2TailedPLabel.frame;
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/2x2ScreenPad.png" atomically:YES];
//    To here
}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([workerThread isExecuting])
        [workerThread cancel];
    if ([exactThread isExecuting])
        [exactThread cancel];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.yyField)
    {
        [self.ynField becomeFirstResponder];
    }
    else if (textField == self.ynField)
    {
        [self.nyField becomeFirstResponder];
    }
    else if (textField == self.nyField)
    {
        [self.nnField becomeFirstResponder];
    }
    return YES;
}

- (void)makeSegmentSelection:(UISegmentedControl *)event
{
    if ([exactThread isExecuting])
        [exactThread cancel];

    float zs = [self.twox2CalculatorView zoomScale];
    [self.twox2CalculatorView setZoomScale:1.0 animated:YES];
    [self.twox2CalculatorView setContentOffset:CGPointMake(0, 0) animated:YES];
    if ([self.yyField isFirstResponder])
        [self.yyField resignFirstResponder];
    else if ([self.ynField isFirstResponder])
        [self.ynField resignFirstResponder];
    else if ([self.nyField isFirstResponder])
        [self.nyField resignFirstResponder];
    else if ([self.nnField isFirstResponder])
        [self.nnField resignFirstResponder];
    
    for (int i = 0; i < [event.subviews count]; i++)
    {
        if ([[event.subviews objectAtIndex:i] isSelected])
        {
            [[event.subviews objectAtIndex:i] setTintColor:[UIColor blackColor]];
        }
        else
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
            {
                [[event.subviews objectAtIndex:i] setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
            }
            else
            {
                [[event.subviews objectAtIndex:i] setTintColor:[UIColor clearColor]];
            }
        }
    }
    
    if (stratum != 5 && [event selectedSegmentIndex] != 5 && NO)
        [self doCompute];
    if (stratum == 5)
    {
        [self.oddsBasedParametersLabel setText:@"Odds-based Parameters"];
        [self.oddsRatioLabel setText:@"Odds Ratio"];
        [self.mleORLabel setText:@"MLE OR"];
//        [self.riskBasedParametersLabel setCenter:CGPointMake([self.riskBasedParametersLabel center].x, [self.riskBasedParametersLabel center].y - 2.0 * [self.riskBasedParametersLabel bounds].size.height)];
        [self.riskBasedParametersLabel setText:@"Risk-based Parameters"];
//        [self.riskBasedEstimateLabel setCenter:CGPointMake([self.riskBasedEstimateLabel center].x, [self.riskBasedEstimateLabel center].y - 2.0 * [self.riskBasedEstimateLabel bounds].size.height)];
//        [self.riskBasedEstimateLowerLabel setCenter:CGPointMake([self.riskBasedEstimateLowerLabel center].x, [self.riskBasedEstimateLowerLabel center].y - 2.0 * [self.riskBasedEstimateLowerLabel bounds].size.height)];
//        [self.riskBasedEstimateUpperLabel setCenter:CGPointMake([self.riskBasedEstimateUpperLabel center].x, [self.riskBasedEstimateUpperLabel center].y - 2.0 * [self.riskBasedEstimateUpperLabel bounds].size.height)];
//        [self.relativeRiskLabel setCenter:CGPointMake([self.relativeRiskLabel center].x, [self.relativeRiskLabel center].y - 2.0 * [self.relativeRiskLabel bounds].size.height)];
        [self.relativeRiskLabel setText:@"Relative Risk"];
//        [self.rrEstimate setCenter:CGPointMake([self.rrEstimate center].x, [self.rrEstimate center].y - 2.0 * [self.rrEstimate bounds].size.height)];
//        [self.rrLower setCenter:CGPointMake([self.rrLower center].x, [self.rrLower center].y - 2.0 * [self.rrLower bounds].size.height)];
//        [self.rrUpper setCenter:CGPointMake([self.rrUpper center].x, [self.rrUpper center].y - 2.0 * [self.rrUpper bounds].size.height)];
//        [self.riskDifferenceLabel setCenter:CGPointMake([self.riskDifferenceLabel center].x, [self.riskDifferenceLabel center].y - 2.0 * [self.riskDifferenceLabel bounds].size.height)];
        [self.riskDifferenceLabel setText:@"Risk Difference"];
//        [self.rdEstimate setCenter:CGPointMake([self.rdEstimate center].x, [self.rdEstimate center].y - 2.0 * [self.rdEstimate bounds].size.height)];
//        [self.rdLower setCenter:CGPointMake([self.rdLower center].x, [self.rdLower center].y - 2.0 * [self.rdLower bounds].size.height)];
//        [self.rdUpper setCenter:CGPointMake([self.rdUpper center].x, [self.rdUpper center].y - 2.0 * [self.rdUpper bounds].size.height)];
//        [self.statisticalTestsLabel setCenter:CGPointMake([self.statisticalTestsLabel center].x, [self.statisticalTestsLabel center].y - 2.0 * [self.statisticalTestsLabel bounds].size.height)];
        [self.statisticalTestsLabel setText:@"Statistical Tests"];
//        [self.x2Label setCenter:CGPointMake([self.x2Label center].x, [self.x2Label center].y - 2.0 * [self.x2Label bounds].size.height)];
//        [self.twoTailedPLabel setCenter:CGPointMake([self.twoTailedPLabel center].x, [self.twoTailedPLabel center].y - 2.0 * [self.twoTailedPLabel bounds].size.height)];
//        [self.uncorrectedLabel setCenter:CGPointMake([self.uncorrectedLabel center].x, [self.uncorrectedLabel center].y - 2.0 * [self.uncorrectedLabel bounds].size.height)];
        [self.uncorrectedLabel setText:@"Uncorrected"];
//        [self.uX2 setCenter:CGPointMake([self.uX2 center].x, [self.uX2 center].y - 2.0 * [self.uX2 bounds].size.height)];
//        [self.uX2P setCenter:CGPointMake([self.uX2P center].x, [self.uX2P center].y - 2.0 * [self.uX2P bounds].size.height)];
//        [self.mantelHaenszelLabel setCenter:CGPointMake([self.mantelHaenszelLabel center].x, [self.mantelHaenszelLabel center].y - 2.0 * [self.mantelHaenszelLabel bounds].size.height)];
        [self.mantelHaenszelLabel setText:@"Mantel-Haenszel"];
//        [self.mhX2 setCenter:CGPointMake([self.mhX2 center].x, [self.mhX2 center].y - 2.0 * [self.mhX2 bounds].size.height)];
//        [self.mhX2P setCenter:CGPointMake([self.mhX2P center].x, [self.mhX2P center].y - 2.0 * [self.mhX2P bounds].size.height)];
        [self.correctedLabel setHidden:NO];
        [self.correctedLabel setText:@"Corrected"];
        [self.correctedLabel setAccessibilityLabel:@"Corrected"];
        [self.correctedLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    }
    
    [self clearAll];
    if ([event selectedSegmentIndex] != 5)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [phoneOddsBasedParametersColorBox setFrame:CGRectMake(phoneOddsBasedParametersColorBox.frame.origin.x, phoneOddsBasedParametersColorBox.frame.origin.y, phoneOddsBasedParametersColorBox.frame.size.width, 245 - (181 - 32))];
                    [phoneRiskBasedParametersView setFrame:CGRectMake(0, 286 - 34, self.view.frame.size.width, 330 - (283 - 34))];
                    [phoneStatisticalTestsView setFrame:CGRectMake(0, 374 - 34, self.view.frame.size.width, 491 - (369 - 34))];
                    if (stratum == 5)
                        [phoneOddsBasedParametersView setFrame:CGRectMake(phoneOddsBasedParametersView.frame.origin.x, phoneOddsBasedParametersView.frame.origin.y + 8, phoneOddsBasedParametersView.frame.size.width, phoneOddsBasedParametersView.frame.size.height)];
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [phoneOddsBasedParametersColorBox setFrame:CGRectMake(phoneOddsBasedParametersColorBox.frame.origin.x, phoneOddsBasedParametersColorBox.frame.origin.y, phoneOddsBasedParametersColorBox.frame.size.width, 245 - (181 - 32))];
                    [phoneRiskBasedParametersView setFrame:CGRectMake(phoneOddsBasedParametersView.frame.origin.x, 45 + phoneOddsBasedParametersView.frame.size.height - 34, phoneRiskBasedParametersView.frame.size.width, phoneRiskBasedParametersView.frame.size.height)];
                    [phoneStatisticalTestsView setFrame:CGRectMake(0, phoneInputsView.frame.size.height + 5, phoneStatisticalTestsView.frame.size.width, 156)];
                    self.twox2CalculatorView.contentSize = CGSizeMake(phoneStatisticalTestsView.frame.size.width + phoneOddsBasedParametersView.frame.size.width, phoneInputsView.frame.size.height + phoneStatisticalTestsView.frame.size.height + 100);
                }];
            }
            [UIView animateWithDuration:0.3 animations:^{
                [phoneStatisticalTestsColorBox setFrame:CGRectMake(17, 0, self.uX2P.frame.origin.x + self.uX2P.frame.size.width - 13, phoneStatisticalTestsView.frame.size.height)];
                [phoneOBPWhiteBox13 setHidden:YES];
                [phoneOBPWhiteBox14 setHidden:YES];
                [phoneOBPWhiteBox15 setHidden:YES];
                [phoneOBPWhiteBox16 setHidden:YES];
                [phoneOBPWhiteBox17 setHidden:YES];
                [phoneOBPWhiteBox18 setHidden:YES];
                [phoneOBPWhiteBox19 setHidden:YES];
                [phoneOBPWhiteBox20 setHidden:YES];
                [phoneOBPBottomRow setFrame:phoneOBPBottomRowFrame1];
                [phoneSTWhiteBox7 setHidden:NO];
                [phoneSTWhiteBox8 setHidden:NO];
                [phoneSTWhiteBox9 setHidden:NO];
                [phoneSTWhiteBox10 setHidden:NO];
                [phoneSTWhiteBox11 setHidden:NO];
                [phoneSTWhiteBox12 setHidden:NO];
                [phoneSTWhiteBox13 setHidden:NO];
                [phoneSTWhiteBox14 setHidden:NO];
                [phoneSTWhiteBox15 setHidden:NO];
                [phoneSTWhiteBox16 setHidden:NO];
                [phoneSTWhiteBox17 setHidden:NO];
                [phoneSTWhiteBox18 setHidden:NO];
                [phoneSTBottomRow setFrame:phoneSTBottomRowFrame1];
            }];
            [self.twox2CalculatorView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
            [self.twox2CalculatorView setScrollEnabled:YES];
        [self.computingAdjustedOR setHidden:YES];
        if ([self.computingAdjustedOR isAnimating])
            [self.computingAdjustedOR stopAnimating];
        
        if ([workerThread isExecuting])
            [workerThread cancel];
        if ([timeConsumingCrudeThread isExecuting])
            [timeConsumingCrudeThread cancel];
        if ([exactThread isExecuting])
            [exactThread cancel];
        if (stratum != [event selectedSegmentIndex])
        {
            //iPad
            [self.summaryView setHidden:YES];
            [self.strataView setHidden:NO];
            [self.ynView setHidden:NO];
            [self.subView4 setHidden:NO];
            //
            
            [self.yyField setEnabled:YES];
            [self.ynField setEnabled:YES];
            [self.nyField setEnabled:YES];
            [self.nnField setEnabled:YES];
//            [self.computeButton setHidden:NO];
//            [self.clearButton setHidden:NO];
            [adjustedMHLabel setHidden:YES];
            [adjustedMLELabel setHidden:YES];
            [adjustedMHEstimate setText:@""];
            [adjustedMHEstimate setHidden:YES];
            [adjustedMHLower setText:@""];
            [adjustedMHLower setHidden:YES];
            [adjustedMHUpper setText:@""];
            [adjustedMHUpper setHidden:YES];
            [adjustedMLEEstimate setText:@""];
            [adjustedMLEEstimate setHidden:YES];
            [adjustedMLELower setText:@""];
            [adjustedMLELower setHidden:YES];
            [adjustedMLEUpper setText:@""];
            [adjustedMLEUpper setHidden:YES];
            [self.oneTailedPLabel setHidden:NO];
            [self.twoTailedPForExactTestsLabel setHidden:NO];
            [self.midPExactLabel setHidden:NO];
            [self.midPExactLabel setText:@"Mid P Exact"];
            [self.midPExactLabel setAccessibilityLabel:@"Mid P Exact"];
            [self.midPExactLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
            [self.fisherExactLabel setHidden:NO];
            [self.fisherExactLabel setText:@"Fisher Exact"];
            [self.fisherExactLabel setAccessibilityLabel:@"Fisher Exact"];
            [self.fisherExactLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
            [self.phone2TailedPLabel setText:@"2 Tailed P"];
            [self.phone2TailedPLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
            
            if (fisherExactLabelFrame.size.width > 0)
            {
                [self.fisherExactLabel setFrame:fisherExactLabelFrame];
                [self.fisherExact setFrame:fisherExact1Frame];
                [self.fisherExact2 setFrame:fisherExact2Frame];
                [self.phone2TailedPLabel setFrame:twoTailedPLabelFrame];
            }
            
            stratum = [event selectedSegmentIndex];
            
            if ([strataData[stratum] hasData])
            {
                if ([strataData[stratum] yyHasValue]) self.yyField.text = [[NSString alloc] initWithFormat:@"%d", [strataData[stratum] yy]];
                if ([strataData[stratum] ynHasValue]) self.ynField.text = [[NSString alloc] initWithFormat:@"%d", [strataData[stratum] yn]];
                if ([strataData[stratum] nyHasValue]) self.nyField.text = [[NSString alloc] initWithFormat:@"%d", [strataData[stratum] ny]];
                if ([strataData[stratum] nnHasValue]) self.nnField.text = [[NSString alloc] initWithFormat:@"%d", [strataData[stratum] nn]];
            }
            if ([strataData[stratum] hasStatistics])
            {
                self.orEstimate.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelor]];
                self.orLower.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelorLower]];
                self.orUpper.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelorUpper]];
                self.mleOR.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelmleOR]];
                self.mleLower.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelmleORLower]];
                self.mleUpper.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelmleORUpper]];
                self.fisherLower.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelfisherORLower]];
                self.fisherUpper.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelfisherORUpper]];
                self.rrEstimate.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelrr]];
                self.rrLower.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelrrLower]];
                self.rrUpper.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelrrUpper]];
                self.rdEstimate.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelrd]];
                self.rdLower.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelrdLower]];
                self.rdUpper.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelrdUpper]];
                self.uX2.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelx2]];
                self.uX2P.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelx2p]];
                self.mhX2.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelmhx2]];
                self.mhX2P.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelmhx2p]];
                self.cX2.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelcx2]];
                self.cX2P.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelcx2p]];
                self.mpExact.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelmidP]];
                self.fisherExact.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelfisherExact1]];
                self.fisherExact2.text = [[NSString alloc] initWithFormat:@"%g", [strataData[stratum] modelfisherExact2]];
                
                if (isnan([strataData[stratum] modelmleORLower]))
                    [self.mleLower setText:@"?"];
                if (isnan([strataData[stratum] modelmleORUpper]))
                    [self.mleUpper setText:@"?"];
                if (isnan([strataData[stratum] modelfisherORLower]))
                    [self.fisherLower setText:@"?"];
                if (isnan([strataData[stratum] modelfisherORUpper]))
                    [self.fisherUpper setText:@"?"];
            }
        }
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [phoneOddsBasedParametersColorBox setFrame:CGRectMake(phoneOddsBasedParametersColorBox.frame.origin.x, phoneOddsBasedParametersColorBox.frame.origin.y, phoneOddsBasedParametersColorBox.frame.size.width, 245 - (181 - 34) + 34)];
                    [phoneOddsBasedParametersView setFrame:CGRectMake(phoneOddsBasedParametersView.frame.origin.x, phoneOddsBasedParametersView.frame.origin.y - 8, phoneOddsBasedParametersView.frame.size.width, phoneOddsBasedParametersView.frame.size.height)];
                    [phoneRiskBasedParametersView setFrame:CGRectMake(0, 286 - 12, self.view.frame.size.width, 330 - (283 - 34))];
                    [phoneStatisticalTestsView setFrame:CGRectMake(0, 374 - 19, self.view.frame.size.width, 488 - (369 - 34))];
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [phoneOddsBasedParametersColorBox setFrame:CGRectMake(phoneOddsBasedParametersColorBox.frame.origin.x, phoneOddsBasedParametersColorBox.frame.origin.y, phoneOddsBasedParametersColorBox.frame.size.width, 245 - (181 - 34) + 34)];
                    [phoneRiskBasedParametersView setFrame:CGRectMake(phoneOddsBasedParametersView.frame.origin.x, 45 + phoneOddsBasedParametersView.frame.size.height, phoneRiskBasedParametersView.frame.size.width, phoneRiskBasedParametersView.frame.size.height)];
                    [phoneStatisticalTestsView setFrame:CGRectMake(0, phoneInputsView.frame.size.height + 5 - 12, phoneStatisticalTestsView.frame.size.width, phoneStatisticalTestsView.frame.size.height)];
                    self.twox2CalculatorView.contentSize = CGSizeMake(phoneStatisticalTestsView.frame.size.width + phoneOddsBasedParametersView.frame.size.width, phoneInputsView.frame.size.height + phoneStatisticalTestsView.frame.size.height);
                }];
            }
            [UIView animateWithDuration:0.3 animations:^{
                [phoneStatisticalTestsColorBox setFrame:CGRectMake(17, 0, self.uX2P.frame.origin.x + self.uX2P.frame.size.width - 13, phoneMantelHaenszelLabelFrame.origin.y + phoneMantelHaenszelLabelFrame.size.height + 1 + 19 * 3)];
                [phoneOBPWhiteBox13 setHidden:NO];
                [phoneOBPWhiteBox14 setHidden:NO];
                [phoneOBPWhiteBox15 setHidden:NO];
                [phoneOBPWhiteBox16 setHidden:NO];
                [phoneOBPWhiteBox17 setHidden:NO];
                [phoneOBPWhiteBox18 setHidden:NO];
                [phoneOBPWhiteBox19 setHidden:NO];
                [phoneOBPWhiteBox20 setHidden:NO];
                [phoneOBPBottomRow setFrame:phoneOBPBottomRowFrame2];
                [phoneSTWhiteBox7 setHidden:NO];
                [phoneSTWhiteBox8 setHidden:NO];
                [phoneSTWhiteBox9 setHidden:NO];
                [phoneSTWhiteBox10 setHidden:NO];
                [phoneSTWhiteBox11 setHidden:NO];
                [phoneSTWhiteBox12 setHidden:NO];
                [phoneSTWhiteBox13 setHidden:NO];
                [phoneSTWhiteBox14 setHidden:NO];
                [phoneSTWhiteBox15 setHidden:NO];
                [phoneSTWhiteBox16 setHidden:YES];
                [phoneSTWhiteBox17 setHidden:YES];
                [phoneSTWhiteBox18 setHidden:YES];
                [phoneSTBottomRow setFrame:phoneSTBottomRowFrame2];
            }];
            [self.twox2CalculatorView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self.twox2CalculatorView setScrollEnabled:NO];
        if (stratum != [event selectedSegmentIndex])
        {
            //iPad
            [self.summaryView setHidden:NO];
            [self.strataView setHidden:YES];
            [self.ynView setHidden:YES];
            [self.subView4 setHidden:YES];
            //
            stratum = [event selectedSegmentIndex];
            [self.yyField setEnabled:NO];
            [self.ynField setEnabled:NO];
            [self.nyField setEnabled:NO];
            [self.nnField setEnabled:NO];
            [self.computeButton setHidden:YES];
            [self.clearButton setHidden:YES];
            [adjustedMHLabel setHidden:NO];
            [adjustedMLELabel setHidden:NO];
            [adjustedMHEstimate setHidden:NO];
            [adjustedMHLower setHidden:NO];
            [adjustedMHUpper setHidden:NO];
            [adjustedMLEEstimate setHidden:NO];
            [adjustedMLELower setHidden:NO];
            [adjustedMLEUpper setHidden:NO];
            [self.oneTailedPLabel setHidden:YES];
//            [self.twoTailedPForExactTestsLabel setHidden:YES];
//            [self.midPExactLabel setHidden:YES];
            [self.midPExactLabel setText:@"Breslow-Day RR"];
            [self.midPExactLabel setAccessibilityLabel:@"Breslow Day Risk Ratio"];
            [self.midPExactLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
//            [self.fisherExactLabel setHidden:YES];
            [self.fisherExactLabel setText:@"Breslow-Day OR"];
            [self.fisherExactLabel setAccessibilityLabel:@"Breslow Day Odds Ratio"];
            [self.fisherExactLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
            [self.fisherExactLabel setFrame:CGRectMake(self.fisherExactLabel.frame.origin.x, self.oneTailedPLabel.frame.origin.y, self.fisherExactLabel.frame.size.width, self.fisherExactLabel.frame.size.height)];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                [self.fisherExact setFrame:CGRectMake(self.fisherExact.frame.origin.x, self.oneTailedPLabel.frame.origin.y, self.fisherExact.frame.size.width, self.fisherExact.frame.size.height)];
                [self.fisherExact2 setFrame:CGRectMake(self.fisherExact2.frame.origin.x, self.oneTailedPLabel.frame.origin.y, self.fisherExact2.frame.size.width, self.fisherExact2.frame.size.height)];
            }
            [self.phone2TailedPLabel setText:@""];
            [self.phone2TailedPLabel setFont:[UIFont systemFontOfSize:12.0]];
            [self.phone2TailedPLabel setFrame:CGRectMake(self.phone2TailedPLabel.frame.origin.x, self.mpExact.frame.origin.y + 2, self.phone2TailedPLabel.frame.size.width, self.phone2TailedPLabel.frame.size.height)];

            self.crudeSEstimate.text = [[NSString alloc] initWithFormat:@""];
            self.crudeSLower.text = [[NSString alloc] initWithFormat:@""];
            self.crudeSUpper.text = [[NSString alloc] initWithFormat:@""];
            self.crudeSmleOR.text = [[NSString alloc] initWithFormat:@""];
            self.crudeSmleLower.text = [[NSString alloc] initWithFormat:@""];
            self.crudeSmleUpper.text = [[NSString alloc] initWithFormat:@""];
            self.fisherSLower.text = [[NSString alloc] initWithFormat:@""];
            self.fisherSUpper.text = [[NSString alloc] initWithFormat:@""];
            self.adjustedSEstimate.text = [[NSString alloc] initWithFormat:@""];
            self.adjustedSLower.text = [[NSString alloc] initWithFormat:@""];
            self.adjustedSUpper.text = [[NSString alloc] initWithFormat:@""];
            self.riskcrudeSEstimate.text = [[NSString alloc] initWithFormat:@""];
            self.riskcrudeSLower.text = [[NSString alloc] initWithFormat:@""];
            self.riskcrudeSUpper.text = [[NSString alloc] initWithFormat:@""];
            self.riskadjSEstimate.text = [[NSString alloc] initWithFormat:@""];
            self.riskadjcrudeSLower.text = [[NSString alloc] initWithFormat:@""];
            self.riskadjSUpper.text = [[NSString alloc] initWithFormat:@""];
            self.uSX2.text = [[NSString alloc] initWithFormat:@""];
            self.uSX2P.text = [[NSString alloc] initWithFormat:@""];
            self.mhSX2.text = [[NSString alloc] initWithFormat:@""];
            self.mhSX2P.text = [[NSString alloc] initWithFormat:@""];
            
            [self.oddsBasedParametersLabel setText:@"Odds Ratio"];
            [self.oddsRatioLabel setText:@"Crude"];
            [self.mleORLabel setText:@"Crude (MLE)"];
//            [self.riskBasedParametersLabel setCenter:CGPointMake([self.riskBasedParametersLabel center].x, [self.riskBasedParametersLabel center].y + 2.0 * [self.riskBasedParametersLabel bounds].size.height)];
            [self.riskBasedParametersLabel setText:@"Relative Risk"];
//            [self.riskBasedEstimateLabel setCenter:CGPointMake([self.riskBasedEstimateLabel center].x, [self.riskBasedEstimateLabel center].y + 2.0 * [self.riskBasedEstimateLabel bounds].size.height)];
//            [self.riskBasedEstimateLowerLabel setCenter:CGPointMake([self.riskBasedEstimateLowerLabel center].x, [self.riskBasedEstimateLowerLabel center].y + 2.0 * [self.riskBasedEstimateLowerLabel bounds].size.height)];
//            [self.riskBasedEstimateUpperLabel setCenter:CGPointMake([self.riskBasedEstimateUpperLabel center].x, [self.riskBasedEstimateUpperLabel center].y + 2.0 * [self.riskBasedEstimateUpperLabel bounds].size.height)];
//            [self.relativeRiskLabel setCenter:CGPointMake([self.relativeRiskLabel center].x, [self.relativeRiskLabel center].y + 2.0 * [self.relativeRiskLabel bounds].size.height)];
            [self.relativeRiskLabel setText:@"Crude"];
//            [self.rrEstimate setCenter:CGPointMake([self.rrEstimate center].x, [self.rrEstimate center].y + 2.0 * [self.rrEstimate bounds].size.height)];
//            [self.rrLower setCenter:CGPointMake([self.rrLower center].x, [self.rrLower center].y + 2.0 * [self.rrLower bounds].size.height)];
//            [self.rrUpper setCenter:CGPointMake([self.rrUpper center].x, [self.rrUpper center].y + 2.0 * [self.rrUpper bounds].size.height)];
//            [self.riskDifferenceLabel setCenter:CGPointMake([self.riskDifferenceLabel center].x, [self.riskDifferenceLabel center].y + 2.0 * [self.riskDifferenceLabel bounds].size.height)];
            [self.riskDifferenceLabel setText:@"Adjusted"];
//            [self.rdEstimate setCenter:CGPointMake([self.rdEstimate center].x, [self.rdEstimate center].y + 2.0 * [self.rdEstimate bounds].size.height)];
//            [self.rdLower setCenter:CGPointMake([self.rdLower center].x, [self.rdLower center].y + 2.0 * [self.rdLower bounds].size.height)];
//            [self.rdUpper setCenter:CGPointMake([self.rdUpper center].x, [self.rdUpper center].y + 2.0 * [self.rdUpper bounds].size.height)];
//            [self.statisticalTestsLabel setCenter:CGPointMake([self.statisticalTestsLabel center].x, [self.statisticalTestsLabel center].y + 2.0 * [self.statisticalTestsLabel bounds].size.height)];
            [self.statisticalTestsLabel setText:@"Chi Square"];
//            [self.x2Label setCenter:CGPointMake([self.x2Label center].x, [self.x2Label center].y + 2.0 * [self.x2Label bounds].size.height)];
//            [self.twoTailedPLabel setCenter:CGPointMake([self.twoTailedPLabel center].x, [self.twoTailedPLabel center].y + 2.0 * [self.twoTailedPLabel bounds].size.height)];
//            [self.uncorrectedLabel setCenter:CGPointMake([self.uncorrectedLabel center].x, [self.uncorrectedLabel center].y + 2.0 * [self.uncorrectedLabel bounds].size.height)];
            [self.uncorrectedLabel setText:@"Uncorrected (MH)"];
            [self.uncorrectedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
//            [self.uX2 setCenter:CGPointMake([self.uX2 center].x, [self.uX2 center].y + 2.0 * [self.uX2 bounds].size.height)];
//            [self.uX2P setCenter:CGPointMake([self.uX2P center].x, [self.uX2P center].y + 2.0 * [self.uX2P bounds].size.height)];
//            [self.mantelHaenszelLabel setCenter:CGPointMake([self.mantelHaenszelLabel center].x, [self.mantelHaenszelLabel center].y + 2.0 * [self.mantelHaenszelLabel bounds].size.height)];
            [self.mantelHaenszelLabel setText:@"Corrected (MH)"];
//            [self.mhX2 setCenter:CGPointMake([self.mhX2 center].x, [self.mhX2 center].y + 2.0 * [self.mhX2 bounds].size.height)];
//            [self.mhX2P setCenter:CGPointMake([self.mhX2P center].x, [self.mhX2P center].y + 2.0 * [self.mhX2P bounds].size.height)];
//            [self.correctedLabel setHidden:YES];
            [self.correctedLabel setText:@"Breslow-Day-Tarone"];
            [self.correctedLabel setAccessibilityLabel:@"Breslow Day Tarone"];
            [self.correctedLabel setFont:[UIFont boldSystemFontOfSize:10.0]];

            if ([strataData[0] hasStatistics] || [strataData[1] hasStatistics] || [strataData[2] hasStatistics] || [strataData[3] hasStatistics] || [strataData[4] hasStatistics])
            {
                Twox2SummaryData *summaryData = [[Twox2SummaryData alloc] init];
                double summaryResultsArray[31];
                
                [summaryData compute:strataData summaryResults:summaryResultsArray];
                
                self.yyField.text = [[NSString alloc] initWithFormat:@"%g", summaryResultsArray[0]];
                self.ynField.text = [[NSString alloc] initWithFormat:@"%g", summaryResultsArray[1]];
                self.nyField.text = [[NSString alloc] initWithFormat:@"%g", summaryResultsArray[2]];
                self.nnField.text = [[NSString alloc] initWithFormat:@"%g", summaryResultsArray[3]];
 
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    self.orEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[4]) / 10000];
                    self.orLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[5]) / 10000];
                    self.orUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[6]) / 10000];
//                    self.mleOR.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[7]) / 10000];
//                    self.mleLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[8]) / 10000];
//                    self.mleUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[9]) / 10000];
//                    self.fisherLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[10]) / 10000];
//                    self.fisherUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[11]) / 10000];
                    adjustedMHEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[12]) / 10000];
                    adjustedMHLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[13]) / 10000];
                    adjustedMHUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[14]) / 10000];
                    self.rrEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[18]) / 10000];
                    self.rrLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[19]) / 10000];
                    self.rrUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[20]) / 10000];
                    self.rdEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[15]) / 10000];
                    self.rdLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[16]) / 10000];
                    self.rdUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[17]) / 10000];
                    self.uX2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[21]) / 10000];
                    self.uX2P.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[22]) / 10000];
                    self.mhX2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[23]) / 10000];
                    self.mhX2P.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[24]) / 10000];
                    self.cX2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[25]) / 10000];
                    self.cX2P.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[26]) / 10000];
                    self.mpExact.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[29]) / 10000];
                    self.phone2TailedPLabel.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[30]) / 10000];
                    self.fisherExact.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[27]) / 10000];
                    self.fisherExact2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[28]) / 10000];
                }

                //iPad
                self.crudeSEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[4]) / 10000];
                self.crudeSLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[5]) / 10000];
                self.crudeSUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[6]) / 10000];
//                self.crudeSmleOR.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[7]) / 10000];
//                self.crudeSmleLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[8]) / 10000];
//                self.crudeSmleUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[9]) / 10000];
//                self.fisherSLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[10]) / 10000];
//                self.fisherSUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[11]) / 10000];
                self.adjustedSEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[12]) / 10000];
                self.adjustedSLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[13]) / 10000];
                self.adjustedSUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[14]) / 10000];
                self.riskcrudeSEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[18]) / 10000];
                self.riskcrudeSLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[19]) / 10000];
                self.riskcrudeSUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[20]) / 10000];
                self.riskadjSEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[15]) / 10000];
                self.riskadjcrudeSLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[16]) / 10000];
                self.riskadjSUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[17]) / 10000];
                self.uSX2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[21]) / 10000];
                self.uSX2P.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[22]) / 10000];
                self.mhSX2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[23]) / 10000];
                self.mhSX2P.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[24]) / 10000];
                //
                
                if ((summaryResultsArray[7] <= 0.0 || isnan(summaryResultsArray[7])) &&
                    (summaryResultsArray[8] <= 0.0 || isnan(summaryResultsArray[8])) &&
                    (summaryResultsArray[9] <= 0.0 || isnan(summaryResultsArray[9])))
                {
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        self.mleOR.text = @"";
                        self.mleLower.text = @"";
                        self.mleUpper.text = @"";
                    }
                    self.crudeSmleOR.text = @"";
                    self.crudeSmleLower.text = @"";
                    self.crudeSmleUpper.text = @"";
                }
                
                if ((summaryResultsArray[10] <= 0.0 || isnan(summaryResultsArray[10])) &&
                    (summaryResultsArray[11] <= 0.0 || isnan(summaryResultsArray[11])))
                {
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        self.fisherLower.text = @"";
                        self.fisherUpper.text = @"";
                    }
                    self.fisherSLower.text = @"";
                    self.fisherSUpper.text = @"";
                }
            
                [self.computingAdjustedOR setHidden:NO];
                [self.twox2CalculatorView bringSubviewToFront:self.computingAdjustedOR];
                [self.computingAdjustedOR startAnimating];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    [self.computingAdjustedOR setFrame:CGRectMake(phoneOddsBasedParametersView.frame.size.width / 2.0 - 13.5, phoneOddsBasedParametersView.frame.size.height / 2.0 - 13.5, 27, 27)];
                    [self.computingAdjustedOR setColor:[UIColor colorWithRed:221/255.0 green:85/255.0 blue:12/255.0 alpha:1.0]];
                    [phoneOddsBasedParametersView addSubview:self.computingAdjustedOR];
                    [phoneOddsBasedParametersView bringSubviewToFront:self.computingAdjustedOR];
                }
                
                if ([timeConsumingCrudeThread isExecuting])
                    [timeConsumingCrudeThread cancel];
                timeConsumingCrudeThread = [[NSThread alloc] initWithTarget:self selector:@selector(doTimeConsumingCrudeStuff) object:nil];
                [timeConsumingCrudeThread start];
                
                workerThread = [[NSThread alloc] initWithTarget:self selector:@selector(doSummaryStuff) object:nil];
                [workerThread start];
            }
            else
            {
                self.yyField.text = [[NSString alloc] initWithFormat:@""];
                self.ynField.text = [[NSString alloc] initWithFormat:@""];
                self.nyField.text = [[NSString alloc] initWithFormat:@""];
                self.nnField.text = [[NSString alloc] initWithFormat:@""];
            }
        }
    }
    if (zs > 1.0)
        [self.twox2CalculatorView setZoomScale:zs animated:YES];
}

- (void)doTimeConsumingCrudeStuff
{
    Twox2SummaryData *summaryData = [[Twox2SummaryData alloc] init];
    double summaryResultsArray[31];
    
    [summaryData computeSlowStuff:strataData summaryResults:summaryResultsArray];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.mleOR.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[7]) / 10000];
        self.mleLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[8]) / 10000];
        self.mleUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[9]) / 10000];
        self.fisherLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[10]) / 10000];
        self.fisherUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[11]) / 10000];
        
        if (summaryResultsArray[10] > summaryResultsArray[7] || summaryResultsArray[11] < summaryResultsArray[7])
        {
            [self.fisherLower setText:@"?"];
            [self.fisherUpper setText:@"?"];
        }
        
        if (summaryResultsArray[8] > summaryResultsArray[7] || summaryResultsArray[9] < summaryResultsArray[7])
        {
            [self.mleLower setText:@"?"];
            [self.mleUpper setText:@"?"];
        }
    }
    
    //iPad
    self.crudeSmleOR.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[7]) / 10000];
    self.crudeSmleLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[8]) / 10000];
    self.crudeSmleUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[9]) / 10000];
    self.fisherSLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[10]) / 10000];
    self.fisherSUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[11]) / 10000];
    
    if (summaryResultsArray[10] > summaryResultsArray[7] || summaryResultsArray[11] < summaryResultsArray[7])
    {
        [self.fisherSLower setText:@"?"];
        [self.fisherSUpper setText:@"?"];
    }
    
    if (summaryResultsArray[8] > summaryResultsArray[7] || summaryResultsArray[9] < summaryResultsArray[7])
    {
        [self.crudeSmleLower setText:@"?"];
        [self.crudeSmleUpper setText:@"?"];
    }
    //
    
    if ((summaryResultsArray[7] <= 0.0 || isnan(summaryResultsArray[7])) &&
        (summaryResultsArray[8] <= 0.0 || isnan(summaryResultsArray[8])) &&
        (summaryResultsArray[9] <= 0.0 || isnan(summaryResultsArray[9])))
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.mleOR.text = @"";
            self.mleLower.text = @"";
            self.mleUpper.text = @"";
        }
        self.crudeSmleOR.text = @"";
        self.crudeSmleLower.text = @"";
        self.crudeSmleUpper.text = @"";
    }
    
    if ((summaryResultsArray[10] <= 0.0 || isnan(summaryResultsArray[10])) &&
        (summaryResultsArray[11] <= 0.0 || isnan(summaryResultsArray[11])))
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.fisherLower.text = @"";
            self.fisherUpper.text = @"";
        }
        self.fisherSLower.text = @"";
        self.fisherSUpper.text = @"";
    }
}

- (void)doSummaryStuff
{
    Twox2SummaryData *summaryData = [[Twox2SummaryData alloc] init];
    double summaryResultsArray[3];
    summaryResultsArray[0] = 0.0;
    summaryResultsArray[1] = 0.0;
    summaryResultsArray[2] = 0.0;
    
    [summaryData computeExactOR:strataData summaryResults:summaryResultsArray];
    
    [self.computingAdjustedOR stopAnimating];
    [self.computingAdjustedOR setHidden:YES];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        adjustedMLEEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[0]) / 10000];
        adjustedMLELower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[1]) / 10000];
        adjustedMLEUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[2]) / 10000];
        
        if (summaryResultsArray[0] < 0)
        {
            [adjustedMLEEstimate setText:@"?"];
            [adjustedMLELower setText:@"?"];
            [adjustedMLEUpper setText:@"?"];
        }
    }
    
    
    //iPad
    self.adjustedSmleEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[0]) / 10000];
    self.adjustedSmleLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[1]) / 10000];
    self.adjustedSmleUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * summaryResultsArray[2]) / 10000];
    
    if (summaryResultsArray[0] < 0)
    {
        [adjustedSmleEstimate setText:@"?"];
        [adjustedSmleLower setText:@"?"];
        [adjustedSmleUpper setText:@"?"];
    }
    //
    if ((summaryResultsArray[0] <= 0.0 || isnan(summaryResultsArray[0])) &&
        (summaryResultsArray[1] <= 0.0 || isnan(summaryResultsArray[1])) &&
        (summaryResultsArray[2] <= 0.0 || isnan(summaryResultsArray[2])))
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            adjustedMLEEstimate.text = @"";
            adjustedMLELower.text = @"";
            adjustedMLEUpper.text = @"";
        }
        self.adjustedSmleEstimate.text = @"";
        self.adjustedSmleLower.text = @"";
        self.adjustedSmleUpper.text = @"";
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView BooleanVariable:(BOOL)bv
{
    return self.twox2CalculatorView;
}

- (void)viewDidUnload {
    
    [self setYyField:nil];
    [self setYnField:nil];
    [self setNyField:nil];
    [self setNnField:nil];
    [self setOrEstimate:nil];
    [self setOrLower:nil];
    [self setOrUpper:nil];
    [self setMleOR:nil];
    [self setMleLower:nil];
    [self setMleUpper:nil];
    [self setFisherLower:nil];
    [self setFisherUpper:nil];
    [self setRrEstimate:nil];
    [self setRrLower:nil];
    [self setRrUpper:nil];
    [self setRdEstimate:nil];
    [self setRdLower:nil];
    [self setRdUpper:nil];
    [self setUX2:nil];
    [self setUX2P:nil];
    [self setMhX2:nil];
    [self setMhX2P:nil];
    [self setCX2:nil];
    [self setCX2P:nil];
    [self setMpExact:nil];
    [self setFisherExact:nil];
    [self setFisherExact2:nil];
    [super viewDidUnload];
}

- (IBAction)compute:(id)sender
{
    [self doCompute];
}

- (void)doCompute
{
    self.yyString = self.yyField.text;
    self.ynString = self.ynField.text;
    self.nyString = self.nyField.text;
    self.nnString = self.nnField.text;
    
    if (self.yyString.length > 0 && self.ynString.length > 0 && self.nyString.length > 0 && self.nnString.length > 0)
    {
        int yy = [self.yyString intValue];
        int yn = [self.ynString intValue];
        int ny = [self.nyString intValue];
        int nn = [self.nnString intValue];
        
        [strataData[stratum] setYyHasValue:YES];
        [strataData[stratum] setYnHasValue:YES];
        [strataData[stratum] setNyHasValue:YES];
        [strataData[stratum] setNnHasValue:YES];
        
        Twox2Compute *computer = [[Twox2Compute alloc] init];
        
        [self clearSome];
        
        self.orEstimate.text = [[NSString alloc] initWithFormat:@"%g", [computer OddsRatioEstimate:yy cellb:yn cellc:ny celld:nn]];
        self.orLower.text = [[NSString alloc] initWithFormat:@"%g", [computer OddsRatioLower:yy cellb:yn cellc:ny celld:nn]];
        self.orUpper.text = [[NSString alloc] initWithFormat:@"%g", [computer OddsRatioUpper:yy cellb:yn cellc:ny celld:nn]];
        
//        double ExactResults[4];
//        NSLog(@"1");
//        [computer CalcPoly:yy CPyn:yn CPny:ny CPnn:nn CPExactResults:ExactResults];
//        NSLog(@"2");
//        double lowerMidP = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:NO];
//        NSLog(@"3");
//        double upperMidP = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:NO];
//        NSLog(@"4");
//        self.mleOR.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * ExactResults[0]) / 10000];
//        self.mleLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * lowerMidP) / 10000];
//        self.mleUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * upperMidP) / 10000];
//        
//        double lowerFisher = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:YES];
//        NSLog(@"5");
//        double upperFisher = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:YES];
//        NSLog(@"6");
//        self.fisherLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * lowerFisher) / 10000];
//        self.fisherUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * upperFisher) / 10000];
        
        double RRstats[12];
        [computer RRStats:yy RRSb:yn RRSc:ny RRSd:nn RRSstats:RRstats];
        self.rrEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[0]) / 10000];
        self.rrLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[1]) / 10000];
        self.rrUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[2]) / 10000];
        self.rdEstimate.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[3]) / 10000];
        self.rdLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[4]) / 10000];
        self.rdUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[5]) / 10000];
        self.uX2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[6]) / 10000];
        self.uX2P.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[7]) / 10000];
        self.mhX2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[8]) / 10000];
        self.mhX2P.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[9]) / 10000];
        self.cX2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[10]) / 10000];
        self.cX2P.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * RRstats[11]) / 10000];
//        self.mpExact.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * ExactResults[1]) / 10000];
//        self.fisherExact.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * ExactResults[2]) / 10000];
//        self.fisherExact2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * ExactResults[3]) / 10000];
        
        if ([exactThread isExecuting])
            [exactThread cancel];
        exactThread = [[NSThread alloc] initWithTarget:self selector:@selector(exactComputing) object:nil];
        [exactThread start];
        
        [self.computingAdjustedOR setHidden:NO];
        [self.twox2CalculatorView bringSubviewToFront:self.computingAdjustedOR];
        [self.computingAdjustedOR startAnimating];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self.computingAdjustedOR setFrame:CGRectMake(phoneOddsBasedParametersView.frame.size.width / 2.0 - 13.5, phoneOddsBasedParametersView.frame.size.height / 2.0 - 13.5, 27, 27)];
            [self.computingAdjustedOR setColor:[UIColor colorWithRed:221/255.0 green:85/255.0 blue:12/255.0 alpha:1.0]];
            [phoneOddsBasedParametersView addSubview:self.computingAdjustedOR];
            [phoneOddsBasedParametersView bringSubviewToFront:self.computingAdjustedOR];
        }
        
        [strataData[stratum] setHasData:YES];
        [strataData[stratum] setYy:yy];
        [strataData[stratum] setYn:yn];
        [strataData[stratum] setNy:ny];
        [strataData[stratum] setNn:nn];
        [strataData[stratum] setHasStatistics:YES];
        [strataData[stratum] setModelor:[self.orEstimate.text doubleValue]];
        [strataData[stratum] setModelorLower:[self.orLower.text doubleValue]];
        [strataData[stratum] setModelorUpper:[self.orUpper.text doubleValue]];
//        [strataData[stratum] setModelmleOR:[self.mleOR.text doubleValue]];
//        [strataData[stratum] setModelmleORLower:[self.mleLower.text doubleValue]];
//        [strataData[stratum] setModelmleORUpper:[self.mleUpper.text doubleValue]];
//        [strataData[stratum] setModelfisherORLower:[self.fisherLower.text doubleValue]];
//        [strataData[stratum] setModelfisherORUpper:[self.fisherUpper.text doubleValue]];
        [strataData[stratum] setModelrr:[self.rrEstimate.text doubleValue]];
        [strataData[stratum] setModelrrLower:[self.rrLower.text doubleValue]];
        [strataData[stratum] setModelrrUpper:[self.rrUpper.text doubleValue]];
        [strataData[stratum] setModelrd:[self.rdEstimate.text doubleValue]];
        [strataData[stratum] setModelrdLower:[self.rdLower.text doubleValue]];
        [strataData[stratum] setModelrdUpper:[self.rdUpper.text doubleValue]];
        [strataData[stratum] setModelx2:[self.uX2.text doubleValue]];
        [strataData[stratum] setModelx2p:[self.uX2P.text doubleValue]];
        [strataData[stratum] setModelmhx2:[self.mhX2.text doubleValue]];
        [strataData[stratum] setModelmhx2p:[self.mhX2P.text doubleValue]];
        [strataData[stratum] setModelcx2:[self.cX2.text doubleValue]];
        [strataData[stratum] setModelcx2p:[self.cX2P.text doubleValue]];
//        [strataData[stratum] setModelmidP:[self.mpExact.text doubleValue]];
//        [strataData[stratum] setModelfisherExact1:[self.fisherExact.text doubleValue]];
//        [strataData[stratum] setModelfisherExact2:[self.fisherExact2.text doubleValue]];
    }
    else if (self.yyString.length > 0 || self.ynString.length > 0 || self.nyString.length > 0 || self.nnString.length > 0)
    {
        int yy = [self.yyString intValue];
        int yn = [self.ynString intValue];
        int ny = [self.nyString intValue];
        int nn = [self.nnString intValue];
        
        [strataData[stratum] setHasData:YES];
        [strataData[stratum] setYy:yy];
        [strataData[stratum] setYn:yn];
        [strataData[stratum] setNy:ny];
        [strataData[stratum] setNn:nn];
        [strataData[stratum] setHasStatistics:NO];
        
        [self clearAll];
        
        [strataData[stratum] setYyHasValue:NO];
        [strataData[stratum] setYnHasValue:NO];
        [strataData[stratum] setNyHasValue:NO];
        [strataData[stratum] setNnHasValue:NO];

        if (self.yyString.length > 0) {self.yyField.text = [[NSString alloc] initWithFormat:@"%d", [strataData[stratum] yy]];[strataData[stratum] setYyHasValue:YES];}
        if (self.ynString.length > 0) {self.ynField.text = [[NSString alloc] initWithFormat:@"%d", [strataData[stratum] yn]];[strataData[stratum] setYnHasValue:YES];}
        if (self.nyString.length > 0) {self.nyField.text = [[NSString alloc] initWithFormat:@"%d", [strataData[stratum] ny]];[strataData[stratum] setNyHasValue:YES];}
        if (self.nnString.length > 0) {self.nnField.text = [[NSString alloc] initWithFormat:@"%d", [strataData[stratum] nn]];[strataData[stratum] setNnHasValue:YES];}
    }
    else
    {
        [strataData[stratum] setHasData:NO];
        [strataData[stratum] setYyHasValue:NO];
        [strataData[stratum] setYnHasValue:NO];
        [strataData[stratum] setNyHasValue:NO];
        [strataData[stratum] setNnHasValue:NO];
        [strataData[stratum] setHasStatistics:NO];
        [self clearAll];
    }
}

- (void)exactComputing
{
    self.yyString = self.yyField.text;
    self.ynString = self.ynField.text;
    self.nyString = self.nyField.text;
    self.nnString = self.nnField.text;
    int yy = [self.yyString intValue];
    int yn = [self.ynString intValue];
    int ny = [self.nyString intValue];
    int nn = [self.nnString intValue];
    Twox2Compute *computer = [[Twox2Compute alloc] init];
    double ExactResults[4];

    [computer CalcPoly:yy CPyn:yn CPny:ny CPnn:nn CPExactResults:ExactResults];

    double lowerMidP = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:NO];

    double upperMidP = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:NO];
    self.mleOR.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * ExactResults[0]) / 10000];
    self.mleLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * lowerMidP) / 10000];
    self.mleUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * upperMidP) / 10000];
    
    double lowerFisher = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:YES];

    double upperFisher = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:YES];

    self.fisherLower.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * lowerFisher) / 10000];
    self.fisherUpper.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * upperFisher) / 10000];
    self.mpExact.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * ExactResults[1]) / 10000];
    self.fisherExact.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * ExactResults[2]) / 10000];
    self.fisherExact2.text = [[NSString alloc] initWithFormat:@"%g", round(10000 * ExactResults[3]) / 10000];
    
    [self.computingAdjustedOR stopAnimating];
    [self.computingAdjustedOR setHidden:YES];

    [strataData[stratum] setModelmleOR:[self.mleOR.text doubleValue]];
    [strataData[stratum] setModelmleORLower:[self.mleLower.text doubleValue]];
    [strataData[stratum] setModelmleORUpper:[self.mleUpper.text doubleValue]];
    [strataData[stratum] setModelfisherORLower:[self.fisherLower.text doubleValue]];
    [strataData[stratum] setModelfisherORUpper:[self.fisherUpper.text doubleValue]];
    [strataData[stratum] setModelmidP:[self.mpExact.text doubleValue]];
    [strataData[stratum] setModelfisherExact1:[self.fisherExact.text doubleValue]];
    [strataData[stratum] setModelfisherExact2:[self.fisherExact2.text doubleValue]];
    
    if (lowerFisher > ExactResults[0] || upperFisher < ExactResults[0])
    {
        [self.fisherLower setText:@"?"];
        [self.fisherUpper setText:@"?"];
        [strataData[stratum] setModelfisherORLower:NAN];
        [strataData[stratum] setModelfisherORUpper:NAN];
    }
    
    if (lowerMidP > ExactResults[0] || upperMidP < ExactResults[0])
    {
        [self.mleLower setText:@"?"];
        [self.mleUpper setText:@"?"];
        [strataData[stratum] setModelmleORLower:NAN];
        [strataData[stratum] setModelmleORUpper:NAN];
    }
}

- (IBAction)clearButtonPressed:(id)sender
{
    if ([self.yyField isFirstResponder])
        [self.yyField resignFirstResponder];
    else if ([self.ynField isFirstResponder])
        [self.ynField resignFirstResponder];
    else if ([self.nyField isFirstResponder])
        [self.nyField resignFirstResponder];
    else if ([self.nnField isFirstResponder])
        [self.nnField resignFirstResponder];

    [self clearAll];
    [strataData[stratum] setHasData:NO];
    [strataData[stratum] setYyHasValue:NO];
    [strataData[stratum] setYnHasValue:NO];
    [strataData[stratum] setNyHasValue:NO];
    [strataData[stratum] setNnHasValue:NO];
    [strataData[stratum] setHasStatistics:NO];
    [strataData[stratum] setYy:0];
    [strataData[stratum] setYn:0];
    [strataData[stratum] setNy:0];
    [strataData[stratum] setNn:0];
    [strataData[stratum] setModelor:0.0];
    [strataData[stratum] setModelorLower:0.0];
    [strataData[stratum] setModelorUpper:0.0];
    [strataData[stratum] setModelmleOR:0.0];
    [strataData[stratum] setModelmleORLower:0.0];
    [strataData[stratum] setModelmleORUpper:0.0];
    [strataData[stratum] setModelfisherORLower:0.0];
    [strataData[stratum] setModelfisherORUpper:0.0];
    [strataData[stratum] setModelrr:0.0];
    [strataData[stratum] setModelrrLower:0.0];
    [strataData[stratum] setModelrrUpper:0.0];
    [strataData[stratum] setModelrd:0.0];
    [strataData[stratum] setModelrdLower:0.0];
    [strataData[stratum] setModelrdUpper:0.0];
    [strataData[stratum] setModelx2:0.0];
    [strataData[stratum] setModelx2p:0.0];
    [strataData[stratum] setModelmhx2:0.0];
    [strataData[stratum] setModelmhx2p:0.0];
    [strataData[stratum] setModelcx2:0.0];
    [strataData[stratum] setModelcx2p:0.0];
    [strataData[stratum] setModelmidP:0.0];
    [strataData[stratum] setModelfisherExact1:0.0];
    [strataData[stratum] setModelfisherExact2:0.0];
}

- (IBAction)textFieldAction:(id)sender
{
    int cursorPosition = [sender offsetFromPosition:[sender endOfDocument] toPosition:[[sender selectedTextRange] start]];
    
    UITextField *theTextField = (UITextField *)sender;
    
    if (theTextField.text.length + cursorPosition == 0)
    {
        [self doCompute];
        UITextPosition *newPosition = [sender positionFromPosition:[sender endOfDocument] offset:cursorPosition];
        [sender setSelectedTextRange:[sender textRangeFromPosition:newPosition toPosition:newPosition]];
        return;
    }
    
    if (theTextField.text.length == 0)
    {
        [self doCompute];
        return;
    }
    
    NSCharacterSet *validSet; // = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
/*
    if ([[theTextField.text substringWithRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
    {
        theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1) withString:@""];
    }
    else
        [self doCompute];
*/    
    validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < theTextField.text.length; i++)
    {
        if ([[theTextField.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
            theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
    }
    theTextField.text = [theTextField.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [self compute:sender];
    
    UITextPosition *newPosition = [sender positionFromPosition:[sender endOfDocument] offset:cursorPosition];
    [sender setSelectedTextRange:[sender textRangeFromPosition:newPosition toPosition:newPosition]];
}

- (IBAction)resetBarButtonPressed:(id)sender
{
    if (stratum == 5)
        return;
    [self clearButtonPressed:sender];
}

- (void)clearAll
{
    if ([exactThread isExecuting])
        [exactThread cancel];
    
    [self.computingAdjustedOR stopAnimating];
    [self.computingAdjustedOR setHidden:YES];

    self.yyField.text = [[NSString alloc] initWithFormat:@""];
    self.ynField.text = [[NSString alloc] initWithFormat:@""];
    self.nyField.text = [[NSString alloc] initWithFormat:@""];
    self.nnField.text = [[NSString alloc] initWithFormat:@""];
    self.orEstimate.text = [[NSString alloc] initWithFormat:@""];
    self.orLower.text = [[NSString alloc] initWithFormat:@""];
    self.orUpper.text = [[NSString alloc] initWithFormat:@""];
    self.mleOR.text = [[NSString alloc] initWithFormat:@""];
    self.mleLower.text = [[NSString alloc] initWithFormat:@""];
    self.mleUpper.text = [[NSString alloc] initWithFormat:@""];
    self.fisherLower.text = [[NSString alloc] initWithFormat:@""];
    self.fisherUpper.text = [[NSString alloc] initWithFormat:@""];
    self.rrEstimate.text = [[NSString alloc] initWithFormat:@""];
    self.rrLower.text = [[NSString alloc] initWithFormat:@""];
    self.rrUpper.text = [[NSString alloc] initWithFormat:@""];
    self.rdEstimate.text = [[NSString alloc] initWithFormat:@""];
    self.rdLower.text = [[NSString alloc] initWithFormat:@""];
    self.rdUpper.text = [[NSString alloc] initWithFormat:@""];
    self.uX2.text = [[NSString alloc] initWithFormat:@""];
    self.uX2P.text = [[NSString alloc] initWithFormat:@""];
    self.mhX2.text = [[NSString alloc] initWithFormat:@""];
    self.mhX2P.text = [[NSString alloc] initWithFormat:@""];
    self.cX2.text = [[NSString alloc] initWithFormat:@""];
    self.cX2P.text = [[NSString alloc] initWithFormat:@""];
    self.mpExact.text = [[NSString alloc] initWithFormat:@""];
    self.fisherExact.text = [[NSString alloc] initWithFormat:@""];
    self.fisherExact2.text = [[NSString alloc] initWithFormat:@""];
    self.adjustedSmleEstimate.text = [[NSString alloc] initWithFormat:@""];
    self.adjustedSmleLower.text = [[NSString alloc] initWithFormat:@""];
    self.adjustedSmleUpper.text = [[NSString alloc] initWithFormat:@""];
}

- (void)clearSome
{
    self.mleOR.text = [[NSString alloc] initWithFormat:@""];
    self.mleLower.text = [[NSString alloc] initWithFormat:@""];
    self.mleUpper.text = [[NSString alloc] initWithFormat:@""];
    self.fisherLower.text = [[NSString alloc] initWithFormat:@""];
    self.fisherUpper.text = [[NSString alloc] initWithFormat:@""];
    self.mpExact.text = [[NSString alloc] initWithFormat:@""];
    self.fisherExact.text = [[NSString alloc] initWithFormat:@""];
    self.fisherExact2.text = [[NSString alloc] initWithFormat:@""];
    [strataData[stratum] setModelmleOR:0.0];
    [strataData[stratum] setModelmleORLower:0.0];
    [strataData[stratum] setModelmleORUpper:0.0];
    [strataData[stratum] setModelfisherORLower:0.0];
    [strataData[stratum] setModelfisherORUpper:0.0];
    [strataData[stratum] setModelmidP:0.0];
    [strataData[stratum] setModelfisherExact1:0.0];
    [strataData[stratum] setModelfisherExact2:0.0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currentOrientationPortrait = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (currentOrientationPortrait && UIInterfaceOrientationIsLandscape(fromInterfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:scrollViewFrame];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -1, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setFrame:CGRectMake(0, [self.view frame].size.height - 400.0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:1];
                
                [self.subView1 setFrame:CGRectMake(156, 37, 372, 311)];
                [self.subView2 setFrame:CGRectMake(20, 267, 643, 675)];
                [self.subView3 setFrame:CGRectMake(26, 50, 632, 632)];
                [self.subView4 setFrame:CGRectMake(143, 560, 388, 338)];
                
                [self.computingAdjustedOR setFrame:computingFrame];
                [segmentedControl setBounds:CGRectMake(self.view.bounds.size.width / 2.0, 68.0, self.view.bounds.size.width, 50.0)];
                [segmentedControl setCenter:CGPointMake(self.view.bounds.size.width / 2.0, 68.0)];
                segmentedControl.transform = CGAffineTransformMakeRotation(0.0);
                
                NSArray *segments = [segmentedControl subviews];
                for (int i = 0; i < segments.count; i++)
                {
                    UIView *v = (UIView*)[segments objectAtIndex:i];
                    NSArray *subarr = [v subviews];
                    for (int j = 0; j < subarr.count; j++)
                    {
                        if ([[subarr objectAtIndex:j] isKindOfClass:[UILabel class]])
                        {
                            UILabel *l = (UILabel*)[subarr objectAtIndex:j];
                            if ([l.text isEqualToString:@"Summary"])
                            {
                                [l setNumberOfLines:0];
                                [l setLineBreakMode:summaryTabMode];
                                [l setFrame:CGRectMake(110, -25, 50, 100)];
                            }
                            l.transform = CGAffineTransformMakeRotation(0.0);
                        }
                    }
                }
                
                [blurryView setFrame:segmentedControl.frame];
            }];
            
            if (stratum != 5)
                [self.twox2CalculatorView setScrollEnabled:YES];
        }
        else if (!currentOrientationPortrait && UIInterfaceOrientationIsPortrait(fromInterfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -1, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 186.0, 37, 372, 311)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 643.0, 290, 643, 675)];
                [self.subView3 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 316.0, 20, 632, 632)];
                [self.subView4 setFrame:CGRectMake(20, 300, 388, 338)];
                
                [self.computingAdjustedOR setFrame:CGRectMake(self.view.frame.size.width / 2.0 - computingFrame.size.width / 2.0, self.view.frame.size.height / 2.0 - computingFrame.size.height / 2.0, computingFrame.size.width, computingFrame.size.height)];
                [segmentedControl setBounds:CGRectMake(self.view.bounds.size.width / 2.0, 68.0, self.view.bounds.size.height - 43.0, 50.0)];
                [segmentedControl setCenter:CGPointMake(self.view.bounds.size.width -25.0, self.view.frame.size.height / 2.0 + 21.0)];
                segmentedControl.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
                
                NSArray *segments = [segmentedControl subviews];
                for (int i = 0; i < segments.count; i++)
                {
                    UIView *v = (UIView*)[segments objectAtIndex:i];
                    NSArray *subarr = [v subviews];
                    for (int j = 0; j < subarr.count; j++)
                    {
                        if ([[subarr objectAtIndex:j] isKindOfClass:[UILabel class]])
                        {
                            UILabel *l = (UILabel*)[subarr objectAtIndex:j];
                            if ([l.text isEqualToString:@"Summary"])
                            {
                                [l setNumberOfLines:0];
                                [l setLineBreakMode:NSLineBreakByCharWrapping];
                                [l setFrame:CGRectMake(70, -50, 15, 150)];
                            }
                            l.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
                        }
                    }
                }
            }];
            
            [blurryView setFrame:segmentedControl.frame];
            
            [self.twox2CalculatorView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self.twox2CalculatorView setScrollEnabled:NO];
        }
    }
    else
    {
        float zs = [self.twox2CalculatorView zoomScale];
        [self.twox2CalculatorView setZoomScale:1.0 animated:YES];
        if (currentOrientationPortrait && UIInterfaceOrientationIsLandscape(fromInterfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [segmentedControl setWidth:40.0 forSegmentAtIndex:0];
                [segmentedControl setWidth:40.0 forSegmentAtIndex:1];
                [segmentedControl setWidth:40.0 forSegmentAtIndex:2];
                [segmentedControl setWidth:40.0 forSegmentAtIndex:3];
                [segmentedControl setWidth:40.0 forSegmentAtIndex:4];
                [segmentedControl setBounds:CGRectMake(160.0, 20.0, 320.0, 30.0)];
                [segmentedControl setCenter:CGPointMake(160.0, 15.0)];
                [blurryView setFrame:segmentedControl.frame];
                [phoneInputsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 138)];
                [phoneOddsBasedParametersView setFrame:CGRectMake(0, 181 - 34, self.view.frame.size.width, 245 - (181 - 34) + 34)];
                if (stratum == 5)
                    [phoneOddsBasedParametersView setFrame:CGRectMake(0, 181 - 40, self.view.frame.size.width, 245 - (181 - 34) + 34)];
                [phoneRiskBasedParametersView setFrame:CGRectMake(0, 286 - 34, self.view.frame.size.width, 330 - (283 - 34))];
                if (stratum == 5)
                    [phoneRiskBasedParametersView setFrame:CGRectMake(0, 286 - 10, self.view.frame.size.width, 330 - (283 - 34))];
                [phoneStatisticalTestsView setFrame:CGRectMake(0, 374 - 34, self.view.frame.size.width, phoneStatisticalTestsView.frame.size.height)];
                if (stratum == 5)
                    [phoneStatisticalTestsView setFrame:CGRectMake(0, 374 - 16, self.view.frame.size.width, 488 - (369 - 34))];
                
                float x = 100.0;
                if (fourInchPhone)
                    x = 0.0;
                self.twox2CalculatorView.contentSize = CGSizeMake(320, phoneStatisticalTestsView.frame.origin.y + phoneStatisticalTestsView.frame.size.height + x);
            }];
            //Re-size the zoomingView
            if (fourInchPhone)
                [zoomingView setFrame:CGRectMake(0, 0, self.twox2CalculatorView.frame.size.width, self.twox2CalculatorView.frame.size.height)];
            else
                [zoomingView setFrame:CGRectMake(0, 0, self.twox2CalculatorView.frame.size.width, self.twox2CalculatorView.frame.size.height + 100)];
        }
        else if (!currentOrientationPortrait && UIInterfaceOrientationIsPortrait(fromInterfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [segmentedControl setWidth:60.0 forSegmentAtIndex:0];
                [segmentedControl setWidth:60.0 forSegmentAtIndex:1];
                [segmentedControl setWidth:60.0 forSegmentAtIndex:2];
                [segmentedControl setWidth:60.0 forSegmentAtIndex:3];
                [segmentedControl setWidth:60.0 forSegmentAtIndex:4];
                [segmentedControl setBounds:CGRectMake(self.view.frame.size.width / 2.0, 20.0, self.view.frame.size.width, 30.0)];
                [segmentedControl setCenter:CGPointMake(self.view.frame.size.width / 2.0, 15.0)];
                [blurryView setFrame:segmentedControl.frame];
                [phoneInputsView setFrame:CGRectMake(-20, -8, self.view.frame.size.width, 138)];
                [phoneOddsBasedParametersView setFrame:CGRectMake(phoneStatisticalTestsView.frame.size.width, 40, phoneOddsBasedParametersView.frame.size.width, phoneOddsBasedParametersView.frame.size.height)];
                [phoneRiskBasedParametersView setFrame:CGRectMake(phoneOddsBasedParametersView.frame.origin.x, 45 + phoneOddsBasedParametersView.frame.size.height - 34, phoneRiskBasedParametersView.frame.size.width, phoneRiskBasedParametersView.frame.size.height)];
                if (stratum == 5)
                    [phoneRiskBasedParametersView setFrame:CGRectMake(phoneOddsBasedParametersView.frame.origin.x, 45 + phoneOddsBasedParametersView.frame.size.height, phoneRiskBasedParametersView.frame.size.width, phoneRiskBasedParametersView.frame.size.height)];
                [phoneStatisticalTestsView setFrame:CGRectMake(0, phoneInputsView.frame.size.height + 5, phoneStatisticalTestsView.frame.size.width, phoneStatisticalTestsView.frame.size.height)];
                if (stratum == 5)
                    [phoneStatisticalTestsView setFrame:CGRectMake(0, phoneInputsView.frame.size.height + 5 - 12, phoneStatisticalTestsView.frame.size.width, phoneStatisticalTestsView.frame.size.height)];
                self.twox2CalculatorView.contentSize = CGSizeMake(phoneStatisticalTestsView.frame.size.width + phoneOddsBasedParametersView.frame.size.width, phoneInputsView.frame.size.height + phoneStatisticalTestsView.frame.size.height + 100);
                if (stratum == 5)
                    self.twox2CalculatorView.contentSize = CGSizeMake(phoneStatisticalTestsView.frame.size.width + phoneOddsBasedParametersView.frame.size.width, phoneInputsView.frame.size.height + phoneStatisticalTestsView.frame.size.height);
            }];
            
            [self.twox2CalculatorView setContentOffset:CGPointMake(0, 0) animated:YES];
            //Re-size the zoomingView
            [zoomingView setFrame:CGRectMake(0, 0, self.twox2CalculatorView.contentSize.width, self.twox2CalculatorView.contentSize.height)];
        }
        if (zs > 1.0)
            [self.twox2CalculatorView setZoomScale:zs animated:YES];
    }
}

- (void)popCurrentViewController
{
    //Method for the custom "Back" button on the NavigationController
    [self.navigationController popViewControllerAnimated:YES];
}
@end
