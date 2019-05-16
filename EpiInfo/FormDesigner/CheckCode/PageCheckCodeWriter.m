//
//  PageCheckCodeWriter.m
//  EpiInfo
//
//  Created by John Copeland on 5/14/19.
//

#import "PageCheckCodeWriter.h"
#import "FormDesigner.h"
#import "FormElementObject.h"
#import "IfBuilder.h"

@implementation PageCheckCodeWriter

- (id)initWithFrame:(CGRect)frame AndFieldName:(nonnull NSString *)fn AndFieldType:(nonnull NSString *)ft AndSenderSuperview:(nonnull UIView *)sv
{
    self = [super initWithFrame:frame AndFieldName:fn AndFieldType:ft AndSenderSuperview:sv];
    if (self)
    {
        pageNames = [(FormDesigner *)sv pageNames];
        pageNameSelected = [NSString stringWithString:[pageNames objectAtIndex:0]];
        pageNameSelectedIndex = 0;
        beginFieldString = [NSString stringWithFormat:@"Page [%@]", pageNameSelected];
        endFieldString = @"&#xA;End-Page";

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
    beginFieldString = [NSString stringWithFormat:@"Page [%@]", pageNameSelected];
    [beforeButton.layer setValue:pageNameSelected forKey:@"FieldName"];
    [afterButton.layer setValue:pageNameSelected forKey:@"FieldName"];
    pageNameSelectedIndex = row;
}

- (void)closeButtonPressed:(UIButton *)sender
{
    [super closeButtonPressed:sender];
    if ([[sender superview] superview] == senderSuperview)
    {
        if ([senderSuperview.layer valueForKey:@"CheckCode"])
        {
            [(FormDesigner *)senderSuperview addCheckCodeString:[senderSuperview.layer valueForKey:@"CheckCode"]];
        }
    }
}

- (void)beforeOrAfterButtonPressed:(UIButton *)sender
{
    UIView *selectFunctionView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [selectFunctionView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:selectFunctionView];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 32)];
    [firstLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [firstLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [firstLabel setTextAlignment:NSTextAlignmentCenter];
    [firstLabel setText:@"Check Code Builder"];
    [selectFunctionView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, self.frame.size.width / 2.0 - 4, 32)];
    [secondLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [secondLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [secondLabel setTextAlignment:NSTextAlignmentRight];
    [secondLabel setText:@"Field Name:"];
    [selectFunctionView addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 + 4, 32, self.frame.size.width / 2.0 - 4, 32)];
    [thirdLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [thirdLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [thirdLabel setTextAlignment:NSTextAlignmentLeft];
    [thirdLabel setText:[sender.layer valueForKey:@"FieldName"]];
    [selectFunctionView addSubview:thirdLabel];
    
    UILabel *fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width / 2.0 - 4, 32)];
    [fourthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [fourthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [fourthLabel setTextAlignment:NSTextAlignmentRight];
    [fourthLabel setText:@"Field Type:"];
    [selectFunctionView addSubview:fourthLabel];
    
    UILabel *fifthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 + 4, 64, self.frame.size.width / 2.0 - 4, 32)];
    [fifthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [fifthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [fifthLabel setTextAlignment:NSTextAlignmentLeft];
    [fifthLabel setText:[sender.layer valueForKey:@"FieldType"]];
    [selectFunctionView addSubview:fifthLabel];
    
    UILabel *sixthLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 96, self.frame.size.width - 16, 32)];
    [sixthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [sixthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [sixthLabel setTextAlignment:NSTextAlignmentLeft];
    [sixthLabel setText:[NSString stringWithFormat:@"Build IF statement to evaluate %@:", [[sender titleLabel] text]]];
    [selectFunctionView addSubview:sixthLabel];
    
    if ([[[sender titleLabel] text] isEqualToString:@"After"])
    {
    }
    else
    {
            UIButton *ifButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 128, selectFunctionView.frame.size.width, 32)];
            [ifButton setBackgroundColor:[UIColor whiteColor]];
            [ifButton setTitle:@"IF-THEN-ELSE Statement" forState:UIControlStateNormal];
            [ifButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [ifButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [ifButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [ifButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [ifButton addTarget:self action:@selector(ifButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [ifButton.layer setValue:@"Before" forKey:@"BeforeAfter"];
            [selectFunctionView addSubview:ifButton];
    }
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(selectFunctionView.frame.size.width / 2.0, selectFunctionView.frame.size.height - 48, selectFunctionView.frame.size.width / 2.0, 32)];
    [closeButton setBackgroundColor:[UIColor whiteColor]];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [selectFunctionView addSubview:closeButton];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [selectFunctionView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)ifButtonPressed:(UIButton *)sender
{
    UIView *span = [[UIView alloc] init];
    span = [[IfBuilder alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                     -[sender superview].frame.size.height,
                                                     [sender superview].frame.size.width,
                                                     [sender superview].frame.size.height)
                         AndCallingButton:sender];
    [[sender superview] addSubview:span];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [span setFrame:CGRectMake(0, 0, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
