//
//  BinomialCalculatorViewController.m
//  EpiInfo
//
//  Created by John Copeland on 10/12/12.
//

#import "BinomialCalculatorViewController.h"
#import "EpiInfoScrollView.h"
#import "BinomialCalculatorCompute.h"
#import "ButtonRight.h"
#import "ButtonLeft.h"

@interface BinomialCalculatorViewController ()
@property (nonatomic, weak) IBOutlet EpiInfoScrollView *epiInfoScrollView;
@end

@implementation BinomialCalculatorViewController

@synthesize expectedPercentageSlider = _expectedPercentageSlider;
@synthesize expectedPercentageStepper = _expectedPercentageStepper;
@synthesize resetBarButton = _resetBarButton;

@synthesize sliderLabel, numeratorField, denominatorField;

@synthesize computingCI = _computingCI;


-(void)setEpiInfoScrollView:(EpiInfoScrollView *)epiInfoScrollView
{
    _epiInfoScrollView = epiInfoScrollView;
    self.epiInfoScrollView.minimumZoomScale = 1.0;
    self.epiInfoScrollView.maximumZoomScale = 2.0;
    self.epiInfoScrollView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomingView;
}

- (void)doubleTapAction
{
    if (self.epiInfoScrollView.zoomScale < 2.0)
        [self.epiInfoScrollView setZoomScale:2.0 animated:YES];
    else
        [self.epiInfoScrollView setZoomScale:1.0 animated:YES];
}

