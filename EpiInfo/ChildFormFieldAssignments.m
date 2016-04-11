//
//  ChildFormFieldAssignments.m
//  EpiInfo
//
//  Created by John Copeland on 3/11/16.
//

#import "ChildFormFieldAssignments.h"
#import "EpiInfoControlProtocol.h"

@implementation ChildFormFieldAssignments

+ (void)parseForAssignStatements:(NSString *)checkCodeString parentForm:(EnterDataView *)parentForm childForm:(EnterDataView *)childForm relateButtonName:(NSString *)relateButtonName
{
    NSMutableArray *arrayOfLines = [[NSMutableArray alloc] init];
    
    NSString *ccs = [NSString stringWithString:checkCodeString];
    if ((int)[ccs rangeOfString:@"End-Before"].location > 0)
    {
        int nextSubstringLocation = 0;
        while ([ccs containsString:@"End-Before"])
        {
            nextSubstringLocation += (int)[ccs rangeOfString:@"End-Before"].location + 9;
            ccs = [ccs substringFromIndex:[ccs rangeOfString:@"Before"].location];
            ccs = [ccs substringToIndex:[ccs rangeOfString:@"End-Before"].location + 11];
            
            while ([ccs length] > 0)
            {
                [arrayOfLines addObject:[[ccs substringToIndex:[ccs rangeOfString:@"\n"].location] stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
                ccs = [ccs substringFromIndex:[ccs rangeOfString:@"\n"].location + 1];
                NSLog(@"%@", [arrayOfLines lastObject]);
            }
            
            for (int i = (int)[arrayOfLines count] - 1; i > -1; i--)
            {
                if ([(NSString *)[arrayOfLines objectAtIndex:i] isEqualToString:@"Before"] ||
                    [(NSString *)[arrayOfLines objectAtIndex:i] isEqualToString:@"End-Before"] ||
                    [[(NSString *)[arrayOfLines objectAtIndex:i] substringToIndex:2] isEqualToString:@"//"])
                {
                    [arrayOfLines removeObjectAtIndex:i];
                }
            }
            ccs = [checkCodeString substringFromIndex:nextSubstringLocation];
        }
        
        NSMutableArray *ifs = [[NSMutableArray alloc] init];
        NSMutableArray *nonIfs = [[NSMutableArray alloc] init];
        NSMutableArray *ifarray = nil;
        BOOL inAnIf = NO;
        for (int i = 0; i < [arrayOfLines count]; i++)
        {
            if ([[(NSString *)[arrayOfLines objectAtIndex:i] substringToIndex:2] isEqualToString:@"IF"] || inAnIf)
            {
                inAnIf = YES;
                if ([[(NSString *)[arrayOfLines objectAtIndex:i] substringToIndex:2] isEqualToString:@"IF"])
                {
                    ifarray = [[NSMutableArray alloc] init];
                }
                [ifarray addObject:[arrayOfLines objectAtIndex:i]];
                if ([(NSString *)[arrayOfLines objectAtIndex:i] isEqualToString:@"END-IF"])
                {
                    inAnIf = NO;
                    [ifs addObject:[NSArray arrayWithArray:ifarray]];
                }
            }
            else
            {
                [nonIfs addObject:[arrayOfLines objectAtIndex:i]];
            }
        }
        
        NSMutableArray *unconditionalAssigns = [[NSMutableArray alloc] init];
        for (int i = (int)[nonIfs count] - 1; i > -1; i--)
        {
            NSString *arrayObject = (NSString *)[nonIfs objectAtIndex:i];
            if ([[[arrayObject substringToIndex:[arrayObject rangeOfString:@" "].location] uppercaseString] isEqualToString:@"ASSIGN"])
            {
                [unconditionalAssigns addObject:[arrayObject substringFromIndex:7]];
                [nonIfs removeObjectAtIndex:i];
            }
        }
        NSLog(@"nonIfs:\n%@", nonIfs);
        
        NSDictionary *buttonClickAssignments = [self buttonClickAssignmentsFromParentForm:parentForm andButtonName:relateButtonName];
        NSLog(@"%@", buttonClickAssignments);
        
        NSDictionary *unconditionalAssignmentsDictionary = [self unconditionalAssignmentsDictionaryFromUnconditionalAssignsArray:unconditionalAssigns];
        NSLog(@"unconditionalAssigns in child form:\n%@", unconditionalAssignmentsDictionary);
        
       for (id key in unconditionalAssignmentsDictionary)
       {
           if ([[childForm dictionaryOfFields] objectForKey:key])
           {
               NSString *objectForKey = (NSString *)[unconditionalAssignmentsDictionary objectForKey:key];
               if ([buttonClickAssignments objectForKey:objectForKey])
               {
                   if ([[[childForm dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextField class]])
                   {
                       [(UITextField *)[[childForm dictionaryOfFields] objectForKey:key] setText:[buttonClickAssignments objectForKey:objectForKey]];
                   }
               }
               else
               {
                   if ([objectForKey containsString:@"&"] ||
                       ([objectForKey containsString:@"("] && [objectForKey containsString:@")"]))
                   {
                       if ([objectForKey containsString:@"("] && [objectForKey containsString:@")"])
                       {
                           if ([[objectForKey uppercaseString] rangeOfString:@"DAYS"].location == 0)
                           {
                               if ([[[childForm dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextField class]])
                               {
                                   [(UITextField *)[[childForm dictionaryOfFields] objectForKey:key] setText:[self timeBetweenTwoDates:objectForKey parentFormValues:buttonClickAssignments timeUnit:0]];
                               }
                           }
                           else if ([[objectForKey uppercaseString] rangeOfString:@"MONTHS"].location == 0)
                           {
                               if ([[[childForm dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextField class]])
                               {
                                   [(UITextField *)[[childForm dictionaryOfFields] objectForKey:key] setText:[self timeBetweenTwoDates:objectForKey parentFormValues:buttonClickAssignments timeUnit:1]];
                               }
                           }
                           else if ([[objectForKey uppercaseString] rangeOfString:@"YEARS"].location == 0)
                           {
                               if ([[[childForm dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextField class]])
                               {
                                   [(UITextField *)[[childForm dictionaryOfFields] objectForKey:key] setText:[self timeBetweenTwoDates:objectForKey parentFormValues:buttonClickAssignments timeUnit:2]];
                               }
                           }
                       }
                       else
                       {
                           
                       }
                   }
               }
           }
           else
           {
               for (id keyy in [childForm dictionaryOfPages])
               {
                   EnterDataView *endavi = (EnterDataView *)[[childForm dictionaryOfPages] objectForKey:keyy];
                   if ([[endavi dictionaryOfFields] objectForKey:key])
                   {
                       NSString *objectForKey = (NSString *)[unconditionalAssignmentsDictionary objectForKey:key];
                       if ([buttonClickAssignments objectForKey:objectForKey])
                       {
                           if ([[[endavi dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextField class]])
                           {
                               [(UITextField *)[[endavi dictionaryOfFields] objectForKey:key] setText:[buttonClickAssignments objectForKey:objectForKey]];
                           }
                       }
                       else
                       {
                           if ([objectForKey containsString:@"&"] ||
                               ([objectForKey containsString:@"("] && [objectForKey containsString:@")"]))
                           {
                               if ([objectForKey containsString:@"("] && [objectForKey containsString:@")"])
                               {
                                   if ([[objectForKey uppercaseString] rangeOfString:@"DAYS"].location == 0)
                                   {
                                       if ([[[endavi dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextField class]])
                                       {
                                           [(UITextField *)[[endavi dictionaryOfFields] objectForKey:key] setText:[self timeBetweenTwoDates:objectForKey parentFormValues:buttonClickAssignments timeUnit:0]];
                                       }
                                   }
                                   else if ([[objectForKey uppercaseString] rangeOfString:@"MONTHS"].location == 0)
                                   {
                                       if ([[[endavi dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextField class]])
                                       {
                                           [(UITextField *)[[endavi dictionaryOfFields] objectForKey:key] setText:[self timeBetweenTwoDates:objectForKey parentFormValues:buttonClickAssignments timeUnit:1]];
                                       }
                                   }
                                   else if ([[objectForKey uppercaseString] rangeOfString:@"YEARS"].location == 0)
                                   {
                                       if ([[[endavi dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextField class]])
                                       {
                                           [(UITextField *)[[endavi dictionaryOfFields] objectForKey:key] setText:[self timeBetweenTwoDates:objectForKey parentFormValues:buttonClickAssignments timeUnit:2]];
                                       }
                                   }
                               }
                               else
                               {
                                   
                               }
                           }
                       }
                       break;
                   }
               }
           }
       }
    }
}

+ (NSDictionary *)unconditionalAssignmentsDictionaryFromUnconditionalAssignsArray:(NSArray *)unconditionalAssigns
{
    NSMutableDictionary *nsmd = [[NSMutableDictionary alloc] init];
    
    for (NSString *s in unconditionalAssigns)
    {
        int equalsLocation = (int)[s rangeOfString:@"="].location;
        if (equalsLocation > -1)
        {
            NSString *objectString = [s substringFromIndex:equalsLocation + 1];
            while ([objectString characterAtIndex:0] == ' ')
                objectString = [objectString substringFromIndex:1];
            NSString *keyString = [s substringToIndex:equalsLocation];
            while ([keyString characterAtIndex:[keyString length] - 1] == ' ')
                keyString = [keyString substringToIndex:[keyString length] - 1];
            [nsmd setObject:objectString forKey:keyString];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:nsmd];
}

+ (NSDictionary *)buttonClickAssignmentsFromParentForm:(EnterDataView *)parentForm andButtonName:(NSString *)relateButtonName
{
    NSMutableDictionary *nsmd = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *nsmd2 = [[NSMutableDictionary alloc] init];
    
    NSString *parentCheckCodeString = [NSString stringWithString:[parentForm formCheckCodeString]];
    if ((int)[parentCheckCodeString rangeOfString:[NSString stringWithFormat:@"Field %@", relateButtonName]].location > -1)
    {
        NSString *buttonCheckCodeString = [parentCheckCodeString substringFromIndex:(int)[parentCheckCodeString rangeOfString:[NSString stringWithFormat:@"Field %@", relateButtonName]].location];
        buttonCheckCodeString = [buttonCheckCodeString substringToIndex:(int)[buttonCheckCodeString rangeOfString:@"End-Field"].location + 10];
        buttonCheckCodeString = [buttonCheckCodeString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSMutableArray *arrayOfLines = [[NSMutableArray alloc] init];
        
        while ([buttonCheckCodeString length] > 0)
        {
            [arrayOfLines addObject:[buttonCheckCodeString substringToIndex:[buttonCheckCodeString rangeOfString:@"\n"].location]];
            buttonCheckCodeString = [buttonCheckCodeString substringFromIndex:[buttonCheckCodeString rangeOfString:@"\n"].location + 1];
            if ([(NSString *)[arrayOfLines lastObject] rangeOfString:@"ASSIGN"].location == 0)
            {
                int equalsLocation = (int)[(NSString *)[arrayOfLines lastObject] rangeOfString:@"="].location;
                [nsmd setObject:[(NSString *)[arrayOfLines lastObject] substringFromIndex:equalsLocation + 2] forKey:[[(NSString *)[arrayOfLines lastObject] substringFromIndex:7] substringToIndex:equalsLocation - 8]];
            }
        }
        
        for (id key in nsmd)
        {
            NSString *objectForKey = (NSString *)[nsmd objectForKey:key];
            if ([objectForKey containsString:@"&"] ||
                ([objectForKey containsString:@"("] && [objectForKey containsString:@")"]))
            {
                if (![objectForKey containsString:@"("] && ![objectForKey containsString:@")"])
                {
                    NSMutableArray *arrayOfAmpersandIndexes = [[NSMutableArray alloc] init];
                    int i = 0;
                    while (i < [objectForKey length])
                    {
                        if ([objectForKey characterAtIndex:i++] == '&')
                            [arrayOfAmpersandIndexes addObject:[NSNumber numberWithInt:i - 1]];
                    }
                    int startIndex = 0;
                    NSMutableString *valueString = [[NSMutableString alloc] init];
                    for (NSNumber *num in arrayOfAmpersandIndexes)
                    {
                        NSString *section = [[objectForKey substringToIndex:[num intValue]] substringFromIndex:startIndex];
                        while ([section characterAtIndex:0] == ' ')
                        {
                            section = [section substringFromIndex:1];
                        }
                        while ([section characterAtIndex:[section length] - 1] == ' ')
                        {
                            section = [section substringToIndex:[section length] - 1];
                        }
                        startIndex = [num intValue] + 1;
                        if ([[parentForm dictionaryOfFields] objectForKey:section])
                        {
                            if ([[[parentForm dictionaryOfFields] objectForKey:section] conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                            {
                                id <EpiInfoControlProtocol> epiInfoControl = [[parentForm dictionaryOfFields] objectForKey:section];
                                [valueString appendString:[epiInfoControl epiInfoControlValue]];
                            }
                        }
                        else
                        {
                            BOOL notFound = YES;
                            for (id keyy in [parentForm dictionaryOfPages])
                            {
                                if ([[(EnterDataView *)[[parentForm dictionaryOfPages] objectForKey:keyy] dictionaryOfFields] objectForKey:section])
                                {
                                    if ([[[(EnterDataView *)[[parentForm dictionaryOfPages] objectForKey:keyy] dictionaryOfFields] objectForKey:section] conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                                    {
                                        id <EpiInfoControlProtocol> epiInfoControl = [[(EnterDataView *)[[parentForm dictionaryOfPages] objectForKey:keyy] dictionaryOfFields] objectForKey:section];
                                        [valueString appendString:[epiInfoControl epiInfoControlValue]];
                                    }
                                    notFound = NO;
                                    break;
                                }
                            }
                            if (notFound)
                                [valueString appendString:[section stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
                        }
                    }
                    NSString *section = [objectForKey substringFromIndex:startIndex];
                    while ([section characterAtIndex:0] == ' ')
                    {
                        section = [section substringFromIndex:1];
                    }
                    while ([section characterAtIndex:[section length] - 1] == ' ')
                    {
                        section = [section substringToIndex:[section length] - 1];
                    }
                    if ([[parentForm dictionaryOfFields] objectForKey:[section stringByReplacingOccurrencesOfString:@" " withString:@""]])
                    {
                        if ([[[parentForm dictionaryOfFields] objectForKey:[section stringByReplacingOccurrencesOfString:@" " withString:@""]] conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                        {
                            id <EpiInfoControlProtocol> epiInfoControl = [[parentForm dictionaryOfFields] objectForKey:[section stringByReplacingOccurrencesOfString:@" " withString:@""]];
                            [valueString appendString:[epiInfoControl epiInfoControlValue]];
                        }
                    }
                    else
                    {
                        BOOL notFound = YES;
                        for (id keyy in [parentForm dictionaryOfPages])
                        {
                            if ([[(EnterDataView *)[[parentForm dictionaryOfPages] objectForKey:keyy] dictionaryOfFields] objectForKey:[section stringByReplacingOccurrencesOfString:@" " withString:@""]])
                            {
                                if ([[[(EnterDataView *)[[parentForm dictionaryOfPages] objectForKey:keyy] dictionaryOfFields] objectForKey:section] conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                                {
                                    id <EpiInfoControlProtocol> epiInfoControl = [[(EnterDataView *)[[parentForm dictionaryOfPages] objectForKey:keyy] dictionaryOfFields] objectForKey:[section stringByReplacingOccurrencesOfString:@" " withString:@""]];
                                    [valueString appendString:[epiInfoControl epiInfoControlValue]];
                                }
                                notFound = NO;
                                break;
                            }
                        }
                        if (notFound)
                            [valueString appendString:[section stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
                    }
                    [nsmd2 setObject:valueString forKey:key];
                }
            }
            else
            {
                if ([[parentForm dictionaryOfFields] objectForKey:objectForKey])
                    [nsmd2 setObject:[(EpiInfoTextField *)[[parentForm dictionaryOfFields] objectForKey:objectForKey] text] forKey:key];
                else
                {
                    for (id keyy in [parentForm dictionaryOfPages])
                    {
                        if ([[(EnterDataView *)[[parentForm dictionaryOfPages] objectForKey:keyy] dictionaryOfFields] objectForKey:objectForKey])
                        {
                            [nsmd2 setObject:[(EpiInfoTextField *)[[(EnterDataView *)[[parentForm dictionaryOfPages] objectForKey:keyy] dictionaryOfFields] objectForKey:objectForKey] text] forKey:key];
                            break;
                        }
                    }
                }
            }
        }
    }
    
    for (id keyy in [parentForm dictionaryOfPages])
    {
        EnterDataView *parentFormPage = (EnterDataView *)[[parentForm dictionaryOfPages] objectForKey:keyy];
        for (id key in [parentFormPage dictionaryOfFields])
        {
            if ([[[parentFormPage dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextField class]])
            {
                if (![nsmd2 objectForKey:key])
                    [nsmd2 setObject:[(UITextField *)[[parentFormPage dictionaryOfFields] objectForKey:key] text] forKey:key];
            }
            else if ([[[parentFormPage dictionaryOfFields] objectForKey:key] isKindOfClass:[Checkbox class]])
            {
                if (![nsmd2 objectForKey:key])
                    [nsmd2 setObject:[NSNumber numberWithBool:[(Checkbox *)[[parentFormPage dictionaryOfFields] objectForKey:key] value]] forKey:key];
            }
            else if ([[[parentFormPage dictionaryOfFields] objectForKey:key] isKindOfClass:[UITextView class]])
            {
                if (![nsmd2 objectForKey:key])
                    [nsmd2 setObject:[(UITextView *)[[parentFormPage dictionaryOfFields] objectForKey:key] text] forKey:key];
            }
            else if ([[[parentFormPage dictionaryOfFields] objectForKey:key] isKindOfClass:[LegalValues class]])
            {
                if (![nsmd2 objectForKey:key])
                    [nsmd2 setObject:[(LegalValues *)[[parentFormPage dictionaryOfFields] objectForKey:key] picked] forKey:key];
            }
            else if ([[[parentFormPage dictionaryOfFields] objectForKey:key] isKindOfClass:[YesNo class]])
            {
                if (![nsmd2 objectForKey:key])
                    [nsmd2 setObject:[(YesNo *)[[parentFormPage dictionaryOfFields] objectForKey:key] picked] forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:nsmd2];
}

+ (NSString *)timeBetweenTwoDates:(NSString *)checkCodeDaysFunction parentFormValues:(NSDictionary *)parentFormFields timeUnit:(int)timeUnit
{
    NSString *returnString = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    int openParenPosition = (int)[checkCodeDaysFunction rangeOfString:@"("].location;
    int closeParenPosition = (int)[checkCodeDaysFunction rangeOfString:@")"].location;
    int commaPosition = (int)[checkCodeDaysFunction rangeOfString:@","].location;
    
    NSString *startDate = [checkCodeDaysFunction substringWithRange:NSMakeRange(openParenPosition + 1, commaPosition - openParenPosition - 1)];
    NSString *endDate = [checkCodeDaysFunction substringWithRange:NSMakeRange(commaPosition + 1, closeParenPosition - commaPosition - 1)];
    
    while ([startDate characterAtIndex:0] == ' ')
        startDate = [startDate substringFromIndex:1];
    while ([startDate characterAtIndex:[startDate length] - 1] == ' ')
        startDate = [startDate substringToIndex:[startDate length] - 1];
    
    while ([endDate characterAtIndex:0] == ' ')
        endDate = [endDate substringFromIndex:1];
    while ([endDate characterAtIndex:[endDate length] - 1] == ' ')
        endDate = [endDate substringToIndex:[endDate length] - 1];
    
    NSDate *startNSDate = nil;
    NSDate *endNSDate = nil;
    
    if ([[startDate uppercaseString] isEqualToString:@"SYSTEMDATE"])
    {
        startNSDate = [NSDate date];
    }
    else
    {
        if ([parentFormFields objectForKey:startDate])
        {
            NSString *stringDate = [parentFormFields objectForKey:startDate];
            if (![stringDate containsString:@"/"])
                return @"";
            if ([stringDate characterAtIndex:2] == '/')
                [formatter setDateFormat:@"MM/dd/yyyy"];
            else
                [formatter setDateFormat:@"yyyy/MM/dd"];
            startNSDate = [formatter dateFromString:stringDate];
        }
        else
            return  @"";
    }
    
    if ([[endDate uppercaseString] isEqualToString:@"SYSTEMDATE"])
    {
        endNSDate = [NSDate date];
    }
    else
    {
        if ([parentFormFields objectForKey:endDate])
        {
            NSString *stringDate = [parentFormFields objectForKey:endDate];
            if (![stringDate containsString:@"/"])
                return @"";
            if ([stringDate characterAtIndex:2] == '/')
                [formatter setDateFormat:@"MM/dd/yyyy"];
            else
                [formatter setDateFormat:@"yyyy/MM/dd"];
            endNSDate = [formatter dateFromString:stringDate];
        }
        else
            return @"";
    }
    
    if (timeUnit == 0)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:startNSDate toDate:endNSDate options:0];
        returnString = [NSString stringWithFormat:@"%d", (int)[components day]];
    }
    else if (timeUnit == 1)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:startNSDate toDate:endNSDate options:0];
        returnString = [NSString stringWithFormat:@"%d", (int)[components month]];
    }
    else if (timeUnit == 2)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:startNSDate toDate:endNSDate options:0];
        returnString = [NSString stringWithFormat:@"%d", (int)[components year]];
    }
   
    return returnString;
}
@end
