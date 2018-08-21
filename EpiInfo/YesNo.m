//
//  YesNo.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "YesNo.h"
#import "EnterDataView.h"

@implementation YesNo
@synthesize columnName = _columnName;
@synthesize isReadOnly = _isReadOnly;
@synthesize tv = _tv;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 300, 80)];
    if (self) {
        // Initialization code
        //        [self setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setCornerRadius:4.0];
        picked = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 40, 10)];
        //        [self addSubview:picked];
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 10, 280, 160)];
        [picker setDelegate:self];
        [picker setDataSource:self];
        [picker setShowsSelectionIndicator:YES];
        [picker setBackgroundColor:[UIColor clearColor]];
        [self addSubview:picker];
        [picker setAlpha:0.0];

        valueButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [valueButtonView setBackgroundColor:[UIColor whiteColor]];
        
        self.valueButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, valueButtonView.frame.size.width - 16, 48)];
        [self.valueButton setBackgroundColor:[UIColor whiteColor]];
        float fontSize = 16.0;
        [self.valueButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
        [self.valueButton setTitle:@"" forState:UIControlStateNormal];
        [self.valueButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.valueButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.valueButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.valueButton.layer setBorderWidth:1.0];
        [self.valueButton.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
        [self.valueButton addTarget:self action:@selector(valueButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        float triangleViewDimension = self.valueButton.frame.size.height;
        DownTriangle *dt = [[DownTriangle alloc] initWithFrame:CGRectMake(self.valueButton.frame.size.width - (0.6 * triangleViewDimension), 0, 0.6 * triangleViewDimension, triangleViewDimension)];
        [dt setBackgroundColor:[UIColor whiteColor]];
        [dt addTarget:self action:@selector(valueButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.valueButton addSubview:dt];
        
        self.tv = [[UITableView alloc] initWithFrame:CGRectMake(self.valueButton.frame.origin.x, self.valueButton.frame.origin.y, self.valueButton.frame.size.width, 0) style:UITableViewStylePlain];
        [self.tv setDelegate:self];
        [self.tv setDataSource:self];
        [self.tv setSeparatorColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self.tv.layer setBorderWidth:1.0];
        [self.tv.layer setBorderColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0].CGColor];
        [self.tv setTag:7594];
        
        [self addSubview:valueButtonView];
        [valueButtonView addSubview:self.valueButton];
        [valueButtonView addSubview:self.tv];
    }
    return self;
}

- (NSString *)picked
{
    if ([picked.text length] == 0)
        return @"NULL";
    return picked.text;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *tView = (UILabel *)view;
    if (!view)
    {
        tView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    }
    [tView setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [tView setTextAlignment:NSTextAlignmentCenter];
    [tView setTextColor:[UIColor blackColor]];
    [tView setText:[NSString stringWithFormat:@"%@", [[NSArray arrayWithObjects:@"", @"Yes", @"No", nil] objectAtIndex:row]]];
    
    return tView;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [picked setText:[NSString stringWithFormat:@"%@", [[NSArray arrayWithObjects:@"", @"1", @"0", nil] objectAtIndex:row]]];
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    
}

- (void)reset
{
    [picked setText:nil];
    [picker selectRow:0 inComponent:0 animated:YES];
    NSIndexPath *nsip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tv didSelectRowAtIndexPath:nsip];
    [self.tv deselectRowAtIndexPath:nsip animated:NO];
    [self.valueButton setTitle:@"" forState:UIControlStateNormal];
    [self setIsEnabled:YES];
}

- (void)resetDoNotEnable
{
    [picked setText:nil];
    [picker selectRow:0 inComponent:0 animated:YES];
    NSIndexPath *nsip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tv didSelectRowAtIndexPath:nsip];
    [self.tv deselectRowAtIndexPath:nsip animated:NO];
    [self.valueButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)setYesNo:(NSInteger)yesNo
{
    if (yesNo < 0 || yesNo > 1)
        return;
    if (yesNo == 1)
    {
        [picker selectRow:1 inComponent:0 animated:NO];
        NSIndexPath *nsip = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.tv didSelectRowAtIndexPath:nsip];
    }
    else
    {
        [picker selectRow:2 inComponent:0 animated:NO];
        NSIndexPath *nsip = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.tv didSelectRowAtIndexPath:nsip];
    }
    [picked setText:[NSString stringWithFormat:@"%d", (int)yesNo]];
}

-(float)contentSizeHeightAdjustment
{
    return self.frame.size.height - 20.0;
}