-(void)viewDidLoad
{
    // Scroll View added in the storyboard. Not needed for this calulator.
    scrollViewFrame = CGRectMake(0, 43, 768,960);
    [self.epiInfoScrollView0 setScrollEnabled:NO];
    computingCIFrame = [self.computingCI frame];
    
    self.epiInfoScrollView.contentSize = CGSizeMake(320, 758);
    
    [self.computingCI setHidden:YES];
    
    //iPad
    // Background color doesn't matter. Background image will be used.
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"textured-Bar.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    // Set the title on the NavigationController
    self.title = @"";
    // Deprecation replacement
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    self.navigationItem.titleView = label;
    label.text = self.title;
    
    // Set the initial input values and compute the probabilities
    [self.numeratorField setText:@"3"];
    [self.denominatorField setText:@"16"];
    [self.expectedPercentageField setText:@"10"];
    [self.expectedPercentageSlider setValue:10.0 animated:YES];
    [self.expectedPercentageStepper setValue:self.expectedPercentageSlider.value];
    [self.sliderLabel setText:[[NSString alloc] initWithFormat:@"%0.1f", self.expectedPercentageSlider.value]];
    [self compute:self.numeratorField];
    [self.numeratorField resignFirstResponder];
    
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
        
        // Checking version of user's OS
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
            [self.lowerNavigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:130/255.0 blue:126/255.0 alpha:1.0]];
            [self.epiInfoScrollView0 setFrame:CGRectMake(scrollViewFrame.origin.x, scrollViewFrame.origin.y, scrollViewFrame.size.width, scrollViewFrame.size.height + 500)];
            [self.subView2 setFrame:CGRectMake(97, 306, 574, 470)];
        }
    }
    else // Phone
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
        
        // Set the background image
        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
        if (self.view.frame.size.height > 500)
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5BackgroundWhite.png"]];
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4BackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];

        // Set text field delegates so text fields can enforce number-only entries
        [self.numeratorField setDelegate:self];
        [self.denominatorField setDelegate:self];
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.epiInfoScrollView.frame.size.width, self.epiInfoScrollView.frame.size.height)];

        phoneInputsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 147)];
        [self.view addSubview:phoneInputsView];        
        [phoneInputsView addSubview:self.numeratorField];
        [phoneInputsView addSubview:self.denominatorField];
        [phoneInputsView addSubview:self.sliderLabel];
        [phoneInputsView addSubview:self.phonePercentSign];
        [phoneInputsView addSubview:self.expectedPercentageSlider];
        [phoneInputsView addSubview:self.phoneNumeratorLabel];
        [phoneInputsView addSubview:self.phoneTotalObservationsLabel];
        [phoneInputsView addSubview:self.phoneExpectedPercentageLabel];
        [phoneInputsView addSubview:self.phoneComputeButton];
        [phoneInputsView addSubview:self.phoneResetButton];
        
        // Epi Info only runs on iOS 7 or greater so this test is always true
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            // Adjust the position of the slider
            [self.expectedPercentageSlider setFrame:CGRectMake(self.expectedPercentageSlider.frame.origin.x, self.expectedPercentageSlider.frame.origin.y + 6.0, self.expectedPercentageSlider.frame.size.width, self.expectedPercentageSlider.frame.size.height)];
        }
        // Add the stepper buttons at each end of the slider
        ButtonLeft *bl = [[ButtonLeft alloc] initWithFrame:CGRectMake(self.expectedPercentageSlider.frame.origin.x - self.expectedPercentageSlider.frame.size.height - 5, self.expectedPercentageSlider.frame.origin.y, self.expectedPercentageSlider.frame.size.height, self.expectedPercentageSlider.frame.size.height) AndSlider:self.expectedPercentageSlider];
        [phoneInputsView addSubview:bl];
        ButtonRight *br = [[ButtonRight alloc] initWithFrame:CGRectMake(self.expectedPercentageSlider.frame.origin.x + self.expectedPercentageSlider.frame.size.width + 5, self.expectedPercentageSlider.frame.origin.y, self.expectedPercentageSlider.frame.size.height, self.expectedPercentageSlider.frame.size.height) AndSlider:self.expectedPercentageSlider];
        [phoneInputsView addSubview:br];
        
        // Set up the results display on the phone
        phoneResultsView = [[UIView alloc] initWithFrame:CGRectMake(18, 147, 277, 300)];
        [self.view addSubview:phoneResultsView];

        [self.phoneSectionHeaderLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneSectionHeaderLabel setFrame:CGRectMake(2, 2, self.phoneSectionHeaderLabel.frame.size.width, self.phoneSectionHeaderLabel.frame.size.height)];
        [self.phoneSectionHeaderLabel.layer setCornerRadius:10.0];
        [phoneResultsView addSubview:self.phoneSectionHeaderLabel];
        
        [phoneResultsView addSubview:self.ltLabel];
        [phoneResultsView addSubview:self.ltValue];
        [phoneResultsView addSubview:self.leLabel];
        [phoneResultsView addSubview:self.leValue];
        [phoneResultsView addSubview:self.eqLabel];
        [phoneResultsView addSubview:self.eqValue];
        [phoneResultsView addSubview:self.geLabel];
        [phoneResultsView addSubview:self.geValue];
        [phoneResultsView addSubview:self.gtLabel];
        [phoneResultsView addSubview:self.gtValue];
        
        phonePValueView = [[UIView alloc] initWithFrame:CGRectMake(18, 348, 277, 28)];
        [self.view addSubview:phonePValueView];
        [self.phonePValueLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phonePValueLabel setFrame:CGRectMake(2, 2, self.phonePValueLabel.frame.size.width, self.phonePValueLabel.frame.size.height)];
        [self.phonePValueLabel.layer setCornerRadius:10.0];
        [phonePValueView addSubview:self.phonePValueLabel];
        [phonePValueView addSubview:self.pValue];
        
        phoneCIView = [[UIView alloc] initWithFrame:CGRectMake(18, 376, 277, 28)];
        [self.view addSubview:phoneCIView];
        [self.phoneCILabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneCILabel setFrame:CGRectMake(2, 2, self.phoneCILabel.frame.size.width, self.phoneCILabel.frame.size.height)];
        [self.phoneCILabel.layer setCornerRadius:10.0];
        [phoneCIView addSubview:self.phoneCILabel];
        [phoneCIView addSubview:self.ciValue];
        
        float X = self.phoneSectionHeaderLabel.frame.origin.x;
        float Y = self.phoneSectionHeaderLabel.frame.origin.y;
        float W = self.phoneSectionHeaderLabel.frame.size.width;
        float H = self.ltLabel.frame.size.height;
        
        phoneColorBox = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, 200)];
        [phoneColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneColorBox.layer setCornerRadius:10.0];
        
        [phoneResultsView addSubview:phoneColorBox];
        
        phoneWhiteBox0 = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
        [phoneWhiteBox0 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox0];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox0];
        
        phoneWhiteBox1 = [[UIView alloc] initWithFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
        [phoneWhiteBox1 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox1];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox1];
        
        phoneWhiteBox2 = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
        [phoneWhiteBox2 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox2];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox2];
        
        phoneWhiteBox3 = [[UIView alloc] initWithFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
        [phoneWhiteBox3 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox3];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox3];
        
        phoneWhiteBox4 = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
        [phoneWhiteBox4 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox4];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox4];
        
        phoneWhiteBox5 = [[UIView alloc] initWithFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
        [phoneWhiteBox5 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox5];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox5];
        
        phoneWhiteBox6 = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
        [phoneWhiteBox6 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox6];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox6];
        
        phoneWhiteBox7 = [[UIView alloc] initWithFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
        [phoneWhiteBox7 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox7];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox7];
        
        phoneWhiteBox8 = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 2.0, W - 3.0, H + 5.0)];
        [phoneWhiteBox8 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox8];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox8];
        [phoneWhiteBox8.layer setCornerRadius:8.0];
        phoneExtraWhite0 = [[UIView alloc] initWithFrame:CGRectMake(X + 12.0, Y - 2.0, W - 13.0, H + 5.0)];
        [phoneExtraWhite0 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneExtraWhite0];
        [phoneResultsView sendSubviewToBack:phoneExtraWhite0];
        phoneExtraWhite2 = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 2.0, W / 4.0, H / 2.0)];
        [phoneExtraWhite2 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneExtraWhite2];
        [phoneResultsView sendSubviewToBack:phoneExtraWhite2];
        
        phoneWhiteBox9 = [[UIView alloc] initWithFrame:CGRectMake(X + 4.0, Y - 2.0, W - 6.0, H + 5.0)];
        [phoneWhiteBox9 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneWhiteBox9];
        [phoneResultsView sendSubviewToBack:phoneWhiteBox9];
        [phoneWhiteBox9.layer setCornerRadius:8.0];
        phoneExtraWhite1 = [[UIView alloc] initWithFrame:CGRectMake(X + 4.0, Y - 2.0, W - 16.0, H + 5.0)];
        [phoneExtraWhite1 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneExtraWhite1];
        [phoneResultsView sendSubviewToBack:phoneExtraWhite1];
        phoneExtraWhite3 = [[UIView alloc] initWithFrame:CGRectMake(X + 4.0 + (W - 6.0) * 0.75, Y - 2.0, (W - 6.0) / 4.0, H / 2.0)];
        [phoneExtraWhite3 setBackgroundColor:[UIColor whiteColor]];
        [phoneResultsView addSubview:phoneExtraWhite3];
        [phoneResultsView sendSubviewToBack:phoneExtraWhite3];
        
        [phoneResultsView sendSubviewToBack:phoneColorBox];
        
        X = self.phonePValueLabel.frame.origin.x;
        Y = self.phonePValueLabel.frame.origin.y;
        W = phonePValueView.frame.size.width;
        H = self.phonePValueLabel.frame.size.height;
        
        phonePValueColorBox = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [phonePValueColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phonePValueColorBox.layer setCornerRadius:10.0];
        [phonePValueView addSubview:phonePValueColorBox];
        phonePValueWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
        [phonePValueWhiteBox setBackgroundColor:[UIColor whiteColor]];
        [phonePValueWhiteBox.layer setCornerRadius:8.0];
        [phonePValueView addSubview:phonePValueWhiteBox];
        phonePValueExtraWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 3.0, W / 2.0, H + 6.0)];
        [phonePValueExtraWhiteBox setBackgroundColor:[UIColor whiteColor]];
        [phonePValueView addSubview:phonePValueExtraWhiteBox];
        [phonePValueView sendSubviewToBack:phonePValueExtraWhiteBox];
        [phonePValueView sendSubviewToBack:phonePValueWhiteBox];
        [phonePValueView sendSubviewToBack:phonePValueColorBox];
        
        X = self.phoneCILabel.frame.origin.x;
        Y = self.phoneCILabel.frame.origin.y;
        W = phoneCIView.frame.size.width;
        H = self.phoneCILabel.frame.size.height;
        
        phoneCIColorBox = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [phoneCIColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneCIColorBox.layer setCornerRadius:10.0];
        [phoneCIView addSubview:phoneCIColorBox];
        phoneCIWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
        [phoneCIWhiteBox setBackgroundColor:[UIColor whiteColor]];
        [phoneCIWhiteBox.layer setCornerRadius:8.0];
        [phoneCIView addSubview:phoneCIWhiteBox];
        phoneCIExtraWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(X + 2.0, Y - 3.0, W / 2.0, H + 6.0)];
        [phoneCIExtraWhiteBox setBackgroundColor:[UIColor whiteColor]];
        [phoneCIView addSubview:phoneCIExtraWhiteBox];
        [phoneCIView sendSubviewToBack:phoneCIExtraWhiteBox];
        [phoneCIView sendSubviewToBack:phoneCIWhiteBox];
        [phoneCIView sendSubviewToBack:phoneCIColorBox];
        
        [phoneCIView addSubview:self.computingCI];
        
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
        [self.epiInfoScrollView addSubview:zoomingView];
        
        //Add double-tap zooming
        //Except don't add this because it interferes with the arrows.
