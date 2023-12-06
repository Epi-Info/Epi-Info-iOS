//
//  DatePicker.h
//  EpiInfo
//
//  Created by John Copeland on 5/20/14.
//

#import <UIKit/UIKit.h>
#import "LegalValues.h"
#import "LegalValuesEnter.h"
#import "EICalendar.h"

@interface DatePicker : UIView <UIPickerViewDelegate>
{
    EICalendar *eic;
    LegalValues *monthsLV;
    LegalValues *daysLV;
    LegalValues *yearsLV;
    LegalValuesEnter *hhLV;
    LegalValuesEnter *mmLV;
    BOOL dmy;
    UIViewController *rootViewController;
}
@property UITextField *dateField;
-(id)initWithFrame:(CGRect)frame AndDateField:(UITextField *)dateField;
-(void)removeSelfFromSuperview;
-(void)setRootViewController:(UIViewController *)rvc;
-(UIViewController *)rootViewController;
@end
