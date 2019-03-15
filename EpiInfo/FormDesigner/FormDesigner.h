//
//  FormDesigner.h
//  EpiInfo
//
//  Created by John Copeland on 2/13/19.
//

#import <UIKit/UIKit.h>
#import "FormElementObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormDesigner : UIView <UITextFieldDelegate, NSXMLParserDelegate>
{
    float nextY;
    float nextYReset;
    float yTouched;
    
    NSString *epiInfoForms;
    NSMutableArray *existingForms;
    NSString *formName;
    NSMutableArray *formElements;
    NSMutableArray *formElementObjects;
    NSMutableArray *pages;
    NSMutableArray *pageNames;
    NSMutableArray *pageNumbers;
    NSMutableArray *actualPageNumbers;
    int lastPage;
    
    UIScrollView *canvasSV;
    UILabel *formDesignerLabel;
    UIView *canvas;
    UIView *canvasCover;
    UITapGestureRecognizer *canvasTapGesture;
    
    BOOL formNamed;
    
    UIScrollView *menu;
    
    UIView *newFormViewGrayBackground;
    UIView *controlViewGrayBackground;
    UIView *valuesGrayBackground;
    NSMutableArray *valuesFields;

    FormElementObject *feoUnderEdit;
    
    NSString *checkCodeString;
}
@property UIViewController *rootViewController;
-(id)initWithFrame:(CGRect)frame andSender:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
