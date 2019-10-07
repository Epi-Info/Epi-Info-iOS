//
//  AnalysisViewController.m
//  EpiInfo
//
//  Created by John Copeland on 3/15/13.
//

#import "AnalysisViewController.h"
#include <stdlib.h>

@interface AnalysisViewController ()
@property (nonatomic, weak) IBOutlet EpiInfoScrollView *epiInfoScrollView;
@end

@implementation AnalysisViewController

- (NSString *)dataSourceName
{
    return dataSourceName;
}

- (void)setWorkingDataObject:(AnalysisDataObject *)wdo
{
    workingDataObject = wdo;
}
- (void)workingDataSetWithWhereClause:(NSString *)whereClause
{
    [sqlData makeSQLiteWorkingTableWithWhereClause:whereClause];
    [dataSourceLabel setText:[NSString stringWithFormat:@"%@\n(%d/%d Records)", [[[dataSourceLabel text] componentsSeparatedByString:@"\n"] objectAtIndex:0], [sqlData workingTableSize], [sqlData fullTableSize]]];
}
- (NSString *)workingDatasetWhereClause
{
    return [workingDataObject whereClause];
}
- (AnalysisDataObject *)fullDataObject
{
    return fullDataObject;
}

- (NSArray *)getSQLiteColumnNames
{
    return sqlData.columnNamesWorking;
}
- (NSArray *)getSQLiteColumnTypes
{
    return sqlData.dataTypesWorking;
}
- (NSDictionary *)getWorkingColumnNames
{
    return workingDataObject.columnNames;
}
- (NSDictionary *)getWorkingColumnTypes
{
    return workingDataObject.dataTypes;
}
- (NSDictionary *)getWorkingYesNo
{
    return workingDataObject.isYesNo;
}
- (NSDictionary *)getWorkingTrueFalse
{
    return workingDataObject.isTrueFalse;
}
- (NSDictionary *)getWorkingOneZero
{
    return workingDataObject.isOneZero;
}
- (NSDictionary *)getWorkingBinary
{
    return workingDataObject.isBinary;
}
- (FrequencyObject *)getFrequencyObjectForVariable:(NSString *)variableName
{
    return [[FrequencyObject alloc] initWithAnalysisDataObject:workingDataObject AndVariable:variableName AndIncludeMissing:NO];
}

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)portraitOrientation
{
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:@""];
    dataSourceName = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.epiInfoScrollView setFrame:CGRectMake(0, 0, 768, 1024)];
        
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
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.epiInfoScrollView.frame.size.width, self.epiInfoScrollView.frame.size.height)];
        
        //Add the Analyze Data Label
        analyzeDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -32, self.view.frame.size.width, self.view.frame.size.height - 100)];
        [analyzeDataLabel setText:@"Analyze Data"];
        [analyzeDataLabel setTextAlignment:NSTextAlignmentCenter];
        [analyzeDataLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [analyzeDataLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [analyzeDataLabel setNumberOfLines:0];
        [analyzeDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:68.0]];
        [self.view addSubview:analyzeDataLabel];
        
        //Put subviews on the zooming view
        for (UIView *view in self.view.subviews)
        {
            if (![view isKindOfClass:[UIScrollView class]])
            {
                [zoomingView addSubview:view];
                //Remove all struts and springs
                [view setAutoresizingMask:UIViewAutoresizingNone];
            }
        }
        //Put the zooming view on the scroll view
        [self.epiInfoScrollView addSubview:zoomingView];

        //Add the setDataSource button
        setDataSource = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [setDataSource setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [setDataSource setTitle:@"Set Data Source" forState:UIControlStateNormal];
        [setDataSource setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [setDataSource setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [setDataSource addTarget:self action:@selector(selectDataType) forControlEvents:UIControlEventTouchUpInside];
        dataSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(setDataSource.frame.size.width / 2.0, 0, setDataSource.frame.size.width / 2.0, 50)];
        [dataSourceLabel setBackgroundColor:[UIColor clearColor]];
        [dataSourceLabel setTextColor:[UIColor whiteColor]];
        [dataSourceLabel setTextAlignment:NSTextAlignmentCenter];
        [dataSourceLabel setFont:[UIFont systemFontOfSize:14.0]];
        [dataSourceLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [dataSourceLabel setNumberOfLines:0];
        [setDataSource addSubview:dataSourceLabel];
        dataSourceBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 49, setDataSource.frame.size.width, 1)];
        [dataSourceBorder setBackgroundColor:[UIColor blackColor]];
        [setDataSource addSubview:dataSourceBorder];
        [self.view addSubview:setDataSource];
        
        //Add the chooseAnalysis button
        chooseAnalysis = [[ChooseAnalysisButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        [chooseAnalysis setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [chooseAnalysis setTitle:@"Add Analysis" forState:UIControlStateNormal];
        [chooseAnalysis setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chooseAnalysis setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [chooseAnalysis addTarget:self action:@selector(showAnalysisList) forControlEvents:UIControlEventTouchUpInside];
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, chooseAnalysis.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [chooseAnalysis addSubview:topLineView];
        [self.view addSubview:chooseAnalysis];
        
        //Add the newVariablesButton
        newVariablesButton = [[NewVariablesButton alloc] initWithFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
        [newVariablesButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [newVariablesButton addTarget:self action:@selector(newVariablesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        UIView *newVariablesButtonTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
        [newVariablesButtonTopLine setBackgroundColor:[UIColor blackColor]];
        [newVariablesButton addSubview:newVariablesButtonTopLine];
        UIView *newVariablesButtonBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, newVariablesButton.frame.size.height - 1, 50, 1)];
        [newVariablesButtonBottomLine setBackgroundColor:[UIColor blackColor]];
        [newVariablesButton addSubview:newVariablesButtonBottomLine];
        UIView *newVariablesButtonSideLine = [[UIView alloc] initWithFrame:CGRectMake(newVariablesButton.frame.size.width - 1, 0, 1, newVariablesButton.frame.size.height)];
        [newVariablesButtonSideLine setBackgroundColor:[UIColor blackColor]];
        [newVariablesButton addSubview:newVariablesButtonSideLine];
        //        [self.view addSubview:newVariablesButton];
        UILabel *newVariablesButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, newVariablesButton.frame.size.height / 2 - 25, 50, 50)];
        [newVariablesButtonLabel setText:@"Add Variables"];
        [newVariablesButtonLabel setBackgroundColor:[UIColor clearColor]];
        [newVariablesButtonLabel setTextColor:[UIColor whiteColor]];
        [newVariablesButtonLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
        [newVariablesButton addSubview:newVariablesButtonLabel];
        [newVariablesButton.titleLabel removeFromSuperview];
        //Make the button invisible until the view is in place
        [newVariablesButton setAlpha:0];
        
        //Add the filterButton
        filterButton = [[FilterButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
        [filterButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [filterButton addTarget:self action:@selector(filterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        UIView *filterButtonTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
        [filterButtonTopLine setBackgroundColor:[UIColor blackColor]];
        [filterButton addSubview:filterButtonTopLine];
        UIView *filterButtonBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, filterButton.frame.size.height - 1, 50, 1)];
        [filterButtonBottomLine setBackgroundColor:[UIColor blackColor]];
        [filterButton addSubview:filterButtonBottomLine];
        UIView *filterButtonSideLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, filterButton.frame.size.height)];
        [filterButtonSideLine setBackgroundColor:[UIColor blackColor]];
        [filterButton addSubview:filterButtonSideLine];
        [self.view addSubview:filterButton];
        [filterButton setAlpha:0.0];
        UILabel *filterButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, filterButton.frame.size.height / 2 - 25, 50, 50)];
        [filterButtonLabel setText:@"Filter"];
        [filterButtonLabel setBackgroundColor:[UIColor clearColor]];
        [filterButtonLabel setTextColor:[UIColor whiteColor]];
        [filterButtonLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        [filterButton addSubview:filterButtonLabel];
        [filterButton.titleLabel removeFromSuperview];
        
        //initial set-up of analysis list
        availableAnalyses = 6.0;
        analysisList = [[AnalysisList alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50 * availableAnalyses)];
        [analysisList setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:analysisList];
        [analysisList setHidden:YES];
        //Add the cancel button to the list
        UIButton *cancelAnalysisList = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50)];
        [cancelAnalysisList setTitle:@"  Cancel" forState:UIControlStateNormal];
        [cancelAnalysisList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelAnalysisList setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [cancelAnalysisList setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [cancelAnalysisList addTarget:self action:@selector(cancelAnalysisListSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cancelAnalysisList.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [cancelAnalysisList addSubview:topLineView];
        [analysisList addSubview:cancelAnalysisList];
        //Add the frequency button to the list
        UIButton *doFrequencyAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, zoomingView.frame.size.width, 50)];
        [doFrequencyAnalysisButton setTitle:@"  Frequency" forState:UIControlStateNormal];
        [doFrequencyAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doFrequencyAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doFrequencyAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doFrequencyAnalysisButton addTarget:self action:@selector(frequencyAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doFrequencyAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doFrequencyAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doFrequencyAnalysisButton];
        //Add the tables button to the list
        UIButton *doTablesAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, zoomingView.frame.size.width, 50)];
        [doTablesAnalysisButton setTitle:@"  Tables (2x2, MxN)" forState:UIControlStateNormal];
        [doTablesAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doTablesAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doTablesAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doTablesAnalysisButton addTarget:self action:@selector(tablesAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doTablesAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doTablesAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doTablesAnalysisButton];
        //Add the means button to the list
        UIButton *doMeansAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, zoomingView.frame.size.width, 50)];
        [doMeansAnalysisButton setTitle:@"  Means" forState:UIControlStateNormal];
        [doMeansAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doMeansAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doMeansAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doMeansAnalysisButton addTarget:self action:@selector(meansAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doMeansAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doMeansAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doMeansAnalysisButton];
        //Add the linear button to the list
        UIButton *doLinearAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, zoomingView.frame.size.width, 50)];
        [doLinearAnalysisButton setTitle:@"  Linear Regression" forState:UIControlStateNormal];
        [doLinearAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doLinearAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doLinearAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doLinearAnalysisButton addTarget:self action:@selector(linearAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doLinearAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doLinearAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doLinearAnalysisButton];
        //Add the logistic button to the list
        UIButton *doLogisticAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 250, zoomingView.frame.size.width, 50)];
        [doLogisticAnalysisButton setTitle:@"  Logistic Regression" forState:UIControlStateNormal];
        [doLogisticAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doLogisticAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doLogisticAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doLogisticAnalysisButton addTarget:self action:@selector(logisticAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doLogisticAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doLogisticAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doLogisticAnalysisButton];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            BlurryView *blurryView = [BlurryView new];
            [blurryView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50 * availableAnalyses)];
            [analysisList addSubview:blurryView];
            //            [blurryView setBlurTintColor:[UIColor lightGrayColor]];
            [analysisList setBackgroundColor:[UIColor clearColor]];
            [analysisList sendSubviewToBack:blurryView];
        }
        
        //initial set-up of data source list and data type list and AWS SimpleDB schema list
        dataTypeList = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
        [dataTypeList setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:dataTypeList];
        schemaList = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
        [schemaList setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:schemaList];
        dataSourceList = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
        [dataSourceList setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:dataSourceList];
    }
    else
    {
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
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
                [self setEdgesForExtendedLayout:UIRectEdgeNone];
            [self.navigationController.navigationBar setTranslucent:NO];
        }
        fourInchPhone = (self.view.frame.size.height > 500);
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.epiInfoScrollView.frame.size.width, self.epiInfoScrollView.frame.size.height)];
        
        //Add the Analyze Data Label
        analyzeDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -32, self.view.frame.size.width, self.view.frame.size.height - 100)];
        [analyzeDataLabel setText:@"Analyze Data"];
        [analyzeDataLabel setTextAlignment:NSTextAlignmentCenter];
        [analyzeDataLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [analyzeDataLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [analyzeDataLabel setNumberOfLines:0];
        [analyzeDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:68.0]];
        [self.view addSubview:analyzeDataLabel];
        
        //Put subviews on the zooming view
        for (UIView *view in self.view.subviews)
        {
            if (![view isKindOfClass:[UIScrollView class]])
            {
                [zoomingView addSubview:view];
                //Remove all struts and springs
                [view setAutoresizingMask:UIViewAutoresizingNone];
            }
        }
        //Put the zooming view on the scroll view
        [self.epiInfoScrollView addSubview:zoomingView];
        
        //Add the setDataSource button
        setDataSource = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [setDataSource setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [setDataSource setTitle:@"  Set Data Source" forState:UIControlStateNormal];
        [setDataSource setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [setDataSource setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [setDataSource addTarget:self action:@selector(selectDataType) forControlEvents:UIControlEventTouchUpInside];
        dataSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(setDataSource.frame.size.width / 2.0, 0, setDataSource.frame.size.width / 2.0, 50)];
        [dataSourceLabel setBackgroundColor:[UIColor clearColor]];
        [dataSourceLabel setTextColor:[UIColor whiteColor]];
        [dataSourceLabel setTextAlignment:NSTextAlignmentLeft];
        [dataSourceLabel setFont:[UIFont systemFontOfSize:14.0]];
        [dataSourceLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [dataSourceLabel setNumberOfLines:0];
        [setDataSource addSubview:dataSourceLabel];
        dataSourceBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 49, setDataSource.frame.size.width, 1)];
        [dataSourceBorder setBackgroundColor:[UIColor blackColor]];
        [setDataSource addSubview:dataSourceBorder];
        [self.view addSubview:setDataSource];
        
        //Add the chooseAnalysis button
        chooseAnalysis = [[ChooseAnalysisButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        [chooseAnalysis setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [chooseAnalysis setTitle:@"Add Analysis" forState:UIControlStateNormal];
        [chooseAnalysis setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chooseAnalysis setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [chooseAnalysis addTarget:self action:@selector(showAnalysisList) forControlEvents:UIControlEventTouchUpInside];
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, chooseAnalysis.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [chooseAnalysis addSubview:topLineView];
        [self.view addSubview:chooseAnalysis];
        
        //Add the newVariablesButton
        newVariablesButton = [[NewVariablesButton alloc] initWithFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
        [newVariablesButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [newVariablesButton addTarget:self action:@selector(newVariablesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        UIView *newVariablesButtonTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
        [newVariablesButtonTopLine setBackgroundColor:[UIColor blackColor]];
        [newVariablesButton addSubview:newVariablesButtonTopLine];
        UIView *newVariablesButtonBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, newVariablesButton.frame.size.height - 1, 50, 1)];
        [newVariablesButtonBottomLine setBackgroundColor:[UIColor blackColor]];
        [newVariablesButton addSubview:newVariablesButtonBottomLine];
        UIView *newVariablesButtonSideLine = [[UIView alloc] initWithFrame:CGRectMake(newVariablesButton.frame.size.width - 1, 0, 1, newVariablesButton.frame.size.height)];
        [newVariablesButtonSideLine setBackgroundColor:[UIColor blackColor]];
        [newVariablesButton addSubview:newVariablesButtonSideLine];
//        [self.view addSubview:newVariablesButton];
        UILabel *newVariablesButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, newVariablesButton.frame.size.height / 2 - 25, 50, 50)];
        [newVariablesButtonLabel setText:@"Add Variables"];
        [newVariablesButtonLabel setBackgroundColor:[UIColor clearColor]];
        [newVariablesButtonLabel setTextColor:[UIColor whiteColor]];
        [newVariablesButtonLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
        [newVariablesButton addSubview:newVariablesButtonLabel];
        [newVariablesButton.titleLabel removeFromSuperview];
        //Make the button invisible until the view is in place
        [newVariablesButton setAlpha:0];
        
        //Add the filterButton
        filterButton = [[FilterButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
        [filterButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [filterButton addTarget:self action:@selector(filterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        UIView *filterButtonTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
        [filterButtonTopLine setBackgroundColor:[UIColor blackColor]];
        [filterButton addSubview:filterButtonTopLine];
        UIView *filterButtonBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, filterButton.frame.size.height - 1, 50, 1)];
        [filterButtonBottomLine setBackgroundColor:[UIColor blackColor]];
        [filterButton addSubview:filterButtonBottomLine];
        UIView *filterButtonSideLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, filterButton.frame.size.height)];
        [filterButtonSideLine setBackgroundColor:[UIColor blackColor]];
        [filterButton addSubview:filterButtonSideLine];
        [self.view addSubview:filterButton];
        [filterButton setAlpha:0.0];
        UILabel *filterButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, filterButton.frame.size.height / 2 - 25, 50, 50)];
        [filterButtonLabel setText:@"Filter"];
        [filterButtonLabel setBackgroundColor:[UIColor clearColor]];
        [filterButtonLabel setTextColor:[UIColor whiteColor]];
        [filterButtonLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        [filterButton addSubview:filterButtonLabel];
        [filterButton.titleLabel removeFromSuperview];
        
        //initial set-up of analysis list
        availableAnalyses = 6.0;
        analysisList = [[AnalysisList alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50 * availableAnalyses)];
        [analysisList setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:analysisList];
        [analysisList setHidden:YES];
        //Add the cancel button to the list
        UIButton *cancelAnalysisList = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50)];
        [cancelAnalysisList setTitle:@"  Cancel" forState:UIControlStateNormal];
        [cancelAnalysisList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelAnalysisList setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [cancelAnalysisList setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [cancelAnalysisList addTarget:self action:@selector(cancelAnalysisListSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cancelAnalysisList.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [cancelAnalysisList addSubview:topLineView];
        [analysisList addSubview:cancelAnalysisList];
        //Add the frequency button to the list
        UIButton *doFrequencyAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, zoomingView.frame.size.width, 50)];
        [doFrequencyAnalysisButton setTitle:@"  Frequency" forState:UIControlStateNormal];
        [doFrequencyAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doFrequencyAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doFrequencyAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doFrequencyAnalysisButton addTarget:self action:@selector(frequencyAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doFrequencyAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doFrequencyAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doFrequencyAnalysisButton];
        //Add the tables button to the list
        UIButton *doTablesAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, zoomingView.frame.size.width, 50)];
        [doTablesAnalysisButton setTitle:@"  Tables (2x2, MxN)" forState:UIControlStateNormal];
        [doTablesAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doTablesAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doTablesAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doTablesAnalysisButton addTarget:self action:@selector(tablesAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doTablesAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doTablesAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doTablesAnalysisButton];
        //Add the means button to the list
        UIButton *doMeansAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, zoomingView.frame.size.width, 50)];
        [doMeansAnalysisButton setTitle:@"  Means" forState:UIControlStateNormal];
        [doMeansAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doMeansAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doMeansAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doMeansAnalysisButton addTarget:self action:@selector(meansAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doMeansAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doMeansAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doMeansAnalysisButton];
        //Add the linear button to the list
        UIButton *doLinearAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, zoomingView.frame.size.width, 50)];
        [doLinearAnalysisButton setTitle:@"  Linear Regression" forState:UIControlStateNormal];
        [doLinearAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doLinearAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doLinearAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doLinearAnalysisButton addTarget:self action:@selector(linearAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doLinearAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doLinearAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doLinearAnalysisButton];
        //Add the logistic button to the list
        UIButton *doLogisticAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 250, zoomingView.frame.size.width, 50)];
        [doLogisticAnalysisButton setTitle:@"  Logistic Regression" forState:UIControlStateNormal];
        [doLogisticAnalysisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doLogisticAnalysisButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [doLogisticAnalysisButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [doLogisticAnalysisButton addTarget:self action:@selector(logisticAnalysisSelected) forControlEvents:UIControlEventTouchUpInside];
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doLogisticAnalysisButton.frame.size.width, 1)];
        [topLineView setBackgroundColor:[UIColor blackColor]];
        [doLogisticAnalysisButton addSubview:topLineView];
        [analysisList addSubview:doLogisticAnalysisButton];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            BlurryView *blurryView = [BlurryView new];
            [blurryView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50 * availableAnalyses)];
            [analysisList addSubview:blurryView];
//            [blurryView setBlurTintColor:[UIColor lightGrayColor]];
            [analysisList setBackgroundColor:[UIColor clearColor]];
            [analysisList sendSubviewToBack:blurryView];
        }
        
        //initial set-up of data source list and data type list and AWS SimpleDB schema list
        dataTypeList = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
        [dataTypeList setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:dataTypeList];
        schemaList = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
        [schemaList setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:schemaList];
        dataSourceList = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
        [dataSourceList setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:dataSourceList];
        
        if (fourInchPhone)
        {
            initialContentSize = CGSizeMake(320, 504);
            initialLandscapeContentSize = CGSizeMake(568, 268);
        }
        else
        {
            initialContentSize = CGSizeMake(320, 416);
            initialLandscapeContentSize = CGSizeMake(480, 268);
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [setDataSource setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
                [dataSourceLabel setFrame:CGRectMake(setDataSource.frame.size.width / 2.0, 0, setDataSource.frame.size.width / 2.0, 50)];
                [dataSourceBorder setFrame:CGRectMake(0, 49, setDataSource.frame.size.width, 1)];
                [analyzeDataLabel setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
                [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
                [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
                //newVariableButton starts out invisible until view is in place
                [newVariablesButton setAlpha:1];
                } completion:^(BOOL finished){
                    [filterButton setAlpha:0.0];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [setDataSource setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
                [dataSourceLabel setFrame:CGRectMake(setDataSource.frame.size.width / 2.0, 0, setDataSource.frame.size.width / 2.0, 50)];
                [dataSourceBorder setFrame:CGRectMake(0, 49, setDataSource.frame.size.width, 1)];
//                [analyzeDataLabel setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
                [filterButton setFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
                [newVariablesButton setFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
                //newVariableButton starts out invisible until view is in place
                [newVariablesButton setAlpha:1];
                } completion:^(BOOL finished){
                    [filterButton setAlpha:1.0];
            }];
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.epiInfoScrollView setContentSize:zoomingView.frame.size];
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [setDataSource setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
                [dataSourceLabel setFrame:CGRectMake(setDataSource.frame.size.width / 2.0, 0, setDataSource.frame.size.width / 2.0, 50)];
                [dataSourceBorder setFrame:CGRectMake(0, 49, setDataSource.frame.size.width, 1)];
                [analyzeDataLabel setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
                [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
                [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
                //newVariableButton starts out invisible until view is in place
                [newVariablesButton setAlpha:1];
                } completion:^(BOOL finished){
                    [filterButton setAlpha:0.0];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [setDataSource setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
                [dataSourceLabel setFrame:CGRectMake(setDataSource.frame.size.width / 2.0, 0, setDataSource.frame.size.width / 2.0, 50)];
                [dataSourceBorder setFrame:CGRectMake(0, 49, setDataSource.frame.size.width, 1)];
//                [analyzeDataLabel setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
                [filterButton setFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
                [newVariablesButton setFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
                //newVariableButton starts out invisible until view is in place
                [newVariablesButton setAlpha:1];
            } completion:^(BOOL finished){
                [filterButton setAlpha:1.0];
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/AnalysisPad.png" atomically:YES];
//    To here
}

- (void)setDataSourceEnabled:(BOOL)isEnabled
{
    [setDataSource setEnabled:isEnabled];
}

- (void)newVariablesButtonPressed
{
    newVariableswView = [[NewVariablesView alloc] initWithViewController:self AndSQLiteData:sqlData];
    [self.view addSubview:newVariableswView];
}

- (void)filterButtonPressed
{
    filterView = [[AnalysisFilterView alloc] initWithViewController:self];
    [self.view addSubview:filterView];
    if (workingDataObject.listOfFilters)
        if ([workingDataObject.listOfFilters count] > 0)
        {
            [filterView setListOfValues:workingDataObject.listOfFilters];
        }
}

- (void)selectDataType
{
    //User tapped the Select Data Source button
    
    //Temporarily disable the Select Data Source button
    [setDataSource setEnabled:NO];
    
    //Disable the Add Analysis button
    [chooseAnalysis setEnabled:NO];
    [filterButton setEnabled:NO];
    [newVariablesButton setEnabled:NO];
    
    //Remove any existing instances of dataTypeList
    [dataTypeList removeFromSuperview];
    dataTypeList = nil;
    
    //Re-allociate and instantiate dataTypeList
    dataTypeList = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
    [dataTypeList setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:dataTypeList];

    //Remove any analysis views from the superview and from memory
    if (fv)
        [fv xButtonPressed];
    if (tv)
        [tv xButtonPressed];
    
    //One data type plus a cancel button
    numberOfDataTypes = 3.0;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50)];
    [button setTitle:@"  Table from Device" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button addTarget:self action:@selector(lookupDataSources) forControlEvents:UIControlEventTouchUpInside];
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
    [bottomLineView setBackgroundColor:[UIColor blackColor]];
    [button addSubview:bottomLineView];
    [dataTypeList addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, zoomingView.frame.size.width, 50)];
    [button setTitle:@"  Use SQL Tool" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button addTarget:self action:@selector(loadSqlTool:) forControlEvents:UIControlEventTouchUpInside];
    bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
    [bottomLineView setBackgroundColor:[UIColor blackColor]];
    [button addSubview:bottomLineView];
    [dataTypeList addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, zoomingView.frame.size.width, 50)];
    [button setTitle:@"  AWS SimpleDB Table" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button addTarget:self action:@selector(lookupSimpleDBSources) forControlEvents:UIControlEventTouchUpInside];
    bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
    [bottomLineView setBackgroundColor:[UIColor blackColor]];
    [button addSubview:bottomLineView];
    //    [dataTypeList addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, zoomingView.frame.size.width, 50)];
    [button setTitle:@"  Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button addTarget:self action:@selector(cancelDataTypeSelection) forControlEvents:UIControlEventTouchUpInside];
    bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
    [bottomLineView setBackgroundColor:[UIColor blackColor]];
    [button addSubview:bottomLineView];
    [dataTypeList addSubview:button];
    
    [dataTypeList setFrame:CGRectMake(0, -50.0 * numberOfDataTypes, zoomingView.frame.size.width, 50.0 * numberOfDataTypes)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        BlurryView *blurryView = [BlurryView new];
        [blurryView setFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50.0 * numberOfDataTypes)];
        [dataTypeList addSubview:blurryView];
//        [blurryView setBlurTintColor:[UIColor lightGrayColor]];
        [dataTypeList setBackgroundColor:[UIColor clearColor]];
        [dataTypeList sendSubviewToBack:blurryView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [dataTypeList setFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50.0 * numberOfDataTypes)];
    }];
}

- (void)lookupDataSources
{
    //User selected "File from Device" from dataTypeList
    
    [fv removeFromSuperview];
    fv = nil;
    [tv removeFromSuperview];
    tv = nil;
    
    //Remove any existing instances of dataSourceList
    [dataSourceList removeFromSuperview];
    dataSourceList = nil;
    
    //Re-allocate and instantiate dataSourceList
    dataSourceList = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
    [dataSourceList setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:dataSourceList];

    //Move dataTypeList off of the screen
    [UIView animateWithDuration:0.3 animations:^{
        [dataTypeList setFrame:CGRectMake(0, -50.0 * numberOfDataTypes, zoomingView.frame.size.width, 50.0 * numberOfDataTypes)];
    }];
    
    //Get the files stored on the device and add a button to dataSourceList for each file
    //Then add a cancel button to dataSourceList
//    NSDirectoryEnumerator *d = [self getFilesInDocumentsDirectory];
    
    // Get data tables from SQLite database instead of Documents Directory
    NSMutableArray *arrayOfDatasets = [[NSMutableArray alloc] init];
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
        {
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
            
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = [NSString stringWithFormat:@"select count(name), name as n from sqlite_master where name <> '__sqlite_recall_table__' group by name order by name"];
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        [arrayOfDatasets addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)]];
                        //                    NSLog(@"%s:  %d", sqlite3_column_text(statement, 1), sqlite3_column_int(statement, 0));
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
        }
    }
    
    numberOfFiles = 0;
    for (NSString *filename in arrayOfDatasets)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50.0 * numberOfFiles, zoomingView.frame.size.width, 50)];
        [button setTitle:[NSString stringWithFormat:@"  %@", [filename substringToIndex:filename.length - 0]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button addTarget:self action:@selector(setDataSource:) forControlEvents:UIControlEventTouchUpInside];
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
        [bottomLineView setBackgroundColor:[UIColor blackColor]];
        [button addSubview:bottomLineView];
        UIButton *deleteDatasetButton = [[UIButton alloc] initWithFrame:CGRectMake(button.frame.size.width - 35, 10, 30, 30)];
        [deleteDatasetButton setBackgroundColor:[UIColor clearColor]];
        [deleteDatasetButton setImage:[UIImage imageNamed:@"RoundDeleteButton60.png"] forState:UIControlStateNormal];
        [deleteDatasetButton addTarget:self action:@selector(deleteDatasetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:deleteDatasetButton];
        [dataSourceList addSubview:button];
        numberOfFiles++;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50.0 * numberOfFiles, zoomingView.frame.size.width, 50)];
    [button setTitle:@"  Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button addTarget:self action:@selector(cancelDataSourceSelection) forControlEvents:UIControlEventTouchUpInside];
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
    [bottomLineView setBackgroundColor:[UIColor blackColor]];
    [button addSubview:bottomLineView];
    [dataSourceList addSubview:button];
    
    //Set the dataSourceList frame above the top of the screen
    [dataSourceList setFrame:CGRectMake(0, -50.0 * (numberOfFiles + 1), zoomingView.frame.size.width, 50.0 * (numberOfFiles + 1))];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        BlurryView *blurryView = [BlurryView new];
        [blurryView setFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50.0 * (numberOfFiles + 1))];
        [dataSourceList addSubview:blurryView];
//        [blurryView setBlurTintColor:[UIColor lightGrayColor]];
        [dataSourceList setBackgroundColor:[UIColor clearColor]];
        [dataSourceList sendSubviewToBack:blurryView];
    }
    
    //Move the dataSourceList into view
    [UIView animateWithDuration:0.3 delay:0.3 options:nil animations:^{
        float menuheight = self.view.frame.size.height;
        [dataSourceList setFrame:CGRectMake(0, 0, zoomingView.frame.size.width, menuheight)];
    } completion:^(BOOL finished){
        [dataSourceList setContentSize:CGSizeMake(zoomingView.frame.size.width, 50.0 * (numberOfFiles + 1))];
    }];
}

- (void)loadSqlTool:(UIButton *)sender
{
    
    //Move dataTypeList off of the screen
    [self cancelDataTypeSelection];
    
    SQLTool *sqlTool = [[SQLTool alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height + 50)];
    [self.view addSubview:sqlTool];
    
    [UIView animateWithDuration:0.3 delay:0.3 options:nil animations:^{
        [sqlTool setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 60, self.view.frame.size.width, self.view.frame.size.height + 60)];
    }completion:nil];
}

