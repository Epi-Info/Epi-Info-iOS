//
//  MatchedPairCalculatorViewController.m
//  MatchedPairCalculator
//
//  Created by John Copeland on 10/1/12.
//

#import "MatchedPairCalculatorViewController.h"
#import "MatchedPairCalculatorView.h"
#import "MatchedPairCompute.h"
#import "SharedResources.h"

@interface MatchedPairCalculatorViewController()
@property (nonatomic, weak) IBOutlet MatchedPairCalculatorView *twox2CalculatorView;
@end

@implementation MatchedPairCalculatorViewController
@synthesize twox2CalculatorView = _twox2CalculatorView;
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
@synthesize fisherLower = _fisherLower;
@synthesize fisherUpper = _fisherUpper;
@synthesize uX2 = _uX2;
@synthesize uX2P = _uX2P;
@synthesize cX2 = _cX2;
@synthesize cX2P = _cX2P;
@synthesize fisherExact = _fisherExact;
@synthesize fisherExact2 = _fisherExact2;
@synthesize exactLimitsLabel = _exactLimitsLabel;
@synthesize exactTestsLabel = _exactTestsLabel;
@synthesize oneTailedPLabel = _oneTailedPLabel;
@synthesize twoTailedPLabel = _twoTailedPLabel;
@synthesize discordantPairLabel = _discordantPairLabel;
@synthesize cellAdditionLabel = _cellAdditionLabel;
@synthesize computing = _computing;

-(void)setTwox2CalculatorView:(MatchedPairCalculatorView *)twox2CalculatorView
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
       
        fourInchPhone = (self.view.frame.size.height > 500);
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.twox2CalculatorView.frame.size.width, self.twox2CalculatorView.frame.size.height)];

        [self.phoneOddsBasedSectionLabel setFrame:CGRectMake(28, 130, 280, 21)];
        [self.phoneEstimateLabel setFrame:CGRectMake(122, 148, 51, 21)];
        [self.phoneLowerLabel setFrame:CGRectMake(202, 148, 42, 21)];
        [self.phoneUpperLabel setFrame:CGRectMake(263, 148, 42, 21)];
        [self.phoneOddsRatioLabel setFrame:CGRectMake(31, 163, 65, 21)];
        [self.orEstimate setFrame:CGRectMake(122, 163, 42, 21)];
        [self.orLower setFrame:CGRectMake(202, 163, 42, 21)];
        [self.orUpper setFrame:CGRectMake(263, 163, 42, 21)];
        [self.phoneExactLabel setFrame:CGRectMake(23, 180, 72, 21)];
        [self.fisherLower setFrame:CGRectMake(202, 180, 42, 21)];
        [self.fisherUpper setFrame:CGRectMake(263, 180, 42, 21)];

        [self.phoneStatisticalTestsSectionLabel setFrame:CGRectMake(21, 209, 280, 21)];
        [self.phoneX2Label setFrame:CGRectMake(124, 227, 75, 21)];
        [self.phoneX2PLabel setFrame:CGRectMake(226, 227, 75, 21)];
        [self.phoneMcNemarLabel setFrame:CGRectMake(28, 242, 75, 21)];
        [self.uX2 setFrame:CGRectMake(140, 242, 42, 21)];
        [self.uX2P setFrame:CGRectMake(243, 242, 42, 21)];
        [self.phoneCorrectedLabel setFrame:CGRectMake(28, 260, 75, 21)];
        [self.cX2 setFrame:CGRectMake(140, 260, 42, 21)];
        [self.cX2P setFrame:CGRectMake(243, 260, 42, 21)];
        [self.phone1TailedPLabel setFrame:CGRectMake(123, 285, 75, 21)];
        [self.phone2TailedPLabel setFrame:CGRectMake(226, 285, 75, 21)];
        [self.phoneFisherExactLabel setFrame:CGRectMake(28, 302, 72, 21)];
        [self.fisherExact setFrame:CGRectMake(131, 302, 56, 21)];
        [self.fisherExact2 setFrame:CGRectMake(233, 302, 56, 21)];
    }

    scrollViewFrame = CGRectMake(0, 40, 768,960);
    [self.epiInfoScrollView0 setScrollEnabled:NO];
    computingFrame = [self.computing frame];
    
    self.yyField.returnKeyType = UIReturnKeyNext;
    self.ynField.returnKeyType = UIReturnKeyNext;
    self.nyField.returnKeyType = UIReturnKeyNext;
    self.nnField.returnKeyType = UIReturnKeyDone;
    self.yyField.delegate = self;
    self.ynField.delegate = self;
    self.nyField.delegate = self;
    self.nnField.delegate = self;
    
    self.twox2CalculatorView.contentSize = CGSizeMake(320, 758);
    
    [self.computing setHidden:YES];
    
    //iPad
    self.view.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"textured-Bar.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:124/255.0 green:177/255.0 blue:55/255.0 alpha:1.0]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    self.title = @"";
    //
    
    //self.title = @"Matched Pair Case Control";
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20.0]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    self.navigationItem.titleView = label;
    label.text = self.title;
    
    CGRect hiderFrame = CGRectMake(74, 762, 620, 1000);
    hiderView = [[UIView alloc] initWithFrame:hiderFrame];
    hiderView.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1.0];
