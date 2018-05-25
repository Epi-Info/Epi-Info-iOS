//
//  LegalValuesEnter.m
//  EpiInfo
//
//  Created by admin on 2/19/16.
//

#import "LegalValuesEnter.h"
#import "EnterDataView.h"

@implementation LegalValuesEnter
@synthesize columnName = _columnName;
@synthesize isReadOnly = _isReadOnly;
@synthesize picker = _picker;
@synthesize textFieldToUpdate = _textFieldToUpdate;
@synthesize viewToAlertOfChanges = _viewToAlertOfChanges;
@synthesize selectedIndex = _selectedIndex;
@synthesize tv = _tv;

- (void)setListOfValues:(NSArray *)lov
{
    listOfValues = [NSMutableArray arrayWithArray:lov];
    [self.picker reloadAllComponents];
}
- (NSMutableArray *)listOfValues
{
    return listOfValues;
}
- (NSString *)picked
{
    if ([picked.text length] == 0)
        return @"NULL";
    return  picked.text;
}
- (void)setPicked:(NSString *)pkd
{
    [picked setText:pkd];
}
-(float)contentSizeHeightAdjustment
{
    return self.frame.size.height - 20.0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 300, 80)];
    if (self) {
        // Initialization code
        if (@available(iOS 11.0, *)) {
            [self.textFieldToUpdate setSmartQuotesType:UITextSmartQuotesTypeNo];
        } else {
            // Fallback on earlier versions
        }
        [self setSelectedIndex:[NSNumber numberWithInt:0]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame ForOptionsField:(BOOL)forOptionsField
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 300, frame.size.height)];
    if (self) {
        // Initialization code
        if (@available(iOS 11.0, *)) {
            [self.textFieldToUpdate setSmartQuotesType:UITextSmartQuotesTypeNo];
        } else {
            // Fallback on earlier versions
        }
        [self setSelectedIndex:[NSNumber numberWithInt:0]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov
{
    self = [self initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 300, 180)];
    if (self) {
        // Initialization code
        [self setListOfValues:lov];
        //        [self setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setCornerRadius:4.0];
        picked = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 40, 10)];
        //        [self addSubview:picked];
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 10, 280, 160)];
        [self.picker setDelegate:self];
        [self.picker setDataSource:self];
        [self.picker setShowsSelectionIndicator:YES];
        [self.picker setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.picker];
        [self.picker setAlpha:0.0];
        
        valueButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [valueButtonView setBackgroundColor:[UIColor whiteColor]];
        
        self.valueButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, valueButtonView.frame.size.width - 16, 48)];
        [self.valueButton setBackgroundColor:[UIColor whiteColor]];
        [self.valueButton setTitle:@"" forState:UIControlStateNormal];
        [self.valueButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.valueButton.layer setBorderWidth:1.0];
        [self.valueButton.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
        [self.valueButton addTarget:self action:@selector(valueButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.tv = [[UITableView alloc] initWithFrame:CGRectMake(self.valueButton.frame.origin.x, self.valueButton.frame.origin.y, self.valueButton.frame.size.width, 0) style:UITableViewStylePlain];
        [self.tv setDelegate:self];
        [self.tv setDataSource:self];
        [self.tv setSeparatorColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self.tv.layer setBorderWidth:1.0];
        [self.tv.layer setBorderColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0].CGColor];
        [self.tv setTag:7593];
        
        [self addSubview:valueButtonView];
        [valueButtonView addSubview:self.valueButton];
        [valueButtonView addSubview:self.tv];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov ForOptionsField:(BOOL)forOptionsField
{
    self = [self initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 300, 180) ForOptionsField:forOptionsField];
    if (self) {
        // Initialization code
        [self setListOfValues:lov];
        //        [self setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setCornerRadius:4.0];
        picked = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 40, 10)];
        //        [self addSubview:picked];
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 10, 280, 160)];
        [self.picker setDelegate:self];
        [self.picker setDataSource:self];
        [self.picker setShowsSelectionIndicator:YES];
        [self.picker setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.picker];
        
        valueButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [valueButtonView setBackgroundColor:[UIColor whiteColor]];
        
        self.valueButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, valueButtonView.frame.size.width - 16, 48)];
        [self.valueButton setBackgroundColor:[UIColor whiteColor]];
        [self.valueButton setTitle:@"" forState:UIControlStateNormal];
        [self.valueButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.valueButton.layer setBorderWidth:1.0];
        [self.valueButton.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
        [self.valueButton addTarget:self action:@selector(valueButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.tv = [[UITableView alloc] initWithFrame:CGRectMake(self.valueButton.frame.origin.x, self.valueButton.frame.origin.y, self.valueButton.frame.size.width, 0) style:UITableViewStylePlain];
        [self.tv setDelegate:self];
        [self.tv setDataSource:self];
        [self.tv setSeparatorColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self.tv.layer setBorderWidth:1.0];
        [self.tv.layer setBorderColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0].CGColor];
        
        [self addSubview:valueButtonView];
        [valueButtonView addSubview:self.valueButton];
        [valueButtonView addSubview:self.tv];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov AndTextFieldToUpdate:(UITextField *)tftu
{
    self = [self initWithFrame:frame AndListOfValues:lov];
    if (self)
    {
        [self setTextFieldToUpdate:tftu];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov NoFixedDimensions:(BOOL)nfd
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setListOfValues:lov];
        //        [self setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setCornerRadius:4.0];
        picked = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 40, 10)];
        //        [self addSubview:picked];
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        [self.picker setDelegate:self];
        [self.picker setDataSource:self];
        [self.picker setShowsSelectionIndicator:YES];
        [self.picker setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.picker];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov AndTextFieldToUpdate:(UITextField *)tftu NoFixedDimensions:(BOOL)nfd
{
    self = [self initWithFrame:frame AndListOfValues:lov NoFixedDimensions:nfd];
    if (self)
    {
        [self setTextFieldToUpdate:tftu];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return listOfValues.count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *tView = (UILabel *)view;
    if (!view)
    {
        tView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    }
    [tView setTextAlignment:NSTextAlignmentCenter];
    [tView setTextColor:[UIColor blackColor]];
    [tView setText:[NSString stringWithFormat:@"%@", [listOfValues objectAtIndex:row]]];
    float fontSize = 16.0;
    while ([tView.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]}].width > 200)
        fontSize -= 0.1;
    [tView setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]];
    
    return tView;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [picked setText:[NSString stringWithFormat:@"%@", [listOfValues objectAtIndex:row]]];
    [self setSelectedIndex:[NSNumber numberWithInt:(int)row]];
    if (self.textFieldToUpdate)
    {
        [self.textFieldToUpdate setText:[NSString stringWithString:[listOfValues objectAtIndex:row]]];
    }
    if (self.viewToAlertOfChanges)
    {
        [self.viewToAlertOfChanges didChangeValueForKey:[NSString stringWithString:[listOfValues objectAtIndex:row]]];
    }
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
    
}

