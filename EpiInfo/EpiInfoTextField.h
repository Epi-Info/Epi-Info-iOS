//
//  EpiInfoTextField.h
//  EpiInfo
//
//  Created by John Copeland on 12/31/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "EpiInfo-Swift.h"
#import <UIKit/UIKit.h>

@interface EpiInfoTextField : UITextField
@property CheckCode *checkcode;
@property NSString *columnName;
@property UITextField *mirroringMe;
-(void)setFormFieldValue:(NSString *)formFieldValue;
@end
