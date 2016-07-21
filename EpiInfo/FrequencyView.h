//
//  FrequencyView.h
//  EpiInfo
//
//  Created by John Copeland on 7/8/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AnalysisDataObject.h"
#import "FrequencyObject.h"
#include "ShinyButton.h"
#include "UIPickerViewWithBlurryBackground.h"

@interface FrequencyView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIColor *epiInfoLightBlue;
    
    UIView *titleBar;
    UILabel *gadgetTitle;
    UIButton *xButton;
    UIButton *gearButton;
    
    UIView *inputView;
    UIView *inputViewWhiteBox;

    UIPickerViewWithBlurryBackground *chooseVariable;
    UIPickerViewWithBlurryBackground *chooseStratificationVariable;

    UILabel *includeMissingLabel;
    UIButton *includeMissingButton;
    BOOL includeMissing;
    NSNumber *selectedVariableNumber;
    NSNumber *selectedStratificationVariableNumber;
    NSMutableArray *availableVariables;
    NSMutableArray *availableStratificationVariables;
    
    BOOL frequencyVariableChosen;
    BOOL stratificationVariableChosen;
    ShinyButton *chosenFrequencyVariable;
    ShinyButton *chosenStratificationVariable;

    UIView *outputView;
    
    AnalysisDataObject *dataObject;
    SQLiteData *sqliteData;

    BOOL inputViewDisplayed;
    
    UIView *outputTableView;
}

-(id)initWithFrame:(CGRect)frame AndDataSource:(AnalysisDataObject *)dataSource AndViewController:(UIViewController *)vc;
-(id)initWithFrame:(CGRect)frame AndSQLiteData:(SQLiteData *)dataSource AndViewController:(UIViewController *)vc;
-(void)xButtonPressed;
@end