//    hiderView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
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
        [fadingColorView setImage:[UIImage imageNamed:@"iPadBackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];

//        [self.view addSubview:hiderView];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
            [self.lowerNavigationBar setBarTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
        }
        
        [self.yyField setAccessibilityLabel:@"Cases and Controls both exposed"];
        [self.ynField setAccessibilityLabel:@"Cases exposed and Controls un exposed"];
        [self.nyField setAccessibilityLabel:@"Cases un exposed and Controls exposed"];
        [self.nnField setAccessibilityLabel:@"Cases and Controls both un exposed"];
        
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
                    if ([[(UILabel *)vi text] isEqualToString:@"McNemar"])
                        [vi setAccessibilityLabel:@"Mack neh Mar"];
                }
            }
            i++;
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

        phoneInputsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 102)];
        [self.view addSubview:phoneInputsView];
        [phoneInputsView addSubview:self.yyField];
        [phoneInputsView addSubview:self.ynField];
        [phoneInputsView addSubview:self.nyField];
        [phoneInputsView addSubview:self.nnField];
        [phoneInputsView addSubview:self.phoneCasesLabel];
        [phoneInputsView addSubview:self.phoneCasesPlusLabel];
        [self.phoneCasesMinusLabel setAccessibilityLabel:@"Minus"];
        [phoneInputsView addSubview:self.phoneCasesMinusLabel];
        [phoneInputsView addSubview:self.phoneControlsLabel];
        [phoneInputsView addSubview:self.phoneControlsPlusLabel];
        [self.phoneControlsMinusLabel setAccessibilityLabel:@"Minus"];
        [phoneInputsView addSubview:self.phoneControlsMinusLabel];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.phoneCasesLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phoneCasesPlusLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phoneCasesMinusLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phoneControlsLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phoneControlsPlusLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phoneControlsMinusLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phoneCasesLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            [self.phoneCasesPlusLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            [self.phoneCasesMinusLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            [self.phoneControlsLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            [self.phoneControlsPlusLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            [self.phoneControlsMinusLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        }
        [self.phoneCasesLabel setFrame:CGRectMake(self.phoneCasesLabel.frame.origin.x, self.phoneCasesLabel.frame.origin.y - self.phoneCasesLabel.frame.size.width / 5.0, self.phoneCasesLabel.frame.size.width, self.phoneCasesLabel.frame.size.height)];
        self.phoneCasesLabel.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
        phoneInputsColorBoxBorder = 2.0;
        phoneInputsColorBox = [[UIView alloc] initWithFrame:CGRectMake(self.yyField.frame.origin.x - phoneInputsColorBoxBorder, self.yyField.frame.origin.y - phoneInputsColorBoxBorder, self.ynField.frame.origin.x + self.ynField.frame.size.width + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.x, self.nnField.frame.origin.y + self.nnField.frame.size.height + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.y)];
        [phoneInputsColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneInputsColorBox.layer setCornerRadius:8.0];
        [phoneInputsView addSubview:phoneInputsColorBox];
        [phoneInputsView sendSubviewToBack:phoneInputsColorBox];
        BlurryView *blurryInputsView = [BlurryView new];
        [blurryInputsView setFrame:CGRectMake(0, 0, phoneInputsColorBox.frame.size.width, phoneInputsColorBox.frame.size.height)];
//        [phoneInputsColorBox addSubview:blurryInputsView];
        [blurryInputsView setBlurTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [blurryInputsView.layer setCornerRadius:8.0];

        phoneOddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(0, 117, 320, 88)];
        [self.view addSubview:phoneOddsBasedParametersView];
        [phoneOddsBasedParametersView addSubview:self.phoneOddsBasedSectionLabel];
        [self.phoneOddsBasedSectionLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneOddsBasedSectionLabel setTextColor:[UIColor whiteColor]];
        [self.phoneOddsBasedSectionLabel.layer setCornerRadius:10.0];
        [phoneOddsBasedParametersView addSubview:self.phoneEstimateLabel];
        [phoneOddsBasedParametersView addSubview:self.phoneLowerLabel];
        [phoneOddsBasedParametersView addSubview:self.phoneUpperLabel];
        [phoneOddsBasedParametersView addSubview:self.phoneOddsRatioLabel];
        [phoneOddsBasedParametersView addSubview:self.phoneExactLabel];
        [phoneOddsBasedParametersView addSubview:self.orEstimate];
        [phoneOddsBasedParametersView addSubview:self.orLower];
        [phoneOddsBasedParametersView addSubview:self.orUpper];
        [phoneOddsBasedParametersView addSubview:self.fisherLower];
        [phoneOddsBasedParametersView addSubview:self.fisherUpper];
        [self.phoneOddsBasedSectionLabel setFrame:CGRectMake(self.phoneStatisticalTestsSectionLabel.frame.origin.x, self.phoneOddsBasedSectionLabel.frame.origin.y - 128, 290, self.phoneOddsBasedSectionLabel.frame.size.height)];
        [self.phoneEstimateLabel setFrame:CGRectMake(self.phoneEstimateLabel.frame.origin.x, self.phoneEstimateLabel.frame.origin.y - 128, self.phoneEstimateLabel.frame.size.width, self.phoneEstimateLabel.frame.size.height)];
        [self.phoneLowerLabel setFrame:CGRectMake(self.phoneLowerLabel.frame.origin.x, self.phoneLowerLabel.frame.origin.y - 128, self.phoneLowerLabel.frame.size.width, self.phoneLowerLabel.frame.size.height)];
        [self.phoneUpperLabel setFrame:CGRectMake(self.phoneUpperLabel.frame.origin.x, self.phoneUpperLabel.frame.origin.y - 128, self.phoneUpperLabel.frame.size.width, self.phoneUpperLabel.frame.size.height)];
        [self.phoneOddsRatioLabel setFrame:CGRectMake(self.phoneOddsRatioLabel.frame.origin.x, self.phoneOddsRatioLabel.frame.origin.y - 128, self.phoneOddsRatioLabel.frame.size.width, self.phoneOddsRatioLabel.frame.size.height)];
        [self.phoneExactLabel setFrame:CGRectMake(self.phoneExactLabel.frame.origin.x, self.phoneExactLabel.frame.origin.y - 128, self.phoneExactLabel.frame.size.width, self.phoneExactLabel.frame.size.height)];
        [self.orEstimate setFrame:CGRectMake(self.orEstimate.frame.origin.x, self.orEstimate.frame.origin.y - 128, self.orEstimate.frame.size.width, self.orEstimate.frame.size.height)];
        [self.orLower setFrame:CGRectMake(self.orLower.frame.origin.x, self.orLower.frame.origin.y - 128, self.orLower.frame.size.width, self.orLower.frame.size.height)];
        [self.orUpper setFrame:CGRectMake(self.orUpper.frame.origin.x, self.orUpper.frame.origin.y - 128, self.orUpper.frame.size.width, self.orUpper.frame.size.height)];
        [self.fisherLower setFrame:CGRectMake(self.fisherLower.frame.origin.x, self.fisherLower.frame.origin.y - 128, self.fisherLower.frame.size.width, self.fisherLower.frame.size.height)];
        [self.fisherUpper setFrame:CGRectMake(self.fisherUpper.frame.origin.x, self.fisherUpper.frame.origin.y - 128, self.fisherUpper.frame.size.width, self.fisherUpper.frame.size.height)];

        phoneOddsBasedParametersColorBox = [[UIView alloc] initWithFrame:CGRectMake(self.phoneOddsBasedSectionLabel.frame.origin.x, self.phoneOddsBasedSectionLabel.frame.origin.y, self.phoneOddsBasedSectionLabel.frame.size.width, 69)];
        [phoneOddsBasedParametersColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneOddsBasedParametersColorBox.layer setCornerRadius:10.0];
        [phoneOddsBasedParametersView addSubview:phoneOddsBasedParametersColorBox];
        
        phoneOBPWhiteBox1 = [[UIView alloc] initWithFrame:CGRectMake(self.phoneOddsBasedSectionLabel.frame.origin.x + 2, self.phoneOddsBasedSectionLabel.frame.size.height + self.phoneOddsBasedSectionLabel.frame.origin.y, self.phoneOddsRatioLabel.frame.size.width + self.phoneOddsRatioLabel.frame.origin.x - 3, 14)];
        [phoneOBPWhiteBox1 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox1];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox1];
        
        phoneOBPWhiteBox2 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x + phoneOBPWhiteBox1.frame.size.width + 2, phoneOBPWhiteBox1.frame.origin.y, (phoneOddsBasedParametersColorBox.frame.size.width - phoneOBPWhiteBox1.frame.size.width - 6) / 3 - 1, 14)];
        [phoneOBPWhiteBox2 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox2];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox2];
        
        phoneOBPWhiteBox3 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox2.frame.origin.x + phoneOBPWhiteBox2.frame.size.width + 2, phoneOBPWhiteBox1.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 14)];
        [phoneOBPWhiteBox3 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox3];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox3];
        
        phoneOBPWhiteBox4 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox3.frame.origin.x + phoneOBPWhiteBox3.frame.size.width + 2, phoneOBPWhiteBox1.frame.origin.y, phoneOBPWhiteBox2.frame.size.width - 1, 14)];
        [phoneOBPWhiteBox4 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox4];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox4];
        
        phoneOBPWhiteBox5 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x, phoneOBPWhiteBox1.frame.origin.y + 16, phoneOBPWhiteBox1.frame.size.width, 14)];
        [phoneOBPWhiteBox5 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox5];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox5];
        
        phoneOBPWhiteBox6 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x + phoneOBPWhiteBox1.frame.size.width + 2, phoneOBPWhiteBox5.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 14)];
        [phoneOBPWhiteBox6 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox6];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox6];
        
        phoneOBPWhiteBox7 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox2.frame.origin.x + phoneOBPWhiteBox2.frame.size.width + 2, phoneOBPWhiteBox5.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 14)];
        [phoneOBPWhiteBox7 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox7];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox7];
        
        phoneOBPWhiteBox8 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox3.frame.origin.x + phoneOBPWhiteBox3.frame.size.width + 2, phoneOBPWhiteBox5.frame.origin.y, phoneOBPWhiteBox2.frame.size.width - 1, 14)];
        [phoneOBPWhiteBox8 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox8];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox8];
        
        phoneOBPWhiteBox9 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x, phoneOBPWhiteBox5.frame.origin.y + 16, phoneOBPWhiteBox1.frame.size.width, 14)];
        [phoneOBPWhiteBox9 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPWhiteBox9.layer setCornerRadius:8.0];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox9];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox9];
        phoneOBPExtraWhite1 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox9.frame.origin.x + 10, phoneOBPWhiteBox9.frame.origin.y, phoneOBPWhiteBox9.frame.size.width - 10, phoneOBPWhiteBox9.frame.size.height)];
        [phoneOBPExtraWhite1 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPExtraWhite1];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPExtraWhite1];
        phoneOBPExtraWhite3 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox9.frame.origin.x, phoneOBPWhiteBox9.frame.origin.y, 10, 7)];
        [phoneOBPExtraWhite3 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPExtraWhite3];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPExtraWhite3];
        
        phoneOBPWhiteBox10 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox1.frame.origin.x + phoneOBPWhiteBox1.frame.size.width + 2, phoneOBPWhiteBox9.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 14)];
        [phoneOBPWhiteBox10 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox10];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox10];
        
        phoneOBPWhiteBox11 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox2.frame.origin.x + phoneOBPWhiteBox2.frame.size.width + 2, phoneOBPWhiteBox9.frame.origin.y, phoneOBPWhiteBox2.frame.size.width, 14)];
        [phoneOBPWhiteBox11 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox11];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox11];
        
        phoneOBPWhiteBox12 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox3.frame.origin.x + phoneOBPWhiteBox3.frame.size.width + 2, phoneOBPWhiteBox9.frame.origin.y, phoneOBPWhiteBox2.frame.size.width - 1, 14)];
        [phoneOBPWhiteBox12 setBackgroundColor:[UIColor whiteColor]];
        [phoneOBPWhiteBox12.layer setCornerRadius:8.0];
        [phoneOddsBasedParametersView addSubview:phoneOBPWhiteBox12];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPWhiteBox12];
        phoneOBPExtraWhite2 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox12.frame.origin.x, phoneOBPWhiteBox12.frame.origin.y, 10, phoneOBPWhiteBox12.frame.size.height)];
        [phoneOBPExtraWhite2 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPExtraWhite2];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPExtraWhite2];
        phoneOBPExtraWhite4 = [[UIView alloc] initWithFrame:CGRectMake(phoneOBPWhiteBox12.frame.origin.x + 10, phoneOBPWhiteBox12.frame.origin.y, phoneOBPWhiteBox12.frame.size.width - 10, 7)];
        [phoneOBPExtraWhite4 setBackgroundColor:[UIColor whiteColor]];
        [phoneOddsBasedParametersView addSubview:phoneOBPExtraWhite4];
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOBPExtraWhite4];
        
        [phoneOddsBasedParametersView sendSubviewToBack:phoneOddsBasedParametersColorBox];
        
        phoneStatisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(0, 195, 320, 118)];
        [self.view addSubview:phoneStatisticalTestsView];
        [phoneStatisticalTestsView addSubview:self.phoneStatisticalTestsSectionLabel];
        [self.phoneStatisticalTestsSectionLabel  setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneStatisticalTestsSectionLabel setTextColor:[UIColor whiteColor]];
        [self.phoneStatisticalTestsSectionLabel.layer setCornerRadius:10.0];
        [self.phoneX2Label setAccessibilityLabel:@"Ky square"];
        [phoneStatisticalTestsView addSubview:self.phoneX2Label];
        [phoneStatisticalTestsView addSubview:self.phoneX2PLabel];
        [self.phoneMcNemarLabel setAccessibilityLabel:@"Mack neh mar"];
        [phoneStatisticalTestsView addSubview:self.phoneMcNemarLabel];
        [phoneStatisticalTestsView addSubview:self.phoneCorrectedLabel];
        [phoneStatisticalTestsView addSubview:self.phone1TailedPLabel];
        [phoneStatisticalTestsView addSubview:self.phone2TailedPLabel];
        [phoneStatisticalTestsView addSubview:self.phoneFisherExactLabel];
        [phoneStatisticalTestsView addSubview:self.uX2];
        [phoneStatisticalTestsView addSubview:self.uX2P];
        [phoneStatisticalTestsView addSubview:self.cX2];
        [phoneStatisticalTestsView addSubview:self.cX2P];
        [phoneStatisticalTestsView addSubview:self.fisherExact];
        [phoneStatisticalTestsView addSubview:self.fisherExact2];
        [self.phoneStatisticalTestsSectionLabel setFrame:CGRectMake(self.phoneStatisticalTestsSectionLabel.frame.origin.x, self.phoneStatisticalTestsSectionLabel.frame.origin.y - 207, 290, self.phoneStatisticalTestsSectionLabel.frame.size.height)];
        [self.phoneX2Label setFrame:CGRectMake(self.phoneX2Label.frame.origin.x, self.phoneX2Label.frame.origin.y - 207, self.phoneX2Label.frame.size.width, self.phoneX2Label.frame.size.height)];
        [self.phoneX2PLabel setFrame:CGRectMake(self.phoneX2PLabel.frame.origin.x, self.phoneX2PLabel.frame.origin.y - 207, self.phoneX2PLabel.frame.size.width, self.phoneX2PLabel.frame.size.height)];
        [self.phoneMcNemarLabel setFrame:CGRectMake(self.phoneMcNemarLabel.frame.origin.x, self.phoneMcNemarLabel.frame.origin.y - 207, self.phoneMcNemarLabel.frame.size.width, self.phoneMcNemarLabel.frame.size.height)];
        [self.phoneCorrectedLabel setFrame:CGRectMake(self.phoneCorrectedLabel.frame.origin.x, self.phoneCorrectedLabel.frame.origin.y - 207, self.phoneCorrectedLabel.frame.size.width, self.phoneCorrectedLabel.frame.size.height)];
        [self.phone1TailedPLabel setFrame:CGRectMake(self.phone1TailedPLabel.frame.origin.x, self.phone1TailedPLabel.frame.origin.y - 207, self.phone1TailedPLabel.frame.size.width, self.phone1TailedPLabel.frame.size.height)];
        [self.phone2TailedPLabel setFrame:CGRectMake(self.phone2TailedPLabel.frame.origin.x, self.phone2TailedPLabel.frame.origin.y - 207, self.phone2TailedPLabel.frame.size.width, self.phone2TailedPLabel.frame.size.height)];
        [self.phoneFisherExactLabel setFrame:CGRectMake(self.phoneFisherExactLabel.frame.origin.x, self.phoneFisherExactLabel.frame.origin.y - 207, self.phoneFisherExactLabel.frame.size.width, self.phoneFisherExactLabel.frame.size.height)];
        [self.uX2 setFrame:CGRectMake(self.uX2.frame.origin.x, self.uX2.frame.origin.y - 207, self.uX2.frame.size.width, self.uX2.frame.size.height)];
        [self.uX2P setFrame:CGRectMake(self.uX2P.frame.origin.x, self.uX2P.frame.origin.y - 207, self.uX2P.frame.size.width, self.uX2P.frame.size.height)];
        [self.cX2 setFrame:CGRectMake(self.cX2.frame.origin.x, self.cX2.frame.origin.y - 207, self.cX2.frame.size.width, self.cX2.frame.size.height)];
        [self.cX2P setFrame:CGRectMake(self.cX2P.frame.origin.x, self.cX2P.frame.origin.y - 207, self.cX2P.frame.size.width, self.cX2P.frame.size.height)];
        [self.fisherExact setFrame:CGRectMake(self.fisherExact.frame.origin.x, self.fisherExact.frame.origin.y - 207, self.fisherExact.frame.size.width, self.fisherExact.frame.size.height)];
        [self.fisherExact2 setFrame:CGRectMake(self.fisherExact2.frame.origin.x, self.fisherExact2.frame.origin.y - 207, self.fisherExact2.frame.size.width, self.fisherExact2.frame.size.height)];
        phoneStatisticalTestsColorBox = [[UIView alloc] initWithFrame:CGRectMake(self.phoneStatisticalTestsSectionLabel.frame.origin.x, self.phoneStatisticalTestsSectionLabel.frame.origin.y, self.phoneStatisticalTestsSectionLabel.frame.size.width, phoneStatisticalTestsView.frame.size.height - 7.0)];
        [phoneStatisticalTestsColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneStatisticalTestsColorBox.layer setCornerRadius:10.0];
        [phoneStatisticalTestsView addSubview:phoneStatisticalTestsColorBox];
        
        phoneSTWhiteBox1 = [[UIView alloc] initWithFrame:CGRectMake(phoneStatisticalTestsColorBox.frame.origin.x + 2.0, 23, (phoneStatisticalTestsColorBox.frame.size.width - 8) / 3, phoneOBPWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox1 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox1];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox1];
        
        phoneSTWhiteBox2 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox1.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox2 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox2];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox2];
        
        phoneSTWhiteBox3 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox1.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox3 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox3];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox3];
        
        phoneSTWhiteBox4 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox1.frame.origin.y + phoneOBPWhiteBox1.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox4 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox4];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox4];
        
        phoneSTWhiteBox5 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox4.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox5 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox5];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox5];
        
        phoneSTWhiteBox6 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox4.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox6 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox6];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox6];
        
        phoneSTWhiteBox7 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox4.frame.origin.y + phoneOBPWhiteBox4.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox7 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox7];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox7];
        
        phoneSTWhiteBox8 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox7.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox8 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox8];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox8];
        
        phoneSTWhiteBox9 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox7.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox9 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox9];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox9];
        
        phoneSTWhiteBox10 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox7.frame.origin.y + phoneOBPWhiteBox7.frame.size.height + 12, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox10 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox10];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox10];
        
        phoneSTWhiteBox11 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox10.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox11 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox11];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox11];
        
        phoneSTWhiteBox12 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox10.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox12 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox12];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox12];
        
        phoneSTWhiteBox13 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x, phoneSTWhiteBox10.frame.origin.y + phoneOBPWhiteBox10.frame.size.height + 2, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox13 setBackgroundColor:[UIColor whiteColor]];
        [phoneSTWhiteBox13.layer setCornerRadius:8.0];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox13];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox13];
        phoneSTExtraWhite1 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox13.frame.origin.x + 10, phoneSTWhiteBox13.frame.origin.y, phoneSTWhiteBox13.frame.size.width - 10, phoneSTWhiteBox13.frame.size.height)];
        [phoneSTExtraWhite1 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTExtraWhite1];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTExtraWhite1];
        phoneSTExtraWhite3 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox13.frame.origin.x, phoneSTWhiteBox13.frame.origin.y, 10, 7)];
        [phoneSTExtraWhite3 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTExtraWhite3];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTExtraWhite3];
        
        phoneSTWhiteBox14 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox1.frame.origin.x + phoneSTWhiteBox1.frame.size.width + 2, phoneSTWhiteBox13.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox14 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox14];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox14];
        
        phoneSTWhiteBox15 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox2.frame.origin.x + phoneSTWhiteBox2.frame.size.width + 2, phoneSTWhiteBox13.frame.origin.y, phoneSTWhiteBox1.frame.size.width, phoneSTWhiteBox1.frame.size.height)];
        [phoneSTWhiteBox15 setBackgroundColor:[UIColor whiteColor]];
        [phoneSTWhiteBox15.layer setCornerRadius:8.0];
        [phoneStatisticalTestsView addSubview:phoneSTWhiteBox15];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTWhiteBox15];
        phoneSTExtraWhite2 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox15.frame.origin.x, phoneSTWhiteBox15.frame.origin.y, 10, phoneSTWhiteBox15.frame.size.height)];
        [phoneSTExtraWhite2 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTExtraWhite2];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTExtraWhite2];
        phoneSTExtraWhite4 = [[UIView alloc] initWithFrame:CGRectMake(phoneSTWhiteBox15.frame.origin.x + 10, phoneSTWhiteBox15.frame.origin.y, phoneSTWhiteBox15.frame.size.width - 10, 7)];
        [phoneSTExtraWhite4 setBackgroundColor:[UIColor whiteColor]];
        [phoneStatisticalTestsView addSubview:phoneSTExtraWhite4];
        [phoneStatisticalTestsView sendSubviewToBack:phoneSTExtraWhite4];

        [phoneStatisticalTestsView sendSubviewToBack:phoneStatisticalTestsColorBox];
        
        phoneDisclaimersView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0 - 131, 331, 262, 99)];
        if (!fourInchPhone)
            [phoneDisclaimersView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 131, phoneStatisticalTestsView.frame.origin.y + phoneStatisticalTestsView.frame.size.height + 4, 262, 99)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [phoneDisclaimersView setBackgroundColor:[UIColor clearColor]];
        }
        [self.view addSubview:phoneDisclaimersView];
        phoneDisclaimersColorBox = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 258, 95)];
        [phoneDisclaimersColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneDisclaimersColorBox.layer setCornerRadius:10.0];
        [phoneDisclaimersView addSubview:phoneDisclaimersColorBox];
        [phoneDisclaimersColorBox setAlpha:0.0];
        phoneDisclaimersWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 254, 91)];
        [phoneDisclaimersWhiteBox setBackgroundColor:[UIColor whiteColor]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [phoneDisclaimersWhiteBox setBackgroundColor:[UIColor clearColor]];
            [self.discordantPairLabel setTextColor:[UIColor whiteColor]];
            [self.cellAdditionLabel setTextColor:[UIColor whiteColor]];
        }
        [phoneDisclaimersWhiteBox.layer setCornerRadius:8.0];
        [phoneDisclaimersView addSubview:phoneDisclaimersWhiteBox];
        [self.discordantPairLabel setFrame:CGRectMake(6, 4, 252, 63)];
        [self.cellAdditionLabel setFrame:CGRectMake(6, 74, 252, 21)];
        [phoneDisclaimersView addSubview:self.discordantPairLabel];
        [phoneDisclaimersView addSubview:self.cellAdditionLabel];
        
        //Add everything to the zoomingView
        for (UIView *view in self.view.subviews)
        {
            if (![view isKindOfClass:[UIScrollView class]])
            {
                [zoomingView addSubview:view];
                //Remove all struts and springs
                [view setAutoresizingMask:UIViewAutoresizingNone];
            }
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
            [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];
        }

        [fadingColorView removeFromSuperview];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        [self.yyField setAccessibilityLabel:@"Cases and Controls both exposed"];
        [self.ynField setAccessibilityLabel:@"Cases exposed and Controls un exposed"];
        [self.nyField setAccessibilityLabel:@"Cases un exposed and Controls exposed"];
        [self.nnField setAccessibilityLabel:@"Cases and Controls both un exposed"];
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
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                
                [self.subView1 setFrame:CGRectMake(0, 30, 372, 311)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 640.0, 30, 620, 593)];
                
                [hiderView setFrame:CGRectMake(self.view.frame.size.width - 640.0, 30 + 762 - 247, 620, 1000)];
                [self.computing setFrame:CGRectMake(self.subView2.frame.size.width / 2.1, self.subView2.frame.size.height / 4.5, computingFrame.size.width, computingFrame.size.height)];
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
            float X = 15.0;
            if (self.view.frame.size.width < 520)
                X = 30.0;
            float Y = -10.0;
            if (self.view.frame.size.width > 520)
                Y = 0.0;

            [UIView animateWithDuration:0.3 animations:^{
                [phoneInputsView setFrame:CGRectMake(-self.phoneCasesLabel.frame.origin.x + 1.0, 0, self.view.frame.size.width, 102)];
                [phoneStatisticalTestsView setFrame:CGRectMake(self.view.frame.size.width - phoneOddsBasedParametersView.frame.size.width + 5.0, 88 + Y, self.view.frame.size.width, 118)];
                [phoneOddsBasedParametersView setFrame:CGRectMake(self.view.frame.size.width - phoneOddsBasedParametersView.frame.size.width + 5.0, 0, self.view.frame.size.width, 88)];
                if (fourInchPhone)
                    [phoneDisclaimersView setFrame:CGRectMake(2, 110, 262, 99)];
                else
                {
                    [phoneDisclaimersView setFrame:CGRectMake(0, phoneStatisticalTestsView.frame.origin.y + phoneStatisticalTestsView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (phoneStatisticalTestsView.frame.origin.y + phoneStatisticalTestsView.frame.size.height))];
                    [self.discordantPairLabel setFrame:CGRectMake(6, 4, self.view.frame.size.width - 12, 42)];
                    [self.cellAdditionLabel setFrame:CGRectMake(6, 46, self.view.frame.size.width - 12, 21)];
                    [phoneDisclaimersColorBox setFrame:CGRectMake(2, 2, phoneDisclaimersView.frame.size.width - 4, phoneDisclaimersView.frame.size.height - 4)];
                    [phoneDisclaimersWhiteBox setFrame:CGRectMake(4, 4, phoneDisclaimersView.frame.size.width - 8, phoneDisclaimersView.frame.size.height - 8)];
                }
                [self.phoneControlsLabel setFrame:CGRectMake(self.phoneControlsLabel.frame.origin.x - 1.75 * X, self.phoneControlsLabel.frame.origin.y, self.phoneControlsLabel.frame.size.width, self.phoneControlsLabel.frame.size.height)];
                [self.phoneControlsMinusLabel setFrame:CGRectMake(self.phoneControlsMinusLabel.frame.origin.x - 2.75 * X, self.phoneControlsMinusLabel.frame.origin.y, self.phoneControlsMinusLabel.frame.size.width, self.phoneControlsMinusLabel.frame.size.height)];
                [self.ynField setFrame:CGRectMake(self.ynField.frame.origin.x - 2.75 * X, self.ynField.frame.origin.y, self.ynField.frame.size.width, self.ynField.frame.size.height)];
                [self.nnField setFrame:CGRectMake(self.nnField.frame.origin.x - 2.75 * X, self.nnField.frame.origin.y, self.nnField.frame.size.width, self.nnField.frame.size.height)];
                [self.phoneCasesPlusLabel setFrame:CGRectMake(self.phoneCasesPlusLabel.frame.origin.x - 0.25 * X, self.phoneCasesPlusLabel.frame.origin.y, self.phoneCasesPlusLabel.frame.size.width, self.phoneCasesPlusLabel.frame.size.height)];
                [self.phoneCasesMinusLabel setFrame:CGRectMake(self.phoneCasesMinusLabel.frame.origin.x - 0.25 * X, self.phoneCasesMinusLabel.frame.origin.y, self.phoneCasesMinusLabel.frame.size.width, self.phoneCasesMinusLabel.frame.size.height)];
                [self.yyField setFrame:CGRectMake(self.yyField.frame.origin.x - 0.5 * X, self.yyField.frame.origin.y, self.yyField.frame.size.width, self.yyField.frame.size.height)];
                [self.nyField setFrame:CGRectMake(self.nyField.frame.origin.x - 0.5 * X, self.nyField.frame.origin.y, self.nyField.frame.size.width, self.nyField.frame.size.height)];
                [self.phoneControlsPlusLabel setFrame:CGRectMake(self.phoneControlsPlusLabel.frame.origin.x - 0.5 * X, self.phoneControlsPlusLabel.frame.origin.y, self.phoneControlsPlusLabel.frame.size.width, self.phoneControlsPlusLabel.frame.size.height)];
                [phoneInputsColorBox setFrame:CGRectMake(self.yyField.frame.origin.x - phoneInputsColorBoxBorder, self.yyField.frame.origin.y - phoneInputsColorBoxBorder, self.ynField.frame.origin.x + self.ynField.frame.size.width + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.x, self.nnField.frame.origin.y + self.nnField.frame.size.height + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.y)];
            }];
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.twox2CalculatorView setContentSize:zoomingView.frame.size];
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/PMCCScreenPad.png" atomically:YES];
//    To here
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

