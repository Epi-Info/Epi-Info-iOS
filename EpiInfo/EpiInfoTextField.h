//
//  EpiInfoTextField.h
//  EpiInfo
//
//  Created by John Copeland on 12/31/13.
//

#import "EpiInfo-Swift.h"
#import "EpiInfoControlProtocol.h"
#import <UIKit/UIKit.h>

@interface EpiInfoTextField : UITextField <UITextFieldDelegate, EpiInfoControlProtocol>
@property CheckCode *checkcode;
@property NSString *columnName;
@property BOOL isReadOnly;
@property UITextField *mirroringMe;
@property UILabel *elementLabel;
@property int maxLength;
-(void)setFormFieldValue:(NSString *)formFieldValue;
-(void)reset;
@end
