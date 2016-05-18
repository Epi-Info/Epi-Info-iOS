//
//  ChiSquareCalculatorViewController.m
//  EpiInfo
//
//  Created by John Copeland on 10/12/12.
//

#import "ChiSquareCalculatorViewController.h"
#import "EpiInfoScrollView.h"
#import "ChiSquareCalculatorCompute.h"

@interface ChiSquareCalculatorViewController ()
@property (nonatomic, weak) IBOutlet EpiInfoScrollView *epiInfoScrollView;
@end

@implementation ChiSquareCalculatorViewController

//iPad
@synthesize exposureScoreField0, casesField0, controlsField0, exposureScoreField1, casesField1,controlsField1, exposureScoreField2, casesField2, controlsField2, exposureScoreField3, casesField3, controlsField3, exposureScoreField4, casesField4, controlsField4, exposureScoreField5, casesField5, controlsField5, exposureScoreField6, casesField6, controlsField6, exposureScoreField7, casesField7, controlsField7, exposureScoreField8, casesField8, controlsField8, exposureScoreField9, casesField9, controlsField9;
//

-(void)setEpiInfoScrollView:(EpiInfoScrollView *)epiInfoScrollView
{
    _epiInfoScrollView = epiInfoScrollView;
//    [self.epiInfoScrollView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.epiInfoScrollView action:@selector(pinch:)]];
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
    //iPhone-only tasks
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
        
        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
        if (self.view.frame.size.height > 500)
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5BackgroundWhite.png"]];
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4BackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];

        //Set up the zoomingView
        phoneScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        phoneScrollView.minimumZoomScale = 1.0;
        phoneScrollView.maximumZoomScale = 2.0;
        phoneScrollView.delegate = self;
        
        //Determine the size of the phone.
        fourInchPhone = (self.view.frame.size.height > 500);
        
        //No first responder at load time
        hasAFirstResponder = NO;
        
        // Activate Next and Done buttons on all text fields
        self.exposureScoreField0.delegate = self;
        self.exposureScoreField1.delegate = self;
        self.exposureScoreField2.delegate = self;
        self.exposureScoreField3.delegate = self;
        self.exposureScoreField4.delegate = self;
        self.exposureScoreField5.delegate = self;
        self.exposureScoreField6.delegate = self;
        self.exposureScoreField7.delegate = self;
        self.exposureScoreField8.delegate = self;
        self.exposureScoreField9.delegate = self;
        self.casesField0.delegate = self;
        self.casesField1.delegate = self;
        self.casesField2.delegate = self;
        self.casesField3.delegate = self;
        self.casesField4.delegate = self;
        self.casesField5.delegate = self;
        self.casesField6.delegate = self;
        self.casesField7.delegate = self;
        self.casesField8.delegate = self;
        self.casesField9.delegate = self;
        self.controlsField0.delegate = self;
        self.controlsField1.delegate = self;
        self.controlsField2.delegate = self;
        self.controlsField3.delegate = self;
        self.controlsField4.delegate = self;
        self.controlsField5.delegate = self;
        self.controlsField6.delegate = self;
        self.controlsField7.delegate = self;
        self.controlsField8.delegate = self;
        self.controlsField9.delegate = self;

        //Set the SIZE of the phone's ScrollView for proper positioning of subviews.
        //Content Size determines how much the user can scroll and is set below.
        //Must set this SIZE again in viewDidAppear or area will compress.
        phoneScrollViewSize = CGRectMake(0, 70, self.view.frame.size.width, 840);
        if (fourInchPhone)
            phoneScrollViewSize = CGRectMake(0, 70, self.view.frame.size.width, 920);
        [self.epiInfoScrollView setFrame:phoneScrollViewSize];

        //Position and Size the main title and the Chi-Square and P-Value results
        //Remove them from the ScrollView
        phoneHeaderLabelFrame = CGRectMake(0, 0, self.view.frame.size.width, 21);
        phoneChiSquareLabelFrame = CGRectMake(10, 26, self.view.frame.size.width / 2.0 - 20, 21);
        phoneChiSquareResultFrame = CGRectMake(10, 48, self.view.frame.size.width / 2.0 - 20, 21);
        phonePValueLabelFrame = CGRectMake(self.view.frame.size.width / 2.0 + 10, 26, self.view.frame.size.width / 2.0 - 20, 21);
        phonePValueResultFrame = CGRectMake(self.view.frame.size.width / 2.0 + 10, 48, self.view.frame.size.width / 2.0 - 20, 21);
        [self.phoneHeaderLabel setFrame:phoneHeaderLabelFrame];
        [self.phoneChiSquareLabel setFrame:phoneChiSquareLabelFrame];
        [self.phoneChiSquareLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneChiSquareLabel.layer setCornerRadius:10.0];
        [self.phoneChiSquareLabel setAccessibilityLabel:@"Ky square"];
        [self.chiSquareResult setFrame:phoneChiSquareResultFrame];
        [self.phonePValueLabel setFrame:phonePValueLabelFrame];
        [self.phonePValueLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phonePValueLabel.layer setCornerRadius:10.0];
        [self.pValueResult setFrame:phonePValueResultFrame];
        [self.phoneHeaderLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.chiSquareResult setTextColor:[UIColor blackColor]];
        [self.pValueResult setTextColor:[UIColor blackColor]];
        [self.view addSubview:self.phoneHeaderLabel];
        [self.view addSubview:self.phoneChiSquareLabel];
        [self.view addSubview:self.chiSquareResult];
        [self.view addSubview:self.phonePValueLabel];
        [self.view addSubview:self.pValueResult];
        
        // Set the background color for the column header labels
        [self.phoneExposureScoreLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneExposureScoreLabel.layer setCornerRadius:10.0];
        [self.phoneCasesLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneControlsLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneOddsRatioLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneOddsRatioLabel.layer setCornerRadius:10.0];
        
        // Postion the inputs, odds ratios, and column headers
        float tableWidth = self.view.frame.size.width - 40.0;
        float columnWidth = tableWidth / 4.0;
        float rowPadding = 4.0;
        float rowHeight = 30;
        phoneExposureScoreLabelFrame = CGRectMake(20, 0, columnWidth, 42);
        phoneCasesLabelFrame = CGRectMake(20 + columnWidth, 0, columnWidth, 42);
        phoneControlsLabelFrame = CGRectMake(20 + 2 * columnWidth, 0, columnWidth, 42);
        phoneOddsRatioLabelFrame = CGRectMake(20 + 3 * columnWidth, 0, columnWidth, 42);
        [self.phoneExposureScoreLabel setFrame:phoneExposureScoreLabelFrame];
        [self.phoneCasesLabel setFrame:phoneCasesLabelFrame];
        [self.phoneControlsLabel setFrame:phoneControlsLabelFrame];
        [self.phoneOddsRatioLabel setFrame:phoneOddsRatioLabelFrame];
        phoneExposureScoreField0Frame = CGRectMake(21, 42 + rowPadding, columnWidth, rowHeight);
        phoneExposureScoreField1Frame = CGRectMake(21, 42 + rowPadding + 1 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneExposureScoreField2Frame = CGRectMake(21, 42 + rowPadding + 2 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneExposureScoreField3Frame = CGRectMake(21, 42 + rowPadding + 3 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneExposureScoreField4Frame = CGRectMake(21, 42 + rowPadding + 4 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneExposureScoreField5Frame = CGRectMake(21, 42 + rowPadding + 5 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneExposureScoreField6Frame = CGRectMake(21, 42 + rowPadding + 6 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneExposureScoreField7Frame = CGRectMake(21, 42 + rowPadding + 7 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneExposureScoreField8Frame = CGRectMake(21, 42 + rowPadding + 8 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneExposureScoreField9Frame = CGRectMake(21, 42 + rowPadding + 9 * (rowHeight + rowPadding), columnWidth, rowHeight);
        [self.exposureScoreField0 setFrame:phoneExposureScoreField0Frame];
        [self.exposureScoreField1 setFrame:phoneExposureScoreField1Frame];
        [self.exposureScoreField2 setFrame:phoneExposureScoreField2Frame];
        [self.exposureScoreField3 setFrame:phoneExposureScoreField3Frame];
        [self.exposureScoreField4 setFrame:phoneExposureScoreField4Frame];
        [self.exposureScoreField5 setFrame:phoneExposureScoreField5Frame];
        [self.exposureScoreField6 setFrame:phoneExposureScoreField6Frame];
        [self.exposureScoreField7 setFrame:phoneExposureScoreField7Frame];
        [self.exposureScoreField8 setFrame:phoneExposureScoreField8Frame];
        [self.exposureScoreField9 setFrame:phoneExposureScoreField9Frame];
        phoneCasesField0Frame = CGRectMake(21 + columnWidth, 42 + rowPadding, columnWidth, rowHeight);
        phoneCasesField1Frame = CGRectMake(21 + columnWidth, 42 + rowPadding + 1 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneCasesField2Frame = CGRectMake(21 + columnWidth, 42 + rowPadding + 2 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneCasesField3Frame = CGRectMake(21 + columnWidth, 42 + rowPadding + 3 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneCasesField4Frame = CGRectMake(21 + columnWidth, 42 + rowPadding + 4 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneCasesField5Frame = CGRectMake(21 + columnWidth, 42 + rowPadding + 5 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneCasesField6Frame = CGRectMake(21 + columnWidth, 42 + rowPadding + 6 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneCasesField7Frame = CGRectMake(21 + columnWidth, 42 + rowPadding + 7 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneCasesField8Frame = CGRectMake(21 + columnWidth, 42 + rowPadding + 8 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneCasesField9Frame = CGRectMake(21 + columnWidth, 42 + rowPadding + 9 * (rowHeight + rowPadding), columnWidth, rowHeight);
        [self.casesField0 setFrame:phoneCasesField0Frame];
        [self.casesField1 setFrame:phoneCasesField1Frame];
        [self.casesField2 setFrame:phoneCasesField2Frame];
        [self.casesField3 setFrame:phoneCasesField3Frame];
        [self.casesField4 setFrame:phoneCasesField4Frame];
        [self.casesField5 setFrame:phoneCasesField5Frame];
        [self.casesField6 setFrame:phoneCasesField6Frame];
        [self.casesField7 setFrame:phoneCasesField7Frame];
        [self.casesField8 setFrame:phoneCasesField8Frame];
        [self.casesField9 setFrame:phoneCasesField9Frame];
        phoneControlsField0Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding, columnWidth, rowHeight);
        phoneControlsField1Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding + 1 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneControlsField2Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding + 2 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneControlsField3Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding + 3 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneControlsField4Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding + 4 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneControlsField5Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding + 5 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneControlsField6Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding + 6 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneControlsField7Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding + 7 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneControlsField8Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding + 8 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneControlsField9Frame = CGRectMake(21 + 2 * columnWidth, 42 + rowPadding + 9 * (rowHeight + rowPadding), columnWidth, rowHeight);
        [self.controlsField0 setFrame:phoneControlsField0Frame];
        [self.controlsField1 setFrame:phoneControlsField1Frame];
        [self.controlsField2 setFrame:phoneControlsField2Frame];
        [self.controlsField3 setFrame:phoneControlsField3Frame];
        [self.controlsField4 setFrame:phoneControlsField4Frame];
        [self.controlsField5 setFrame:phoneControlsField5Frame];
        [self.controlsField6 setFrame:phoneControlsField6Frame];
        [self.controlsField7 setFrame:phoneControlsField7Frame];
        [self.controlsField8 setFrame:phoneControlsField8Frame];
        [self.controlsField9 setFrame:phoneControlsField9Frame];
        phoneOddsRatioResults0Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding, columnWidth, rowHeight);
        phoneOddsRatioResults1Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding + 1 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneOddsRatioResults2Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding + 2 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneOddsRatioResults3Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding + 3 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneOddsRatioResults4Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding + 4 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneOddsRatioResults5Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding + 5 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneOddsRatioResults6Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding + 6 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneOddsRatioResults7Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding + 7 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneOddsRatioResults8Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding + 8 * (rowHeight + rowPadding), columnWidth, rowHeight);
        phoneOddsRatioResults9Frame = CGRectMake(21 + 3 * columnWidth, 42 + rowPadding + 9 * (rowHeight + rowPadding), columnWidth, rowHeight);
        [self.oddsRatioResult0 setFrame:phoneOddsRatioResults0Frame];
        [self.oddsRatioResult1 setFrame:phoneOddsRatioResults1Frame];
        [self.oddsRatioResult2 setFrame:phoneOddsRatioResults2Frame];
        [self.oddsRatioResult3 setFrame:phoneOddsRatioResults3Frame];
        [self.oddsRatioResult4 setFrame:phoneOddsRatioResults4Frame];
        [self.oddsRatioResult5 setFrame:phoneOddsRatioResults5Frame];
        [self.oddsRatioResult6 setFrame:phoneOddsRatioResults6Frame];
        [self.oddsRatioResult7 setFrame:phoneOddsRatioResults7Frame];
        [self.oddsRatioResult8 setFrame:phoneOddsRatioResults8Frame];
        [self.oddsRatioResult9 setFrame:phoneOddsRatioResults9Frame];
        
        //Add the blue (?) box to the inputs and odds ratios section
        phoneLargeColorBoxFrame = CGRectMake(20, 0, 4 * columnWidth, 42 + 10 * rowPadding + 10 * rowHeight + 1);
        phoneLargeColorBox = [[UIView alloc] initWithFrame:phoneLargeColorBoxFrame];
        [phoneLargeColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneLargeColorBox.layer setCornerRadius:6.0];
        [self.epiInfoScrollView addSubview:phoneLargeColorBox];
        [self.epiInfoScrollView sendSubviewToBack:phoneLargeColorBox];
        
        //Set the content sizes for keyboard and no keyboard
        responderSize = CGRectMake(0, 70, self.view.frame.size.width, 1100).size;
        noResponderSize = CGRectMake(0, 70, self.view.frame.size.width, 900).size;
        landscapeNoResponderSize = CGRectMake(0, 70, self.view.frame.size.width, 1050).size;
        landscapeResponderSize = CGRectMake(0, 70, self.view.frame.size.width, 1190).size;
        if (fourInchPhone)
        {
            landscapeNoResponderSize = CGRectMake(0, 70, self.view.frame.size.width, 1140).size;
            landscapeResponderSize = CGRectMake(0, 70, self.view.frame.size.width, 1270).size;
        }
        
        //Add method for hiding the keyboard to all non-textfield views
        selfViewControl = [[UIControl alloc] initWithFrame:self.view.frame];
        [selfViewControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:selfViewControl];
        [self.view sendSubviewToBack:selfViewControl];
        UIControl *scrollViewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.epiInfoScrollView.frame.size.width, self.epiInfoScrollView.frame.size.height)];
        [scrollViewControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchDown];
        [self.epiInfoScrollView addSubview:scrollViewControl];
        [self.epiInfoScrollView sendSubviewToBack:scrollViewControl];
        UIControl *headerControl = [[UIControl alloc] initWithFrame:phoneHeaderLabelFrame];
        [headerControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:headerControl];
        UIControl *chiSquareLabelControl = [[UIControl alloc] initWithFrame:phoneChiSquareLabelFrame];
        [chiSquareLabelControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:chiSquareLabelControl];
        UIControl *chiSquareValueControl = [[UIControl alloc] initWithFrame:phoneChiSquareResultFrame];
        [chiSquareValueControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:chiSquareValueControl];
        UIControl *pValueLabelControl = [[UIControl alloc] initWithFrame:phonePValueLabelFrame];
        [pValueLabelControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:pValueLabelControl];
        UIControl *pValueResultControl = [[UIControl alloc] initWithFrame:phonePValueResultFrame];
        [pValueResultControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:pValueResultControl];
        UIControl *exposureScoreLabelControl = [[UIControl alloc] initWithFrame:phoneExposureScoreLabelFrame];
        [exposureScoreLabelControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:exposureScoreLabelControl];
        UIControl *casesLabelControl = [[UIControl alloc] initWithFrame:phoneCasesLabelFrame];
        [casesLabelControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:casesLabelControl];
        UIControl *controlsLabelControl = [[UIControl alloc] initWithFrame:phoneControlsLabelFrame];
        [controlsLabelControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:controlsLabelControl];
        UIControl *oddsRatioLabelControl = [[UIControl alloc] initWithFrame:phoneOddsRatioLabelFrame];
        [oddsRatioLabelControl addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioLabelControl];
        UIControl *oddsRatioResults0Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults0Frame];
        [oddsRatioResults0Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults0Control];
        UIControl *oddsRatioResults1Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults1Frame];
        [oddsRatioResults1Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults1Control];
        UIControl *oddsRatioResults2Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults2Frame];
        [oddsRatioResults2Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults2Control];
        UIControl *oddsRatioResults3Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults3Frame];
        [oddsRatioResults3Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults3Control];
        UIControl *oddsRatioResults4Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults4Frame];
        [oddsRatioResults4Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults4Control];
        UIControl *oddsRatioResults5Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults5Frame];
        [oddsRatioResults5Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults5Control];
        UIControl *oddsRatioResults6Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults6Frame];
        [oddsRatioResults6Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults6Control];
        UIControl *oddsRatioResults7Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults7Frame];
        [oddsRatioResults7Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults7Control];
        UIControl *oddsRatioResults8Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults8Frame];
        [oddsRatioResults8Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults8Control];
        UIControl *oddsRatioResults9Control = [[UIControl alloc] initWithFrame:phoneOddsRatioResults9Frame];
        [oddsRatioResults9Control addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
        [self.epiInfoScrollView addSubview:oddsRatioResults9Control];

        //Add everything to the zoomingView
        for (UIView *view in self.view.subviews)
        {
            [zoomingView addSubview:view];
            //Remove all struts and springs
            [view setAutoresizingMask:UIViewAutoresizingNone];
        }
        [phoneScrollView addSubview:zoomingView];
        [self.view addSubview:phoneScrollView];
        
        //Add double-tap zooming
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
        [tgr setNumberOfTapsRequired:2];
        [tgr setNumberOfTouchesRequired:1];
        [phoneScrollView addGestureRecognizer:tgr];
        
        [fadingColorView removeFromSuperview];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
    }
    
    scrollViewFrame = CGRectMake(0, 40, 768,960);
    [self.epiInfoScrollView0 setScrollEnabled:NO];

    //Adjust the position of the iPhone's ScrollView
    //Must use setContentSize to do this
    [[self epiInfoScrollView] setContentSize:noResponderSize];
//    [self.epiInfoScrollView setFrame:CGRectMake(0, 70, self.view.frame.size.width, 890)];
    
    [[self exposureScoreField0] setTag:1];
    [[self exposureScoreField1] setTag:1];
    [[self exposureScoreField2] setTag:1];
    [[self exposureScoreField3] setTag:1];
    [[self exposureScoreField4] setTag:1];
    [[self exposureScoreField5] setTag:1];
    [[self exposureScoreField6] setTag:1];
    [[self exposureScoreField7] setTag:1];
    [[self exposureScoreField8] setTag:1];
    [[self exposureScoreField9] setTag:1];
    
    //ipad
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"textured-Bar.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:124/255.0 green:177/255.0 blue:55/255.0 alpha:1.0]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    self.title = @"";
    //
    
   // self.title = @"Chi-Square";
//    CGRect frame = CGRectMake(0, 0, [self.title sizeWithFont:[UIFont boldSystemFontOfSize:20.0]].width, 44);
    // Deprecation replacement
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    self.navigationItem.titleView = label;
    label.text = self.title;
    
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
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        fadingColorView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
        [fadingColorView0 setImage:[UIImage imageNamed:@"FadeUpAndDown.png"]];
//        [self.view addSubview:fadingColorView0];
//        [self.view sendSubviewToBack:fadingColorView0];
        fadingColorView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [fadingColorView setImage:[UIImage imageNamed:@"iPadBackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
            [self.lowerNavigationBar setBarTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
        }
        int i = 0;
        for (UIView *v in [self.epiInfoScrollView subviews])
        {
            int j = 0;
            for (UIView *vi in [v subviews])
            {
                j++;
                if ([vi isKindOfClass:[UILabel class]])
                {
                    if ([[(UILabel *)vi text] isEqualToString:@"Chi Square"])
                        [vi setAccessibilityLabel:@"Ky square"];
                }
            }
            i++;
        }
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
                
                [self.subView1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 322.0, 0, 644, 689)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 253.0, 558, 506, 137)];
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
        [self.epiInfoScrollView setFrame:CGRectMake(0, 70, self.view.frame.size.width, 840)];
        if (fourInchPhone)
            [self.epiInfoScrollView setFrame:CGRectMake(0, 70, self.view.frame.size.width, 920)];
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [selfViewControl setFrame:self.view.frame];
                [self.phoneChiSquareLabel setFrame:phoneChiSquareLabelFrame];
                [self.chiSquareResult setFrame:phoneChiSquareResultFrame];
                [self.phonePValueLabel setFrame:phonePValueLabelFrame];
                [self.pValueResult setFrame:phonePValueResultFrame];
                [self.phoneHeaderLabel setFrame:phoneHeaderLabelFrame];
                [self.epiInfoScrollView setFrame:CGRectMake(0, 70, phoneScrollViewSize.size.width, phoneScrollViewSize.size.height)];
                
                //Conditionally set the scroll size by whether or not there is a keyboard
                if (hasAFirstResponder)
                    [self.epiInfoScrollView setContentSize:responderSize];
                else
                    [self.epiInfoScrollView setContentSize:noResponderSize];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [selfViewControl setFrame:self.view.frame];
                [self.phoneChiSquareLabel setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 10 - phoneChiSquareLabelFrame.size.width, phoneChiSquareLabelFrame.origin.y, phoneChiSquareLabelFrame.size.width, phoneChiSquareLabelFrame.size.height)];
                [self.chiSquareResult setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 10 - phoneChiSquareResultFrame.size.width, phoneChiSquareResultFrame.origin.y, phoneChiSquareResultFrame.size.width, phoneChiSquareResultFrame.size.height)];
                [self.phonePValueLabel setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 10, phonePValueLabelFrame.origin.y, phonePValueLabelFrame.size.width, phonePValueLabelFrame.size.height)];
                [self.pValueResult setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 10, phonePValueResultFrame.origin.y, phonePValueResultFrame.size.width, phonePValueResultFrame.size.height)];
                [self.phoneHeaderLabel setFrame:CGRectMake(self.view.frame.size.width / 2.0 - phoneHeaderLabelFrame.size.width / 2.0, phoneHeaderLabelFrame.origin.y, phoneHeaderLabelFrame.size.width, phoneHeaderLabelFrame.size.height)];
                [self.epiInfoScrollView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - phoneScrollViewSize.size.width / 2.0, 70, phoneScrollViewSize.size.width, phoneScrollViewSize.size.height)];
                
                //Conditionally set the scroll size by whether or not there is a keyboard
                if (hasAFirstResponder)
                    [self.epiInfoScrollView setContentSize:landscapeResponderSize];
                else
                    [self.epiInfoScrollView setContentSize:landscapeNoResponderSize];
            }];
        }
        [zoomingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [phoneScrollView setFrame:zoomingView.frame];
        [phoneScrollView setContentSize:zoomingView.frame.size];
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/ChiSquareScreenPad.png" atomically:YES];
//    To here
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)textFieldBecameFirstResponder:(id)sender
{
    if (hasAFirstResponder)
        return;
    
    float zs = [phoneScrollView zoomScale];
    [phoneScrollView setZoomScale:1.0 animated:YES];
    hasAFirstResponder = YES;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        [self.epiInfoScrollView setContentSize:responderSize];
    else
        [self.epiInfoScrollView setContentSize:landscapeResponderSize];
    if (zs > 1.0)
        [phoneScrollView setZoomScale:zs animated:YES];
}

