//
//  EnableDisableClear.h
//  EpiInfo
//
//  Created by John Copeland on 5/13/19.
//

#import <UIKit/UIKit.h>
#import "LegalValuesEnter.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnableDisableClear : UIView
{
    UIButton *callingButton;
    UIView *ccWriter;
    UIView *formDesigner;
    
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    
    UILabel *fieldToAffectLabel;
    LegalValuesEnter *fieldToAffect;
    UITextField *fieldToAffectSelected;
    
    UIButton *existingFunctionsButton;
    UIButton *deleteButton;
    
    BOOL existingFunctions;
    NSMutableArray *existingFunctionsArray;
    
    NSString *functionBeingEdited;
}
-(id)initWithFrame:(CGRect)frame AndCallingButton:(UIButton *)cb;
-(void)closeButtonPressed:(UIButton *)sender;
-(void)editButtonPressed:(UIButton *)sender;
-(void)addAfterFunction:(NSString *)function;
-(void)addBeforeFunction:(NSString *)function;
-(void)addClickFunction:(NSString *)function;
-(void)loadFunctionToEdit:(NSString *)function;
@end

NS_ASSUME_NONNULL_END