- (void)viewDidUnload {
    [self setYyField:nil];
    [self setYnField:nil];
    [self setNyField:nil];
    [self setNnField:nil];
    [self setOrEstimate:nil];
    [self setOrLower:nil];
    [self setOrUpper:nil];
    [self setFisherLower:nil];
    [self setFisherUpper:nil];
    [self setUX2:nil];
    [self setUX2P:nil];
    [self setCX2:nil];
    [self setCX2P:nil];
    [self setFisherExact:nil];
    [self setFisherExact2:nil];
    [super viewDidUnload];
}
- (IBAction)compute:(id)sender
{
    self.yyString = self.yyField.text;
    self.ynString = self.ynField.text;
    self.nyString = self.nyField.text;
    self.nnString = self.nnField.text;
    
    [hiderView setHidden:YES];
    
    if (self.ynString.length > 0 && self.nyString.length > 0)
    {
        [self clearStats];
        
        int yy = [self.yyString intValue];
        int yn = [self.ynString intValue];
        int ny = [self.nyString intValue];
        int nn = [self.nnString intValue];
        
        MatchedPairCompute *computer = [[MatchedPairCompute alloc] init];
        
        self.orEstimate.text = [[NSString alloc] initWithFormat:@"%g", [computer OddsRatioEstimate:yy cellb:yn cellc:ny celld:nn]];
        self.orLower.text = [[NSString alloc] initWithFormat:@"%g", [computer OddsRatioLower:yy cellb:yn cellc:ny celld:nn]];
        self.orUpper.text = [[NSString alloc] initWithFormat:@"%g", [computer OddsRatioUpper:yy cellb:yn cellc:ny celld:nn]];
        if (ny > 0)
        {
            self.exactLimitsLabel.hidden = NO;
            double oneTailFish[2];
            [computer oneFish:yy cellb:yn cellc:ny celld:nn rvs:oneTailFish];
            self.fisherExact.text = [[NSString alloc] initWithFormat:@"%g", oneTailFish[0]];
            self.fisherExact2.text = [[NSString alloc] initWithFormat:@"%g", oneTailFish[1]];
            self.oneTailedPLabel.hidden = NO;
            self.twoTailedPLabel.hidden = NO;
            self.exactTestsLabel.hidden = NO;
            double fisherLimits[2];
            [computer fisherLimits:yy cellb:yn cellc:ny celld:nn limits:fisherLimits];
            self.fisherLower.text = [[NSString alloc] initWithFormat:@"%g", fisherLimits[0]];
            self.fisherUpper.text = [[NSString alloc] initWithFormat:@"%g", fisherLimits[1]];
        }
        else
        {
//            self.exactLimitsLabel.hidden = YES;
            self.fisherLower.text = @"...";
            self.fisherUpper.text = @"...";
//            self.oneTailedPLabel.hidden = YES;
//            self.twoTailedPLabel.hidden = YES;
//            self.exactTestsLabel.hidden = YES;
            self.fisherExact.text = @"...";
            self.fisherExact2.text = @"...";
        }
        double mcNemarValue = [computer McNemarUncorrectedVal:yy cellb:yn cellc:ny celld:nn];
        double correctedValue = [computer McNemarCorrectedVal:yy cellb:yn cellc:ny celld:nn];
        double mcNemarP = [SharedResources PValFromChiSq:mcNemarValue PVFCSdf:1.0];
        double correctedP = [SharedResources PValFromChiSq:correctedValue PVFCSdf:1.0];
        self.uX2.text = [[NSString alloc] initWithFormat:@"%g", mcNemarValue];
        self.uX2P.text = [[NSString alloc] initWithFormat:@"%g", mcNemarP];
        self.cX2.text = [[NSString alloc] initWithFormat:@"%g", correctedValue];
        self.cX2P.text = [[NSString alloc] initWithFormat:@"%g", correctedP];
        
        double discPairs = (double)yn + (double)ny;
        
        if (yn + ny < 20)
            self.discordantPairLabel.text = [[NSString alloc] initWithFormat:@"There are %g discordant pairs. Because this number is fewer than 20, it is recommended that only the exact results be used.", discPairs];
        else
            self.discordantPairLabel.text = [[NSString alloc] initWithFormat:@"There are %g discordant pairs. Because this number is >= 20, the McNemar test may be used.", discPairs];
        
        if (yn == 0 || ny == 0)
            self.cellAdditionLabel.text = [[NSString alloc] initWithFormat:@"0.5 has been added to each cell for calculations."];
        else
            self.cellAdditionLabel.text = [[NSString alloc] initWithFormat:@""];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            [phoneDisclaimersColorBox setAlpha:1.0];
    }
    else
    {
        self.orEstimate.text = [[NSString alloc] initWithFormat:@""];
        self.orLower.text = [[NSString alloc] initWithFormat:@""];
        self.orUpper.text = [[NSString alloc] initWithFormat:@""];
        self.fisherLower.text = [[NSString alloc] initWithFormat:@""];
        self.fisherUpper.text = [[NSString alloc] initWithFormat:@""];
        self.uX2.text = [[NSString alloc] initWithFormat:@""];
        self.uX2P.text = [[NSString alloc] initWithFormat:@""];
        self.cX2.text = [[NSString alloc] initWithFormat:@""];
        self.cX2P.text = [[NSString alloc] initWithFormat:@""];
        self.fisherExact.text = [[NSString alloc] initWithFormat:@""];
        self.fisherExact2.text = [[NSString alloc] initWithFormat:@""];
        self.discordantPairLabel.text = [[NSString alloc] initWithFormat:@""];
        self.cellAdditionLabel.text = [[NSString alloc] initWithFormat:@""];
        self.exactLimitsLabel.hidden = NO;
        self.exactTestsLabel.hidden = NO;
        self.oneTailedPLabel.hidden = NO;
        self.twoTailedPLabel.hidden = NO;
        [hiderView setHidden:NO];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            [phoneDisclaimersColorBox setAlpha:0.0];
    }
    [self.computing stopAnimating];
    [self.computing setHidden:YES];
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
    
    if ([workerThread isExecuting])
        [workerThread cancel];
    if ([self.computing isAnimating])
    {
        [self.computing stopAnimating];
        [self.computing setHidesWhenStopped:YES];
    }
    
    self.yyField.text = [[NSString alloc] initWithFormat:@""];
    self.ynField.text = [[NSString alloc] initWithFormat:@""];
    self.nyField.text = [[NSString alloc] initWithFormat:@""];
    self.nnField.text = [[NSString alloc] initWithFormat:@""];
    self.orEstimate.text = [[NSString alloc] initWithFormat:@""];
    self.orLower.text = [[NSString alloc] initWithFormat:@""];
    self.orUpper.text = [[NSString alloc] initWithFormat:@""];
    self.fisherLower.text = [[NSString alloc] initWithFormat:@""];
    self.fisherUpper.text = [[NSString alloc] initWithFormat:@""];
    self.uX2.text = [[NSString alloc] initWithFormat:@""];
    self.uX2P.text = [[NSString alloc] initWithFormat:@""];
    self.cX2.text = [[NSString alloc] initWithFormat:@""];
    self.cX2P.text = [[NSString alloc] initWithFormat:@""];
    self.fisherExact.text = [[NSString alloc] initWithFormat:@""];
    self.fisherExact2.text = [[NSString alloc] initWithFormat:@""];
    self.discordantPairLabel.text = [[NSString alloc] initWithFormat:@""];
    self.cellAdditionLabel.text = [[NSString alloc] initWithFormat:@""];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [phoneDisclaimersColorBox setAlpha:0.0];
    self.exactLimitsLabel.hidden = NO;
    self.exactTestsLabel.hidden = NO;
    self.oneTailedPLabel.hidden = NO;
    self.twoTailedPLabel.hidden = NO;
    [hiderView setHidden:NO];
}

