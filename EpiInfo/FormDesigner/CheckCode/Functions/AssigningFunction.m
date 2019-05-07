//
//  AssigningFunction.m
//  EpiInfo
//
//  Created by John Copeland on 5/2/19.
//

#import "AssigningFunction.h"
#import "CheckCodeWriter.h"
#import "FormDesigner.h"
#import "FormElementObject.h"

@implementation AssigningFunction

- (void)addAfterFunction:(NSString *)function
{
    [(CheckCodeWriter *)ccWriter addAfterFunction:function];
}
- (void)addBeforeFunction:(NSString *)function
{
    [(CheckCodeWriter *)ccWriter addBeforeFunction:function];
}

- (id)initWithFrame:(CGRect)frame AndCallingButton:(nonnull UIButton *)cb
{
    self = [super initWithFrame:frame];
    if (self)
    {
        callingButton = cb;
        ccWriter = [[callingButton superview] superview];
        formDesigner = [ccWriter superview];
        
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
        
        fieldToAssignLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 64, frame.size.width - 16, 32)];
        [fieldToAssignLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [fieldToAssignLabel setTextAlignment:NSTextAlignmentLeft];
        [fieldToAssignLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [fieldToAssignLabel setText:@"Field to Populate:"];
        [self addSubview:fieldToAssignLabel];
        
        fieldToAssignSelected = [[UITextField alloc] init];
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
            if (fieldType == 1 ||
                fieldType == 3 ||
                fieldType == 4 ||
                fieldType == 5)
                [assignmentFields addObject:fieldName];
        }
        fieldToAssign = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 96, 300, 180) AndListOfValues:assignmentFields AndTextFieldToUpdate:fieldToAssignSelected];
        [fieldToAssign.picker selectRow:0 inComponent:0 animated:YES];
        [self addSubview:fieldToAssign];

        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0,
                                                                           self.frame.size.height - 48,
                                                                           self.frame.size.width / 2.0,
                                                                           32)];
        [closeButton setBackgroundColor:[UIColor whiteColor]];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
