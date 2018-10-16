//
//  EpiInfoCodesField.m
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//

#import "EpiInfoCodesField.h"

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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [super pickerView:pickerView didSelectRow:row inComponent:component];
    if (self.textColumnField)
        [self.textColumnField setText:[self.textColumnValues objectAtIndex:row]];
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
