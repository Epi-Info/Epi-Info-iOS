//
//  LegalValues.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "LegalValues.h"

@implementation LegalValues
@synthesize columnName = _columnName;
@synthesize picker = _picker;
@synthesize textFieldToUpdate = _textFieldToUpdate;
@synthesize viewToAlertOfChanges = _viewToAlertOfChanges;
@synthesize selectedIndex = _selectedIndex;

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 300, 180)];
    if (self) {
        // Initialization code
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
}

- (NSString *)epiInfoControlValue
{
    return [self picked];
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
