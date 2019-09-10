//
//  TextFieldDisplay.h
//  EpiInfo
//
//  Created by John Copeland on 3/6/19.
//

#import <UIKit/UIKit.h>
#import "FormDesignerFieldDisplayPrompt.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextFieldDisplay : UIView
@property FormDesignerFieldDisplayPrompt *prompt;
@property UITextField *field;
-(void)checkTheBox;
-(void)displayDate;
-(void)displayYesNo;
-(void)displayOption;
-(void)displayImage;
-(void)displayLegalValues;
-(void)displayCommandButton;
-(void)displayButton;
-(void)displayPageBreak;
@end

NS_ASSUME_NONNULL_END
