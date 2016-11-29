//
//  CheckCodeParser.m
//  EpiInfo
//
//  Created by admin on 1/5/16.
//  Copyright © 2016 John Copeland. All rights reserved.
//
/*GIT*/

#import "CheckCodeParser.h"
#import "ElementPairsCheck.h"
#import "ConditionsModel.h"
#import "EnterDataView.h"


@implementation CheckCodeParser
@synthesize edv;

-(id)init
{
    if (self)
    {
        pageArray = [[NSMutableArray alloc]init];
        fieldArray = [[NSMutableArray alloc]init];
        allArray = [[NSMutableArray alloc]init];
        ifArray = [[NSMutableArray alloc]init];
        fieldPageArray = [[NSMutableArray alloc]init];
        conditionsArray = [[NSMutableArray alloc]init];
        check =[NSMutableString stringWithString:@""];
    }
    return self;
}
-(void)parseCheckCode:(NSString *)pcc
{
    [check appendString:pcc];
    [self removeComments];
}
#pragma mark removeComments&Spaces

-(void)removeComments
{
    [check replaceOccurrencesOfString:@"/\\*(?:.|[\\n\\r])*?\\*/" withString:@"" options:NSRegularExpressionSearch range:(NSRange){0,check.length}];
    [self removeSingle];
}

-(void)removeSingle
{
    [self replaceLinefeedCharsAfterAssigns];
    [check replaceOccurrencesOfString:@"//(.*?)\r?\n" withString:@"" options:NSRegularExpressionSearch range:(NSRange){0,check.length}];
    [self removeSpaces];
    
}

- (void)replaceLinefeedCharsAfterAssigns
{
    NSMutableArray *arrayOfAssignIndexes = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfLineFeedCharacters = [[NSMutableArray alloc] init];
    
    NSString *copyOfCheck = [NSString stringWithString:check];
    int addToIndex = 0;
    
    while ([copyOfCheck length] > 0)
    {
        if (![[copyOfCheck uppercaseString] containsString:@"ASSIGN"])
            break;
        
        int indexOfAssign = (int)[copyOfCheck rangeOfString:@"ASSIGN"].location;
        int indexOfLineFeed = (int)[[copyOfCheck substringFromIndex:indexOfAssign] rangeOfString:@"\n"].location;
        
        [arrayOfAssignIndexes addObject:[NSNumber numberWithInteger:indexOfAssign + addToIndex]];
        [arrayOfLineFeedCharacters addObject:[NSNumber numberWithInteger:indexOfLineFeed + indexOfAssign + addToIndex]];
        
        addToIndex += indexOfLineFeed + indexOfAssign;
        copyOfCheck = [copyOfCheck substringFromIndex:indexOfAssign + indexOfLineFeed];
    }
    
    for (int i = (int)arrayOfLineFeedCharacters.count - 1; i >= 0; i--)
    {
        [check replaceCharactersInRange:NSMakeRange([(NSNumber *)[arrayOfLineFeedCharacters objectAtIndex:i] intValue], 1) withString:@"<LINEFEED>"];
    }
}

