//
//  CommentLegal.m
//  EpiInfo
//
//  Created by John Copeland on 4/1/16.
//

#import "CommentLegal.h"
#import "EnterDataView.h"

@implementation CommentLegal

- (NSArray *)listOfStoredValues
{
    NSMutableArray *listOfStoredValues = [[NSMutableArray alloc] init];
    for (int i = 0; i < [listOfValues count]; i++)
    {
        NSString *stringAtIndex = [listOfValues objectAtIndex:i];
        if (![stringAtIndex containsString:@"-"])
        {
            [listOfStoredValues setObject:stringAtIndex atIndexedSubscript:i];
            continue;
        }
        int dashPlace = (int)[stringAtIndex rangeOfString:@"-"].location;
        NSString *storingValue = [self trimLeadingAndTrailingSpaces:[stringAtIndex substringToIndex:dashPlace]];
        [listOfStoredValues setObject:storingValue atIndexedSubscript:i];
    }
    return [NSArray arrayWithArray:listOfStoredValues];
}

- (NSString *)picked
{
    if ([picked.text length] == 0 || ![picked.text containsString:@"-"])
        return @"NULL";
    int dashPlace = (int)[picked.text rangeOfString:@"-"].location;
    return  [self trimLeadingAndTrailingSpaces:[picked.text substringToIndex:dashPlace]];
}
- (void)setPicked:(NSString *)pkd
{
    int i = 0;
    for (id item in listOfValues)
    {
        if (![(NSString *)item containsString:@"-"])
        {
            i++;
            continue;
        }
        int dashPlace = (int)[(NSString *)item rangeOfString:@"-"].location;
        NSString *itemString = [self trimLeadingAndTrailingSpaces:[(NSString *)item substringToIndex:dashPlace]];
        if ([(NSString *)itemString isEqualToString:pkd])
        {
            [picked setText:(NSString *)item];
            return;
        }
        i++;
    }
    [picked setText:pkd];
}

- (void)setSelectedLegalValue:(NSString *)selectedLegalValue
{
    int i = 0;
    for (id item in listOfValues)
    {
        if (![(NSString *)item containsString:@"-"])
        {
            i++;
            continue;
        }
        int dashPlace = (int)[(NSString *)item rangeOfString:@"-"].location;
        NSString *itemString = [self trimLeadingAndTrailingSpaces:[(NSString *)item substringToIndex:dashPlace]];
        if ([(NSString *)itemString isEqualToString:selectedLegalValue])
        {
            [self.picker selectRow:i inComponent:0 animated:NO];
            [self.textFieldToUpdate setText:(NSString *)item];
            NSIndexPath *nsip = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self.valueButton setTitle:[[[self.tv cellForRowAtIndexPath:nsip] textLabel] text] forState:UIControlStateNormal];
            return;
        }
        i++;
    }
    [super setSelectedLegalValue:selectedLegalValue];
}

- (NSString *)trimLeadingAndTrailingSpaces:(NSString *)stringToTrim
{
    while ([stringToTrim characterAtIndex:0] == ' ')
        stringToTrim = [stringToTrim substringFromIndex:1];
    while ([stringToTrim characterAtIndex:[stringToTrim length] - 1] == ' ')
        stringToTrim = [stringToTrim substringToIndex:[stringToTrim length] - 1];
    return stringToTrim;
}

- (void)assignValue:(NSString *)value
{
    if ([value isEqualToString:@""] || [value isEqualToString:@"NULL"])
    {
        [self reset];
        return;
    }
    [self setPicked:value];
    [self setSelectedLegalValue:value];
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