//        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
//        [tgr setNumberOfTapsRequired:2];
//        [tgr setNumberOfTouchesRequired:1];
//        [self.epiInfoScrollView addGestureRecognizer:tgr];
        
//        [self.epiInfoScrollView setShowsVerticalScrollIndicator:NO];
//        [self.epiInfoScrollView setShowsHorizontalScrollIndicator:NO];
        [self.epiInfoScrollView setShowsVerticalScrollIndicator:YES];
        [self.epiInfoScrollView setShowsHorizontalScrollIndicator:YES];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            float Y = phoneResultsView.frame.origin.y;
            float H = 21.0;
            
            [self.ltLabel setFrame:CGRectMake(self.ltLabel.frame.origin.x - phoneResultsView.frame.origin.x, 177 - Y, self.ltLabel.frame.size.width, H)];
            [self.ltValue setFrame:CGRectMake(self.ltValue.frame.origin.x - phoneResultsView.frame.origin.x, 177 - Y, self.ltValue.frame.size.width, H)];
            
            [self.leLabel setFrame:CGRectMake(self.leLabel.frame.origin.x - phoneResultsView.frame.origin.x, 206 - Y, self.leLabel.frame.size.width, H)];
            [self.leValue setFrame:CGRectMake(self.leValue.frame.origin.x - phoneResultsView.frame.origin.x, 206 - Y, self.leValue.frame.size.width, H)];
            
            [self.eqLabel setFrame:CGRectMake(self.eqLabel.frame.origin.x - phoneResultsView.frame.origin.x, 235 - Y, self.eqLabel.frame.size.width, H)];
            [self.eqValue setFrame:CGRectMake(self.eqValue.frame.origin.x - phoneResultsView.frame.origin.x, 235 - Y, self.eqValue.frame.size.width, H)];
            
            [self.geLabel setFrame:CGRectMake(self.geLabel.frame.origin.x - phoneResultsView.frame.origin.x, 264 - Y, self.geLabel.frame.size.width, H)];
            [self.geValue setFrame:CGRectMake(self.geValue.frame.origin.x - phoneResultsView.frame.origin.x, 264 - Y, self.geValue.frame.size.width, H)];
            
            [self.gtLabel setFrame:CGRectMake(self.gtLabel.frame.origin.x - phoneResultsView.frame.origin.x, 293 - Y, self.gtLabel.frame.size.width, H)];
            [self.gtValue setFrame:CGRectMake(self.gtValue.frame.origin.x - phoneResultsView.frame.origin.x, 293 - Y, self.gtValue.frame.size.width, H)];
            
            Y = phonePValueView.frame.origin.y;
            [self.pValue setFrame:CGRectMake(self.pValue.frame.origin.x - phonePValueView.frame.origin.x, 350 - Y, self.pValue.frame.size.width, 20)];
            
            Y = phoneCIView.frame.origin.y;
            [self.ciValue setFrame:CGRectMake(self.ciValue.frame.origin.x - phoneCIView.frame.origin.x, 378 - Y, self.ciValue.frame.size.width, 20)];
            
            float X = self.phoneSectionHeaderLabel.frame.origin.x;
            Y = self.phoneSectionHeaderLabel.frame.origin.y;
            float W = self.phoneSectionHeaderLabel.frame.size.width;
            H = self.phoneSectionHeaderLabel.frame.size.height + self.ltLabel.frame.size.height * 7;
            
            [phoneColorBox setFrame:CGRectMake(X, Y, W, H + 2.0)];
            
            X = self.ltLabel.frame.origin.x;
            Y = self.ltLabel.frame.origin.y;
            W = self.ltLabel.frame.size.width;
            H = self.ltLabel.frame.size.height;
            [phoneWhiteBox0 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
            
            X = self.ltValue.frame.origin.x;
            Y = self.ltValue.frame.origin.y;
            W = self.ltValue.frame.size.width;
            H = self.ltValue.frame.size.height;
            [phoneWhiteBox1 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
            
            X = self.leLabel.frame.origin.x;
            Y = self.leLabel.frame.origin.y;
            W = self.leLabel.frame.size.width;
            H = self.leLabel.frame.size.height;
            [phoneWhiteBox2 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
            
            X = self.leValue.frame.origin.x;
            Y = self.leValue.frame.origin.y;
            W = self.leValue.frame.size.width;
            H = self.leValue.frame.size.height;
            [phoneWhiteBox3 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
            
            X = self.eqLabel.frame.origin.x;
            Y = self.eqLabel.frame.origin.y;
            W = self.eqLabel.frame.size.width;
            H = self.eqLabel.frame.size.height;
            [phoneWhiteBox4 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
            
            X = self.eqValue.frame.origin.x;
            Y = self.eqValue.frame.origin.y;
            W = self.eqValue.frame.size.width;
            H = self.eqValue.frame.size.height;
            [phoneWhiteBox5 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
            
            X = self.geLabel.frame.origin.x;
            Y = self.geLabel.frame.origin.y;
            W = self.geLabel.frame.size.width;
            H = self.geLabel.frame.size.height;
            [phoneWhiteBox6 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
            
            X = self.geValue.frame.origin.x;
            Y = self.geValue.frame.origin.y;
            W = self.geValue.frame.size.width;
            H = self.geValue.frame.size.height;
            [phoneWhiteBox7 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
            
            X = self.gtLabel.frame.origin.x;
            Y = self.gtLabel.frame.origin.y;
            W = self.gtLabel.frame.size.width;
            H = self.gtLabel.frame.size.height;
            [phoneWhiteBox8 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 5.0)];
            [phoneExtraWhite0 setFrame:CGRectMake(X + 12.0, Y - 3.0, W - 13.0, H + 5.0)];
            [phoneExtraWhite2 setFrame:CGRectMake(X + 2.0, Y - 3.0, W / 4.0, H / 2.0)];
            
            X = self.gtValue.frame.origin.x;
            Y = self.gtValue.frame.origin.y;
            W = self.gtValue.frame.size.width;
            H = self.gtValue.frame.size.height;
            [phoneWhiteBox9 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 5.0)];
            [phoneExtraWhite1 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 16.0, H + 5.0)];
            [phoneExtraWhite3 setFrame:CGRectMake(X + 4.0 + (W - 6.0) * 0.75, Y - 3.0, (W - 6.0) / 4.0, H / 2.0)];
            
            X = self.pValue.frame.origin.x;
            Y = phonePValueColorBox.frame.origin.y;
            W = self.pValue.frame.size.width;
            H = phonePValueColorBox.frame.size.height;
            [phonePValueWhiteBox setFrame:CGRectMake(X + 4.0, Y + 1.5, W - 1.5, H - 3.0)];
            [phonePValueExtraWhiteBox setFrame:CGRectMake(X + 4.0, Y + 1.5, W / 2.0, H - 3.0)];
            
            X = self.ciValue.frame.origin.x;
            Y = phoneCIColorBox.frame.origin.y;
            W = self.ciValue.frame.size.width;
            H = phoneCIColorBox.frame.size.height;
            [phoneCIWhiteBox setFrame:CGRectMake(X + 4.0, Y + 1.5, W - 1.5, H - 3.0)];
            [phoneCIExtraWhiteBox setFrame:CGRectMake(X + 4.0, Y + 1.5, W / 2.0, H - 3.0)];
            [self.computingCI setFrame:CGRectMake(self.ciValue.frame.origin.x, self.ciValue.center.y - self.computingCI.frame.size.height / 2.0, self.computingCI.frame.size.width, self.computingCI.frame.size.height)];
            
            label.text = @"";

            if (self.view.frame.size.height > 500)
            {
                // If 4-inch phone
                [phoneResultsView setFrame:CGRectMake(phoneResultsView.frame.origin.x, phoneResultsView.frame.origin.y + 20.0, phoneResultsView.frame.size.width, phoneResultsView.frame.size.height)];
                [self.expectedPercentageSlider setFrame:CGRectMake(self.expectedPercentageSlider.frame.origin.x, self.expectedPercentageSlider.frame.origin.y + 10, self.expectedPercentageSlider.frame.size.width, self.expectedPercentageSlider.frame.size.height)];
                [bl setFrame:CGRectMake(bl.frame.origin.x, bl.frame.origin.y + 10, bl.frame.size.width, bl.frame.size.height)];
                [br setFrame:CGRectMake(br.frame.origin.x, br.frame.origin.y + 10, br.frame.size.width, br.frame.size.height)];
                [self.expectedPercentageField setFrame:CGRectMake(self.expectedPercentageField.frame.origin.x, self.phoneExpectedPercentageLabel.frame.origin.y - 4, self.expectedPercentageField.frame.size.width, self.expectedPercentageField.frame.size.height)];
                [self.phonePercentSign setFrame:CGRectMake(self.phonePercentSign.frame.origin.x, self.phoneExpectedPercentageLabel.frame.origin.y, self.phonePercentSign.frame.size.width, self.phonePercentSign.frame.size.height)];
            }
            else
            {
                // If 3.5-inch phone
                [phoneResultsView setFrame:CGRectMake(phoneResultsView.frame.origin.x, phoneResultsView.frame.origin.y + 20.0, phoneResultsView.frame.size.width, phoneResultsView.frame.size.height)];
                [self.expectedPercentageSlider setFrame:CGRectMake(self.expectedPercentageSlider.frame.origin.x, self.expectedPercentageSlider.frame.origin.y + 10, self.expectedPercentageSlider.frame.size.width, self.expectedPercentageSlider.frame.size.height)];
                [bl setFrame:CGRectMake(bl.frame.origin.x, bl.frame.origin.y + 10, bl.frame.size.width, bl.frame.size.height)];
                [br setFrame:CGRectMake(br.frame.origin.x, br.frame.origin.y + 10, br.frame.size.width, br.frame.size.height)];
                [self.phoneExpectedPercentageLabel setFrame:CGRectMake(self.phoneExpectedPercentageLabel.frame.origin.x, self.phonePercentSign.frame.origin.y, self.phoneExpectedPercentageLabel.frame.size.width, self.phoneExpectedPercentageLabel.frame.size.height)];
                [self.phoneTotalObservationsLabel setFrame:CGRectMake(self.phoneTotalObservationsLabel.frame.origin.x, self.phoneTotalObservationsLabel.frame.origin.y + 10.0, self.phoneTotalObservationsLabel.frame.size.width, self.phoneTotalObservationsLabel.frame.size.height)];
                [self.denominatorField setFrame:CGRectMake(self.denominatorField.frame.origin.x, self.denominatorField.frame.origin.y + 10.0, self.denominatorField.frame.size.width, self.denominatorField.frame.size.height)];
            }
            [self.expectedPercentageField setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phonePercentSign setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phonePercentSign setFont:[UIFont boldSystemFontOfSize:12.0]];
            [self.phoneNumeratorLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phoneNumeratorLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
            [self.phoneTotalObservationsLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phoneTotalObservationsLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
            [self.phoneExpectedPercentageLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.phoneExpectedPercentageLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
            [self.expectedPercentageSlider setMinimumTrackTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [self.expectedPercentageSlider setMaximumTrackTintColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
            
            [self.phoneExpectedPercentageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        }
        
        [fadingColorView removeFromSuperview];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, self.view.frame.size.height - 400.0, [self.view frame].size.width, 400.0)];
                
                [self.subView1 setFrame:CGRectMake(-20, 20, 498, 387)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 554, 25, 574, 470)];
                
                [self.computingCI setFrame:CGRectMake(-15, self.subView2.frame.size.height / 3.0, computingCIFrame.size.width, computingCIFrame.size.height)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                
                [self.subView1 setFrame:CGRectMake(135, -1, 498, 387)];
                [self.subView2 setFrame:CGRectMake(97, 306, 574, 470)];
                
                [self.computingCI setFrame:computingCIFrame];
            }];
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            // Turn the Clear button text white
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
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        {
            // Position the results
            float Y = phoneResultsView.frame.origin.y;
            float H = 21.0;
            
            [self.ltLabel setFrame:CGRectMake(self.ltLabel.frame.origin.x - phoneResultsView.frame.origin.x, 177 - Y, self.ltLabel.frame.size.width, H)];
            [self.ltValue setFrame:CGRectMake(self.ltValue.frame.origin.x - phoneResultsView.frame.origin.x, 177 - Y, self.ltValue.frame.size.width, H)];
            
            [self.leLabel setFrame:CGRectMake(self.leLabel.frame.origin.x - phoneResultsView.frame.origin.x, 206 - Y, self.leLabel.frame.size.width, H)];
            [self.leValue setFrame:CGRectMake(self.leValue.frame.origin.x - phoneResultsView.frame.origin.x, 206 - Y, self.leValue.frame.size.width, H)];
            
            [self.eqLabel setFrame:CGRectMake(self.eqLabel.frame.origin.x - phoneResultsView.frame.origin.x, 235 - Y, self.eqLabel.frame.size.width, H)];
            [self.eqValue setFrame:CGRectMake(self.eqValue.frame.origin.x - phoneResultsView.frame.origin.x, 235 - Y, self.eqValue.frame.size.width, H)];
            
            [self.geLabel setFrame:CGRectMake(self.geLabel.frame.origin.x - phoneResultsView.frame.origin.x, 264 - Y, self.geLabel.frame.size.width, H)];
            [self.geValue setFrame:CGRectMake(self.geValue.frame.origin.x - phoneResultsView.frame.origin.x, 264 - Y, self.geValue.frame.size.width, H)];
            
            [self.gtLabel setFrame:CGRectMake(self.gtLabel.frame.origin.x - phoneResultsView.frame.origin.x, 293 - Y, self.gtLabel.frame.size.width, H)];
            [self.gtValue setFrame:CGRectMake(self.gtValue.frame.origin.x - phoneResultsView.frame.origin.x, 293 - Y, self.gtValue.frame.size.width, H)];
            
            Y = phonePValueView.frame.origin.y;
            [self.pValue setFrame:CGRectMake(self.pValue.frame.origin.x - phonePValueView.frame.origin.x, 350 - Y, self.pValue.frame.size.width, 20)];
            
            Y = phoneCIView.frame.origin.y;
            [self.ciValue setFrame:CGRectMake(self.ciValue.frame.origin.x - phoneCIView.frame.origin.x, 378 - Y, self.ciValue.frame.size.width, 20)];
            
            float X = self.phoneSectionHeaderLabel.frame.origin.x;
            Y = self.phoneSectionHeaderLabel.frame.origin.y;
            float W = self.phoneSectionHeaderLabel.frame.size.width;
            H = self.phoneSectionHeaderLabel.frame.size.height + self.ltLabel.frame.size.height * 7;
            
            [phoneColorBox setFrame:CGRectMake(X, Y, W, H + 2.0)];
            
            X = self.ltLabel.frame.origin.x;
            Y = self.ltLabel.frame.origin.y;
            W = self.ltLabel.frame.size.width;
            H = self.ltLabel.frame.size.height;
            [phoneWhiteBox0 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
            
            X = self.ltValue.frame.origin.x;
            Y = self.ltValue.frame.origin.y;
            W = self.ltValue.frame.size.width;
            H = self.ltValue.frame.size.height;
            [phoneWhiteBox1 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
            
            X = self.leLabel.frame.origin.x;
            Y = self.leLabel.frame.origin.y;
            W = self.leLabel.frame.size.width;
            H = self.leLabel.frame.size.height;
            [phoneWhiteBox2 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
            
            X = self.leValue.frame.origin.x;
            Y = self.leValue.frame.origin.y;
            W = self.leValue.frame.size.width;
            H = self.leValue.frame.size.height;
            [phoneWhiteBox3 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
            
            X = self.eqLabel.frame.origin.x;
            Y = self.eqLabel.frame.origin.y;
            W = self.eqLabel.frame.size.width;
            H = self.eqLabel.frame.size.height;
            [phoneWhiteBox4 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
            
            X = self.eqValue.frame.origin.x;
            Y = self.eqValue.frame.origin.y;
            W = self.eqValue.frame.size.width;
            H = self.eqValue.frame.size.height;
            [phoneWhiteBox5 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
            
            X = self.geLabel.frame.origin.x;
            Y = self.geLabel.frame.origin.y;
            W = self.geLabel.frame.size.width;
            H = self.geLabel.frame.size.height;
            [phoneWhiteBox6 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 6.0)];
            
            X = self.geValue.frame.origin.x;
            Y = self.geValue.frame.origin.y;
            W = self.geValue.frame.size.width;
            H = self.geValue.frame.size.height;
            [phoneWhiteBox7 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 6.0)];
            
            X = self.gtLabel.frame.origin.x;
            Y = self.gtLabel.frame.origin.y;
            W = self.gtLabel.frame.size.width;
            H = self.gtLabel.frame.size.height;
            [phoneWhiteBox8 setFrame:CGRectMake(X + 2.0, Y - 3.0, W - 3.0, H + 5.0)];
            [phoneExtraWhite0 setFrame:CGRectMake(X + 12.0, Y - 3.0, W - 13.0, H + 5.0)];
            [phoneExtraWhite2 setFrame:CGRectMake(X + 2.0, Y - 3.0, W / 4.0, H / 2.0)];
            
            X = self.gtValue.frame.origin.x;
            Y = self.gtValue.frame.origin.y;
            W = self.gtValue.frame.size.width;
            H = self.gtValue.frame.size.height;
            [phoneWhiteBox9 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 6.0, H + 5.0)];
            [phoneExtraWhite1 setFrame:CGRectMake(X + 4.0, Y - 3.0, W - 16.0, H + 5.0)];
            [phoneExtraWhite3 setFrame:CGRectMake(X + 4.0 + (W - 6.0) * 0.75, Y - 3.0, (W - 6.0) / 4.0, H / 2.0)];
            
            X = self.pValue.frame.origin.x;
            Y = phonePValueColorBox.frame.origin.y;
            W = self.pValue.frame.size.width;
            H = phonePValueColorBox.frame.size.height;
            [phonePValueWhiteBox setFrame:CGRectMake(X + 4.0, Y + 1.5, W - 1.5, H - 3.0)];
            [phonePValueExtraWhiteBox setFrame:CGRectMake(X + 4.0, Y + 1.5, W / 2.0, H - 3.0)];
            
            X = self.ciValue.frame.origin.x;
            Y = phoneCIColorBox.frame.origin.y;
            W = self.ciValue.frame.size.width;
            H = phoneCIColorBox.frame.size.height;
            [phoneCIWhiteBox setFrame:CGRectMake(X + 4.0, Y + 1.5, W - 1.5, H - 3.0)];
            [phoneCIExtraWhiteBox setFrame:CGRectMake(X + 4.0, Y + 1.5, W / 2.0, H - 3.0)];
            [self.computingCI setFrame:CGRectMake(self.ciValue.frame.origin.x, self.ciValue.center.y - self.computingCI.frame.size.height / 2.0, self.computingCI.frame.size.width, self.computingCI.frame.size.height)];
        }
        
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [phoneInputsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 147)];
                    [phoneResultsView setFrame:CGRectMake(18, 147, 277, 300)];
                    [phonePValueView setFrame:CGRectMake(18, 348, 277, 28)];
                    [phoneCIView setFrame:CGRectMake(18, 376, 277, 28)];
                }];
            }
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (self.view.frame.size.width > 2.0 * phoneResultsView.frame.size.width)
                {
                    [phoneInputsView setFrame:CGRectMake(self.view.frame.size.width  / 2.0 - phoneResultsView.frame.size.width, 0, self.view.frame.size.height, 147)];
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width  / 2.0, 0, 277, 300)];
                }
                else
                {
                    [phoneInputsView setFrame:CGRectMake(1.0 - self.phoneNumeratorLabel.frame.origin.x, 0, self.view.frame.size.height, 147)];
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width - 276, 0, 277, 300)];
                }
                [phonePValueView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - phonePValueView.frame.size.width / 2.0, self.view.frame.size.height - 80, 277, 28)];
                [phoneCIView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - phoneCIView.frame.size.width / 2.0, self.view.frame.size.height - 56, 277, 28)];
            }];
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.epiInfoScrollView setContentSize:zoomingView.frame.size];
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/BinomialScreenPad.png" atomically:YES];
//    To here
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Kill any calculating if view is closed
    if ([workerThread isExecuting])
        [workerThread cancel];
    if ([anotherWorkerThread isExecuting])
        [anotherWorkerThread cancel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)compute:(id)sender
{
    // Kill an;y computing tht may already be happening
    if ([workerThread isExecuting] && [sender isKindOfClass:[UITextField class]])
        [workerThread cancel];
    if ([anotherWorkerThread isExecuting] && [sender isKindOfClass:[UITextField class]])
        [anotherWorkerThread cancel];
    
    if ([self.computingCI isAnimating] && [sender isKindOfClass:[UITextField class]])
    {
        [self.computingCI stopAnimating];
        [self.computingCI setHidden:YES];
    }
    
    if ([sender isKindOfClass:[UITextField class]])
    {
        ll = @"";
        ul = @"";
    }

    self.ltLabel.text = [[NSString alloc] initWithFormat:@""];
    self.ltValue.text = [[NSString alloc] initWithFormat:@""];
    self.leLabel.text = [[NSString alloc] initWithFormat:@""];
    self.leValue.text = [[NSString alloc] initWithFormat:@""];
    self.eqLabel.text = [[NSString alloc] initWithFormat:@""];
    self.eqValue.text = [[NSString alloc] initWithFormat:@""];
    self.geLabel.text = [[NSString alloc] initWithFormat:@""];
    self.geValue.text = [[NSString alloc] initWithFormat:@""];
    self.gtLabel.text = [[NSString alloc] initWithFormat:@""];
    self.gtValue.text = [[NSString alloc] initWithFormat:@""];
    self.pValue.text = [[NSString alloc] initWithFormat:@""];
    if ([sender isKindOfClass:[UITextField class]])
        self.ciValue.text = [[NSString alloc] initWithFormat:@""];

    if (self.numeratorField.text.length > 0 && self.denominatorField.text.length > 0 && self.expectedPercentageField.text.length > 0)
    {
        // If all necessary inputs contain data, run the calculations
        int numeratorValue = [self.numeratorField.text intValue];
        int denominatorValue = [self.denominatorField.text intValue];
        if (numeratorValue > denominatorValue)
            return;
        double expectedPercentageValue = [self.expectedPercentageField.text doubleValue];
        
        BinomialCalculatorCompute *computer = [[BinomialCalculatorCompute alloc] init];
        double probs[6];
        [computer Calculate:denominatorValue VariableX:numeratorValue VariableP:expectedPercentageValue / 100.0 ProbabilityArray:probs];

        if ([sender isKindOfClass:[UITextField class]])
        {
            [self.computingCI setHidden:NO];
            [self.computingCI startAnimating];
            
            [sender resignFirstResponder];
            workerThread = [[NSThread alloc] initWithTarget:self selector:@selector(moreComputing) object:nil];
            anotherWorkerThread = [[NSThread alloc] initWithTarget:self selector:@selector(stillMoreComputing) object:nil];
            [workerThread start];
            [anotherWorkerThread start];
            [sender becomeFirstResponder];
        }
        
        self.ltLabel.text = [[NSString alloc] initWithFormat:@"< %d", numeratorValue];
        self.ltLabel.accessibilityLabel = [NSString stringWithFormat:@"less than %d", numeratorValue];
        self.ltValue.text = [[NSString alloc] initWithFormat:@"%g", probs[0]];
        self.leLabel.text = [[NSString alloc] initWithFormat:@"<= %d", numeratorValue];
        self.leLabel.accessibilityLabel = [NSString stringWithFormat:@"less than or equal to %d", numeratorValue];
        self.leValue.text = [[NSString alloc] initWithFormat:@"%g", probs[1]];
        self.eqLabel.text = [[NSString alloc] initWithFormat:@"= %d", numeratorValue];
        self.eqLabel.accessibilityLabel = [NSString stringWithFormat:@"equal to %d", numeratorValue];
        self.eqValue.text = [[NSString alloc] initWithFormat:@"%g", probs[2]];
        self.geLabel.text = [[NSString alloc] initWithFormat:@">= %d", numeratorValue];
        self.geLabel.accessibilityLabel = [NSString stringWithFormat:@"greater than or equal to %d", numeratorValue];
        self.geValue.text = [[NSString alloc] initWithFormat:@"%g", probs[3]];
        self.gtLabel.text = [[NSString alloc] initWithFormat:@"> %d", numeratorValue];
        self.gtLabel.accessibilityLabel = [NSString stringWithFormat:@"greater than %d", numeratorValue];
        self.gtValue.text = [[NSString alloc] initWithFormat:@"%g", probs[4]];
        self.pValue.text = [[NSString alloc] initWithFormat:@"%g", probs[5]];
        if ([sender isKindOfClass:[UITextField class]])
            [self performSelectorOnMainThread:@selector(setCIValueText) withObject:nil waitUntilDone:YES];
   }
    else
    {
        self.ltLabel.text = [[NSString alloc] initWithFormat:@""];
        self.ltValue.text = [[NSString alloc] initWithFormat:@""];
        self.leLabel.text = [[NSString alloc] initWithFormat:@""];
        self.leValue.text = [[NSString alloc] initWithFormat:@""];
        self.eqLabel.text = [[NSString alloc] initWithFormat:@""];
        self.eqValue.text = [[NSString alloc] initWithFormat:@""];
        self.geLabel.text = [[NSString alloc] initWithFormat:@""];
        self.geValue.text = [[NSString alloc] initWithFormat:@""];
        self.gtLabel.text = [[NSString alloc] initWithFormat:@""];
        self.gtValue.text = [[NSString alloc] initWithFormat:@""];
        self.pValue.text = [[NSString alloc] initWithFormat:@""];
        self.ciValue.text = [[NSString alloc] initWithFormat:@""];
    }

}