//Method to hide the keyboard on iPhone
- (void)resignAllFirstResponders
{
    float zs = [phoneScrollView zoomScale];
    [phoneScrollView setZoomScale:1.0 animated:YES];
    hasAFirstResponder = NO;
    [self.view endEditing:YES];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        [self.epiInfoScrollView setContentSize:noResponderSize];
    else
        [self.epiInfoScrollView setContentSize:landscapeNoResponderSize];
    if (zs > 1.0)
        [phoneScrollView setZoomScale:zs animated:YES];
}

- (IBAction)resetBarButtonPressed:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (hasAFirstResponder)
        {
            float zs = [phoneScrollView zoomScale];
            [phoneScrollView setZoomScale:1.0 animated:YES];
            hasAFirstResponder = NO;
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
                [self.epiInfoScrollView setContentSize:noResponderSize];
            else
                [self.epiInfoScrollView setContentSize:landscapeNoResponderSize];
            if (zs > 1.0)
                [phoneScrollView setZoomScale:zs animated:YES];
        }
    }
    [self reset:sender];
}

- (IBAction)textFieldAction:(id)sender
{
    int cursorPosition = (int)[sender offsetFromPosition:[sender endOfDocument] toPosition:[[sender selectedTextRange] start]];
    
    UITextField *theTextField = (UITextField *)sender;
    
    if (theTextField.text.length + cursorPosition == 0)
    {
        [self compute:sender];
        return;
    }
    
    if ([theTextField.text length] >1 && [theTextField.text characterAtIndex:1] == '-' && theTextField.text.length + cursorPosition == 1)
    {
        theTextField.text = [theTextField.text substringFromIndex:1];
        return;
    }
    
    if (theTextField.text.length == 0)
    {
        [self compute:sender];
        return;
    }
    
    int tag = (int)[theTextField tag];
    NSCharacterSet *validSet;
/*
    validSet = [NSCharacterSet characterSetWithCharactersInString:@"-.0123456789"];
    if (theTextField.text.length + cursorPosition > 1 || (theTextField.text.length > 1 && theTextField.text.length + cursorPosition > 1 && [theTextField.text characterAtIndex:0] == '-'))
        validSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    if (!tag || [theTextField.text stringByReplacingOccurrencesOfString:@"." withString:@""].length < theTextField.text.length - 1)
        validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    if (tag && theTextField.text.length > 1 && theTextField.text.length + cursorPosition == 1 && [theTextField.text characterAtIndex:1] != '-' && [validSet isEqual:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]])
        validSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
    
    if ([[theTextField.text substringWithRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
    {
        theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1) withString:@""];
    }
    else
        [self compute:sender];
*/    
    if (tag)
    {
        validSet = [NSCharacterSet characterSetWithCharactersInString:@"-.0123456789"];
        if ([[theTextField.text substringToIndex:1] stringByTrimmingCharactersInSet:validSet].length > 0)
            theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"#"];
        if ([[theTextField.text substringToIndex:1] isEqualToString:@"."])
             validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        else
            validSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
        for (int i = 1; i < theTextField.text.length; i++)
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

- (IBAction)compute:(id)sender
{
    self.oddsRatioResult0.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult1.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult2.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult3.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult4.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult5.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult6.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult7.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult8.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult9.text = [[NSString alloc] initWithFormat:@""];
    self.chiSquareResult.text = [[NSString alloc] initWithFormat:@""];
    self.pValueResult.text = [[NSString alloc] initWithFormat:@""];

    if ([[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField0.text] &&
        [[[NSNumberFormatter alloc] init] numberFromString:self.casesField0.text] &&
        [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField0.text] &&
        [[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField1.text] &&
        [[[NSNumberFormatter alloc] init] numberFromString:self.casesField1.text] &&
        [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField1.text] > 0)
    {
        int levels = 2;
        levels += [[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField2.text] &&
        [[[NSNumberFormatter alloc] init] numberFromString:self.casesField2.text] &&
        [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField2.text];
        if (levels == 3)
            levels += [[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField3.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.casesField3.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField3.text];
        if (levels == 4)
            levels += [[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField4.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.casesField4.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField4.text];
        if (levels == 5)
            levels += [[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField5.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.casesField5.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField5.text];
        if (levels == 6)
            levels += [[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField6.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.casesField6.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField6.text];
        if (levels == 7)
            levels += [[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField7.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.casesField7.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField7.text];
        if (levels == 8)
            levels += [[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField8.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.casesField8.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField8.text];
        if (levels == 9)
            levels += [[[NSNumberFormatter alloc] init] numberFromString:self.exposureScoreField9.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.casesField9.text] &&
            [[[NSNumberFormatter alloc] init] numberFromString:self.controlsField9.text];
        
        double scores[levels];
        int casess[levels];
        int contrs[levels];
        
        scores[0] = [self.exposureScoreField0.text doubleValue];
        casess[0] = [self.casesField0.text intValue];
        contrs[0] = [self.controlsField0.text intValue];
        scores[1] = [self.exposureScoreField1.text doubleValue];
        casess[1] = [self.casesField1.text intValue];
        contrs[1] = [self.controlsField1.text intValue];
        
        if (levels > 2)
        {
            int i = 2;
            scores[i] = [self.exposureScoreField2.text doubleValue];
            casess[i] = [self.casesField2.text intValue];
            contrs[i] = [self.controlsField2.text intValue];
        }
        if (levels > 3)
        {
            int i = 3;
            scores[i] = [self.exposureScoreField3.text doubleValue];
            casess[i] = [self.casesField3.text intValue];
            contrs[i] = [self.controlsField3.text intValue];
        }
        if (levels > 4)
        {
            int i = 4;
            scores[i] = [self.exposureScoreField4.text doubleValue];
            casess[i] = [self.casesField4.text intValue];
            contrs[i] = [self.controlsField4.text intValue];
        }
        if (levels > 5)
        {
            int i = 5;
            scores[i] = [self.exposureScoreField5.text doubleValue];
            casess[i] = [self.casesField5.text intValue];
            contrs[i] = [self.controlsField5.text intValue];
        }
        if (levels > 6)
        {
            int i = 6;
            scores[i] = [self.exposureScoreField6.text doubleValue];
            casess[i] = [self.casesField6.text intValue];
            contrs[i] = [self.controlsField6.text intValue];
        }
        if (levels > 7)
        {
            int i = 7;
            scores[i] = [self.exposureScoreField7.text doubleValue];
            casess[i] = [self.casesField7.text intValue];
            contrs[i] = [self.controlsField7.text intValue];
        }
        if (levels > 8)
        {
            int i = 8;
            scores[i] = [self.exposureScoreField8.text doubleValue];
            casess[i] = [self.casesField8.text intValue];
            contrs[i] = [self.controlsField8.text intValue];
        }
        if (levels > 9)
        {
            int i = 9;
            scores[i] = [self.exposureScoreField9.text doubleValue];
            casess[i] = [self.casesField9.text intValue];
            contrs[i] = [self.controlsField9.text intValue];
        }
        
        double ors[levels];
        double chiSquareAndP[2];
        
        ChiSquareCalculatorCompute *computer = [[ChiSquareCalculatorCompute alloc] init];
        [computer Calculate:levels ExposureScoreVector:scores CasesVector:casess ControlsVector:contrs OddsRatioVector:ors ChiSquareAndPValueVector:chiSquareAndP];
        
        self.oddsRatioResult0.text = [[NSString alloc] initWithFormat:@"1.000"];
        self.oddsRatioResult1.text = [[NSString alloc] initWithFormat:@"%g", ors[1]];
        if (levels > 2)
            self.oddsRatioResult2.text = [[NSString alloc] initWithFormat:@"%g", ors[2]];
        if (levels > 3)
            self.oddsRatioResult3.text = [[NSString alloc] initWithFormat:@"%g", ors[3]];
        if (levels > 4)
            self.oddsRatioResult4.text = [[NSString alloc] initWithFormat:@"%g", ors[4]];
        if (levels > 5)
            self.oddsRatioResult5.text = [[NSString alloc] initWithFormat:@"%g", ors[5]];
        if (levels > 6)
            self.oddsRatioResult6.text = [[NSString alloc] initWithFormat:@"%g", ors[6]];
        if (levels > 7)
            self.oddsRatioResult7.text = [[NSString alloc] initWithFormat:@"%g", ors[7]];
        if (levels > 8)
            self.oddsRatioResult8.text = [[NSString alloc] initWithFormat:@"%g", ors[8]];
        if (levels > 9)
            self.oddsRatioResult9.text = [[NSString alloc] initWithFormat:@"%g", ors[9]];
        self.chiSquareResult.text = [[NSString alloc] initWithFormat:@"%g", chiSquareAndP[0]];
        self.pValueResult.text = [[NSString alloc] initWithFormat:@"%g", chiSquareAndP[1]];
    }
}

- (IBAction)reset:(id)sender
{
    [self.view endEditing:YES];
    
    self.exposureScoreField0.text = [[NSString alloc] initWithFormat:@""];
    self.casesField0.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField0.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult0.text = [[NSString alloc] initWithFormat:@""];
    self.exposureScoreField1.text = [[NSString alloc] initWithFormat:@""];
    self.casesField1.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField1.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult1.text = [[NSString alloc] initWithFormat:@""];
    self.exposureScoreField2.text = [[NSString alloc] initWithFormat:@""];
    self.casesField2.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField2.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult2.text = [[NSString alloc] initWithFormat:@""];
    self.exposureScoreField3.text = [[NSString alloc] initWithFormat:@""];
    self.casesField3.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField3.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult3.text = [[NSString alloc] initWithFormat:@""];
    self.exposureScoreField4.text = [[NSString alloc] initWithFormat:@""];
    self.casesField4.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField4.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult4.text = [[NSString alloc] initWithFormat:@""];
    self.exposureScoreField5.text = [[NSString alloc] initWithFormat:@""];
    self.casesField5.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField5.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult5.text = [[NSString alloc] initWithFormat:@""];
    self.exposureScoreField6.text = [[NSString alloc] initWithFormat:@""];
    self.casesField6.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField6.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult6.text = [[NSString alloc] initWithFormat:@""];
    self.exposureScoreField7.text = [[NSString alloc] initWithFormat:@""];
    self.casesField7.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField7.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult7.text = [[NSString alloc] initWithFormat:@""];
    self.exposureScoreField8.text = [[NSString alloc] initWithFormat:@""];
    self.casesField8.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField8.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult8.text = [[NSString alloc] initWithFormat:@""];
    self.exposureScoreField9.text = [[NSString alloc] initWithFormat:@""];
    self.casesField9.text = [[NSString alloc] initWithFormat:@""];
    self.controlsField9.text = [[NSString alloc] initWithFormat:@""];
    self.oddsRatioResult9.text = [[NSString alloc] initWithFormat:@""];
    self.chiSquareResult.text = [[NSString alloc] initWithFormat:@""];
    self.pValueResult.text = [[NSString alloc] initWithFormat:@""];
}

//iPad
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == exposureScoreField0) {
        [exposureScoreField0 resignFirstResponder];
        [casesField0 becomeFirstResponder];
    }
    else if (theTextField == casesField0) {
        [casesField0 resignFirstResponder];
        [controlsField0 becomeFirstResponder];
    }
    else if (theTextField == controlsField0) {
        [controlsField0 resignFirstResponder];
        [exposureScoreField1 becomeFirstResponder];
    }
    else if (theTextField == exposureScoreField1) {
        [exposureScoreField1 resignFirstResponder];
        [casesField1 becomeFirstResponder];
    }
    else if (theTextField == casesField1) {
        [casesField1 resignFirstResponder];
        [controlsField1 becomeFirstResponder];
    }
    else if (theTextField == controlsField1) {
        [controlsField1 resignFirstResponder];
        [exposureScoreField2 becomeFirstResponder];
    }
    else if (theTextField == exposureScoreField2) {
        [exposureScoreField2 resignFirstResponder];
        [casesField2 becomeFirstResponder];
    }
    else if (theTextField == casesField2) {
        [casesField2 resignFirstResponder];
        [controlsField2 becomeFirstResponder];
    }
    else if (theTextField == controlsField2) {
        [controlsField2 resignFirstResponder];
        [exposureScoreField3 becomeFirstResponder];
    }
    else if (theTextField == exposureScoreField3) {
        [exposureScoreField3 resignFirstResponder];
        [casesField3 becomeFirstResponder];
    }
    else if (theTextField == casesField3) {
        [casesField3 resignFirstResponder];
        [controlsField3 becomeFirstResponder];
    }
    else if (theTextField == controlsField3) {
        [controlsField3 resignFirstResponder];
        [exposureScoreField4 becomeFirstResponder];
    }
    else if (theTextField == exposureScoreField4) {
        [exposureScoreField4 resignFirstResponder];
        [casesField4 becomeFirstResponder];
    }
    else if (theTextField == casesField4) {
        [casesField4 resignFirstResponder];
        [controlsField4 becomeFirstResponder];
    }
    else if (theTextField == controlsField4) {
        [controlsField4 resignFirstResponder];
        [exposureScoreField5 becomeFirstResponder];
    }
    else if (theTextField == exposureScoreField5) {
        [exposureScoreField5 resignFirstResponder];
        [casesField5 becomeFirstResponder];
    }
    else if (theTextField == casesField5) {
        [casesField5 resignFirstResponder];
        [controlsField5 becomeFirstResponder];
    }
    else if (theTextField == controlsField5) {
        [controlsField5 resignFirstResponder];
        [exposureScoreField6 becomeFirstResponder];
    }
    else if (theTextField == exposureScoreField6) {
        [exposureScoreField6 resignFirstResponder];
        [casesField6 becomeFirstResponder];
    }
    else if (theTextField == casesField6) {
        [casesField6 resignFirstResponder];
        [controlsField6 becomeFirstResponder];
    }
    else if (theTextField == controlsField6) {
        [controlsField6 resignFirstResponder];
        [exposureScoreField7 becomeFirstResponder];
    }
    else if (theTextField == exposureScoreField7) {
        [exposureScoreField7 resignFirstResponder];
        [casesField7 becomeFirstResponder];
    }
    else if (theTextField == casesField7) {
        [casesField7 resignFirstResponder];
        [controlsField7 becomeFirstResponder];
    }
    else if (theTextField == controlsField7) {
        [controlsField7 resignFirstResponder];
        [exposureScoreField8 becomeFirstResponder];
    }
    else if (theTextField == exposureScoreField8) {
        [exposureScoreField8 resignFirstResponder];
        [casesField8 becomeFirstResponder];
    }
    else if (theTextField == casesField8) {
        [casesField8 resignFirstResponder];
        [controlsField8 becomeFirstResponder];
    }
    else if (theTextField == controlsField8) {
        [controlsField8 resignFirstResponder];
        [exposureScoreField9 becomeFirstResponder];
    }
    else if (theTextField == exposureScoreField9) {
        [exposureScoreField9 resignFirstResponder];
        [casesField9 becomeFirstResponder];
    }
    else if (theTextField == casesField9) {
        [casesField9 resignFirstResponder];
        [controlsField9 becomeFirstResponder];
    }
    else if (theTextField == controlsField9) {
        [controlsField9 resignFirstResponder];
        //[exposureScoreField9 becomeFirstResponder];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            hasAFirstResponder = NO;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && !hasAFirstResponder)
    {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
            [self.epiInfoScrollView setContentSize:noResponderSize];
        else
            [self.epiInfoScrollView setContentSize:landscapeNoResponderSize];
    }
    
    return YES;
}

//Determine the current orientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currentOrientationPortrait = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation));
}

//Animatedly move the subviews to the new orientation's layout
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
                
                [self.subView1 setFrame:CGRectMake(62, 4, 644, 689)];
                [self.subView2 setFrame:CGRectMake(131, 592, 506, 137)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, self.view.frame.size.height - 400.0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 322.0, 0, 644, 689)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 253.0, 558, 506, 137)];
            }];
        }
    }
    else
    {
        float zs = [phoneScrollView zoomScale];
        [phoneScrollView setZoomScale:1.0 animated:YES];
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [selfViewControl setFrame:self.view.frame];
                [self.phoneChiSquareLabel setFrame:phoneChiSquareLabelFrame];
                [self.chiSquareResult setFrame:phoneChiSquareResultFrame];
                [self.phonePValueLabel setFrame:phonePValueLabelFrame];
                [self.pValueResult setFrame:phonePValueResultFrame];
                [self.phoneHeaderLabel setFrame:phoneHeaderLabelFrame];
                [self.epiInfoScrollView setFrame:CGRectMake(0, 70, phoneScrollViewSize.size.width, phoneScrollViewSize.size.height)];
                
                //Conditionally set the scroll size by whether or not there is a keyboard
                if (hasAFirstResponder)
                    [self.epiInfoScrollView setContentSize:responderSize];
                else
                    [self.epiInfoScrollView setContentSize:noResponderSize];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [selfViewControl setFrame:self.view.frame];
                [self.phoneChiSquareLabel setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 10 - phoneChiSquareLabelFrame.size.width, phoneChiSquareLabelFrame.origin.y, phoneChiSquareLabelFrame.size.width, phoneChiSquareLabelFrame.size.height)];
                [self.chiSquareResult setFrame:CGRectMake(self.view.frame.size.width / 2.0 - 10 - phoneChiSquareResultFrame.size.width, phoneChiSquareResultFrame.origin.y, phoneChiSquareResultFrame.size.width, phoneChiSquareResultFrame.size.height)];
                [self.phonePValueLabel setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 10, phonePValueLabelFrame.origin.y, phonePValueLabelFrame.size.width, phonePValueLabelFrame.size.height)];
                [self.pValueResult setFrame:CGRectMake(self.view.frame.size.width / 2.0 + 10, phonePValueResultFrame.origin.y, phonePValueResultFrame.size.width, phonePValueResultFrame.size.height)];
                [self.phoneHeaderLabel setFrame:CGRectMake(self.view.frame.size.width / 2.0 - phoneHeaderLabelFrame.size.width / 2.0, phoneHeaderLabelFrame.origin.y, phoneHeaderLabelFrame.size.width, phoneHeaderLabelFrame.size.height)];
                [self.epiInfoScrollView setFrame:CGRectMake(self.view.frame.size.width / 2.0 - phoneScrollViewSize.size.width / 2.0, 70, phoneScrollViewSize.size.width, phoneScrollViewSize.size.height)];
                
                //Conditionally set the scroll size by whether or not there is a keyboard
                if (hasAFirstResponder)
                    [self.epiInfoScrollView setContentSize:landscapeResponderSize];
                else
                    [self.epiInfoScrollView setContentSize:landscapeNoResponderSize];
            }];
        }
        [zoomingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [phoneScrollView setFrame:zoomingView.frame];
        [phoneScrollView setContentSize:zoomingView.frame.size];
        
        if (zs > 1.0)
            [phoneScrollView setZoomScale:zs animated:YES];
    }
}

- (void)popCurrentViewController
{
    //Method for the custom "Back" button on the NavigationController
    [self.navigationController popViewControllerAnimated:YES];
}
@end
