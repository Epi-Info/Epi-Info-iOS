//
//  DateField.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import <UIKit/UIKit.h>
#import "EpiInfoControlProtocol.h"

@interface DateField : UITextField <EpiInfoControlProtocol>
@property NSString *columnName;
@property BOOL isReadOnly;
@property NSString *fieldLabel;
@property UITextField *mirroringMe;
@property NSNumber *templateFieldID;
@property UILabel *elementLabel;
@property NSDate *lower;
@property NSDate *upper;
-(void)setFormFieldValue:(NSString *)formFieldValue;
-(void)reset;
@end
