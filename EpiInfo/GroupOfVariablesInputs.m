//
//  GroupOfVariablesInputs.m
//  EpiInfo
//
//  Created by John Copeland on 11/15/19.
//

#import "GroupOfVariablesInputs.h"

@implementation GroupOfVariablesInputs
- (void)setAVC:(UIViewController *)uivc
{
    [super setAVC:uivc];
    NSArray *unsortedVariableNames = [(AnalysisViewController *)avc getSQLiteColumnNames];
    NSMutableArray *variableNamesNSMA = [[NSMutableArray alloc] init];
    [variableNamesNSMA addObject:@""];
    for (NSString *variable in unsortedVariableNames)
    {
        [variableNamesNSMA addObject:variable];
    }
    [variableNamesNSMA sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [variablesListLVE setListOfValues:variableNamesNSMA];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        variablesListLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
        [variablesListLabel setText:@"Select Variables in Group:"];
        [variablesListLabel setBackgroundColor:[UIColor whiteColor]];
        [variablesListLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [variablesListLabel setTextAlignment:NSTextAlignmentLeft];
        [variablesListLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [self addSubview:variablesListLabel];
        variablesListLVE = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(0, 0, 2, 2) AndListOfValues:[[NSMutableArray alloc] init]];
        [variablesListLVE setTag:201];
        [variablesListLVE analysisStyle];
        [self addSubview:variablesListLVE];
        
        arrayOfVariablesInGroup = [[NSMutableArray alloc] init];
        [arrayOfVariablesInGroup addObject:@""];
        variablesInGroupUITV = [[UITableView alloc] initWithFrame:CGRectMake(variablesListLVE.frame.origin.x, variablesListLVE.frame.origin.y + 1.8 * variablesListLVE.frame.size.height + 4.0, variablesListLVE.frame.size.width, 2.4 * variablesListLVE.frame.size.height)];
        [variablesInGroupUITV setDelegate:self];
        [variablesInGroupUITV setDataSource:self];
        [self addSubview:variablesInGroupUITV];

        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:frame];
        }completion:nil];
    }
    return self;
}

- (void)removeSelf:(UIButton *)sender
{
    [super removeSelf:sender];
    if ([[[sender titleLabel] text] isEqualToString:@"Save"])
    {
        NSMutableString *groupDeclaration = [[NSMutableString alloc] init];
        [groupDeclaration appendFormat:@"%@ = GROUP(%@", newVariableName, [arrayOfVariablesInGroup objectAtIndex:0]];
        for (int i = 1; i < [arrayOfVariablesInGroup count]; i++)
            [groupDeclaration appendFormat:@", %@", [arrayOfVariablesInGroup objectAtIndex:i]];
        [groupDeclaration appendString:@")"];
        [listOfNewVariables addObject:groupDeclaration];
        [newVariableList reloadData];
        [(NewVariablesView *)[[[newVariableList superview] superview] superview] addToListOfAllVariables:newVariableName];
    }
    else
    {
    }
}

- (void)fieldResignedFirstResponder:(id)field
{
    if ([field tag] == 201)
    {
        if ([[(LegalValuesEnter *)field selectedIndex] intValue] > 0)
        {
            if ([arrayOfVariablesInGroup containsObject:[(LegalValuesEnter *)field epiInfoControlValue]])
                return;
            [arrayOfVariablesInGroup addObject:[(LegalValuesEnter *)field epiInfoControlValue]];
            if ([arrayOfVariablesInGroup count] > 1 && [(NSString *)[arrayOfVariablesInGroup objectAtIndex:0] length] == 0)
                [arrayOfVariablesInGroup removeObjectAtIndex:0];
            [variablesInGroupUITV reloadData];
        }
    }
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
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [arrayOfVariablesInGroup objectAtIndex:indexPath.row]]];
    UIButton *bt = (UIButton *)[cell viewWithTag:1066];
    if (bt)
        [bt setAccessibilityLabel:[NSString stringWithFormat:@"%@", [arrayOfVariablesInGroup objectAtIndex:indexPath.row]]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [cell.textLabel setNumberOfLines:0];
    
    float fontSize = 16.0;
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfVariablesInGroup count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)conditionDoubleTapped:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    [arrayOfVariablesInGroup removeObject:[[cell textLabel] text]];
    if ([arrayOfVariablesInGroup count] == 0)
    {
        [arrayOfVariablesInGroup addObject:@""];
    }
    [variablesInGroupUITV reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
