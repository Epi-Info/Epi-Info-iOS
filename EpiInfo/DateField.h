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
@property NSString *fieldLabel;
@property UITextField *mirroringMe;
@property NSNumber *templateFieldID;
-(void)setFormFieldValue:(NSString *)formFieldValue;
-(void)reset;
@end
