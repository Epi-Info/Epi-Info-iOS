//
//  YesNo.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EpiInfoControlProtocol.h"

@interface YesNo : UIView <UIPickerViewDelegate, UIPickerViewDataSource, EpiInfoControlProtocol, UITableViewDelegate, UITableViewDataSource>
{
    UILabel *picked;
    UIPickerView *picker;
    UIView *valueButtonView;
    UIView *shield;
    float topX;
    float topY;
    float finalTopY;
}

-(NSString *)picked;
-(void)reset;
-(void)setYesNo:(NSInteger)yesNo;
-(void)setFormFieldValue:(NSString *)formFieldValue;
-(void)removeValueButtonViewFromSuperview;
-(float)contentSizeHeightAdjustment;

@property NSString *columnName;
@property BOOL isReadOnly;
@property UIButton *valueButton;
@property UITableView *tv;
@end
