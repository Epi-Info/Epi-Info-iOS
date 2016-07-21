//
//  UppercaseTextField.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "EpiInfo-Swift.h"
#import <UIKit/UIKit.h>

@interface UppercaseTextField : UITextField
@property CheckCode *checkcode;
@property NSString *columnName;
-(void)setFormFieldValue:(NSString *)formFieldValue;
@end
