//
//  AnalysisFilterView.m
//  EpiInfo
//
//  Created by John Copeland on 8/8/13.
//

#import "AnalysisFilterView.h"
#import "AnalysisViewController.h"
#import "FrequencyObject.h"

@implementation AnalysisFilterView
{
    AnalysisViewController *avc;
}

- (void)setListOfValues:(NSMutableArray *)lov
{
    listOfValues = [NSMutableArray arrayWithArray:lov];
    [filterList reloadData];
    if ([lov count] > 0)
    {
        if ([(NSString *)[lov objectAtIndex:0] length] > 0)
        {
            if ([addFilterButton superview])
            {
                [[addFilterButton superview] addSubview:addWithAndButton];
                [[addFilterButton superview] addSubview:addWithOrButton];
                [addFilterButton removeFromSuperview];
            }
        }
    }
}

- (id)initWithFrameForSubclass:(CGRect)frame
{
    return [super initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.size.width, frame.origin.y, frame.size.width, frame.size.height)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //Add blueView and whiteView to create thin blue border line
        //Add all other views to whiteView
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
        [blueView setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [self addSubview:blueView];
        UIScrollView *whiteView = [[UIScrollView alloc] initWithFrame:CGRectMake(2, 2, blueView.frame.size.width - 4, blueView.frame.size.height - 4)];
        [whiteView setBackgroundColor:[UIColor whiteColor]];
        [blueView addSubview:whiteView];
        
        UILabel *selectVariableLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 256, 28)];
        [selectVariableLabel setText:@"Filter Variable:"];
        [selectVariableLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [selectVariableLabel setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:selectVariableLabel];
        selectVariable = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 32, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectVariable setTag:3401];
        [selectVariable analysisStyle];
        [whiteView addSubview:selectVariable];
        
        UILabel *selectOperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 96, 256, 28)];
        [selectOperatorLabel setText:@"Operator:"];
        [selectOperatorLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectOperatorLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [selectOperatorLabel setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:selectOperatorLabel];
        selectOperator = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 124, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectOperator setTag:3402];
        [selectOperator analysisStyle];
        [whiteView addSubview:selectOperator];
        [selectOperator setIsEnabled:NO];
        
        UILabel *selectValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 188, 256, 28)];
        [selectValueLabel setText:@"Value:"];
        [selectValueLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [selectValueLabel setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:selectValueLabel];
        selectValue = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 216, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectValue setTag:3403];
        [selectValue analysisStyle];
        typeTextValue = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(4, 216, 300, 40)];
        [typeTextValue setBorderStyle:UITextBorderStyleRoundedRect];
        [typeTextValue setDelegate:self];
        [typeTextValue setReturnKeyType:UIReturnKeyDone];
        [typeTextValue setTag:3404];
        typeNumberValue = [[NumberField alloc] initWithFrame:CGRectMake(4, 216, 300, 40)];
        [typeNumberValue setBorderStyle:UITextBorderStyleRoundedRect];
        [typeNumberValue setDelegate:self];
        [typeNumberValue setReturnKeyType:UIReturnKeyDone];
        [typeNumberValue setTag:3405];
        [whiteView addSubview:typeTextValue];
        [typeTextValue setIsEnabled:NO];
        
        listOfValues = [[NSMutableArray alloc] init];
        [listOfValues addObject:@""];
        filterList = [[UITableView alloc] initWithFrame:CGRectMake(typeNumberValue.frame.origin.x, typeNumberValue.frame.origin.y + 2.0 * typeNumberValue.frame.size.height + 4.0, typeNumberValue.frame.size.width, 2.4 * typeNumberValue.frame.size.height)];
        [filterList setDelegate:self];
        [filterList setDataSource:self];
        [whiteView addSubview:filterList];

        float side = 40;
        UIButton *hideSelfButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.frame.size.width - side - 4, whiteView.frame.size.height - side - 4, side, side)];
        [hideSelfButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [hideSelfButton.layer setCornerRadius:2];
        [hideSelfButton setTitle:@">>>" forState:UIControlStateNormal];
        [hideSelfButton setAccessibilityLabel:@"Save filters and return to analysis screen"];
        [hideSelfButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [hideSelfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [hideSelfButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [hideSelfButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:hideSelfButton];
        
        addFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(4, hideSelfButton.frame.origin.y, 2.5 * side, side)];
        [addFilterButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [addFilterButton.layer setCornerRadius:2];
        [addFilterButton setTitle:@"Add Filter" forState:UIControlStateNormal];
        [addFilterButton setAccessibilityLabel:@"Add, filter"];
        [addFilterButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [addFilterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addFilterButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [addFilterButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:addFilterButton];
        [addFilterButton setEnabled:NO];
        [addFilterButton setAlpha:0.5];
        
        addWithAndButton = [[UIButton alloc] initWithFrame:addFilterButton.frame];
        [addWithAndButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [addWithAndButton.layer setCornerRadius:2];
        [addWithAndButton setTitle:@"Add With AND" forState:UIControlStateNormal];
        [addWithAndButton setAccessibilityLabel:@"Add, with, and"];
        [addWithAndButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [addWithAndButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addWithAndButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [addWithAndButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
        [addWithAndButton setEnabled:NO];
        [addWithAndButton setAlpha:0.5];

        addWithOrButton = [[UIButton alloc] initWithFrame:CGRectMake(4 + 2.5 * side + 2, hideSelfButton.frame.origin.y, 2.5 * side, side)];
        [addWithOrButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [addWithOrButton.layer setCornerRadius:2];
        [addWithOrButton setTitle:@"Add With OR" forState:UIControlStateNormal];
        [addWithOrButton setAccessibilityLabel:@"Add, with, or"];
        [addWithOrButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [addWithOrButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addWithOrButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [addWithOrButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
        [addWithOrButton setEnabled:NO];
        [addWithOrButton setAlpha:0.5];

        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:frame];
        }completion:nil];
    }
    return self;
}

- (id)initWithViewController:(UIViewController *)vc
{
    self = [self initWithFrame:CGRectMake(0, 50, vc.view.frame.size.width, vc.view.frame.size.height - 50)];
    avc = (AnalysisViewController *)vc;
    
    unsortedVariableNames = [avc getSQLiteColumnNames];
    unsortedVariableTypes = [avc getSQLiteColumnTypes];
    
    NSMutableArray *variableNamesNSMA = [[NSMutableArray alloc] init];
    [variableNamesNSMA addObject:@""];
    for (NSString *variable in unsortedVariableNames)
    {
        [variableNamesNSMA addObject:variable];
    }
    [variableNamesNSMA sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [selectVariable setListOfValues:variableNamesNSMA];
    variablesLVESelectedIndex = 0;
    
    NSMutableArray *operatorsNSMA = [[NSMutableArray alloc] init];
    [operatorsNSMA addObject:@""];
    [selectOperator setListOfValues:operatorsNSMA];
    
    NSMutableArray *valuesNSMA = [[NSMutableArray alloc] init];
    [valuesNSMA addObject:@""];
    [selectValue setListOfValues:valuesNSMA];

    return self;
}

- (void)hideSelf
{
//    [avc setWorkingDataObject:[[AnalysisDataObject alloc] initWithAnalysisDataObject:[avc fullDataObject] AndTableName:[avc dataSourceName] AndFilters:listOfValues]];
    NSString *whereClause = [AnalysisDataObject buildWhereClauseFromFilters:listOfValues DataObject:[avc workingDataObject]];
    [avc workingDataSetWithWhereClause:whereClause];
    [avc setWorkingDataObjectListOfFilters:listOfValues];
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [self setFrame:CGRectMake(self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    }completion:^(BOOL finished){
        [self removeSelfFromSuperview];
        
    }];
}

- (void)addFilter:(UIButton *)sender
{
    [addFilterButton setEnabled:NO];
    [addFilterButton setAlpha:0.5];
    [addWithAndButton setEnabled:NO];
    [addWithAndButton setAlpha:0.5];
    [addWithOrButton setEnabled:NO];
    [addWithOrButton setAlpha:0.5];
    NSString *selectedValue = [selectValue epiInfoControlValue];
    if ([selectedValue isEqualToString:@"NULL"])
        selectedValue = @"";
    if ([[[sender titleLabel] text] isEqualToString:@"Add Filter"])
    {
        [listOfValues removeAllObjects];
        [listOfValues addObject:[[NSString stringWithFormat:@"%@ %@ %@ %@", [selectVariable epiInfoControlValue], [selectOperator epiInfoControlValue], selectedValue, [typeNumberValue epiInfoControlValue]] stringByReplacingOccurrencesOfString:@"  " withString:@" "]];
        [filterList reloadData];
        [[addFilterButton superview] addSubview:addWithAndButton];
        [[addFilterButton superview] addSubview:addWithOrButton];
        [addFilterButton removeFromSuperview];
    }
    else if ([[[sender titleLabel] text] containsString:@"AND"])
    {
        [listOfValues addObject:[[NSString stringWithFormat:@"AND %@ %@ %@ %@", [selectVariable epiInfoControlValue], [selectOperator epiInfoControlValue], selectedValue, [typeNumberValue epiInfoControlValue]] stringByReplacingOccurrencesOfString:@"  " withString:@" "]];
        [filterList reloadData];
    }
    else if ([[[sender titleLabel] text] containsString:@"OR"])
    {
        [listOfValues addObject:[[NSString stringWithFormat:@"OR %@ %@ %@ %@", [selectVariable epiInfoControlValue], [selectOperator epiInfoControlValue], selectedValue, [typeNumberValue epiInfoControlValue]] stringByReplacingOccurrencesOfString:@"  " withString:@" "]];
        [filterList reloadData];
    }
}

- (BOOL)removeSelfFromSuperview
{
    [self removeFromSuperview];
    return YES;
}

- (void)fieldResignedFirstResponder:(id)field
{
    if ([field tag] == 3401)
    {
        if ([[(LegalValuesEnter *)field selectedIndex] intValue] == variablesLVESelectedIndex)
            return;
        
        variablesLVESelectedIndex = [[(LegalValuesEnter *)field selectedIndex] intValue];
        [selectOperator reset];
        [selectValue reset];
        [typeNumberValue reset];
        [selectValue setIsEnabled:NO];
        [typeNumberValue setIsEnabled:NO];
        [selectValue removeFromSuperview];
        [typeNumberValue removeFromSuperview];
        [[selectVariable superview] addSubview:typeTextValue];
        [addFilterButton setEnabled:NO];
        [addFilterButton setAlpha:0.5];
        [addWithAndButton setEnabled:NO];
        [addWithAndButton setAlpha:0.5];
        [addWithOrButton setEnabled:NO];
        [addWithOrButton setAlpha:0.5];

        if ([[(LegalValuesEnter *)field selectedIndex] intValue] == 0)
        {
            [selectOperator setIsEnabled:NO];
            return;
        }
        
        NSString *selectedVariable = [(LegalValuesEnter *)field epiInfoControlValue];
//        int selectedVariableType = [[unsortedVariableTypes objectAtIndex:[unsortedVariableNames indexOfObject:selectedVariable]] intValue];
        NSNumber *indexNSN = (NSNumber *)[[avc getWorkingColumnNames] objectForKey:selectedVariable];
        NSNumber *isYesNo = (NSNumber *)[[avc getWorkingYesNo] objectForKey:indexNSN];
        NSNumber *isBinary = (NSNumber *)[[avc getWorkingBinary] objectForKey:indexNSN];
        NSNumber *isOneZero = (NSNumber *)[[avc getWorkingOneZero] objectForKey:indexNSN];
        NSNumber *isTrueFalse = (NSNumber *)[[avc getWorkingTrueFalse] objectForKey:indexNSN];
        NSNumber *columnType = (NSNumber *)[[avc getWorkingColumnTypes] objectForKey:indexNSN];
        if (!indexNSN && [[avc getSQLiteColumnNames] containsObject:selectedVariable])
        {
            columnType = [[avc getSQLiteColumnTypes] objectAtIndex:[[avc getSQLiteColumnNames] indexOfObject:selectedVariable]];
        }
        if ([columnType intValue] == 2 || [isYesNo boolValue] || [isOneZero boolValue] || [isTrueFalse boolValue] || [isBinary boolValue])
        {
            NSMutableArray *operatorsNSMA = [[NSMutableArray alloc] init];
            [operatorsNSMA addObject:@""];
            [operatorsNSMA addObject:@"is missing"];
            [operatorsNSMA addObject:@"is not missing"];
            [operatorsNSMA addObject:@"equals"];
            [operatorsNSMA addObject:@"is not equal to"];
            [selectOperator setListOfValues:operatorsNSMA];
            [typeTextValue removeFromSuperview];
            [typeNumberValue removeFromSuperview];
            [[selectVariable superview] addSubview:selectValue];
            
            FrequencyObject *fo = [avc getFrequencyObjectForVariable:selectedVariable];
            NSMutableArray *valuesNSMA = [NSMutableArray arrayWithArray:fo.variableValues];
            [valuesNSMA insertObject:@"" atIndex:0];
            [selectValue setListOfValues:valuesNSMA];
        }
        else
        {
            NSMutableArray *operatorsNSMA = [[NSMutableArray alloc] init];
            [operatorsNSMA addObject:@""];
            [operatorsNSMA addObject:@"is missing"];
            [operatorsNSMA addObject:@"is not missing"];
            [operatorsNSMA addObject:@"equals"];
            [operatorsNSMA addObject:@"is not equal to"];
            [operatorsNSMA addObject:@"is less than"];
            [operatorsNSMA addObject:@"is less than or equal to"];
            [operatorsNSMA addObject:@"is greater than"];
            [operatorsNSMA addObject:@"is greater than or equal to"];
            [selectOperator setListOfValues:operatorsNSMA];
            [typeTextValue removeFromSuperview];
            [selectValue removeFromSuperview];
            [[selectVariable superview] addSubview:typeNumberValue];
        }
        [selectOperator setIsEnabled:YES];
    }
    else if ([field tag] == 3402)
    {
        NSString *selectedOperator = [(LegalValuesEnter *)field epiInfoControlValue];
        if ([selectedOperator containsString:@"missing"] || [selectedOperator length] == 0 || [selectedOperator isEqualToString:@"NULL"])
        {
            [selectValue reset];
            [typeNumberValue reset];
            [selectValue setIsEnabled:NO];
            [typeNumberValue setIsEnabled:NO];
            if ([selectedOperator containsString:@"missing"])
            {
                [addFilterButton setEnabled:YES];
                [addFilterButton setAlpha:1.0];
                [addWithAndButton setEnabled:YES];
                [addWithAndButton setAlpha:1.0];
                [addWithOrButton setEnabled:YES];
                [addWithOrButton setAlpha:1.0];
            }
            else
            {
                [addFilterButton setEnabled:NO];
                [addFilterButton setAlpha:0.5];
                [addWithAndButton setEnabled:NO];
                [addWithAndButton setAlpha:0.5];
                [addWithOrButton setEnabled:NO];
                [addWithOrButton setAlpha:0.5];
            }
        }
        else
        {
            [selectValue reset];
            [typeNumberValue reset];
            [selectValue setIsEnabled:YES];
            [typeNumberValue setIsEnabled:YES];
            [addFilterButton setEnabled:NO];
            [addFilterButton setAlpha:0.5];
            [addWithAndButton setEnabled:NO];
            [addWithAndButton setAlpha:0.5];
            [addWithOrButton setEnabled:NO];
            [addWithOrButton setAlpha:0.5];
        }
    }
    else if ([field tag] > 3402)
    {
        [addFilterButton setEnabled:YES];
        [addFilterButton setAlpha:1.0];
        [addWithAndButton setEnabled:YES];
        [addWithAndButton setAlpha:1.0];
        [addWithOrButton setEnabled:YES];
        [addWithOrButton setAlpha:1.0];
        if ([field tag] > 3403)
        {
            if ([[[(UITextField *)field text] stringByReplacingOccurrencesOfString:@"." withString:@""] length] == 0)
            {
                [addFilterButton setEnabled:NO];
                [addFilterButton setAlpha:0.5];
                [addWithAndButton setEnabled:NO];
                [addWithAndButton setAlpha:0.5];
                [addWithOrButton setEnabled:NO];
                [addWithOrButton setAlpha:0.5];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self fieldResignedFirstResponder:textField];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [(UIScrollView *)[textField superview] setContentSize:CGSizeMake([textField superview].frame.size.width, [textField superview].frame.size.height)];
    } completion:^(BOOL finished){
//        hasAFirstResponder = NO;
    }];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    [(UIScrollView *)[textField superview] setContentSize:CGSizeMake([textField superview].frame.size.width, [textField superview].frame.size.height * 1.2)];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [(UIScrollView *)[textField superview] setContentOffset:CGPointMake(0, ((UIScrollView *)[textField superview]).contentSize.height - ((UIScrollView *)[textField superview]).bounds.size.height + ((UIScrollView *)[textField superview]).contentInset.bottom) animated:NO];
    } completion:^(BOOL finished){
        //        hasAFirstResponder = NO;
    }];
    return YES;
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
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [listOfValues objectAtIndex:indexPath.row]]];
    UIButton *bt = (UIButton *)[cell viewWithTag:1066];
    if (bt)
        [bt setAccessibilityLabel:[NSString stringWithFormat:@"%@", [listOfValues objectAtIndex:indexPath.row]]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [cell.textLabel setNumberOfLines:0];
    
    float fontSize = 16.0;
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfValues count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)conditionDoubleTapped:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    [listOfValues removeObject:[[cell textLabel] text]];
    if ([listOfValues count] > 0)
    {
        NSString *value0 = [listOfValues objectAtIndex:0];
        NSArray *components = [value0 componentsSeparatedByString:@" "];
        NSString *component0 = [components objectAtIndex:0];
        if ([component0 isEqualToString:@"AND"])
            [listOfValues setObject:[value0 substringFromIndex:4] atIndexedSubscript:0];
        else if ([component0 isEqualToString:@"OR"])
            [listOfValues setObject:[value0 substringFromIndex:3] atIndexedSubscript:0];
    }
    else
    {
        [listOfValues addObject:@""];
        if ([addWithAndButton superview])
        {
            [[addWithAndButton superview] addSubview:addFilterButton];
            [addWithAndButton removeFromSuperview];
            [addWithOrButton removeFromSuperview];
        }
    }
    [filterList reloadData];
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
