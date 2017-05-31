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
        
        displayingAMonth = YES;
        displayingAYear = NO;
        displayingADecade = NO;
        
        int month = (int)[[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:dateObject] month];
        int day = (int)[[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:dateObject] day];
        int year = (int)[[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:dateObject] year];
        
        if ([self.dateField text].length > 0)
        {
            month = [[[self.dateField text] substringWithRange:NSMakeRange(0, 2)] intValue];
            day = [[[self.dateField text] substringWithRange:NSMakeRange(3, 2)] intValue];
            year = [[[self.dateField text] substringWithRange:NSMakeRange(6, 4)] intValue];
            if (dmy)
            {
                int dayactually = month;
                month = day;
                day = dayactually;
            }
        }
        
        NSString *wordMonth = [[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:month - 1];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width - 2.0, frame.size.height - 2.0)];
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
        [leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:leftButton];
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(topBar.frame.size.width - 40, 0, 40, 40)];
        [rightButton setTitleColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithRed:188/255.0 green:189/255.0 blue:191/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [rightButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [rightButton setTitle:@">" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:rightButton];
        
        monthButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, topBar.frame.size.width - 80, 40)];
        [monthButton setTitleColor:[UIColor colorWithRed:89/255.0 green:90/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [monthButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
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
            [dayButton setTag:i];
            [dayButton addTarget:self action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [daysGridBase addSubview:dayButton];
        }
        //
        
        // Construct the months grid
        //
        
        // Construct the years grid
        //
        
        [whiteView bringSubviewToFront:daysGridBase];
    }
    return self;
}

- (void)monthButtonPressed:(UIButton *)sender
{
    
}

- (void)leftButtonPressed:(UIButton *)sender
{
    
}

- (void)rightButtonPressed:(UIButton *)sender
{
    
}

- (void)dayButtonPressed:(UIButton *)sender
{
    NSLog(@"Day %ld pressed", (long)[sender tag]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
