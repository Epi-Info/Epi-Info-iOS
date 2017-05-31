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
    
    UIView *daysGridBase;
    UIView *monthsGridBase;
    UIView *yearsGridBase;
}
@property UITextField *dateField;
-(id)initWithFrame:(CGRect)frame AndDateField:(UITextField *)dateField;
@end
