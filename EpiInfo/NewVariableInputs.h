//
//  NewVariableInputs.h
//  EpiInfo
//
//  Created by John Copeland on 10/10/19.
//

#import <UIKit/UIKit.h>
#import "AnalysisViewController.h"
#import "LegalValuesEnter.h"
#import "EpiInfoTextField.h"
#import "NumberField.h"
#import "DateField.h"
#import "DataManagementView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewVariableInputs : UIView <UITextFieldDelegate>
{
    UIViewController *avc;
    UILabel *function;
    NSString *newVariableType;
    UIButton *saveButton;
    UIButton *cancelButton;
    
    NSString *newVariableName;
    NSMutableArray *listOfNewVariables;
    UITableView *newVariableList;
}
-(void)setNewVariableType:(NSString *)nvType;
-(void)setFunction:(NSString *)func;
-(void)removeSelf:(UIButton *)sender;
-(void)fieldResignedFirstResponder:(id)field;
-(void)setAVC:(UIViewController *)uivc;
-(void)setNewVariableName:(NSString *)nvn;
-(void)setListOfNewVariables:(NSMutableArray *)nsma;
-(void)setNewVariableList:(UITableView *)uitv;
-(id)initWithFrameForConditionalAssignment:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
