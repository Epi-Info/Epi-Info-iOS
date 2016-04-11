//
//  Checkbox.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "EpiInfo-Swift.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EpiInfoControlProtocol.h"

@interface Checkbox : UIView <EpiInfoControlProtocol>
{
    UIButton *button;
    BOOL value;
}

-(BOOL)value;
-(void)reset;
-(void)setTrueFalse:(NSInteger)trueFalse;
-(void)setFormFieldValue:(NSString *)formFieldValue;
-(void)setCheckboxAccessibilityLabel:(NSString *)accessibilityLabel;

-(UIButton *)myButton;

@property CheckCode *checkcode;
@property NSString *columnName;
@end