//- (void)lookupSimpleDBSources
//{
//    //User selected "AWS SimpleDB Table" from dataTypeList
//
//    [fv removeFromSuperview];
//    fv = nil;
//    [tv removeFromSuperview];
//    tv = nil;
//
//    //Remove any existing instances of schemaList
//    [schemaList removeFromSuperview];
//    schemaList = nil;
//    
//    //Re-allocate and instantiate schemaList
//    schemaList = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
//    [schemaList setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:schemaList];
//    
//    //Move dataTypeList off of the screen
//    [UIView animateWithDuration:0.3 animations:^{
//        [dataTypeList setFrame:CGRectMake(0, -50.0 * numberOfDataTypes, zoomingView.frame.size.width, 50.0 * numberOfDataTypes)];
//    }];
//
//    //Get the available SimpleDB schemas from AWSSimpleDBConnectionInfo class and loop through and add
//    //a button to schemaList for each one; add a Cancel button to the end
//    schema = 0;
//    for (NSString *conn in [AWSSimpleDBConnectionInfo connections])
//    {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50.0 * schema, zoomingView.frame.size.width, 50)];
//        [button setTitle:[NSString stringWithFormat:@"  %@", conn] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [button addTarget:self action:@selector(lookupSimpleDBTable:) forControlEvents:UIControlEventTouchUpInside];
//        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
//        [bottomLineView setBackgroundColor:[UIColor blackColor]];
//        [button addSubview:bottomLineView];
//        [schemaList addSubview:button];
//        schema++;
//    }
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50.0 * schema, zoomingView.frame.size.width, 50)];
//    [button setTitle:@"  Add/Remove" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [button addTarget:self action:@selector(addSimpleDVSchema) forControlEvents:UIControlEventTouchUpInside];
//    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
//    [bottomLineView setBackgroundColor:[UIColor blackColor]];
//    [button addSubview:bottomLineView];
//    [schemaList addSubview:button];
//    
//    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50.0 * (schema + 1), zoomingView.frame.size.width, 50)];
//    [button setTitle:@"  Cancel" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [button addTarget:self action:@selector(cancelSimpleDBSchemaSelection) forControlEvents:UIControlEventTouchUpInside];
//    bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
//    [bottomLineView setBackgroundColor:[UIColor blackColor]];
//    [button addSubview:bottomLineView];
//    [schemaList addSubview:button];
//    
//    //Set the schemaList frame above the top of the screen
//    [schemaList setFrame:CGRectMake(0, -50.0 * (schema + 2), zoomingView.frame.size.width, 50.0 * (schema + 2))];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        BlurryView *blurryView = [BlurryView new];
//        [blurryView setFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50.0 * (schema + 2))];
//        [schemaList addSubview:blurryView];
//        [blurryView setBlurTintColor:[UIColor lightGrayColor]];
//        [schemaList setBackgroundColor:[UIColor clearColor]];
//        [schemaList sendSubviewToBack:blurryView];
//    }
//    
//    //Move the schemaList into view
//    [UIView animateWithDuration:0.3 delay:0.3 options:nil animations:^{
//        [schemaList setFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50.0 * (schema + 2))];
//    }completion:nil];
//}

