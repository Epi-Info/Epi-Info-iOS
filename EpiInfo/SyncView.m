//
//  SyncView.m
//  EpiInfo
//
//  Created by John Copeland on 3/20/19.
//

#import "SyncView.h"

@implementation SyncView
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
        [self setBackgroundColor:[UIColor whiteColor]];
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
        [saveBarButton setAccessibilityLabel:@"Continue importing the data."];
        [saveBarButton setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [uini setRightBarButtonItem:xBarButton];
        [uini setLeftBarButtonItem:saveBarButton];
        [uinb setItems:[NSArray arrayWithObject:uini]];
        [self.fakeNavBar addSubview:uinb];
        
        UILabel *pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 150.0, 40, 280, 28)];
        [pickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [pickerLabel setText:@"Select a data destination:"];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:pickerLabel];
        
        lvSelected = [[UITextField alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]] && [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] error:nil].count > 0)
        {
            int selectedindex = 0;
            NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] error:nil];
            NSMutableArray *pickerFiles = [[NSMutableArray alloc] init];
            [pickerFiles addObject:@""];
            int count = 0;
            for (id i in files)
            {
                count++;
                [pickerFiles addObject:[(NSString *)i substringToIndex:[(NSString *)i length] - 4]];
            }
            lv = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 150.0, 68, 300, 180) AndListOfValues:pickerFiles AndTextFieldToUpdate:lvSelected];
            [lv.picker selectRow:selectedindex inComponent:0 animated:YES];
            [lv setTag:1957];
            [self addSubview:lv];
            
            UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(lv.frame.origin.x, lv.frame.origin.y + lv.frame.size.height, 280, 28)];
            [passwordLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [passwordLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [passwordLabel setText:@"Password:"];
            [passwordLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:passwordLabel];
            
            passwordField = [[UITextField alloc] initWithFrame:CGRectMake(passwordLabel.frame.origin.x, passwordLabel.frame.origin.y + passwordLabel.frame.size.height, 280, 40)];
            [passwordField setDelegate:self];
            [passwordField setBorderStyle:UITextBorderStyleRoundedRect];
            [passwordField setReturnKeyType:UIReturnKeyDone];
            [passwordField setSecureTextEntry:YES];
            [self addSubview:passwordField];
        }
        else
            [pickerLabel setText:@"No forms found on this device."];
    }
    return self;
}

- (BOOL)decryptSyncFile
{
    NSString *encryptedString0 = [NSString stringWithContentsOfURL:self.url encoding:NSUTF8StringEncoding error:nil];
    if ([[encryptedString0 substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"APPLE"])
    {
        NSString *encryptedString = [NSString stringWithString:[encryptedString0 substringFromIndex:5]];
        NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:encryptedString options:NSDataBase64EncodingEndLineWithCarriageReturn];
        CCCryptorStatus ccStatus = kCCSuccess;
        CCCryptorRef thisEncipher = NULL;
        NSData *cipherOrPlainText = nil;
        uint8_t *bufferPtr = NULL;
        size_t bufferPtrSize = 0;
        size_t remainingBytes = 0;
        size_t movedBytes = 0;
        size_t plainTextBufferSize = 0;
        size_t totalBytesWritten = 0;
        uint8_t *ptr;
        
        NSString *password = [NSString stringWithString:[passwordField text]];
        float passwordLength = (float)password.length;
        float sixteens = 16.0 / passwordLength;
        if (sixteens > 1.0)
            for (int i = 0; i < (int)sixteens; i++)
                password = [password stringByAppendingString:password];
        password = [password substringToIndex:16];
        
        ccStatus = CCCryptorCreate(kCCDecrypt,
                                   kCCAlgorithmAES128,
                                   kCCOptionPKCS7Padding, // 0x0000 or kCCOptionPKCS7Padding
                                   (const void *)[password dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                   [password dataUsingEncoding:NSUTF8StringEncoding].length,
                                   (const void *)[@"0000000000000000" dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                   &thisEncipher
                                   );
        plainTextBufferSize = [encryptedData length];
        bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
        bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        ptr = bufferPtr;
        remainingBytes = bufferPtrSize;
        ccStatus = CCCryptorUpdate(thisEncipher, (const void *) [encryptedData bytes], plainTextBufferSize, ptr, remainingBytes, &movedBytes);
        ptr += movedBytes;
        remainingBytes -= movedBytes;
        totalBytesWritten += movedBytes;
        ccStatus = CCCryptorFinal(thisEncipher, ptr, remainingBytes, &movedBytes);
        totalBytesWritten += movedBytes;
        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
        CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
        if(bufferPtr) free(bufferPtr);
        dataText = [[NSString alloc] initWithData:cipherOrPlainText encoding:NSUTF8StringEncoding];
        if (!dataText)
            return NO;
    }
    return YES;
}

- (BOOL)updateAppendData
{
    NSLog(@"%@", dataText);
    arrayOfGUIDs = [[NSMutableArray alloc] init];
    arrayOfColumns = [[NSMutableArray alloc] init];
    arrayOfValues = [[NSMutableArray alloc] init];
    doingResponseDetail = NO;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[dataText dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
    BOOL rc = [parser parse];
    return rc;
}

- (void)saveTheForm
{
    if ([[passwordField text] length] == 0 || [[lvSelected text] length] == 0)
        return;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        BOOL rc = [self decryptSyncFile];
        if (rc)
            rc = [self updateAppendData];
        [self removeFromSuperview];
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

- (void)removeFromSuperview
{
    [self.fakeNavBar removeFromSuperview];
    [super removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    if ([elementName isEqualToString:@"SurveyResponse"])
    {
        NSString *guidString = [attributeDict objectForKey:@"SurveyResponseID"];
        [arrayOfGUIDs addObject:guidString];
    }
    else if ([elementName isEqualToString:@"ResponseDetail"])
    {
        doingResponseDetail = YES;
        NSString *columnName = [attributeDict objectForKey:@"QuestionName"];
        if (![arrayOfColumns containsObject:columnName])
            [arrayOfColumns addObject:columnName];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!doingResponseDetail)
        return;
    [arrayOfValues addObject:string];
    doingResponseDetail = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
