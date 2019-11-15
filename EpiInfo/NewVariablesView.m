//
//  NewVariablesView.m
//  EpiInfo
//
//  Created by John Copeland on 8/9/13.
//  For CDC Epi Info.
//

#import "NewVariablesView.h"
#import "AnalysisViewController.h"
#import "DateMathFunctionInput.h"
#import "ConditionalAssignmentView.h"
#import "GroupOfVariablesInputs.h"

@implementation NewVariablesView
{
    AnalysisViewController *avc;
    SQLiteData *sqlData;
}

- (void)setListOfNewVariables:(NSMutableArray *)loav
{
    listOfNewVariables = loav;
    [newVariableList reloadData];
    for (NSString *str in loav)
    {
        NSString *justTheVariableName = [[str componentsSeparatedByString:@" = "] objectAtIndex:0];
        if (![listOfAllVariables containsObject:[justTheVariableName lowercaseString]])
            [listOfAllVariables addObject:[justTheVariableName lowercaseString]];
    }
}

- (void)addToListOfAllVariables:(NSString *)var
{
    [listOfAllVariables addObject:[var lowercaseString]];
    [newVariableName setText:@""];
    [selectVariableType reset];
    [selectVariableType setIsEnabled:NO];
    [selectFunction reset];
    [selectFunction setIsEnabled:NO];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(-frame.size.width, frame.origin.y, frame.size.width, frame.size.height)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //Add blueView and whiteView to create thin blue border line
            //Add all other views to whiteView
            UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
            [blueView setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [self addSubview:blueView];
            UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, blueView.frame.size.width - 4, blueView.frame.size.height - 4)];
            [whiteView setBackgroundColor:[UIColor whiteColor]];
            [blueView addSubview:whiteView];
            
            //The title of the view
            UILabel *viewMainTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 40)];
            [viewMainTitle setBackgroundColor:[UIColor clearColor]];
            [viewMainTitle setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [viewMainTitle setText:@"Add Variables"];
            [viewMainTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [viewMainTitle setTextAlignment:NSTextAlignmentCenter];
            [whiteView addSubview:viewMainTitle];
            
            //The label for the text field where the new variable name is entered
            NSString *newVariableNameLabelText = @"Variable Name:";
            UILabel *newVariableNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 40, [newVariableNameLabelText sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0]}].width, 28)];
            [newVariableNameLabel setBackgroundColor:[UIColor clearColor]];
            [newVariableNameLabel setText:newVariableNameLabelText];
            [newVariableNameLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [newVariableNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [whiteView addSubview:newVariableNameLabel];
            //The text field where the new variable name is entered
            newVariableName = [[UITextField alloc] initWithFrame:CGRectMake(4, 68, 300, 40)];
            [newVariableName setBorderStyle:UITextBorderStyleRoundedRect];
            [newVariableName setReturnKeyType:UIReturnKeyDone];
            [newVariableName setDelegate:self];
            [newVariableName setAutocorrectionType:UITextAutocorrectionTypeNo];
            [newVariableName addTarget:self action:@selector(userTypedInNewVariableName:) forControlEvents:UIControlEventEditingChanged];
            [newVariableName setTag:700];
            [whiteView addSubview:newVariableName];
            
            UILabel *selectVariableTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 108, 256, 28)];
            [selectVariableTypeLabel setText:@"Variable Type:"];
            [selectVariableTypeLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [selectVariableTypeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [selectVariableTypeLabel setTextAlignment:NSTextAlignmentLeft];
            [whiteView addSubview:selectVariableTypeLabel];
            selectVariableType = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 136, 300, 180) AndListOfValues:[NSMutableArray arrayWithArray:@[@"", @"Number", @"Text", @"Yes/No", @"Group"]]];
            [selectVariableType setTag:701];
            [selectVariableType analysisStyle];
            [whiteView addSubview:selectVariableType];
            [selectVariableType setIsEnabled:NO];

            UILabel *selectFunctionLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 200, 256, 28)];
            [selectFunctionLabel setText:@"Assign Values Function:"];
            [selectFunctionLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [selectFunctionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [selectFunctionLabel setTextAlignment:NSTextAlignmentLeft];
            [whiteView addSubview:selectFunctionLabel];
            selectFunction = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 228, 300, 180) AndListOfValues:[NSMutableArray arrayWithArray:@[@"", @"Years difference between two dates", @"Months difference between two dates", @"Days difference between two dates"]]];
            [selectFunction setTag:702];
            [selectFunction analysisStyle];
            [whiteView addSubview:selectFunction];
            [selectFunction setIsEnabled:NO];
            
            listOfNewVariables = [[NSMutableArray alloc] init];
            [listOfNewVariables addObject:@""];
            newVariableList = [[UITableView alloc] initWithFrame:CGRectMake(newVariableName.frame.origin.x, selectFunction.frame.origin.y + 1.7 * newVariableName.frame.size.height + 4.0, newVariableName.frame.size.width, 2.4 * newVariableName.frame.size.height)];
            [newVariableList setDelegate:self];
            [newVariableList setDataSource:self];
            [whiteView addSubview:newVariableList];

            //Button to remove this view and return to the main analysis view
            float side = 40;
            UIButton *hideSelfButton = [[UIButton alloc] initWithFrame:CGRectMake(4, whiteView.frame.size.height - side - 4, side, side)];
            [hideSelfButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [hideSelfButton.layer setCornerRadius:2];
            [hideSelfButton setTitle:@"<<<" forState:UIControlStateNormal];
            [hideSelfButton setAccessibilityLabel:@"Save variables and return to analysis screen"];
            [hideSelfButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            [hideSelfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [hideSelfButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [hideSelfButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:hideSelfButton];

            [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
                [self setFrame:frame];
            }completion:nil];
        }
        else
        {
            //Add blueView and whiteView to create thin blue border line
            //Add all other views to whiteView
            UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
            [blueView setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [self addSubview:blueView];
            UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, blueView.frame.size.width - 4, blueView.frame.size.height - 4)];
            [whiteView setBackgroundColor:[UIColor whiteColor]];
            [blueView addSubview:whiteView];
            
            //The title of the view
            UILabel *viewMainTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 40)];
            [viewMainTitle setBackgroundColor:[UIColor clearColor]];
            [viewMainTitle setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [viewMainTitle setText:@"Add Variables"];
            [viewMainTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [viewMainTitle setTextAlignment:NSTextAlignmentCenter];
            [whiteView addSubview:viewMainTitle];
            
            //The label for the text field where the new variable name is entered
            NSString *newVariableNameLabelText = @"Variable Name:";
            UILabel *newVariableNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 40, [newVariableNameLabelText sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0]}].width, 28)];
            [newVariableNameLabel setBackgroundColor:[UIColor clearColor]];
            [newVariableNameLabel setText:newVariableNameLabelText];
            [newVariableNameLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [newVariableNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [whiteView addSubview:newVariableNameLabel];
            //The text field where the new variable name is entered
            newVariableName = [[UITextField alloc] initWithFrame:CGRectMake(4, 68, 300, 40)];
            [newVariableName setBorderStyle:UITextBorderStyleRoundedRect];
            [newVariableName setReturnKeyType:UIReturnKeyDone];
            [newVariableName setDelegate:self];
            [newVariableName setAutocorrectionType:UITextAutocorrectionTypeNo];
            [newVariableName addTarget:self action:@selector(userTypedInNewVariableName:) forControlEvents:UIControlEventEditingChanged];
            [newVariableName setTag:700];
            [whiteView addSubview:newVariableName];
            
            UILabel *selectVariableTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 108, 256, 28)];
            [selectVariableTypeLabel setText:@"Variable Type:"];
            [selectVariableTypeLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [selectVariableTypeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [selectVariableTypeLabel setTextAlignment:NSTextAlignmentLeft];
            [whiteView addSubview:selectVariableTypeLabel];
            selectVariableType = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 136, 300, 180) AndListOfValues:[NSMutableArray arrayWithArray:@[@"", @"Number", @"Text", @"Yes/No", @"Group"]]];
            [selectVariableType setTag:701];
            [selectVariableType analysisStyle];
            [whiteView addSubview:selectVariableType];
            [selectVariableType setIsEnabled:NO];

            UILabel *selectFunctionLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 200, 256, 28)];
            [selectFunctionLabel setText:@"Assign Values Function:"];
            [selectFunctionLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [selectFunctionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [selectFunctionLabel setTextAlignment:NSTextAlignmentLeft];
            [whiteView addSubview:selectFunctionLabel];
            selectFunction = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 228, 300, 180) AndListOfValues:[NSMutableArray arrayWithArray:@[@"", @"Years difference between two dates", @"Months difference between two dates", @"Days difference between two dates"]]];
            [selectFunction setTag:702];
            [selectFunction analysisStyle];
            [whiteView addSubview:selectFunction];
            [selectFunction setIsEnabled:NO];
            
            listOfNewVariables = [[NSMutableArray alloc] init];
            [listOfNewVariables addObject:@""];
            newVariableList = [[UITableView alloc] initWithFrame:CGRectMake(newVariableName.frame.origin.x, selectFunction.frame.origin.y + 1.7 * newVariableName.frame.size.height + 4.0, newVariableName.frame.size.width, 2.4 * newVariableName.frame.size.height)];
            [newVariableList setDelegate:self];
            [newVariableList setDataSource:self];
            [whiteView addSubview:newVariableList];

            //Button to remove this view and return to the main analysis view
            float side = 40;
            UIButton *hideSelfButton = [[UIButton alloc] initWithFrame:CGRectMake(4, whiteView.frame.size.height - side - 4, side, side)];
            [hideSelfButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [hideSelfButton.layer setCornerRadius:2];
            [hideSelfButton setTitle:@"<<<" forState:UIControlStateNormal];
            [hideSelfButton setAccessibilityLabel:@"Save variables and return to analysis screen"];
            [hideSelfButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            [hideSelfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [hideSelfButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [hideSelfButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:hideSelfButton];

            [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
                [self setFrame:frame];
            }completion:nil];
        }
    }
    return self;
}

