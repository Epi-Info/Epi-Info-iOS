//
//  FormDesigner.m
//  EpiInfo
//
//  Created by John Copeland on 2/13/19.
//

#import "FormDesigner.h"
#import "DataEntryViewController.h"
#import "TextFieldDisplay.h"

@implementation FormDesigner
@synthesize rootViewController = _rootViewController;

- (id)initWithFrame:(CGRect)frame andSender:(nonnull UIButton *)sender
{
    self = [super initWithFrame:frame];
    if (self)
    {
        yTouched = -99.9;
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
        
        nextY = formDesignerLabelY + formDesignerLabel.frame.size.height;
        nextYReset = nextY;
        
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
        [canvasCover setTag:19572010];
        [canvas addSubview:canvasCover];
        
        formNamed = NO;
        
        NSArray *senderTitleArray = [[[sender titleLabel] text] componentsSeparatedByString:@" "];
        if ([(NSString *)[senderTitleArray objectAtIndex:0] isEqualToString:@"Edit"])
        {
            formName = [NSString stringWithString:[senderTitleArray objectAtIndex:1]];
            [formDesignerLabel setText:[NSString stringWithFormat:@"Form Designer: %@", formName]];
            formNamed = YES;
            formElements = [[NSMutableArray alloc] init];
            formElementObjects = [[NSMutableArray alloc] init];
            
            NSURL *templateFile = [[NSURL alloc] initWithString:[@"file://" stringByAppendingString:[[[epiInfoForms stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"]]];
            NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:templateFile];
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:YES];
            BOOL success = [parser parse];
            if (success)
            {
                for (int i = 0; i < [formElementObjects count]; i++)
                {
                    FormElementObject *feo = [formElementObjects objectAtIndex:i];
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"1"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"2"])
                    {
                        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, nextY, canvasSV.frame.size.width - 32, 40)];
                        [titleLabel setBackgroundColor:[UIColor clearColor]];
                        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                        [titleLabel setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [canvas addSubview:titleLabel];
                        [canvas sendSubviewToBack:titleLabel];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                }
            }
        }
    }
    return self;
}

- (void)displayFieldsFromFEO
{
    nextY = nextYReset;
    if (YES)
    {
        for (int i = 0; i < [formElementObjects count]; i++)
        {
            FormElementObject *feo = [formElementObjects objectAtIndex:i];
            if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"1"])
            {
                TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                [controlRendering setBackgroundColor:[UIColor clearColor]];
                [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                [canvas addSubview:controlRendering];
                [canvas sendSubviewToBack:controlRendering];
                nextY += 40;
                [feo setNextY:nextY];
            }
            else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"2"])
            {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, nextY, canvasSV.frame.size.width - 32, 40)];
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [titleLabel setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                [canvas addSubview:titleLabel];
                [canvas sendSubviewToBack:titleLabel];
                nextY += 40;
                [feo setNextY:nextY];
            }
        }
    }
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
        epiInfoForms = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"];
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
    
    if (touchPoint.y > nextY)
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
    else
    {
        [canvasTapGesture setEnabled:NO];
        yTouched = touchPoint.y;
        for (int i = 0; i < [formElementObjects count]; i++)
        {
            FormElementObject *feo = [formElementObjects objectAtIndex:i];
            if (touchPoint.y < [feo nextY])
            {
                if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"1"])
                {
                    feoUnderEdit = feo;
                    [self presentTextView];
                }
                if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"2"])
                {
                    feoUnderEdit = feo;
                    [self presentLabelTitleView];
                }
                break;
            }
        }
    }
}

- (void)menuButtonPressed:(UIButton *)sender
{
    int buttonTag = ((int)(((float)((int)[sender tag])) / 1000000));
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [menu setFrame:CGRectMake(menu.frame.origin.x, self.frame.size.height, menu.frame.size.width, menu.frame.size.height)];
    } completion:^(BOOL finished){
        [menu removeFromSuperview];
        [canvasSV setScrollEnabled:YES];
        if (buttonTag == 1)
            [self presentNewFormView];
        else if (buttonTag == 2)
            [canvasTapGesture setEnabled:YES];
        else if (buttonTag == 3)
            [self presentLabelTitleView];
        else if (buttonTag == 4)
            [self presentTextView];
    }];
}

#pragma mark Present Views for Controls

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

