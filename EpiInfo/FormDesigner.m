//
//  FormDesigner.m
//  EpiInfo
//
//  Created by John Copeland on 2/13/19.
//

#import "FormDesigner.h"

@implementation FormDesigner

- (id)initWithFrame:(CGRect)frame andSender:(nonnull UIButton *)sender
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self getExistingForms];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        float formDesignerLabelY = 0.0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            formDesignerLabelY = 8.0;
        formDesignerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, formDesignerLabelY, self.frame.size.width, 32)];
        [formDesignerLabel setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:0.95]];
        [formDesignerLabel setText:@"Form Designer"];
        [formDesignerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [formDesignerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [formDesignerLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:formDesignerLabel];
        
        UINavigationBar *footerBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, frame.size.height - 32.0, frame.size.width, 32)];
        UINavigationItem *footerBarNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(footerBarClose)];
        [closeBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
        [footerBarNavigationItem setRightBarButtonItem:closeBarButtonItem];
        [footerBar setItems:[NSArray arrayWithObject:footerBarNavigationItem]];
        [self addSubview:footerBar];
        
        canvasSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [canvasSV setBackgroundColor:[UIColor whiteColor]];
        [canvasSV setContentSize:CGSizeMake(frame.size.width, 2.0 * frame.size.height)];
        [self addSubview:canvasSV];
        [self sendSubviewToBack:canvasSV];
        
        canvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, canvasSV.contentSize.height)];
        [canvas setBackgroundColor:[UIColor whiteColor]];
        [canvasSV addSubview:canvas];
        
        canvasCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, canvas.frame.size.height)];
        [canvasCover setBackgroundColor:[UIColor clearColor]];
        canvasTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canvasTap:)];
        [canvasCover addGestureRecognizer:canvasTapGesture];
        [canvas addSubview:canvasCover];
        
        formNamed = NO;
    }
    return self;
}

- (void)getExistingForms
{
    existingForms = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[paths objectAtIndex:0] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        NSString *epiInfoForms = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"];
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:epiInfoForms error:nil];
        for (int i = 0; i < [contents count]; i++)
        {
            NSString *formlc = [(NSString *)[contents objectAtIndex:i] lowercaseString];
            NSRange dotxmlrange = [formlc rangeOfString:@".xml"];
            [existingForms addObject:(NSString *)[formlc substringToIndex:dotxmlrange.location]];
        }
    }
}

