//
//  EICalendar.m
//  EpiInfo
//
//  Created by John Copeland on 5/30/17.
//

#import "EICalendar.h"
#import "BlurryView.h"
#import "DateField.h"

@implementation EICalendar
@synthesize dateField = _dateField;

- (id)initWithFrame:(CGRect)frame AndDateField:(UITextField *)dateField
{
    self = [self initWithFrame:frame];
    if (self)
    {
        [self setDateField:dateField];
        
        [self setBackgroundColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0]];
        
        NSDate *dateObject = [NSDate date];
        dmy = ([[[dateObject descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[dateObject descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
        
        int month = (int)[[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:dateObject] month];
        int day = (int)[[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:dateObject] day];
        int year = (int)[[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:dateObject] year];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width - 2.0, frame.size.height - 2.0)];
        [whiteView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:whiteView];
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.0];
        [whiteView.layer setMasksToBounds:YES];
        [whiteView.layer setCornerRadius:4.0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
