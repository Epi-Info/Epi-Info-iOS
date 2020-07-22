//
//  EnableDisableClear.m
//  EpiInfo
//
//  Created by John Copeland on 5/13/19.
//

#import "EnableDisableClear.h"
#import "CheckCodeWriter.h"
#import "FormDesigner.h"
#import "FormElementObject.h"
#import "ExistingFunctionsListView.h"

@implementation EnableDisableClear

- (void)addAfterFunction:(NSString *)function
{
    [(CheckCodeWriter *)ccWriter addAfterFunction:function];
}
- (void)addBeforeFunction:(NSString *)function
{
    [(CheckCodeWriter *)ccWriter addBeforeFunction:function];
}
- (void)addClickFunction:(NSString *)function
{
    [(CheckCodeWriter *)ccWriter addClickFunction:function];
}

- (id)initWithFrame:(CGRect)frame AndCallingButton:(nonnull UIButton *)cb
{
    self = [super initWithFrame:frame];
    if (self)
    {
        callingButton = cb;
        ccWriter = [[callingButton superview] superview];
        formDesigner = [ccWriter superview];
        existingFunctions = NO;
        
        if ([[cb.layer valueForKey:@"BeforeAfter"] isEqualToString:@"After"])
        {
            if ([[(CheckCodeWriter *)ccWriter afterFunctions] count] > 0)
            {
                existingFunctions = YES;
                existingFunctionsArray = [(CheckCodeWriter *)ccWriter afterFunctions];
            }
        }
        else if ([[cb.layer valueForKey:@"BeforeAfter"] isEqualToString:@"Before"])
        {
            if ([[(CheckCodeWriter *)ccWriter beforeFunctions] count] > 0)
            {
                existingFunctions = YES;
                existingFunctionsArray = [(CheckCodeWriter *)ccWriter beforeFunctions];
            }
        }
        else if ([[cb.layer valueForKey:@"BeforeAfter"] isEqualToString:@"Click"])
        {
            if ([[(CheckCodeWriter *)ccWriter clickFunctions] count] > 0)
            {
                existingFunctions = YES;
                existingFunctionsArray = [(CheckCodeWriter *)ccWriter clickFunctions];
            }
        }
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 32)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [titleLabel setText:@"Assignment Function"];
        [self addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, frame.size.width, 32)];
        [subtitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [subtitleLabel setTextAlignment:NSTextAlignmentCenter];
        [subtitleLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [subtitleLabel setText:[NSString stringWithFormat:@"%@ %@", [cb.layer valueForKey:@"BeforeAfter"], [(CheckCodeWriter *)ccWriter beginFieldString]]];
        [self addSubview:subtitleLabel];
        
        fieldToAffectLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 64, frame.size.width - 16, 32)];
        [fieldToAffectLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [fieldToAffectLabel setTextAlignment:NSTextAlignmentLeft];
        [fieldToAffectLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [fieldToAffectLabel setText:[NSString stringWithFormat:@"Field to %@", [[cb titleLabel] text]]];
        [self addSubview:fieldToAffectLabel];
        
        fieldToAffectSelected = [[UITextField alloc] init];
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
            if (fieldType != 2 &&
                fieldType != 99)
                [assignmentFields addObject:fieldName];
        }
        fieldToAffect = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 96, 300, 180) AndListOfValues:assignmentFields AndTextFieldToUpdate:fieldToAffectSelected];
        [fieldToAffect.picker selectRow:0 inComponent:0 animated:YES];
        [self addSubview:fieldToAffect];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                          self.frame.size.height - 40,
                                                                          self.frame.size.width / 4.0,
                                                                          32)];
        [saveButton setBackgroundColor:[UIColor whiteColor]];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [saveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [saveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [saveButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4.0,
                                                                           self.frame.size.height - 40,
                                                                           self.frame.size.width / 4.0,
                                                                           32)];
        [closeButton setBackgroundColor:[UIColor whiteColor]];
        [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        existingFunctionsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0,
                                                                             self.frame.size.height - 40,
                                                                             self.frame.size.width / 4.0,
                                                                             32)];
        [existingFunctionsButton setBackgroundColor:[UIColor whiteColor]];
        [existingFunctionsButton setTitle:@"Edit" forState:UIControlStateNormal];
        [existingFunctionsButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [existingFunctionsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [existingFunctionsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [existingFunctionsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [existingFunctionsButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(3.0 * self.frame.size.width / 4.0,
                                                                  self.frame.size.height - 40,
                                                                  self.frame.size.width / 4.0,
                                                                  32)];
        [deleteButton setBackgroundColor:[UIColor whiteColor]];
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [deleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [deleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [deleteButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)closeButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[sender superview] setFrame:CGRectMake([sender superview].frame.origin.x, -[sender superview].frame.size.height, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
        [[sender superview] removeFromSuperview];
    }];
}

- (void)editButtonPressed:(UIButton *)sender
{
    NSMutableArray *relevantFunctionsArray = [[NSMutableArray alloc] init];
    if ([sender tag] == 362253)
    {
        for (int i = 0; i < [existingFunctionsArray count]; i++)
            if ([(NSString *)[existingFunctionsArray objectAtIndex:i] containsString:@"ENABLE "])
                [relevantFunctionsArray addObject:[existingFunctionsArray objectAtIndex:i]];
    }
    else if ([sender tag] == 3472253)
    {
        for (int i = 0; i < [existingFunctionsArray count]; i++)
            if ([(NSString *)[existingFunctionsArray objectAtIndex:i] containsString:@"DISABLE "])
                [relevantFunctionsArray addObject:[existingFunctionsArray objectAtIndex:i]];
    }
    else if ([sender tag] == 25327)
    {
        for (int i = 0; i < [existingFunctionsArray count]; i++)
            if ([(NSString *)[existingFunctionsArray objectAtIndex:i] containsString:@"CLEAR "])
                [relevantFunctionsArray addObject:[existingFunctionsArray objectAtIndex:i]];
    }
    ExistingFunctionsListView *eflv = [[ExistingFunctionsListView alloc] initWithFrame:CGRectMake(0,
                                                                                                  -self.frame.size.height,
                                                                                                  self.frame.size.width,
                                                                                                  self.frame.size.height)
                                                                     AndFunctionsArray:relevantFunctionsArray
                                                                             AndSender:sender];
    [self addSubview:eflv];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [eflv setFrame:CGRectMake(0, 0, eflv.frame.size.width, eflv.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)loadFunctionToEdit:(NSString *)function
{
    NSLog(@"\nEnableDisableClear object loading\n%@", function);
    [self addSubview:deleteButton];
    functionBeingEdited = [NSString stringWithString:function];
    [existingFunctionsArray removeObject:functionBeingEdited];
    NSArray *tokens = [function componentsSeparatedByString:@" "];
    NSString *fieldToPopulateString = [tokens objectAtIndex:1];
    
    @try {
        [fieldToAffect assignValue:fieldToPopulateString];
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
