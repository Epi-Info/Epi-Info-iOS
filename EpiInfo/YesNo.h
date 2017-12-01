//
//  YesNo.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EpiInfoControlProtocol.h"

@interface YesNo : UIView <UIPickerViewDelegate, UIPickerViewDataSource, EpiInfoControlProtocol>
{
    UILabel *picked;
    UIPickerView *picker;
}

-(NSString *)picked;
-(void)reset;
-(void)setYesNo:(NSInteger)yesNo;
-(void)setFormFieldValue:(NSString *)formFieldValue;

@property NSString *columnName;
@property BOOL isReadOnly;
@end
