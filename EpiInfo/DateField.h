//
//  DateField.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import <UIKit/UIKit.h>

@interface DateField : UITextField
@property NSString *columnName;
@property UITextField *mirroringMe;
@property NSNumber *templateFieldID;
-(void)setFormFieldValue:(NSString *)formFieldValue;
@end
