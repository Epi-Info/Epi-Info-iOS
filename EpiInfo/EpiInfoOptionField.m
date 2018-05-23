//
//  EpiInfoOptionField.m
//  EpiInfo
//
//  Created by John Copeland on 6/2/14.
//

#import "EpiInfoOptionField.h"
#import "EnterDataView.h"

@implementation EpiInfoOptionField
@synthesize oftv = _oftv;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov
{
    self = [super initWithFrame:frame AndListOfValues:lov];
    if (self) {
        // Add the UITableView
        [self removeValueButtonViewFromSuperview];
        self.oftv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        [self.oftv setDelegate:self];
        [self.oftv setDataSource:self];
        [self.oftv setSeparatorColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self addSubview:self.oftv];
    }
    return self;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    row--;
    [picked setText:[NSString stringWithFormat:@"%d", (int)row]];
    if (row == -1)
        [picked setText:@"NULL"];
    if (self.textFieldToUpdate)
    {
        [self.textFieldToUpdate setText:[NSString stringWithString:[NSString stringWithFormat:@"%d", (int)row]]];
    }
    if (self.viewToAlertOfChanges)
    {
        [self.viewToAlertOfChanges didChangeValueForKey:[NSString stringWithString:[listOfValues objectAtIndex:row]]];
    }
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    
}

- (void)setSelectedLegalValue:(NSString *)selectedLegalValue
{
//    [self.picker selectRow:[selectedLegalValue intValue] inComponent:0 animated:NO];
//    [self.textFieldToUpdate setText:[NSString stringWithFormat:@"%d", [selectedLegalValue intValue]]];
    NSIndexPath *nsip = [NSIndexPath indexPathForRow:[selectedLegalValue intValue] + 1 inSection:0];
    [self.oftv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionBottom];
    [self tableView:self.oftv didSelectRowAtIndexPath:nsip];
}

- (void)assignValue:(NSString *)value
{
    if ([value isEqualToString:@""] || [value isEqualToString:@"NULL"] || [value isEqualToString:@"(null)"])
    {
        [self reset];
        return;
    }
    value = [NSString stringWithFormat:@"%d", [value intValue] + 1];
    [self setPicked:value];
    [self setSelectedIndex:[NSNumber numberWithInt:[value intValue]]];
    [self.picker selectRow:[value intValue] inComponent:0 animated:YES];
    [self pickerView:self.picker didSelectRow:[value intValue] inComponent:0];
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
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
        [cell setIndentationWidth:18];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 16, cell.frame.size.height)];
        if ([indexPath row] > 0)
             [leftLabel setText:@"\u25cb"];
        else
            [leftLabel setText:@""];
        [leftLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [leftLabel setBackgroundColor:[UIColor whiteColor]];
        [leftLabel setTag:34];
        [cell.contentView addSubview:leftLabel];
    }
    else
    {
        for (UIView *uiv in [cell.contentView subviews])
        {
            if ([uiv isKindOfClass:[UILabel class]] && [uiv tag] == 34)
            {
                if ([indexPath row] > 0)
                    if ([indexPath row] == [self.picker selectedRowInComponent:0])
                        [(UILabel *)uiv setText:@"\u25c9"];
                    else
                        [(UILabel *)uiv setText:@"\u25cb"];
                else
                    [(UILabel *)uiv setText:@""];
            }
        }
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [listOfValues objectAtIndex:indexPath.row]]];
    if (indexPath.row == 0)
        [cell.textLabel setText:@""];
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
    NSUInteger nsui = [indexPath item];
    [self.picker selectRow:nsui inComponent:0 animated:NO];
    [self.textFieldToUpdate setText:[NSString stringWithFormat:@"%ld", (long)nsui]];
    [self pickerView:self.picker didSelectRow:nsui inComponent:0];
    
    for (long i = 1; i < [tableView numberOfRowsInSection:0]; i++)
    {
        UITableViewCell *uitc = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == [indexPath row])
        {
            for (UIView *uiv in [uitc.contentView subviews])
            {
                if ([uiv isKindOfClass:[UILabel class]] && [uiv tag] == 34)
                {
                    [(UILabel *)uiv setText:@"\u25c9"];
                }
            }
        }
        else
        {
            for (UIView *uiv in [uitc.contentView subviews])
            {
                if ([uiv isKindOfClass:[UILabel class]] && [uiv tag] == 34)
                {
                    [(UILabel *)uiv setText:@"\u25cb"];
                }
            }
        }
    }
}

- (void)reset
{
    [self resetDoNotEnable];
    [self setIsEnabled:YES];
}
- (void)resetDoNotEnable
{
    [super resetDoNotEnable];
    NSIndexPath *nsip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.oftv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.oftv didSelectRowAtIndexPath:nsip];
    [self.oftv deselectRowAtIndexPath:nsip animated:NO];
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    [super setIsEnabled:isEnabled];
    [self.oftv setUserInteractionEnabled:isEnabled];
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
