//
//  EICalendar.h
//  EpiInfo
//
//  Created by John Copeland on 5/30/17.
//

#import <UIKit/UIKit.h>

@interface EICalendar : UIView
{
    BOOL dmy;
    
    UIButton *monthButton;
    
    BOOL displayingAMonth;
    BOOL displayingAYear;
    BOOL displayingADecade;
    
    UIView *whiteView;
    
    UIView *daysGridBase;
    UIView *monthsGridBase;
    UIView *yearsGridBase;
    
    int month;
    int day;
    int year;
    
    int initialMonth;
    int initialYear;
}
@property UIView *datePickerView;
@property UITextField *dateField;
-(id)initWithFrame:(CGRect)frame AndDateField:(UITextField *)dateField;
@end
