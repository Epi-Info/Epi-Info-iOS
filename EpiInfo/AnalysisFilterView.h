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

@interface AnalysisFilterView : DataManagementView <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSArray *unsortedVariableNames;
    NSArray *unsortedVariableTypes;
    
    int variablesLVESelectedIndex;
    
    LegalValuesEnter *selectVariable;
    LegalValuesEnter *selectOperator;
    LegalValuesEnter *selectValue;
    EpiInfoTextField *typeTextValue;
    NumberField *typeNumberValue;
    
    NSMutableArray *listOfValues;
    UITableView *filterList;
    
    UIButton *addFilterButton;
    UIButton *addWithAndButton;
    UIButton *addWithOrButton;
}
-(id)initWithFrameForSubclass:(CGRect)frame;
-(id)initWithViewController:(UIViewController *)vc;
-(void)setListOfValues:(NSMutableArray *)lov;
@end