- (void)clearStats
{
    self.orEstimate.text = [[NSString alloc] initWithFormat:@""];
    self.orLower.text = [[NSString alloc] initWithFormat:@""];
    self.orUpper.text = [[NSString alloc] initWithFormat:@""];
    self.fisherLower.text = [[NSString alloc] initWithFormat:@""];
    self.fisherUpper.text = [[NSString alloc] initWithFormat:@""];
    self.uX2.text = [[NSString alloc] initWithFormat:@""];
    self.uX2P.text = [[NSString alloc] initWithFormat:@""];
    self.cX2.text = [[NSString alloc] initWithFormat:@""];
    self.cX2P.text = [[NSString alloc] initWithFormat:@""];
    self.fisherExact.text = [[NSString alloc] initWithFormat:@""];
    self.fisherExact2.text = [[NSString alloc] initWithFormat:@""];
    self.discordantPairLabel.text = [[NSString alloc] initWithFormat:@""];
    self.cellAdditionLabel.text = [[NSString alloc] initWithFormat:@""];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [phoneDisclaimersColorBox setAlpha:0.0];
    self.exactLimitsLabel.hidden = NO;
    self.exactTestsLabel.hidden = NO;
    self.oneTailedPLabel.hidden = NO;
    self.twoTailedPLabel.hidden = NO;
    [hiderView setHidden:NO];
}

