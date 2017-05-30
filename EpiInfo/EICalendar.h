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
}
@property UITextField *dateField;
-(id)initWithFrame:(CGRect)frame AndDateField:(UITextField *)dateField;
@end