//- (void)lookupSimpleDBTable:(id)sender
//{
//    //User selected a schema
//    
//    //Remove any existing instances of dataSourceList
//    [dataSourceList removeFromSuperview];
//    dataSourceList = nil;
//    
//    //Re-allocate and instantiate dataSourceList
//    dataSourceList = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
//    [dataSourceList setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:dataSourceList];
//    
//    //Move schemaList off of the screen
//    [UIView animateWithDuration:0.3 animations:^{
//        [schemaList setFrame:CGRectMake(0, -50.0 * (schema + 2), zoomingView.frame.size.width, 50.0 * (schema + 2))];
//    }];
//    
//    //Request dispatch queue
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //Run the queue in the background
//    dispatch_async(queue, ^{
//        
//        //Start the activity indicator in the main thread
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        });
//        
//        //Allocate and instantiate the AmazonSimpleDBClient by
//        //sending the button's text to AWSSimpleDBConnectionInfo and
//        //getting the appropriate key values
//        sdb = [[AmazonSimpleDBClient alloc] initWithAccessKey:[[AWSSimpleDBConnectionInfo keys:[[[(UIButton *)sender titleLabel] text] substringFromIndex:2]] objectAtIndex:0] withSecretKey:[[AWSSimpleDBConnectionInfo keys:[[[(UIButton *)sender titleLabel] text] substringFromIndex:2]] objectAtIndex:1]];
//        
//        //Tell sdb which region to use?
//        sdb.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
//        
//        //Send ListDomainsRequest to selected SimpleDB schema
//        SimpleDBListDomainsRequest  *listDomainsRequest  = [[SimpleDBListDomainsRequest alloc] init];
//        //Get the response
//        SimpleDBListDomainsResponse *listDomainsResponse = [sdb listDomains:listDomainsRequest];
//        if(listDomainsResponse.error != nil)
//        {
//            NSLog(@"Error: %@", listDomainsResponse.error);
//        }
//        
//        //Allocate and initialize SimpleDBDomains NSMutableArray if necessary
//        //Empty it if it already exists
//        if (SimpleDBDomains == nil) {
//            SimpleDBDomains = [[NSMutableArray alloc] initWithCapacity:[listDomainsResponse.domainNames count]];
//        }
//        else {
//            [SimpleDBDomains removeAllObjects];
//        }
//        
//        //Fill SimpldDBDomains NSMutableArray with list of tables (domains)
//        for (NSString *name in listDomainsResponse.domainNames)
//            [SimpleDBDomains addObject:name];
//        
//        //Return to the main thread after completion of the above tasks
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //Hide the ActivityIndicator
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            
//            //For each table in the NSMutableArray, add a button to dataSourceList
//            //Add a cancel button at the end
//            numberOfFiles = 0;
//            for (NSString *filename in SimpleDBDomains)
//            {
//                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50.0 * numberOfFiles, zoomingView.frame.size.width, 50)];
//                [button setTitle:[NSString stringWithFormat:@"  %@", filename] forState:UIControlStateNormal];
//                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//                [button addTarget:self action:@selector(setDataSourceFromSimpleDB:) forControlEvents:UIControlEventTouchUpInside];
//                UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
//                [bottomLineView setBackgroundColor:[UIColor blackColor]];
//                [button addSubview:bottomLineView];
//                [dataSourceList addSubview:button];
//                numberOfFiles++;
//            }
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50.0 * numberOfFiles, zoomingView.frame.size.width, 50)];
//            [button setTitle:@"  Cancel" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//            UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.frame.size.width, 1)];
//            [bottomLineView setBackgroundColor:[UIColor blackColor]];
//            [button addSubview:bottomLineView];
//            [button addTarget:self action:@selector(cancelDataSourceSelection) forControlEvents:UIControlEventTouchUpInside];
//            [dataSourceList addSubview:button];
//            
//            //Place the dataSourceList above the top of the screen
//            [dataSourceList setFrame:CGRectMake(0, -50.0 * (numberOfFiles + 1), zoomingView.frame.size.width, 50.0 * (numberOfFiles + 1))];
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//            {
//                BlurryView *blurryView = [BlurryView new];
//                [blurryView setFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50.0 * (numberOfFiles + 1))];
//                [dataSourceList addSubview:blurryView];
//                [blurryView setBlurTintColor:[UIColor lightGrayColor]];
//                [dataSourceList setBackgroundColor:[UIColor clearColor]];
//                [dataSourceList sendSubviewToBack:blurryView];
//            }
//            
//            //Move the dataSourceList into view
//            [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
//                [dataSourceList setFrame:CGRectMake(0, 0, zoomingView.frame.size.width, 50.0 * (numberOfFiles + 1))];
//            }completion:nil];
//        });
//    });
//}

