//
//  PoissonCalculatorViewController.m
//  EpiInfo
//
//  Created by John Copeland on 10/12/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import "PoissonCalculatorViewController.h"
#import "EpiInfoScrollView.h"
#import "PoissonCalculatorCompute.h"

@interface PoissonCalculatorViewController ()
@property (nonatomic, weak) IBOutlet EpiInfoScrollView *epiInfoScrollView;
@end

@implementation PoissonCalculatorViewController
//iPad
@synthesize observedEventsField, expectedEventsField;
//

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
    scrollViewFrame = CGRectMake(0, 40, 769,960);
    [self.epiInfoScrollView0 setScrollEnabled:NO];

    self.observedEventsField.returnKeyType = UIReturnKeyNext;
    self.expectedEventsField.returnKeyType = UIReturnKeyDone;
    self.observedEventsField.delegate = self;
    self.expectedEventsField.delegate = self;
    
    [self.expectedEventsField setTag:42];
    
    self.epiInfoScrollView.contentSize = CGSizeMake(320, 758);
    
    //iPad
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"textured-Bar.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:124/255.0 green:177/255.0 blue:55/255.0 alpha:1.0]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    self.title = @"";
    //
    
    //self.title = @"Poisson";
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
    
    [self.observedEventsField setText:@"10"];
    [self.expectedEventsField setText:@"10"];
    [self compute:self.expectedEventsField];
    [self.expectedEventsField resignFirstResponder];
    
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
            [self.lowerNavigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:130/255.0 blue:126/255.0 alpha:1.0]];
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
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        [self.phoneSectionHeaderLabel setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneSectionHeaderLabel setFrame:CGRectMake(2, 2, self.phoneSectionHeaderLabel.frame.size.width, self.phoneSectionHeaderLabel.frame.size.height)];
        [self.phoneSectionHeaderLabel.layer setCornerRadius:10.0];
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.epiInfoScrollView.frame.size.width, self.epiInfoScrollView.frame.size.height)];
        
        float X = self.phoneSectionHeaderLabel.frame.origin.x;
        float Y = self.phoneSectionHeaderLabel.frame.origin.y;
        float W = self.phoneSectionHeaderLabel.frame.size.width;
        float H = self.ltLabel.frame.size.height;
        
        phoneColorBox = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, 200)];
        [phoneColorBox setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [phoneColorBox.layer setCornerRadius:10.0];
        
        phoneInputsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 109)];
        
        phoneResultsView = [[UIView alloc] initWithFrame:CGRectMake(18, 109, 277, 300)];
        [self.view addSubview:phoneResultsView];
        [phoneResultsView addSubview:self.phoneSectionHeaderLabel];

        [self.view addSubview:phoneInputsView];
        
        [phoneInputsView addSubview:self.expectedEventsField];
        [phoneInputsView addSubview:self.observedEventsField];
        [self.phoneExpectedEventsLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneObservedEventsLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.phoneExpectedEventsLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.phoneObservedEventsLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        if (self.view.frame.size.height <= 500)
        {
            [self.phoneExpectedEventsLabel setFrame:CGRectMake(self.phoneExpectedEventsLabel.frame.origin.x, self.phoneExpectedEventsLabel.frame.origin.y + 10.0, self.phoneExpectedEventsLabel.frame.size.width, self.phoneExpectedEventsLabel.frame.size.height)];
            [self.expectedEventsField setFrame:CGRectMake(self.expectedEventsField.frame.origin.x, self.expectedEventsField.frame.origin.y + 10.0, self.expectedEventsField.frame.size.width, self.expectedEventsField.frame.size.height)];
        }
        [phoneInputsView addSubview:self.phoneObservedEventsLabel];
        [phoneInputsView addSubview:self.phoneExpectedEventsLabel];
        [phoneInputsView addSubview:self.phoneComputeButton];
        [phoneInputsView addSubview:self.phoneResetButton];

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
        
        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
        if (self.view.frame.size.height > 500)
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5BackgroundWhite.png"]];
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4BackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
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
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
        [tgr setNumberOfTapsRequired:2];
        [tgr setNumberOfTouchesRequired:1];
        [self.epiInfoScrollView addGestureRecognizer:tgr];
        
        [self.epiInfoScrollView setShowsVerticalScrollIndicator:NO];
        [self.epiInfoScrollView setShowsHorizontalScrollIndicator:NO];
        [self.epiInfoScrollView setShowsVerticalScrollIndicator:YES];
        [self.epiInfoScrollView setShowsHorizontalScrollIndicator:YES];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            float Y = phoneResultsView.frame.origin.y;
            float H = 21.0;
            
            [self.ltLabel setFrame:CGRectMake(self.ltLabel.frame.origin.x - phoneResultsView.frame.origin.x, 139 - Y, self.ltLabel.frame.size.width, H)];
            [self.ltValue setFrame:CGRectMake(self.ltValue.frame.origin.x - phoneResultsView.frame.origin.x, 139 - Y, self.ltValue.frame.size.width, H)];
            
            [self.leLabel setFrame:CGRectMake(self.leLabel.frame.origin.x - phoneResultsView.frame.origin.x, 168 - Y, self.leLabel.frame.size.width, H)];
            [self.leValue setFrame:CGRectMake(self.leValue.frame.origin.x - phoneResultsView.frame.origin.x, 168 - Y, self.leValue.frame.size.width, H)];
            
            [self.eqLabel setFrame:CGRectMake(self.eqLabel.frame.origin.x - phoneResultsView.frame.origin.x, 197 - Y, self.eqLabel.frame.size.width, H)];
            [self.eqValue setFrame:CGRectMake(self.eqValue.frame.origin.x - phoneResultsView.frame.origin.x, 197 - Y, self.eqValue.frame.size.width, H)];
            
            [self.geLabel setFrame:CGRectMake(self.geLabel.frame.origin.x - phoneResultsView.frame.origin.x, 226 - Y, self.geLabel.frame.size.width, H)];
            [self.geValue setFrame:CGRectMake(self.geValue.frame.origin.x - phoneResultsView.frame.origin.x, 226 - Y, self.geValue.frame.size.width, H)];
            
            [self.gtLabel setFrame:CGRectMake(self.gtLabel.frame.origin.x - phoneResultsView.frame.origin.x, 254 - Y, self.gtLabel.frame.size.width, H)];
            [self.gtValue setFrame:CGRectMake(self.gtValue.frame.origin.x - phoneResultsView.frame.origin.x, 254 - Y, self.gtValue.frame.size.width, H)];
            
            float X = self.phoneSectionHeaderLabel.frame.origin.x;
            Y = self.phoneSectionHeaderLabel.frame.origin.y;
            float W = self.phoneSectionHeaderLabel.frame.size.width;
            H = self.phoneSectionHeaderLabel.frame.size.height + self.ltLabel.frame.size.height * 7;
            
            [self.phoneSectionHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
            [self.phoneObservedEventsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
            [self.phoneExpectedEventsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
            
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
            [phoneWhiteBox8 setFrame:CGRectMake(X + 2.0, Y - 2.0, W - 3.0, H + 5.0)];
            [phoneExtraWhite0 setFrame:CGRectMake(X + 12.0, Y - 2.0, W - 13.0, H + 5.0)];
            [phoneExtraWhite2 setFrame:CGRectMake(X + 2.0, Y - 2.0, W / 4.0, H / 2.0)];
            
            X = self.gtValue.frame.origin.x;
            Y = self.gtValue.frame.origin.y;
            W = self.gtValue.frame.size.width;
            H = self.gtValue.frame.size.height;
            [phoneWhiteBox9 setFrame:CGRectMake(X + 4.0, Y - 2.0, W - 6.0, H + 5.0)];
            [phoneExtraWhite1 setFrame:CGRectMake(X + 4.0, Y - 2.0, W - 16.0, H + 5.0)];
            [phoneExtraWhite3 setFrame:CGRectMake(X + 4.0 + (W - 6.0) * 0.75, Y - 2.0, (W - 6.0) / 4.0, H / 2.0)];
            
            label.text = @"";
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
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [fadingColorView setFrame:CGRectMake(0, self.view.frame.size.height - 400.0, [self.view frame].size.width, 400.0)];
                    [fadingColorView0 setAlpha:0];
                }
                
                [self.subView1 setFrame:CGRectMake(0, 55, 437, 293)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 565, 25, 565, 356)];
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
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        {
            float Y = phoneResultsView.frame.origin.y;
            float H = 21.0;
            
            [self.ltLabel setFrame:CGRectMake(self.ltLabel.frame.origin.x - phoneResultsView.frame.origin.x, 139 - Y, self.ltLabel.frame.size.width, H)];
            [self.ltValue setFrame:CGRectMake(self.ltValue.frame.origin.x - phoneResultsView.frame.origin.x, 139 - Y, self.ltValue.frame.size.width, H)];
            
            [self.leLabel setFrame:CGRectMake(self.leLabel.frame.origin.x - phoneResultsView.frame.origin.x, 168 - Y, self.leLabel.frame.size.width, H)];
            [self.leValue setFrame:CGRectMake(self.leValue.frame.origin.x - phoneResultsView.frame.origin.x, 168 - Y, self.leValue.frame.size.width, H)];
            
            [self.eqLabel setFrame:CGRectMake(self.eqLabel.frame.origin.x - phoneResultsView.frame.origin.x, 197 - Y, self.eqLabel.frame.size.width, H)];
            [self.eqValue setFrame:CGRectMake(self.eqValue.frame.origin.x - phoneResultsView.frame.origin.x, 197 - Y, self.eqValue.frame.size.width, H)];
            
            [self.geLabel setFrame:CGRectMake(self.geLabel.frame.origin.x - phoneResultsView.frame.origin.x, 226 - Y, self.geLabel.frame.size.width, H)];
            [self.geValue setFrame:CGRectMake(self.geValue.frame.origin.x - phoneResultsView.frame.origin.x, 226 - Y, self.geValue.frame.size.width, H)];
            
            [self.gtLabel setFrame:CGRectMake(self.gtLabel.frame.origin.x - phoneResultsView.frame.origin.x, 254 - Y, self.gtLabel.frame.size.width, H)];
            [self.gtValue setFrame:CGRectMake(self.gtValue.frame.origin.x - phoneResultsView.frame.origin.x, 254 - Y, self.gtValue.frame.size.width, H)];
            
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
            [phoneWhiteBox8 setFrame:CGRectMake(X + 2.0, Y - 2.0, W - 3.0, H + 5.0)];
            [phoneExtraWhite0 setFrame:CGRectMake(X + 12.0, Y - 2.0, W - 13.0, H + 5.0)];
            [phoneExtraWhite2 setFrame:CGRectMake(X + 2.0, Y - 2.0, W / 4.0, H / 2.0)];
            
            X = self.gtValue.frame.origin.x;
            Y = self.gtValue.frame.origin.y;
            W = self.gtValue.frame.size.width;
            H = self.gtValue.frame.size.height;
            [phoneWhiteBox9 setFrame:CGRectMake(X + 4.0, Y - 2.0, W - 6.0, H + 5.0)];
            [phoneExtraWhite1 setFrame:CGRectMake(X + 4.0, Y - 2.0, W - 16.0, H + 5.0)];
            [phoneExtraWhite3 setFrame:CGRectMake(X + 4.0 + (W - 6.0) * 0.75, Y - 2.0, (W - 6.0) / 4.0, H / 2.0)];
        }
        
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (self.view.frame.size.width > 2.0 * phoneResultsView.frame.size.width)
                {
                    [phoneInputsView setFrame:CGRectMake(self.view.frame.size.width  / 2.0 - phoneResultsView.frame.size.width, 0, self.view.frame.size.height, 109)];
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width  / 2.0, 0, 277, 300)];
                }
                else
                {
                    [phoneInputsView setFrame:CGRectMake(1.0 - self.phoneObservedEventsLabel.frame.origin.x, 0, self.view.frame.size.height, 109)];
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width - 276, 0, 277, 300)];
                }
                [fadingColorView setFrame:CGRectMake(0, [self.view frame].size.height / 2.0, [self.view frame].size.width, self.view.frame.size.height / 2.0)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [phoneInputsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 109)];
                [phoneResultsView setFrame:CGRectMake(18, 109, 277, 300)];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [fadingColorView setFrame:CGRectMake(0, [self.view frame].size.height / 2.0, [self.view frame].size.width, self.view.frame.size.height / 2.0)];
                }
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/PoissonScreenPad.png" atomically:YES];
//    To here
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)textFieldActions:(id)sender
{
    int cursorPosition = [sender offsetFromPosition:[sender endOfDocument] toPosition:[[sender selectedTextRange] start]];
    
    UITextField *theTextField = (UITextField *)sender;
    
    if (theTextField.text.length + cursorPosition == 0)
    {
        [self compute:sender];
        return;
    }
    
    if (theTextField.text.length == 0)
    {
        [self compute:sender];
        return;
    }
    
    int tag = [theTextField tag];
    NSCharacterSet *validSet; // = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
/*
    if ([[theTextField.text substringWithRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1)] stringByTrimmingCharactersInSet:validSet].length > 0)
    {
        theTextField.text = [theTextField.text stringByReplacingCharactersInRange:NSMakeRange(theTextField.text.length - 1 + cursorPosition, 1) withString:@""];
    }
   else
        [self compute:sender];
*/
    if (tag)
    {
        validSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
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

- (IBAction)resetBarButtonPressed:(id)sender
{
    [self reset:sender];
}

- (IBAction)compute:(id)sender
{
    if (self.observedEventsField.text.length > 0 && self.expectedEventsField.text.length > 0)
    {
        int observedValue = [self.observedEventsField.text intValue];
        double expectedValue = [self.expectedEventsField.text doubleValue];
        
        PoissonCalculatorCompute *computer = [[PoissonCalculatorCompute alloc] init];
        double probs[5];
        [computer Calculate:observedValue VariableLambda:expectedValue ProbabilityArray:probs];
        
        self.ltLabel.text = [[NSString alloc] initWithFormat:@"< %d", observedValue];
        self.ltLabel.accessibilityLabel = [NSString stringWithFormat:@"less than %d", observedValue];
        self.ltValue.text = [[NSString alloc] initWithFormat:@"%g", probs[0]];
        self.leLabel.text = [[NSString alloc] initWithFormat:@"<= %d", observedValue];
        self.leLabel.accessibilityLabel = [NSString stringWithFormat:@"less than or equal to %d", observedValue];
        self.leValue.text = [[NSString alloc] initWithFormat:@"%g", probs[1]];
        self.eqLabel.text = [[NSString alloc] initWithFormat:@"= %d", observedValue];
        self.eqLabel.accessibilityLabel = [NSString stringWithFormat:@"equal to %d", observedValue];
        self.eqValue.text = [[NSString alloc] initWithFormat:@"%g", probs[2]];
        self.geLabel.text = [[NSString alloc] initWithFormat:@">= %d", observedValue];
        self.geLabel.accessibilityLabel = [NSString stringWithFormat:@"greater than or equal to %d", observedValue];
        self.geValue.text = [[NSString alloc] initWithFormat:@"%g", probs[3]];
        self.gtLabel.text = [[NSString alloc] initWithFormat:@"> %d", observedValue];
        self.gtLabel.accessibilityLabel = [NSString stringWithFormat:@"greater than %d", observedValue];
        self.gtValue.text = [[NSString alloc] initWithFormat:@"%g", probs[4]];
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
    }
}

- (IBAction)reset:(id)sender
{
    if ([self.observedEventsField isFirstResponder])
        [self.observedEventsField resignFirstResponder];
    else if ([self.expectedEventsField isFirstResponder])
        [self.expectedEventsField resignFirstResponder];
    
    self.observedEventsField.text = [[NSString alloc] initWithFormat:@""];
    self.expectedEventsField.text = [[NSString alloc] initWithFormat:@""];
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
}

//iPad
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if (theTextField == observedEventsField)
    {
        [observedEventsField resignFirstResponder];
        [expectedEventsField becomeFirstResponder];
    }
    else if (theTextField == expectedEventsField)
    {
        //[observedEventsField resignFirstResponder];
        [expectedEventsField resignFirstResponder];
    }
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
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:scrollViewFrame];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setFrame:CGRectMake(0, [self.view frame].size.height - 400.0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:1];
                
                [self.subView1 setFrame:CGRectMake(166, 35, 437, 293)];
                [self.subView2 setFrame:CGRectMake(102, 250, 565, 356)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView0 setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
                [self.lowerNavigationBar setFrame:CGRectMake(0, -4, self.view.frame.size.width, 44)];
                [fadingColorView setFrame:CGRectMake(0, self.view.frame.size.height - 400.0, [self.view frame].size.width, 400.0)];
                [fadingColorView0 setAlpha:0];
                
                [self.subView1 setFrame:CGRectMake(0, 55, 437, 293)];
                [self.subView2 setFrame:CGRectMake(self.view.frame.size.width - 565, 25, 565, 356)];
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
                [phoneInputsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 109)];
                [phoneResultsView setFrame:CGRectMake(18, 109, 277, 300)];
                [fadingColorView setFrame:CGRectMake(0, [self.view frame].size.height / 2.0, [self.view frame].size.width, self.view.frame.size.height / 2.0)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (self.view.frame.size.width > 2.0 * phoneResultsView.frame.size.width)
                {
                    [phoneInputsView setFrame:CGRectMake(self.view.frame.size.width  / 2.0 - phoneResultsView.frame.size.width, 0, self.view.frame.size.height, 109)];
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width  / 2.0, 0, 277, 300)];
                }
                else
                {
                    [phoneInputsView setFrame:CGRectMake(1.0 - self.phoneObservedEventsLabel.frame.origin.x, 0, self.view.frame.size.height, 109)];
                    [phoneResultsView setFrame:CGRectMake(self.view.frame.size.width - 276, 0, 277, 300)];
                }
                [fadingColorView setFrame:CGRectMake(0, [self.view frame].size.height / 2.0, [self.view frame].size.width, self.view.frame.size.height / 2.0)];
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
