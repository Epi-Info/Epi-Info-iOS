//
//  NumberField.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import <UIKit/UIKit.h>
#import "EpiInfoControlProtocol.h"

@interface NumberField : UITextField <UITextFieldDelegate, EpiInfoControlProtocol>
{
  NSObject *checkcode;
}
-(NSString *)value;
-(void)setFormFieldValue:(NSString *)formFieldValue;

@property NSString *columnName;
@property BOOL isReadOnly;
@property BOOL nonNegative;
@property BOOL hasMaximum;
@property BOOL hasMinimum;
@property float maximum;
@property float minimum;
@property UILabel *elementLabel;

-(void)setCheckcode:(id)ccode;
-(id)checkcode;
-(void)reset;
@end
