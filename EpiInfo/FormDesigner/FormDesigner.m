//
//  FormDesigner.m
//  EpiInfo
//
//  Created by John Copeland on 2/13/19.
//

#import "FormDesigner.h"
#import "DataEntryViewController.h"
#import "TextFieldDisplay.h"
#import "CheckCodeWriter.h"
#import "PageCheckCodeWriter.h"
#import "VariablesInGroupSelector.h"

@implementation FormDesigner
@synthesize rootViewController = _rootViewController;

- (NSMutableArray *)formElementObjects
{
    return formElementObjects;
}
- (NSMutableArray *)pageNames
{
    return pageNames;
}
- (NSMutableArray *)checkCodeStrings
{
    return checkCodeStrings;
}

- (void)setDeletedFieldIfBlocks:(NSMutableArray *)dfib
{
    deletedFieldIfBlocks = dfib;
}

- (void)addCheckCodeString:(NSString *)ccString
{
    if (checkCodeStrings == nil)
        checkCodeStrings = [[NSMutableArray alloc] init];
    [checkCodeStrings addObject:ccString];
}

- (id)initWithFrame:(CGRect)frame andSender:(nonnull UIButton *)sender
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setAccessibilityViewIsModal:YES];
        lastPage = 1;
        checkCodeString = @"";
        justParsingForCheckCode = NO;
        checkCodeStrings = [[NSMutableArray alloc] init];
        yTouched = -99.9;
        [self getExistingForms];
        
        NSError *fileError;
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Reserved_Words" ofType:@"txt"];
        NSString *fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&fileError];
        reservedWords = [[fileString lowercaseString] componentsSeparatedByString:@","];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        float formDesignerLabelY = 0.0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            formDesignerLabelY = 8.0;
        formDesignerLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, formDesignerLabelY, self.frame.size.width, 32)];
        [formDesignerLabel setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:0.95]];
        [formDesignerLabel setTitle:@"Form Designer" forState:UIControlStateNormal];
        [formDesignerLabel setAccessibilityLabel:@"Form Designer. Double tap for options."];
        [formDesignerLabel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
        if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
        {
            [formDesignerLabel setTitle:@"Diseñador de Formularios" forState:UIControlStateNormal];
            [formDesignerLabel setAccessibilityLabel:@"Diseñador de Formularios"];
        }
        [formDesignerLabel setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [formDesignerLabel.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [formDesignerLabel addTarget:self action:@selector(bannerTap:) forControlEvents:UIControlEventTouchUpInside];
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

//        [formDesignerLabel addGestureRecognizer:canvasTapGesture];

        formNamed = NO;
        
        NSArray *senderTitleArray = [[[sender titleLabel] text] componentsSeparatedByString:@" "];
        if ([(NSString *)[senderTitleArray objectAtIndex:0] isEqualToString:@"Edit"])
        {
            formName = [NSString stringWithString:[senderTitleArray objectAtIndex:1]];
            [formDesignerLabel setTitle:[NSString stringWithFormat:@"Form Designer: %@", formName] forState:UIControlStateNormal];
            [formDesignerLabel setAccessibilityLabel:[NSString stringWithFormat:@"Form Designer. %@. Double tap for options.", formName]];
            formNamed = YES;
            formElements = [[NSMutableArray alloc] init];
            formElementObjects = [[NSMutableArray alloc] init];
            pages = [[NSMutableArray alloc] init];
            [pages addObject:[[NSMutableArray alloc] init]];
            pageNames = [[NSMutableArray alloc] init];
            pageNumbers = [[NSMutableArray alloc] init];
            actualPageNumbers = [[NSMutableArray alloc] init];

            NSURL *templateFile = [[NSURL alloc] initWithString:[@"file://" stringByAppendingString:[[[epiInfoForms stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"]]];
            NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:templateFile];
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:YES];
//            NSLog(@"CONSUMING XML: %@", [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:[@"file://" stringByAppendingString:[[[epiInfoForms stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"]]] encoding:NSUTF8StringEncoding error:nil]);
            BOOL success = [parser parse];
            if (success)
            {
                for (int i = (int)[pages count] - 1; i >= 0; i--)
                {
                    NSMutableArray *page = [pages objectAtIndex:i];
                    if ([page count] == 0)
                    {
                        [pages removeObjectAtIndex:i];
                        continue;
                    }
                    BOOL nothingButPageBreaks = YES;
                    for (int j = 0; j < [page count]; j++)
                    {
                        FormElementObject *feoj = (FormElementObject *)[page objectAtIndex:j];
                        if (![[feoj.FieldTagValues objectAtIndex:[feoj.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"99"])
                        {
                            nothingButPageBreaks = NO;
                            break;
                        }
                    }
                    if (nothingButPageBreaks)
                    {
                        [pages removeObjectAtIndex:i];
                    }
                }
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
                        [titleLabel setAccessibilityLabel:[NSString stringWithFormat:@"%@. Double tap to edit label or title.", [feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]]];
                        [canvas addSubview:titleLabel];
                        [canvas sendSubviewToBack:titleLabel];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"3"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"4"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 80;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"5"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"6"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering.field setText:@"555-555-5555"];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"7"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayDate];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"10"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering checkTheBox];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"11"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayYesNo];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 80;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"12"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayOption];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 80;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"13"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayCommandButton];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"14"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayImage];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 80;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"17"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayLegalValues];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"19"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayLegalValues];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"20"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayButton];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"21"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2.0, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayGroup];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                    else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"99"])
                    {
                        TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                        [controlRendering setBackgroundColor:[UIColor clearColor]];
                        [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                        [controlRendering displayPageBreak];
                        [canvas addSubview:controlRendering];
                        [canvas sendSubviewToBack:controlRendering];
                        nextY += 40;
                        [feo setNextY:nextY];
                    }
                }
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
                
                [self processCheckCodeString];
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
        for (int h = 0; h < [pages count]; h++)
        {
            NSMutableArray *arrayH = (NSMutableArray *)[pages objectAtIndex:h];
            if ([arrayH count] == 0)
                continue;
            for (int i = 0; i < [arrayH count]; i++)
            {
                FormElementObject *feo = [arrayH objectAtIndex:i];
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
                    [titleLabel setAccessibilityLabel:[NSString stringWithFormat:@"%@. Double tap to edit label or title.", [feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]]];
                    [canvas addSubview:titleLabel];
                    [canvas sendSubviewToBack:titleLabel];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"3"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"4"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 80;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"5"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"6"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering.field setText:@"555-555-5555"];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"7"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayDate];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"10"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering checkTheBox];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"11"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayYesNo];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 80;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"12"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayOption];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 80;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"13"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayCommandButton];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"14"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayImage];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 80;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"17"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayLegalValues];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"19"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayLegalValues];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"20"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayButton];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"21"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2.0, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayGroup];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
                else if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"99"])
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PromptText"]]];
                    [controlRendering displayPageBreak];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 40;
                    [feo setNextY:nextY];
                }
            }
        }
        [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
        [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
        [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
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

- (void)bannerTap:(UIButton *)sender
{
    {
        CGPoint touchPoint = CGPointMake(sender.frame.origin.x, sender.frame.origin.y);
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
        
        UIButton *pageBreakButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [pageBreakButton setBackgroundColor:[UIColor whiteColor]];
        [pageBreakButton setTitle:@"\tInsert Page Break" forState:UIControlStateNormal];
        [pageBreakButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [pageBreakButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [pageBreakButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [pageBreakButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [pageBreakButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [pageBreakButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pageBreakButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:pageBreakButton];
        [pageBreakButton setEnabled:formNamed];
        
        UIButton *distributeFormButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [distributeFormButton setBackgroundColor:[UIColor whiteColor]];
        [distributeFormButton setTitle:@"\tDistribute Form Template" forState:UIControlStateNormal];
        [distributeFormButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [distributeFormButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [distributeFormButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [distributeFormButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [distributeFormButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [distributeFormButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [distributeFormButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:distributeFormButton];
        [distributeFormButton setEnabled:formNamed];
        
        NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
        if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
        {
            [newFormButton setTitle:@"\tNuevo" forState:UIControlStateNormal];
            [cancelButton setTitle:@"\tCancelar" forState:UIControlStateNormal];
            [labelButton setTitle:@"\tEtiqueta/Título" forState:UIControlStateNormal];
            [textButton setTitle:@"\tTexto" forState:UIControlStateNormal];
            [uppercasetextButton setTitle:@"\tTexto (Mayúscula)" forState:UIControlStateNormal];
            [multilineButton setTitle:@"\tMultílinea" forState:UIControlStateNormal];
            [numberButton setTitle:@"\tNúmero" forState:UIControlStateNormal];
            [phonenumberButton setTitle:@"\tNúmero de Teléfono" forState:UIControlStateNormal];
            [dateButton setTitle:@"\tFecha" forState:UIControlStateNormal];
            [checkboxButton setTitle:@"\tCasilla" forState:UIControlStateNormal];
            [yesnoButton setTitle:@"\tSi/No" forState:UIControlStateNormal];
            [optionButton setTitle:@"\tOpción" forState:UIControlStateNormal];
            [imagefieldButton setTitle:@"\tImagen" forState:UIControlStateNormal];
            [legalvaluesButton setTitle:@"\tValores Legales" forState:UIControlStateNormal];
            [commentlegalButton setTitle:@"\tCódigo-Descripcíon" forState:UIControlStateNormal];
            [pageBreakButton setTitle:@"\tInsert Page Break" forState:UIControlStateNormal];
            [distributeFormButton setTitle:@"\tDistribute Form Template" forState:UIControlStateNormal];
        }

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

- (void)canvasTap:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint touchPoint = [tapRecognizer locationInView:self];
    CGPoint svOffset = [canvasSV contentOffset];
    
    if (touchPoint.y + svOffset.y > nextY)
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

        UIButton *commandbuttonButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [commandbuttonButton setBackgroundColor:[UIColor whiteColor]];
        [commandbuttonButton setTitle:@"\tCommand Button" forState:UIControlStateNormal];
        [commandbuttonButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [commandbuttonButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [commandbuttonButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [commandbuttonButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [commandbuttonButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [commandbuttonButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [commandbuttonButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:commandbuttonButton];
        [commandbuttonButton setEnabled:formNamed];
        
        UIButton *groupButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [groupButton setBackgroundColor:[UIColor whiteColor]];
        [groupButton setTitle:@"\tVariable Group" forState:UIControlStateNormal];
        [groupButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [groupButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [groupButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [groupButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [groupButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [groupButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [groupButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:groupButton];
        [groupButton setEnabled:formNamed];

        UIButton *pageBreakButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [pageBreakButton setBackgroundColor:[UIColor whiteColor]];
        [pageBreakButton setTitle:@"\tInsert Page Break" forState:UIControlStateNormal];
        [pageBreakButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [pageBreakButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [pageBreakButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [pageBreakButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [pageBreakButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [pageBreakButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pageBreakButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:pageBreakButton];
        [pageBreakButton setEnabled:formNamed];

        UIButton *distributeFormButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [distributeFormButton setBackgroundColor:[UIColor whiteColor]];
        [distributeFormButton setTitle:@"\tDistribute Form Template" forState:UIControlStateNormal];
        [distributeFormButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [distributeFormButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [distributeFormButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [distributeFormButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [distributeFormButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [distributeFormButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [distributeFormButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:distributeFormButton];
        [distributeFormButton setEnabled:formNamed];

        UIButton *pageCheckCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [pageCheckCodeButton setBackgroundColor:[UIColor whiteColor]];
        [pageCheckCodeButton setTitle:@"\tCheck Code" forState:UIControlStateNormal];
        [pageCheckCodeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [pageCheckCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [pageCheckCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [pageCheckCodeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [pageCheckCodeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [pageCheckCodeButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pageCheckCodeButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:pageCheckCodeButton];
        [pageCheckCodeButton setEnabled:formNamed];

        UIButton *showFormTemplateButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2.0 * initialButtonHeight, menu.frame.size.width - 2, initialButtonHeight)];
        [showFormTemplateButton setBackgroundColor:[UIColor whiteColor]];
        [showFormTemplateButton setTitle:@"\tShow Form Template Text" forState:UIControlStateNormal];
        [showFormTemplateButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [showFormTemplateButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [showFormTemplateButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [showFormTemplateButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [showFormTemplateButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [showFormTemplateButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [showFormTemplateButton setTag:tagIncrementer++ * 1000000 + 1957];
        [menu addSubview:showFormTemplateButton];
        [showFormTemplateButton setEnabled:formNamed];
        
        NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
        if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
        {
            [newFormButton setTitle:@"\tNuevo" forState:UIControlStateNormal];
            [cancelButton setTitle:@"\tCancelar" forState:UIControlStateNormal];
            [labelButton setTitle:@"\tEtiqueta/Título" forState:UIControlStateNormal];
            [textButton setTitle:@"\tTexto" forState:UIControlStateNormal];
            [uppercasetextButton setTitle:@"\tTexto (Mayúscula)" forState:UIControlStateNormal];
            [multilineButton setTitle:@"\tMultílinea" forState:UIControlStateNormal];
            [numberButton setTitle:@"\tNúmero" forState:UIControlStateNormal];
            [phonenumberButton setTitle:@"\tNúmero de Teléfono" forState:UIControlStateNormal];
            [dateButton setTitle:@"\tFecha" forState:UIControlStateNormal];
            [checkboxButton setTitle:@"\tCasilla" forState:UIControlStateNormal];
            [yesnoButton setTitle:@"\tSi/No" forState:UIControlStateNormal];
            [optionButton setTitle:@"\tOpción" forState:UIControlStateNormal];
            [imagefieldButton setTitle:@"\tImagen" forState:UIControlStateNormal];
            [legalvaluesButton setTitle:@"\tValores Legales" forState:UIControlStateNormal];
            [commentlegalButton setTitle:@"\tCódigo-Descripcíon" forState:UIControlStateNormal];
            [pageBreakButton setTitle:@"\tInsert Page Break" forState:UIControlStateNormal];
            [distributeFormButton setTitle:@"\tDistribute Form Template" forState:UIControlStateNormal];
            [pageCheckCodeButton setTitle:@"\tCódigo Check" forState:UIControlStateNormal];
            [showFormTemplateButton setTitle:@"\tShow Form Template Text" forState:UIControlStateNormal];
            [commandbuttonButton setTitle:@"\tBotón de Comando" forState:UIControlStateNormal];
            [groupButton setTitle:@"\tGrupo" forState:UIControlStateNormal];
        }

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
        yTouched = touchPoint.y + svOffset.y;
        for (int h = 0; h < [pages count]; h++)
        {
            NSMutableArray *arrayH = (NSMutableArray *)[pages objectAtIndex:h];
            if ([arrayH count] == 0)
                continue;
            for (int i = 0; i < [arrayH count]; i++)
            {
                FormElementObject *feo = [arrayH objectAtIndex:i];
                if (touchPoint.y + svOffset.y < [feo nextY])
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
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"3"])
                    {
                        feoUnderEdit = feo;
                        [self presentTextUppercaseView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"4"])
                    {
                        feoUnderEdit = feo;
                        [self presentMultilineView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"5"])
                    {
                        feoUnderEdit = feo;
                        [self presentNumberView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"6"])
                    {
                        feoUnderEdit = feo;
                        [self presentPhoneNumberView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"7"])
                    {
                        feoUnderEdit = feo;
                        [self presentDateView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"10"])
                    {
                        feoUnderEdit = feo;
                        [self presentCheckboxView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"11"])
                    {
                        feoUnderEdit = feo;
                        [self presentYesNoView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"12"])
                    {
                        feoUnderEdit = feo;
                        [self presentOptionView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"13"])
                    {
                        feoUnderEdit = feo;
                        [self presentCommandButtonView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"14"])
                    {
                        feoUnderEdit = feo;
                        [self presentImageView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"17"])
                    {
                        feoUnderEdit = feo;
                        [self presentLegalValuesView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"19"])
                    {
                        feoUnderEdit = feo;
                        [self presentCommentLegalView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"20"])
                    {
                        feoUnderEdit = feo;
                        [self presentButtonView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"21"])
                    {
                        feoUnderEdit = feo;
                        [self presentGroupView];
                    }
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"99"])
                    {
                        NSLog(@"Page Break Pressed");
                        [canvasTapGesture setEnabled:YES];
                        if ([(NSMutableArray *)[pages lastObject] lastObject] == feo)
                        {
                            feoUnderEdit = feo;
                            UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
                            [tempButton setTitle:@"PageBreak" forState:UIControlStateNormal];
                            [self upDownDeletePressed:tempButton];
                        }
                    }
                    return;
                }
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
        else if (buttonTag == 5)
            [self presentTextUppercaseView];
        else if (buttonTag == 6)
            [self presentMultilineView];
        else if (buttonTag == 7)
            [self presentNumberView];
        else if (buttonTag == 8)
            [self presentPhoneNumberView];
        else if (buttonTag == 9)
            [self presentDateView];
        else if (buttonTag == 10)
            [self presentCheckboxView];
        else if (buttonTag == 11)
            [self presentYesNoView];
        else if (buttonTag == 12)
            [self presentOptionView];
        else if (buttonTag == 13)
            [self presentImageView];
        else if (buttonTag == 14)
            [self presentLegalValuesView];
        else if (buttonTag == 15)
            [self presentCommentLegalView];
        else if (buttonTag == 16)
            [self presentCommandButtonView];
        else if (buttonTag == 17)
            [self presentGroupView];
        else if (buttonTag == 18)
            [self insertPageBreakPressed:sender];
        else if (buttonTag == 19)
            [self distributeFormPressed:sender];
        else if (buttonTag == 20)
            [self pageCheckCodePressed:sender];
        else if (buttonTag == 21)
            [self showHideFormTemplate:sender];
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
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [newFormViewLabel setText:@"\tForm Name:"];
        [newFormViewText setPlaceholder:@"Enter form name."];
        [newFormViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [newFormViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
    }

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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tEtiqueta/Título"];
        [controlViewPromptText setPlaceholder:@"Etiqueta/Título Texto"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Text Field" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tTexto"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tUppercase Text Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Uppercase Text" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(uppercaseSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(uppercaseSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tMayúscula"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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

- (void)presentMultilineView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tMultiline Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Multiline Field" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(multilineSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(multilineSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tMultílinea"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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

- (void)presentNumberView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tNumber Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Number Field" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(numberSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(numberSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tNúmero"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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

- (void)presentPhoneNumberView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tPhone Number Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Phone Number" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(phoneNumberSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(phoneNumberSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tNúmero de Teléfono"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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

- (void)presentDateView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tDate Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Date" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    [controlViewGrayBackground.layer setValue:@"" forKey:@"CheckCode"];

    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(dateSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(dateSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tFecha"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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

- (void)presentCheckboxView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tCheckbox Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Checkbox" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(checkboxSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(checkboxSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tCasilla"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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

- (void)presentYesNoView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tYes/No Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Yes/No Field" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(yesnoSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(yesnoSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tSi/No"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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

- (void)presentOptionView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tOption Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewDeleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [controlViewDeleteButton addTarget:self action:@selector(upDownDeletePressed:) forControlEvents:UIControlEventTouchDownRepeat];
    [controlViewDeleteButton setEnabled:NO];
    [controlViewGrayBackground addSubview:controlViewDeleteButton];
    
    UIButton *checkCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [checkCodeButton setBackgroundColor:[UIColor whiteColor]];
    [checkCodeButton setTitle:@"Field Check Code" forState:UIControlStateNormal];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [checkCodeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [checkCodeButton.layer setValue:@"Option Field" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *valuesButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [valuesButton setBackgroundColor:[UIColor whiteColor]];
    [valuesButton setTitle:@"Values" forState:UIControlStateNormal];
    [valuesButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [valuesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [valuesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [valuesButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [valuesButton addTarget:self action:@selector(valuesPressed:) forControlEvents:UIControlEventTouchUpInside];
    [valuesButton setEnabled:NO];
    [valuesButton setTag:1001004];
    [controlViewGrayBackground addSubview:valuesButton];

    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(optionSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(optionSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
        [valuesButton setEnabled:YES];
        if (feoUnderEdit.values != nil)
        {
            if ([feoUnderEdit.values count] > 0)
            {
                valuesFields = [[NSMutableArray alloc] init];
                for (int i = 0; i < [feoUnderEdit.values count]; i++)
                {
                    UITextField *valueText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
                    [valueText setBackgroundColor:[UIColor whiteColor]];
                    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
                    [valueText setLeftViewMode:UITextFieldViewModeAlways];
                    [valueText setLeftView:spacerView];
                    [valueText setPlaceholder:@"Value"];
                    [valueText setDelegate:self];
                    [valueText addTarget:self action:@selector(valueFieldChanged:) forControlEvents:UIControlEventEditingChanged];
                    [valueText setReturnKeyType:UIReturnKeyDone];
                    [valueText setText:(NSString *)[feoUnderEdit.values objectAtIndex:i]];
                    [valuesFields addObject:valueText];
                }
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tOpción"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
    }

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [controlViewGrayBackground setFrame:CGRectMake(controlViewGrayBackground.frame.origin.x, 0.08 * self.frame.size.height, 0.84 * self.frame.size.width, 242)];
        [controlViewViewLabel setFrame:CGRectMake(1, 1, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewPromptText setFrame:CGRectMake(1, 41, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewFieldNameText setFrame:CGRectMake(1, 81, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewMoveUpButton setFrame:CGRectMake(1, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [controlViewMoveDnButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3, 40)];
        [controlViewDeleteButton setFrame:CGRectMake(2.0 * controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [checkCodeButton setFrame:CGRectMake(1, 161, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [valuesButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 161, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewCancelButton setFrame:CGRectMake(1, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewSaveButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)presentImageView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tImage Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [controlViewCancelButton addTarget:self action:@selector(imageSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(imageSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tImagen"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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

- (void)presentLegalValuesView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tLegal Values Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewDeleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [controlViewDeleteButton addTarget:self action:@selector(upDownDeletePressed:) forControlEvents:UIControlEventTouchDownRepeat];
    [controlViewDeleteButton setEnabled:NO];
    [controlViewGrayBackground addSubview:controlViewDeleteButton];
    
    UIButton *checkCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [checkCodeButton setBackgroundColor:[UIColor whiteColor]];
    [checkCodeButton setTitle:@"Field Check Code" forState:UIControlStateNormal];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [checkCodeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [checkCodeButton.layer setValue:@"Legal Values" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *valuesButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [valuesButton setBackgroundColor:[UIColor whiteColor]];
    [valuesButton setTitle:@"Values" forState:UIControlStateNormal];
    [valuesButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [valuesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [valuesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [valuesButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [valuesButton addTarget:self action:@selector(valuesPressed:) forControlEvents:UIControlEventTouchUpInside];
    [valuesButton setEnabled:NO];
    [valuesButton setTag:1001004];
    [controlViewGrayBackground addSubview:valuesButton];
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(legalValuesSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(legalValuesSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
        [valuesButton setEnabled:YES];
        if (feoUnderEdit.values != nil)
        {
            if ([feoUnderEdit.values count] > 0)
            {
                if ([(NSString *)[feoUnderEdit.values lastObject] length] > 0)
                    [feoUnderEdit.values addObject:@""];
                valuesFields = [[NSMutableArray alloc] init];
                for (int i = 0; i < [feoUnderEdit.values count]; i++)
                {
                    UITextField *valueText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
                    [valueText setBackgroundColor:[UIColor whiteColor]];
                    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
                    [valueText setLeftViewMode:UITextFieldViewModeAlways];
                    [valueText setLeftView:spacerView];
                    [valueText setPlaceholder:@"Value"];
                    [valueText setDelegate:self];
                    [valueText addTarget:self action:@selector(valueFieldChanged:) forControlEvents:UIControlEventEditingChanged];
                    [valueText setReturnKeyType:UIReturnKeyDone];
                    [valueText setText:(NSString *)[feoUnderEdit.values objectAtIndex:i]];
                    [valuesFields addObject:valueText];
                }
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tValores Legales"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
    }

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [controlViewGrayBackground setFrame:CGRectMake(controlViewGrayBackground.frame.origin.x, 0.08 * self.frame.size.height, 0.84 * self.frame.size.width, 242)];
        [controlViewViewLabel setFrame:CGRectMake(1, 1, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewPromptText setFrame:CGRectMake(1, 41, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewFieldNameText setFrame:CGRectMake(1, 81, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewMoveUpButton setFrame:CGRectMake(1, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [controlViewMoveDnButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3, 40)];
        [controlViewDeleteButton setFrame:CGRectMake(2.0 * controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [checkCodeButton setFrame:CGRectMake(1, 161, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [valuesButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 161, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewCancelButton setFrame:CGRectMake(1, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewSaveButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)presentCommentLegalView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tComment Legal Field"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewDeleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewDeleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [controlViewDeleteButton addTarget:self action:@selector(upDownDeletePressed:) forControlEvents:UIControlEventTouchDownRepeat];
    [controlViewDeleteButton setEnabled:NO];
    [controlViewGrayBackground addSubview:controlViewDeleteButton];
    
    UIButton *checkCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [checkCodeButton setBackgroundColor:[UIColor whiteColor]];
    [checkCodeButton setTitle:@"Field Check Code" forState:UIControlStateNormal];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [checkCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [checkCodeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [checkCodeButton.layer setValue:@"Comment Legal" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *valuesButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [valuesButton setBackgroundColor:[UIColor whiteColor]];
    [valuesButton setTitle:@"Values" forState:UIControlStateNormal];
    [valuesButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [valuesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [valuesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [valuesButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [valuesButton addTarget:self action:@selector(valuesPressed:) forControlEvents:UIControlEventTouchUpInside];
    [valuesButton setEnabled:NO];
    [valuesButton setTag:1001004];
    [controlViewGrayBackground addSubview:valuesButton];
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(commentLegalSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(commentLegalSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
        [valuesButton setEnabled:YES];
        if (feoUnderEdit.values != nil)
        {
            if ([feoUnderEdit.values count] > 0)
            {
                if ([(NSString *)[feoUnderEdit.values lastObject] length] > 0)
                    [feoUnderEdit.values addObject:@""];
                valuesFields = [[NSMutableArray alloc] init];
                for (int i = 0; i < [feoUnderEdit.values count]; i++)
                {
                    UITextField *valueText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
                    [valueText setBackgroundColor:[UIColor whiteColor]];
                    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
                    [valueText setLeftViewMode:UITextFieldViewModeAlways];
                    [valueText setLeftView:spacerView];
                    [valueText setPlaceholder:@"Value"];
                    [valueText setDelegate:self];
                    [valueText addTarget:self action:@selector(valueFieldChanged:) forControlEvents:UIControlEventEditingChanged];
                    [valueText setReturnKeyType:UIReturnKeyDone];
                    [valueText setText:(NSString *)[feoUnderEdit.values objectAtIndex:i]];
                    [valuesFields addObject:valueText];
                }
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tCódigo-Descripcíon"];
        [controlViewPromptText setPlaceholder:@"Field Prompt"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
    }

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [controlViewGrayBackground setFrame:CGRectMake(controlViewGrayBackground.frame.origin.x, 0.08 * self.frame.size.height, 0.84 * self.frame.size.width, 242)];
        [controlViewViewLabel setFrame:CGRectMake(1, 1, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewPromptText setFrame:CGRectMake(1, 41, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewFieldNameText setFrame:CGRectMake(1, 81, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewMoveUpButton setFrame:CGRectMake(1, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [controlViewMoveDnButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3, 40)];
        [controlViewDeleteButton setFrame:CGRectMake(2.0 * controlViewGrayBackground.frame.size.width / 3, 121, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [checkCodeButton setFrame:CGRectMake(1, 161, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [valuesButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 161, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewCancelButton setFrame:CGRectMake(1, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewSaveButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)presentCommandButtonView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tCommand Button"];
    [controlViewViewLabel setTextAlignment:NSTextAlignmentLeft];
    [controlViewViewLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [controlViewGrayBackground addSubview:controlViewViewLabel];
    
    UITextField *controlViewPromptText = [[UITextField alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewPromptText setBackgroundColor:[UIColor whiteColor]];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [controlViewPromptText setLeftViewMode:UITextFieldViewModeAlways];
    [controlViewPromptText setLeftView:spacerView];
    [controlViewPromptText setPlaceholder:@"Button Text"];
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Command Button" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    [controlViewGrayBackground addSubview:checkCodeButton];
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(commandButtonSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 0, controlViewGrayBackground.frame.size.width / 2 - 1, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(commandButtonSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        for (int i = 0; i < [checkCodeStrings count]; i++)
        {
            NSArray *nsa = [[checkCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "];
            if ([[nsa objectAtIndex:1] containsString:[controlViewFieldNameText text]])
            {
                [controlViewGrayBackground.layer setValue:[checkCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
                [checkCodeStrings removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tBotón de Comando"];
        [controlViewPromptText setPlaceholder:@"Button Text"];
        [controlViewFieldNameText setPlaceholder:@"Field Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
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

- (void)presentButtonView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tRelate Button (No Editing Yet)"];
    [controlViewViewLabel setTextAlignment:NSTextAlignmentLeft];
    [controlViewViewLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
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
    [controlViewPromptText setEnabled:NO];
    
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
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [controlViewGrayBackground addSubview:controlViewFieldNameText];
    [controlViewFieldNameText setEnabled:NO];
    
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
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
//        [controlViewMoveUpButton setEnabled:YES];
//        [controlViewMoveDnButton setEnabled:YES];
//        [controlViewDeleteButton setEnabled:YES];
//        [controlViewSaveButton setEnabled:YES];
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

- (void)presentGroupView
{
    controlViewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0.08 * self.frame.size.width, formDesignerLabel.frame.origin.y + formDesignerLabel.frame.size.height, 0.84 * self.frame.size.width, 0)];
    [controlViewGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [self addSubview:controlViewGrayBackground];
    
    UILabel *controlViewViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewViewLabel setBackgroundColor:[UIColor whiteColor]];
    [controlViewViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewViewLabel setText:@"\tVariable Group"];
    [controlViewViewLabel setTextAlignment:NSTextAlignmentLeft];
    [controlViewViewLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [controlViewGrayBackground addSubview:controlViewViewLabel];
    
    UITextField *controlViewPromptText = [[UITextField alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewPromptText setBackgroundColor:[UIColor whiteColor]];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [controlViewPromptText setLeftViewMode:UITextFieldViewModeAlways];
    [controlViewPromptText setLeftView:spacerView];
    [controlViewPromptText setPlaceholder:@"Group Label"];
    [controlViewPromptText setDelegate:self];
    [controlViewPromptText addTarget:self action:@selector(textFieldChangedInGroupView:) forControlEvents:UIControlEventEditingChanged];
    [controlViewPromptText setReturnKeyType:UIReturnKeyDone];
    [controlViewPromptText setTag:1001001];
    [controlViewGrayBackground addSubview:controlViewPromptText];
    
    UITextField *controlViewFieldNameText = [[UITextField alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0)];
    [controlViewFieldNameText setBackgroundColor:[UIColor whiteColor]];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [controlViewFieldNameText setLeftViewMode:UITextFieldViewModeAlways];
    [controlViewFieldNameText setLeftView:spacerView2];
    [controlViewFieldNameText setPlaceholder:@"Group Name"];
    [controlViewFieldNameText setDelegate:self];
    [controlViewFieldNameText addTarget:self action:@selector(textFieldChangedInGroupView:) forControlEvents:UIControlEventEditingChanged];
    [controlViewFieldNameText setReturnKeyType:UIReturnKeyDone];
    [controlViewFieldNameText setTag:1001002];
    [controlViewFieldNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
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
    [controlViewMoveUpButton setTag:1001005];
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
    [controlViewMoveDnButton setTag:1001006];
    [controlViewGrayBackground addSubview:controlViewMoveDnButton];

    UIButton *controlViewDeleteButton = [[UIButton alloc] initWithFrame:CGRectMake(2.0 * controlViewGrayBackground.frame.size.width / 3, 0, controlViewGrayBackground.frame.size.width / 3 - 1, 0)];
    [controlViewDeleteButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewDeleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [controlViewDeleteButton setAccessibilityLabel:@"Delete. Triple tap to delete control from form."];
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
    [checkCodeButton.layer setValue:@"Command Button" forKey:@"FieldType"];
    [checkCodeButton addTarget:self action:@selector(checkCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeButton setEnabled:YES];
    
    NSMutableArray *variablesThatCanBeInGroups = [[NSMutableArray alloc] init];
    NSMutableArray *selectRowNumbers = [[NSMutableArray alloc] init];
    for (int i = 0; i < [pages count]; i++)
    {
        for (int j = 0; j < [(NSArray *)[pages objectAtIndex:i] count]; j++)
        {
            FormElementObject *feoij = [(NSArray *)[pages objectAtIndex:i] objectAtIndex:j];
            if ([[feoij.FieldTagValues objectAtIndex:[feoij.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"2"] ||
                [[feoij.FieldTagValues objectAtIndex:[feoij.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"21"] ||
                [[feoij.FieldTagValues objectAtIndex:[feoij.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"99"])
                continue;
            NSString *varname = [feoij.FieldTagValues objectAtIndex:[feoij.FieldTagElements indexOfObject:@"Name"]];
            [variablesThatCanBeInGroups addObject:varname];
            if (feoUnderEdit != nil)
            {
                if (feoUnderEdit.values != nil)
                {
                    if ([feoUnderEdit.values containsObject:varname])
                        [selectRowNumbers addObject:[NSNumber numberWithInt:(int)[variablesThatCanBeInGroups indexOfObject:varname]]];
                }
            }
        }
    }
    VariablesInGroupSelector *vigs = [[VariablesInGroupSelector alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width - 2, 0) AndListOfValues:variablesThatCanBeInGroups AndTextFieldToUpdate:[[UITextField alloc] init]];
    [vigs setTag:1001008];
    [vigs setFD:self];
    [controlViewGrayBackground addSubview:vigs];
    for (int selections = 0; selections < [selectRowNumbers count]; selections++)
    {
        [vigs.tv selectRowAtIndexPath:[NSIndexPath indexPathForRow:[(NSNumber *)[selectRowNumbers objectAtIndex:selections] intValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    UIButton *controlViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, controlViewGrayBackground.frame.size.width / 3 - 1, 0)];
    [controlViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewCancelButton addTarget:self action:@selector(variableGroupSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewGrayBackground addSubview:controlViewCancelButton];
    
    UIButton *controlViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 3, 0, controlViewGrayBackground.frame.size.width / 3, 0)];
    [controlViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [controlViewSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [controlViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [controlViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [controlViewSaveButton addTarget:self action:@selector(variableGroupSaveOrCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [controlViewSaveButton setEnabled:NO];
    [controlViewSaveButton setTag:1001003];
    [controlViewSaveButton.layer setValue:vigs.tv forKey:@"groupTV"];
    [controlViewGrayBackground addSubview:controlViewSaveButton];
    
    if (feoUnderEdit != nil)
    {
        [controlViewPromptText setText:[feoUnderEdit.FieldTagValues objectAtIndex:[feoUnderEdit.FieldTagElements indexOfObject:@"PromptText"]]];
        [controlViewFieldNameText setText:[feoUnderEdit.FieldTagValues objectAtIndex:[feoUnderEdit.FieldTagElements indexOfObject:@"Name"]]];
        [controlViewFieldNameText setEnabled:NO];
        [controlViewDeleteButton setEnabled:YES];
        [controlViewMoveUpButton setEnabled:YES];
        [controlViewMoveDnButton setEnabled:YES];
        [controlViewSaveButton setEnabled:YES];
    }
    
    NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
    if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
    {
        [controlViewViewLabel setText:@"\tGrupo"];
        [controlViewPromptText setPlaceholder:@"Group Label"];
        [controlViewFieldNameText setPlaceholder:@"Group Name"];
        [controlViewMoveUpButton setTitle:@"Move Up" forState:UIControlStateNormal];
        [controlViewMoveDnButton setTitle:@"Move Down" forState:UIControlStateNormal];
        [controlViewDeleteButton setTitle:@"Eliminar" forState:UIControlStateNormal];
        [controlViewCancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [controlViewSaveButton setTitle:@"Guardar" forState:UIControlStateNormal];
    }

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [controlViewGrayBackground setFrame:CGRectMake(controlViewGrayBackground.frame.origin.x, 0.08 * self.frame.size.height, 0.84 * self.frame.size.width, 282)];
        [controlViewViewLabel setFrame:CGRectMake(1, 1, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewPromptText setFrame:CGRectMake(1, 41, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewFieldNameText setFrame:CGRectMake(1, 81, controlViewGrayBackground.frame.size.width - 2, 40)];
        [controlViewMoveUpButton setFrame:CGRectMake(1, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewMoveDnButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 2, 201, controlViewGrayBackground.frame.size.width / 2 - 1, 40)];
        [controlViewDeleteButton setFrame:CGRectMake(2.0 * controlViewGrayBackground.frame.size.width / 3, 241, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [vigs setFrame:CGRectMake(1, 121, controlViewGrayBackground.frame.size.width - 2, 80)];
        [controlViewCancelButton setFrame:CGRectMake(1, 241, controlViewGrayBackground.frame.size.width / 3 - 1, 40)];
        [controlViewSaveButton setFrame:CGRectMake(controlViewGrayBackground.frame.size.width / 3, 241, controlViewGrayBackground.frame.size.width / 3, 40)];
    } completion:^(BOOL finished){
    }];
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
//            NSLog(@"Save button pressed. Form name = %@.", newFormName);
            if ([newFormName length] > 0)
            {
                [formDesignerLabel setTitle:[NSString stringWithFormat:@"Form Designer: %@", newFormName] forState:UIControlStateNormal];
                [formDesignerLabel setAccessibilityLabel:[NSString stringWithFormat:@"Form Designer. %@. Double tap for options.", newFormName]];
                formNamed = YES;
                formElements = [[NSMutableArray alloc] init];
                formElementObjects = [[NSMutableArray alloc] init];
                pages = [[NSMutableArray alloc] init];
                [pages addObject:[[NSMutableArray alloc] init]];
                lastPage = 1;
                pageNames = [[NSMutableArray alloc] init];
                pageNumbers = [[NSMutableArray alloc] init];
                actualPageNumbers = [[NSMutableArray alloc] init];
                [pageNames addObject:[NSString stringWithFormat:@"Page %d", lastPage]];
                [pageNumbers addObject:[NSString stringWithFormat:@"%d", lastPage]];
                [actualPageNumbers addObject:[NSString stringWithFormat:@"%d", lastPage]];
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
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
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
                    [titleLabel setAccessibilityLabel:[NSString stringWithFormat:@"%@. Double tap to edit label or title.", promptText]];
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
                                [(UILabel *)v setAccessibilityLabel:[NSString stringWithFormat:@"%@. Double tap to edit label or title.", promptText]];
                            }
                            break;
                        }
                    }
                }
                
                FormElementObject *feo = [[FormElementObject alloc] init];
                if (feoUnderEdit != nil)
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.24853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"2"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }

                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
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
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.4853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"1"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }

                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)uppercaseSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.4853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"3"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)multilineSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
        if (saveButtonPressed)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 80;
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.4853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"4"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)numberSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
        if (saveButtonPressed)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"5"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)phoneNumberSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
        if (saveButtonPressed)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [controlRendering.field setText:@"555-555-5555"];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"6"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)dateSaveOrCancelPressed:(UIButton *)sender
{
    UIView *vv = [controlViewGrayBackground viewWithTag:1001002];
    NSString *fieldName = @"";
    fieldName = [(UITextField *)vv text];
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
        }
    for (int i = 0; i < [checkCodeStrings count]; i++)
        NSLog(@"\n%@", [checkCodeStrings objectAtIndex:i]);
    
    NSString *promptText = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    
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
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [controlRendering displayDate];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"7"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)checkboxSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
        if (saveButtonPressed)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [controlRendering checkTheBox];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"10"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)commandButtonSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
        if (saveButtonPressed)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [controlRendering displayCommandButton];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"13"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)variableGroupSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    UITableView *uitv;
    NSArray *uitvselections;
    if (saveButtonPressed)
    {
        if ([sender.layer valueForKey:@"groupTV"])
        {
            uitv = [sender.layer valueForKey:@"groupTV"];
            uitvselections = [uitv indexPathsForSelectedRows];
            if ([uitvselections count] == 0)
            {
                saveButtonPressed = NO;
            }
        }
        else
        {
            saveButtonPressed = NO;
        }
    }
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
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
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width / 2.0, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [controlRendering displayGroup];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"21"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                if (!feo.values)
                    feo.values = [[NSMutableArray alloc] init];
                else
                    [feo.values removeAllObjects];
                for (int sels = 0; sels < [uitvselections count]; sels++)
                {
                    NSIndexPath *nsip = [uitvselections objectAtIndex:sels];
                    id uitvsource = [uitv dataSource];
                    NSArray *uitvdata = [(VariablesInGroupSelector *)uitvsource listOfValues];
                    NSString *nsst = [uitvdata objectAtIndex:nsip.row];
                    [feo.values addObject:nsst];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}
- (void)yesnoSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
        if (saveButtonPressed)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [controlRendering displayYesNo];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 80;
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"11"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)optionSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
        if (saveButtonPressed)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [controlRendering displayOption];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 80;
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"12"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (valuesFields != nil)
                {
                    NSMutableArray *values = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [valuesFields count]; i++)
                    {
                        NSString *valueString = [(UITextField *)[valuesFields objectAtIndex:i] text];
                        if ([valueString characterAtIndex:[valueString length] - 1] == ' ')
                            valueString = [valueString substringToIndex:[valueString length] - 1];
                        if ([valueString containsString:@","])
                            valueString = [valueString stringByReplacingOccurrencesOfString:@"," withString:@";"];
                        [values addObject:valueString];
                    }
                    [feo setValues:values];
                }
                else
                    [feo setValues:[[NSMutableArray alloc] init]];

                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        valuesFields = nil;
        feoUnderEdit = nil;
    }];
}

- (void)imageSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
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
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 80)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [controlRendering displayImage];
                    [canvas addSubview:controlRendering];
                    [canvas sendSubviewToBack:controlRendering];
                    nextY += 80;
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"14"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        feoUnderEdit = nil;
    }];
}

- (void)legalValuesSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
                    [controlRendering displayLegalValues];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"17"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (valuesFields != nil)
                {
                    NSMutableArray *values = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [valuesFields count]; i++)
                    {
                        NSString *valueString = [(UITextField *)[valuesFields objectAtIndex:i] text];
                        if ([valueString characterAtIndex:[valueString length] - 1] == ' ')
                            valueString = [valueString substringToIndex:[valueString length] - 1];
                        [values addObject:valueString];
                    }
                    [feo setValues:values];
                }
                else
                    [feo setValues:[[NSMutableArray alloc] init]];
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        valuesFields = nil;
        feoUnderEdit = nil;
    }];
}

- (void)commentLegalSaveOrCancelPressed:(UIButton *)sender
{
    NSString *promptText = @"";
    NSString *fieldName = @"";
    BOOL saveButtonPressed = ([[[sender titleLabel] text] isEqualToString:@"Save"]);
    
    UIView *vv = [controlViewGrayBackground viewWithTag:1001001];
    promptText = [(UITextField *)vv text];
    if ([promptText length] > 0 && [promptText characterAtIndex:[promptText length] - 1] == ' ')
        promptText = [promptText substringToIndex:[promptText length] - 1];
    vv = [controlViewGrayBackground viewWithTag:1001002];
    fieldName = [(UITextField *)vv text];
    
    if (!checkCodeStrings)
        checkCodeStrings = [[NSMutableArray alloc] init];
    if ([[[sender superview].layer valueForKey:@"CheckCode"] length] > 0)
        if (![checkCodeStrings containsObject:[NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]]])
        {
            NSString *csString = [NSString stringWithString:[[sender superview].layer valueForKey:@"CheckCode"]];
            if (deletedFieldIfBlocks)
            {
                for (NSString *ifb in deletedFieldIfBlocks)
                {
                    csString = [csString stringByReplacingOccurrencesOfString:ifb withString:@""];
                }
            }
            NSString *trimmedCSString = [[[[[[[csString stringByReplacingOccurrencesOfString:fieldName withString:@""] stringByReplacingOccurrencesOfString:@"End-Field" withString:@""] stringByReplacingOccurrencesOfString:@"End-After" withString:@""] stringByReplacingOccurrencesOfString:@"After" withString:@""] stringByReplacingOccurrencesOfString:@"Field " withString:@""] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""];
            if ([trimmedCSString length] > 0)
                [checkCodeStrings addObject:csString];
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
                    [controlRendering displayLegalValues];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
                    [feo.FieldTagValues addObject:@"0.019853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"19"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (valuesFields != nil)
                {
                    NSMutableArray *values = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [valuesFields count]; i++)
                    {
                        NSString *valueString = [(UITextField *)[valuesFields objectAtIndex:i] text];
                        if ([valueString characterAtIndex:[valueString length] - 1] == ' ')
                            valueString = [valueString substringToIndex:[valueString length] - 1];
                        [values addObject:valueString];
                    }
                    [feo setValues:values];
                }
                else
                    [feo setValues:[[NSMutableArray alloc] init]];
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        valuesFields = nil;
        feoUnderEdit = nil;
    }];
}

- (void)insertPageBreakPressed:(UIButton *)sender
{
    NSString *promptText = @"Page Break";
    NSString *fieldName = @"_pageBreak";
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
    } completion:^(BOOL finished){
        [controlViewGrayBackground removeFromSuperview];
        [canvasTapGesture setEnabled:YES];
        if (YES)
        {
            if ([promptText length] > 0)
            {
                [formElements addObject:[[NSString stringWithString:fieldName] lowercaseString]];
                
                if (feoUnderEdit == nil)
                {
                    TextFieldDisplay *controlRendering = [[TextFieldDisplay alloc] initWithFrame:CGRectMake(8, nextY, canvasSV.frame.size.width - 16, 40)];
                    [controlRendering setBackgroundColor:[UIColor clearColor]];
                    [controlRendering.prompt setText:promptText];
                    [controlRendering displayPageBreak];
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
                {
                    feo = feoUnderEdit;
                    [feo.FieldTagValues setObject:promptText atIndexedSubscript:[feo.FieldTagElements indexOfObject:@"PromptText"]];
                }
                else
                {
                    lastPage++;
                    feo.FieldTagElements = [[NSMutableArray alloc] init];
                    feo.FieldTagValues = [[NSMutableArray alloc] init];
                    [feo.FieldTagElements addObject:@"Name"];
                    [feo.FieldTagValues addObject:fieldName];
                    [feo.FieldTagElements addObject:@"PageId"];
                    [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                    [feo.FieldTagElements addObject:@"IsReadOnly"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"IsRequired"];
                    [feo.FieldTagValues addObject:@"False"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                    [feo.FieldTagValues addObject:@"0.19853"];
                    [feo.FieldTagElements addObject:@"PromptText"];
                    [feo.FieldTagValues addObject:promptText];
                    [feo.FieldTagElements addObject:@"FieldTypeId"];
                    [feo.FieldTagValues addObject:@"99"];
                    [feo.FieldTagElements addObject:@"UniqueId"];
                    [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                }
                
                if (feoUnderEdit == nil)
                {
                    [feo setNextY:nextY];
                    [formElementObjects addObject:feo];
                    while ([pages count] < [(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue])
                    {
                        [pages addObject:[[NSMutableArray alloc] init]];
                        [pageNumbers addObject:[NSString stringWithFormat:@"%d", lastPage]];
                        [actualPageNumbers addObject:[NSString stringWithFormat:@"%d", lastPage]];
                        [pageNames addObject:[NSString stringWithFormat:@"Page %d", lastPage]];
                    }
                    [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
                }
                
                [self buildTheXMLFile];
                yTouched = -99.9;
                [canvasSV setContentSize:CGSizeMake(canvasSV.contentSize.width, nextY + self.frame.size.height)];
                [canvas setFrame:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvasSV.contentSize.height)];
                [canvasCover setFrame:CGRectMake(canvasCover.frame.origin.x, canvasCover.frame.origin.y, canvasCover.frame.size.width, canvas.frame.size.height)];
            }
        }
        valuesFields = nil;
        feoUnderEdit = nil;
    }];
}

- (void)distributeFormPressed:(UIButton *)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        return;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        NSString *filePathAndName = [[[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePathAndName])
        {
            MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
            [composer setMailComposeDelegate:self];
            [composer addAttachmentData:[[self removeActualPageNumbers] dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:[formName stringByAppendingString:@".xml"]];
            [composer setSubject:@"Epi Info Form"];
            [composer setMessageBody:@"Here is an Epi Info form template." isHTML:NO];
            [self.rootViewController presentViewController:composer animated:YES completion:^(void){
            }];
        }
    }
}

- (NSString *)removeActualPageNumbers
{
    NSString *xmlString = [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:[@"file://" stringByAppendingString:[[[epiInfoForms stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"]]] encoding:NSUTF8StringEncoding error:nil];
    while ([xmlString containsString:@" ActualPageNumber=\""])
    {
        NSRange apnrange = [xmlString rangeOfString:@" ActualPageNumber=\""];
        int indexofsecondquote = (int)[[xmlString substringFromIndex:apnrange.location + apnrange.length] rangeOfString:@"\""].location;
        NSRange rangetoremove = NSMakeRange(apnrange.location, apnrange.length + indexofsecondquote + 1);
        xmlString = [xmlString stringByReplacingCharactersInRange:rangetoremove withString:@""];
    }
    return xmlString;
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
    
    for (id f in pages)
    {
        formElementObjects = [NSMutableArray arrayWithArray:(NSMutableArray *)f];
        if ([formElementObjects containsObject:feoUnderEdit])
            break;
    }
    
    if (delete)
    {
        for (NSMutableArray *nsma in pages)
        {
            if ([nsma containsObject:feoUnderEdit])
            {
                [nsma removeObject:feoUnderEdit];
                formElementObjects = [NSMutableArray arrayWithArray:nsma];
                if ([nsma count] == 0)
                {
                    if ([[feoUnderEdit.FieldTagValues objectAtIndex:[feoUnderEdit.FieldTagElements indexOfObject:@"Name"]] isEqualToString:@"_pageBreak"])
                    {
                        [pages removeObject:nsma];
                    }
                }
                break;
            }
        }
        [formElements removeObject:[[(UITextField *)[[sender superview] viewWithTag:1001002] text] lowercaseString]];
        [self buildTheXMLFile];
        for (UIView *v in [canvas subviews])
            if ([v tag] != 19572010)
                [v removeFromSuperview];
    }
    else if (moveUp)
    {
        if ([(NSMutableArray *)[pages firstObject] firstObject] == feoUnderEdit)
            return;
        int pagesIndex = 0;
        for (pagesIndex = 0; pagesIndex < [pages count]; pagesIndex++)
        {
            NSMutableArray *nsma = [pages objectAtIndex:pagesIndex];
            if ([nsma containsObject:feoUnderEdit])
            {
                formElementObjects = nsma;
                break;
            }
        }
        if (pagesIndex == 0 || [formElementObjects indexOfObject:feoUnderEdit] > 1)
        {
            int idx = (int)[formElementObjects indexOfObject:feoUnderEdit];
            [formElementObjects removeObjectAtIndex:idx];
            [formElementObjects insertObject:feoUnderEdit atIndex:idx - 1];
        }
        else
        {
            int idx = (int)[formElementObjects indexOfObject:feoUnderEdit];
            [formElementObjects removeObjectAtIndex:idx];
            formElementObjects = [pages objectAtIndex:pagesIndex - 1];
            [feoUnderEdit.FieldTagValues setObject:[NSString stringWithFormat:@"%d", pagesIndex] atIndexedSubscript:[feoUnderEdit.FieldTagElements indexOfObject:@"PageId"]];
            [formElementObjects addObject:feoUnderEdit];
        }
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:formElementObjects];
        formElementObjects = tempArray;
        [self buildTheXMLFile];
        for (UIView *v in [canvas subviews])
            if ([v tag] != 19572010)
                [v removeFromSuperview];
        if ([sender tag] == 1001005 || [sender tag] == 1001006)
        {
            [self variableGroupSaveOrCancelPressed:[[sender superview] viewWithTag:1001003]];
        }
    }
    else
    {
        if ([(NSMutableArray *)[pages lastObject] lastObject] == feoUnderEdit)
            return;
        int pagesIndex = 0;
        for (pagesIndex = 0; pagesIndex < [pages count]; pagesIndex++)
        {
            NSMutableArray *nsma = [pages objectAtIndex:pagesIndex];
            if ([nsma containsObject:feoUnderEdit])
            {
                formElementObjects = nsma;
                break;
            }
        }
        if ([formElementObjects lastObject] == feoUnderEdit)
        {
            int idx = (int)[formElementObjects indexOfObject:feoUnderEdit];
            [formElementObjects removeObjectAtIndex:idx];
            formElementObjects = [pages objectAtIndex:pagesIndex + 1];
            [feoUnderEdit.FieldTagValues setObject:[NSString stringWithFormat:@"%d", pagesIndex + 2] atIndexedSubscript:[feoUnderEdit.FieldTagElements indexOfObject:@"PageId"]];
            [formElementObjects insertObject:feoUnderEdit atIndex:1];
        }
        else
        {
            int idx = (int)[formElementObjects indexOfObject:feoUnderEdit];
            [formElementObjects removeObjectAtIndex:idx];
            [formElementObjects insertObject:feoUnderEdit atIndex:idx + 1];
        }
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:formElementObjects];
        formElementObjects = tempArray;
        [self buildTheXMLFile];
        for (UIView *v in [canvas subviews])
            if ([v tag] != 19572010)
                [v removeFromSuperview];
        if ([sender tag] == 1001005 || [sender tag] == 1001006)
        {
            [self variableGroupSaveOrCancelPressed:[[sender superview] viewWithTag:1001003]];
        }
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
        if (!([sender tag] == 1001005 || [sender tag] == 1001006))
            feoUnderEdit = nil;
    }];
}

- (void)checkCodePressed:(UIButton *)sender
{
    [self processCheckCodeString];
    CheckCodeWriter *ccWriter = [[CheckCodeWriter alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width - 0.0, self.frame.size.height - 1.0) AndFieldName:[(UITextField *)[[sender superview] viewWithTag:1001002] text] AndFieldType:[sender.layer valueForKey:@"FieldType"] AndSenderSuperview:[sender superview]];
    [ccWriter setFormDesignerCheckCodeStrings:checkCodeStrings];
    if (!deletedFieldIfBlocks)
        deletedFieldIfBlocks = [[NSMutableArray alloc] init];
    [ccWriter setDeletedIfBlocks:deletedFieldIfBlocks];
    [self addSubview:ccWriter];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [ccWriter setFrame:CGRectMake(0, 1, self.frame.size.width - 0.0, self.frame.size.height - 1.0)];
    } completion:^(BOOL finished){
    }];
}

- (void)pageCheckCodePressed:(UIButton *)sender
{
    [self processCheckCodeString];
    PageCheckCodeWriter *ccWriter = [[PageCheckCodeWriter alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width - 0.0, self.frame.size.height - 1.0) AndFieldName:@"Page" AndFieldType:@"Page" AndSenderSuperview:self];
    [self addSubview:ccWriter];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [ccWriter setFrame:CGRectMake(0, 1, self.frame.size.width - 0.0, self.frame.size.height - 1.0)];
    } completion:^(BOOL finished){
        [canvasTapGesture setEnabled:YES];
    }];
}

- (void)showHideFormTemplate:(UIButton *)sender
{
    int buttonTag = ((int)(((float)((int)[sender tag])) / 1000000));
    if (buttonTag == 21)
    {
        UIView *templateBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width - 0.0, self.frame.size.height - 1.0)];
        [templateBottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:templateBottomView];
        
        UIButton *showCheckCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(00, templateBottomView.frame.size.height - 48.0, templateBottomView.frame.size.width / 2.0, 32)];
        [showCheckCodeButton setBackgroundColor:[UIColor whiteColor]];
        [showCheckCodeButton setTitle:@"Check Code View" forState:UIControlStateNormal];
        [showCheckCodeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [showCheckCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [showCheckCodeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [showCheckCodeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [showCheckCodeButton addTarget:self action:@selector(showHideFormTemplate:) forControlEvents:UIControlEventTouchUpInside];
        [showCheckCodeButton setTag:243252633];
        [templateBottomView addSubview:showCheckCodeButton];
        
        UIButton *templateViewCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(templateBottomView.frame.size.width / 2.0, templateBottomView.frame.size.height - 48.0, templateBottomView.frame.size.width / 2.0, 32)];
        [templateViewCloseButton setBackgroundColor:[UIColor whiteColor]];
        [templateViewCloseButton setTitle:@"Close" forState:UIControlStateNormal];
        [templateViewCloseButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [templateViewCloseButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [templateViewCloseButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [templateViewCloseButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [templateViewCloseButton addTarget:self action:@selector(showHideFormTemplate:) forControlEvents:UIControlEventTouchUpInside];
        [templateViewCloseButton setTag:-1];
        [templateBottomView addSubview:templateViewCloseButton];

        UIScrollView *templateSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, templateBottomView.frame.size.width, templateViewCloseButton.frame.origin.y)];
        [templateSV setContentSize:CGSizeMake(templateSV.frame.size.width, templateSV.frame.size.height)];
        [templateBottomView addSubview:templateSV];
        [templateSV setTag:2360852];
        [templateSV setMaximumZoomScale:2.0];
        [templateSV setDelegate:self];
        
        templateViewLabel = [[UILabel alloc] initWithFrame:templateSV.frame];
        [templateSV addSubview:templateViewLabel];
        [templateViewLabel setNumberOfLines:0];
        [templateViewLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [templateViewLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [templateViewLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        }
        [templateViewLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:[paths objectAtIndex:0] withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            NSString *filePathAndName = [[[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"];
            [templateViewLabel setText:[NSString stringWithContentsOfFile:filePathAndName encoding:NSUTF8StringEncoding error:nil]];
        }
        
        [templateViewLabel sizeToFit];
        if (templateViewLabel.frame.size.height > templateSV.contentSize.height)
            [templateSV setContentSize:CGSizeMake(templateViewLabel.frame.size.width, templateViewLabel.frame.size.height)];

        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [templateBottomView setFrame:CGRectMake(0, 1, self.frame.size.width - 0.0, self.frame.size.height - 1.0)];
        } completion:^(BOOL finished){
            [canvasTapGesture setEnabled:YES];
        }];
    }
    else if ([sender tag] == 243252633)
    {
        UIView *checkCodeBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width - 0.0, self.frame.size.height - 1.0)];
        [checkCodeBottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:checkCodeBottomView];
        
        UIButton *checkCodeViewCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(checkCodeBottomView.frame.size.width / 2.0, checkCodeBottomView.frame.size.height - 48.0, checkCodeBottomView.frame.size.width / 2.0, 32)];
        [checkCodeViewCloseButton setBackgroundColor:[UIColor whiteColor]];
        [checkCodeViewCloseButton setTitle:@"Close" forState:UIControlStateNormal];
        [checkCodeViewCloseButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [checkCodeViewCloseButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [checkCodeViewCloseButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [checkCodeViewCloseButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [checkCodeViewCloseButton addTarget:self action:@selector(showHideFormTemplate:) forControlEvents:UIControlEventTouchUpInside];
        [checkCodeViewCloseButton setTag:-1];
        [checkCodeBottomView addSubview:checkCodeViewCloseButton];
        
        UIScrollView *checkCodeSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, checkCodeBottomView.frame.size.width, checkCodeViewCloseButton.frame.origin.y)];
        [checkCodeSV setContentSize:CGSizeMake(checkCodeSV.frame.size.width, checkCodeSV.frame.size.height)];
        [checkCodeBottomView addSubview:checkCodeSV];
        [checkCodeSV setTag:2729988];
        [checkCodeSV setMaximumZoomScale:2.0];
        [checkCodeSV setDelegate:self];
        
        checkCodeViewLabel = [[UILabel alloc] initWithFrame:checkCodeSV.frame];
        [checkCodeSV addSubview:checkCodeViewLabel];
        [checkCodeViewLabel setNumberOfLines:0];
        [checkCodeViewLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [checkCodeViewLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        justParsingForCheckCode = YES;
        NSURL *templateFile = [[NSURL alloc] initWithString:[@"file://" stringByAppendingString:[[[epiInfoForms stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"]]];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:templateFile];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:YES];
        //            NSLog(@"CONSUMING XML: %@", [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:[@"file://" stringByAppendingString:[[[epiInfoForms stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"]]] encoding:NSUTF8StringEncoding error:nil]);
        BOOL success = [parser parse];
        justParsingForCheckCode = NO;
        if (success)
            [checkCodeViewLabel setText:[[checkCodeStringForDisplay stringByReplacingOccurrencesOfString:@"&#xA;" withString:@"\n"] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@"\t"]];
        [checkCodeViewLabel sizeToFit];
        if (checkCodeViewLabel.frame.size.height > checkCodeSV.contentSize.height)
            [checkCodeSV setContentSize:CGSizeMake(checkCodeViewLabel.frame.size.width, checkCodeViewLabel.frame.size.height)];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [checkCodeBottomView setFrame:CGRectMake(0, 1, self.frame.size.width - 0.0, self.frame.size.height - 1.0)];
        } completion:^(BOOL finished){
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[sender superview] setFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width - 0.0, self.frame.size.height - 1.0)];
        } completion:^(BOOL finished){
            [[sender superview] removeFromSuperview];
        }];
    }
}

- (void)valuesPressed:(UIButton *)sender
{
    if (valuesFields == nil)
        valuesFields = [[NSMutableArray alloc] init];
    
    valuesGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, controlViewGrayBackground.frame.size.width, 0)];
    [valuesGrayBackground setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [controlViewGrayBackground addSubview:valuesGrayBackground];
    
    UIScrollView *valuesSV = [[UIScrollView alloc] initWithFrame:CGRectMake(1, 1, valuesGrayBackground.frame.size.width - 2, 0)];
    [valuesSV setBackgroundColor:[UIColor clearColor]];
    [valuesSV setBounces:NO];
    [valuesGrayBackground addSubview:valuesSV];
    
    if ([valuesFields count] == 0)
    {
        UITextField *valueText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, valuesSV.frame.size.width, 0)];
        [valueText setBackgroundColor:[UIColor whiteColor]];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [valueText setLeftViewMode:UITextFieldViewModeAlways];
        [valueText setLeftView:spacerView];
        [valueText setPlaceholder:@"Value"];
        [valueText setDelegate:self];
        [valueText addTarget:self action:@selector(valueFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [valueText setReturnKeyType:UIReturnKeyDone];
        [valuesSV addSubview:valueText];
        [valuesFields addObject:valueText];
    }
    else
    {
        for (int i = 0; i < [valuesFields count]; i++)
        {
            UITextField *valueText = (UITextField *)[valuesFields objectAtIndex:i];
            [valueText setFrame:CGRectMake(0, 0, valueText.frame.size.width, 0)];
            [valuesSV addSubview:valueText];
        }
    }

    UIButton *valuesViewCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, valuesGrayBackground.frame.size.width / 2 - 1, 0)];
    [valuesViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [valuesViewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [valuesViewCancelButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [valuesViewCancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [valuesViewCancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [valuesViewCancelButton addTarget:self action:@selector(valuesDismissed:) forControlEvents:UIControlEventTouchUpInside];
//    [valuesGrayBackground addSubview:valuesViewCancelButton];
    
    UIButton *valuesViewSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, valuesGrayBackground.frame.size.width - 2, 0)];
    [valuesViewSaveButton setBackgroundColor:[UIColor whiteColor]];
    [valuesViewSaveButton setTitle:@"Done" forState:UIControlStateNormal];
    [valuesViewSaveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [valuesViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [valuesViewSaveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [valuesViewSaveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [valuesViewSaveButton addTarget:self action:@selector(valuesDismissed:) forControlEvents:UIControlEventTouchUpInside];
//    [valuesViewSaveButton setEnabled:NO];
    [valuesGrayBackground addSubview:valuesViewSaveButton];

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [valuesGrayBackground setFrame:CGRectMake(0, 0, controlViewGrayBackground.frame.size.width, controlViewGrayBackground.frame.size.height)];
        [valuesSV setFrame:CGRectMake(1, 1, valuesGrayBackground.frame.size.width - 2, 200)];
        [valuesSV setContentSize:CGSizeMake(valuesSV.frame.size.width, valuesSV.frame.size.height)];
        for (int i = 0; i < [valuesFields count]; i++)
        {
            UITextField *valueText = (UITextField *)[valuesFields objectAtIndex:i];
            [valueText setFrame:CGRectMake(0, 40.0 * i, valuesSV.frame.size.width, 40)];
        }
        if (40.0 * [valuesFields count] > valuesSV.contentSize.height)
            [valuesSV setContentSize:CGSizeMake(valuesSV.contentSize.width, 40.0 * [valuesFields count])];
//        [valuesViewCancelButton setFrame:CGRectMake(1, 201, valuesGrayBackground.frame.size.width / 2 - 1, 40)];
        [valuesViewSaveButton setFrame:CGRectMake(1, 201, valuesGrayBackground.frame.size.width - 2, 40)];
    } completion:^(BOOL finished){
    }];
}
- (void)valuesDismissed:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [valuesGrayBackground setFrame:CGRectMake(valuesGrayBackground.frame.origin.x, valuesGrayBackground.frame.origin.y, valuesGrayBackground.frame.size.width, 0)];
        for (UIView *vv in [valuesGrayBackground subviews])
        {
            if ([vv isKindOfClass:[UIScrollView class]])
            {
                for (UIView *vvv in [vv subviews])
                {
                    [vvv setFrame:CGRectMake(vvv.frame.origin.x, 0, vvv.frame.size.width, 0)];
                }
            }
            [vv setFrame:CGRectMake(vv.frame.origin.x, 0, vv.frame.size.width, 0)];
        }
    } completion:^(BOOL finished){
        [valuesGrayBackground removeFromSuperview];
    }];
}

- (void)buildTheXMLFile
{
    if ([pageNumbers count] == 0)
        [pageNumbers addObject:[NSString stringWithFormat:@"%d", 1]];
    if ([actualPageNumbers count] == 0)
        [actualPageNumbers addObject:[NSString stringWithFormat:@"%d", 1]];
    if ([pageNames count] == 0)
        [pageNames addObject:[NSString stringWithFormat:@"Page %d", 1]];
    
    if ([checkCodeStrings count] > 0)
    {
        NSMutableString *checkCodeStringBuilder = [[NSMutableString alloc] init];
        [checkCodeStringBuilder appendString:[checkCodeStrings objectAtIndex:0]];
        for (int i = 1; i < [checkCodeStrings count]; i++)
        {
            [checkCodeStringBuilder appendFormat:@"&#xA;&#xA;%@", [checkCodeStrings objectAtIndex:i]];
        }
        if ([checkCodeString rangeOfString:checkCodeStringBuilder options:NSCaseInsensitiveSearch].location == NSNotFound)
            checkCodeString = [checkCodeString stringByAppendingString:checkCodeStringBuilder];
    }

    NSMutableString *xmlMS = [[NSMutableString alloc] init];
    NSMutableString *sourceTables = [[NSMutableString alloc] init];
    [xmlMS appendString:@"<?xml version=\"1.0\"?>\n"];
    [xmlMS appendString:[NSString stringWithFormat:@"<Template Level=\"View\" Name=\"%@\">\n", formName]];
    [xmlMS appendString:@"<Project>\n"];
    [xmlMS appendString:[NSString stringWithFormat:@"<View Name=\"%@\" ", formName]];
    [xmlMS appendString:[NSString stringWithFormat:@"LabelAlign=\"Vertical\" Orientation=\"Portrait\" Height=\"1016\" Width=\"780\" CheckCode=\"%@", checkCodeString]];
    [xmlMS appendString:@"\" IsRelatedView=\"False\" ViewId=\"1\">\n"];
    for (int h = 0; h < [pages count]; h++)
    {
        NSMutableArray *arrayH = (NSMutableArray *)[pages objectAtIndex:h];
        if ([arrayH count] == 0)
        {
            if ([pages count] == 1)
                [xmlMS appendString:[NSString stringWithFormat:@"<Page PageId=\"1\" ActualPageNumber=\"1\" Name=\"Page 1\" ViewId=\"1\" BackgroundId=\"0\" Position=\"0\">\n</Page>\n"]];
            continue;
        }
        if ([actualPageNumbers containsObject:[NSString stringWithFormat:@"%d", h + 1]])
        {
            unsigned long indexOfPageId = [actualPageNumbers indexOfObject:[NSString stringWithFormat:@"%d", h + 1]];
            [xmlMS appendString:[NSString stringWithFormat:@"<Page PageId=\"%@\" ActualPageNumber=\"%d\" Name=\"%@\" ViewId=\"1\" BackgroundId=\"0\" Position=\"0\">\n", [pageNumbers objectAtIndex:indexOfPageId], h + 1, [pageNames objectAtIndex:indexOfPageId]]];
        }
        else if ([pageNumbers containsObject:[NSString stringWithFormat:@"%d", h + 1]])
        {
            unsigned long indexOfPageId = [pageNumbers indexOfObject:[NSString stringWithFormat:@"%d", h + 1]];
            [xmlMS appendString:[NSString stringWithFormat:@"<Page PageId=\"%d\" ActualPageNumber=\"%@\" Name=\"%@\" ViewId=\"1\" BackgroundId=\"0\" Position=\"0\">\n", h + 1, [actualPageNumbers objectAtIndex:indexOfPageId], [pageNames objectAtIndex:indexOfPageId]]];
        }
        else
        {
            continue;
        }
        // Replaced formElemtntObjects with arrahY in this loop when implemented multiple pages
        for (int i = 0; i < [arrayH count]; i++)
        {
            FormElementObject *feo = (FormElementObject *)[arrayH objectAtIndex:i];
            if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"99"])
                continue;
            [xmlMS appendString:@"<Field"];
            if ([feo.FieldTagElements containsObject:@"List"])
            {
                unsigned long indexOfList = [feo.FieldTagElements indexOfObject:@"List"];
                [feo.FieldTagElements removeObjectAtIndex:indexOfList];
                [feo.FieldTagValues removeObjectAtIndex:indexOfList];
            }
            for (int j = 0; j < [feo.FieldTagElements count]; j++)
            {
                [xmlMS appendString:[NSString stringWithFormat:@" %@=\"%@\"", (NSString *)[feo.FieldTagElements objectAtIndex:j], (NSString *)[feo.FieldTagValues objectAtIndex:j]]];
            }
            [xmlMS appendString:[NSString stringWithFormat:@" TabIndex=\"%d\"", i]];
            [xmlMS appendString:[NSString stringWithFormat:@" FieldId=\"%d\"", i]];
            if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"12"] && feo.values != nil)
            {
                if ([feo.values count] > 0)
                {
                    [xmlMS appendString:@" List=\""];
                    NSMutableString *coordinates = [[NSMutableString alloc] init];
                    for (int j = 0; j < [feo.values count] - 1; j++)
                    {
                        if (j > 0)
                        {
                            [xmlMS appendString:@","];
                            [coordinates appendString:@":"];
                        }
                        [xmlMS appendString:[feo.values objectAtIndex:j]];
                        [coordinates appendString:[NSString stringWithFormat:@"%f:.01538", 0.02854 * (1.0 + j)]];
                    }
                    [xmlMS appendString:@"||"];
                    [xmlMS appendString:coordinates];
                    [xmlMS appendString:@"\""];
                }
            }
            if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"17"] && feo.values != nil)
            {
                if ([feo.values count] > 0)
                {
                    NSString *itemString = [[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"Name"]] lowercaseString];
                    if (![feo.FieldTagElements containsObject:@"SourceTableName"])
                    {
                        [xmlMS appendString:@" SourceTableName=\""];
                        [xmlMS appendString:[NSString stringWithFormat:@"code%@1", itemString]];
                        [xmlMS appendString:@"\""];
                    }
                    if (![feo.FieldTagElements containsObject:@"TextColumnName"])
                    {
                        [xmlMS appendString:@" TextColumnName=\""];
                        [xmlMS appendString:[NSString stringWithFormat:@"%@", itemString]];
                        [xmlMS appendString:@"\""];
                    }
                    NSMutableString *sourceTable = [[NSMutableString alloc] init];
                    NSString *codeString = [NSString stringWithFormat:@"code%@1", itemString];
                    if ([feo.FieldTagElements containsObject:@"SourceTableName"])
                    {
                        codeString = [feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"SourceTableName"]];
                    }
                    if ([feo.FieldTagElements containsObject:@"TextColumnName"])
                    {
                        itemString = [feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"TextColumnName"]];
                    }
                    [sourceTable appendString:[NSString stringWithFormat:@"<SourceTable TableName=\"%@\">\n", codeString]];
                    for (int j = 0; j < [feo.values count]; j++)
                    {
                        if (j == [feo.values count] - 1)
                            if ([(NSString *)[feo.values objectAtIndex:j] length] == 0)
                                continue;
                        [sourceTable appendString:[NSString stringWithFormat:@"<Item %@=\"%@\"/>\n", itemString, [feo.values objectAtIndex:j]]];
                    }
                    [sourceTable appendString:@"</SourceTable>\n"];
                    if (![[sourceTables lowercaseString] containsString:[sourceTable lowercaseString]])
                        [sourceTables appendString:sourceTable];
                }
            }
            if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"19"] && feo.values != nil)
            {
                if ([feo.values count] > 0)
                {
                    NSString *itemString = [[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"Name"]] lowercaseString];
                    if (![feo.FieldTagElements containsObject:@"SourceTableName"])
                    {
                        [xmlMS appendString:@" SourceTableName=\""];
                        [xmlMS appendString:[NSString stringWithFormat:@"code%@1", itemString]];
                        [xmlMS appendString:@"\""];
                    }
                    if (![feo.FieldTagElements containsObject:@"TextColumnName"])
                    {
                        [xmlMS appendString:@" TextColumnName=\""];
                        [xmlMS appendString:[NSString stringWithFormat:@"%@", itemString]];
                        [xmlMS appendString:@"\""];
                    }
                    NSMutableString *sourceTable = [[NSMutableString alloc] init];
                    NSString *codeString = [NSString stringWithFormat:@"code%@1", itemString];
                    if ([feo.FieldTagElements containsObject:@"SourceTableName"])
                    {
                        codeString = [feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"SourceTableName"]];
                    }
                    if ([feo.FieldTagElements containsObject:@"TextColumnName"])
                    {
                        itemString = [feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"TextColumnName"]];
                    }
                    [sourceTable appendString:[NSString stringWithFormat:@"<SourceTable TableName=\"%@\">\n", codeString]];
                    for (int j = 0; j < [feo.values count]; j++)
                    {
                        if (j == [feo.values count] - 1)
                            if ([(NSString *)[feo.values objectAtIndex:j] length] == 0)
                                continue;
                        [sourceTable appendString:[NSString stringWithFormat:@"<Item %@=\"%@\"/>\n", itemString, [feo.values objectAtIndex:j]]];
                    }
                    [sourceTable appendString:@"</SourceTable>\n"];
                    if (![[sourceTables lowercaseString] containsString:[sourceTable lowercaseString]])
                        [sourceTables appendString:sourceTable];
                }
            }
            if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"21"] && feo.values != nil)
            {
                if ([feo.values count] > 0)
                {
                    if (![feo.FieldTagElements containsObject:@"List"])
                    {
                        [xmlMS appendString:@" List=\""];
                        [xmlMS appendString:[NSString stringWithFormat:@"%@", [feo.values objectAtIndex:0]]];
                        for (int j = 1; j < [feo.values count]; j++)
                        {
                            [xmlMS appendString:[NSString stringWithFormat:@",%@", [feo.values objectAtIndex:j]]];
                        }
                        [xmlMS appendString:@"\""];
                    }
                }
            }
            [xmlMS appendString:[NSString stringWithFormat:@" ControlLeftPositionPercentage=\"0.1953846\" ControlTopPositionPercentage=\"%f\"", 0.0531496 + (0.9 / [arrayH count]) * i]];
            [xmlMS appendString:@" Position=\"0\" SourceFieldId=\"\" HasTabStop=\"False\" IsExclusiveTable=\"False\" Sort=\"False\" CodeColumnName=\"\""];
            if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"FieldTypeId"]] isEqualToString:@"20"])
            {
                [xmlMS appendString:@" ShouldReturnToParent=\"False\" RelateCondition=\"\" Upper=\"\" Lower=\"\" ShowTextOnRight=\"False\" MaxLength=\"\""];
            }
            else
            {
                [xmlMS appendString:@" RelatedViewId=\"\" ShouldReturnToParent=\"False\" RelateCondition=\"\" Upper=\"\" Lower=\"\" ShowTextOnRight=\"False\" MaxLength=\"\""];
            }
            [xmlMS appendString:@" Pattern=\"\" ShouldRetainImageSize=\"False\" IsEncrypted=\"False\" ShouldRepeatLast=\"False\""];
            [xmlMS appendString:@" PromptScriptName=\"\" ControlFontStyle=\"Regular\" ControlFontSize=\"14.0\" ControlFontFamily=\"Arial\" PromptFontStyle=\"Regular\""];
            [xmlMS appendString:[NSString stringWithFormat:@" PromptFontSize=\"14.25\" PromptFontFamily=\"Arial\" PromptLeftPositionPercentage=\"0.118\" PromptTopPositionPercentage=\"%f\"", 0.0531496 + (0.9 / [arrayH count]) * i]];
            [xmlMS appendString:@" ControlScriptName=\"\" Expr1017=\"Regular\" Expr1016=\"14.0\" Expr1015=\"Arial\""];
//            [xmlMS appendString:[NSString stringWithFormat:@" UniqueId=\"%@\"", [CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]]];
            [xmlMS appendString:@"/>\n"];
        }
        [xmlMS appendString:@"</Page>\n"];
    }
    [xmlMS appendString:@"</View>\n"];
    [xmlMS appendString:@"</Project>\n"];
    [xmlMS appendString:sourceTables];
    [xmlMS appendString:@"</Template>"];
    NSString *xmlS = [NSString stringWithString:xmlMS];
//    NSLog(@"%@", xmlS);
    
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
//        NSLog(@"%@", filePathAndName);
        [xmlS writeToFile:filePathAndName atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"WROTE XML: %@", [NSString stringWithContentsOfFile:filePathAndName encoding:NSUTF8StringEncoding error:nil]);
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

- (void)fieldResignedFirstResponder:(UIView *)vigs
{
    [self textFieldChangedInGroupView:[[vigs superview] viewWithTag:1001001]];
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
        NSCharacterSet *validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789_qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
        if ([[compressedText stringByTrimmingCharactersInSet:validSet] length] > 0)
        {
            NSCharacterSet *invalidSet = [NSCharacterSet characterSetWithCharactersInString:[compressedText stringByTrimmingCharactersInSet:validSet]];
            compressedText = [compressedText stringByTrimmingCharactersInSet:invalidSet];
        }
        NSString *incrementedText = [NSString stringWithString:compressedText];
        int increment = 0;
        while ([formElements containsObject:[incrementedText lowercaseString]])
            incrementedText = [compressedText stringByAppendingString:[NSString stringWithFormat:@"%d", increment++]];
        UITextField *variableNameField = [[textField superview] viewWithTag:1001002];
        [variableNameField setText:incrementedText];
        [self textFieldChanged:textField];
        if ([[textField superview] viewWithTag:1001008])
            [self textFieldChangedInGroupView:textField];
    }
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField
{
    if ([textField tag] == 1001002)
    {
        NSCharacterSet *validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789_qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
        if ([[[textField text] stringByTrimmingCharactersInSet:validSet] length] > 0)
        {
            NSCharacterSet *invalidSet = [NSCharacterSet characterSetWithCharactersInString:[[textField text] stringByTrimmingCharactersInSet:validSet]];
            NSString *compressedText = [[textField text] stringByTrimmingCharactersInSet:invalidSet];
            [textField setText:compressedText];
        }
    }
    if (![(UITextField *)[[textField superview] viewWithTag:1001002] isEnabled])
        return;
    if ([[(UITextField *)[[textField superview] viewWithTag:1001001] text] length] > 0 && [[(UITextField *)[[textField superview] viewWithTag:1001002] text] length] > 0)
    {
        [(UIButton *)[[textField superview] viewWithTag:1001003] setEnabled:YES];
        [(UIButton *)[[textField superview] viewWithTag:1001004] setEnabled:YES];
    }
    else
    {
        [(UIButton *)[[textField superview] viewWithTag:1001003] setEnabled:NO];
        [(UIButton *)[[textField superview] viewWithTag:1001004] setEnabled:NO];
        if ([textField tag] == 1001001)
            return;
    }
    if ([formElements containsObject:[[(UITextField *)[[textField superview] viewWithTag:1001002] text] lowercaseString]] ||
        [reservedWords containsObject:[[(UITextField *)[[textField superview] viewWithTag:1001002] text] lowercaseString]] ||
        ([[(UITextField *)[[textField superview] viewWithTag:1001002] text] length] > 0 &&
         ([[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '_' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '0' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '1' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '2' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '3' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '4' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '5' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '6' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '7' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '8' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '9')))
    {
        [(UIButton *)[[textField superview] viewWithTag:1001003] setEnabled:NO];
        [(UIButton *)[[textField superview] viewWithTag:1001004] setEnabled:NO];
        [(UITextField *)[[textField superview] viewWithTag:1001002] setTextColor:[UIColor redColor]];
    }
    else
        [(UITextField *)[[textField superview] viewWithTag:1001002] setTextColor:[UIColor blackColor]];
}

- (void)textFieldChangedInGroupView:(UITextField *)textField
{
    if ([textField tag] == 1001002)
    {
        NSCharacterSet *validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789_qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
        if ([[[textField text] stringByTrimmingCharactersInSet:validSet] length] > 0)
        {
            NSCharacterSet *invalidSet = [NSCharacterSet characterSetWithCharactersInString:[[textField text] stringByTrimmingCharactersInSet:validSet]];
            NSString *compressedText = [[textField text] stringByTrimmingCharactersInSet:invalidSet];
            [textField setText:compressedText];
        }
    }
    if ([[(UITextField *)[[textField superview] viewWithTag:1001001] text] length] > 0 && [[(UITextField *)[[textField superview] viewWithTag:1001002] text] length] > 0 && [[((VariablesInGroupSelector *)[[textField superview] viewWithTag:1001008]).tv indexPathsForSelectedRows] count] > 0)
    {
        [(UIButton *)[[textField superview] viewWithTag:1001003] setEnabled:YES];
        [(UIButton *)[[textField superview] viewWithTag:1001004] setEnabled:YES];
        if (![(UITextField *)[[textField superview] viewWithTag:1001002] isEnabled])
        {
            [(UIButton *)[[textField superview] viewWithTag:1001005] setEnabled:YES];
            [(UIButton *)[[textField superview] viewWithTag:1001006] setEnabled:YES];
        }
    }
    else
    {
        [(UIButton *)[[textField superview] viewWithTag:1001003] setEnabled:NO];
        [(UIButton *)[[textField superview] viewWithTag:1001004] setEnabled:NO];
        [(UIButton *)[[textField superview] viewWithTag:1001005] setEnabled:NO];
        [(UIButton *)[[textField superview] viewWithTag:1001006] setEnabled:NO];
        if ([textField tag] == 1001001)
            return;
    }
    if (![(UITextField *)[[textField superview] viewWithTag:1001002] isEnabled])
        return;
    if ([formElements containsObject:[[(UITextField *)[[textField superview] viewWithTag:1001002] text] lowercaseString]] ||
        [reservedWords containsObject:[[(UITextField *)[[textField superview] viewWithTag:1001002] text] lowercaseString]] ||
        ([[(UITextField *)[[textField superview] viewWithTag:1001002] text] length] > 0 &&
         ([[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '_' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '0' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '1' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '2' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '3' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '4' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '5' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '6' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '7' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '8' ||
          [[(UITextField *)[[textField superview] viewWithTag:1001002] text] characterAtIndex:0] == '9')))
    {
        [(UIButton *)[[textField superview] viewWithTag:1001003] setEnabled:NO];
        [(UIButton *)[[textField superview] viewWithTag:1001004] setEnabled:NO];
        [(UITextField *)[[textField superview] viewWithTag:1001002] setTextColor:[UIColor redColor]];
    }
    else
        [(UITextField *)[[textField superview] viewWithTag:1001002] setTextColor:[UIColor blackColor]];
}

- (void)valueFieldChanged:(UITextField *)textField
{
    if ([[textField text] length] > 1)
        return;
    if ([[textField text] length] == 0)
    {
        if ([valuesFields indexOfObject:textField] == [valuesFields count] - 2 &&
            [[(UITextField *)[valuesFields lastObject] text] length] == 0)
        {
            [(UITextField *)[valuesFields lastObject] removeFromSuperview];
            [valuesFields removeLastObject];
            UIScrollView *uisv = (UIScrollView *)[textField superview];
            [uisv setContentSize:CGSizeMake(uisv.contentSize.width, uisv.frame.size.height)];
            if (textField.frame.origin.y + textField.frame.size.height > uisv.contentSize.height)
                [uisv setContentSize:CGSizeMake(uisv.contentSize.width, textField.frame.origin.y + textField.frame.size.height)];
            [uisv setContentOffset:CGPointMake(0, uisv.contentSize.height - uisv.frame.size.height) animated:YES];
        }
        return;
    }
    if ([valuesFields lastObject] == textField)
    {
        UIScrollView *uisv = (UIScrollView *)[textField superview];
        UITextField *valueText = [[UITextField alloc] initWithFrame:CGRectMake(0, textField.frame.origin.y + textField.frame.size.height, uisv.frame.size.width, textField.frame.size.height)];
        [valueText setBackgroundColor:[UIColor whiteColor]];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [valueText setLeftViewMode:UITextFieldViewModeAlways];
        [valueText setLeftView:spacerView];
        [valueText setPlaceholder:@"Value"];
        [valueText setDelegate:self];
        [valueText addTarget:self action:@selector(valueFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [valueText setReturnKeyType:UIReturnKeyDone];
        [uisv addSubview:valueText];
        [valuesFields addObject:valueText];
        if (valueText.frame.origin.y + valueText.frame.size.height > uisv.contentSize.height)
            [uisv setContentSize:CGSizeMake(uisv.contentSize.width, valueText.frame.origin.y + valueText.frame.size.height)];
    }
}

#pragma mark MFMailComposeViewControllerDelegate Method

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            //            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self.rootViewController.view bringSubviewToFront:self];
        [canvasTapGesture setEnabled:YES];
    }];
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
    if (justParsingForCheckCode)
    {
        if ([elementName isEqualToString:@"View"])
        {
            if ([attributeDict objectForKey:@"CheckCode"] != nil)
            {
                checkCodeStringForDisplay = [[[[[[[[NSString stringWithString:[attributeDict objectForKey:@"CheckCode"]] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"] stringByReplacingOccurrencesOfString:@"\t" withString:@"&#x9;"] stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"] stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"] stringByReplacingOccurrencesOfString:@"\r" withString:@"&#xD;"] stringByReplacingOccurrencesOfString:@"\n" withString:@"&#xA;"];
            }
        }
        return;
    }
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
        [feo.FieldTagElements addObject:@"ControlHeightPercentage"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"ControlHeightPercentage"]]];
        [feo.FieldTagElements addObject:@"PromptText"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"PromptText"]]];
        [feo.FieldTagElements addObject:@"FieldTypeId"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"FieldTypeId"]]];
        [feo.FieldTagElements addObject:@"UniqueId"];
        [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"UniqueId"]]];
        if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"12"])
        {
            if ([attributeDict objectForKey:@"List"] != nil)
            {
                NSString *valuesString = [[[attributeDict objectForKey:@"List"] componentsSeparatedByString:@"||"] objectAtIndex:0];
                NSMutableArray *valuesArray = [NSMutableArray arrayWithArray:[valuesString componentsSeparatedByString:@","]];
                [valuesArray addObject:@""];
                [feo setValues:[NSMutableArray arrayWithArray:valuesArray]];
            }
        }
        if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"21"])
        {
            if ([attributeDict objectForKey:@"List"] != nil)
            {
                NSString *valuesString = [attributeDict objectForKey:@"List"];
                NSMutableArray *valuesArray = [NSMutableArray arrayWithArray:[valuesString componentsSeparatedByString:@","]];
                [feo setValues:[NSMutableArray arrayWithArray:valuesArray]];
            }
        }
        if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"17"] ||
            [[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"19"])
        {
            if ([attributeDict objectForKey:@"SourceTableName"] != nil)
            {
                [feo.FieldTagElements addObject:@"SourceTableName"];
                [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"SourceTableName"]]];
            }
            if ([attributeDict objectForKey:@"TextColumnName"] != nil)
            {
                [feo.FieldTagElements addObject:@"TextColumnName"];
                [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"TextColumnName"]]];
            }
        }
        if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"20"])
        {
            [feo.FieldTagElements addObject:@"RelatedViewName"];
            [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"RelatedViewName"]]];
            [feo.FieldTagElements addObject:@"RelatedViewId"];
            [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"RelatedViewId"]]];
        }
        if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"21"])
        {
            [feo.FieldTagElements addObject:@"List"];
            [feo.FieldTagValues addObject:[NSString stringWithString:[attributeDict objectForKey:@"List"]]];
        }
        [formElementObjects addObject:feo];
        while ([pages count] < [(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue])
            [pages addObject:[[NSMutableArray alloc] init]];
        [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
    }
    else if ([elementName isEqualToString:@"Item"])
    {
        for (NSString *s in attributeDict)
        {
            NSString *val = [attributeDict objectForKey:s];
            for (FormElementObject *feo in formElementObjects)
            {
                if ([feo.FieldTagElements containsObject:@"TextColumnName"])
                {
                    if ([[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"TextColumnName"]] caseInsensitiveCompare:s] == NSOrderedSame)
                    {
                        if (feo.values == nil)
                            feo.values = [[NSMutableArray alloc] init];
                        [feo.values addObject:val];
                    }
                }
            }
        }
    }
    else if ([elementName isEqualToString:@"View"])
    {
        if ([attributeDict objectForKey:@"CheckCode"] != nil)
        {
            checkCodeString = [[[[[[[[NSString stringWithString:[attributeDict objectForKey:@"CheckCode"]] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"] stringByReplacingOccurrencesOfString:@"\t" withString:@"&#x9;"] stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"] stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"] stringByReplacingOccurrencesOfString:@"\r" withString:@"&#xD;"] stringByReplacingOccurrencesOfString:@"\n" withString:@"&#xA;"];
        }
    }
    else if ([elementName isEqualToString:@"Page"])
    {
        if ([attributeDict objectForKey:@"PageId"] != nil)
        {
            [pageNumbers addObject:[attributeDict objectForKey:@"PageId"]];
            if ([attributeDict objectForKey:@"Name"] != nil)
            {
                [pageNames addObject:[attributeDict objectForKey:@"Name"]];
            }
            if ([attributeDict objectForKey:@"ActualPageNumber"] != nil)
            {
                [actualPageNumbers addObject:[attributeDict objectForKey:@"ActualPageNumber"]];
            }
            else
                [actualPageNumbers addObject:@""];
            if ([pageNumbers count] > 1)
            {
                lastPage = (int)[pageNumbers count];
                FormElementObject *feo = [[FormElementObject alloc] init];
                feo.FieldTagElements = [[NSMutableArray alloc] init];
                feo.FieldTagValues = [[NSMutableArray alloc] init];
                [feo.FieldTagElements addObject:@"Name"];
                [feo.FieldTagValues addObject:@"_pageBreak"];
                [feo.FieldTagElements addObject:@"PageId"];
                [feo.FieldTagValues addObject:[NSString stringWithFormat:@"%d", lastPage]];
                [feo.FieldTagElements addObject:@"IsReadOnly"];
                [feo.FieldTagValues addObject:@"False"];
                [feo.FieldTagElements addObject:@"IsRequired"];
                [feo.FieldTagValues addObject:@"False"];
                [feo.FieldTagElements addObject:@"ControlWidthPercentage"];
                [feo.FieldTagValues addObject:@"0.19853"];
                [feo.FieldTagElements addObject:@"PromptText"];
                [feo.FieldTagValues addObject:@"Page Break"];
                [feo.FieldTagElements addObject:@"FieldTypeId"];
                [feo.FieldTagValues addObject:@"99"];
                [feo.FieldTagElements addObject:@"UniqueId"];
                [feo.FieldTagValues addObject:[CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))) lowercaseString]];
                [formElementObjects addObject:feo];
                while ([pages count] < [(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue])
                    [pages addObject:[[NSMutableArray alloc] init]];
                [(NSMutableArray *)[pages objectAtIndex:[(NSString *)[feo.FieldTagValues objectAtIndex:[feo.FieldTagElements indexOfObject:@"PageId"]] intValue] - 1] addObject:feo];
            }
        }
    }
}

- (void)processCheckCodeString
{
    if ([checkCodeString length] == 0)
        return;
    while ([[checkCodeString lowercaseString] containsString:@"end-field"])
    {
        int fieldPosition = (int)[[checkCodeString lowercaseString] rangeOfString:@"field "].location;
        int endFieldPosition = (int)[[[checkCodeString lowercaseString] substringFromIndex:fieldPosition] rangeOfString:@"end-field"].location;
        NSRange fieldRange = NSMakeRange(fieldPosition, endFieldPosition + 9);
        NSString *fieldString = [checkCodeString substringWithRange:fieldRange];
        if (![checkCodeStrings containsObject:fieldString])
            [checkCodeStrings addObject:fieldString];
        checkCodeString = [checkCodeString stringByReplacingCharactersInRange:fieldRange withString:@""];
    }
    while ([[checkCodeString lowercaseString] containsString:@"end-page"])
    {
        int pagePosition = (int)[[checkCodeString lowercaseString] rangeOfString:@"page "].location;
        int endPagePosition = (int)[[[checkCodeString lowercaseString] substringFromIndex:pagePosition] rangeOfString:@"end-page"].location;
        NSRange pageRange = NSMakeRange(pagePosition, endPagePosition + 8);
        NSString *pageString = [checkCodeString substringWithRange:pageRange];
        if (![checkCodeStrings containsObject:pageString])
            [checkCodeStrings addObject:pageString];
        checkCodeString = [checkCodeString stringByReplacingCharactersInRange:pageRange withString:@""];
    }
    if ([[[checkCodeString stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""] length] == 0)
        checkCodeString = @"";
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([scrollView tag] == 2360852)
        return templateViewLabel;
    else
        return checkCodeViewLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