- (id)initWithViewController:(UIViewController *)vc
{
    self = [self initWithFrame:CGRectMake(0, 50, vc.view.frame.size.width, vc.view.frame.size.height - 50)];
    avc = (AnalysisViewController *)vc;
    listOfAllVariables = [[NSMutableArray alloc] init];
    for (NSString *str in [avc getSQLiteColumnNames])
        [listOfAllVariables addObject:[str lowercaseString]];
    return self;
}

- (id)initWithViewController:(UIViewController *)vc AndSQLiteData:(SQLiteData *)sqliteData
{
    self = [self initWithFrame:CGRectMake(0, 50, vc.view.frame.size.width, vc.view.frame.size.height - 50)];
    avc = (AnalysisViewController *)vc;
    sqlData = sqliteData;
    listOfAllVariables = [[NSMutableArray alloc] init];
    for (NSString *str in [avc getSQLiteColumnNames])
        [listOfAllVariables addObject:[str lowercaseString]];
    return self;
}

//This method is executed whenever the user types in the newVariableName field
- (void)userTypedInNewVariableName:(id)sender
{
    if ([(UITextField *)sender text].length > 0)
    {
        NSCharacterSet *validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789_qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
        if ([[[(UITextField *)sender text] stringByTrimmingCharactersInSet:validSet] length] > 0)
        {
            NSCharacterSet *invalidSet = [NSCharacterSet characterSetWithCharactersInString:[[(UITextField *)sender text] stringByTrimmingCharactersInSet:validSet]];
            NSString *compressedText = [[(UITextField *)sender text] stringByTrimmingCharactersInSet:invalidSet];
            [(UITextField *)sender setText:compressedText];
        }
        if ([listOfAllVariables containsObject:[[(UITextField *)sender text] lowercaseString]])
        {
            [(UITextField *)sender setTextColor:[UIColor redColor]];
            [selectVariableType setIsEnabled:NO];
            [selectFunction setIsEnabled:NO];
        }
        else
        {
            [(UITextField *)sender setTextColor:[UIColor blackColor]];
            [selectVariableType setIsEnabled:YES];
        }
    }
    else
    {
        [(UITextField *)sender setTextColor:[UIColor blackColor]];
        [selectVariableType reset];
        [selectFunction reset];
        [selectVariableType setIsEnabled:NO];
        [selectFunction setIsEnabled:NO];
    }
}