- (void)moreComputing
{
    int numeratorValue = [self.numeratorField.text intValue];
    int denominatorValue = [self.denominatorField.text intValue];
    if (numeratorValue > denominatorValue)
        return;
    double expectedPercentageValue = [self.expectedPercentageField.text doubleValue];
    
    BinomialCalculatorCompute *computer = [[BinomialCalculatorCompute alloc] init];
    double limit = [computer calculateLowerLimit:denominatorValue VariableX:numeratorValue VariableP:expectedPercentageValue];
    
    ll = [[NSString alloc] initWithFormat:@"%d", (int)round(limit)];
    
    [self performSelectorOnMainThread:@selector(setCIValueText) withObject:nil waitUntilDone:YES];
    
    if (![anotherWorkerThread isExecuting])
    {
        [self performSelectorOnMainThread:@selector(stopTheActivityIndicator) withObject:nil waitUntilDone:YES];
    }
    else
    {
        //This ELSE is in case both threads complete at the same time
        [NSThread sleepForTimeInterval:0.1];
        if (![anotherWorkerThread isExecuting])
        {
            [self performSelectorOnMainThread:@selector(stopTheActivityIndicator) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)stillMoreComputing
{
    int numeratorValue = [self.numeratorField.text intValue];
    int denominatorValue = [self.denominatorField.text intValue];
    if (numeratorValue > denominatorValue)
        return;
    double expectedPercentageValue = [self.expectedPercentageField.text doubleValue];
    
    BinomialCalculatorCompute *computer = [[BinomialCalculatorCompute alloc] init];
    double limit = [computer calculateUpperLimit:denominatorValue VariableX:numeratorValue VariableP:expectedPercentageValue];
    
    ul = [[NSString alloc] initWithFormat:@"%d", (int)round(limit)];
    
    [self performSelectorOnMainThread:@selector(setCIValueText) withObject:nil waitUntilDone:YES];
//    self.ciValue.text = [[NSString alloc] initWithFormat:@"%@ - %@", ll, ul];
    
    if (![workerThread isExecuting])
    {
        [self performSelectorOnMainThread:@selector(stopTheActivityIndicator) withObject:nil waitUntilDone:YES];
    }
}

- (void)setCIValueText
{
    //Avoid exceptions by having the main thread perform all writing to the ciValue field.
    self.ciValue.text = [[NSString alloc] initWithFormat:@"%@ - %@", ll, ul];
    self.ciValue.accessibilityLabel = [[NSString alloc] initWithFormat:@"%@ to %@", ll, ul];
}

- (void)stopTheActivityIndicator
{
    [self.computingCI stopAnimating];
    [self.computingCI setHidden:YES];
}

- (IBAction)reset:(id)sender
{
    if ([self.numeratorField isFirstResponder])
        [self.numeratorField resignFirstResponder];
    else if ([self.denominatorField isFirstResponder])
        [self.denominatorField resignFirstResponder];
    else if ([self.expectedPercentageField isFirstResponder])
        [self.expectedPercentageField resignFirstResponder];
    
    if ([workerThread isExecuting])
        [workerThread cancel];
    if ([anotherWorkerThread isExecuting])
        [anotherWorkerThread cancel];
    
    if ([self.computingCI isAnimating])
    {
        [self.computingCI stopAnimating];
        [self.computingCI setHidden:YES];
    }

    self.numeratorField.text = [[NSString alloc] initWithFormat:@""];
    self.denominatorField.text = [[NSString alloc] initWithFormat:@""];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.expectedPercentageField.text = [[NSString alloc] initWithFormat:@""];
    else
        self.expectedPercentageField.text = [[NSString alloc] initWithFormat:@"0.0"];
    self.ltLabel.text = [[NSString alloc] initWithFormat:@""];
    self.ltValue.text = [[NSString alloc] initWithFormat:@""];
    self.leLabel.text = [[NSString alloc] initWithFormat:@""];
    self.leValue.text = [[NSString alloc] initWithFormat:@""];
    self.eqLabel.text = [[NSString alloc] initWithFormat:@""];
    self.eqValue.text = [[NSString alloc] initWithFormat:@""];
    self.geLabel.text = [[NSString alloc] initWithFormat:@""];
    self.geValue.text = [[NSString alloc] initWithFormat:@""];
    self.gtLabel.text = [[NSString alloc] initWithFormat:@""];
    self.gtValue.text = [[NSString alloc] initWithFormat:@""];
    self.pValue.text = [[NSString alloc] initWithFormat:@""];
    self.ciValue.text = [[NSString alloc] initWithFormat:@""];
    [self.expectedPercentageSlider setValue:0.0];
    [self.expectedPercentageStepper setValue:0.0];
}

- (IBAction)textFieldAction:(id)sender
{
    int cursorPosition = (int)[sender offsetFromPosition:[sender endOfDocument] toPosition:[[sender selectedTextRange] start]];

    UITextField *theTextField = (UITextField *)sender;
    
    if ([theTextField.text length] > 3)
        [theTextField setText:[theTextField.text substringToIndex:3]];
    
    NSString *initialText = theTextField.text;
    
    if (theTextField.text.length + cursorPosition == 0)
    {
        [self resignFirstResponder];
        [self compute:sender];
        [sender becomeFirstResponder];
        return;
    }
    
    if (theTextField.text.length == 0)
    {
        return;
    }
    
    NSCharacterSet *validSet; // = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
/*
    if ([[theTextField.text substringWithRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
    {
            theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1) withString:@""];
    }
    else
    {
        self.ltLabel.text = [[NSString alloc] initWithFormat:@""];
        self.ltValue.text = [[NSString alloc] initWithFormat:@""];
        self.leLabel.text = [[NSString alloc] initWithFormat:@""];
        self.leValue.text = [[NSString alloc] initWithFormat:@""];
        self.eqLabel.text = [[NSString alloc] initWithFormat:@""];
        self.eqValue.text = [[NSString alloc] initWithFormat:@""];
        self.geLabel.text = [[NSString alloc] initWithFormat:@""];
        self.geValue.text = [[NSString alloc] initWithFormat:@""];
        self.gtLabel.text = [[NSString alloc] initWithFormat:@""];
        self.gtValue.text = [[NSString alloc] initWithFormat:@""];
        self.pValue.text = [[NSString alloc] initWithFormat:@""];
        self.ciValue.text = [[NSString alloc] initWithFormat:@""];
    }
*/
    validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < theTextField.text.length; i++)
    {
        if ([[theTextField.text substringWithRange:NSMakeRange(i, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
            theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"#"];
    }
    theTextField.text = [theTextField.text stringByReplacingOccurrencesOfString:@"#" withString:@""];

    if ([theTextField.text isEqualToString:initialText])
    {
        [self resignFirstResponder];
        [self compute:sender];
        [self becomeFirstResponder];
    }

    UITextPosition *newPosition = [sender positionFromPosition:[sender endOfDocument] offset:cursorPosition];
    [sender setSelectedTextRange:[sender textRangeFromPosition:newPosition toPosition:newPosition]];
}

- (IBAction)resetBarButtonPressed:(id)sender
{
    [self reset:sender];
}

//iPad
-(IBAction) sliderChanged:(id) sender{
    if ([self.numeratorField isFirstResponder])
        [self.numeratorField resignFirstResponder];
    else if ([self.denominatorField isFirstResponder])
        [self.denominatorField resignFirstResponder];
    else if ([self.expectedPercentageField isFirstResponder])
        [self.expectedPercentageField resignFirstResponder];

    self.ltLabel.text = [[NSString alloc] initWithFormat:@""];
    self.ltValue.text = [[NSString alloc] initWithFormat:@""];
    self.leLabel.text = [[NSString alloc] initWithFormat:@""];
    self.leValue.text = [[NSString alloc] initWithFormat:@""];
    self.eqLabel.text = [[NSString alloc] initWithFormat:@""];
    self.eqValue.text = [[NSString alloc] initWithFormat:@""];
    self.geLabel.text = [[NSString alloc] initWithFormat:@""];
    self.geValue.text = [[NSString alloc] initWithFormat:@""];
    self.gtLabel.text = [[NSString alloc] initWithFormat:@""];
    self.gtValue.text = [[NSString alloc] initWithFormat:@""];
    self.pValue.text = [[NSString alloc] initWithFormat:@""];
//    self.ciValue.text = [[NSString alloc] initWithFormat:@""];
    
    UISlider *slider = (UISlider *) sender;
    float progressAsFloat = (float)(slider.value );
    NSString *newText =[[NSString alloc]
                        initWithFormat:@"%0.1f",progressAsFloat];
    self.sliderLabel.text = newText;
    [self.expectedPercentageStepper setValue:round(progressAsFloat * 10) / 10];
    [self compute:sender];
    // [newText release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if (theTextField == numeratorField) {
        [numeratorField resignFirstResponder];
        [denominatorField becomeFirstResponder];
        
    }
    else if (theTextField == denominatorField) {
        //[observedEventsField resignFirstResponder];
        [denominatorField resignFirstResponder];
    }
    return YES;
}
//
- (IBAction)stepperChanged:(id)sender
{
    if ([self.numeratorField isFirstResponder])
        [self.numeratorField resignFirstResponder];
    else if ([self.denominatorField isFirstResponder])
        [self.denominatorField resignFirstResponder];
    else if ([self.expectedPercentageField isFirstResponder])
        [self.expectedPercentageField resignFirstResponder];

    self.ltLabel.text = [[NSString alloc] initWithFormat:@""];
    self.ltValue.text = [[NSString alloc] initWithFormat:@""];
    self.leLabel.text = [[NSString alloc] initWithFormat:@""];
    self.leValue.text = [[NSString alloc] initWithFormat:@""];
    self.eqLabel.text = [[NSString alloc] initWithFormat:@""];
    self.eqValue.text = [[NSString alloc] initWithFormat:@""];
    self.geLabel.text = [[NSString alloc] initWithFormat:@""];
    self.geValue.text = [[NSString alloc] initWithFormat:@""];
    self.gtLabel.text = [[NSString alloc] initWithFormat:@""];
    self.gtValue.text = [[NSString alloc] initWithFormat:@""];
    self.pValue.text = [[NSString alloc] initWithFormat:@""];
//    self.ciValue.text = [[NSString alloc] initWithFormat:@""];
    
    UIStepper *stepper = (UIStepper *) sender;
    double currentValue = [stepper value];
    [self.expectedPercentageSlider setValue:currentValue];
    self.sliderLabel.text = [[NSString alloc] initWithFormat:@"%0.1f", currentValue];
    [self compute:sender];
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
                
                [self.subView1 setFrame:CGRectMake(135, -1, 498, 387)];
                [self.subView2 setFrame:CGRectMake(97, 306, 574, 470)];
                
                [self.computingCI setFrame:computingCIFrame];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, self.view.frame.size.height - 400.0, [self.view frame].size.width, 400.0)];
                
                [self.subView1 setFrame:CGRectMake(-20, 20, 498, 387)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 554, 25, 574, 470)];
                
                [self.computingCI setFrame:CGRectMake(-15, self.subView2.frame.size.height / 3.0, computingCIFrame.size.width, computingCIFrame.size.height)];
            }];
        }
    }
    else
    {
        float zs = [self.epiInfoScrollView zoomScale];
        [self.epiInfoScrollView setZoomScale:1.0 animated:YES];
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [phoneInputsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 147)];
                [phoneResultsView setFrame:CGRectMake(18, 147, 277, 300)];
                [phonePValueView setFrame:CGRectMake(18, 348, 277, 28)];
                [phoneCIView setFrame:CGRectMake(18, 376, 277, 28)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (self.view.frame.size.width > 2.0 * phoneResultsView.frame.size.width)
                {
                    [phoneInputsView setFrame:CGRectMake(self.view.frame.size.width  / 2.0 - phoneResultsView.frame.size.width, 0, self.view.frame.size.height, 147)];
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width  / 2.0, 0, 277, 300)];
                }
                else
                {
                    [phoneInputsView setFrame:CGRectMake(1.0 - self.phoneNumeratorLabel.frame.origin.x, 0, self.view.frame.size.height, 147)];
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width - 276, 0, 277, 300)];
                }
               [phonePValueView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - phonePValueView.frame.size.width / 2.0, self.view.frame.size.height - 80, 277, 28)];
                [phoneCIView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - phoneCIView.frame.size.width / 2.0, self.view.frame.size.height - 56, 277, 28)];
            }];
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.epiInfoScrollView setContentSize:zoomingView.frame.size];
        
        if (zs > 1.0)
            [self.epiInfoScrollView setZoomScale:zs animated:YES];
    }
}

- (void)popCurrentViewController
{
    //Method for the custom "Back" button on the NavigationController
    [self.navigationController popViewControllerAnimated:YES];
}
@end