- (void)setSelectedLegalValue:(NSString *)selectedLegalValue
{
    int i = 0;
    for (id item in listOfValues)
    {
        if ([(NSString *)item isEqualToString:selectedLegalValue])
        {
            [self.picker selectRow:i inComponent:0 animated:NO];
            [self.textFieldToUpdate setText:selectedLegalValue];
            NSIndexPath *nsip = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self.valueButton setTitle:[[[self.tv cellForRowAtIndexPath:nsip] textLabel] text] forState:UIControlStateNormal];
            return;
        }
        i++;
    }
}
- (void)setFormFieldValue:(NSString *)formFieldValue
{
    if ([formFieldValue isEqualToString:@"(null)"])
        return;
    
    [self setSelectedLegalValue:formFieldValue];
}

- (void)reset
{
    [picked setText:nil];
    [self setSelectedIndex:[NSNumber numberWithInt:0]];
    [self.picker selectRow:0 inComponent:0 animated:YES];
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
    [self setSelectedIndex:[NSNumber numberWithInt:0]];
    [self.picker selectRow:0 inComponent:0 animated:YES];
    NSIndexPath *nsip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tv selectRowAtIndexPath:nsip animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tv didSelectRowAtIndexPath:nsip];
    [self.tv deselectRowAtIndexPath:nsip animated:NO];
    [self.valueButton setTitle:@"" forState:UIControlStateNormal];
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
    // Code for correcting bad single and double quote characters already in SQLite
    NSMutableArray *eightytwoeighteens = [[NSMutableArray alloc] init];
    for (int i = 0; i < value.length; i++)
    {
        if ([value characterAtIndex:i] == 8218)
            [eightytwoeighteens addObject:[NSNumber numberWithInteger:i]];
    }
    for (int i = (int)eightytwoeighteens.count - 1; i >= 0; i--)
    {
        NSNumber *num = [eightytwoeighteens objectAtIndex:i];
        value = [value stringByReplacingCharactersInRange:NSMakeRange([num integerValue], 1) withString:@""];
    }
    if ([eightytwoeighteens count] > 0)
    {
        if ([value containsString:[NSString stringWithFormat:@"%c%c", '\304', '\364']])
            value = [value stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c%c", '\304', '\364'] withString:@"'"];
        if ([value containsString:[NSString stringWithFormat:@"%c%c", '\304', '\371']])
            value = [value stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c%c", '\304', '\371'] withString:@"\""];
    }
    //
    [self setPicked:value];
    [self setFormFieldValue:value];
    [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    [self.picker setUserInteractionEnabled:isEnabled];
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
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.tv setFrame:CGRectMake(topX, topY, self.valueButton.frame.size.width, 0)];
    } completion:^(BOOL finished){
        [self.tv setFrame:CGRectMake(self.valueButton.frame.origin.x, self.valueButton.frame.origin.y, self.valueButton.frame.size.width, 0)];
        [self.valueButton addSubview:self.tv];
        
        UIScrollView *uisv = (UIScrollView *)[[self superview] superview];
        [uisv setScrollEnabled:YES];
        [shield removeFromSuperview];
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
