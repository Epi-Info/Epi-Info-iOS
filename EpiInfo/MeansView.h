//
//  MeansView.h
//  EpiInfo
//
//  Created by John Copeland on 8/21/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AnalysisDataObject.h"
#import "MeansObject.h"
#import "MeansCrosstabCompute.h"
#import "ShinyButton.h"
#import "EpiInfoUILabel.h"
#import "EpiInfoViewForRounding.h"
#import "UIPickerViewWithBlurryBackground.h"
#import "LegalValuesEnter.h"

@interface MeansView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIColor *epiInfoLightBlue;
    
    UIView *titleBar;
    UILabel *gadgetTitle;
    UIButton *xButton;
    UIButton *gearButton;
    
    UIView *inputView;
    UIView *inputViewWhiteBox;
    UIPickerViewWithBlurryBackground *chooseMeansVariable;
    UIPickerViewWithBlurryBackground *chooseCrosstabVariable;
    UIPickerViewWithBlurryBackground *chooseStratificationVariable;
    UILabel *includeMissingLabel;
    UIButton *includeMissingButton;
    BOOL includeMissing;
    NSNumber *selectedMeansVariableNumber;
    NSNumber *selectedCrosstabVariableNumber;
    NSNumber *selectedStratificationVariableNumber;
    NSMutableArray *availableOutcomeVariables;
    NSMutableArray *availableExposureVariables;
    NSMutableArray *availableStratificationVariables;
    
    BOOL meansVariableChosen;
    BOOL crosstabVariableChosen;
    BOOL stratificationVariableChosen;
    ShinyButton *chosenMeansVariable;
    ShinyButton *chosenCrosstabVariable;
    ShinyButton *chosenStratificationVariable;
    
    UILabel *meansVariableLabel;
    UITextField *meansVariableString;
    LegalValuesEnter *meansLVE;
    UILabel *crosstabVariableLabel;
    UITextField *crosstabVariableString;
    LegalValuesEnter *crosstabLVE;

    UIView *outputView;
    
    AnalysisDataObject *dataObject;
    SQLiteData *sqliteData;
    
    UIView *outputTableView;
    UIView *oddsBasedParametersView;
    UIView *riskBasedParametersView;
    UIView *statisticalTestsView;
    
    BOOL inputViewDisplayed;
    BOOL outputViewDisplayed;
    BOOL twoByTwoDisplayed;
    
    float outputTableViewWidth;
    float outputTableViewHeight;
    
    int stratum;
    
    float leftSide;
}

-(id)initWithFrame:(CGRect)frame AndDataSource:(AnalysisDataObject *)dataSource AndViewController:(UIViewController *)vc;
-(id)initWithFrame:(CGRect)frame AndSQLiteData:(SQLiteData *)dataSource AndViewController:(UIViewController *)vc;
-(void)xButtonPressed;
@end
