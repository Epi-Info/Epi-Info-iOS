//
//  TablesView.h
//  EpiInfo
//
//  Created by John Copeland on 7/10/13.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AnalysisDataObject.h"
#import "TablesObject.h"
#import "ShinyButton.h"
#import "EpiInfoUILabel.h"
#import "UIPickerViewWithBlurryBackground.h"
#import "LegalValuesEnter.h"
#import "EpiInfoTextField.h"
#import "VariableValueMapper.h"

@interface TablesView : UIView <UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate>
{
    UIColor *epiInfoLightBlue;
    
    UIView *titleBar;
    UILabel *gadgetTitle;
    UIButton *xButton;
    UIButton *gearButton;
    
    UIView *inputView;
    UIView *inputViewWhiteBox;
    UIPickerViewWithBlurryBackground *chooseOutcomeVariable;
    UIPickerViewWithBlurryBackground *chooseExposureVariable;
    UIPickerViewWithBlurryBackground *chooseStratificationVariable;
    UILabel *includeMissingLabel;
    UIButton *includeMissingButton;
    BOOL includeMissing;
    NSNumber *selectedOutcomeVariableNumber;
    NSNumber *selectedExposureVariableNumber;
    NSNumber *selectedStratificationVariableNumber;
    NSMutableArray *availableOutcomeVariables;
    NSMutableArray *availableExposureVariables;
    NSMutableArray *availableStratificationVariables;
    
    BOOL outcomeVariableChosen;
    BOOL exposureVariableChosen;
    BOOL stratificationVariableChosen;
    ShinyButton *chosenOutcomeVariable;
    ShinyButton *chosenExposureVariable;
    ShinyButton *chosenStratificationVariable;
    
    UILabel *outcomeVariableLabel;
    UITextField *outcomeVariableString;
    LegalValuesEnter *outcomeLVE;
    UILabel *exposureVariableLabel;
    EpiInfoTextField *exposureVariableString;
    LegalValuesEnter *exposureLVE;
    UILabel *stratificationVariableLabel;
    UITextField *stratificationVariableString;
    LegalValuesEnter *stratificationLVE;

    UIView *outputView;
    UIView *secondOutputViewForIPad;

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
    
    int numberOfExposures;
    int workingExposure;
    NSMutableArray *summaryTable;
    UIScrollView *oddsAndRiskTableView;
    float contentSizeHeight;
    
    VariableValueMapper *outcomeValueMapper;
    UIButton *mapOutcomeValuesButton;
    NSString *previousOutcomeVariableValue;
    VariableValueMapper *exposureValueMapper;
    UIButton *mapExposureValuesButton;
    NSString *previousExposureVariableValue;
}

-(id)initWithFrame:(CGRect)frame AndDataSource:(AnalysisDataObject *)dataSource AndViewController:(UIViewController *)vc;
-(id)initWithFrame:(CGRect)frame AndSQLiteData:(SQLiteData *)dataSource AndViewController:(UIViewController *)vc;
-(void)fieldResignedFirstResponder:(id)field;
-(void)xButtonPressed;
-(VariableValueMapper *)outcomeValueMapper;
-(VariableValueMapper *)exposureValueMapper;
@end
