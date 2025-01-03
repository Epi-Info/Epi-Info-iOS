//
//  FormView.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import "FormView.h"

@implementation FormView
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
        contentSizeHeight = 0.0;
        
        legalValuesDictionary = [[NSMutableDictionary alloc] init];
        
        [self setContentSize:CGSizeMake(320, 548)];
        
        formCanvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [formCanvas setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundColor:[UIColor whiteColor]];

        UIImageView *imageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (frame.size.height < 500.0)
                [imageBackground setImage:[UIImage imageNamed:@"iPhone4Background.png"]];
            else
                [imageBackground setImage:[UIImage imageNamed:@"iPhone5Background.png"]];
        }
        else
        {
            [imageBackground setImage:[UIImage imageNamed:@"iPadBackground.png"]];
        }
//        [self addSubview:imageBackground];
        
        [self addSubview:formCanvas];
        [self setScrollEnabled:YES];
        
        xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:self.url];
        [xmlParser setDelegate:self];
        [xmlParser setShouldResolveExternalEntities:YES];
        
        xmlParser1 = [[NSXMLParser alloc] initWithContentsOfURL:self.url];
        [xmlParser1 setDelegate:self];
        [xmlParser1 setShouldResolveExternalEntities:YES];
        
        firstParse = YES;
        BOOL success = [xmlParser parse];
        
        if (success)
        {
            if (legalValuesArray)
            {
                [legalValuesDictionary setObject:legalValuesArray forKey:lastLegalValuesKey];
            }
        }

        firstParse = NO;
        success = [xmlParser1 parse];
        
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

        
        if (contentSizeHeight > 548)
        {
            [self setContentSize:CGSizeMake(frame.size.width, contentSizeHeight)];
            [formCanvas setFrame:CGRectMake(0, 0, frame.size.width, contentSizeHeight)];
        }
        
        UILabel *disclaimer = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
        [disclaimer setBackgroundColor:[UIColor blackColor]];
        [disclaimer setTextColor:[UIColor whiteColor]];
        [disclaimer setNumberOfLines:0];
        [disclaimer setLineBreakMode:NSLineBreakByWordWrapping];
        [disclaimer.layer setCornerRadius:4.0];
        [disclaimer setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [disclaimer setText:@"This feature is still under development. Touch this message to dismiss the form and return to StatCalc."];
        UIButton *dismissFormButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
        [dismissFormButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
        [dismissFormButton setBackgroundColor:[UIColor clearColor]];
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
        
        float uinbY = 0.0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            uinbY = 20.0;
        UINavigationBar *uinb = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, uinbY, self.fakeNavBar.frame.size.width, 20)];
        [uinb setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [uinb setShadowImage:[UIImage new]];
        [uinb setTranslucent:YES];
        UINavigationItem *uini = [[UINavigationItem alloc] initWithTitle:@""];
        xBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissForm)];
        [xBarButton setAccessibilityLabel:@"Cancel"];
        [xBarButton setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        saveBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTheForm)];
        [saveBarButton setAccessibilityLabel:@"Continue Saving the form."];
        [saveBarButton setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [uini setRightBarButtonItem:xBarButton];
        [uini setLeftBarButtonItem:saveBarButton];
        [uinb setItems:[NSArray arrayWithObject:uini]];
        [self.fakeNavBar addSubview:uinb];
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [xBarButton setEnabled:YES];
    [saveBarButton setEnabled:YES];
}

- (void)saveTheForm
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        saveFormView = [[SaveFormView alloc] initWithFrame:self.frame AndRootViewController:self.rootViewController AndFormView:self AndFormName:formName AndURL:self.url];
        [self.rootViewController.view addSubview:saveFormView];
        [xBarButton setEnabled:NO];
        [saveBarButton setEnabled:NO];
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
            [self.rootViewController.view.layer setTransform:CATransform3DIdentity];
        } completion:^(BOOL finished){
        }];
    }];
}

