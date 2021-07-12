//
//  ImportCSV.m
//  EpiInfo
//
//  Created by John Copeland on 8/1/14.
//

#import "ImportCSV.h"

@implementation ImportCSV
@synthesize url = _url;
@synthesize rootViewController = _rootViewController;
@synthesize fakeNavBar = _fakeNavBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        [self setUrl:url];
        
        dataText = @"";
        formName = @"";
        contentSizeHeight = 4.0;
        
        hasAFirstResponder = NO;
        
        formCanvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [formCanvas setBackgroundColor:[UIColor colorWithRed:0/255.0 green:129/255.0 blue:126/255.0 alpha:1.0]];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:formCanvas];
        [self setScrollEnabled:YES];
        
        ado = [[AnalysisDataObject alloc] initWithCSVFile:url.path];
        [[NSFileManager defaultManager] removeItemAtPath:url.path error:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self setContentSize:CGSizeMake(320, 500)];
            
            EpiInfoUILabel *datasetNameLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6, contentSizeHeight, 113, 40)];
            [datasetNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [datasetNameLabel setTextAlignment:NSTextAlignmentLeft];
            [datasetNameLabel setText:@"Dataset Name:"];
            [datasetNameLabel setTextColor:[UIColor whiteColor]];
            [formCanvas addSubview:datasetNameLabel];
            EpiInfoTextField *datasetName = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(129, contentSizeHeight, 185, 40)];
            [datasetName addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
            [datasetName setBorderStyle:UITextBorderStyleRoundedRect];
            [datasetName setDelegate:self];
            [datasetName setReturnKeyType:UIReturnKeyDone];
            // Get the file name from the NSURL
            [datasetName setText:[url.lastPathComponent substringToIndex:[url.lastPathComponent rangeOfString:@"." options:NSBackwardsSearch].location]];
            [formCanvas addSubview:datasetName];
            contentSizeHeight += 50.0;
            
            formName = [datasetName text];
            
            EpiInfoUILabel *columnNameHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(10, contentSizeHeight, 150, 40)];
            [columnNameHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [columnNameHeader setTextAlignment:NSTextAlignmentCenter];
            [columnNameHeader setText:@"Variable"];
            [columnNameHeader setTextColor:[UIColor whiteColor]];
            [formCanvas addSubview:columnNameHeader];
            EpiInfoUILabel *variableTypeHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(160, contentSizeHeight, 75, 40)];
            [variableTypeHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [variableTypeHeader setTextAlignment:NSTextAlignmentCenter];
            [variableTypeHeader setText:@"Type"];
            [variableTypeHeader setTextColor:[UIColor whiteColor]];
            [formCanvas addSubview:variableTypeHeader];
            EpiInfoUILabel *binaryHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(235, contentSizeHeight, 75, 40)];
            [binaryHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [binaryHeader setTextAlignment:NSTextAlignmentCenter];
            [binaryHeader setText:@"Binary"];
            [binaryHeader setTextColor:[UIColor whiteColor]];
            [formCanvas addSubview:binaryHeader];
            contentSizeHeight += 40;
            
            NSArray *variableNamesArray = [ado.columnNames keysSortedByValueUsingComparator:^(NSNumber *num1, NSNumber *num2) {
               if ([num1 intValue] > [num2 intValue])
                   return (NSComparisonResult)NSOrderedDescending;
                if ([num1 intValue] < [num2 intValue])
                    return (NSComparisonResult)NSOrderedAscending;
                return (NSComparisonResult)NSOrderedSame;
            }];
            for (int i = 0; i < variableNamesArray.count; i++)
            {
                EpiInfoTextField *variableNameField = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(11, contentSizeHeight, 148, 40)];
                [variableNameField setTag:1000 + i];
                [variableNameField setBorderStyle:UITextBorderStyleNone];
                [variableNameField setBackgroundColor:[UIColor whiteColor]];
                [variableNameField.layer setCornerRadius:4.0];
                [variableNameField setDelegate:self];
                [variableNameField setReturnKeyType:UIReturnKeyDone];
                [variableNameField setText:[[[variableNamesArray objectAtIndex:i] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 0x0d] withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]];
                UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, variableNameField.frame.size.height)];
                [variableNameField setLeftViewMode:UITextFieldViewModeAlways];
                [variableNameField setLeftView:spacerView];
                if (i == 0)
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(variableNameField.frame.origin.x + 10, contentSizeHeight, variableNameField.frame.size.width - 10, 40)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(variableNameField.frame.origin.x, contentSizeHeight + 20, 20, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                    [formCanvas addSubview:white1];
                }
                else if (i == variableNamesArray.count - 1)
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(variableNameField.frame.origin.x + 10, contentSizeHeight, variableNameField.frame.size.width - 10, 40)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(variableNameField.frame.origin.x, contentSizeHeight, 20, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                    [formCanvas addSubview:white1];
                }
                else
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:variableNameField.frame];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                }
                [formCanvas addSubview:variableNameField];
                
                EpiInfoUILabel *variableTypeField = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(161, contentSizeHeight, 73, 40)];
                [variableTypeField setBackgroundColor:[UIColor whiteColor]];
                [variableTypeField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [variableTypeField setTextColor:[UIColor blackColor]];
                [variableTypeField setTextAlignment:NSTextAlignmentCenter];
                int typeNumber = [(NSNumber *)[ado.dataTypes objectForKey:[NSString stringWithFormat:@"%d", i]] intValue];
                if (typeNumber < 2)
                    [variableTypeField setText:@"Num"];
                else
                    [variableTypeField setText:@"String"];
                [formCanvas addSubview:variableTypeField];
                
                EpiInfoUILabel *isBinaryField = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(236, contentSizeHeight, 73, 40)];
                [isBinaryField setBackgroundColor:[UIColor whiteColor]];
                [isBinaryField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [isBinaryField setTextColor:[UIColor blackColor]];
                [isBinaryField setTextAlignment:NSTextAlignmentCenter];
                [isBinaryField.layer setCornerRadius:4.0];
                if ([(NSNumber *)[ado.isTrueFalse objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 1)
                    [isBinaryField setText:@"T/F"];
                else if ([(NSNumber *)[ado.isYesNo objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 1)
                    [isBinaryField setText:@"Y/N"];
                else if ([(NSNumber *)[ado.isOneZero objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 1)
                    [isBinaryField setText:@"1/0"];
                else if ([(NSNumber *)[ado.isBinary objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 1)
                    [isBinaryField setText:@"Binary"];
                if (i == 0)
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(isBinaryField.frame.origin.x, contentSizeHeight, isBinaryField.frame.size.width - 10, 40)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(isBinaryField.frame.origin.x, contentSizeHeight + 20, isBinaryField.frame.size.width, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                    [formCanvas addSubview:white1];
                }
                else if (i == variableNamesArray.count - 1)
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(isBinaryField.frame.origin.x, contentSizeHeight, isBinaryField.frame.size.width - 10, 40)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(isBinaryField.frame.origin.x, contentSizeHeight, isBinaryField.frame.size.width, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                    [formCanvas addSubview:white1];
                }
                else
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:isBinaryField.frame];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                }
                [formCanvas addSubview:isBinaryField];

                contentSizeHeight += 42.0;
            }
            
            contentSizeHeight += 10;
            UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(198, contentSizeHeight, 120, 40)];
            [saveButton setTitle:@"Save" forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [saveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [saveButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [saveButton.layer setMasksToBounds:YES];
            [saveButton.layer setCornerRadius:4.0];
            [saveButton addTarget:self action:@selector(saveTheForm) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:saveButton];
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(2, contentSizeHeight, 120, 40)];
            [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [cancelButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [cancelButton.layer setMasksToBounds:YES];
            [cancelButton.layer setCornerRadius:4.0];
            [cancelButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelButton];
            contentSizeHeight += 42.0;
            
            if (contentSizeHeight > 500)
            {
                [self setContentSize:CGSizeMake(frame.size.width, contentSizeHeight)];
                [formCanvas setFrame:CGRectMake(0, 0, frame.size.width, contentSizeHeight + 256)];
            }
        }
        else
        {
            [self setContentSize:CGSizeMake(self.frame.size.width, 800)];
            
            EpiInfoUILabel *datasetNameLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6, contentSizeHeight, 113, 40)];
            [datasetNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [datasetNameLabel setTextAlignment:NSTextAlignmentLeft];
            [datasetNameLabel setText:@"Dataset Name:"];
            [datasetNameLabel setTextColor:[UIColor whiteColor]];
            [formCanvas addSubview:datasetNameLabel];
            EpiInfoTextField *datasetName = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(129, contentSizeHeight, 500, 40)];
            [datasetName addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
            [datasetName setBorderStyle:UITextBorderStyleRoundedRect];
            [datasetName setDelegate:self];
            [datasetName setReturnKeyType:UIReturnKeyDone];
            // Get the file name from the NSURL
            [datasetName setText:[url.lastPathComponent substringToIndex:[url.lastPathComponent rangeOfString:@"." options:NSBackwardsSearch].location]];
            [formCanvas addSubview:datasetName];
            contentSizeHeight += 50.0;
            
            formName = [datasetName text];
            
            EpiInfoUILabel *columnNameHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(10, contentSizeHeight, 374, 40)];
            [columnNameHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [columnNameHeader setTextAlignment:NSTextAlignmentCenter];
            [columnNameHeader setText:@"Variable"];
            [columnNameHeader setTextColor:[UIColor whiteColor]];
            [formCanvas addSubview:columnNameHeader];
            EpiInfoUILabel *variableTypeHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(384, contentSizeHeight, 187, 40)];
            [variableTypeHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [variableTypeHeader setTextAlignment:NSTextAlignmentCenter];
            [variableTypeHeader setText:@"Type"];
            [variableTypeHeader setTextColor:[UIColor whiteColor]];
            [formCanvas addSubview:variableTypeHeader];
            EpiInfoUILabel *binaryHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(571, contentSizeHeight, 187, 40)];
            [binaryHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [binaryHeader setTextAlignment:NSTextAlignmentCenter];
            [binaryHeader setText:@"Binary"];
            [binaryHeader setTextColor:[UIColor whiteColor]];
            [formCanvas addSubview:binaryHeader];
            contentSizeHeight += 40;
            
            NSArray *variableNamesArray = [ado.columnNames keysSortedByValueUsingComparator:^(NSNumber *num1, NSNumber *num2) {
                if ([num1 intValue] > [num2 intValue])
                    return (NSComparisonResult)NSOrderedDescending;
                if ([num1 intValue] < [num2 intValue])
                    return (NSComparisonResult)NSOrderedAscending;
                return (NSComparisonResult)NSOrderedSame;
            }];
            for (int i = 0; i < variableNamesArray.count; i++)
            {
                EpiInfoTextField *variableNameField = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(11, contentSizeHeight, 372, 40)];
                [variableNameField setTag:1000 + i];
                [variableNameField setBorderStyle:UITextBorderStyleNone];
                [variableNameField setBackgroundColor:[UIColor whiteColor]];
                [variableNameField.layer setCornerRadius:4.0];
                [variableNameField setDelegate:self];
                [variableNameField setReturnKeyType:UIReturnKeyDone];
                [variableNameField setText:[[[variableNamesArray objectAtIndex:i] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 0x0d] withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]];
                UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, variableNameField.frame.size.height)];
                [variableNameField setLeftViewMode:UITextFieldViewModeAlways];
                [variableNameField setLeftView:spacerView];
                if (i == 0)
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(variableNameField.frame.origin.x + 10, contentSizeHeight, variableNameField.frame.size.width - 10, 40)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(variableNameField.frame.origin.x, contentSizeHeight + 20, 20, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                    [formCanvas addSubview:white1];
                }
                else if (i == variableNamesArray.count - 1)
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(variableNameField.frame.origin.x + 10, contentSizeHeight, variableNameField.frame.size.width - 10, 40)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(variableNameField.frame.origin.x, contentSizeHeight, 20, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                    [formCanvas addSubview:white1];
                }
                else
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:variableNameField.frame];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                }
                [formCanvas addSubview:variableNameField];
                
                EpiInfoUILabel *variableTypeField = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(385, contentSizeHeight, 185, 40)];
                [variableTypeField setBackgroundColor:[UIColor whiteColor]];
                [variableTypeField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [variableTypeField setTextColor:[UIColor blackColor]];
                [variableTypeField setTextAlignment:NSTextAlignmentCenter];
                int typeNumber = [(NSNumber *)[ado.dataTypes objectForKey:[NSString stringWithFormat:@"%d", i]] intValue];
                if (typeNumber < 2)
                    [variableTypeField setText:@"Num"];
                else
                    [variableTypeField setText:@"String"];
                [formCanvas addSubview:variableTypeField];
                
                EpiInfoUILabel *isBinaryField = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(572, contentSizeHeight, 185, 40)];
                [isBinaryField setBackgroundColor:[UIColor whiteColor]];
                [isBinaryField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [isBinaryField setTextColor:[UIColor blackColor]];
                [isBinaryField setTextAlignment:NSTextAlignmentCenter];
                [isBinaryField.layer setCornerRadius:4.0];
                if ([(NSNumber *)[ado.isTrueFalse objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 1)
                    [isBinaryField setText:@"T/F"];
                else if ([(NSNumber *)[ado.isYesNo objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 1)
                    [isBinaryField setText:@"Y/N"];
                else if ([(NSNumber *)[ado.isOneZero objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 1)
                    [isBinaryField setText:@"1/0"];
                else if ([(NSNumber *)[ado.isBinary objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 1)
                    [isBinaryField setText:@"Binary"];
                if (i == 0)
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(isBinaryField.frame.origin.x, contentSizeHeight, isBinaryField.frame.size.width - 10, 40)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(isBinaryField.frame.origin.x, contentSizeHeight + 20, isBinaryField.frame.size.width, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                    [formCanvas addSubview:white1];
                }
                else if (i == variableNamesArray.count - 1)
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(isBinaryField.frame.origin.x, contentSizeHeight, isBinaryField.frame.size.width - 10, 40)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(isBinaryField.frame.origin.x, contentSizeHeight, isBinaryField.frame.size.width, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                    [formCanvas addSubview:white1];
                }
                else
                {
                    UIView *white0 = [[UIView alloc] initWithFrame:isBinaryField.frame];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [formCanvas addSubview:white0];
                }
                [formCanvas addSubview:isBinaryField];
                
                contentSizeHeight += 42.0;
            }
            
            contentSizeHeight += 10;
            UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 + 40, contentSizeHeight, 120, 40)];
            [saveButton setTitle:@"Save" forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [saveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [saveButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [saveButton.layer setMasksToBounds:YES];
            [saveButton.layer setCornerRadius:4.0];
            [saveButton addTarget:self action:@selector(saveTheForm) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:saveButton];
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 160, contentSizeHeight, 120, 40)];
            [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [cancelButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [cancelButton.layer setMasksToBounds:YES];
            [cancelButton.layer setCornerRadius:4.0];
            [cancelButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelButton];
            contentSizeHeight += 42.0;
            
            if (contentSizeHeight > 800)
            {
                [self setContentSize:CGSizeMake(frame.size.width, contentSizeHeight)];
                [formCanvas setFrame:CGRectMake(0, 0, frame.size.width, contentSizeHeight + 256)];
            }
        }
        
//        EpiInfoUILabel *disclaimer = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
//        [disclaimer setBackgroundColor:[UIColor blackColor]];
//        [disclaimer setTextColor:[UIColor whiteColor]];
//        [disclaimer setNumberOfLines:0];
//        [disclaimer setLineBreakMode:NSLineBreakByWordWrapping];
//        [disclaimer.layer setCornerRadius:4.0];
//        [disclaimer setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
//        [disclaimer setText:@"This feature is still under development. Touch this message to dismiss the form and return to StatCalc."];
//        UIButton *dismissFormButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
//        [dismissFormButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
//        [dismissFormButton setBackgroundColor:[UIColor clearColor]];
        //        [self addSubview:disclaimer];
        //        [self addSubview:dismissFormButton];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndFakeNavBar:(UIView *)fnb
{
    self = [self initWithFrame:frame AndURL:url];
    if (self)
    {
        [self setRootViewController:rvc];
        [self setFakeNavBar:fnb];
        
        UINavigationBar *uinb = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.fakeNavBar.frame.size.width, 20)];
        [uinb setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [uinb setShadowImage:[UIImage new]];
        [uinb setTranslucent:YES];
        UINavigationItem *uini = [[UINavigationItem alloc] initWithTitle:@""];
        UIBarButtonItem *xBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissForm)];
        [xBarButton setAccessibilityLabel:@"Cancel"];
        [xBarButton setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTheForm)];
        [saveBarButton setAccessibilityLabel:@"Continue Saving the data."];
        [saveBarButton setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [uini setRightBarButtonItem:xBarButton];
        [uini setLeftBarButtonItem:saveBarButton];
        [uinb setItems:[NSArray arrayWithObject:uini]];
        [self.fakeNavBar addSubview:uinb];
        
        if ([[url.lastPathComponent substringToIndex:[url.lastPathComponent rangeOfString:@"." options:NSBackwardsSearch].location] isEqualToString:@"_VHFContactTracing"])
            [self saveTheForm];
    }
    return self;
}

- (void)changeFakeNavBarText:(NSString *)text
{
    for (UIView *v in [self.fakeNavBar subviews])
        if ([v isKindOfClass:[UILabel class]])
            [(UILabel *)v setText:text];
}

- (void)saveTheForm
{
    NSString *fakeNavBarText = @"Loading data... 0%";
    NSThread *navBarThread = [[NSThread alloc] initWithTarget:self selector:@selector(changeFakeNavBarText:) object:fakeNavBarText];
    [navBarThread start];

    NSString *createTableStatement = [NSString stringWithFormat:@"create table %@(", formName];
    NSMutableDictionary *nsmd = [[NSMutableDictionary alloc] init];

    for (UIView *v in [formCanvas subviews])
    {
        if ([v isKindOfClass:[UIControl class]])
            [(UIControl *)v setEnabled:NO];
        if ([v isKindOfClass:[EpiInfoTextField class]] && [v tag] > 0)
        {
            [(EpiInfoTextField *)v setEnabled:NO];
            [nsmd setObject:[NSString stringWithFormat:@"%d", (int)[v tag] - 1000] forKey:[(EpiInfoTextField *)v text]];
        }
    }
    
    NSArray *variableNamesArray = [nsmd keysSortedByValueUsingComparator:^(NSNumber *num1, NSNumber *num2) {
        if ([num1 intValue] > [num2 intValue])
            return (NSComparisonResult)NSOrderedDescending;
        if ([num1 intValue] < [num2 intValue])
            return (NSComparisonResult)NSOrderedAscending;
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    for (int i = 0; i < variableNamesArray.count; i++)
    {
        if (i == 0)
            createTableStatement = [createTableStatement stringByAppendingString:[variableNamesArray objectAtIndex:i]];
        else
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@", %@", [variableNamesArray objectAtIndex:i]]];
        NSString *key = (NSString *)[nsmd objectForKey:[variableNamesArray objectAtIndex:i]];
        int type = [[ado.dataTypes objectForKey:key] intValue];
        // Special case of Notes field in VHF dataset
        if ([formName isEqualToString:@"_VHFContactTracing"] && [[[variableNamesArray objectAtIndex:i] lowercaseString] isEqualToString:@"notes"])
        {
            type = 2;
        }
        if (type == 0)
            createTableStatement = [createTableStatement stringByAppendingString:@" integer"];
        else if (type == 1)
            createTableStatement = [createTableStatement stringByAppendingString:@" real"];
        else
            createTableStatement = [createTableStatement stringByAppendingString:@" text"];
    }
    
    createTableStatement = [createTableStatement stringByAppendingString:@")"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];

        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
//            NSString *selStmt = [NSString stringWithFormat:@"select count(name), name as n from sqlite_master group by name"];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
//                    NSLog(@"%s:  %d", sqlite3_column_text(statement, 1), sqlite3_column_int(statement, 0));
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists > 0)
        {
            //Convert the databasePath NSString to a char array
            const char *dbpath = [databasePath UTF8String];
            
            //Open sqlite3 analysisDB pointing to the databasePath
            if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                //Build the DROP TABLE statement
                //Convert the sqlStmt to char array
                const char *sql_stmt = [[NSString stringWithFormat:@"drop table %@", formName] UTF8String];
                
                //Execute the DROP TABLE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to drop table: %s :::: %@", errMsg, createTableStatement);
                    [self dismissForm];
                    return;
                }
                else
                {
//                                        NSLog(@"Table dropped");
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open/create database");
                [self dismissForm];
                return;
            }
        }
        //Convert the databasePath NSString to a char array
        const char *dbpath = [databasePath UTF8String];
        
        //Open sqlite3 analysisDB pointing to the databasePath
        if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
        {
            char *errMsg;
            //Build the CREATE TABLE statement
            //Convert the sqlStmt to char array
            const char *sql_stmt = [createTableStatement UTF8String];
            //                const char *sql_stmt = [@"drop table FoodHistory" UTF8String];
            
            //Execute the CREATE TABLE statement
            if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table: %s :::: %@", errMsg, createTableStatement);
                [self dismissForm];
                return;
            }
            else
            {
//                                    NSLog(@"Table created");
            }
            //Close the sqlite connection
            sqlite3_close(epiinfoDB);
        }
        else
        {
            NSLog(@"Failed to open/create database");
            [self dismissForm];
            return;
        }
        
        int denominator = (int)[ado.dataSet count];
        for (int i = 0; i < [ado.dataSet count]; i++)
        {
            NSString *insertStatement = [NSString stringWithFormat:@"insert into %@\nvalues(", formName];
            NSArray *nsa = (NSArray *)[ado.dataSet objectAtIndex:i];
            for (int j = 0; j < nsa.count; j++)
            {
                if (j > 0)
                    insertStatement = [insertStatement stringByAppendingString:@","];
                if ([[nsa objectAtIndex:j] isKindOfClass:[NSNull class]])
                    insertStatement = [insertStatement stringByAppendingString:@"NULL"];
                else if ([[[nsa objectAtIndex:j] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 0x0d] withString:@""] length] == 0)
                    insertStatement = [insertStatement stringByAppendingString:@"NULL"];
                else
                {
                    NSString *value = [[nsa objectAtIndex:j] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 0x0d] withString:@""];
                    NSString *key = (NSString *)[nsmd objectForKey:[variableNamesArray objectAtIndex:j]];
                    int type = [[ado.dataTypes objectForKey:key] intValue];
                    if (type == 2)
                    {
                        if ([value characterAtIndex:0] == '"' && [value characterAtIndex:value.length - 1] == '"') { }
                        else
                        {
                            if ((int)[value rangeOfString:@"'"].location < 0 || (int)[value rangeOfString:@"'"].location >= (int)value.length)
                            {
                                value = [NSString stringWithFormat:@"'%@'", value];
                            }
                            else
                            {
                                value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
                                value = [NSString stringWithFormat:@"\"%@\"", value];
                            }
                        }
                        NSError *regexerror;
                        NSRange searchedRange = NSMakeRange(0, [value length]);
                        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" options:0 error:&regexerror];
                        NSArray* matches = [regex matchesInString:value options:0 range: searchedRange];
                        if ([matches count] == 1)
                        {
                            for (NSTextCheckingResult* match in matches)
                            {
                                NSString *csvDate = [value substringWithRange:[match range]];
                                NSArray *dateComponents = [csvDate componentsSeparatedByString:@"-"];
                                if ([dateComponents count] != 3)
                                    break;
                                NSString *csvMonth = [dateComponents objectAtIndex:1];
                                if ([csvMonth intValue] < 10)
                                    csvMonth = [@"0" stringByAppendingString:csvMonth];
                                NSString *csvDay = [dateComponents objectAtIndex:2];
                                if ([csvDay intValue] < 10)
                                    csvDay = [@"0" stringByAppendingString:csvDay];
                                BOOL dmy = NO;
                                NSDate *dateObject = [NSDate date];
                                dmy = ([[[dateObject descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[dateObject descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
                                NSString *newDate = [NSString stringWithFormat:@"%@/%@/%@", csvMonth, csvDay, [dateComponents objectAtIndex:0]];
                                if (dmy)
                                {
                                    newDate = [NSString stringWithFormat:@"%@/%@/%@", csvDay, csvMonth, [dateComponents objectAtIndex:0]];
                                }
                                value = [value stringByReplacingOccurrencesOfString:csvDate withString:newDate];
                            }
                        }
                    }
                    insertStatement = [insertStatement stringByAppendingString:value];
                }
            }
            insertStatement = [insertStatement stringByAppendingString:@")"];
        
            //Open sqlite3 analysisDB pointing to the databasePath
            if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                //Build the INSERT statement
                //Convert the sqlStmt to char array
                const char *sql_stmt = [insertStatement UTF8String];
                //                const char *sql_stmt = [@"delete from FoodHistory where caseid is null" UTF8String];
                //                const char *sql_stmt = [@"update FoodHistory set DOB = '04/23/1978' where DOB = '04/33/1978'" UTF8String];
                
                //Execute the INSERT statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to insert row into table: %s :::: %@", errMsg, insertStatement);
                }
                else
                {
//                    NSLog(@"Row(s) inserted");
                    fakeNavBarText = [NSString stringWithFormat:@"Loading Data... %d%%", (100 * i) / denominator];
                    float rollovers;
                    int modulo = (int)(modff((float)i / 50.0, &rollovers) * 50.0);
                    if (![navBarThread isExecuting] && modulo == 0)
                    {
                        navBarThread = [[NSThread alloc] initWithTarget:self selector:@selector(changeFakeNavBarText:) object:fakeNavBarText];
                        [navBarThread start];
                    }
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open database or insert record");
            }
        }
    }
    else
    {
        NSLog(@"Database directory does not exist");
    }

    [self dismissForm];
}

- (void)dismissForm;
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * -0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * -1.0, 0.0, 1.0, 0.0);
            [self.rootViewController.view.layer setTransform:rotate];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                CATransform3D rotate = CATransform3DIdentity;
                rotate.m34 = 1.0 / -2000;
                rotate = CATransform3DRotate(rotate, M_PI * -1.5, 0.0, 1.0, 0.0);
                [self.rootViewController.view.layer setTransform:rotate];
            } completion:^(BOOL finished){
                [(EpiInfoViewController *)[(EpiInfoNavigationController *)self.rootViewController topViewController] viewDidAppear:YES];
                [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    CATransform3D rotate = CATransform3DIdentity;
                    rotate.m34 = 1.0 / -2000;
                    rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
                    [self.rootViewController.view.layer setTransform:CATransform3DIdentity];
                } completion:^(BOOL finished){
                }];
            }];
        }];
    }];
}

- (void)removeFromSuperview
{
    [self.fakeNavBar removeFromSuperview];
    [super removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
    } completion:^(BOOL finished){
        hasAFirstResponder = NO;
    }];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (hasAFirstResponder)
        return YES;
    
    [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height + 200.0)];
    hasAFirstResponder = YES;
    
    return YES;
}

- (void)textFieldAction:(EpiInfoTextField *)eitf
{
    formName = [eitf text];
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
