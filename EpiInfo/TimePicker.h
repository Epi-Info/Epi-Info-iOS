//
//  TimePicker.h
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//

#import <UIKit/UIKit.h>
#import "LegalValues.h"

@interface TimePicker : UIView <UIPickerViewDelegate>
{
    LegalValues *hoursLV;
    LegalValues *minutesLV;
    LegalValues *secondsLV;
    BOOL dmy;
}
@property UITextField *timeField;
-(id)initWithFrame:(CGRect)frame AndTimeField:(UITextField *)timeField;
@end
