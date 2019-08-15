//
//  FormDesigner.h
//  EpiInfo
//
//  Created by John Copeland on 2/13/19.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FormElementObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormDesigner : UIView <MFMailComposeViewControllerDelegate, UITextFieldDelegate, NSXMLParserDelegate>
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
    NSMutableArray *checkCodeStrings;
    int lastPage;
    
    UIScrollView *canvasSV;
    UIButton *formDesignerLabel;
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
    
    NSArray *reservedWords;
    
    NSMutableArray *deletedFieldIfBlocks;
    
    BOOL justParsingForCheckCode;
    NSString *checkCodeStringForDisplay;
}
@property UIViewController *rootViewController;
-(NSMutableArray *)formElementObjects;
-(NSMutableArray *)pageNames;
-(NSMutableArray *)checkCodeStrings;
-(void)setDeletedFieldIfBlocks:(NSMutableArray *)dfib;
-(id)initWithFrame:(CGRect)frame andSender:(UIButton *)sender;
-(void)addCheckCodeString:(NSString *)ccString;
-(void)buildTheXMLFile;
@end

NS_ASSUME_NONNULL_END
