//
//  VariableValueMapper.m
//  EpiInfo
//
//  Created by John Copeland on 1/27/20.
//

#import "VariableValueMapper.h"

@implementation VariableValueMapper

- (UITableView *)onesUITV
{
    return onesUITV;
}
- (UITableView *)zerosUITV
{
    return zerosUITV;
}

- (NSMutableArray *)onesNSMA
{
    return onesNSMA;
}
- (NSMutableArray *)zerosNSMA
{
    return zerosNSMA;
}

- (void)setWhiteY:(float)whiteY andValueList:(nonnull NSArray *)valueList
{
    allInputValues = [NSArray arrayWithArray:valueList];
    onesNSMA = [NSMutableArray arrayWithArray:allInputValues];
    zerosNSMA = [NSMutableArray arrayWithArray:allInputValues];
    
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, whiteY, self.frame.size.width, self.frame.size.height - whiteY)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:whiteView];
    
    UILabel *onesLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, whiteView.frame.size.width - 8, 20.0)];
    [onesLabel setBackgroundColor:[UIColor whiteColor]];
    [onesLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
    [onesLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [onesLabel setText:@"Ones"];
    [whiteView addSubview:onesLabel];
    
    onesUITV = [[UITableView alloc] initWithFrame:CGRectMake(8, 20, whiteView.frame.size.width - 16.0, 128.0) style:UITableViewStylePlain];
    [onesUITV setDelegate:self];
    [onesUITV setDataSource:self];
    [onesUITV setTag:22001];
    [whiteView addSubview:onesUITV];
    
    UILabel *zerosLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 156, whiteView.frame.size.width - 8, 20.0)];
    [zerosLabel setBackgroundColor:[UIColor whiteColor]];
    [zerosLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
    [zerosLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [zerosLabel setText:@"Zeros"];
    [whiteView addSubview:zerosLabel];
    
    zerosUITV = [[UITableView alloc] initWithFrame:CGRectMake(8, 176, whiteView.frame.size.width - 16.0, 128.0) style:UITableViewStylePlain];
    [zerosUITV setDelegate:self];
    [zerosUITV setDataSource:self];
    [zerosUITV setTag:22000];
    [whiteView addSubview:zerosUITV];

    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - whiteY - 40, self.frame.size.width / 2.0, 40)];
    [saveButton setBackgroundColor:[UIColor whiteColor]];
    [saveButton setTitle:@"Save and Close" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:0.1] forState:UIControlStateHighlighted];
    [saveButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:saveButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0, self.frame.size.height - whiteY - 40, self.frame.size.width / 2.0, 40)];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton setTitle:@"Clear and Close" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:0.1] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelButton];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5]];
    }
    return self;
}

- (void)cancelButtonPressed:(UIButton *)sender
{
    for (int i = 0; i < [allInputValues count]; i++)
    {
        NSIndexPath *nsip = [NSIndexPath indexPathForRow:i inSection:0];
        [onesUITV deselectRowAtIndexPath:nsip animated:NO];
        [zerosUITV deselectRowAtIndexPath:nsip animated:NO];
        if (i == 0)
        {
            [onesUITV scrollToRowAtIndexPath:nsip atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [zerosUITV scrollToRowAtIndexPath:nsip atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    [self saveButtonPressed:sender];
}

- (void)saveButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [self setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    }completion:nil];
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
    }
    
    if ([tableView tag] == 22000)
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", [zerosNSMA objectAtIndex:indexPath.row]]];
    else if ([tableView tag] == 22001)
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", [onesNSMA objectAtIndex:indexPath.row]]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    UIView *cellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [cellBackgroundView setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
    [cell setSelectedBackgroundView:cellBackgroundView];
    [cell.textLabel setNumberOfLines:0];
    
    float fontSize = 16.0;
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    unsigned long returnvalue = 0;
    if ([tableView tag] == 22000)
        returnvalue = [zerosNSMA count];
    else if ([tableView tag] == 22001)
        returnvalue = [onesNSMA count];
    return returnvalue;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isSelected]) {
        // Deselect manually.
//        [tableView.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];

        return nil;
    }
//    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedNSA = [tableView indexPathsForSelectedRows];

    if ([tableView tag] == 22001)
    {
        selectedOnes = [tableView indexPathsForSelectedRows];
        for (NSIndexPath *nsip in selectedNSA)
        {
            [zerosUITV deselectRowAtIndexPath:nsip animated:NO];
        }
    }
    else if ([tableView tag] == 22000)
    {
        selectedZeros = [tableView indexPathsForSelectedRows];
        for (NSIndexPath *nsip in selectedNSA)
        {
            [onesUITV deselectRowAtIndexPath:nsip animated:NO];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedNSA = [tableView indexPathsForSelectedRows];

    if ([tableView tag] == 22001)
    {
        selectedOnes = [tableView indexPathsForSelectedRows];
        for (NSIndexPath *nsip in selectedNSA)
        {
            [zerosUITV deselectRowAtIndexPath:nsip animated:NO];
        }
    }
    else if ([tableView tag] == 22000)
    {
        selectedZeros = [tableView indexPathsForSelectedRows];
        for (NSIndexPath *nsip in selectedNSA)
        {
            [onesUITV deselectRowAtIndexPath:nsip animated:NO];
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
