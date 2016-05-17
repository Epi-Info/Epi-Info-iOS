//
//  EpiInfoViewController.m
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//

#import "EpiInfoViewController.h"
#import "StatCalcViewController.h"
#import "StatCalc2x2ViewController.h"
#import "MatchedPairCalculatorViewController.h"
#import "PopulationSurveyViewController.h"

@interface EpiInfoViewController ()

@end

@implementation EpiInfoViewController
@synthesize analyzeDataButton = _analyzeDataButton;
@synthesize statCalcButton = _statCalcButton;

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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    // code here
    self.view.backgroundColor = [[UIColor alloc] initWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    
    self.title = @"";
//    CGRect frame = CGRectMake(0, 0, [self.title sizeWithFont:[UIFont boldSystemFontOfSize:20.0]].width, 44);
    // Deprecation replacement
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
//        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
//        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:45/255.0 green:111/255.0 blue:14/255.0 alpha:1.0]];
//        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTranslucent:NO];
        UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0 - (277.0 / 4.0), 8, 277 / 2.0, 64 / 2.0)];
        [barImageView setImage:[UIImage imageNamed:@"epi_info_logo_full.png"]];
        [self.navigationController.navigationBar addSubview:barImageView];

        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleDefault];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    //self.navigationItem.titleView = label;
    label.text = self.title;
    
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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
//        [self.statCalcButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        button1Frame = CGRectMake(84, 210, 600, 48);
        button2Frame = CGRectMake(84, 266, 600, 48);
        button3Frame = CGRectMake(84, 322, 600, 48);
        button1LandscapeFrame = CGRectMake(self.view.frame.size.height / 2.0 - 140, 60, 280, 44);
        button2LandscapeFrame = CGRectMake(self.view.frame.size.height / 2.0 - 140, 111, 280, 44);
        button3LandscapeFrame = CGRectMake(self.view.frame.size.height / 2.0 - 140, 162, 280, 44);
        
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
            fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
        else
            fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.height, [self.view frame].size.width)];
        [fadingColorView setImage:[UIImage imageNamed:@"iPadBackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        UIView *unblurryView = [[UIView alloc] initWithFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y, button1Frame.size.width + 40, button3Frame.origin.y - button1Frame.origin.y + button3Frame.size.height + 40)];
        [unblurryView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:unblurryView];
        
        // Added for new UI/UX
        UIView *gravView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, self.view.frame.size.width, 256)];
        [gravView setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self.view addSubview:gravView];
        
        // Changed vxs for use with new UI
//        v1 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800), sqrtf(800), 76, 106)];
        v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, gravView.frame.size.width, 84)];
        [v1 setBackgroundColor:[UIColor whiteColor]];
//        v3 = [[UIView alloc] initWithFrame:CGRectMake(unblurryView.frame.size.width - sqrtf(800) - 76, sqrtf(800), 76, 106)];
//        v2 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800) + 76 + (v3.frame.origin.x - (sqrtf(800) + 76)) / 2.0 - 76 / 2.0, sqrtf(800), 76, 106)];
        v2 = [[UIView alloc] initWithFrame:CGRectMake(0, v1.frame.origin.y + v1.frame.size.height + 1, gravView.frame.size.width, 84)];
        [v2 setBackgroundColor:[UIColor whiteColor]];
        v3 = [[UIView alloc] initWithFrame:CGRectMake(0, v2.frame.origin.y + v2.frame.size.height + 1, gravView.frame.size.width, 84)];
        [v3 setBackgroundColor:[UIColor whiteColor]];
        v4 = [[UIView alloc] initWithFrame:CGRectMake(v1.frame.origin.x, v1.frame.origin.y + v1.frame.size.height + 16, v1.frame.size.width, v1.frame.size.height)];
        
