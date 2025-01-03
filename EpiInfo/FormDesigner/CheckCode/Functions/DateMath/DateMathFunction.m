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
        
        beginDateLiteral = [[DateField alloc] initWithFrame:CGRectMake(8, beginDate.frame.origin.y + beginDate.frame.size.height - 16, 304, 40)];
        [beginDateLiteral setBorderStyle:UITextBorderStyleRoundedRect];
        [beginDateLiteral setEnabled:NO];
        [beginDateLiteral setHidden:YES];
        [self addSubview:beginDateLiteral];
        
        endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,
                                                                   beginDateLiteral.frame.origin.y + beginDateLiteral.frame.size.height,
                                                                   frame.size.width - 16,
                                                                   32)];
        [endDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [endDateLabel setTextAlignment:NSTextAlignmentLeft];
        [endDateLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [endDateLabel setText:@"End Date:"];
        [self addSubview:endDateLabel];
        
        endDateSelected = [[CETextField alloc] init];
        [endDateSelected addTarget:self action:@selector(myTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        endDate = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4,
                                                                       endDateLabel.frame.origin.y + endDateLabel.frame.size.height,
                                                                       300,
                                                                       180)
                                            AndListOfValues:assignmentFields AndTextFieldToUpdate:endDateSelected];
        [endDate.picker selectRow:0 inComponent:0 animated:YES];
        [self addSubview:endDate];
        
        endDateLiteral = [[DateField alloc] initWithFrame:CGRectMake(8, endDate.frame.origin.y + endDate.frame.size.height - 16, 304, 40)];
        [endDateLiteral setBorderStyle:UITextBorderStyleRoundedRect];
        [endDateLiteral setEnabled:NO];
        [endDateLiteral setHidden:YES];
        [self addSubview:endDateLiteral];
    }
    return self;
}

- (void)myTextFieldChanged:(UITextField *)textField
{
    if ([[textField text] isEqualToString:@"Literal Date"])
    {
        if (textField == beginDateSelected)
        {
            [beginDateLiteral setEnabled:YES];
            [beginDateLiteral setHidden:NO];
            [beginDateLiteral setPlaceholder:@"Tap to select literal date."];
        }
        else if (textField == endDateSelected)
        {
            [endDateLiteral setEnabled:YES];
            [endDateLiteral setHidden:NO];
            [endDateLiteral setPlaceholder:@"Tap to select literal date."];
        }
    }
    else
    {
        if (textField == beginDateSelected)
        {
            [beginDateLiteral setEnabled:NO];
            [beginDateLiteral setHidden:YES];
            [beginDateLiteral setPlaceholder:nil];
            [beginDateLiteral setText:@""];
        }
        else if (textField == endDateSelected)
        {
            [endDateLiteral setEnabled:NO];
            [endDateLiteral setHidden:YES];
            [endDateLiteral setPlaceholder:nil];
            [endDateLiteral setText:@""];
        }
    }
}

