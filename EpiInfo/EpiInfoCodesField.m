//
//  EpiInfoCodesField.m
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//

#import "EpiInfoCodesField.h"
#import "EnterDataView.h"

@implementation EpiInfoCodesField
@synthesize textColumnName = _textColumnName;
@synthesize textColumnField = _textColumnField;
@synthesize textColumnValues = _textColumnValues;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndDictionaryOfCodes:(NSMutableDictionary *)doc AndFieldName:(NSString *)fn
{
    [(NSMutableArray *)[doc objectForKey:fn] insertObject:@"" atIndex:0];
    self = [super initWithFrame:frame AndListOfValues:(NSMutableArray *)[doc objectForKey:fn]];
    linkedFields = [[NSMutableDictionary alloc] init];
    for (id key in doc)
    {
        if ([(NSString *)key isEqualToString:fn])
            continue;
        [linkedFields setObject:[doc objectForKey:key] forKey:key];
    }
    return self;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [super pickerView:pickerView didSelectRow:row inComponent:component];
    if (self.textColumnField)
        [self.textColumnField setText:[self.textColumnValues objectAtIndex:row]];
    if ([[[self superview] superview] isKindOfClass:[EnterDataView class]])
    {
        EnterDataView *edv = (EnterDataView *)[[self superview] superview];
        DictionaryOfFields *dof = [edv dictionaryOfFields];
        for (NSString *key in linkedFields)
        {
            NSString *val = @"";
            if (row > 0)
                val = [(NSArray *)[linkedFields objectForKey:key] objectAtIndex:row - 1];
            NSObject *v = [dof objectForKey:[key lowercaseString]];
            if ([v conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                [(id<EpiInfoControlProtocol>)v assignValue:val];
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