- (void)fieldResignedFirstResponder:(id)field
{
    if ([field tag] == 701)
    {
        if ([[(LegalValuesEnter *)field selectedIndex] intValue] > 0)
        {
            [selectFunction setIsEnabled:YES];
            if ([[(LegalValuesEnter *) field selectedIndex] intValue] == 3)
            {
                [selectFunction setListOfValues:[NSMutableArray arrayWithArray:@[@"", @"Conditional Assignment"]]];
                [selectFunction.tv reloadData];
            }
            else if ([[(LegalValuesEnter *) field selectedIndex] intValue] < 3)
            {
                [selectFunction setListOfValues:[NSMutableArray arrayWithArray:@[@"", @"Years difference between two dates", @"Months difference between two dates", @"Days difference between two dates"]]];
                [selectFunction.tv reloadData];
            }
            else if ([[(LegalValuesEnter *) field selectedIndex] intValue] == 4)
            {
                [selectFunction reset];
                [selectFunction setIsEnabled:NO];
                GroupOfVariablesInputs *govi = [[GroupOfVariablesInputs alloc] initWithFrame:CGRectMake(0, 0, [field superview].frame.size.width, [field superview].frame.size.height)];
                [[field superview] addSubview:govi];
                [govi setFunction:[(LegalValuesEnter *)field epiInfoControlValue]];
                [govi setAVC:avc];
            }
        }
        else
        {
            [selectFunction reset];
            [selectFunction setIsEnabled:NO];
        }
    }
    else if ([field tag] == 702)
    {
        if ([[(LegalValuesEnter *)field selectedIndex] intValue] > 0)
        {
            if ([[(LegalValuesEnter *)field epiInfoControlValue] containsString:@"difference between two dates"])
            {
                DateMathFunctionInput *dmfi = [[DateMathFunctionInput alloc] initWithFrame:CGRectMake(0, 0, [field superview].frame.size.width, [field superview].frame.size.height)];
                [[field superview] addSubview:dmfi];
                [dmfi setFunction:[(LegalValuesEnter *)field epiInfoControlValue]];
                [dmfi setNewVariableType:[selectVariableType epiInfoControlValue]];
                [dmfi setAVC:avc];
                [dmfi setNewVariableName:[newVariableName text]];
                [dmfi setListOfNewVariables:listOfNewVariables];
                [dmfi setNewVariableList:newVariableList];
            }
            else if ([[(LegalValuesEnter *)field epiInfoControlValue] containsString:@"Conditional Assignment"])
            {
                ConditionalAssignmentView *cav = [[ConditionalAssignmentView alloc] initWithFrame:CGRectMake(0, 0, [field superview].frame.size.width, [field superview].frame.size.height)];
                [[field superview] addSubview:cav];
                [cav setAnalysisViewController:avc];
                [cav setNewVariableType:[selectVariableType epiInfoControlValue]];
                [cav setNewVariableName:[newVariableName text]];
                [cav setListOfNewVariables:listOfNewVariables];
                [cav setNewVariableList:newVariableList];
            }
        }
    }
}