//        [unblurryView addSubview:v1];
//        [unblurryView addSubview:v2];
//        [unblurryView addSubview:v3];
//        [unblurryView addSubview:v4];
        
        [gravView addSubview:v1];
        [gravView addSubview:v2];
        [gravView addSubview:v3];
        
        // Make v4 appear in viewDidAppear, depending on presence of VHF data
        [v4 setHidden:YES];
        
        [self.analyzeDataButton setFrame:CGRectMake(8, 4, 76, 76)];
        [self.statCalcButton setFrame:CGRectMake(8, 4, 76, 76)];
        [self.dataEntryButton setFrame:CGRectMake(8, 4, 76, 76)];
        [self.vhfButton setFrame:CGRectMake(0, 0, 76, 76)];
        
        [self.analyzeDataButton.layer setCornerRadius:10.0];
        [self.statCalcButton.layer setCornerRadius:10.0];
        [self.dataEntryButton.layer setCornerRadius:10.0];
        [self.vhfButton.layer setCornerRadius:10.0];
        
        if ([[UIScreen mainScreen] scale] > 1.0)
        {
            [self.analyzeDataButton setBackgroundImage:[UIImage imageNamed:@"AnalysisButton.png"] forState:UIControlStateNormal];
            [self.statCalcButton setBackgroundImage:[UIImage imageNamed:@"CalculatorButton.png"] forState:UIControlStateNormal];
            [self.dataEntryButton setBackgroundImage:[UIImage imageNamed:@"FormsButton.png"] forState:UIControlStateNormal];
            [self.vhfButton setBackgroundImage:[UIImage imageNamed:@"VHFButton.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self.analyzeDataButton setBackgroundImage:[UIImage imageNamed:@"AnalysisButtonNR.png"] forState:UIControlStateNormal];
            [self.statCalcButton setBackgroundImage:[UIImage imageNamed:@"CalculatorButtonNR.png"] forState:UIControlStateNormal];
            [self.dataEntryButton setBackgroundImage:[UIImage imageNamed:@"FormsButtonNR.png"] forState:UIControlStateNormal];
            [self.vhfButton setBackgroundImage:[UIImage imageNamed:@"VHFButtonNR.png"] forState:UIControlStateNormal];
        }
        
        [self.analyzeDataButton setClipsToBounds:YES];
        [self.statCalcButton setClipsToBounds:YES];
        [self.dataEntryButton setClipsToBounds:YES];
        [self.vhfButton setClipsToBounds:YES];
        
        [self.analyzeDataButton setTitle:@"Data analysis" forState:UIControlStateNormal];
        [self.statCalcButton setTitle:@"Stat calc statistical calculators" forState:UIControlStateNormal];
        [self.dataEntryButton setTitle:@"Data entry forms" forState:UIControlStateNormal];
        [self.vhfButton setTitle:@"V H F contact tracing" forState:UIControlStateNormal];
        
        [self.analyzeDataButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.statCalcButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.dataEntryButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.vhfButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        [v1 addSubview:self.dataEntryButton];
        [v2 addSubview:self.analyzeDataButton];
        [v3 addSubview:self.statCalcButton];
        [v4 addSubview:self.vhfButton];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(-3, 80, 82, 18)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(-12, 80, 100, 18)];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 76, 18)];
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 76, 18)];
        UILabel *label4b = [[UILabel alloc] initWithFrame:CGRectMake(0, 98, 76, 18)];
        
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label3 setBackgroundColor:[UIColor clearColor]];
        [label4 setBackgroundColor:[UIColor clearColor]];
        [label4b setBackgroundColor:[UIColor clearColor]];
       
        [label1 setText:@"Enter Data"];
        [label2 setText:@"Analyze Data"];
        [label3 setText:@"StatCalc"];
        [label4 setText:@"Contact"];
        [label4b setText:@"Tracing"];
        
        [label1 setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [label2 setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [label3 setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [label4 setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [label4b setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        
        [label1 setTextAlignment:NSTextAlignmentCenter];
        [label2 setTextAlignment:NSTextAlignmentCenter];
        [label3 setTextAlignment:NSTextAlignmentCenter];
        [label4 setTextAlignment:NSTextAlignmentCenter];
        [label4b setTextAlignment:NSTextAlignmentCenter];
        
        [label1 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [label2 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [label3 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [label4 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [label4b setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        
        // Using different labels with new UI
//        [v1 addSubview:label1];
//        [v2 addSubview:label2];
//        [v3 addSubview:label3];
        [v4 addSubview:label4];
        [v4 addSubview:label4b];
        
        // New, more verbose labels for new UI
        float labelX = self.dataEntryButton.frame.origin.x + self.dataEntryButton.frame.size.width + 16;
        float labelWidth = gravView.frame.size.width - labelX - 8;
        UILabel *l1a = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 8, labelWidth, v1.frame.size.height * 0.4 - 8)];
        UILabel *l1b = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 8 + l1a.frame.size.height, labelWidth, v1.frame.size.height - 8 - l1a.frame.size.height)];
        UILabel *l2a = [[UILabel alloc] initWithFrame:CGRectMake(labelX, l1a.frame.origin.y, labelWidth, l1a.frame.size.height)];
        UILabel *l2b = [[UILabel alloc] initWithFrame:CGRectMake(labelX, l1b.frame.origin.y, labelWidth, l1b.frame.size.height)];
        UILabel *l3a = [[UILabel alloc] initWithFrame:CGRectMake(labelX, l1a.frame.origin.y, labelWidth, l1a.frame.size.height)];
        UILabel *l3b = [[UILabel alloc] initWithFrame:CGRectMake(labelX, l1b.frame.origin.y, labelWidth, l1b.frame.size.height)];
        
        [l1a setText:@"ENTER DATA"];
        [l1a setTextAlignment:NSTextAlignmentLeft];
        [l1a setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l1a setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
        [l1b setText:@"Enter data, browse records, and search the database."];
        [l1b setTextAlignment:NSTextAlignmentLeft];
        [l1b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l1b setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [l1b setNumberOfLines:0];
        [l1b setLineBreakMode:NSLineBreakByWordWrapping];
        
        [l2a setText:@"ANALYZE DATA"];
        [l2a setTextAlignment:NSTextAlignmentLeft];
        [l2a setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l2a setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
        [l2b setText:@"Visualize analytic results with gadgets, tables, and SQL tools."];
        [l2b setTextAlignment:NSTextAlignmentLeft];
        [l2b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l2b setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [l2b setNumberOfLines:0];
        [l2b setLineBreakMode:NSLineBreakByWordWrapping];
        
        [l3a setText:@"STATCALC"];
        [l3a setTextAlignment:NSTextAlignmentLeft];
        [l3a setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l3a setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
        [l3b setText:@"Statistical calculators for sample size, power, and more."];
        [l3b setTextAlignment:NSTextAlignmentLeft];
        [l3b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l3b setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [l3b setNumberOfLines:0];
        [l3b setLineBreakMode:NSLineBreakByWordWrapping];
        
        [v1 addSubview:l1a];
        [v1 addSubview:l1b];
        [v2 addSubview:l2a];
        [v2 addSubview:l2b];
        [v3 addSubview:l3a];
        [v3 addSubview:l3b];
        
        // Clear buttons to go over labels
        UIButton *clearButton1 = [[UIButton alloc] initWithFrame:CGRectMake(l1a.frame.origin.x, l1a.frame.origin.y - 8, l1a.frame.size.width, v1.frame.size.height)];
        [clearButton1 setBackgroundColor:[UIColor clearColor]];
        [clearButton1 setTag:1];
        [clearButton1 addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [clearButton1 addTarget:self action:@selector(clearButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton1 addTarget:self action:@selector(clearButtonDragged:) forControlEvents:UIControlEventTouchDragOutside];
        [clearButton1 setAccessibilityLabel:@"Enter data. Enter data, browse records, and search the database."];
        [v1 addSubview:clearButton1];
        UIButton *clearButton2 = [[UIButton alloc] initWithFrame:CGRectMake(l1a.frame.origin.x, l1a.frame.origin.y - 8, l1a.frame.size.width, v1.frame.size.height)];
        [clearButton2 setBackgroundColor:[UIColor clearColor]];
        [clearButton2 setTag:2];
        [clearButton2 addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [clearButton2 addTarget:self action:@selector(clearButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton2 addTarget:self action:@selector(clearButtonDragged:) forControlEvents:UIControlEventTouchDragOutside];
        [clearButton2 setAccessibilityLabel:@"Analyze data. Visualize analytic results with gadgets, tables, and SQL tools."];
        [v2 addSubview:clearButton2];
        UIButton *clearButton3 = [[UIButton alloc] initWithFrame:CGRectMake(l1a.frame.origin.x, l1a.frame.origin.y - 8, l1a.frame.size.width, v1.frame.size.height)];
        [clearButton3 setBackgroundColor:[UIColor clearColor]];
        [clearButton3 setTag:3];
        [clearButton3 addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [clearButton3 addTarget:self action:@selector(clearButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton3 addTarget:self action:@selector(clearButtonDragged:) forControlEvents:UIControlEventTouchDragOutside];
        [clearButton3 setAccessibilityLabel:@"Stat calc. Statistical calculators for sample size, power, and more."];
        [v3 addSubview:clearButton3];
       
        // Use a larger label than just the nav bar for the title in the iPad
        [self setTitle:@""];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        UILabel *padTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 150)];
        [padTitleLabel setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [padTitleLabel setText:@""];
        [padTitleLabel setTextColor:[UIColor whiteColor]];
        [padTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [padTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0]];
//        [self.view addSubview:padTitleLabel];
    }
    else
    {
//        [self.statCalcButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        button1Frame = CGRectMake(20, 60, 280, 44);
        button2Frame = CGRectMake(20, 111, 280, 44);
        button3Frame = CGRectMake(20, 162, 280, 44);
        button4Frame = CGRectMake(20, 213, 280, 44);
        button5Frame = CGRectMake(20, 264, 280, 44);
        button1LandscapeFrame = CGRectMake(self.view.frame.size.height / 2.0 - 140, 60, 280, 44);
        button2LandscapeFrame = CGRectMake(self.view.frame.size.height / 2.0 - 140, 111, 280, 44);
        button3LandscapeFrame = CGRectMake(self.view.frame.size.height / 2.0 - 140, 162, 280, 44);

        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];

        if (self.view.frame.size.height > 500)
        {
            [fadingColorView setFrame:CGRectMake(0, 0, 320, 504)];
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5BackgroundWhite.png"]];
        }
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4BackgroundWhite.png"]];

        UIView *unblurryView = [[UIView alloc] initWithFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y, button1Frame.size.width + 40, button3Frame.origin.y - button1Frame.origin.y + button3Frame.size.height + 120 + 40)];
        [unblurryView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:unblurryView];
        
        // Added for new UI/UX
        UIView *gravView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, self.view.frame.size.width, 208)];
        [gravView setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self.view addSubview:gravView];

        // Changed vxs for use with new UI
//        v1 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800), sqrtf(800), 60, 90)];
        v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, gravView.frame.size.width, 68)];
        [v1 setBackgroundColor:[UIColor whiteColor]];
//        v3 = [[UIView alloc] initWithFrame:CGRectMake(unblurryView.frame.size.width - sqrtf(800) - 60, sqrtf(800), 60, 90)];
 //       v2 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800) + 60 + (v3.frame.origin.x - (sqrtf(800) + 60)) / 2.0 - 60 / 2.0, sqrtf(800), 60, 90)];
        v2 = [[UIView alloc] initWithFrame:CGRectMake(0, v1.frame.origin.y + v1.frame.size.height + 1, gravView.frame.size.width, 68)];
        [v2 setBackgroundColor:[UIColor whiteColor]];
        v3 = [[UIView alloc] initWithFrame:CGRectMake(0, v2.frame.origin.y + v2.frame.size.height + 1, gravView.frame.size.width, 68)];
        [v3 setBackgroundColor:[UIColor whiteColor]];
        v4 = [[UIView alloc] initWithFrame:CGRectMake(v1.frame.origin.x, v1.frame.origin.y + v1.frame.size.height + 32, v1.frame.size.width, v1.frame.size.height)];
        v5 = [[UIView alloc] initWithFrame:CGRectMake(v2.frame.origin.x, v1.frame.origin.y + v1.frame.size.height + 32, v1.frame.size.width, v1.frame.size.height)];
        
//        [unblurryView addSubview:v1];
//        [unblurryView addSubview:v2];
//        [unblurryView addSubview:v3];
        [gravView addSubview:v1];
        [gravView addSubview:v2];
        [gravView addSubview:v3];
        [unblurryView addSubview:v4];
//        [unblurryView addSubview:v5];
        
        // Make v4 appear in viewDidAppear, depending on presence of VHF data
        [v4 setHidden:YES];

        [self.analyzeDataButton setFrame:CGRectMake(4, 4, 60, 60)];
        [self.statCalcButton setFrame:CGRectMake(4, 4, 60, 60)];
        [self.dataEntryButton setFrame:CGRectMake(4, 4, 60, 60)];
        [self.vhfButton setFrame:CGRectMake(0, 0, 60, 60)];
        [self.simulationsButton setFrame:CGRectMake(0, 0, 60, 60)];
        
        [self.analyzeDataButton.layer setCornerRadius:10.0];
        [self.statCalcButton.layer setCornerRadius:10.0];
        [self.dataEntryButton.layer setCornerRadius:10.0];
        [self.vhfButton.layer setCornerRadius:10.0];
        [self.simulationsButton.layer setCornerRadius:10.0];
        
        if ([[UIScreen mainScreen] scale] > 1.0)
        {
            [self.analyzeDataButton setBackgroundImage:[UIImage imageNamed:@"AnalysisButton.png"] forState:UIControlStateNormal];
            [self.statCalcButton setBackgroundImage:[UIImage imageNamed:@"CalculatorButton.png"] forState:UIControlStateNormal];
            [self.dataEntryButton setBackgroundImage:[UIImage imageNamed:@"FormsButton.png"] forState:UIControlStateNormal];
            [self.vhfButton setBackgroundImage:[UIImage imageNamed:@"VHFButton.png"] forState:UIControlStateNormal];
            [self.simulationsButton setBackgroundImage:[UIImage imageNamed:@"SimulationButton.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self.analyzeDataButton setBackgroundImage:[UIImage imageNamed:@"AnalysisButtonNR.png"] forState:UIControlStateNormal];
            [self.statCalcButton setBackgroundImage:[UIImage imageNamed:@"CalculatorButtonNR.png"] forState:UIControlStateNormal];
            [self.dataEntryButton setBackgroundImage:[UIImage imageNamed:@"FormsButtonNR.png"] forState:UIControlStateNormal];
            [self.vhfButton setBackgroundImage:[UIImage imageNamed:@"VHFButtonNR.png"] forState:UIControlStateNormal];
            [self.simulationsButton setBackgroundImage:[UIImage imageNamed:@"SimulationButtonNR.png"] forState:UIControlStateNormal];
        }
        
        [self.analyzeDataButton setClipsToBounds:YES];
        [self.statCalcButton setClipsToBounds:YES];
        [self.dataEntryButton setClipsToBounds:YES];
        [self.vhfButton setClipsToBounds:YES];
        [self.simulationsButton setClipsToBounds:YES];
        
        [self.analyzeDataButton setTitle:@"Data analysis" forState:UIControlStateNormal];
        [self.statCalcButton setTitle:@"Stat calc statistical calculators" forState:UIControlStateNormal];
        [self.dataEntryButton setTitle:@"Data entry forms" forState:UIControlStateNormal];
        [self.vhfButton setTitle:@"V H F contact tracing" forState:UIControlStateNormal];
        [self.simulationsButton setTitle:@"Simulate" forState:UIControlStateNormal];
        
        [self.analyzeDataButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.statCalcButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.dataEntryButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.vhfButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.simulationsButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        [v1 addSubview:self.dataEntryButton];
        [v2 addSubview:self.analyzeDataButton];
        [v3 addSubview:self.statCalcButton];
        [v4 addSubview:self.vhfButton];
        [v5 addSubview:self.simulationsButton];

        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(-8, 64, 76, 12)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(-8, 64, 76, 12)];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 60, 12)];
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 60, 12)];
        UILabel *label4b = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, 60, 14)];
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(-4, 64, 68, 12)];
        UILabel *label5b = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, 60, 14)];
        
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label3 setBackgroundColor:[UIColor clearColor]];
        [label4 setBackgroundColor:[UIColor clearColor]];
        [label4b setBackgroundColor:[UIColor clearColor]];
        [label5 setBackgroundColor:[UIColor clearColor]];
        [label5b setBackgroundColor:[UIColor clearColor]];
        
        [label1 setText:@"Enter Data"];
        [label2 setText:@"Analyze Data"];
        [label3 setText:@"StatCalc"];
        [label4 setText:@"Contact"];
        [label4b setText:@"Tracing"];
        [label5 setText:@"Simulations"];
        [label5b setText:@"Study"];
        
        [label1 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [label2 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [label3 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [label4 setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [label4b setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [label5 setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [label5b setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        
        [label1 setTextAlignment:NSTextAlignmentCenter];
        [label2 setTextAlignment:NSTextAlignmentCenter];
        [label3 setTextAlignment:NSTextAlignmentCenter];
        [label4 setTextAlignment:NSTextAlignmentCenter];
        [label4b setTextAlignment:NSTextAlignmentCenter];
        [label5 setTextAlignment:NSTextAlignmentCenter];
        [label5b setTextAlignment:NSTextAlignmentCenter];
        
        [label1 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [label2 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [label3 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [label4 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [label4b setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [label5 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [label5b setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];

        // Using different labels with new UI
//        [v1 addSubview:label1];
//        [v2 addSubview:label2];
//        [v3 addSubview:label3];
        [v4 addSubview:label4];
        [v4 addSubview:label4b];
        [v5 addSubview:label5];
//        [v5 addSubview:label5b];
        
        // New, more verbose labels for new UI
        float labelX = self.dataEntryButton.frame.origin.x + self.dataEntryButton.frame.size.width + 16;
        float labelWidth = gravView.frame.size.width - labelX - 8;
        UILabel *l1a = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 8, labelWidth, v1.frame.size.height * 0.4 - 8)];
        UILabel *l1b = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 8 + l1a.frame.size.height, labelWidth, v1.frame.size.height - 8 - l1a.frame.size.height)];
        UILabel *l2a = [[UILabel alloc] initWithFrame:CGRectMake(labelX, l1a.frame.origin.y, labelWidth, l1a.frame.size.height)];
        UILabel *l2b = [[UILabel alloc] initWithFrame:CGRectMake(labelX, l1b.frame.origin.y, labelWidth, l1b.frame.size.height)];
        UILabel *l3a = [[UILabel alloc] initWithFrame:CGRectMake(labelX, l1a.frame.origin.y, labelWidth, l1a.frame.size.height)];
        UILabel *l3b = [[UILabel alloc] initWithFrame:CGRectMake(labelX, l1b.frame.origin.y, labelWidth, l1b.frame.size.height)];
        
        [l1a setText:@"ENTER DATA"];
        [l1a setTextAlignment:NSTextAlignmentLeft];
        [l1a setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l1a setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
        [l1b setText:@"Enter data, browse records, and search the database."];
        [l1b setTextAlignment:NSTextAlignmentLeft];
        [l1b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l1b setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [l1b setNumberOfLines:0];
        [l1b setLineBreakMode:NSLineBreakByWordWrapping];
        
        [l2a setText:@"ANALYZE DATA"];
        [l2a setTextAlignment:NSTextAlignmentLeft];
        [l2a setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l2a setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
        [l2b setText:@"Visualize analytic results with gadgets, tables, and SQL tools."];
        [l2b setTextAlignment:NSTextAlignmentLeft];
        [l2b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l2b setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [l2b setNumberOfLines:0];
        [l2b setLineBreakMode:NSLineBreakByWordWrapping];
        
        [l3a setText:@"STATCALC"];
        [l3a setTextAlignment:NSTextAlignmentLeft];
        [l3a setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l3a setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
        [l3b setText:@"Statistical calculators for sample size, power, and more."];
        [l3b setTextAlignment:NSTextAlignmentLeft];
        [l3b setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [l3b setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [l3b setNumberOfLines:0];
        [l3b setLineBreakMode:NSLineBreakByWordWrapping];
        
        [v1 addSubview:l1a];
        [v1 addSubview:l1b];
        [v2 addSubview:l2a];
        [v2 addSubview:l2b];
        [v3 addSubview:l3a];
        [v3 addSubview:l3b];
        
        // Clear buttons to go over labels
        UIButton *clearButton1 = [[UIButton alloc] initWithFrame:CGRectMake(l1a.frame.origin.x, l1a.frame.origin.y - 8, l1a.frame.size.width, v1.frame.size.height)];
        [clearButton1 setBackgroundColor:[UIColor clearColor]];
        [clearButton1 setTag:1];
        [clearButton1 addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [clearButton1 addTarget:self action:@selector(clearButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton1 addTarget:self action:@selector(clearButtonDragged:) forControlEvents:UIControlEventTouchDragOutside];
        [clearButton1 setAccessibilityLabel:@"Enter data. Enter data, browse records, and search the database."];
        [v1 addSubview:clearButton1];
        UIButton *clearButton2 = [[UIButton alloc] initWithFrame:CGRectMake(l1a.frame.origin.x, l1a.frame.origin.y - 8, l1a.frame.size.width, v1.frame.size.height)];
        [clearButton2 setBackgroundColor:[UIColor clearColor]];
        [clearButton2 setTag:2];
        [clearButton2 addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [clearButton2 addTarget:self action:@selector(clearButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton2 addTarget:self action:@selector(clearButtonDragged:) forControlEvents:UIControlEventTouchDragOutside];
        [clearButton2 setAccessibilityLabel:@"Analyze data. Visualize analytic results with gadgets, tables, and SQL tools."];
        [v2 addSubview:clearButton2];
        UIButton *clearButton3 = [[UIButton alloc] initWithFrame:CGRectMake(l1a.frame.origin.x, l1a.frame.origin.y - 8, l1a.frame.size.width, v1.frame.size.height)];
        [clearButton3 setBackgroundColor:[UIColor clearColor]];
        [clearButton3 setTag:3];
        [clearButton3 addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [clearButton3 addTarget:self action:@selector(clearButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton3 addTarget:self action:@selector(clearButtonDragged:) forControlEvents:UIControlEventTouchDragOutside];
        [clearButton3 setAccessibilityLabel:@"Stat calc. Statistical calculators for sample size, power, and more."];
        [v3 addSubview:clearButton3];
    }
    // Remove this section when ready to add analysis
//    [v2 setHidden:YES];
//    [v1 setFrame:CGRectMake(v1.superview.frame.size.width / 3.0 - v1.frame.size.width, v1.frame.origin.y, v1.frame.size.width, v1.frame.size.height)];
//    [v3 setFrame:CGRectMake(2.0 * v3.superview.frame.size.width / 3.0, v3.frame.origin.y, v3.frame.size.width, v3.frame.size.height)];
    // End of hide analysis section
}

-(void)viewDidAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        hasVHFData = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        sqlite3 *epiinfoDB;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(*) as n from %@", @"_VHFContactTracing"];
            
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    hasVHFData = YES;
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        
        if (hasVHFData)
            [v4 setHidden:NO];
        else
            [v4 setHidden:YES];
    }
    else
    {
        hasVHFData = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        sqlite3 *epiinfoDB;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(*) as n from %@", @"_VHFContactTracing"];
            
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    hasVHFData = YES;
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        
        if (hasVHFData)
            [v4 setHidden:NO];
        else
            [v4 setHidden:YES];
        
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.analyzeDataButton setFrame:button1LandscapeFrame];
                [self.statCalcButton setFrame:button2LandscapeFrame];
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    frameOfButtonPressed = [[(UIButton *)sender superview] frame];
    buttonPressed = (UIButton *)sender;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([segue.identifier isEqualToString:@"Whatever"])
        {
        }
        else if ([segue.identifier isEqualToString:@"StatCalcButtonPushed"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"StatCalc5.png"];
            else
                [self setImageFileToUseInSegue:@"StatCalc4.png"];
        }
        else if ([segue.identifier isEqualToString:@"AnalyzeDataButtonPushed"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"Analysis5.png"];
            else
                [self setImageFileToUseInSegue:@"Analysis4.png"];
        }
        else if ([segue.identifier isEqualToString:@"EnterDataButtonPushed"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"Entry5.png"];
            else
                [self setImageFileToUseInSegue:@"EnterData4.png"];
        }
        else if ([segue.identifier isEqualToString:@"VHFButtonPushed"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"VHF.png"];
            else
                [self setImageFileToUseInSegue:@"VHF4.png"];
        }
        else if ([segue.identifier isEqualToString:@"SimulationsButtonPushed"])
        {
            if (self.view.frame.size.height > 500)
                [self setImageFileToUseInSegue:@"Simulations5.png"];
            else
                [self setImageFileToUseInSegue:@"Simulations4.png"];
        }
    }
    else
    {
        if ([segue.identifier isEqualToString:@"Whatever"])
        {
        }
        else if ([segue.identifier isEqualToString:@"StatCalcButtonPushed"])
        {
            [self setImageFileToUseInSegue:@"StatCalcPad.png"];
        }
        else if ([segue.identifier isEqualToString:@"AnalyzeDataButtonPushed"])
        {
            [self setImageFileToUseInSegue:@"AnalysisPad.png"];
        }
        else if ([segue.identifier isEqualToString:@"EnterDataButtonPushed"])
        {
            [self setImageFileToUseInSegue:@"EnterDataPad.png"];
        }
        else if ([segue.identifier isEqualToString:@"VHFButtonPushed"])
        {
            [self setImageFileToUseInSegue:@"VHFPad.png"];
        }
    }
}

- (void)clearButtonPressed:(UIButton *)sender
{
    switch ([sender tag]) {
        case 1:
            [self.dataEntryButton setHighlighted:YES];
            break;
            
        case 2:
            [self.analyzeDataButton setHighlighted:YES];
            break;
            
        case 3:
            [self.statCalcButton setHighlighted:YES];
            break;
            
        default:
            break;
    }
}
- (void)clearButtonReleased:(UIButton *)sender
{
    switch ([sender tag]) {
        case 1:
            [self.dataEntryButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [self.dataEntryButton setHighlighted:NO];
            break;
            
        case 2:
            [self.analyzeDataButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [self.analyzeDataButton setHighlighted:NO];
            break;
            
        case 3:
            [self.statCalcButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [self.statCalcButton setHighlighted:NO];
            break;
            
        default:
            break;
    }
}
- (void)clearButtonDragged:(UIButton *)sender
{
    switch ([sender tag]) {
        case 1:
            [self.dataEntryButton setHighlighted:NO];
            break;
            
        case 2:
            [self.analyzeDataButton setHighlighted:NO];
            break;
            
        case 3:
            [self.statCalcButton setHighlighted:NO];
            break;
            
        default:
            break;
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
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
        if (currentOrientationPortrait)
        {
        }
        else
        {
        }
    }
    else
    {
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.analyzeDataButton setFrame:button1Frame];
                [self.statCalcButton setFrame:button2Frame];
                
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.analyzeDataButton setFrame:button1LandscapeFrame];
                [self.statCalcButton setFrame:button2LandscapeFrame];
                
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
    }
}
@end
