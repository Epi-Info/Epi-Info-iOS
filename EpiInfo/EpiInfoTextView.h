//
//  EpiInfoTextView.h
//  EpiInfo
//
//  Created by John Copeland on 12/31/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpiInfoControlProtocol.h"

@interface EpiInfoTextView : UITextView <EpiInfoControlProtocol>
@property NSString *columnName;
@property BOOL isReadOnly;
-(void)setFormFieldValue:(NSString *)formFieldValue;
-(void)reset;
@end
