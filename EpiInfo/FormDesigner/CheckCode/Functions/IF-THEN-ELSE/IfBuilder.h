//
//  IfBuilder.h
//  EpiInfo
//
//  Created by John Copeland on 5/16/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IfBuilder : UIView
{
    UIButton *callingButton;
    UIView *ccWriter;
    UIView *formDesigner;
    
    UILabel *ifConditionLabel;
    UITextView *ifConditionText;
    UILabel *thenLabel;
    UITextView *thenText;
    UILabel *elseLabel;
    UITextView *elseText;
    
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    
    UIButton *existingFunctionsButton;
    UIButton *deleteButton;
    
    BOOL existingFunctions;
    NSMutableArray *existingFunctionsArray;
    
    NSString *functionBeingEdited;
    
    NSMutableArray *formDesignerCheckCodeStrings;
    
    NSMutableArray *deletedIfBlocks;
}
-(void)setFormDesignerCheckCodeStrings:(NSMutableArray *)fdccs;
-(void)setDeletedIfBlocks:(NSMutableArray *)dib;
-(id)initWithFrame:(CGRect)frame AndCallingButton:(UIButton *)cb;
-(void)loadFunctionToEdit:(NSString *)function;
@end

NS_ASSUME_NONNULL_END