- (IBAction)textFieldAction:(id)sender
{    
    if ([workerThread isExecuting])
        [workerThread cancel];
    if ([self.computing isAnimating])
    {
        [self.computing stopAnimating];
        [self.computing setHidesWhenStopped:YES];
    }

    int cursorPosition = [sender offsetFromPosition:[sender endOfDocument] toPosition:[[sender selectedTextRange] start]];
    
    UITextField *theTextField = (UITextField *)sender;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [phoneOddsBasedParametersView addSubview:self.computing];
        [phoneOddsBasedParametersView bringSubviewToFront:self.computing];
        [self.computing setFrame:CGRectMake(phoneOddsBasedParametersView.frame.size.width / 2.0 - 13.5, phoneOddsBasedParametersView.frame.size.height / 2.0 - 13.5, 27, 27)];
        [self.computing setColor:[UIColor colorWithRed:221/255.0 green:85/255.0 blue:12/255.0 alpha:1.0]];
    }
    
    if (theTextField.text.length + cursorPosition == 0)
    {
        [sender resignFirstResponder];
        [self.computing setHidden:NO];
        [self.computing startAnimating];
        workerThread = [[NSThread alloc] initWithTarget:self selector:@selector(compute:) object:sender];
        [workerThread start];
        //    [self compute:sender];
        [sender becomeFirstResponder];
        return;
    }
    
    if (theTextField.text.length == 0)
    {
        [sender resignFirstResponder];
        [self.computing setHidden:NO];
        [self.computing startAnimating];
        workerThread = [[NSThread alloc] initWithTarget:self selector:@selector(compute:) object:sender];
        [workerThread start];
        //    [self compute:sender];
        [sender becomeFirstResponder];
        return;
    }
    
    NSCharacterSet *validSet; // = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
