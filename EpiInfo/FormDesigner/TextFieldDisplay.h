//
//  TextFieldDisplay.h
//  EpiInfo
//
//  Created by John Copeland on 3/6/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextFieldDisplay : UIView
@property UILabel *prompt;
@property UITextField *field;
-(void)checkTheBox;
-(void)displayDate;
@end

NS_ASSUME_NONNULL_END
