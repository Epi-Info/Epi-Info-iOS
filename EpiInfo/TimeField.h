//
//  TimeField.h
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpiInfoTextField.h"

@interface TimeField : EpiInfoTextField
@property NSString *columnName;
-(void)setFormFieldValue:(NSString *)formFieldValue;
-(void)reset;
@end
