//
//  ParseAssignment.m
//  EpiInfo
//
//  Created by John Copeland on 8/17/16.
//

#import "ParseAssignment.h"

@implementation ParseAssignment
+ (AssignmentModel *)parseAssign:(NSString *)statement
{
    AssignmentModel *am = [[AssignmentModel alloc] init];
    [am setInitialText:[NSString stringWithString:statement]];
 //   [self tokenize:am];
    return am;
}

+ (void)tokenize:(AssignmentModel *)am
{
    if ([am.initialText rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@")("]].location != NSNotFound)
    {
        if ([[am.initialText substringWithRange:NSMakeRange(0, 6)] isEqualToString:@"years("])
        {
            long closeParenthesisIndex = [self getIndexOfClosingParenthesisToParenthesisAtIndex:5 InString:am.initialText];
            if (closeParenthesisIndex == [am.initialText length] - (long)1)
            {
                [am setAm0:[[AssignmentModel alloc] init]];
                [am setAm1:[[AssignmentModel alloc] init]];
                int commaIndex = (int)[am.initialText rangeOfString:@","].location;
                [am.am0 setInitialText:[am.initialText substringWithRange:NSMakeRange(6, commaIndex - 6)]];
                while ([am.am0.initialText characterAtIndex:0] == ' ')
                    [am.am0 setInitialText:[am.am1.initialText substringFromIndex:1]];
                if (closeParenthesisIndex != NSNotFound)
                {
                    [am.am1 setInitialText:[am.initialText substringWithRange:NSMakeRange(commaIndex + 1, (int)closeParenthesisIndex - commaIndex - 1)]];
                    while ([am.am1.initialText characterAtIndex:0] == ' ')
                        [am.am1 setInitialText:[am.am1.initialText substringFromIndex:1]];
                }
                [am setInitialText:@"years"];
            }
        }
    }
}

+ (long)getIndexOfClosingParenthesisToParenthesisAtIndex:(int)openIndex InString:(NSString *)string
{
    long closeIndex = 0;
    
    if ([[string substringFromIndex:openIndex] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@")"]].location == NSNotFound)
        return NSNotFound;
    
    int additionalOpenParentheses = 0;
    while (YES)
    {
        openIndex++;
        if ([string characterAtIndex:openIndex] == ')')
        {
            if (additionalOpenParentheses == 0)
                return (long)openIndex;
            else
                additionalOpenParentheses--;
        }
        if ([string characterAtIndex:openIndex] == '(')
        {
            additionalOpenParentheses++;
        }
    }
    
    return closeIndex;
}
@end