- (void)setFormFieldValue:(NSString *)formFieldValue
{
    if ([formFieldValue isEqualToString:@"(null)"] || [[formFieldValue uppercaseString] isEqualToString:@"NULL"])
    {
        [picker selectRow:0 inComponent:0 animated:NO];
        NSIndexPath *nsip = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.tv didSelectRowAtIndexPath:nsip];
        [self.tv deselectRowAtIndexPath:nsip animated:NO];
        [self.valueButton setTitle:@"" forState:UIControlStateNormal];
        return;
    }
    else if ([[formFieldValue uppercaseString] isEqualToString:@"YES"])
    {
        [self setYesNo:1];
        return;
    }
    else if ([[formFieldValue uppercaseString] isEqualToString:@"NO"])
    {
        [self setYesNo:0];
        return;
    }
    
    [self setYesNo:[formFieldValue integerValue]];
}

- (NSString *)epiInfoControlValue
{
    return [self picked];
}

- (void)assignValue:(NSString *)value
{
    if ([value isEqualToString:@""] || [value isEqualToString:@"NULL"])
    {
        [self reset];
        return;
    }
    if ([value isEqualToString:@"Yes"] || [value isEqualToString:@"1"])
        [self setYesNo:1];
    else
        [self setYesNo:0];
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    [picker setUserInteractionEnabled:isEnabled];
    [self.valueButton setUserInteractionEnabled:isEnabled];
    [self.tv setFrame:CGRectMake(self.valueButton.frame.origin.x, self.valueButton.frame.origin.y, self.valueButton.frame.size.width, 0)];
    [self setAlpha:0.5 + 0.5 * (int)isEnabled];
}

- (void)selfFocus
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.1f];
        dispatch_async(dispatch_get_main_queue(), ^{
            float yForBottom = [(EnterDataView *)[[self superview] superview] contentSize].height - [(EnterDataView *)[[self superview] superview] bounds].size.height;
            if (yForBottom < 0.0)
                yForBottom = 0.0;
            float selfY = self.frame.origin.y - 80.0f;
            
            CGPoint pt = CGPointMake(0.0f, selfY);
            if (selfY > yForBottom)
                pt = CGPointMake(0.0f, yForBottom);
            
            [(EnterDataView *)[[self superview] superview] setContentOffset:pt animated:YES];
        });
    });
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

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
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [[NSArray arrayWithObjects:@"",@"Yes",@"No", nil] objectAtIndex:indexPath.row]]];
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
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger nsui = [indexPath item];
    [picker selectRow:nsui inComponent:0 animated:NO];
//    [self.textFieldToUpdate setText:[NSString stringWithFormat:@"%ld", (long)nsui]];
    [self pickerView:picker didSelectRow:nsui inComponent:0];
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.tv setFrame:CGRectMake(topX, topY, self.valueButton.frame.size.width, 0)];
    } completion:^(BOOL finished){
        [self.tv setFrame:CGRectMake(self.valueButton.frame.origin.x, self.valueButton.frame.origin.y, self.valueButton.frame.size.width, 0)];
        [self.valueButton addSubview:self.tv];
        
        UIScrollView *uisv = (UIScrollView *)[[self superview] superview];
        [uisv setScrollEnabled:YES];
        [shield removeFromSuperview];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.valueButton);
    }];
    
    [self.valueButton setTitle:[[[self.tv cellForRowAtIndexPath:indexPath] textLabel] text] forState:UIControlStateNormal];
}

- (void)valueButtonPressed:(id)sender
{
    UIView *topView = [[UIApplication sharedApplication].keyWindow.rootViewController view];
    topX = [self.valueButton convertRect:self.valueButton.bounds toView:nil].origin.x;
    topY = [self.valueButton convertRect:self.valueButton.bounds toView:nil].origin.y;
    finalTopY = topView.frame.size.height - 16.0 - (180.0 - 16);
    if (topY < finalTopY)
        finalTopY = topY;
    [self.tv setFrame:CGRectMake(topX, topY, self.tv.frame.size.width, 0.0)];
    shield = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height)];
    [topView addSubview:shield];
    [shield addSubview:self.tv];
    
    UIScrollView *uisv = (UIScrollView *)[[self superview] superview];
    [uisv setScrollEnabled:NO];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.tv setFrame:CGRectMake(topX, finalTopY, self.valueButton.frame.size.width, 180 - 16)];
    } completion:^(BOOL finished){
    }];
}

- (void)removeValueButtonViewFromSuperview
{
    for (UIView *v in [valueButtonView subviews])
        [v removeFromSuperview];
    [valueButtonView removeFromSuperview];
}

@end
