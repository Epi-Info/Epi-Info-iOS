//
//  FormFieldsLegalValues.m
//  EpiInfo
//
//  Created by John Copeland on 5/24/19.
//

#import "FormFieldsLegalValues.h"
#import "FormDesigner.h"

@implementation FormFieldsLegalValues

- (id)initWithFrame:(CGRect)frame AndFormDesigner:(UIView *)formDesigner AndTextFieldToUpdate:(UITextField *)tftu
{
    NSMutableArray *availableFields = [[NSMutableArray alloc] init];
    [availableFields addObject:@""];
    NSArray *formElementObjects = [(FormDesigner *)formDesigner formElementObjects];
    for (int i = 0; i < [formElementObjects count]; i++)
    {
        FormElementObject *feo = [formElementObjects objectAtIndex:i];
        if (![[feo FieldTagElements] containsObject:@"Name"] || ![[feo FieldTagElements] containsObject:@"FieldTypeId"])
            continue;
        int nameIndex = (int)[[feo FieldTagElements] indexOfObject:@"Name"];
        int typeIndex = (int)[[feo FieldTagElements] indexOfObject:@"FieldTypeId"];
        NSString *fieldName = [[feo FieldTagValues] objectAtIndex:nameIndex];
        int fieldType = [(NSString *)[[feo FieldTagValues] objectAtIndex:typeIndex] intValue];
        if (fieldType != 2 &&
            fieldType != 99)
            [availableFields addObject:fieldName];
    }
    self = [super initWithFrame:frame AndListOfValues:availableFields AndTextFieldToUpdate:tftu];
    return self;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [super pickerView:pickerView didSelectRow:row inComponent:component];
    [self.textFieldToUpdate sendActionsForControlEvents:UIControlEventEditingChanged];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
