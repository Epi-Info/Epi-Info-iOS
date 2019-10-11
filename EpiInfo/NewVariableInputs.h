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
    UIButton *saveButton;
    UIButton *cancelButton;
}
-(void)setFunction:(NSString *)func;
-(void)removeSelf:(UIButton *)sender;
-(void)fieldResignedFirstResponder:(id)field;
-(void)setAVC:(UIViewController *)uivc;
@end

NS_ASSUME_NONNULL_END
