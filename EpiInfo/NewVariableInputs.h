//
//  NewVariableInputs.h
//  EpiInfo
//
//  Created by John Copeland on 10/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewVariableInputs : UIView
{
    UILabel *function;
    UIButton *saveButton;
    UIButton *cancelButton;
}
-(void)setFunction:(NSString *)func;
-(void)removeSelf:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
