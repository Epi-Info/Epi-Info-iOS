//
//  NewVariablesView.m
//  EpiInfo
//
//  Created by John Copeland on 8/9/13.
//  For CDC Epi Info.
//

#import "NewVariablesView.h"
#import "AnalysisViewController.h"
#import "BlurryView.h"

@implementation NewVariablesView
{
    AnalysisViewController *avc;
    UIColor *epiInfoLightBlue;
    UIView *assignValuesFrame;
    
    SQLiteData *sqlData;
    
    int selectedVariableTypeNumber;
    UIView *variableTypePickerHolder;
    ShinyButton *chooseVariableTypeButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(-frame.size.width, frame.origin.y, frame.size.width, frame.size.height)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        epiInfoLightBlue = [UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //Add blueView and whiteView to create thin blue border line
            //Add all other views to whiteView
            UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
            [blueView setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [blueView.layer setCornerRadius:10.0];
            [self addSubview:blueView];
            UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, blueView.frame.size.width - 4, blueView.frame.size.height - 4)];
            [whiteView setBackgroundColor:[UIColor whiteColor]];
            [whiteView.layer setCornerRadius:8];
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
            selectVariableType = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 136, 300, 180) AndListOfValues:[NSMutableArray arrayWithArray:@[@"", @"Number", @"Text", @"Yes/No"]]];
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

            //View containing the subviews for assigning values to the new variable
            //Hidden until variable name is typed
            assignValuesFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 80, whiteView.frame.size.width, whiteView.frame.size.height - 80)];
            [assignValuesFrame setBackgroundColor:[UIColor whiteColor]];
            [assignValuesFrame.layer setCornerRadius:8.0];
            [assignValuesFrame setHidden:YES];
            [whiteView addSubview:assignValuesFrame];
            
            //The header label for the assign values view
            UILabel *assignValuesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 40)];
            [assignValuesLabel setBackgroundColor:[UIColor clearColor]];
            [assignValuesLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [assignValuesLabel setText:@"Assign Values"];
            [assignValuesLabel setTextAlignment:NSTextAlignmentCenter];
            [assignValuesLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [assignValuesFrame addSubview:assignValuesLabel];
            
            //Button to select data type
            chooseVariableTypeButton = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 40, assignValuesLabel.frame.size.width - 40, 30)];
            [chooseVariableTypeButton.layer setCornerRadius:10.0];
            [chooseVariableTypeButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [chooseVariableTypeButton setTitle:@"Variable Type" forState:UIControlStateNormal];
            [chooseVariableTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [chooseVariableTypeButton setTitleColor:epiInfoLightBlue forState:UIControlStateHighlighted];
            [chooseVariableTypeButton addTarget:self action:@selector(chooseVariableTypeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [assignValuesFrame addSubview:chooseVariableTypeButton];
            
            //Button to add the column
            ShinyButton *addButton = [[ShinyButton alloc] initWithFrame:CGRectMake(10, assignValuesFrame.frame.size.height - 90, assignValuesFrame.frame.size.width / 2.0 - 20, 40)];
            [addButton setTitle:@"Add" forState:UIControlStateNormal];
            [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [addButton setTitleColor:epiInfoLightBlue forState:UIControlStateHighlighted];
            [addButton.layer setCornerRadius:10.0];
            [addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [addButton setBackgroundColor:epiInfoLightBlue];
            [assignValuesFrame addSubview:addButton];
            
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

            selectedVariableTypeNumber = 2;

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
    return self;
}

- (id)initWithViewController:(UIViewController *)vc AndSQLiteData:(SQLiteData *)sqliteData
{
    self = [self initWithFrame:CGRectMake(0, 50, vc.view.frame.size.width, vc.view.frame.size.height - 50)];
    avc = (AnalysisViewController *)vc;
    sqlData = sqliteData;
    return self;
}

//This method is executed whenever the user types in the newVariableName field
- (void)userTypedInNewVariableName:(id)sender
{
    if ([(UITextField *)sender text].length > 0)
        [selectVariableType setIsEnabled:YES];
    else
    {
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
        }
        else
        {
            [selectFunction reset];
            [selectFunction setIsEnabled:NO];
        }
    }
}

- (void)addButtonPressed
{
    [sqlData addColumnToWorkingTable:newVariableName.text ColumnType:[NSNumber numberWithInt:selectedVariableTypeNumber]];
}

- (void)hideSelf
{
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

-(void)chooseVariableTypeButtonPressed
{
    [newVariableName resignFirstResponder];
    [newVariableName setEnabled:NO];
    if (selectedVariableTypeNumber == 2)
        [chooseVariableTypeButton setTitle:@"Variable Type: String" forState:UIControlStateNormal];
    
    variableTypePickerHolder = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, assignValuesFrame.frame.size.height)];
    [variableTypePickerHolder setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [[variableTypePickerHolder layer] setShadowOpacity:0.9];
    [[variableTypePickerHolder layer] setShadowOffset:CGSizeMake(0.0, 3.0)];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, variableTypePickerHolder.frame.size.width, 1)];
    [topLine setBackgroundColor:[UIColor darkGrayColor]];
    [variableTypePickerHolder addSubview:topLine];
    UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(0, variableTypePickerHolder.frame.size.height - 2, variableTypePickerHolder.frame.size.width, 1)];
    [botLine setBackgroundColor:[UIColor darkGrayColor]];
    [variableTypePickerHolder addSubview:botLine];
    
    ShinyButton *doneButton = [[ShinyButton alloc] initWithFrame:CGRectMake(variableTypePickerHolder.frame.size.width - 90, 4, 80, 40)];
    [doneButton.layer setCornerRadius:10.0];
    [doneButton.layer setMasksToBounds:YES];
    [doneButton.layer setBorderWidth:1];
    [doneButton setBackgroundColor:epiInfoLightBlue];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:epiInfoLightBlue forState:UIControlStateHighlighted];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(removeVariableTypePicker) forControlEvents:UIControlEventTouchUpInside];
    [variableTypePickerHolder addSubview:doneButton];
    [self addSubview:variableTypePickerHolder];

    UIPickerView *pickVariableType = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, variableTypePickerHolder.frame.size.width, 200)];
    [pickVariableType setTag:1];
    [pickVariableType setDelegate:self];
    [pickVariableType setDataSource:self];
    [pickVariableType setShowsSelectionIndicator:YES];
    [pickVariableType selectRow:selectedVariableTypeNumber inComponent:0 animated:NO];
    [variableTypePickerHolder addSubview:pickVariableType];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [variableTypePickerHolder setFrame:CGRectMake(0, assignValuesFrame.frame.origin.y, self.frame.size.width, assignValuesFrame.frame.size.height)];
    }completion:nil];
}
-(void)removeVariableTypePicker
{
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [variableTypePickerHolder setFrame:CGRectMake(assignValuesFrame.frame.origin.x, self.frame.size.height, assignValuesFrame.frame.size.width, assignValuesFrame.frame.size.height)];
    }completion:^(BOOL finished){[self destroyVariableTypePickerHolder];}];
}
-(void)destroyVariableTypePickerHolder
{
    for (UIView *v in [variableTypePickerHolder subviews])
    {
        [v removeFromSuperview];
    }
    [variableTypePickerHolder removeFromSuperview];
    variableTypePickerHolder = nil;
    [newVariableName setEnabled:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *values = [[NSArray alloc] initWithObjects:@"Integer", @"Decimal", @"String", @"Yes/No", nil];
    return [values objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [chooseVariableTypeButton setTitle:[NSString stringWithFormat:@"Variable Type: %@", [[NSArray arrayWithObjects:@"Integer", @"Decimal", @"String", @"Yes/No", nil] objectAtIndex:row]] forState:UIControlStateNormal];
    selectedVariableTypeNumber = (int)row;
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
    [listOfNewVariables removeObject:[[cell textLabel] text]];
    if ([listOfNewVariables count] > 0)
    {
        NSString *value0 = [listOfNewVariables objectAtIndex:0];
        NSArray *components = [value0 componentsSeparatedByString:@" "];
        NSString *component0 = [components objectAtIndex:0];
        if ([component0 isEqualToString:@"AND"])
            [listOfNewVariables setObject:[value0 substringFromIndex:4] atIndexedSubscript:0];
        else if ([component0 isEqualToString:@"OR"])
            [listOfNewVariables setObject:[value0 substringFromIndex:3] atIndexedSubscript:0];
    }
    else
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