/*
    if ([[theTextField.text substringWithRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
    {
        theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1) withString:@""];
    }
    else
        [self compute:sender];
*/    
    validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < theTextField.text.length; i++)
    {
        if ([[theTextField.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
            theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
    }
    theTextField.text = [theTextField.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [sender resignFirstResponder];
    [self.computing setHidden:NO];
    [self.computing startAnimating];
    workerThread = [[NSThread alloc] initWithTarget:self selector:@selector(compute:) object:sender];
    [workerThread start];
//    [self compute:sender];
    [sender becomeFirstResponder];

    UITextPosition *newPosition = [sender positionFromPosition:[sender endOfDocument] offset:cursorPosition];
    [sender setSelectedTextRange:[sender textRangeFromPosition:newPosition toPosition:newPosition]];
}

- (IBAction)resetBarButtonPressed:(id)sender
{
    [self clearButtonPressed:sender];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
                
                [self.subView1 setFrame:CGRectMake(198, -10, 372, 311)];
                [self.subView2 setFrame:CGRectMake(74, 247, 620, 593)];
                
                [hiderView setFrame:CGRectMake(74, 762, 620, 1000)];
                [self.computing setFrame:computingFrame];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                
                [self.subView1 setFrame:CGRectMake(0, 30, 372, 311)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 640.0, 30, 620, 593)];
                
                [hiderView setFrame:CGRectMake(self.view.frame.size.width - 640.0, 30 + 762 - 247, 620, 1000)];
                [self.computing setFrame:CGRectMake(self.subView2.frame.size.width / 2.1, self.subView2.frame.size.height / 4.5, computingFrame.size.width, computingFrame.size.height)];
            }];
        }
    }
    else
    {
        float zs = [self.twox2CalculatorView zoomScale];
        [self.twox2CalculatorView setZoomScale:1.0 animated:YES];
        float X = 15.0;
        if ((!currentOrientationPortrait && self.view.frame.size.width < 520) || (currentOrientationPortrait && self.view.frame.size.height < 500))
            X = 30.0;
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [phoneInputsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 102)];
                [phoneOddsBasedParametersView setFrame:CGRectMake(0, 107, self.view.frame.size.width, 88)];
                [phoneStatisticalTestsView setFrame:CGRectMake(0, 195, self.view.frame.size.width, 118)];
                [phoneDisclaimersView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 131, 331, 262, 99)];
                [self.discordantPairLabel setFrame:CGRectMake(6, 4, 252, 63)];
                [self.cellAdditionLabel setFrame:CGRectMake(6, 74, 252, 21)];
                [phoneDisclaimersColorBox setFrame:CGRectMake(2, 2, 258, 95)];
                [phoneDisclaimersWhiteBox setFrame:CGRectMake(4, 4, 254, 91)];
                if (!fourInchPhone)
                    [phoneDisclaimersView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 131, phoneStatisticalTestsView.frame.origin.y + phoneStatisticalTestsView.frame.size.height + 4, 262, 99)];
                [self.phoneControlsLabel setFrame:CGRectMake(self.phoneControlsLabel.frame.origin.x + 1.75 * X, self.phoneControlsLabel.frame.origin.y, self.phoneControlsLabel.frame.size.width, self.phoneControlsLabel.frame.size.height)];
                [self.phoneControlsMinusLabel setFrame:CGRectMake(self.phoneControlsMinusLabel.frame.origin.x + 2.75 * X, self.phoneControlsMinusLabel.frame.origin.y, self.phoneControlsMinusLabel.frame.size.width, self.phoneControlsMinusLabel.frame.size.height)];
                [self.ynField setFrame:CGRectMake(self.ynField.frame.origin.x + 2.75 * X, self.ynField.frame.origin.y, self.ynField.frame.size.width, self.ynField.frame.size.height)];
                [self.nnField setFrame:CGRectMake(self.nnField.frame.origin.x + 2.75 * X, self.nnField.frame.origin.y, self.nnField.frame.size.width, self.nnField.frame.size.height)];
                [self.phoneCasesPlusLabel setFrame:CGRectMake(self.phoneCasesPlusLabel.frame.origin.x + .25 * X, self.phoneCasesPlusLabel.frame.origin.y, self.phoneCasesPlusLabel.frame.size.width, self.phoneCasesPlusLabel.frame.size.height)];
                [self.phoneCasesMinusLabel setFrame:CGRectMake(self.phoneCasesMinusLabel.frame.origin.x + .25 * X, self.phoneCasesMinusLabel.frame.origin.y, self.phoneCasesMinusLabel.frame.size.width, self.phoneCasesMinusLabel.frame.size.height)];
                [self.yyField setFrame:CGRectMake(self.yyField.frame.origin.x + .5 * X, self.yyField.frame.origin.y, self.yyField.frame.size.width, self.yyField.frame.size.height)];
                [self.nyField setFrame:CGRectMake(self.nyField.frame.origin.x + .5 * X, self.nyField.frame.origin.y, self.nyField.frame.size.width, self.nyField.frame.size.height)];
                [self.phoneControlsPlusLabel setFrame:CGRectMake(self.phoneControlsPlusLabel.frame.origin.x + .5 * X, self.phoneControlsPlusLabel.frame.origin.y, self.phoneControlsPlusLabel.frame.size.width, self.phoneControlsPlusLabel.frame.size.height)];
                [phoneInputsColorBox setFrame:CGRectMake(self.yyField.frame.origin.x - phoneInputsColorBoxBorder, self.yyField.frame.origin.y - phoneInputsColorBoxBorder, self.ynField.frame.origin.x + self.ynField.frame.size.width + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.x, self.nnField.frame.origin.y + self.nnField.frame.size.height + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.y)];
            }];
        }
        else
        {
            if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation))
            {
                float Y = -10;
                if (fourInchPhone)
                    Y = 0.0;

                [UIView animateWithDuration:0.3 animations:^{
                    [phoneInputsView setFrame:CGRectMake(-self.phoneCasesLabel.frame.origin.x + 1.0, 0, self.view.frame.size.width, 102)];
                    [phoneStatisticalTestsView setFrame:CGRectMake(self.view.frame.size.width - phoneOddsBasedParametersView.frame.size.width + 5.0, 88 + Y, self.view.frame.size.width, 118)];
                    [phoneOddsBasedParametersView setFrame:CGRectMake(self.view.frame.size.width - phoneOddsBasedParametersView.frame.size.width + 5.0, 0, self.view.frame.size.width, 88)];
                    if (fourInchPhone)
                        [phoneDisclaimersView setFrame:CGRectMake(2, 110, 262, 99)];
                    else
                    {
                        [phoneDisclaimersView setFrame:CGRectMake(0, phoneStatisticalTestsView.frame.origin.y + phoneStatisticalTestsView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (phoneStatisticalTestsView.frame.origin.y + phoneStatisticalTestsView.frame.size.height))];
                        [self.discordantPairLabel setFrame:CGRectMake(6, 4, self.view.frame.size.width - 12, 42)];
                        [self.cellAdditionLabel setFrame:CGRectMake(6, 46, self.view.frame.size.width - 12, 21)];
                        [phoneDisclaimersColorBox setFrame:CGRectMake(2, 2, phoneDisclaimersView.frame.size.width - 4, phoneDisclaimersView.frame.size.height - 4)];
                        [phoneDisclaimersWhiteBox setFrame:CGRectMake(4, 4, phoneDisclaimersView.frame.size.width - 8, phoneDisclaimersView.frame.size.height - 8)];
                    }
                    [self.phoneControlsLabel setFrame:CGRectMake(self.phoneControlsLabel.frame.origin.x - 1.75 * X, self.phoneControlsLabel.frame.origin.y, self.phoneControlsLabel.frame.size.width, self.phoneControlsLabel.frame.size.height)];
                    [self.phoneControlsMinusLabel setFrame:CGRectMake(self.phoneControlsMinusLabel.frame.origin.x - 2.75 * X, self.phoneControlsMinusLabel.frame.origin.y, self.phoneControlsMinusLabel.frame.size.width, self.phoneControlsMinusLabel.frame.size.height)];
                    [self.ynField setFrame:CGRectMake(self.ynField.frame.origin.x - 2.75 * X, self.ynField.frame.origin.y, self.ynField.frame.size.width, self.ynField.frame.size.height)];
                    [self.nnField setFrame:CGRectMake(self.nnField.frame.origin.x - 2.75 * X, self.nnField.frame.origin.y, self.nnField.frame.size.width, self.nnField.frame.size.height)];
                    [self.phoneCasesPlusLabel setFrame:CGRectMake(self.phoneCasesPlusLabel.frame.origin.x - 0.25 * X, self.phoneCasesPlusLabel.frame.origin.y, self.phoneCasesPlusLabel.frame.size.width, self.phoneCasesPlusLabel.frame.size.height)];
                    [self.phoneCasesMinusLabel setFrame:CGRectMake(self.phoneCasesMinusLabel.frame.origin.x - 0.25 * X, self.phoneCasesMinusLabel.frame.origin.y, self.phoneCasesMinusLabel.frame.size.width, self.phoneCasesMinusLabel.frame.size.height)];
                    [self.yyField setFrame:CGRectMake(self.yyField.frame.origin.x - 0.5 * X, self.yyField.frame.origin.y, self.yyField.frame.size.width, self.yyField.frame.size.height)];
                    [self.nyField setFrame:CGRectMake(self.nyField.frame.origin.x - 0.5 * X, self.nyField.frame.origin.y, self.nyField.frame.size.width, self.nyField.frame.size.height)];
                    [self.phoneControlsPlusLabel setFrame:CGRectMake(self.phoneControlsPlusLabel.frame.origin.x - 0.5 * X, self.phoneControlsPlusLabel.frame.origin.y, self.phoneControlsPlusLabel.frame.size.width, self.phoneControlsPlusLabel.frame.size.height)];
                    [phoneInputsColorBox setFrame:CGRectMake(self.yyField.frame.origin.x - phoneInputsColorBoxBorder, self.yyField.frame.origin.y - phoneInputsColorBoxBorder, self.ynField.frame.origin.x + self.ynField.frame.size.width + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.x, self.nnField.frame.origin.y + self.nnField.frame.size.height + 2 * phoneInputsColorBoxBorder - self.yyField.frame.origin.y)];
                }];
            }
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.twox2CalculatorView setContentSize:zoomingView.frame.size];
        
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