- (void)cancelDataTypeSelection
{
    //User pressed Cancel on dataTypeList (the list with Local File, AWS SimpleDB(, etc.))
    [fv removeFromSuperview];
    fv = nil;
    [tv removeFromSuperview];
    tv = nil;
    [setDataSource setEnabled:YES];
    [chooseAnalysis setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [dataTypeList setFrame:CGRectMake(0, -50.0 * numberOfDataTypes, zoomingView.frame.size.width, 50.0 * numberOfDataTypes)];
    }];
}

- (void)cancelDataSourceSelection
{
    //User pressed Cancel on dataSourceList (the list of either local files or AWS SimpleDB tables)
    [setDataSource setEnabled:YES];
    [chooseAnalysis setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [dataSourceList setFrame:CGRectMake(0, -50.0 * (numberOfFiles + 1), zoomingView.frame.size.width, 50.0 * (numberOfFiles + 1))];
    }];
}

- (void)cancelSimpleDBSchemaSelection
{
    //User pressed Cancel on schemaList (the list of AWS SimpleDB schema)
    [setDataSource setEnabled:YES];
    [chooseAnalysis setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [schemaList setFrame:CGRectMake(0, -50.0 * (schema + 2), zoomingView.frame.size.width, 50.0 * (schema + 2))];
    }];
}

