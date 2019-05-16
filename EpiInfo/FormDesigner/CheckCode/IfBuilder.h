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
    
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    
    UIButton *existingFunctionsButton;
    UIButton *deleteButton;
    
    BOOL existingFunctions;
    NSMutableArray *existingFunctionsArray;
    
    NSString *functionBeingEdited;
}
-(id)initWithFrame:(CGRect)frame AndCallingButton:(UIButton *)cb;
@end

NS_ASSUME_NONNULL_END
