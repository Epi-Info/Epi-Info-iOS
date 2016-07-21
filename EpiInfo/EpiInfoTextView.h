//
//  EpiInfoTextView.h
//  EpiInfo
//
//  Created by John Copeland on 12/31/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpiInfoTextView : UITextView
@property NSString *columnName;
-(void)setFormFieldValue:(NSString *)formFieldValue;
@end