- (void)canvasTap:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint touchPoint = [tapRecognizer locationInView:self];
    
    if (YES)
    {
        [canvasTapGesture setEnabled:NO];
        [canvasSV setScrollEnabled:NO];
        menu = [[UIScrollView alloc] initWithFrame:CGRectMake(touchPoint.x, touchPoint.y, 8.0, 8.0 * (self.frame.size.height / self.frame.size.width))];
        [menu setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [menu setBounces:NO];
        
        float finalButtonHeight = 39.0;
        float initialButtonHeight = finalButtonHeight * (menu.frame.size.height / (0.84 * self.frame.size.height));
        int tagIncrementer = 1;
        
        UIButton *newFormButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 1, menu.frame.size.width - 2, initialButtonHeight)];
        [newFormButton setBackgroundColor:[UIColor whiteColor]];
        [newFormButton setTitle:@"\tNew Form" forState:UIControlStateNormal];
        [newFormButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [newFormButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [newFormButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [newFormButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [newFormButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [newFormButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:newFormButton];

        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 3.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [cancelButton setBackgroundColor:[UIColor whiteColor]];
        [cancelButton setTitle:@"\tCancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [cancelButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:cancelButton];

        UIButton *labelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 1.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [labelButton setBackgroundColor:[UIColor whiteColor]];
        [labelButton setTitle:@"\tLabel/Title" forState:UIControlStateNormal];
        [labelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [labelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [labelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [labelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [labelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [labelButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [labelButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:labelButton];
        [labelButton setEnabled:formNamed];
        
        UIButton *textButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [textButton setBackgroundColor:[UIColor whiteColor]];
        [textButton setTitle:@"\tText" forState:UIControlStateNormal];
        [textButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [textButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [textButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [textButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [textButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [textButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [textButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:textButton];
        [textButton setEnabled:formNamed];
        
        UIButton *uppercasetextButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [uppercasetextButton setBackgroundColor:[UIColor whiteColor]];
        [uppercasetextButton setTitle:@"\tText (Uppercase)" forState:UIControlStateNormal];
        [uppercasetextButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [uppercasetextButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [uppercasetextButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [uppercasetextButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [uppercasetextButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [uppercasetextButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [uppercasetextButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:uppercasetextButton];
        [uppercasetextButton setEnabled:formNamed];

        UIButton *multilineButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [multilineButton setBackgroundColor:[UIColor whiteColor]];
        [multilineButton setTitle:@"\tMultiline" forState:UIControlStateNormal];
        [multilineButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [multilineButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [multilineButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [multilineButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [multilineButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [multilineButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [multilineButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:multilineButton];
        [multilineButton setEnabled:formNamed];
        
        UIButton *numberButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [numberButton setBackgroundColor:[UIColor whiteColor]];
        [numberButton setTitle:@"\tNumber" forState:UIControlStateNormal];
        [numberButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [numberButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [numberButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [numberButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [numberButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [numberButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [numberButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:numberButton];
        [numberButton setEnabled:formNamed];
        
        UIButton *phonenumberButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [phonenumberButton setBackgroundColor:[UIColor whiteColor]];
        [phonenumberButton setTitle:@"\tPhone Number" forState:UIControlStateNormal];
        [phonenumberButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [phonenumberButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [phonenumberButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [phonenumberButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [phonenumberButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [phonenumberButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [phonenumberButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:phonenumberButton];
        [phonenumberButton setEnabled:formNamed];

        UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [dateButton setBackgroundColor:[UIColor whiteColor]];
        [dateButton setTitle:@"\tDate" forState:UIControlStateNormal];
        [dateButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [dateButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [dateButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [dateButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [dateButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [dateButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [dateButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:dateButton];
        [dateButton setEnabled:formNamed];
        
        UIButton *checkboxButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [checkboxButton setBackgroundColor:[UIColor whiteColor]];
        [checkboxButton setTitle:@"\tCheckbox" forState:UIControlStateNormal];
        [checkboxButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [checkboxButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [checkboxButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [checkboxButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [checkboxButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [checkboxButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [checkboxButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:checkboxButton];
        [checkboxButton setEnabled:formNamed];
        
        UIButton *yesnoButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [yesnoButton setBackgroundColor:[UIColor whiteColor]];
        [yesnoButton setTitle:@"\tYes/No" forState:UIControlStateNormal];
        [yesnoButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [yesnoButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [yesnoButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [yesnoButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [yesnoButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [yesnoButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [yesnoButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:yesnoButton];
        [yesnoButton setEnabled:formNamed];
        
        UIButton *optionButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [optionButton setBackgroundColor:[UIColor whiteColor]];
        [optionButton setTitle:@"\tOption" forState:UIControlStateNormal];
        [optionButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [optionButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [optionButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [optionButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [optionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [optionButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [optionButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:optionButton];
        [optionButton setEnabled:formNamed];
        
        UIButton *imagefieldButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [imagefieldButton setBackgroundColor:[UIColor whiteColor]];
        [imagefieldButton setTitle:@"\tImage" forState:UIControlStateNormal];
        [imagefieldButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [imagefieldButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [imagefieldButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [imagefieldButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [imagefieldButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [imagefieldButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [imagefieldButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:imagefieldButton];
        [imagefieldButton setEnabled:formNamed];
        
        UIButton *legalvaluesButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [legalvaluesButton setBackgroundColor:[UIColor whiteColor]];
        [legalvaluesButton setTitle:@"\tLegal Values" forState:UIControlStateNormal];
        [legalvaluesButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [legalvaluesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [legalvaluesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [legalvaluesButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [legalvaluesButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [legalvaluesButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [legalvaluesButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:legalvaluesButton];
        [legalvaluesButton setEnabled:formNamed];

        UIButton *commentlegalButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [commentlegalButton setBackgroundColor:[UIColor whiteColor]];
        [commentlegalButton setTitle:@"\tComment Legal" forState:UIControlStateNormal];
        [commentlegalButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [commentlegalButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [commentlegalButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [commentlegalButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [commentlegalButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [commentlegalButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [commentlegalButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:commentlegalButton];
        [commentlegalButton setEnabled:formNamed];

        [self addSubview:menu];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [menu setFrame:CGRectMake(0.08 * self.frame.size.width, 0.08 * self.frame.size.height, 0.84 * self.frame.size.width, fmin(0.84 * self.frame.size.height, (tagIncrementer - 1) * (finalButtonHeight + 1.0) + 1.0))];
            [menu setContentSize:CGSizeMake(menu.frame.size.width, (tagIncrementer - 1) * (finalButtonHeight + 1.0) + 1.0)];
            for (UIView *v in [menu subviews])
                [v setFrame:CGRectMake(v.frame.origin.x, ((((int)(((float)((int)[v tag])) / 1000000)) - 1) * (finalButtonHeight + 1.0)) + 1.0, menu.frame.size.width - 2, finalButtonHeight)];
        } completion:^(BOOL finished){
        }];
    }
}

- (void)menuButtonPressed:(UIButton *)sender
{
    int buttonTag = ((int)(((float)((int)[sender tag])) / 1000000));
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [menu setFrame:CGRectMake(menu.frame.origin.x, self.frame.size.height, menu.frame.size.width, menu.frame.size.height)];
    } completion:^(BOOL finished){
        [menu removeFromSuperview];
        [canvasTapGesture setEnabled:YES];
        [canvasSV setScrollEnabled:YES];
        if (buttonTag == 1)
            [self presentNewFormView];
    }];
}

- (void)presentNewFormView
{
    newFormViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [newFormViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:newFormViewGrayBackground];
    
    UILabel *newFormViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, newFormViewGrayBackground.frame.size.width - 2, 0)];
    [newFormViewLabel setBackgroundColor:[UIColor whiteColor]];
    [newFormViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [newFormViewLabel setText:@"\tForm Name:"];
    [newFormViewLabel setTextAlignment:NSTextAlignmentLeft];
    [newFormViewLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [newFormViewGrayBackground addSubview:newFormViewLabel];
    
    UITextField *newFormViewText = [[UITextField alloc] initWithFrame:CGRectMake(1, 0, newFormViewGrayBackground.frame.size.width - 2, 0)];
    [newFormViewText setBackgroundColor:[UIColor whiteColor]];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [newFormViewText setLeftViewMode:UITextFieldViewModeAlways];
    [newFormViewText setLeftView:spacerView];
    [newFormViewText setPlaceholder:@"Enter form name."];
    [newFormViewText setDelegate:self];
    [newFormViewText setReturnKeyType:UIReturnKeyDone];
    [newFormViewGrayBackground addSubview:newFormViewText];
    
    UIButton *newFormViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, newFormViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [newFormViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [newFormViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [newFormViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [newFormViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [newFormViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [newFormViewCancelButton addTarget:self action:@selector(newFormSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [newFormViewGrayBackground addSubview:newFormViewCancelButton];
    
    UIButton *newFormViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(newFormViewGrayBackground.frame.size.width / 2, 0, newFormViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [newFormViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [newFormViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [newFormViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [newFormViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [newFormViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [newFormViewSaveButton addTarget:self action:@selector(newFormSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [newFormViewGrayBackground addSubview:newFormViewSaveButton];

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [newFormViewGrayBackground setFrame:CGRectMake(newFormViewGrayBackground.frame.origin.x, 0.08 * self.frame.size.height, 0.84 * self.frame.size.width, 122)];
        [newFormViewLabel setFrame:CGRectMake(1, 1, newFormViewGrayBackground.frame.size.width - 2, 40)];
        [newFormViewText setFrame:CGRectMake(1, 41, newFormViewGrayBackground.frame.size.width - 2, 40)];
        [newFormViewCancelButton setFrame:CGRectMake(1, 81, newFormViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [newFormViewSaveButton setFrame:CGRectMake(newFormViewGrayBackground.frame.size.width / 2, 81, newFormViewGrayBackground.frame.size.width / 2 - 1, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)newFormSaveOrCancelPressed:(UIButton *)sender
{
    NSString *newFormName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    for (UIView *vv in [newFormViewGrayBackground subviews])
    {
        if ([vv isKindOfClass:[UITextField class]])
        {
            newFormName = [[(UITextField *)vv text] stringByReplacingOccurrencesOfString:@" " withString:@""];
            break;
        }
    }
    if (saveButtonPressed && [existingForms containsObject:[newFormName lowercaseString]])
    {
        return;
    }
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [newFormViewGrayBackground setFrame:CGRectMake(newFormViewGrayBackground.frame.origin.x, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
        for (UIView *vv in [newFormViewGrayBackground subviews])
        {
            [vv setFrame:CGRectMake(vv.frame.origin.x, 0, vv.frame.size.width, 0)];
        }
    } completion:^(BOOL finished){
        [newFormViewGrayBackground removeFromSuperview];
        if (saveButtonPressed)
        {
            NSLog(@"Save button pressed. Form name = %@.", newFormName);
            if ([newFormName length] > 0)
            {
                [formDesignerLabel setText:[NSString stringWithFormat:@"Form Designer: %@", newFormName]];
                formNamed = YES;
            }
        }
    }];
}

- (void)footerBarClose
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect formDesignerFrame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self setFrame:formDesignerFrame];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