- (void)closeButtonPressed:(UIButton *)sender
{
    NSString *fieldToPopulate = [fieldToAssignSelected text];
    NSString *beginningDateString = [beginDateSelected text];
    NSString *endDateString = [endDateSelected text];
    NSString *beginningDateLiteralString = [beginDateLiteral text];
    NSString *endDateLiteralString = [endDateLiteral text];
    
    [super closeButtonPressed:sender];
    
    if ([[[sender titleLabel] text] isEqualToString:@"Cancel"])
    {
        if (functionBeingEdited != nil)
            if ([functionBeingEdited length] > 0)
                if (![existingFunctionsArray containsObject:functionBeingEdited])
                    [existingFunctionsArray addObject:functionBeingEdited];
        return;
    }
    else if ([[[sender titleLabel] text] isEqualToString:@"Delete"])
    {
        return;
    }

    if ([beginningDateString isEqualToString:@"Literal Date"])
        beginningDateString = beginningDateLiteralString;
    if ([endDateString isEqualToString:@"Literal Date"])
        endDateString = endDateLiteralString;
    if ([fieldToPopulate length] > 0 && [beginningDateString length] > 0 && [endDateString length] > 0)
    {
        NSString *assignStatement = [NSString stringWithFormat:@"ASSIGN %@ = %@(%@, %@)", fieldToPopulate, [[[callingButton titleLabel] text] uppercaseString], beginningDateString, endDateString];
        NSLog(@"%@", assignStatement);
        if ([callingButton.layer valueForKey:@"BeforeAfter"])
        {
            NSString *ba = [callingButton.layer valueForKey:@"BeforeAfter"];
            if ([ba isEqualToString:@"After"])
            {
                [self addAfterFunction:assignStatement];
            }
            else if ([ba isEqualToString:@"Before"])
            {
                [self addBeforeFunction:assignStatement];
            }
            else if ([ba isEqualToString:@"Click"])
            {
                [self addClickFunction:assignStatement];
            }
        }
    }
}

- (void)loadFunctionToEdit:(NSString *)function
{
    NSLog(@"\nDateMath object loading\n%@", function);
    [self addSubview:deleteButton];
    functionBeingEdited = [NSString stringWithString:function];
    [existingFunctionsArray removeObject:functionBeingEdited];
    NSArray *tokens = [function componentsSeparatedByString:@" "];
    NSString *fieldToPopulateString = [tokens objectAtIndex:1];
    NSString *dateMathFunction = [[[function stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"="] lastObject];
    int openParenLocation = (int)[dateMathFunction rangeOfString:@"("].location;
    int commaLocation = (int)[dateMathFunction rangeOfString:@","].location;
    int closeParenLocation = (int)[dateMathFunction rangeOfString:@")"].location;
    NSString *beginningDateString = @"";
    NSString *endDateString = @"";
    
    @try {
        beginningDateString = [dateMathFunction substringWithRange:NSMakeRange(openParenLocation + 1, commaLocation - openParenLocation - 1)];
        endDateString = [dateMathFunction substringWithRange:NSMakeRange(commaLocation + 1, closeParenLocation - commaLocation - 1)];
        
        if (![beginDate.listOfValues containsObject:beginningDateString])
        {
            if ([beginningDateString rangeOfString:@"/"].location > 0)
            {
                if ([beginningDateString length] > [beginningDateString rangeOfString:@"/"].location + 1)
                {
                    if ([[beginningDateString substringFromIndex:[beginningDateString rangeOfString:@"/"].location + 1] rangeOfString:@"/"].location > 0)
                    {
                        [beginDateLiteral setText:beginningDateString];
                        [beginDateLiteral setHidden:NO];
                        beginningDateString = @"Literal Date";
                    }
                }
            }
        }
        if (![endDate.listOfValues containsObject:endDateString])
        {
            if ([endDateString rangeOfString:@"/"].location > 0)
            {
                if ([endDateString length] > [endDateString rangeOfString:@"/"].location + 1)
                {
                    if ([[endDateString substringFromIndex:[endDateString rangeOfString:@"/"].location + 1] rangeOfString:@"/"].location > 0)
                    {
                        [endDateLiteral setText:endDateString];
                        [endDateLiteral setHidden:NO];
                        endDateString = @"Literal Date";
                    }
                }
            }
        }
    } @catch (NSException *exception) {
    } @finally {
    }

    @try {
        [endDate assignValue:endDateString];
    } @catch (NSException *exception) {
    } @finally {
    }
    [fieldToAssign assignValue:fieldToPopulateString];
    @try {
        [endDate assignValue:endDateString];
    } @catch (NSException *exception) {
    } @finally {
    }
    [beginDate assignValue:beginningDateString];
    @try {
        [endDate assignValue:endDateString];
    } @catch (NSException *exception) {
    } @finally {
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
