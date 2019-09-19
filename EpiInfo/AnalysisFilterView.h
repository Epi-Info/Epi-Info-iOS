//
//  AnalysisFilterView.h
//  EpiInfo
//
//  Created by John Copeland on 8/8/13.
//

#import "DataManagementView.h"
#import "LegalValuesEnter.h"
#import "EpiInfoTextField.h"
#import "NumberField.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AnalysisFilterView : DataManagementView
{
    NSArray *unsortedVariableNames;
    NSArray *unsortedVariableTypes;
    
    int variablesLVESelectedIndex;
    
    LegalValuesEnter *selectVariable;
    LegalValuesEnter *selectOperator;
    LegalValuesEnter *selectValue;
    EpiInfoTextField *typeTextValue;
    NumberField *typeNumberValue;
}
- (id)initWithViewController:(UIViewController *)vc;
@end
