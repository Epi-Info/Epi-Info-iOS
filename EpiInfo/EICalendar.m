//
//  EICalendar.m
//  EpiInfo
//
//  Created by John Copeland on 5/30/17.
//

#import "EICalendar.h"
#import "BlurryView.h"
#import "DateField.h"
#import "DatePicker.h"

@implementation EICalendar
@synthesize dateField = _dateField;
@synthesize datePickerView = _datePickerView;

- (id)initWithFrame:(CGRect)frame AndDateField:(UITextField *)dateField
{
    self = [self initWithFrame:frame];
    if (self)
    {
        [self setDateField:dateField];
        
        [self setBackgroundColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0]];
        
        NSDate *dateObject = [NSDate date];
        dmy = ([[[dateObject descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[dateObject descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
        
        displayingAMonth = YES;
        displayingAYear = NO;
        displayingADecade = NO;
        
        month = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:dateObject] month];
        day = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:dateObject] day];
        year = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateObject] year];
        
        if ([self.dateField text].length > 0)
        {
            int indexOfFirstSlash = (int)[dateField.text rangeOfString:@"/"].location;
            int indexOfSecondSlash = (int)[[dateField.text substringFromIndex:indexOfFirstSlash + 1] rangeOfString:@"/"].location + indexOfFirstSlash + 1;
            month = [[dateField.text substringToIndex:indexOfFirstSlash] intValue];
            day = [[dateField.text substringWithRange:NSMakeRange(indexOfFirstSlash + 1, indexOfSecondSlash - indexOfFirstSlash - 1)] intValue];
            year = [[dateField.text substringFromIndex:indexOfSecondSlash + 1] intValue];
            
            if (dmy)
            {
                int dayactually = month;
                month = day;
                day = dayactually;
            }
        }
        
        initialMonth = month;
        initialYear = year;
        
        NSString *wordMonth = [[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:((int)[[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:dateObject] month]) - 1];
        
        @try {
            wordMonth = [[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:month - 1];
        } @catch (NSException *exception) {
            int dayactually = month;
            month = day;
            day = dayactually;
            initialMonth = month;
            wordMonth = [[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:month - 1];
        } @finally {
        }
        
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width - 2.0, frame.size.height - 2.0)];
        [whiteView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:whiteView];
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.0];
        [whiteView.layer setMasksToBounds:YES];
        [whiteView.layer setCornerRadius:4.0];
        
        UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 40)];
        [whiteView addSubview:topBar];
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [leftButton setTitleColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor colorWithRed:188/255.0 green:189/255.0 blue:191/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [leftButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [leftButton setTitle:@"<" forState:UIControlStateNormal];
        [leftButton setAccessibilityLabel:@"Page backward"];
        [leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:leftButton];
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(topBar.frame.size.width - 40, 0, 40, 40)];
        [rightButton setTitleColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithRed:188/255.0 green:189/255.0 blue:191/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [rightButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [rightButton setTitle:@">" forState:UIControlStateNormal];
        [rightButton setAccessibilityLabel:@"Page forward"];
        [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:rightButton];
        
        monthButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, topBar.frame.size.width - 80, 40)];
        [monthButton setTitleColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [monthButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [monthButton addTarget:self action:@selector(monthButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:monthButton];
        
        [monthButton setTitle:[NSString stringWithFormat:@"%@ %d", wordMonth, year] forState:UIControlStateNormal];
        
        // Construct the days grid
        float widthOfDaysGridBase = whiteView.frame.size.width;
        float widthOfDaySquare = (widthOfDaysGridBase - 6.0) / 7.0;
        float heightOfDaysGridBase = widthOfDaySquare * 6.0 + 7.0;
        
        daysGridBase = [[UIView alloc] initWithFrame:CGRectMake(0, 40, widthOfDaysGridBase, heightOfDaysGridBase)];
        [daysGridBase setBackgroundColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0]];
        [whiteView addSubview:daysGridBase];
        
        float dayX = 0.0;
        float dayY = 1.0;
        for (int i = 0; i < 42; i++)
        {
            dayX += (widthOfDaySquare + 1.0);
            if (i % 7 == 0)
                dayX = 0.0;
            if (i == 7 || i == 14 || i == 21 || i == 28 || i == 35)
                dayY += (widthOfDaySquare + 1.0);
            float plus = 1.0;
            if (i == 0 || i == 7 || i == 14 || i == 21 || i == 28 || i == 35)
                plus = 0.0;
            UIButton *dayButton = [[UIButton alloc] initWithFrame:CGRectMake(dayX, dayY, widthOfDaySquare, widthOfDaySquare)];
            [dayButton setBackgroundColor:[UIColor whiteColor]];
            [dayButton setTitleColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [dayButton setTitleColor:[UIColor colorWithRed:188/255.0 green:189/255.0 blue:191/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [dayButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [dayButton setTag:i];
            [dayButton addTarget:self action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [daysGridBase addSubview:dayButton];
            
        }
        [self numberTheDayButtonsForMonth:month AndYear:year];
        //
        
        // Construct the months grid
        float widthOfMonthSquare = (widthOfDaysGridBase - 3.0) / 4.0;
        float heightOfMonthsGridBase = widthOfMonthSquare * 3.0 + 4.0;
        
        monthsGridBase = [[UIView alloc] initWithFrame:CGRectMake(0, 40, widthOfDaysGridBase, heightOfMonthsGridBase)];
        [monthsGridBase setBackgroundColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0]];
        [whiteView addSubview:monthsGridBase];
        
        float monthX = 0.0;
        float monthY = 1.0;
        for (int i = 0; i < 12; i++)
        {
            monthX += (widthOfMonthSquare + 1.0);
            if (i % 4 == 0)
                monthX = 0.0;
            if (i == 4 || i == 8)
                monthY += (widthOfMonthSquare + 1.0);
            float plus = 1.0;
            if (i == 0 || i == 4 || i == 8)
                plus = 0.0;
            UIButton *monButton = [[UIButton alloc] initWithFrame:CGRectMake(monthX, monthY, widthOfMonthSquare, widthOfMonthSquare)];
            [monButton setBackgroundColor:[UIColor whiteColor]];
            [monButton setTitleColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [monButton setTitleColor:[UIColor colorWithRed:188/255.0 green:189/255.0 blue:191/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [monButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
            [monButton setTag:i];
            [monButton addTarget:self action:@selector(monButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [monthsGridBase addSubview:monButton];
            
            NSString *wordMonth = [[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:i];
            [monButton setTitle:[NSString stringWithFormat:@"%@", wordMonth] forState:UIControlStateNormal];
        }
        //
        
        // Construct the years grid
        float widthOfYearSquare = (widthOfDaysGridBase - 4.0) / 5.0;
        float heightOfYearsGridBase = widthOfYearSquare * 2.0 + 3.0;
        
        yearsGridBase = [[UIView alloc] initWithFrame:CGRectMake(0, 40, widthOfDaysGridBase, heightOfYearsGridBase)];
        [yearsGridBase setBackgroundColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0]];
        [whiteView addSubview:yearsGridBase];
        
        float yearX = 0.0;
        float yearY = 1.0;
        for (int i = 0; i < 10; i++)
        {
            yearX += (widthOfYearSquare + 1.0);
            if (i % 5 == 0)
                yearX = 0.0;
            if (i == 5)
                yearY += (widthOfYearSquare + 1.0);
            float plus = 1.0;
            if (i == 0 || i == 5)
                plus = 0.0;
            UIButton *yearButton = [[UIButton alloc] initWithFrame:CGRectMake(yearX, yearY, widthOfYearSquare, widthOfYearSquare)];
            [yearButton setBackgroundColor:[UIColor whiteColor]];
            [yearButton setTitleColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [yearButton setTitleColor:[UIColor colorWithRed:188/255.0 green:189/255.0 blue:191/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [yearButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [yearButton setTag:i];
            [yearButton addTarget:self action:@selector(yearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [yearsGridBase addSubview:yearButton];
            
            int iterYear = (int)((float)year / 10) * 10 + i;
            [yearButton setTitle:[NSString stringWithFormat:@"%d", iterYear] forState:UIControlStateNormal];
        }
        //
        
        [whiteView bringSubviewToFront:daysGridBase];
    }
    return self;
}

- (void)numberTheDayButtonsForMonth:(int)methodmonth AndYear:(int)methodyear
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    [components setMonth:methodmonth];
    [components setYear:methodyear];
    NSDate *firstOfMonth = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:firstOfMonth];
    
//    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
//    [nsdf setDateFormat:@"EEEE"];
    
    int lastDayOfMonth = 31;
    if (methodmonth == 4 || methodmonth == 6 || methodmonth == 9 || methodmonth == 11)
        lastDayOfMonth = 30;
    else if (methodmonth == 2)
    {
        lastDayOfMonth = 28;
        if (methodyear % 4 == 0 && methodyear % 400 != 0)
            lastDayOfMonth = 29;
    }
    
//    NSLog(@"%d/1/%d is %@, which is day number %ld", methodmonth, methodyear, [nsdf stringFromDate:firstOfMonth], (long)[comps weekday]);
    
    int tagForFirstSquare = (int)[comps weekday] - 1;
    
    for (UIView *v in [daysGridBase subviews])
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            [(UIButton *)v setEnabled:YES];
            [(UIButton *)v setTitle:@"" forState:UIControlStateNormal];
            [v setBackgroundColor:[UIColor whiteColor]];
            if ([v tag] >= tagForFirstSquare && (int)[v tag] - tagForFirstSquare < lastDayOfMonth)
            {
                [(UIButton *)v setTitle:[NSString stringWithFormat:@"%d", (int)[v tag] + 1 - tagForFirstSquare] forState:UIControlStateNormal];
                if ((int)[v tag] + 1 - tagForFirstSquare == day && methodmonth == initialMonth && methodyear == initialYear)
                    [(UIButton *)v setBackgroundColor:[UIColor colorWithRed:188/255.0 green:189/255.0 blue:191/255.0 alpha:1.0]];
            }
            else
                [(UIButton *)v setEnabled:NO];
        }
    }
}

- (void)monthButtonPressed:(UIButton *)sender
{
    if (displayingAMonth)
    {
        [monthButton setTitle:[NSString stringWithFormat:@"%d", year] forState:UIControlStateNormal];
        [whiteView bringSubviewToFront:monthsGridBase];
        [daysGridBase setAlpha:0.0];
        displayingAMonth = NO;
        displayingAYear = YES;
    }
    
    else if (displayingAYear)
    {
        int firstYear = (int)((float)year / 10) * 10;
        int lastYear = (int)((float)year / 10) * 10 + 9;
        [monthButton setTitle:[NSString stringWithFormat:@"%d - %d", firstYear, lastYear] forState:UIControlStateNormal];
        [whiteView bringSubviewToFront:yearsGridBase];
        [monthsGridBase setAlpha:0.0];
        displayingADecade = YES;
        displayingAYear = NO;
    }
}

- (void)leftButtonPressed:(UIButton *)sender
{
    if (displayingAMonth)
    {
        month -= 1;
        if (month == 0)
        {
            month = 12;
            year -= 1;
        }
        NSString *wordMonth = [[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:month - 1];
        [monthButton setTitle:[NSString stringWithFormat:@"%@ %d", wordMonth, year] forState:UIControlStateNormal];
        [self numberTheDayButtonsForMonth:month AndYear:year];
    }
    else if (displayingAYear)
    {
        year -= 1;
        [monthButton setTitle:[NSString stringWithFormat:@"%d", year] forState:UIControlStateNormal];
    }
    else if (displayingADecade)
    {
        year -= 10;
        int firstYear = (int)((float)year / 10) * 10;
        int lastYear = (int)((float)year / 10) * 10 + 9;
        [monthButton setTitle:[NSString stringWithFormat:@"%d - %d", firstYear, lastYear] forState:UIControlStateNormal];
        
        for (UIView *v in [yearsGridBase subviews])
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                [(UIButton *)v setTitle:[NSString stringWithFormat:@"%d", firstYear + (int)[v tag]] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)rightButtonPressed:(UIButton *)sender
{
    if (displayingAMonth)
    {
        month += 1;
        if (month == 13)
        {
            month = 1;
            year += 1;
        }
        NSString *wordMonth = [[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:month - 1];
        [monthButton setTitle:[NSString stringWithFormat:@"%@ %d", wordMonth, year] forState:UIControlStateNormal];
        [self numberTheDayButtonsForMonth:month AndYear:year];
    }
    else if (displayingAYear)
    {
        year += 1;
        [monthButton setTitle:[NSString stringWithFormat:@"%d", year] forState:UIControlStateNormal];
    }
    else if (displayingADecade)
    {
        year += 10;
        int firstYear = (int)((float)year / 10) * 10;
        int lastYear = (int)((float)year / 10) * 10 + 9;
        [monthButton setTitle:[NSString stringWithFormat:@"%d - %d", firstYear, lastYear] forState:UIControlStateNormal];
        
        for (UIView *v in [yearsGridBase subviews])
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                [(UIButton *)v setTitle:[NSString stringWithFormat:@"%d", firstYear + (int)[v tag]] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)dayButtonPressed:(UIButton *)sender
{
    int thisday = [[[sender titleLabel] text] intValue];
    
    if (((DateField *)self.dateField).lower)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *selectedDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%d-%d-%d", year, month, thisday]];
        if ([selectedDate compare:((DateField *)self.dateField).lower] == NSOrderedAscending ||
            [selectedDate compare:((DateField *)self.dateField).upper] == NSOrderedDescending)
        {
            if (dmy)
                [dateFormat setDateFormat:@"yyyy-dd-MM"];
            UIAlertController *alertM = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"Date must be between %@ and %@.", [dateFormat stringFromDate:((DateField *)self.dateField).lower], [dateFormat stringFromDate:((DateField *)self.dateField).upper]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            [alertM addAction:okAction];
            [[((DatePicker *)self.datePickerView) rootViewController] presentViewController:alertM animated:YES completion:nil];
            return;
        }
    }
    
    NSString *date = @"";
    
    if (dmy)
    {
        if (thisday < 10)
            date = @"0";
        date = [date stringByAppendingString:[NSString stringWithFormat:@"%d/", thisday]];
        if (month < 10)
            date = [date stringByAppendingString:@"0"];
        date = [date stringByAppendingString:[NSString stringWithFormat:@"%d/%d", month, year]];
    }
    else
    {
        if (month < 10)
            date = @"0";
        date = [date stringByAppendingString:[NSString stringWithFormat:@"%d/", month]];
        if (thisday < 10)
            date = [date stringByAppendingString:@"0"];
        date = [date stringByAppendingString:[NSString stringWithFormat:@"%d/%d", thisday, year]];
    }
    
    for (UIView *v in [daysGridBase subviews])
        [v setBackgroundColor:[UIColor whiteColor]];
    
    [sender setBackgroundColor:[UIColor colorWithRed:188/255.0 green:189/255.0 blue:191/255.0 alpha:1.0]];
    
    [self.dateField setText:date];
    
    [(DatePicker *)self.datePickerView removeSelfFromSuperview];
}

- (void)monButtonPressed:(UIButton *)sender
{
    month = (int)[sender tag] + 1;
    [whiteView bringSubviewToFront:daysGridBase];
    [daysGridBase setAlpha:1.0];
    NSString *wordMonth = [[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:month - 1];
    [monthButton setTitle:[NSString stringWithFormat:@"%@ %d", wordMonth, year] forState:UIControlStateNormal];
    [self numberTheDayButtonsForMonth:month AndYear:year];
    displayingAYear = NO;
    displayingAMonth = YES;
}

- (void)yearButtonPressed:(UIButton *)sender
{
    displayingADecade = NO;
    displayingAYear = YES;
    year = [[[sender titleLabel] text] intValue];
    [monthButton setTitle:[NSString stringWithFormat:@"%d", year] forState:UIControlStateNormal];
    [whiteView bringSubviewToFront:monthsGridBase];
    [monthsGridBase setAlpha:1.0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
