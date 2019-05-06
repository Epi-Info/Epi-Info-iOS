//
//  DateMathFunction.m
//  EpiInfo
//
//  Created by John Copeland on 5/2/19.
//

#import "DateMathFunction.h"
#import "FormDesigner.h"

@implementation DateMathFunction

- (id)initWithFrame:(CGRect)frame AndCallingButton:(UIButton *)cb
{
    self = [super initWithFrame:frame AndCallingButton:cb];
    if (self)
    {
        CGRect fieldToAssignFrame = [fieldToAssign frame];
        
        beginDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,
                                                                   fieldToAssignFrame.origin.y + fieldToAssignFrame.size.height - 16,
                                                                   frame.size.width - 16,
                                                                   32)];
        [beginDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [beginDateLabel setTextAlignment:NSTextAlignmentLeft];
        [beginDateLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [beginDateLabel setText:@"Beginning Date:"];
        [self addSubview:beginDateLabel];
        
        beginDateSelected = [[CETextField alloc] init];
        [beginDateSelected addTarget:self action:@selector(myTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        NSMutableArray *assignmentFields = [[NSMutableArray alloc] init];
        [assignmentFields addObject:@""];
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
            if (fieldType == 7)
                [assignmentFields addObject:fieldName];
        }
        [assignmentFields addObject:@"SYSTEMDATE"];
        [assignmentFields addObject:@"Literal Date"];
        beginDate = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4,
                                                                       beginDateLabel.frame.origin.y + beginDateLabel.frame.size.height,
                                                                       300,
                                                                       180)
                                            AndListOfValues:assignmentFields AndTextFieldToUpdate:beginDateSelected];
        [beginDate.picker selectRow:0 inComponent:0 animated:YES];
        [self addSubview:beginDate];
        
        beginDateLiteral = [[DateField alloc] initWithFrame:CGRectMake(8, beginDate.frame.origin.y + beginDate.frame.size.height, 304, 40)];
        [beginDateLiteral setBorderStyle:UITextBorderStyleRoundedRect];
        [beginDateLiteral setEnabled:NO];
        [self addSubview:beginDateLiteral];
    }
    return self;
}

- (void)myTextFieldChanged:(UITextField *)textField
{
    NSLog(@"%@", [textField text]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