//- (void)addSimpleDVSchema
//{
//    //User pressed Add on schemaList (the list of AWS SimpleDB schema
//    [UIView animateWithDuration:0.3 animations:^{
//        [schemaList setFrame:CGRectMake(0, -50.0 * (schema + 2), zoomingView.frame.size.width, 50.0 * (schema + 2))];
//    }];
//    AddAWSSimpleDBSchema *addOne = [[AddAWSSimpleDBSchema alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) AndViewController:self];
//    [self.view addSubview:addOne];
//}

- (void)showAnalysisList
{
    //Remove any analysis views from the superview and from memory
    [fv removeFromSuperview];
    fv = nil;
    [tv removeFromSuperview];
    tv = nil;

    //Disable the other three buttons
    [setDataSource setEnabled:NO];
    [filterButton setEnabled:NO];
    [newVariablesButton setEnabled:NO];
    
    //Un-hide the analysisList
    [analysisList setHidden:NO];
    
    
    //Move the analysisList back into view
    [UIView animateWithDuration:0.3 animations:^{
        [analysisList setFrame:CGRectMake(0, self.view.frame.size.height - 50 * availableAnalyses, self.view.frame.size.width, 50 * availableAnalyses)];
    }];
}

- (void)cancelAnalysisListSelected
{
    //User selected Cancel from the analysisList
    
    //Enable the other three buttons
    [setDataSource setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    
    //Move analysisList below the bottom of the screen
    [UIView animateWithDuration:0.3 animations:^{
        [analysisList setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50 * availableAnalyses)];
    }];
    //Wait 0.3 seconds and then set the analysisList to hidden
    [self performSelector:@selector(hideAnalysisList) withObject:nil afterDelay:0.3];
}

- (void)frequencyAnalysisSelected
{
    //User selected Frequency from analysisList
    
    //Enable the other three buttons
    [setDataSource setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    
    //Move analysisList below the bottom of the screen
    [UIView animateWithDuration:0.3 animations:^{
        [analysisList setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50 * availableAnalyses)];
    }];
    //Wait 0.3 seconds and then set the analysisList to hidden
    [self performSelector:@selector(hideAnalysisList) withObject:nil afterDelay:0.3];
    
    //Allocate and initialize the FrequencyView, color it white, and add it to the zoomingView
    //FrequencyView is initially in the center of the screen and size 1 pixel by 1 pixel
    fv = [[FrequencyView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0, 1, 1) AndSQLiteData:sqlData AndViewController:self];
//    fv = [[FrequencyView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0, 1, 1) AndDataSource:workingDataObject AndViewController:self];
    [fv setBackgroundColor:[UIColor whiteColor]];
    [zoomingView addSubview:fv];
    
    //Animate the FrequencyView to the proper size
    //Move the chooseAnalysisButton off the bottom of the screen
    [UIView animateWithDuration:0.5 animations:^{
        [fv setFrame:CGRectMake(0, 50, zoomingView.frame.size.width, zoomingView.frame.size.height - 50)];
        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
            [newVariablesButton setFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
        }
        else
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
            [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
        }
    }];
}

- (void)tablesAnalysisSelected
{
    //User selected 2x2/MxN Table from analysisList
    
    //Enable the other three buttons
    [setDataSource setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    
    //Move analysisList below the bottom of the screen
    [UIView animateWithDuration:0.3 animations:^{
        [analysisList setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50 * availableAnalyses)];
    }];
    //Wait 0.3 seconds and then set the analysisList to hidden
    [self performSelector:@selector(hideAnalysisList) withObject:nil afterDelay:0.3];
    
    //Allocate and initialize the TablesView, color it white, and add it to the zoomingView
    //TablesView is initially in the center of the screen and size 1 pixel by 1 pixel
    tv = [[TablesView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0, 1, 1) AndSQLiteData:sqlData AndViewController:self];
//    tv = [[TablesView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0, 1, 1) AndDataSource:workingDataObject AndViewController:self];
    [tv setBackgroundColor:[UIColor whiteColor]];
    [zoomingView addSubview:tv];
    
    //Animate the TablesView to the proper size
    //Move the chooseAnalysisButton off the bottom of the screen
    [UIView animateWithDuration:0.5 animations:^{
        [tv setFrame:CGRectMake(0, 50, zoomingView.frame.size.width, zoomingView.frame.size.height - 50)];
        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
            [newVariablesButton setFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
        }
        else
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
            [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
        }
    }];
}

