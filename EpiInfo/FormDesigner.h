//
//  FormDesigner.h
//  EpiInfo
//
//  Created by John Copeland on 2/13/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormDesigner : UIView <UITextFieldDelegate>
{
    NSMutableArray *existingForms;
    NSMutableArray *formElements;
    
    UIScrollView *canvasSV;
    UILabel *formDesignerLabel;
    UIView *canvas;
    UIView *canvasCover;
    UITapGestureRecognizer *canvasTapGesture;
    
    BOOL formNamed;
    
    UIScrollView *menu;
    
    UIView *newFormViewGrayBackground;
    UIView *controlViewGrayBackground;
}
@property UIViewController *rootViewController;
-(id)initWithFrame:(CGRect)frame andSender:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
