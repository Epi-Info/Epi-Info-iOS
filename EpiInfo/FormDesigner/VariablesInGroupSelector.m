//
//  VariablesInGroupSelector.m
//  EpiInfo
//
//  Created by John Copeland on 12/6/19.
//

#import "VariablesInGroupSelector.h"
#import "FormDesigner.h"

@implementation VariablesInGroupSelector
{
    FormDesigner *fd;
}

- (void)setFD:(UIView *)mfd
{
    fd = (FormDesigner *)mfd;
}

- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov AndTextFieldToUpdate:(UITextField *)tftu
{
    self = [super initWithFrame:frame AndListOfValues:lov AndTextFieldToUpdate:tftu];
    if (self)
        [self setFrame:frame];
    [self.tv setAllowsMultipleSelection:YES];
    return self;
}

- (void)valueButtonPressed:(id)sender
{
    [super valueButtonPressed:sender];
    float tvX = self.tv.frame.origin.x;
    float tvY = self.tv.frame.origin.y;
    float tvWidth = self.tv.frame.size.width;
    UIButton *closeTVButton = [[UIButton alloc] initWithFrame:CGRectMake(tvX, tvY - 39.0, tvWidth, 40.0)];
    [closeTVButton setBackgroundColor:[UIColor whiteColor]];
    [closeTVButton setTitle:@"" forState:UIControlStateNormal];
    [closeTVButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [closeTVButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [closeTVButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [closeTVButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [closeTVButton.layer setBorderWidth:1.0];
    [closeTVButton.layer setBorderColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0].CGColor];
    [closeTVButton setAccessibilityLabel:@"Close Variable List"];
    [shield addSubview:closeTVButton];
    UINavigationBar *vigsNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(tvWidth - 50, 0, tvWidth - (tvWidth - 50), 40.0)];
    [vigsNavigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [vigsNavigationBar setShadowImage:[UIImage new]];
    [vigsNavigationBar setTranslucent:YES];
//    [vigsNavigationBar.layer setBorderWidth:1.0];
//    [vigsNavigationBar.layer setBorderColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0].CGColor];
    UINavigationItem *vigsNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *closevigsBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButtonPressed:)];
    [closevigsBarButtonItem setAccessibilityLabel:@"Close Variable List"];
    [closevigsBarButtonItem setTintColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [vigsNavigationItem setRightBarButtonItem:closevigsBarButtonItem];
    [vigsNavigationBar setItems:[NSArray arrayWithObject:vigsNavigationItem]];
    [closeTVButton addSubview:vigsNavigationBar];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [listOfValues objectAtIndex:indexPath.row]]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [cell.textLabel setNumberOfLines:0];
    
    float fontSize = 16.0;
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    
    return cell;
}

- (void)closeButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.tv setFrame:CGRectMake(topX, topY, self.valueButton.frame.size.width, 0)];
    } completion:^(BOOL finished){
        [self.tv setFrame:CGRectMake(self.valueButton.frame.origin.x, self.valueButton.frame.origin.y, self.valueButton.frame.size.width, 0)];
        [self.valueButton addSubview:self.tv];
        
        [shield removeFromSuperview];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.valueButton);
    }];
    [fd fieldResignedFirstResponder:self];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [valueButtonView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.valueButton setFrame:CGRectMake(8, 8, valueButtonView.frame.size.width - 16, 48)];
    [self.tv setFrame:CGRectMake(self.tv.frame.origin.x, self.tv.frame.origin.y, self.valueButton.frame.size.width, self.tv.frame.size.height)];
    for (UIView *v in [self.valueButton subviews])
    {
        if ([v isKindOfClass:[DownTriangle class]])
        {
            [v setFrame:CGRectMake(self.valueButton.frame.size.width - 1.0 - v.frame.size.width, v.frame.origin.y, v.frame.size.width, v.frame.size.height)];
            break;
        }
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