- (void)linearAnalysisSelected
{
    //User selected Linear from analysisList
    
    //Enable the other three buttons
    [setDataSource setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    
    //Move analysisList below the bottom of the screen
    [UIView animateWithDuration:0.3 animations:^{
        [analysisList setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50 * availableAnalyses)];
    }];
    //Wait 0.3 seconds and then set the analysisList to hidden
    [self performSelector:@selector(hideAnalysisList) withObject:nil afterDelay:0.3];
    
    //Allocate and initialize the TablesView, color it white, and add it to the zoomingView
    //TablesView is initially in the center of the screen and size 1 pixel by 1 pixel
    tv = [[LinearView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0, 1, 1) AndSQLiteData:sqlData AndViewController:self];
    //    tv = [[TablesView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0, 1, 1) AndDataSource:workingDataObject AndViewController:self];
    [tv setBackgroundColor:[UIColor whiteColor]];
    [self.epiInfoScrollView addSubview:tv];
    
    //Animate the TablesView to the proper size
    //Move the chooseAnalysisButton off the bottom of the screen
    [UIView animateWithDuration:0.5 animations:^{
        [tv setFrame:CGRectMake(0, 50, zoomingView.frame.size.width, zoomingView.frame.size.height - 50)];
        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
            [newVariablesButton setFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
        }
        else
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
            [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
        }
    }];
}

- (void)logisticAnalysisSelected
{
    //User selected Logistic from analysisList
    
    //Enable the other three buttons
    [setDataSource setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    
    //Move analysisList below the bottom of the screen
    [UIView animateWithDuration:0.3 animations:^{
        [analysisList setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50 * availableAnalyses)];
    }];
    //Wait 0.3 seconds and then set the analysisList to hidden
    [self performSelector:@selector(hideAnalysisList) withObject:nil afterDelay:0.3];
    
    //Allocate and initialize the TablesView, color it white, and add it to the zoomingView
    //TablesView is initially in the center of the screen and size 1 pixel by 1 pixel
    tv = [[LogisticView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0, 1, 1) AndSQLiteData:sqlData AndViewController:self];
    //    tv = [[TablesView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0, 1, 1) AndDataSource:workingDataObject AndViewController:self];
    [tv setBackgroundColor:[UIColor whiteColor]];
    [self.epiInfoScrollView addSubview:tv];
    
    //Animate the TablesView to the proper size
    //Move the chooseAnalysisButton off the bottom of the screen
    [UIView animateWithDuration:0.5 animations:^{
        [tv setFrame:CGRectMake(0, 50, zoomingView.frame.size.width, zoomingView.frame.size.height - 50)];
        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
            [newVariablesButton setFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
        }
        else
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
            [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
        }
    }];
}

- (void)meansAnalysisSelected
{
    //User selected 2x2/MxN Table from analysisList
    
    //Enable the other three buttons
    [setDataSource setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    
    //Move analysisList below the bottom of the screen
    [UIView animateWithDuration:0.3 animations:^{
        [analysisList setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50 * availableAnalyses)];
    }];
    //Wait 0.3 seconds and then set the analysisList to hidden
    [self performSelector:@selector(hideAnalysisList) withObject:nil afterDelay:0.3];
    
    //Allocate and initialize the MeansView, color it white, and add it to the zoomingView
    //MeansView is initially in the center of the screen and size 1 pixel by 1 pixel
    mv = [[MeansView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0, 1, 1) AndSQLiteData:sqlData AndViewController:self];
    [mv setBackgroundColor:[UIColor whiteColor]];
    [zoomingView addSubview:mv];
    
    //Animate the MeansView to the proper size
    //Move the chooseAnalysisButton off the bottom of the screen
    [UIView animateWithDuration:0.5 animations:^{
        [mv setFrame:CGRectMake(0, 50, zoomingView.frame.size.width, zoomingView.frame.size.height - 50)];
        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
            [newVariablesButton setFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
        }
        else
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
            [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
        }
    }];
}

- (void)replaceChooseAnalysis
{
    [UIView animateWithDuration:0.3 animations:^{
        [analyzeDataLabel setAlpha:0.0];
        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width - 50, 100, 50, self.view.frame.size.height - 200)];
            [newVariablesButton setFrame:CGRectMake(0, 100, 50, self.view.frame.size.height - 200)];
        }
        else
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width - 50, 60, 50, self.view.frame.size.height - 120)];
            [newVariablesButton setFrame:CGRectMake(0, 60, 50, self.view.frame.size.height - 120)];
        }
    }];
}

- (void)hideAnalysisList
{
    //Called in tablesAnalysisSelected and frequencyAnalysisSelected
    [analysisList setHidden:YES];
}

- (void)setDataSource:(id)sender
{
    //User selected a file from the list of locally-stored files
    
    //Re-enable the setDataSourceButton
    [setDataSource setEnabled:YES];
    [chooseAnalysis setEnabled:YES];
    [filterButton setEnabled:YES];
    [newVariablesButton setEnabled:YES];
    
    //Cast the sender to a UIButton
    UIButton *b = (UIButton *)sender;
    datasetButton = b;
    
    //Send the button's title (the file name) to getContentOfFile method to set the fullDataObject
    //and workingDataObject AnalysisDataObjects
//    int recordCount = [self getContentOfFile:[b.titleLabel.text substringFromIndex:2] AtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    int recordCount = [self getStoredDataTable:[b.titleLabel.text substringFromIndex:2]];
    
    //Set the dataSourceLabel (on the setDataSource button) to the name of the selected file
    [dataSourceLabel setText:[NSString stringWithFormat:@"%@\n(%d Records)", [b.titleLabel.text substringFromIndex:2], recordCount]];
    
    //Record the name of the data source
    dataSourceName = [NSString stringWithString:b.titleLabel.text];
    
    //Change the title of the setDataSource button itself (if necessary) to indicate
    //that a source has been selected
    [setDataSource setTitle:@"  Data Source" forState:UIControlStateNormal];
    [setDataSource setAccessibilityLabel:[NSString stringWithFormat:@"Data Source:  %@ (%d) Records)", [b.titleLabel.text substringFromIndex:2], recordCount]];
    
    //Move the dataSourceList off the screen and move the chooseAnalysis button onto the screen
    [UIView animateWithDuration:0.3 animations:^{
        [dataSourceList setFrame:CGRectMake(0, -50.0 * (numberOfFiles + 1), zoomingView.frame.size.width, 50.0 * (numberOfFiles + 1))];
        [analyzeDataLabel setAlpha:0.0];
        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width - 50, 100, 50, self.view.frame.size.height - 200)];
            [newVariablesButton setFrame:CGRectMake(0, 100, 50, self.view.frame.size.height - 200)];
        }
        else
        {
            [filterButton setFrame:CGRectMake(self.view.frame.size.width - 50, 60, 50, self.view.frame.size.height - 120)];
            [newVariablesButton setFrame:CGRectMake(0, 60, 50, self.view.frame.size.height - 120)];
        }
    }];
}

//- (void)setDataSourceFromSimpleDB:(id)sender
//{
//    //User selected a SimpleDB table name
//    
//    //Move the dataSourceList above the top of the screen.
//    [UIView animateWithDuration:0.3 animations:^{
//        [dataSourceList setFrame:CGRectMake(0, -50.0 * (numberOfFiles + 1), zoomingView.frame.size.width, 50.0 * (numberOfFiles + 1))];
//    }];
//    
//    //Request dispatch queue
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //Run the queue in the background
//    dispatch_async(queue, ^{
//        
//        //Start the activity indicator in the main thread
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        });
//        
//        //Cast the sender to a UIButton to get its title text
//        UIButton *b = (UIButton *)sender;
//        
//        //Call getContentOfSimpleDBTable:(NSString *)table to set the selected table
//        //into fullDataObject and workingDataObject (returns the number of records
//        int recordCount = [self getContentOfSimpleDBTable:[b.titleLabel.text substringFromIndex:2]];;
//        
//        //Return to main thread when the above completes
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //Hide the activity indicator
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            //Set the dataSourceLabel to display the selected data table and its record count
//            [dataSourceLabel setText:[NSString stringWithFormat:@"%@\n(%d Records)", [b.titleLabel.text substringFromIndex:2], recordCount]];
//            [dataSourceLabel setNeedsDisplay];
//            //Change the title of setDataSource from "Set Data Source" if necessary
//            [setDataSource setTitle:@"  Data Source" forState:UIControlStateNormal];
//            //Re-enable the button
//            [setDataSource setEnabled:YES];
//            [chooseAnalysis setEnabled:YES];
//            [filterButton setEnabled:YES];
//            [newVariablesButton setEnabled:YES];
//            
//            //Move chooseAnalysis button into view
//            [UIView animateWithDuration:0.3 animations:^{
//                [analyzeDataLabel setAlpha:0.0];
//                [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
//                if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
//                {
//                    [filterButton setFrame:CGRectMake(self.view.frame.size.width - 50, 100, 50, self.view.frame.size.height - 200)];
//                    [newVariablesButton setFrame:CGRectMake(0, 100, 50, self.view.frame.size.height - 200)];
//                }
//                else
//                {
//                    [filterButton setFrame:CGRectMake(self.view.frame.size.width - 50, 60, 50, self.view.frame.size.height - 120)];
//                    [newVariablesButton setFrame:CGRectMake(0, 60, 50, self.view.frame.size.height - 120)];
//                }
//            }];
//        });
//    });
//}

