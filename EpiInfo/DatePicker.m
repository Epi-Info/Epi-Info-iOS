//
//  DatePicker.m
//  EpiInfo
//
//  Created by John Copeland on 5/20/14.
//

#import "DatePicker.h"
#import "BlurryView.h"
#import "DateField.h"

@implementation DatePicker
@synthesize dateField = _dateField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSDate *dateObject = [NSDate date];
        dmy = ([[[dateObject descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[dateObject descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
        
        int month = (int)[[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:dateObject] month];
        int day = (int)[[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:dateObject] day];
        
        BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:bv];
        
        NSMutableArray *months = [NSMutableArray arrayWithArray:@[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"]];
        monthsLV = [[LegalValues alloc] initWithFrame:CGRectMake(10, 10, 200, 180) AndListOfValues:months NoFixedDimensions:YES];
        [monthsLV.picker selectRow:month - 1 inComponent:0 animated:NO];
        [monthsLV setPicked:[months objectAtIndex:month - 1]];
        [monthsLV setViewToAlertOfChanges:self];
        [bv addSubview:monthsLV];
        
        NSMutableArray *days = [[NSMutableArray alloc] init];
        for (int i = 1; i < 32; i++)
            [days addObject:[NSString stringWithFormat:@"%d", i]];
        daysLV = [[LegalValues alloc] initWithFrame:CGRectMake(10, 200, 140, 180) AndListOfValues:days NoFixedDimensions:YES];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [daysLV.picker setFrame:CGRectMake(0, 0, 140, 162)];
            [daysLV setListOfValues:days];
        }
        [daysLV.picker selectRow:day - 1 inComponent:0 animated:NO];
        [daysLV setPicked:[NSString stringWithFormat:@"%d", day]];
        [daysLV setViewToAlertOfChanges:self];
        [bv addSubview:daysLV];
        
        NSMutableArray *years = [[NSMutableArray alloc] init];
        for (int i = 1901; i < 2101; i++)
            [years addObject:[NSString stringWithFormat:@"%d", i]];
        yearsLV = [[LegalValues alloc] initWithFrame:CGRectMake(170, 200, 140, 180) AndListOfValues:years NoFixedDimensions:YES];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [yearsLV.picker setFrame:CGRectMake(0, 0, 140, 162)];
            [yearsLV setListOfValues:years];
        }
        [yearsLV.picker selectRow:[[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]] year] - 1901 inComponent:0 animated:NO];
        [yearsLV setPicked:[NSString stringWithFormat:@"%ld", (long)[[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]] year]]];
        [yearsLV setViewToAlertOfChanges:self];
        [bv addSubview:yearsLV];
        
        UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(bv.frame.size.width / 2.0 - 140, frame.size.height - 280, 120, 40)];
        [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
        [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [noButton.layer setMasksToBounds:YES];
        [noButton.layer setCornerRadius:4.0];
        [noButton addTarget:self action:@selector(removeSelfFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [bv addSubview:noButton];
        
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(bv.frame.size.width / 2.0 + 20, frame.size.height - 280, 120, 40)];
        [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
        [okButton setTitle:@"Okay" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [okButton.layer setMasksToBounds:YES];
        [okButton.layer setCornerRadius:4.0];
        [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [bv addSubview:okButton];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [monthsLV setFrame:CGRectMake(134, 40, 200, 180)];
            //      [daysLV.picker setFrame:CGRectMake(10, 10, 280, 160)];
            [daysLV setFrame:CGRectMake(344, 40, 140, 180)];
            [daysLV setListOfValues:days];
            //      [yearsLV.picker setFrame:CGRectMake(10, 10, 280, 160)];
            [yearsLV setFrame:CGRectMake(494, 40, 140, 180)];
            [yearsLV setListOfValues:years];
            
            [noButton setFrame:CGRectMake(noButton.frame.origin.x, 370, noButton.frame.size.width, noButton.frame.size.height)];
            [okButton setFrame:CGRectMake(okButton.frame.origin.x, 370, okButton.frame.size.width, okButton.frame.size.height)];
        }
        else
        {
            [monthsLV setFrame:CGRectMake(50, monthsLV.frame.origin.y, monthsLV.frame.size.width, monthsLV.frame.size.height)];
            [daysLV.picker setFrame:CGRectMake(0, 0, 140, 162)];
            [daysLV setFrame:CGRectMake(10, 200, 140, 180)];
            [yearsLV.picker setFrame:CGRectMake(10, 0, 120, 162)];
            [yearsLV setFrame:CGRectMake(170, 200, 140, 180)];
            
            [noButton setFrame:CGRectMake(noButton.frame.origin.x, 370, noButton.frame.size.width, noButton.frame.size.height)];
            [okButton setFrame:CGRectMake(okButton.frame.origin.x, 370, okButton.frame.size.width, okButton.frame.size.height)];
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame AndDateField:(UITextField *)dateField
{
    self = [self initWithFrame:frame];
    if (self)
    {
        [self setDateField:dateField];
        
        if (dateField.text.length > 0)
        {
            int indexOfFirstSlash = (int)[dateField.text rangeOfString:@"/"].location;
            int indexOfSecondSlash = (int)[[dateField.text substringFromIndex:indexOfFirstSlash + 1] rangeOfString:@"/"].location + indexOfFirstSlash + 1;
            int month = [[dateField.text substringToIndex:indexOfFirstSlash] intValue];
            int day = [[dateField.text substringWithRange:NSMakeRange(indexOfFirstSlash + 1, indexOfSecondSlash - indexOfFirstSlash - 1)] intValue];
            int year = [[dateField.text substringFromIndex:indexOfSecondSlash + 1] intValue];
            
            if (dmy)
            {
                int notthemonth = month;
                month = day;
                day = notthemonth;
            }
            
            [monthsLV.picker selectRow:month - 1 inComponent:0 animated:NO];
            [daysLV.picker selectRow:day - 1 inComponent:0 animated:NO];
            [daysLV setPicked:[NSString stringWithFormat:@"%d", day]];
            [yearsLV.picker selectRow:year - 1901 inComponent:0 animated:NO];
            [yearsLV setPicked:[NSString stringWithFormat:@"%d", year]];
            
            if (month == 1) [monthsLV setPicked:@"January"];
            else if (month == 2) [monthsLV setPicked:@"February"];
            else if (month == 3) [monthsLV setPicked:@"March"];
            else if (month == 4) [monthsLV setPicked:@"April"];
            else if (month == 5) [monthsLV setPicked:@"May"];
            else if (month == 6) [monthsLV setPicked:@"June"];
            else if (month == 7) [monthsLV setPicked:@"July"];
            else if (month == 8) [monthsLV setPicked:@"August"];
            else if (month == 9) [monthsLV setPicked:@"September"];
            else if (month == 10) [monthsLV setPicked:@"October"];
            else if (month == 11) [monthsLV setPicked:@"November"];
            else if (month == 12) [monthsLV setPicked:@"December"];
        }
    }
    UILabel *fieldLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0, self.frame.size.width - 16.0, 40.0)];
    [fieldLabelLabel setText:[(DateField *)dateField fieldLabel]];
    [fieldLabelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [self addSubview:fieldLabelLabel];
    return self;
}

- (void)okButtonPressed
{
    int month = (int)[monthsLV.picker selectedRowInComponent:0] + 1;
    int day = [daysLV.picked intValue];
    int year = [yearsLV.picked intValue];
    
    NSString *date = @"";
    
    if (dmy)
    {
        if (day < 10)
            date = @"0";
        date = [date stringByAppendingString:[NSString stringWithFormat:@"%d/", day]];
        if (month < 10)
            date = [date stringByAppendingString:@"0"];
        date = [date stringByAppendingString:[NSString stringWithFormat:@"%d/%d", month, year]];
    }
    else
    {
        if (month < 10)
            date = @"0";
        date = [date stringByAppendingString:[NSString stringWithFormat:@"%d/", month]];
        if (day < 10)
            date = [date stringByAppendingString:@"0"];
        date = [date stringByAppendingString:[NSString stringWithFormat:@"%d/%d", day, year]];
    }
    
    [self.dateField setText:date];
    
    [self removeSelfFromSuperview];
}

- (void)removeSelfFromSuperview
{
    CGRect finalFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFrame:finalFrame];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void)didChangeValueForKey:(NSString *)key
{
    if ([monthsLV.picked isEqualToString:@"April"] ||
        [monthsLV.picked isEqualToString:@"June"] ||
        [monthsLV.picked isEqualToString:@"September"] ||
        [monthsLV.picked isEqualToString:@"November"])
    {
        if ([daysLV.picker selectedRowInComponent:0] > 29)
        {
            [daysLV.picker selectRow:29 inComponent:0 animated:YES];
            [daysLV setPicked:[NSString stringWithFormat:@"%d", 30]];
        }
    }
    else if ([monthsLV.picked isEqualToString:@"February"])
    {
        if ([daysLV.picker selectedRowInComponent:0] > 28)
        {
            [daysLV.picker selectRow:28 inComponent:0 animated:YES];
            [daysLV setPicked:[NSString stringWithFormat:@"%d", 29]];
        }
        if ([yearsLV.picked intValue] % 4 > 0 || ([yearsLV.picked intValue] % 100 == 0 && [yearsLV.picked intValue] % 400 > 0))
            if ([daysLV.picker selectedRowInComponent:0] > 27)
            {
                [daysLV.picker selectRow:27 inComponent:0 animated:YES];
                [daysLV setPicked:[NSString stringWithFormat:@"%d", 28]];
            }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