-(void)removeSpaces
{
    NSString *squashed = [check stringByReplacingOccurrencesOfString:@"/\s\s+/g"//@"[ \\t]+"
                                                          withString:@" "
                                                             options:NSRegularExpressionSearch
                                                               range:NSMakeRange(0, check.length)];
    
    NSString *myFinal = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *myFinalAgain = [regex stringByReplacingMatchesInString:myFinal options:0 range:NSMakeRange(0, [myFinal length]) withTemplate:@"  "];
    myFinalAgain = [myFinalAgain stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    myFinalAgain = [myFinalAgain stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    myFinalAgain = [myFinalAgain stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    myFinalAgain = [myFinalAgain stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [check setString:@""];
    check = [myFinalAgain mutableCopy];
    //[check setString:[check lowercaseString]];
    NSLog(@"FinalString %@",check);
    [self getPage];
    [self getField];
}

-(void)getPage
{
    NSScanner *scanner = [NSScanner scannerWithString:check];
    [scanner scanUpToString:@"page " intoString:nil]; // Scan all characters before
    while(![scanner isAtEnd]) {
        NSString *substring = nil;
        [scanner scanString:@"page " intoString:nil]; // Scan the character
        if([scanner scanUpToString:@"end-page" intoString:&substring]) {
            substring = [[substring stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            [pageArray addObject:substring];
            //NSLog(@"%@",substring);
        }
        [scanner scanUpToString:@" page" intoString:nil]; // Scan all characters before next
    }
    
}

//Separate Field Elements

-(void)getField
{
    NSScanner *scanner = [NSScanner scannerWithString:check];
    [scanner scanUpToString:@"field " intoString:nil]; // Scan all characters before
    while(![scanner isAtEnd]) {
        NSString *substring = nil;
        [scanner scanString:@"field " intoString:nil]; // Scan the  character
        if([scanner scanUpToString:@"end-field" intoString:&substring]) {
            [fieldArray addObject:substring];
            // NSLog(@"Satya %@ field string",substring);
        }
        [scanner scanUpToString:@" field " intoString:nil]; // Scan all characters before next
    }
    
    [self BeforeAfter];
}
-(void)BeforeAfter
{
    NSString *beforeString;
    
    //    NSString *start = @"Before";
    //    NSString *end = @"End-Before";
    if (pageArray.count>0)
    {
        for (int i=0; i<pageArray.count; i++)
        {
            beforeString = [pageArray objectAtIndex:i];
            [self fetchBeforeAfter:@"before" end:@"end-before" parameter:beforeString from:@"page"];
            
        }
        for (int i=0; i<pageArray.count; i++)
        {
            beforeString = [pageArray objectAtIndex:i];
            [self fetchBeforeAfter:@"after" end:@"end-after" parameter:beforeString from:@"page"];
            
        }
        
    }
    if (fieldArray.count>0)
    {
        for (int i=0; i<fieldArray.count; i++)
        {
            beforeString = [fieldArray objectAtIndex:i];
            [self fetchBeforeAfter:@"before" end:@"end-before" parameter:beforeString from:@"field"];
            
            
        }
        for (int i=0; i<fieldArray.count; i++)
        {
            beforeString = [fieldArray objectAtIndex:i];
            [self fetchBeforeAfter:@"after" end:@"end-after" parameter:beforeString from:@"field"];
            
            
        }
        
    }
    [self getIfEnd];
    //[self getConditions];
}

-(void)getIfEnd
{
    NSString *beforeString;
    
    ElementPairsCheck *elePairs = [[ElementPairsCheck alloc]init];
    if (allArray.count>0) {
        for (int i=0; i<allArray.count; i++)
        {
            
            //change here to add parameter to track elements for page name or element name
            //If-EndIf
            elePairs = [allArray objectAtIndex:i];
            NSString *tmp = [[elePairs.name componentsSeparatedByString:@" "] objectAtIndex:0];
            if ([tmp isEqualToString:@"page"]) {
                if ([elePairs.condition isEqualToString:@"before"]) {
                    beforeString = elePairs.stringValue;
                    [self fetchIfEnd:@"if" end:@"end-if" parameter:beforeString from:@"pagebeforeif"];
                }
                else if ([elePairs.condition isEqualToString:@"after"])
                {
                    beforeString = elePairs.stringValue;
                    [self fetchIfEnd:@"if" end:@"end-if" parameter:beforeString from:@"pageafterif"];
                    
                }
            }
            else if ([elePairs.name containsString:@"field"]) {
                if ([elePairs.condition isEqualToString:@"before"]) {
                    beforeString = elePairs.stringValue;
                    [self fetchIfEnd:@"if" end:@"end-if" parameter:beforeString from:@"fieldbeforeif"];
                }
                else if ([elePairs.condition isEqualToString:@"after"])
                {
                    beforeString = elePairs.stringValue;
                    [self fetchIfEnd:@"if" end:@"end-if" parameter:beforeString from:@"fieldafterif"];
                    
                }
            }
        }
        
    }
    [self removeIfEnd];
    
}
-(void)removeIfEnd
{
    NSString *beforeString;
    NSString *from;
    NSString *cond;
    
    if (allArray.count>0)
    {
        for (int i=0; i<allArray.count; i++)
        {
            ElementPairsCheck *elePairs = [[ElementPairsCheck alloc]init];
            
            elePairs = [allArray objectAtIndex:i];
            beforeString = elePairs.stringValue;
            from = elePairs.name;
            cond = elePairs.condition;
            
            [self removeIfEndString:beforeString from:from condition:cond];
        }
        
    }
    
    [self getConditions];
}

-(void)fetchBeforeAfter:(NSString *)startValue end:(NSString *)endValue parameter:(NSString *)newParameter from:(NSString *)fromValue
{
    
    NSScanner *scanner = [NSScanner scannerWithString:newParameter];
    // open search
    [scanner scanUpToString:startValue intoString:nil];
    if (![scanner isAtEnd]) {
        [scanner scanString:startValue intoString:nil];
        // close search
        NSString *tag = nil;
        [scanner scanUpToString:endValue intoString:&tag];
        if (![scanner isAtEnd]) {
            //NSLog(@"Tag found : %@", tag);
            ElementPairsCheck *elePairs = [[ElementPairsCheck alloc]init];
            NSString *conditionWord = [[newParameter componentsSeparatedByString:@" "] objectAtIndex:0];
            NSString *conditionWordOne = [[newParameter componentsSeparatedByString:@" "] objectAtIndex:1];
            conditionWordOne = [conditionWordOne stringByReplacingOccurrencesOfString:@"]" withString:@""];
            if ([startValue isEqualToString:@"before"] && [fromValue isEqualToString:@"page"])
            {
                elePairs.name = [NSString stringWithFormat:@"page %@ %@",conditionWord,conditionWordOne];
                elePairs.condition = @"before";
                elePairs.stringValue = tag;
                [allArray addObject:elePairs];
                
            }
            
            else if([startValue isEqualToString:@"after"] && [fromValue isEqualToString:@"page"])
            {
                elePairs.name = [NSString stringWithFormat:@"page %@ %@",conditionWord,conditionWordOne];;
                elePairs.condition = @"after";
                elePairs.stringValue = tag;
                [allArray addObject:elePairs];
            }
            
            else if([startValue isEqualToString:@"before"] && [fromValue isEqualToString:@"field"])
            {
                elePairs.name = [NSString stringWithFormat:@"field %@",conditionWord];;
                elePairs.condition = @"before";
                elePairs.stringValue = tag;
                [allArray addObject:elePairs];
            }
            
            else if([startValue isEqualToString:@"after"] && [fromValue isEqualToString:@"field"])
            {
                elePairs.name = [NSString stringWithFormat:@"field %@",conditionWord];
                elePairs.condition = @"after";
                elePairs.stringValue = tag;
                [allArray addObject:elePairs];
            }
        }
    }
}

-(void)fetchIfEnd:(NSString *)startValue end:(NSString *)endValue parameter:(NSString *)newParameter from:(NSString *)fromValue
{
    /*Expand method to capture page or elements details*/
    //If-EndIf
    NSScanner *scanner = [NSScanner scannerWithString:newParameter];
    [scanner scanUpToString:startValue intoString:nil]; // Scan all characters before
    while(![scanner isAtEnd]) {
        ElementPairsCheck *elePairs = [[ElementPairsCheck alloc]init];
        
        NSString *substring = nil;
        [scanner scanString:startValue intoString:nil]; // Scan the  character
        if([scanner scanUpToString:endValue intoString:&substring])
        {
            
            if ([fromValue isEqualToString:@"pageafterif"])
            {
                elePairs.name = @"pageafter";
                elePairs.condition = @"If";
                elePairs.stringValue = substring;
                [ifArray addObject:elePairs];
                
            }
            else if([fromValue isEqualToString:@"pagebeforeif"])
            {
                elePairs.name = @"pagebefore";
                elePairs.condition = @"If";
                elePairs.stringValue = substring;
                [ifArray addObject:elePairs];
            }
            else if([fromValue isEqualToString:@"fieldafterif"])
            {
                elePairs.name = @"fieldafter";
                elePairs.condition = @"If";
                elePairs.stringValue = substring;
                [ifArray addObject:elePairs];
            }
            else if([fromValue isEqualToString:@"fieldbeforeif"])
            {
                elePairs.name = @"fieldbefore";
                elePairs.condition = @"If";
                elePairs.stringValue = substring;
                [ifArray addObject:elePairs];
            }
            
        }
        [scanner scanUpToString:startValue intoString:nil]; // Scan all characters before next
    }
}

-(void)removeIfEndString:(NSString *)newString from:(NSString *)newFrom condition:(NSString *)newCondition
{
    if (ifArray.count>1) {
        
        
        for (int i=0; i<ifArray.count; i++)
        {
            ElementPairsCheck *elePair = [[ElementPairsCheck alloc]init];
            ElementPairsCheck *eleNewPairs = [[ElementPairsCheck alloc]init];
            
            elePair = [ifArray objectAtIndex:i];
            if ([elePair.condition isEqualToString:@"If"])
            {
                NSString *tmp = [NSString stringWithFormat:@"if %@end-if", elePair.stringValue];
                if ([elePair.name isEqualToString:@"pageafter"] )
                {
                    NSString *newStr = [newString stringByReplacingOccurrencesOfString:tmp withString:@""];
                    eleNewPairs.name = newFrom;
                    eleNewPairs.condition = newCondition;
                    eleNewPairs.stringValue = newStr;
                    [fieldPageArray addObject:eleNewPairs];
                    //   [edv.elementsArray addObject:eleNewPairs];
                    
                }
                else if ([elePair.name isEqualToString:@"pagebefore"] )
                {
                    NSString *newStr = [newString stringByReplacingOccurrencesOfString:tmp withString:@""];
                    eleNewPairs.name = newFrom;
                    eleNewPairs.condition = newCondition;
                    eleNewPairs.stringValue = newStr;
                    [fieldPageArray addObject:eleNewPairs];
                    //  [edv.elementsArray addObject:eleNewPairs];
                    
                }
                else if ([elePair.name isEqualToString:@"fieldafter"] )
                {
                    NSString *newStr = [newString stringByReplacingOccurrencesOfString:tmp withString:@""];
                    eleNewPairs.name = newFrom;
                    eleNewPairs.condition = newCondition;
                    eleNewPairs.stringValue = newStr;
                    
                    [fieldPageArray addObject:eleNewPairs];
                    // [edv.elementsArray addObject:eleNewPairs];
                    
                }
                else if ([elePair.name isEqualToString:@"fieldbefore"] )
                {
                    NSString *newStr = [newString stringByReplacingOccurrencesOfString:tmp withString:@""];
                    eleNewPairs.name = newFrom;
                    eleNewPairs.condition = newCondition;
                    
                    eleNewPairs.stringValue = newStr;
                    
                    [fieldPageArray addObject:eleNewPairs];
                    //[edv.elementsArray addObject:eleNewPairs];
                    
                }
                else
                {
                    eleNewPairs.name = newFrom;
                    eleNewPairs.condition = newCondition;
                    eleNewPairs.stringValue = elePair.stringValue;
                    
                    [fieldPageArray addObject:eleNewPairs];
                    // [edv.elementsArray addObject:eleNewPairs];
                    
                    
                }
            }
        }
        NSLog(@"####***%lu",fieldPageArray.count);
    }
    else
        fieldPageArray = allArray;
}
-(void)getConditions
{
    ElementPairsCheck *elePair = [[ElementPairsCheck alloc]init];
    //    edv.elementsArray = fieldPageArray;
    
    for (int i=0; i<fieldPageArray.count; i++)
    {
        elePair = [fieldPageArray objectAtIndex:i];
        NSString *tmp= [[elePair.stringValue componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString *conditionWord;
        NSString *conditionWordOne;
        NSUInteger count = [self numberOfWordsInString:elePair.name];
        conditionWord= [[elePair.name componentsSeparatedByString:@" "] objectAtIndex:0];
        if (count>1) {
            NSRange range = [elePair.name rangeOfString:conditionWord];
            conditionWordOne=[elePair.name stringByReplacingCharactersInRange:range withString:@""];
            conditionWordOne = [self removeSp:conditionWordOne];
            
            
        }
    }
    //  [edv copyToArray:fieldPageArray];
    
    
    //checking if it is not an if condition
    
    /*    if ([elePair.name containsString:@"page"])
     {
     if ([elePair.condition isEqualToString:@"before"])
     {
     [self getDisableString:elePair.stringValue from:conditionWord name:conditionWordOne befAfter:@"before"];
     
     
     }
     else if ([elePair.condition isEqualToString:@"after"])
     {
     [self getDisableString:elePair.stringValue from:conditionWord name:conditionWordOne befAfter:@"after"];
     }
     
     }
     else if ([elePair.name containsString:@"field"])
     {
     if ([elePair.condition isEqualToString:@"before"])
     {
     [self getDisableString:elePair.stringValue from:conditionWord name:conditionWordOne befAfter:@"before"];
     }
     else if ([elePair.condition isEqualToString:@"after"])
     {
     [self getDisableString:elePair.stringValue from:conditionWord name:conditionWordOne befAfter:@"after"];
     }
     
     }
     }*/
}

-(NSMutableArray *)sendArray
{
    if (fieldPageArray.count<1) {
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"checkcode"];
        [self parseCheckCode:savedValue];
    }
    return fieldPageArray;
}

//Calculate lengths of strings
- (NSUInteger)numberOfWordsInString:(NSString *)str {
    __block NSUInteger count = 0;
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length])
                            options:NSStringEnumerationByWords|NSStringEnumerationSubstringNotRequired
                         usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                             count++;
                         }];
    return count;
}

-(NSString *)removeSp:(NSString *)newStr
{
    NSString *tmp;
    
    tmp= [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return tmp;
    
}

@end
