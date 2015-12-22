//
//  MirrorField.h
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//

#import <UIKit/UIKit.h>
#import "EpiInfoTextField.h"

@interface MirrorField : EpiInfoTextField
@property NSString *columnName;
@property NSNumber *sourceFieldID;
-(void)setFormFieldValue:(NSString *)formFieldValue;
@end