- (NSDirectoryEnumerator *)getFilesInDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDirectoryEnumerator *de = [[[NSFileManager alloc] init] enumeratorAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]];
    return de;
    for (NSString *filename in de)
    {
        NSLog(@"%@", filename);
        [self getContentOfFile:filename AtPath:[paths objectAtIndex:0]];
    }
}

//- (int)getContentOfSimpleDBTable:(NSString *)table
//{
//    //Called by setDataSourceFromSimpleDB:(id)sender, which runs when the user
//    //selects a SimpleDB table name
//    
//    //Initialize attributeCount variable to hold the most non-null cells
//    int attributeCount = 0;
//    
//    //Store all itemNames (record id's) in an NSMutableArray
//    NSString *selectExpression = [NSString stringWithFormat:@"select itemName() from `%@`", table];
//    
//    SimpleDBSelectRequest  *selectRequest  = [[SimpleDBSelectRequest alloc] initWithSelectExpression:selectExpression];
//    SimpleDBSelectResponse *selectResponse = [sdb select:selectRequest];
//    if(selectResponse.error != nil)
//    {
//        NSLog(@"Error: %@", selectResponse.error);
//    }
//    
//    if (SimpleDBItems == nil) {
//        SimpleDBItems = [[NSMutableArray alloc] initWithCapacity:[selectResponse.items count]];
//    }
//    else {
//        [SimpleDBItems removeAllObjects];
//    }
//    
//    //Loop through all items; add item.name to NSMutableArray; add all attributes in each item to array of attributes
//    //(if not already there) then count the attributes at the end
//    NSMutableArray *variables = [[NSMutableArray alloc] init];
//    [variables addObject:@"ItemName"];
//    for (SimpleDBItem *item in selectResponse.items) {
//        [SimpleDBItems addObject:item.name];
//        SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:table andItemName:item.name];
//        SimpleDBGetAttributesResponse *response = [sdb getAttributes:gar];
////        attributeCount = MAX(attributeCount, response.attributes.count);
//        for (SimpleDBAttribute *attr in response.attributes)
//            if (![variables containsObject:attr.name])
//                [variables addObject:attr.name];
//    }
//    attributeCount = (int)[variables count];
//    
//    //For each item, get all attributes again; this time add attr.value to the index of an NSMutableArray
//    //corresponding to the index of attr.name in the variables NSMutableArray.
//    int items = 0;
//    //NSMutableArray rows will be an array of arrays
//    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:SimpleDBItems.count];
//    for (NSString *itemName in SimpleDBItems)
//    {
//        SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:table andItemName:itemName];
//        SimpleDBGetAttributesResponse *response = [sdb getAttributes:gar];
//        if(response.error != nil)
//        {
//            NSLog(@"Error: %@", response.error);
//        }
//        
//        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:attributeCount + 1];
//        [values setObject:itemName atIndexedSubscript:0];
//        //Add NSNulls to all indexes of values array to avoid exceptions
//        for (int i = 0; i < attributeCount; i++)
//            [values addObject:[NSNull null]];
//        
//        for (SimpleDBAttribute *attr in response.attributes)
//        {
////            if (![variables containsObject:attr.name])
////                [variables addObject:attr.name];
//            int index = (int)[variables indexOfObject:attr.name];
//            [values setObject:attr.value atIndexedSubscript:index];
//            //                      NSLog(@"Item = %@ | %@ = %@", itemName, attr.name, attr.value);
//        }
//        [rows addObject:values];
//        items++;
//    }
//    
//    //Create the AnalysisDataObjects from the arrays of variables and data
//    fullDataObject = [[AnalysisDataObject alloc] initWithVariablesArray:variables AndDataArray:rows];
//    workingDataObject = [[AnalysisDataObject alloc] initWithAnalysisDataObject:fullDataObject];
//    sqlData = [[SQLiteData alloc] init];
//    [sqlData makeSQLiteFullTable:fullDataObject ProvideUpdatesTo:nil];
//    [sqlData makeSQLiteWorkingTable];
//    
//    return (int)[workingDataObject.dataSet count];
//}

- (int)getContentOfFile:(NSString *)fileName AtPath:(NSString *)path
{
    NSString *filePath = [[path stringByAppendingString:@"/"] stringByAppendingString:fileName];
    fullDataObject = [[AnalysisDataObject alloc] initWithCSVFile:filePath];
    workingDataObject = [[AnalysisDataObject alloc] initWithAnalysisDataObject:fullDataObject];
    sqlData = [[SQLiteData alloc] init];
    [sqlData makeSQLiteFullTable:fullDataObject ProvideUpdatesTo:nil];
    [sqlData makeSQLiteWorkingTable];
    return [sqlData workingTableSize];
}

- (int)getStoredDataTable:(NSString *)tableName
{
    NSThread *updateThread = [[NSThread alloc] initWithTarget:self selector:@selector(provideUpdate) object:nil];
    [updateThread start];
    fullDataObject = [[AnalysisDataObject alloc] initWithStoredDataTable:tableName];
    workingDataObject = [[AnalysisDataObject alloc] initWithAnalysisDataObject:fullDataObject];
    sqlData = [[SQLiteData alloc] init];
    [sqlData makeSQLiteFullTable:fullDataObject ProvideUpdatesTo:datasetButton];
    [sqlData makeSQLiteWorkingTable];
    return [sqlData workingTableSize];
}