- (void)dismissForm
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

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    dataText = [dataText stringByAppendingString:[NSString stringWithFormat:@"\n%@", elementName]];
    if (firstParse)
    {
        if ([elementName isEqualToString:@"SourceTable"])
        {
            if (legalValuesArray)
            {
                [legalValuesDictionary setObject:legalValuesArray forKey:lastLegalValuesKey];
            }
            legalValuesArray = [[NSMutableArray alloc] init];
            [legalValuesArray addObject:@""];
            lastLegalValuesKey = [attributeDict objectForKey:@"TableName"];
        }
        if ([elementName isEqualToString:@"Item"])
        {
            if (legalValuesArray)
                for (id key in attributeDict)
                    [legalValuesArray addObject:[attributeDict objectForKey:key]];
        }
    }

    else
    {
        if ([elementName isEqualToString:@"View"])
        {
            formName = [attributeDict objectForKey:@"Name"];
        }
        if ([elementName isEqualToString:@"Field"])
        {
            UILabel *elementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, contentSizeHeight, 280, 40)];
            [elementLabel setText:[NSString stringWithFormat:@"%@", [attributeDict objectForKey:@"PromptText"]]];
            [elementLabel setTextAlignment:NSTextAlignmentLeft];
            float fontsize = 14.0;
            while ([elementLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]}].width > 280)
                fontsize -= 0.1;
            [elementLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]];
            [formCanvas addSubview:elementLabel];
            if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"1"])
            {
                UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 280, 40)];
                [tf setBorderStyle:UITextBorderStyleRoundedRect];
                [formCanvas addSubview:tf];
                [tf setEnabled:NO];
                contentSizeHeight += 40.0;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"2"])
            {
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"3"])
            {
                UppercaseTextField *tf = [[UppercaseTextField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 280, 40)];
                [tf setBorderStyle:UITextBorderStyleRoundedRect];
                [formCanvas addSubview:tf];
                [tf setEnabled:NO];
                contentSizeHeight += 40.0;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"4"])
            {
                UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 280, 160)];
                [bg setBackgroundColor:[UIColor blackColor]];
                [formCanvas addSubview:bg];
                UITextView *tf = [[UITextView alloc] initWithFrame:CGRectMake(1, 1, 278, 158)];
                [tf setEditable:NO];
                [bg addSubview:tf];
                contentSizeHeight += 160;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"5"])
            {
                NumberField *tf = [[NumberField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 280, 40)];
                [tf setBorderStyle:UITextBorderStyleRoundedRect];
                [formCanvas addSubview:tf];
                [tf setEnabled:NO];
                contentSizeHeight += 40.0;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"6"])
            {
                PhoneNumberField *tf = [[PhoneNumberField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 80, 40)];
                [tf setBorderStyle:UITextBorderStyleRoundedRect];
                [formCanvas addSubview:tf];
                [tf setEnabled:NO];
                contentSizeHeight += 40.0;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"7"])
            {
                DateField *tf = [[DateField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 80, 40)];
                [tf setBorderStyle:UITextBorderStyleRoundedRect];
                [formCanvas addSubview:tf];
                [tf setEnabled:NO];
                contentSizeHeight += 40.0;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"8"])
            {
                TimeField *tf = [[TimeField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 80, 40)];
                [tf setBorderStyle:UITextBorderStyleRoundedRect];
                [formCanvas addSubview:tf];
                [tf setEnabled:NO];
                contentSizeHeight += 40.0;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"9"])
            {
                DateTimeField *tf = [[DateTimeField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 80, 40)];
                [tf setBorderStyle:UITextBorderStyleRoundedRect];
                [formCanvas addSubview:tf];
                [tf setEnabled:NO];
                contentSizeHeight += 40.0;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"10"])
            {
                [elementLabel setFrame:CGRectMake(60, contentSizeHeight, 260, 40)];
                while ([elementLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]}].width > 260)
                    fontsize -= 0.1;
                [elementLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]];
                Checkbox *cb = [[Checkbox alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 5, 30, 30)];
                [formCanvas addSubview:cb];
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"11"])
            {
                YesNo *yn = [[YesNo alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180)];
                [formCanvas addSubview:yn];
                contentSizeHeight += 160;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"15"])
            {
                MirrorField *tf = [[MirrorField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 80, 40)];
                [tf setBorderStyle:UITextBorderStyleRoundedRect];
                [formCanvas addSubview:tf];
                contentSizeHeight += 40.0;

            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"17"])
            {
                LegalValues *lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]]];
                [formCanvas addSubview:lv];
                contentSizeHeight += 160;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"18"])
            {
                NSMutableArray *fullArray = [legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]];
                NSMutableArray *evenArray = [[NSMutableArray alloc] init];
                NSMutableArray *oddArray = [[NSMutableArray alloc] init];
                [evenArray addObject:@""];
                [oddArray addObject:@""];
                for (int i = 1; i < fullArray.count; i++)
                    if (i % 2 == 0)
                        [evenArray addObject:[fullArray objectAtIndex:i]];
                    else
                        [oddArray addObject:[fullArray objectAtIndex:i]];
                
                EpiInfoCodesField *lv = [[EpiInfoCodesField alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:oddArray];
                [lv setTextColumnValues:evenArray];
                [formCanvas addSubview:lv];
                contentSizeHeight += 160;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"19"])
            {
                LegalValues *lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]]];
                [formCanvas addSubview:lv];
                contentSizeHeight += 160;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"14"])
            {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 60, 60)];
                [iv setImage:[UIImage imageNamed:@"PhoneRH"]];
                [formCanvas addSubview:iv];
                contentSizeHeight += 60;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"12"])
            {
                NSString *list = [attributeDict objectForKey:@"List"];
                int pipes = (int)[list rangeOfString:@"||"].location;
                NSString *valuesList = [list substringToIndex:pipes];
                LegalValues *lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[NSMutableArray arrayWithArray:[valuesList componentsSeparatedByString:@","]]];
                [formCanvas addSubview:lv];
                contentSizeHeight += 160;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"25"])
            {
                EpiInfoUniqueIDField *tf = [[EpiInfoUniqueIDField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 280, 40)];
                [tf setBorderStyle:UITextBorderStyleRoundedRect];
                [formCanvas addSubview:tf];
                [tf setEnabled:NO];
                contentSizeHeight += 40.0;
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"21"])
            {
                contentSizeHeight -= 25.0;
            }
            else
            {
                NSLog(@"%@: %@", [attributeDict objectForKey:@"FieldTypeId"], [attributeDict objectForKey:@"Name"]);
            }
            contentSizeHeight += 60.0;
        }
    }
    
    for (id key in attributeDict)
    {
        if ([key isEqualToString:@"Name"] || [key isEqualToString:@"PromptText"] || [key isEqualToString:@"FieldTypeId"])
        {
            dataText = [dataText stringByAppendingString:[NSString stringWithFormat:@"\n\t\t%@ = %@", key, [attributeDict objectForKey:key]]];
        }
    }
}

- (void)removeFromSuperview
{
    [self.fakeNavBar removeFromSuperview];
    [super removeFromSuperview];
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
