//
//  UppercaseTextField.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "EpiInfo-Swift.h"
#import "EpiInfoControlProtocol.h"
#import <UIKit/UIKit.h>

@interface UppercaseTextField : UITextField <EpiInfoControlProtocol>
@property CheckCode *checkcode;
@property NSString *columnName;
@property BOOL isReadOnly;
@property UILabel *elementLabel;
-(void)setFormFieldValue:(NSString *)formFieldValue;
-(void)reset;
@end