- (void)addButtonPressed
{
}

- (void)hideSelf
{
    [avc workingDataSetWithWhereClause:[avc workingDatasetWhereClause]];
    [avc setWorkingDataObject:[[AnalysisDataObject alloc] initWithWorkingDataset]];
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [self setFrame:CGRectMake(-self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    }completion:^(BOOL finished){[self removeSelfFromSuperview];}];
}

- (BOOL)removeSelfFromSuperview
{
    [self removeFromSuperview];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldChanged:(UITextField *)sender
{
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableIdentifier = @"dataline";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableIdentifier];
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height)];
        [cell setIndentationLevel:1];
        [cell setIndentationWidth:4];
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [bt setTag:1066];
        [bt setBackgroundColor:[UIColor clearColor]];
        [bt addTarget:self action:@selector(conditionDoubleTapped:) forControlEvents:UIControlEventTouchDownRepeat];
        [cell addSubview:bt];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [listOfNewVariables objectAtIndex:indexPath.row]]];
    UIButton *bt = (UIButton *)[cell viewWithTag:1066];
    if (bt)
        [bt setAccessibilityLabel:[NSString stringWithFormat:@"%@", [listOfNewVariables objectAtIndex:indexPath.row]]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [cell.textLabel setNumberOfLines:0];
    
    float fontSize = 16.0;
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfNewVariables count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)conditionDoubleTapped:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    NSString *lowercaseVariableName = [[[[[cell textLabel] text] lowercaseString] componentsSeparatedByString:@" = "] objectAtIndex:0];
    [listOfAllVariables removeObject:lowercaseVariableName];
    [listOfNewVariables removeObject:[[cell textLabel] text]];
    if ([listOfNewVariables count] == 0)
    {
        [listOfNewVariables addObject:@""];
    }
    [newVariableList reloadData];
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
