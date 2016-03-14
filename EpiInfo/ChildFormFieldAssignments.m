//
//  ChildFormFieldAssignments.m
//  EpiInfo
//
//  Created by John Copeland on 3/11/16.
//

#import "ChildFormFieldAssignments.h"

@implementation ChildFormFieldAssignments

+ (void)parseForAssignStatements:(NSString *)checkCodeString parentForm:(EnterDataView *)parentForm childForm:(EnterDataView *)childForm relateButtonName:(NSString *)relateButtonName
{
    NSMutableArray *arrayOfLines = [[NSMutableArray alloc] init];
    
    NSString *ccs = [NSString stringWithString:checkCodeString];
    
    if ([ccs rangeOfString:@"End-Before"].location > 0)
    {
        ccs = [ccs substringFromIndex:[ccs rangeOfString:@"Before"].location];
        ccs = [ccs substringToIndex:[ccs rangeOfString:@"End-Before"].location + 11];
        NSLog(@"ccs:\n%@\n\n%d", ccs, (int)[ccs rangeOfString:@"\n"].location);
        
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
        NSLog(@"%@", unconditionalAssigns);
        NSLog(@"%@", nonIfs);
        
        NSDictionary *buttonClickAssignments = [self buttonClickAssignmentsFromParentForm:parentForm andButtonName:relateButtonName];
        NSLog(@"%@", buttonClickAssignments);
    }
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
                        NSString *section = [[objectForKey substringToIndex:[num intValue] - 1] substringFromIndex:startIndex];
                        startIndex = [num intValue] + 1;
                        if ([[parentForm dictionaryOfFields] objectForKey:section])
                        {
                            [valueString appendString:[(EpiInfoTextField *)[[parentForm dictionaryOfFields] objectForKey:section] text]];
                        }
                        else
                        {
                            [valueString appendString:[section stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
                        }
                    }
                    NSString *section = [objectForKey substringFromIndex:startIndex];
                    if ([[parentForm dictionaryOfFields] objectForKey:[section stringByReplacingOccurrencesOfString:@" " withString:@""]])
                    {
                        [valueString appendString:[(EpiInfoTextField *)[[parentForm dictionaryOfFields] objectForKey:[section stringByReplacingOccurrencesOfString:@" " withString:@""]] text]];
                    }
                    else
                    {
                        [valueString appendString:[section stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
                    }
                    [nsmd2 setObject:valueString forKey:key];
                }
            }
            else
            {
                [nsmd2 setObject:[(EpiInfoTextField *)[[parentForm dictionaryOfFields] objectForKey:objectForKey] text] forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:nsmd2];
}
@end