- (void)presentLabelTitleView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tLabel/Title"];
    [controlViewViewLabel setTextAlignment:NSTextAlignmentLeft];
    [controlViewViewLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [controlViewGrayBackground addSubview:controlViewViewLabel];
    
    UITextField *controlViewPromptText = [[UITextField alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewPromptText setBackgroundColor:[UIColor whiteColor]];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [controlViewPromptText setLeftViewMode:UITextFieldViewModeAlways];
    [controlViewPromptText setLeftView:spacerView];
    [controlViewPromptText setPlaceholder:@"Label/Title text"];
    [controlViewPromptText setDelegate:self];
    [controlViewPromptText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [controlViewPromptText setReturnKeyType:UIReturnKeyDone];
    [controlViewPromptText setTag:1001001];
    [controlViewGrayBackground addSubview:controlViewPromptText];
    
    UITextField *controlViewFieldNameText = [[UITextField alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewFieldNameText setBackgroundColor:[UIColor whiteColor]];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [controlViewFieldNameText setLeftViewMode:UITextFieldViewModeAlways];
    [controlViewFieldNameText setLeftView:spacerView2];
    [controlViewFieldNameText setPlaceholder:@"Field Name"];
    [controlViewFieldNameText setDelegate:self];
    [controlViewFieldNameText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [controlViewFieldNameText setReturnKeyType:UIReturnKeyDone];
    [controlViewFieldNameText setTag:1001002];
    [controlViewGrayBackground addSubview:controlViewFieldNameText];
    
    UIButton *controlViewMoveUpButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 3 - 1, 0)];
    [controlViewMoveUpButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
    [controlViewMoveUpButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewMoveUpButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewMoveUpButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewMoveUpButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [controlViewMoveUpButton addTarget:self action:@selector(upDownDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewMoveUpButton setEnabled:NO];
    [controlViewGrayBackground addSubview:controlViewMoveUpButton];
    
    UIButton *controlViewMoveDnButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 3, 0, controlViewGrayBackground.frame.size.width / 3, 0)];
    [controlViewMoveDnButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
    [controlViewMoveDnButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewMoveDnButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewMoveDnButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewMoveDnButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [controlViewMoveDnButton addTarget:self action:@selector(upDownDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewMoveDnButton setEnabled:NO];
    [controlViewGrayBackground addSubview:controlViewMoveDnButton];
    
    UIButton *controlViewDeleteButton = [[UIButton alloc] initWithFrame:CGRectMake(2.0 * controlViewGrayBackground.frame.size.width / 3, 0, controlViewGrayBackground.frame.size.width / 3 - 1, 0)];
    [controlViewDeleteButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewDeleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewDeleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [controlViewDeleteButton addTarget:self action:@selector(upDownDeletePressed:) forControlEvents:UIControlEventTouchDownRepeat];
    [controlViewDeleteButton setEnabled:NO];
    [controlViewGrayBackground addSubview:controlViewDeleteButton];

    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(labelTitleSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(labelTitleSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewSaveButton setEnabled:NO];
    [controlViewSaveButton setTag:1001003];
    [controlViewGrayBackground addSubview:controlViewSaveButton];
    
    if (feoUnderEdit != nil)
    {
        [controlViewPromptText setText:[feoUnderEdit.FieldTagValues objectAtIndex:[feoUnderEdit.FieldTagElements indexOfObject:@"PromptText"]]];
        [controlViewFieldNameText setText:[feoUnderEdit.FieldTagValues objectAtIndex:[feoUnderEdit.FieldTagElements indexOfObject:@"Name"]]];
        [controlViewFieldNameText setEnabled:NO];
        [controlViewMoveUpButton setEnabled:YES];
        [controlViewMoveDnButton setEnabled:YES];
        [controlViewDeleteButton setEnabled:YES];
        [controlViewSaveButton setEnabled:YES];
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [controlViewGrayBackground setFrame:CGRectMake(controlViewGrayBackground.frame.origin.x, 0.08 * self.frame.size.height, 0.84 * self.frame.size.width, 202)];
        [controlViewViewLabel setFrame:CGRectMake(1, 1, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewPromptText setFrame:CGRectMake(1, 41, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewFieldNameText setFrame:CGRectMake(1, 81, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewMoveUpButton setFrame:CGRectMake(1, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [controlViewMoveDnButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3, 40)];
        [controlViewDeleteButton setFrame:CGRectMake(2.0 * controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [controlViewCancelButton setFrame:CGRectMake(1, 161, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewSaveButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 161, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)presentTextView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tText Field"];
    [controlViewViewLabel setTextAlignment:NSTextAlignmentLeft];
    [controlViewViewLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [controlViewGrayBackground addSubview:controlViewViewLabel];
    
    UITextField *controlViewPromptText = [[UITextField alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewPromptText setBackgroundColor:[UIColor whiteColor]];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [controlViewPromptText setLeftViewMode:UITextFieldViewModeAlways];
    [controlViewPromptText setLeftView:spacerView];
    [controlViewPromptText setPlaceholder:@"Field Prompt"];
    [controlViewPromptText setDelegate:self];
    [controlViewPromptText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [controlViewPromptText setReturnKeyType:UIReturnKeyDone];
    [controlViewPromptText setTag:1001001];
    [controlViewGrayBackground addSubview:controlViewPromptText];
    
    UITextField *controlViewFieldNameText = [[UITextField alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewFieldNameText setBackgroundColor:[UIColor whiteColor]];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [controlViewFieldNameText setLeftViewMode:UITextFieldViewModeAlways];
    [controlViewFieldNameText setLeftView:spacerView2];
    [controlViewFieldNameText setPlaceholder:@"Field Name"];
    [controlViewFieldNameText setDelegate:self];
    [controlViewFieldNameText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [controlViewFieldNameText setReturnKeyType:UIReturnKeyDone];
    [controlViewFieldNameText setTag:1001002];
    [controlViewGrayBackground addSubview:controlViewFieldNameText];
    
    UIButton *controlViewMoveUpButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 3 - 1, 0)];
    [controlViewMoveUpButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
    [controlViewMoveUpButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewMoveUpButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewMoveUpButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewMoveUpButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [controlViewMoveUpButton addTarget:self action:@selector(upDownDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewMoveUpButton setEnabled:NO];
    [controlViewGrayBackground addSubview:controlViewMoveUpButton];
    
    UIButton *controlViewMoveDnButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 3, 0, controlViewGrayBackground.frame.size.width / 3, 0)];
    [controlViewMoveDnButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
    [controlViewMoveDnButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewMoveDnButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewMoveDnButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewMoveDnButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [controlViewMoveDnButton addTarget:self action:@selector(upDownDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewMoveDnButton setEnabled:NO];
    [controlViewGrayBackground addSubview:controlViewMoveDnButton];
    
    UIButton *controlViewDeleteButton = [[UIButton alloc] initWithFrame:CGRectMake(2.0 * controlViewGrayBackground.frame.size.width / 3, 0, controlViewGrayBackground.frame.size.width / 3 - 1, 0)];
    [controlViewDeleteButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewDeleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewDeleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [controlViewDeleteButton addTarget:self action:@selector(upDownDeletePressed:) forControlEvents:UIControlEventTouchDownRepeat];
    [controlViewDeleteButton setEnabled:NO];
    [controlViewGrayBackground addSubview:controlViewDeleteButton];
    
    UIButton *checkCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [checkCodeButton setBackgroundColor:[UIColor whiteColor]];
    [checkCodeButton setTitle:@"Field Check Code" forState:UIControlStateNormal];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [checkCodeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:NO];
    [controlViewGrayBackground addSubview:checkCodeButton];

    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(textSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];

    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(textSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewSaveButton setEnabled:NO];
    [controlViewSaveButton setTag:1001003];
    [controlViewGrayBackground addSubview:controlViewSaveButton];
    
    if (feoUnderEdit != nil)
    {
        [controlViewPromptText setText:[feoUnderEdit.FieldTagValues objectAtIndex:[feoUnderEdit.FieldTagElements indexOfObject:@"PromptText"]]];
        [controlViewFieldNameText setText:[feoUnderEdit.FieldTagValues objectAtIndex:[feoUnderEdit.FieldTagElements indexOfObject:@"Name"]]];
        [controlViewFieldNameText setEnabled:NO];
        [controlViewMoveUpButton setEnabled:YES];
        [controlViewMoveDnButton setEnabled:YES];
        [controlViewDeleteButton setEnabled:YES];
        [controlViewSaveButton setEnabled:YES];
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [controlViewGrayBackground setFrame:CGRectMake(controlViewGrayBackground.frame.origin.x, 0.08 * self.frame.size.height, 0.84 * self.frame.size.width, 242)];
        [controlViewViewLabel setFrame:CGRectMake(1, 1, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewPromptText setFrame:CGRectMake(1, 41, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewFieldNameText setFrame:CGRectMake(1, 81, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewMoveUpButton setFrame:CGRectMake(1, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [controlViewMoveDnButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3, 40)];
        [controlViewDeleteButton setFrame:CGRectMake(2.0 * controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [checkCodeButton setFrame:CGRectMake(1, 161, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewCancelButton setFrame:CGRectMake(1, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewSaveButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)presentTextUppercaseView
{
}

- (void)presentMultilineView
{
}

- (void)presentNumberView
{
}

- (void)presentPhoneNumberView
{
}

- (void)presentDateView
{
}

- (void)presentCheckboxView
{
}

- (void)presentYesNoView
{
}

- (void)presentOptionView
{
}

- (void)presentImageView
{
}

- (void)presentLegalValuesView
{
}

- (void)presentCommentLegalView
{
}

#pragma mark Control View Buttons Touched

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
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"A form with that name is already on this device." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        [alertC addAction:okAction];
        [self.rootViewController presentViewController:alertC animated:YES completion:nil];
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
        [canvasTapGesture setEnabled:YES];
        if (saveButtonPressed)
        {
            NSLog(@"Save button pressed. Form name = %@.", newFormName);
            if ([newFormName length] > 0)
            {
                [formDesignerLabel setText:[NSString stringWithFormat:@"Form Designer: %@", newFormName]];
                formNamed = YES;
                formElements = [[NSMutableArray alloc] init];
                formElementObjects = [[NSMutableArray alloc] init];
                formName = [NSString stringWithString:newFormName];
                [self buildTheXMLFile];
                [self getExistingForms];
            }
        }
    }];
}

- (void)labelTitleSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [controlViewGrayBackground setFrame:CGRectMake(controlViewGrayBackground.frame.origin.x, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
        for (UIView *vv in [controlViewGrayBackground subviews])
        {
            [vv setFrame:CGRectMake(vv.frame.origin.x, 0, vv.frame.size.width, 0)];
        }
    } completion:^(BOOL finished){
        [controlViewGrayBackground removeFromSuperview];
        [canvasTapGesture setEnabled:YES];
        if (saveButtonPressed)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, nextY, canvasSV.frame.size.width - 32, 40)];
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                    [titleLabel setText:promptText];
                    [canvas addSubview:titleLabel];
                    [canvas sendSubviewToBack:titleLabel];
                    nextY += 40;
                }
                else
                {
                    for (UIView *v in [canvas subviews])
                    {
                        if (yTouched > v.frame.origin.y && yTouched < (v.frame.origin.y + v.frame.size.height))
                        {
                            if ([v isKindOfClass:[UILabel class]])
                            {
                                [(UILabel *)v setText:promptText];
                            }
                            break;
                        }
                    }
                }
                
                FormElementObject *feo = [[FormElementObject alloc] init];
                if (feoUnderEdit != nil)
                    feo = feoUnderEdit;
                feo.FieldTagElements = [[NSMutableArray alloc] init];
                feo.FieldTagValues = [[NSMutableArray alloc] init];
                [feo.FieldTagElements addObject:@"Name"];
                [feo.FieldTagValues addObject:fieldName];
                [feo.FieldTagElements addObject:@"PageId"];
                [feo.FieldTagValues addObject:@"1"];
                [feo.FieldTagElements addObject:@"IsReadOnly"];
                [feo.FieldTagValues addObject:@"False"];
                [feo.FieldTagElements addObject:@"IsRequired"];
                [feo.FieldTagValues addObject:@"False"];
                [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                [feo.FieldTagValues addObject:@"0.24853"];
                [feo.FieldTagElements addObject:@"PromptText"];
                [feo.FieldTagValues addObject:promptText];
                [feo.FieldTagElements addObject:@"FieldTypeId"];
                [feo.FieldTagValues addObject:@"2"];

                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)textSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [controlViewGrayBackground setFrame:CGRectMake(controlViewGrayBackground.frame.origin.x, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
        for (UIView *vv in [controlViewGrayBackground subviews])
        {
            [vv setFrame:CGRectMake(vv.frame.origin.x, 0, vv.frame.size.width, 0)];
        }
    } completion:^(BOOL finished){
        [controlViewGrayBackground removeFromSuperview];
        [canvasTapGesture setEnabled:YES];
        if (saveButtonPressed)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                }
                else
                {
                    for (UIView *v in [canvas subviews])
                    {
                        if (yTouched > v.frame.origin.y && yTouched < (v.frame.origin.y + v.frame.size.height))
                        {
                            if ([v isKindOfClass:[TextFieldDisplay class]])
                            {
                                [((TextFieldDisplay *)v).prompt setText:promptText];
                            }
                            break;
                        }
                    }
                }
                
                FormElementObject *feo = [[FormElementObject alloc] init];
                if (feoUnderEdit != nil)
                    feo = feoUnderEdit;
                feo.FieldTagElements = [[NSMutableArray alloc] init];
                feo.FieldTagValues = [[NSMutableArray alloc] init];
                [feo.FieldTagElements addObject:@"Name"];
                [feo.FieldTagValues addObject:fieldName];
                [feo.FieldTagElements addObject:@"PageId"];
                [feo.FieldTagValues addObject:@"1"];
                [feo.FieldTagElements addObject:@"IsReadOnly"];
                [feo.FieldTagValues addObject:@"False"];
                [feo.FieldTagElements addObject:@"IsRequired"];
                [feo.FieldTagValues addObject:@"False"];
                [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                [feo.FieldTagValues addObject:@"0.24853"];
                [feo.FieldTagElements addObject:@"PromptText"];
                [feo.FieldTagValues addObject:promptText];
                [feo.FieldTagElements addObject:@"FieldTypeId"];
                [feo.FieldTagValues addObject:@"1"];
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                }

                [self buildTheXMLFile];
                yTouched = -99.9;
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)upDownDeletePressed:(UIButton *)sender
{
    NSArray *buttonWords = [[[sender titleLabel] text] componentsSeparatedByString:@" "];
    BOOL delete = NO;
    BOOL moveUp = NO;
    if ([buttonWords count] == 1)
        delete = YES;
    else if ([(NSString *)[buttonWords objectAtIndex:1] isEqualToString:@"Up"])
        moveUp = YES;
    
    if (delete)
    {
        [formElementObjects removeObject:feoUnderEdit];
        [self buildTheXMLFile];
        for (UIView *v in [canvas subviews])
            if ([v tag] != 19572010)
                [v removeFromSuperview];
    }
    else if (moveUp)
    {
        if ([formElementObjects firstObject] == feoUnderEdit)
            return;
        int idx = (int)[formElementObjects indexOfObject:feoUnderEdit];
        [formElementObjects removeObjectAtIndex:idx];
        [formElementObjects insertObject:feoUnderEdit atIndex:idx - 1];
        [self buildTheXMLFile];
        for (UIView *v in [canvas subviews])
            if ([v tag] != 19572010)
                [v removeFromSuperview];
    }
    else
    {
        if ([formElementObjects lastObject] == feoUnderEdit)
            return;
        int idx = (int)[formElementObjects indexOfObject:feoUnderEdit];
        [formElementObjects removeObjectAtIndex:idx];
        [formElementObjects insertObject:feoUnderEdit atIndex:idx + 1];
        [self buildTheXMLFile];
        for (UIView *v in [canvas subviews])
            if ([v tag] != 19572010)
                [v removeFromSuperview];
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [controlViewGrayBackground setFrame:CGRectMake(controlViewGrayBackground.frame.origin.x, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
        for (UIView *vv in [controlViewGrayBackground subviews])
        {
            [vv setFrame:CGRectMake(vv.frame.origin.x, 0, vv.frame.size.width, 0)];
        }
    } completion:^(BOOL finished){
        [controlViewGrayBackground removeFromSuperview];
        [canvasTapGesture setEnabled:YES];
        [self displayFieldsFromFEO];
        feoUnderEdit = nil;
    }];
}

- (void)checkCodePressed:(UIButton *)sender
{
}

- (void)buildTheXMLFile
{
    NSMutableString *xmlMS = [[NSMutableString alloc] init];
    [xmlMS appendString:@"<?xml version=\"1.0\"?>\n"];
    [xmlMS appendString:[NSString stringWithFormat:@"<Template Level=\"View\" Name=\"%@\">\n", formName]];
    [xmlMS appendString:@"<Project>\n"];
    [xmlMS appendString:[NSString stringWithFormat:@"<View Name=\"%@\" ", formName]];
    [xmlMS appendString:@"LabelAlign=\"Vertical\" Orientation=\"Portrait\" Height=\"1016\" Width=\"780\" CheckCode=\""];
    [xmlMS appendString:@"\" IsRelatedView=\"False\" ViewId=\"1\">\n"];
    [xmlMS appendString:@"<Page Name=\"Page 1\" ViewId=\"1\" BackgroundId=\"0\" Position=\"0\" PageId=\"1\">\n"];
    for (int i = 0; i < [formElementObjects count]; i++)
    {
        FormElementObject *feo = (FormElementObject *)[formElementObjects objectAtIndex:i];
        [xmlMS appendFormat:@"<Field"];
        for (int j = 0; j < [feo.FieldTagElements count]; j++)
        {
            [xmlMS appendString:[NSString stringWithFormat:@" %@=\"%@\"", (NSString *)[feo.FieldTagElements objectAtIndex:j], (NSString *)[feo.FieldTagValues objectAtIndex:j]]];
        }
        [xmlMS appendFormat:@"/>\n"];
    }
    [xmlMS appendString:@"</Page>\n"];
    [xmlMS appendString:@"</View>\n"];
    [xmlMS appendString:@"</Project>\n"];
    [xmlMS appendString:@"</Template>"];
    NSString *xmlS = [NSString stringWithString:xmlMS];
    NSLog(@"%@", xmlS);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[paths objectAtIndex:0] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        NSString *filePathAndName = [[[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePathAndName])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePathAndName error:nil];
        }
        NSLog(@"%@", filePathAndName);
        [xmlS writeToFile:filePathAndName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)footerBarClose
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect formDesignerFrame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self setFrame:formDesignerFrame];
    } completion:^(BOOL finished) {
        if ([self.rootViewController isKindOfClass:[DataEntryViewController class]])
            [(DataEntryViewController *)self.rootViewController lvReset:formName];
        [self removeFromSuperview];
    }];
}

#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField tag] == 1001001)
    {
        if ([[(UITextField *)[[textField superview] viewWithTag:1001002] text] length] > 0)
            return YES;
        NSString *compressedText = [[textField text] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *incrementedText = [NSString stringWithString:compressedText];
        int increment = 0;
        while ([formElements containsObject:[incrementedText lowercaseString]])
            incrementedText = [compressedText stringByAppendingString:[NSString stringWithFormat:@"%d", increment++]];
        UITextField *variableNameField = [[textField superview] viewWithTag:1001002];
        [variableNameField setText:incrementedText];
        [self textFieldChanged:textField];
    }
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField
{
    if (![(UITextField *)[[textField superview] viewWithTag:1001002] isEnabled])
        return;
    if ([[(UITextField *)[[textField superview] viewWithTag:1001001] text] length] > 0 && [[(UITextField *)[[textField superview] viewWithTag:1001002] text] length] > 0)
        [(UIButton *)[[textField superview] viewWithTag:1001003] setEnabled:YES];
    else
    {
        [(UIButton *)[[textField superview] viewWithTag:1001003] setEnabled:NO];
        if ([textField tag] == 1001001)
            return;
    }
    if ([formElements containsObject:[[(UITextField *)[[textField superview] viewWithTag:1001002] text] lowercaseString]])
    {
        [(UIButton *)[[textField superview] viewWithTag:1001003] setEnabled:NO];
        [(UITextField *)[[textField superview] viewWithTag:1001002] setTextColor:[UIColor redColor]];
    }
    else
        [(UITextField *)[[textField superview] viewWithTag:1001002] setTextColor:[UIColor blackColor]];
}

#pragma mark XML Parsing Methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Field"])
    {
        [formElements addObject:[[NSString stringWithString:[attributeDict objectForKey:@"Name"]] lowercaseString]];
        FormElementObject *feo = [[FormElementObject alloc] init];
        feo.FieldTagElements = [[NSMutableArray alloc] init];
        feo.FieldTagValues = [[NSMutableArray alloc] init];
        [feo.FieldTagElements addObject:@"Name"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"Name"]]];
        [feo.FieldTagElements addObject:@"PageId"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"PageId"]]];
        [feo.FieldTagElements addObject:@"IsReadOnly"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"IsReadOnly"]]];
        [feo.FieldTagElements addObject:@"IsRequired"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"IsRequired"]]];
        [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"ControlWidthPercentage"]]];
        [feo.FieldTagElements addObject:@"PromptText"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"PromptText"]]];
        [feo.FieldTagElements addObject:@"FieldTypeId"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"FieldTypeId"]]];
        [formElementObjects addObject:feo];
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