- (void)provideUpdate
{
    [datasetButton setTitle:[[datasetButton titleLabel].text stringByAppendingString:@" 0%"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetContentSize
{
    if ([self portraitOrientation])
    {
        [self.epiInfoScrollView setContentSize:initialContentSize];
    }
    else
        [self.epiInfoScrollView setContentSize:initialLandscapeContentSize];
    [zoomingView setFrame:CGRectMake(0, 0, self.epiInfoScrollView.frame.size.width, self.epiInfoScrollView.frame.size.height)];
}

- (void)setInitialContentSize:(CGSize)ics
{
    initialContentSize = ics;
}
- (CGSize)getInitialContentSize
{
    return initialContentSize;
}

- (void)setContentSize:(CGSize)size
{
    [zoomingView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.epiInfoScrollView setContentSize:size];
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
        float zs = [self.epiInfoScrollView zoomScale];
        [self.epiInfoScrollView setZoomScale:1.0 animated:YES];
        if (tv)
            if (tv.frame.size.height < 10.0)
            {
                [tv removeFromSuperview];
                tv = nil;
            }
        if (fv)
            if (fv.frame.size.height < 10.0)
            {
                [fv removeFromSuperview];
                fv = nil;
            }
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView setContentSize:initialContentSize];
                [setDataSource setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
                [dataSourceLabel setFrame:CGRectMake(setDataSource.frame.size.width / 2.0, 0, setDataSource.frame.size.width / 2.0, 50)];
                [dataSourceBorder setFrame:CGRectMake(0, 49, setDataSource.frame.size.width, 1)];
                [dataSourceList setFrame:CGRectMake(dataSourceList.frame.origin.x, dataSourceList.frame.origin.y, setDataSource.frame.size.width, dataSourceList.frame.size.height)];
                [schemaList setFrame:CGRectMake(schemaList.frame.origin.x, schemaList.frame.origin.y, setDataSource.frame.size.width, schemaList.frame.size.height)];
                [analyzeDataLabel setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
                if (workingDataObject)
                {
                    double yDiff = analysisList.frame.origin.y - chooseAnalysis.frame.origin.y;
                    if (fv == nil && tv == nil)
                    {
                        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
                        [filterButton setFrame:CGRectMake(self.view.frame.size.width - 50, 100, 50, self.view.frame.size.height - 200)];
                        [newVariablesButton setFrame:CGRectMake(0, 100, 50, self.view.frame.size.height - 200)];
                    }
                    else
                    {
                        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
                        [filterButton setFrame:CGRectMake(self.view.frame.size.width, 100, 50, self.view.frame.size.height - 200)];
                        [newVariablesButton setFrame:CGRectMake(-50, 100, 50, self.view.frame.size.height - 200)];
                    }
                    [analysisList setFrame:CGRectMake(0, chooseAnalysis.frame.origin.y + yDiff, self.view.frame.size.width, analysisList.frame.size.height)];
                    if (fv != nil)
                        if (fv.frame.size.width > 0)
                            [fv setFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
                    if (tv != nil)
                        if (tv.frame.size.width > 0)
                            [tv setFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
                }
                else
                {
                    [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
                    [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
                }
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.epiInfoScrollView setContentSize:initialLandscapeContentSize];
                [setDataSource setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
                [dataSourceLabel setFrame:CGRectMake(setDataSource.frame.size.width / 2.0, 0, setDataSource.frame.size.width / 2.0, 50)];
                [dataSourceBorder setFrame:CGRectMake(0, 49, setDataSource.frame.size.width, 1)];
                [dataSourceList setFrame:CGRectMake(dataSourceList.frame.origin.x, dataSourceList.frame.origin.y, setDataSource.frame.size.width, dataSourceList.frame.size.height)];
                [schemaList setFrame:CGRectMake(schemaList.frame.origin.x, schemaList.frame.origin.y, setDataSource.frame.size.width, schemaList.frame.size.height)];
                [analyzeDataLabel setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
                if (workingDataObject)
                {
                    double yDiff = analysisList.frame.origin.y - chooseAnalysis.frame.origin.y;
                    if (fv == nil && tv == nil)
                    {
                        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
                        [filterButton setFrame:CGRectMake(self.view.frame.size.width - 50, 60, 50, self.view.frame.size.height - 120)];
                        [newVariablesButton setFrame:CGRectMake(0, 60, 50, self.view.frame.size.height - 120)];
                    }
                    else
                    {
                        [chooseAnalysis setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
                        [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
                        [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
                    }
                    [analysisList setFrame:CGRectMake(0, chooseAnalysis.frame.origin.y + yDiff, self.view.frame.size.width, analysisList.frame.size.height)];
                    if (fv != nil)
                        if (fv.frame.size.width > 0)
                            [fv setFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
                    if (tv != nil)
                        if (tv.frame.size.width > 0)
                            [tv setFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
                }
                else
                {
                    [filterButton setFrame:CGRectMake(self.view.frame.size.width, 60, 50, self.view.frame.size.height - 120)];
                    [newVariablesButton setFrame:CGRectMake(-50, 60, 50, self.view.frame.size.height - 120)];
                }
            }];
        }
        //Re-size the zoomingView
        [zoomingView setFrame:CGRectMake(0, 0, self.epiInfoScrollView.contentSize.width, self.epiInfoScrollView.contentSize.height)];
//        [self.epiInfoScrollView setContentSize:zoomingView.frame.size];
        
        if (zs > 1.0)
            [self.epiInfoScrollView setZoomScale:zs animated:YES];
    }
}

- (void)deleteDatasetButtonPressed:(UIButton *)sender
{
    UIButton *sendingButton = (UIButton *)[sender superview];
    [sendingButton removeTarget:self action:@selector(setDataSource:) forControlEvents:UIControlEventTouchUpInside];
    ConfirmDeleteButton *confirmDeleteButton = [[ConfirmDeleteButton alloc] initWithFrame:CGRectMake(sendingButton.frame.origin.x - 80, sendingButton.frame.origin.y, 80, 50)];
    [confirmDeleteButton setBackgroundColor:[UIColor colorWithRed:164/225.0 green:16/255.0 blue:52/255.0 alpha:1.0]];
    [confirmDeleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [confirmDeleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
    [confirmDeleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmDeleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [confirmDeleteButton addTarget:self action:@selector(confirmDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 80, 1)];
    [bottomLineView setBackgroundColor:[UIColor blackColor]];
    [confirmDeleteButton addSubview:bottomLineView];
    [confirmDeleteButton setDatasetToDelete:[[sendingButton titleLabel].text substringFromIndex:2]];
    [confirmDeleteButton setButtonToRemove:sendingButton];
    [[sendingButton superview] addSubview:confirmDeleteButton];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [sendingButton setFrame:CGRectMake(sendingButton.frame.origin.x + 80, sendingButton.frame.origin.y, sendingButton.frame.size.width, sendingButton.frame.size.height)];
        [confirmDeleteButton setFrame:CGRectMake(confirmDeleteButton.frame.origin.x + 80, confirmDeleteButton.frame.origin.y, confirmDeleteButton.frame.size.width, confirmDeleteButton.frame.size.height)];
    } completion:^(BOOL finished){
        [sendingButton addTarget:self action:@selector(moveDatasetButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)confirmDeleteButtonPressed:(UIButton *)sender
{
    ConfirmDeleteButton *confirmDeleteButton = (ConfirmDeleteButton *)sender;
    UIButton *buttonToRemove = [confirmDeleteButton buttonToRemove];
    
    NSMutableArray *arrayOfButtons = [[NSMutableArray alloc] init];
    for (UIView *v in [[buttonToRemove superview] subviews])
        if ([v isKindOfClass:[UIButton class]] && v.frame.origin.y == buttonToRemove.frame.origin.y + buttonToRemove.frame.size.height)
            [arrayOfButtons setObject:(UIButton *)v atIndexedSubscript:0];
        else if ([v isKindOfClass:[UIButton class]] && v.frame.origin.y > buttonToRemove.frame.origin.y + buttonToRemove.frame.size.height)
            [arrayOfButtons addObject:(UIButton *)v];
    
    UIView *blackLine = [[UIView alloc] initWithFrame:CGRectMake(0, -1, [(UIButton *)[arrayOfButtons objectAtIndex:0] frame].size.width, 1)];
    [blackLine setBackgroundColor:[UIColor blackColor]];
    [(UIButton *)[arrayOfButtons objectAtIndex:0] addSubview:blackLine];

    [confirmDeleteButton removeFromSuperview];
    [buttonToRemove removeFromSuperview];
    
    [self removeDatasetFromSQL:[(ConfirmDeleteButton *)sender datasetToDelete]];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        for (int i = 0; i < arrayOfButtons.count; i++)
        {
            UIButton *b = (UIButton *)[arrayOfButtons objectAtIndex:i];
            [b setFrame:CGRectMake(b.frame.origin.x, b.frame.origin.y - b.frame.size.height, b.frame.size.width, b.frame.size.height)];
        }
        [dataSourceList setFrame:CGRectMake(dataSourceList.frame.origin.x, dataSourceList.frame.origin.y, dataSourceList.frame.size.width, dataSourceList.frame.size.height - [(UIButton *)[arrayOfButtons objectAtIndex:0] frame].size.height)];
        for (UIView *v in [dataSourceList subviews])
            if ([v isKindOfClass:[BlurryView class]])
                [(BlurryView *)v setFrame:dataSourceList.frame];
    } completion:^(BOOL finished){
        [blackLine removeFromSuperview];
    }];
}

- (void)moveDatasetButtonBack:(UIButton *)sender
{
    UIButton *confirmDeleteButton;
    for (UIView *v in [[sender superview] subviews])
        if ([v isKindOfClass:[UIButton class]])
            if ([[(UIButton *)v titleLabel].text isEqualToString:@"Delete"])
                confirmDeleteButton = (UIButton *)v;
    UIButton *sendingButton = (UIButton *)sender;
    [sendingButton removeTarget:self action:@selector(moveDatasetButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [sendingButton setFrame:CGRectMake(sendingButton.frame.origin.x - 80, sendingButton.frame.origin.y, sendingButton.frame.size.width, sendingButton.frame.size.height)];
        [confirmDeleteButton setFrame:CGRectMake(confirmDeleteButton.frame.origin.x - 80, confirmDeleteButton.frame.origin.y, confirmDeleteButton.frame.size.width, confirmDeleteButton.frame.size.height)];
    } completion:^(BOOL finished){
        [sendingButton addTarget:self action:@selector(setDataSource:) forControlEvents:UIControlEventTouchUpInside];
        [confirmDeleteButton removeFromSuperview];
    }];
}

- (void)removeDatasetFromSQL:(NSString *)dataset
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        //Convert the databasePath NSString to a char array
        const char *dbpath = [databasePath UTF8String];
        
        //Open sqlite3 analysisDB pointing to the databasePath
        if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
        {
            char *errMsg;
            //Build the DROP TABLE statement
            //Convert the sqlStmt to char array
            const char *sql_stmt = [[NSString stringWithFormat:@"drop table %@", dataset] UTF8String];
            
            //Execute the DROP TABLE statement
            if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to drop table: %s :::: %s", errMsg, sql_stmt);
            }
            else
            {
                //                                        NSLog(@"Table dropped");
            }
            //Close the sqlite connection
            sqlite3_close(epiinfoDB);
        }
        else
        {
            NSLog(@"Failed to open/create database");
        }
    }
}

- (void)putViewOnZoomingView:(UIView *)viewToMove
{
    [zoomingView addSubview:viewToMove];
}
- (void)putViewOnEpiInfoScrollView:(UIView *)viewToMove
{
    [self.epiInfoScrollView addSubview:viewToMove];
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGRect)getZoomingViewFrame{return zoomingView.frame;}
@end
