//
//  PageCheckCodeWriter.m
//  EpiInfo
//
//  Created by John Copeland on 5/14/19.
//

#import "PageCheckCodeWriter.h"
#import "FormDesigner.h"
#import "FormElementObject.h"

@implementation PageCheckCodeWriter

- (id)initWithFrame:(CGRect)frame AndFieldName:(nonnull NSString *)fn AndFieldType:(nonnull NSString *)ft AndSenderSuperview:(nonnull UIView *)sv
{
    self = [super initWithFrame:frame AndFieldName:fn AndFieldType:ft AndSenderSuperview:sv];
    if (self)
    {
        pageNames = [(FormDesigner *)sv pageNames];
        pageNameSelected = [NSString stringWithString:[pageNames objectAtIndex:0]];
        pageNameSelectedIndex = 0;
        [beforeButton setEnabled:YES];
        [afterButton setEnabled:NO];
        
        [secondLabel setText:@"Page Name:"];
        [thirdLabel setText:pageNameSelected];
        [thirdLabel setHidden:YES];
        
        pageNamePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 + 4, 24, frame.size.width / 2.0 - 6, 48)];
        [pageNamePicker setDelegate:self];
        [pageNamePicker setDataSource:self];
        [self addSubview:pageNamePicker];
        
        [beforeButton.layer setValue:pageNameSelected forKey:@"FieldName"];
        [afterButton.layer setValue:pageNameSelected forKey:@"FieldName"];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pageNames count];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *tView = (UILabel *)view;
    if (!view)
    {
        tView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 20)];
    }
    [tView setTextAlignment:NSTextAlignmentLeft];
    [tView setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [tView setText:[NSString stringWithFormat:@"%@", [pageNames objectAtIndex:row]]];
    float fontSize = 16.0;
    while ([tView.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > pickerView.frame.size.width)
        fontSize -= 0.1;
    [tView setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    
    return tView;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pageNameSelected = [pageNames objectAtIndex:row];
    [thirdLabel setText:pageNameSelected];
    [beforeButton.layer setValue:pageNameSelected forKey:@"FieldName"];
    [afterButton.layer setValue:pageNameSelected forKey:@"FieldName"];
    pageNameSelectedIndex = row;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
