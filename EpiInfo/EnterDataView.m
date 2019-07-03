//
//  EnterDataView.m
//  EpiInfo
//
//  Created by John Copeland on 12/19/13.
//

#import "EnterDataView.h"
//#import "QSEpiInfoService.h"
#import "DataEntryViewController.h"
#import "ChildFormFieldAssignments.h"
#import "ElementPairsCheck.h"
#import "ElementsModel.h"
#import "DialogModel.h"
#import "ConditionsModel.h"
#import "AssignModel.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "AssignStatementParser.h"
#import <PEGKit/PEGKit.h>
@import BoxContentSDK;


#pragma mark * Private Interface


@interface EnterDataView ()

// Private properties
//@property (strong, nonatomic)   QSEpiInfoService   *epiinfoService;
@property (nonatomic)           BOOL            useRefreshControl;

@end


#pragma mark * Implementation


@implementation EnterDataView
@synthesize url = _url;
//@synthesize epiinfoService = _epiinfoService;
@synthesize locationManager = _locationManager;
@synthesize latitudeField = _latitudeField;
@synthesize longitudeField = _longitudeField;
@synthesize nameOfTheForm = _nameOfTheForm;
@synthesize dictionaryOfFields = _dictionaryOfFields;
@synthesize dictionaryOfCommentLegals = _dictionaryOfCommentLegals;
@synthesize fieldsAndStringValues = _fieldsAndStringValues;
@synthesize skipThisPage = _skipThisPage;
@synthesize dialogArray;
@synthesize elmArray;
//@synthesize elementsArray;
@synthesize elementListArray;
//@synthesize conditionsArray;

- (void)setNewRecordGUID:(NSString *)guid
{
    newRecordGUID = guid;
}

- (void)setTableBeingUpdated:(NSString *)tbu
{
    tableBeingUpdated = tbu;
}

- (NSString *)createTableStatement
{
    return createTableStatement;
}

- (void)setRecordUIDForUpdate:(NSString *)uid
{
    recordUIDForUpdate = uid;
    guidBeingUpdated = uid;
}

- (NSDictionary *)dictionaryOfPages
{
    return dictionaryOfPages;
}
- (NSMutableDictionary *)mutableDictionaryOfPages
{
    return dictionaryOfPages;
}
- (void)setDictionaryOfPagesObject:(id)object forKey:(id<NSCopying>)key
{
    [dictionaryOfPages setObject:object forKey:key];
}

- (void)setRelateButtonName:(NSString *)rbn
{
    relateButtonName = rbn;
}

- (void)setParentEnterDataView:(EnterDataView *)parentEDV
{
    parentEnterDataView = parentEDV;
}
- (EnterDataView *)parentEnterDataView
{
    return (EnterDataView *)parentEnterDataView;
}

- (NSArray *)arrayOfGroups
{
    if (arrayOfGroups)
        return [NSArray arrayWithArray:arrayOfGroups];
    return nil;
}

- (NSDictionary *)dictionaryOfGroupsAndLists
{
    if (dictionaryOfGroupsAndLists)
        return [NSDictionary dictionaryWithDictionary:dictionaryOfGroupsAndLists];
    return nil;
}

- (void)setParentRecordGUID:(NSString *)prguid
{
    parentRecordGUID = prguid;
    
    int lengthOfCreateTableStatement = (int)[createTableStatement length];
    createTableStatement = [[createTableStatement substringToIndex:lengthOfCreateTableStatement - 1] stringByAppendingString:@",\nFKEY text)"];
}
- (NSString *)parentRecordGUID
{
    return parentRecordGUID;
}

- (NSString *)guidToSendToChild
{
    if (guidBeingUpdated)
        return guidBeingUpdated;
    else if (newRecordGUID)
        return newRecordGUID;
    else return @"";
}

- (void)setPageToDisplay:(int)pageNumber
{
    pageToDisplay = pageNumber;
}

- (BOOL)getIsFirstPage
{
    return isFirstPage;
}
-(BOOL)getIsLastPage
{
    return isLastPage;
}

- (void)setDictionaryOfPages:(NSMutableDictionary *)dop
{
    dictionaryOfPages = dop;
    [dictionaryOfPages setObject:self forKey:[NSString stringWithFormat:@"Page%d", pageToDisplay]];
}

- (void)setConditionsArray:(NSMutableArray *)conditionsArrayNew
{
    conditionsArray = conditionsArrayNew;
}

- (void)setElementsArray:(NSMutableArray *)elementsArrayNew
{
    elementsArray = elementsArrayNew;
}
- (void)setFirstEdit:(BOOL)firstEditNew
{
    firstEdit = firstEditNew;
}
- (UIView *)formCanvas
{
    return formCanvas;
}

- (void)setGuidBeingUpdated:(NSString *)gbu
{
    guidBeingUpdated = gbu;
    recordUIDForUpdate = gbu;
}

- (void)setPopulateInstructionCameFromLineList:(BOOL)yesNo
{
    populateInstructionCameFromLineList = yesNo;
}

- (void)setPageBeingDisplayed:(NSNumber *)page
{
    pageBeingDisplayed = page;
}
- (NSNumber *)pageBeingDisplayed
{
    return pageBeingDisplayed;
}

- (void)setMyOrangeBanner:(UIView *)mob
{
    myOrangeBanner = mob;
}
- (UIView *)myOrangeBanner
{
    return myOrangeBanner;
}

- (void)setAssignArray:(NSMutableArray *)aa
{
    assignArray = aa;
}

- (NSString *)formCheckCodeString
{
    return formCheckCodeString;
}

- (NSString *)pageName
{
    return pageName;
}

- (void)recordUIDForUpdateLogThreadMethod
{
    while (YES)
    {
        sleep(4);
        NSLog(@"recordUIDForUpdate = %@", recordUIDForUpdate);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Create the todoService - this creates the Mobile Service client inside the wrapped service
        //    [self setEpiinfoService:[QSEpiInfoService defaultService]];
        seenFirstGeocodeField = NO;
        legalValuesDictionaryForRVC = [[NSMutableDictionary alloc] init];
        self.dictionaryOfFields = [[DictionaryOfFields alloc] init];
        self.dictionaryOfCommentLegals = [[NSMutableDictionary alloc] init];
//        self.fieldsAndStringValues = [[FieldsAndStringValues alloc] init];
        [self.dictionaryOfFields setFasv:self.fieldsAndStringValues];
        newRecordGUID = CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
        
        //      NSThread *guidThread = [[NSThread alloc] initWithTarget:self selector:@selector(logTheGUIDS) object:nil];
        //      [guidThread start];
        [self setBounces:NO];
        counter = 1;
        
        [self setSkipThisPage:NO];
    }
    return self;
}

- (void)logTheGUIDS
{
    while (YES)
    {
        NSLog(@"newRecordGUID = %@", newRecordGUID);
        NSLog(@"guidBeingUpdated = %@", guidBeingUpdated);
        sleep(5);
        if (!self)
            break;
    }
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        NSString *xmlString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        if (![xmlString containsString:@"ActualPageNumber"])
        {
            xmlString = [self fixPageIdValues:[NSMutableString stringWithString:xmlString]];
            [xmlString writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        
        pageToDisplay = page;
        [self setNameOfTheForm:notf];
        [self setUrl:url];
        
        dataText = @"";
        formName = @"";
        contentSizeHeight = 32.0;
        
        legalValuesDictionary = [[NSMutableDictionary alloc] init];
        
        [self setContentSize:CGSizeMake(320, 506)];
        
        formCanvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [formCanvas setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:formCanvas];
        [self setScrollEnabled:YES];
        
        xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:self.url];
        [xmlParser setDelegate:self];
        [xmlParser setShouldResolveExternalEntities:YES];
        
        xmlParser1 = [[NSXMLParser alloc] initWithContentsOfURL:self.url];
        [xmlParser1 setDelegate:self];
        [xmlParser1 setShouldResolveExternalEntities:YES];
        
        keywordsArray = [[NSMutableArray alloc]initWithObjects:@"enable",@"disable",@"highlight",@"unhighlight",@"set-required",@"set-not-required",@"assign",@"autosearch",@"call",@"clear",@"define",@"dialog",@"execute",@"geocode",@"goto",@"hide",@"unhide",@"if",@"newrecord",@"quit",@"gotoform", nil];
        firstParse = YES;
        if (!((DataEntryViewController *)[self rootViewController]).arrayOfFieldsAllPages)
        {
            ((DataEntryViewController *)[self rootViewController]).arrayOfFieldsAllPages = [[NSMutableArray alloc] init];
        }
        BOOL success = [xmlParser parse];
        
        if (success)
        {
            if (legalValuesArray)
            {
                [legalValuesDictionary setObject:legalValuesArray forKey:lastLegalValuesKey];
            }
        }
        
        firstParse = NO;
        beginColumList = NO;
        success = [xmlParser1 parse];
        
//        if (isLastPage)
            createTableStatement = [createTableStatement stringByAppendingString:@")"];
        
        UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 + 38.0, contentSizeHeight, 120, 40)];
        [submitButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [submitButton.layer setCornerRadius:4.0];
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [submitButton setImage:[UIImage imageNamed:@"SubmitButton.png"] forState:UIControlStateNormal];
        [submitButton.layer setMasksToBounds:YES];
        [submitButton.layer setCornerRadius:4.0];
        [submitButton addTarget:self action:@selector(confirmSubmitOrClear:) forControlEvents:UIControlEventTouchUpInside];
        [submitButton setTag:1];
        // New code for separating pages
        if (!isLastPage)
        {
            [submitButton setEnabled:NO];
            [submitButton setImage:[UIImage imageNamed:@"SwipeButtonPurple.png"] forState:UIControlStateNormal];
            [submitButton setAccessibilityLabel:@"Swipe left or right to change page."];
        }
        //    [self addSubview:submitButton];
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 158.0, contentSizeHeight, 120, 40)];
        [clearButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [clearButton.layer setCornerRadius:4.0];
        [clearButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"ClearButton.png"] forState:UIControlStateNormal];
        [clearButton.layer setMasksToBounds:YES];
        [clearButton.layer setCornerRadius:4.0];
        [clearButton addTarget:self action:@selector(confirmSubmitOrClear:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton setTag:9];
        //    [self addSubview:clearButton];
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 36.0, contentSizeHeight, 72, 40)];
        [deleteButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [deleteButton.layer setCornerRadius:4.0];
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"DeleteButton.png"] forState:UIControlStateNormal];
        [deleteButton.layer setMasksToBounds:YES];
        [deleteButton.layer setCornerRadius:4.0];
        [deleteButton addTarget:self action:@selector(confirmSubmitOrClear:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setTag:7];
        [deleteButton setHidden:YES];
        //    [self addSubview:deleteButton];
        contentSizeHeight += 60.0;
        
        // New code for separating pages
        previousPageButton = [[UIButton alloc] initWithFrame:CGRectMake(clearButton.frame.origin.x - 44, clearButton.frame.origin.y, 40, 40)];
        [previousPageButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [previousPageButton.layer setCornerRadius:4.0];
        [previousPageButton setTitle:@"Previous Page" forState:UIControlStateNormal];
        [previousPageButton setImage:[UIImage imageNamed:@"PreviousPage.png"] forState:UIControlStateNormal];
        [previousPageButton.layer setMasksToBounds:YES];
        [previousPageButton.layer setCornerRadius:4.0];
        [previousPageButton addTarget:self action:@selector(previousOrNextPageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [previousPageButton setTag:pageToDisplay - 1];
        [previousPageButton setHidden:YES];
        [self addSubview:previousPageButton];
        if (isFirstPage)
        {
            [previousPageButton setEnabled:NO];
        }
        else
        {
            [previousPageButton setEnabled:YES];
        }
        nextPageButton = [[UIButton alloc] initWithFrame:CGRectMake(submitButton.frame.origin.x + 124, submitButton.frame.origin.y, 40, 40)];
        [nextPageButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [nextPageButton.layer setCornerRadius:4.0];
        [nextPageButton setTitle:@"Next Page" forState:UIControlStateNormal];
        [nextPageButton setImage:[UIImage imageNamed:@"NextPage.png"] forState:UIControlStateNormal];
        [nextPageButton.layer setMasksToBounds:YES];
        [nextPageButton.layer setCornerRadius:4.0];
        [nextPageButton addTarget:self action:@selector(previousOrNextPageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [nextPageButton setTag:pageToDisplay + 1];
        [nextPageButton setHidden:YES];
        [self addSubview:nextPageButton];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [previousPageButton setFrame:CGRectMake(clearButton.frame.origin.x, clearButton.frame.origin.y + 42, 40, 40)];
            [nextPageButton setFrame:CGRectMake(submitButton.frame.origin.x + submitButton.frame.size.width - 40, submitButton.frame.origin.y + 42, 40, 40)];
            //        contentSizeHeight += 42;
        }
        if (isLastPage)
        {
            [nextPageButton setEnabled:NO];
        }
        else
        {
            [nextPageButton setEnabled:YES];
        }
        
        if (contentSizeHeight > 506)
        {
            [formCanvas setFrame:CGRectMake(0, 0, frame.size.width, contentSizeHeight)];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                contentSizeHeight += 264.0;
                if ([self.pageName intValue] > 1)
                    contentSizeHeight -= 228.0;
            }
            
            [self setContentSize:CGSizeMake(frame.size.width, contentSizeHeight)];
        }
        
        UIButton *resignAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, formCanvas.frame.size.width / 2.0, formCanvas.frame.size.height)];
        [resignAllButton setBackgroundColor:[UIColor clearColor]];
        [resignAllButton addTarget:self action:@selector(resignAll) forControlEvents:UIControlEventTouchUpInside];
        [resignAllButton addTarget:self action:@selector(userSwipedToTheRight) forControlEvents:UIControlEventTouchDownRepeat];
        //    [resignAllButton addTarget:self action:@selector(userSwipedToTheRight) forControlEvents:UISwipeGestureRecognizerDirectionRight];
        UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipedToTheLeft)];
        [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [leftRecognizer setNumberOfTouchesRequired:1];
        [resignAllButton addGestureRecognizer:leftRecognizer];
        UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipedToTheRight)];
        [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [rightRecognizer setNumberOfTouchesRequired:1];
        [resignAllButton addGestureRecognizer:rightRecognizer];
        //    [resignAllButton addTarget:self action:@selector(userSwipedToTheLeft) forControlEvents:UISwipeGestureRecognizerDirectionLeft];
        [formCanvas addSubview:resignAllButton];
        [formCanvas sendSubviewToBack:resignAllButton];
        
        UIButton *resignAllButtonRight = [[UIButton alloc] initWithFrame:CGRectMake(formCanvas.frame.size.width / 2.0, 0, formCanvas.frame.size.width / 2.0, formCanvas.frame.size.height)];
        [resignAllButtonRight setBackgroundColor:[UIColor clearColor]];
        [resignAllButtonRight addTarget:self action:@selector(resignAll) forControlEvents:UIControlEventTouchUpInside];
        [resignAllButtonRight addTarget:self action:@selector(userSwipedToTheLeft) forControlEvents:UIControlEventTouchDownRepeat];
        //    [resignAllButton addTarget:self action:@selector(userSwipedToTheRight) forControlEvents:UISwipeGestureRecognizerDirectionRight];
        UISwipeGestureRecognizer *leftRecognizerForRightButton = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipedToTheLeft)];
        [leftRecognizerForRightButton setDirection:UISwipeGestureRecognizerDirectionLeft];
        [leftRecognizerForRightButton setNumberOfTouchesRequired:1];
        [resignAllButtonRight addGestureRecognizer:leftRecognizerForRightButton];
        UISwipeGestureRecognizer *rightRecognizerForRightButton = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipedToTheRight)];
        [rightRecognizerForRightButton setDirection:UISwipeGestureRecognizerDirectionRight];
        [rightRecognizerForRightButton setNumberOfTouchesRequired:1];
        [resignAllButtonRight addGestureRecognizer:rightRecognizerForRightButton];
        //    [resignAllButton addTarget:self action:@selector(userSwipedToTheLeft) forControlEvents:UISwipeGestureRecognizerDirectionLeft];
        [formCanvas addSubview:resignAllButtonRight];
        [formCanvas sendSubviewToBack:resignAllButtonRight];
        
        UILabel *disclaimer = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
        [disclaimer setBackgroundColor:[UIColor colorWithRed:0/255.0 green:128/255.0 blue:128/255.0 alpha:1.0]];
        [disclaimer setTextColor:[UIColor whiteColor]];
        [disclaimer setNumberOfLines:0];
        [disclaimer setLineBreakMode:NSLineBreakByWordWrapping];
        [disclaimer.layer setCornerRadius:4.0];
        [disclaimer setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [disclaimer setText:@"This feature is still under development. Touch this message to dismiss the form and return to the previous screen."];
        UIButton *dismissFormButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
        [dismissFormButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
        [dismissFormButton setBackgroundColor:[UIColor clearColor]];
        //        [self addSubview:disclaimer];
        //        [self addSubview:dismissFormButton];
        
        //        [formCanvas setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhoneDataEntryBackground.png"]]];
        //    [formCanvas setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1.0]];
        [formCanvas setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    }
    
    return self;
}

// New code for separating pages
- (void)checkcodeSwipedToTheLeft
{
    if ([nextPageButton isEnabled])
    {
        [self previousOrNextPageButtonPressed:nextPageButton isAdvancing:YES];
        
        pageName = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"pageName"];
 //       NSLog(@"%@000000",pageName);
    }
}
- (void)checkcodeSwipedToTheRight
{
    if ([previousPageButton isEnabled])
    {
        [self previousOrNextPageButtonPressed:previousPageButton isAdvancing:NO];
        pageName = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"pageName"];
//        NSLog(@"%@1111111",pageName);
        [self performSelector:@selector(onLoadEleCheck) withObject:nil afterDelay:0.3];
        
        //[self onLoadEleCheck];
    }
}
- (void)userSwipedToTheLeft
{
    if ([nextPageButton isEnabled])
    {
        [self previousOrNextPageButtonPressed:nextPageButton isAdvancing:YES];

        pageName = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"pageName"];
//        NSLog(@"%@000000",pageName);
        
        
        DataEntryViewController *devc = (DataEntryViewController *)self.rootViewController;
        [devc advancePagedots];
    }
}
- (void)userSwipedToTheRight
{
    if ([previousPageButton isEnabled])
    {
        [self previousOrNextPageButtonPressed:previousPageButton isAdvancing:NO];
        pageName = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"pageName"];
//        NSLog(@"%@1111111",pageName);
        [self performSelector:@selector(onLoadEleCheck) withObject:nil afterDelay:0.3];
        
        //[self onLoadEleCheck];
        
        
        DataEntryViewController *devc = (DataEntryViewController *)self.rootViewController;
        [devc retreatPagedots];

        EnterDataView *currentEDV;
        for (UIView *uiv in [self.rootViewController.view subviews])
        {
            if ([uiv isKindOfClass:[EnterDataView class]])
            {
                currentEDV = (EnterDataView *)uiv;
                break;
            }
        }
        if (currentEDV.skipThisPage)
        {
            [currentEDV setSkipThisPage:NO];
            [currentEDV userSwipedToTheRight];
        }
    }
}
- (void)previousOrNextPageButtonPressed:(UIButton *)sender isAdvancing:(BOOL)isAdvancing
{
    if (!dictionaryOfPages)
    {
        dictionaryOfPages = [[NSMutableDictionary alloc] init];
    }
    [dictionaryOfPages setObject:self forKey:[NSString stringWithFormat:@"Page%d", pageToDisplay]];
    if ([sender tag] < pageToDisplay)
    {
        [UIView transitionWithView:self.window
                          duration:0.4f
                           options:UIViewAnimationOptionTransitionNone
                        animations:^{
                        }
                        completion:^(BOOL finished){
                            [self removeFromSuperview];
                        }];
    }
    else
    {
        [UIView transitionWithView:self.window
                          duration:0.4f
                           options:UIViewAnimationOptionTransitionNone
                        animations:^{
                        }
                        completion:^(BOOL finished){
                            [self removeFromSuperview];
                        }];
    }
    [self resignAll];
    [self removeFromSuperview];
    [self setContentOffset:CGPointZero animated:NO];
    if ([dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]])
    {
        // This condition should always be met now that all pages are initialized at form load
        //
        [self.rootViewController.view addSubview:[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]]];
        [self.rootViewController.view bringSubviewToFront:[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]]];
        [[NSUserDefaults standardUserDefaults] setObject:[self myTextPageName] forKey:@"nameOfThePage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // Only execute page after check code when advancing page
        if (isAdvancing)
        {
            [self checkElements:pageName from:@"after" page:pageName];
            [self checkElements:self.myTextPageName from:@"after" page:self.myTextPageName];
        }
        // The next two lines seem to be redundant
//        [[NSUserDefaults standardUserDefaults] setObject:[(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]] myTextPageName] forKey:@"nameOfThePage"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Get the EnterDataView from the ViewController and use it to run these methods
        // Because a GOTO could make that page different from the one to which the user just swiped
        EnterDataView *currentEDV;
        for (UIView *uiv in [self.rootViewController.view subviews])
        {
            if ([uiv isKindOfClass:[EnterDataView class]])
            {
                currentEDV = (EnterDataView *)uiv;
                break;
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:[currentEDV myTextPageName] forKey:@"nameOfThePage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [currentEDV setGuidBeingUpdated:recordUIDForUpdate];
        [currentEDV onLoadEleCheck];
        if (isAdvancing)
        {
            [currentEDV checkElements:currentEDV.pageName from:@"before" page:pageName];
            [currentEDV checkElements:currentEDV.myTextPageName from:@"before" page:currentEDV.myTextPageName];
        }
        if ([currentEDV myOrangeBanner] == nil)
            [currentEDV setMyOrangeBanner:myOrangeBanner];
        [[NSUserDefaults standardUserDefaults] setObject:[currentEDV myTextPageName] forKey:@"nameOfThePage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Comment out the old dictionaryOfPages way
//        [(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]] setGuidBeingUpdated:recordUIDForUpdate];
//        [(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]] onLoadEleCheck];
//        [(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]] checkElements:pageName from:@"before" page:pageName];
//        if ([(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]] myOrangeBanner] == nil)
//            [(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]] setMyOrangeBanner:myOrangeBanner];
//        [[NSUserDefaults standardUserDefaults] setObject:[(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]] myTextPageName] forKey:@"nameOfThePage"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        EnterDataView *edv = [[EnterDataView alloc] initWithFrame:self.frame AndURL:self.url AndRootViewController:self.rootViewController AndNameOfTheForm:self.nameOfTheForm AndPageToDisplay:(int)[sender tag] condArray:conditionsArray eleArray:elementListArray firstEdit:firstEdit elmAr:elmArray checkEleArr:elementsArray assignArray:assignArray ifsArray:ifsArray];
        [edv setDictionaryOfPages:dictionaryOfPages];
//        for (id key in edv.fieldsAndStringValues.nsmd)
//            [self.fieldsAndStringValues setObject:[edv.fieldsAndStringValues objectForKey:key] forKey:key];
//        [edv setFieldsAndStringValues:self.fieldsAndStringValues];
        [edv setGuidBeingUpdated:guidBeingUpdated];
        [edv setNewRecordGUID:newRecordGUID];
        [edv setMyOrangeBanner:myOrangeBanner];
        //        [edv setConditionsArray:conditionsArray];
        //        [edv setElementsArray:elementsArray];
        //        [edv setFirstEdit:firstEdit];
        
        if (guidBeingUpdated)
        {
            [edv populateFieldsWithRecord:@[tableBeingUpdated, guidBeingUpdated]];
        }
        if (parentRecordGUID)
        {
            [edv setParentRecordGUID:parentRecordGUID];
            [edv setParentEnterDataView:(EnterDataView *)parentEnterDataView];
            [edv setRelateButtonName:relateButtonName];
        }
        [self.rootViewController.view addSubview:edv];
        [self.rootViewController.view bringSubviewToFront:edv];
//        [edv checkElements:[NSString stringWithFormat:@"%d", (int)[sender tag]] from:@"before" page:[NSString stringWithFormat:@"%d", (int)[sender tag]]];
    }
    for (UIView *v in [self.rootViewController.view subviews])
    {
        if ([[v backgroundColor] isEqual:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:0.95]])
        {
            [self.rootViewController.view bringSubviewToFront:v];
            for (UIView *l in [v subviews])
            {
                if ([l isKindOfClass:[UILabel class]])
                {
                    if ([[(UILabel *)l text] containsString:formName])
                    {
                        [(UILabel *)l setText:[NSString stringWithFormat:@"%@, page %d of %lu", formName, (int)[sender tag], (unsigned long)[self pagesArray].count]];
                        pageName = [NSString stringWithFormat:@"%d",(int)[sender tag]];
//                        [[NSUserDefaults standardUserDefaults] setObject:pageName forKey:@"pageName"];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
//                        NSLog(@"SETSATYA %@",pageName);
//                        NSLog(@"page name is %@ checkcode",pageName);
                        
                        
                        
                        
                        //                        }
                        [(UILabel *)l setText:[NSString stringWithFormat:@"%@", formName]];
                        [(UILabel *)l setText:[NSString stringWithFormat:@"%@", formName]];
                    }
                }
            }
        }
        else if ([v isKindOfClass:[UINavigationBar class]])
        {
            [self.rootViewController.view bringSubviewToFront:v];
        }
    }
    if (parentEnterDataView)
        [ChildFormFieldAssignments parseForAssignStatements:[self formCheckCodeString] parentForm:(EnterDataView *)parentEnterDataView childForm:self relateButtonName:relateButtonName];
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page AndParentForm:(EnterDataView *)parentForm
{
    [self setParentEnterDataView:parentForm];
    self = [self initWithFrame:frame AndURL:url AndRootViewController:rvc AndNameOfTheForm:notf AndPageToDisplay:page];
    return  self;
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page
{
    self.fieldsAndStringValues = [(DataEntryViewController *)rvc fieldsAndStringValues];
    [self setRootViewController:rvc];
    self = [self initWithFrame:frame AndURL:url AndNameOfTheForm:(NSString *)notf AndPageToDisplay:page];
    if (self)
    {
        //Conditionally initialize or copy
//        if (page == 1)
//        {
//            self.fieldsAndStringValues = [[FieldsAndStringValues alloc] init];
//            [(DataEntryViewController *)rvc setFieldsAndStringValues:self.fieldsAndStringValues];
//        }
//        else
//            [self setFieldsAndStringValues:[(DataEntryViewController *)rvc fieldsAndStringValues]];
        pageName = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"pageName"];
        [[NSUserDefaults standardUserDefaults] setObject:notf forKey:@"sudFormName"];

        [self setRootViewController:rvc];
        if ([[(DataEntryViewController *)self.rootViewController backgroundImage] tag] == 4)
        {
            [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height + 80.0)];
        }
        [(DataEntryViewController *)self.rootViewController setLegalValuesDictionary:legalValuesDictionaryForRVC];
        // Hide the Back button on the nav controller
        //        [self.rootViewController.navigationItem setHidesBackButton:YES animated:YES];
        [self.rootViewController.navigationItem.leftBarButtonItem setEnabled:NO];
        
        hasAFirstResponder = NO;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"]])
        {
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase/Clouds.db"];
            
            //Create the new table if necessary
            int tableAlreadyExists = 0;
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = @"select count(name) as n from sqlite_master where name = 'Clouds'";
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                        tableAlreadyExists = sqlite3_column_int(statement, 0);
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
            if (tableAlreadyExists < 1)
            {
                NSLog(@"Failed to find Clouds table");
                return self;
            }
            else
            {
                tableAlreadyExists = 0;
                if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                {
                    NSString *selStmt = [NSString stringWithFormat:@"select count(*) as n from Clouds where FormName like '%%%@'", self.formName];
                    const char *query_stmt = [selStmt UTF8String];
                    sqlite3_stmt *statement;
                    if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        if (sqlite3_step(statement) == SQLITE_ROW)
                            tableAlreadyExists = sqlite3_column_int(statement, 0);
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(epiinfoDB);
                if (tableAlreadyExists < 1)
                {
                    if (!dictionaryOfPages)
                    {
                        dictionaryOfPages = [[NSMutableDictionary alloc] init];
                    }
                    [dictionaryOfPages setObject:self forKey:[NSString stringWithFormat:@"Page%d", pageToDisplay]];
                    return self;
                }
                else
                {
                    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                    {
                        NSString *selStmt = [NSString stringWithFormat:@"select * from Clouds where FormName = '%@'", self.formName];
                        const char *query_stmt = [selStmt UTF8String];
                        sqlite3_stmt *statement;
                        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            if (sqlite3_step(statement) == SQLITE_ROW)
                            {
                                if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)] isEqualToString:@"MSAzure"])
                                {
//                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Getting Azure credentials (line 784)\n", [NSDate date]]];
//                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: self.formName = %@\n", [NSDate date], self.formName]];
//                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Queried values = %s, %s, %s, %s\n", [NSDate date], sqlite3_column_text(statement, 0), sqlite3_column_text(statement, 1), sqlite3_column_text(statement, 2), sqlite3_column_text(statement, 3)]];
                                    self.client = [MSClient clientWithApplicationURLString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]];
                                    self.cloudService = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)];
                                    self.cloudKey = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)];
                                    //                  self.epiinfoService = [[QSEpiInfoService alloc] initWithURL:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)] AndKey:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]];
                                    //                  [self.epiinfoService setApplicationURL:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]];
                                    //                  [self.epiinfoService setApplicationKey:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]];
                                    //                  [self.epiinfoService setTableName:formName];
                                }
                                else
                                {
                                    //                  [self.epiinfoService setApplicationURL:nil];
                                    //                  [self.epiinfoService setApplicationKey:nil];
                                    //                  self.epiinfoService = [[QSEpiInfoService alloc] initWithURL:nil AndKey:nil];
                                    //                  [self.epiinfoService setTableName:formName];
                                }
                            }
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(epiinfoDB);
                }
            }
        }
    }
    // New code for separating pages
    if (!dictionaryOfPages)
    {
        dictionaryOfPages = [[NSMutableDictionary alloc] init];
    }
    [dictionaryOfPages setObject:self forKey:[NSString stringWithFormat:@"Page%d", pageToDisplay]];
    
    [self setLabelReq];
    /*CHECK for on load dialogs*/
    if (firstEdit == FALSE)
    {
        pageName = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"pageName"];
        
        firstEdit = TRUE;
//        NSLog(@"111%@ %d",pageName,firstEdit);
        
        [self checkElements:pageName from:@"before" page:pageName];
//        NSLog(@"page name is %@ checkcode first",pageName);
        
        
    }
    [self checkDialogs:[pageName lowercaseString] Tag:1 type:1 from:@"before" from:pageName];

    //    [self registerForKeyboardNotifications];
    
    return self;
    
}
- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page condArray:(NSMutableArray *)newCondArray eleArray:(NSMutableArray *)newEleArray firstEdit:(BOOL)newFirst elmAr:(NSMutableArray *)newElm checkEleArr:(NSMutableArray *)newCheckEleArr assignArray:(NSMutableArray *)newAssignArray ifsArray:(NSMutableArray *)newIfsArray
{
    conditionsArray = newCondArray;
    elementListArray = newEleArray;
    firstEdit = newFirst;
    elmArray = newElm;
    elementsArray = newCheckEleArr;
    assignArray = newAssignArray;
    ifsArray = newIfsArray;
    
    self.fieldsAndStringValues = [(DataEntryViewController *)rvc fieldsAndStringValues];
    self = [self initWithFrame:frame AndURL:url AndNameOfTheForm:(NSString *)notf AndPageToDisplay:page];
    if (self)
    {
        //Conditionally initialize or copy
//        if (page == 1)
//        {
//            self.fieldsAndStringValues = [[FieldsAndStringValues alloc] init];
//            [(DataEntryViewController *)rvc setFieldsAndStringValues:self.fieldsAndStringValues];
//        }
//        else
//            [self setFieldsAndStringValues:[(DataEntryViewController *)rvc fieldsAndStringValues]];
//        [self.dictionaryOfFields setFasv:self.fieldsAndStringValues];
        
        [self setRootViewController:rvc];
        if ([[(DataEntryViewController *)self.rootViewController backgroundImage] tag] == 4)
        {
            [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height + 80.0)];
        }
        [(DataEntryViewController *)self.rootViewController setLegalValuesDictionary:legalValuesDictionaryForRVC];
        // Hide the Back button on the nav controller
        //        [self.rootViewController.navigationItem setHidesBackButton:YES animated:YES];
        [self.rootViewController.navigationItem.leftBarButtonItem setEnabled:NO];
        
        hasAFirstResponder = NO;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"]])
        {
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase/Clouds.db"];
            
            //Create the new table if necessary
            int tableAlreadyExists = 0;
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = @"select count(name) as n from sqlite_master where name = 'Clouds'";
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                        tableAlreadyExists = sqlite3_column_int(statement, 0);
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
            if (tableAlreadyExists < 1)
            {
                NSLog(@"Failed to find Clouds table");
                return self;
            }
            else
            {
                tableAlreadyExists = 0;
                if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                {
                    NSString *selStmt = [NSString stringWithFormat:@"select count(*) as n from Clouds where FormName like '%%%@'", self.formName];
                    const char *query_stmt = [selStmt UTF8String];
                    sqlite3_stmt *statement;
                    if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        if (sqlite3_step(statement) == SQLITE_ROW)
                            tableAlreadyExists = sqlite3_column_int(statement, 0);
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(epiinfoDB);
                if (tableAlreadyExists < 1)
                    return self;
                else
                {
                    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                    {
                        NSString *selStmt = [NSString stringWithFormat:@"select * from Clouds where FormName = '%@'", self.formName];
                        const char *query_stmt = [selStmt UTF8String];
                        sqlite3_stmt *statement;
                        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            if (sqlite3_step(statement) == SQLITE_ROW)
                            {
                                if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)] isEqualToString:@"MSAzure"])
                                {
//                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Getting Azure credentials (line 932)\n", [NSDate date]]];
//                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: self.formName = %@\n", [NSDate date], self.formName]];
//                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Queried values = %s, %s, %s, %s\n", [NSDate date], sqlite3_column_text(statement, 0), sqlite3_column_text(statement, 1), sqlite3_column_text(statement, 2), sqlite3_column_text(statement, 3)]];
                                    self.client = [MSClient clientWithApplicationURLString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]];
                                    self.cloudService = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)];
                                    self.cloudKey = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)];
                                    //                  self.epiinfoService = [[QSEpiInfoService alloc] initWithURL:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)] AndKey:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]];
                                    //                  [self.epiinfoService setApplicationURL:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]];
                                    //                  [self.epiinfoService setApplicationKey:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]];
                                    //                  [self.epiinfoService setTableName:formName];
                                }
                                else
                                {
                                    //                  [self.epiinfoService setApplicationURL:nil];
                                    //                  [self.epiinfoService setApplicationKey:nil];
                                    //                  self.epiinfoService = [[QSEpiInfoService alloc] initWithURL:nil AndKey:nil];
                                    //                  [self.epiinfoService setTableName:formName];
                                }
                            }
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(epiinfoDB);
                }
            }
        }
    }
    // New code for separating pages
    if (!dictionaryOfPages)
    {
        dictionaryOfPages = [[NSMutableDictionary alloc] init];
    }
    [dictionaryOfPages setObject:self forKey:[NSString stringWithFormat:@"Page%d", pageToDisplay]];
    
    [self setLabelReq];
    /*CHECK for on load dialogs*/
    if (firstEdit == FALSE)
    {
        //NSLog(@"false");
        pageName = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"pageName"];
        
        [self checkDialogs:[pageName lowercaseString] Tag:1 type:1 from:@"before" from:pageName];
        firstEdit = TRUE;
//        NSLog(@"111%@",pageName);
        // for (NSString *ele in elmArray)
        //{
        [self checkElements:pageName from:@"before" page:pageName];
//        NSLog(@"page name is %@ checkcode",pageName);
        //}
        
        
    }
    else
    {
        pageName = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"pageName"];
        [self onLoadEleCheck];
        [self checkElements:pageName from:@"before" page:pageName];
        
        
    }
    //    [self registerForKeyboardNotifications];
    
    return self;
}

- (void)getMyLocation
{
    // Get coordinates
    if (!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //    [self.locationManager startUpdatingLocation];
    //    [self.locationManager startMonitoringSignificantLocationChanges];
    self.updateLocationThread = [[NSThread alloc] initWithTarget:self selector:@selector(updateMyLocation) object:nil];
    [self.updateLocationThread start];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    float lat = [(CLLocation *)[locations objectAtIndex:[locations count] - 1] coordinate].latitude;
    float lon = [(CLLocation *)[locations objectAtIndex:[locations count] - 1] coordinate].longitude;
    NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
    [nsnf setMaximumFractionDigits:6];
    
    for (NSString *thisEDVString in dictionaryOfPages)
    {
        EnterDataView *thisEDV = [dictionaryOfPages objectForKey:thisEDVString];
        for (UIView *v in [[thisEDV formCanvas] subviews])
            if ([v isKindOfClass:[NumberField class]])
            {
                if ([[(NumberField *)v columnName] isEqualToString:self.latitudeField])
                    [(NumberField *)v setText:[nsnf stringFromNumber:[NSNumber numberWithFloat:lat]]];
                if ([[(NumberField *)v columnName] isEqualToString:self.longitudeField])
                    [(NumberField *)v setText:[nsnf stringFromNumber:[NSNumber numberWithFloat:lon]]];
            }
    }
    [self.locationManager stopUpdatingLocation];
}

- (void)updateMyLocation
{
    // Get coordinates
    [self.locationManager requestWhenInUseAuthorization];
    while (YES)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        if ((geocodingCheckbox.value || [(Checkbox *)[(DataEntryViewController *)self.rootViewController geocodingCheckbox] value]) && [CLLocationManager locationServicesEnabled])
        {
            [self.locationManager startUpdatingLocation];
        }
        sleep(10);
    }
}

- (NSString *)formName
{
    return formName;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}

- (void)submitOrUpdateWithoutClearing
{
    if (guidBeingUpdated != nil && [guidBeingUpdated length] > 0)
        [self updateWithoutClearing];
    else
        [self submitWithoutClearing];
}

- (void)submitWithoutClearing
{
    guidBeingUpdated = nil;
    BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(self.superview.frame.size.width - 5.0, self.superview.frame.size.height - 5.0, 10, 10)];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setNumberOfLines:0];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [bv addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [bv addSubview:uiaiv];
    
    //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Yes" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [okButton.layer setMasksToBounds:YES];
    [okButton.layer setCornerRadius:4.0];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bv addSubview:okButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        //        if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
        //        {
        //            [[NSFileManager defaultManager] removeItemAtPath:databasePath error:nil];
        //        }
        
        NSString *insertStatement = [NSString stringWithFormat:@"\ninsert into %@(GlobalRecordID", formName];
        //        NSString *valuesClause = @" values(";
        // Switched from creating UID at submit time to load-form/clear-form time
        //    NSString *recordUUID = CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
        NSString *valuesClause = [NSString stringWithFormat:@" values('%@'", newRecordGUID];
        BOOL valuesClauseBegun = YES;
        if (parentRecordGUID)
        {
            insertStatement = [insertStatement stringByAppendingString:@",\nFKEY"];
            valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@",\n'%@'", parentRecordGUID]];
        }
        NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
        [azureDictionary setObject:newRecordGUID forKey:@"id"];
        for (id key in dictionaryOfPages)
        {
            EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
            for (UIView *v in [[tempedv formCanvas] subviews])
            {
                if ([v isKindOfClass:[Checkbox class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(Checkbox *)v columnName]];
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%d", [(Checkbox *)v value]]];
                    [azureDictionary setObject:[NSNumber numberWithBool:[(Checkbox *)v value]] forKey:[(Checkbox *)v columnName]];
                }
                else if ([v isKindOfClass:[YesNo class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(YesNo *)v columnName]];
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", [(YesNo *)v picked]]];
                    if ([[(YesNo *)v picked] length] == 1)
                        [azureDictionary setObject:[NSNumber numberWithInt:[[(YesNo *)v picked] intValue]] forKey:[(YesNo *)v columnName]];
                }
                else if ([v isKindOfClass:[LegalValuesEnter class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(LegalValuesEnter *)v columnName]];
                    if ([[(LegalValuesEnter *)v picked] isEqualToString:@"NULL"])
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [[(LegalValuesEnter *)v picked] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[NSString stringWithFormat:@"%d", (int)[[(LegalValuesEnter *)v picker] selectedRowInComponent:0]] forKey:[(LegalValuesEnter *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[NumberField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(NumberField *)v columnName]];
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", [(NumberField *)v value]]];
                    if (![[(NumberField *)v value] isEqualToString:@"NULL"])
                    {
                        [azureDictionary setObject:[NSNumber numberWithFloat:[[(NumberField *)v value] floatValue]] forKey:[(NumberField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[PhoneNumberField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(PhoneNumberField *)v columnName]];
                    if ([[(PhoneNumberField *)v value] isEqualToString:@"NULL"])
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(PhoneNumberField *)v value]]];
                        [azureDictionary setObject:[(PhoneNumberField *)v value] forKey:[(PhoneNumberField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[DateField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(DateField *)v columnName]];
                    if ([[(DateField *)v text] length] == 0)
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(DateField *)v text]]];
                        [azureDictionary setObject:[(DateField *)v text] forKey:[(DateField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoTextView class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextView *)v columnName]];
                    if ([[(EpiInfoTextView *)v text] length] == 0)
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [[(EpiInfoTextView *)v text] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(EpiInfoTextView *)v text] forKey:[(EpiInfoTextView *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoTextField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextField *)v columnName]];
                    if ([[(EpiInfoTextField *)v text] length] == 0)
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [[(EpiInfoTextField *)v text] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(EpiInfoTextField *)v text] forKey:[(EpiInfoTextField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoImageField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoImageField *)v columnName]];
                    if (![(EpiInfoImageField *)v epiInfoImageValue])
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        UIImage *imageToInsert = [(EpiInfoImageField *)v epiInfoImageValue];
                        NSString *imageGUID = [(EpiInfoImageField *)v epiInfoControlValue];
                        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
                        {
                            [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"] withIntermediateDirectories:NO attributes:nil error:nil];
                        }
                        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
                        {
                            if (![[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName]])
                            {
                                [[NSFileManager defaultManager] createDirectoryAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] withIntermediateDirectories:NO attributes:nil error:nil];
                            }
                            if ([[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName]])
                            {
                                //                                NSData *binaryImageData = UIImagePNGRepresentation(imageToInsert);
                                NSData *binaryImageData = UIImageJPEGRepresentation(imageToInsert, 0.9f);
                                NSString *imageFileToWrite = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageGUID]];
                                [binaryImageData writeToFile:imageFileToWrite atomically:YES];
                                valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", imageGUID]];
                                [azureDictionary setObject:imageGUID forKey:[(EpiInfoImageField *)v columnName]];
                            }
                            else
                            {
                                valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                            }
                        }
                        else
                        {
                            valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                        }
                    }
                }
                else if ([v isKindOfClass:[UppercaseTextField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(UppercaseTextField *)v columnName]];
                    if ([[(UppercaseTextField *)v text] length] == 0)
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [[[(UppercaseTextField *)v text] uppercaseString] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(UppercaseTextField *)v text] forKey:[(UppercaseTextField *)v columnName]];
                    }
                }
            }
        }
        insertStatement = [insertStatement stringByAppendingString:@")"];
        valuesClause = [valuesClause stringByAppendingString:@")"];
        insertStatement = [insertStatement stringByAppendingString:valuesClause];
        //        [azureDictionary setObject:@NO forKey:@"complete"];
        //        for (id key in azureDictionary)
        //        {
        //            NSLog(@"%@ :: %@", key, [azureDictionary objectForKey:key]);
        //        }
        //        NSLog(@"%@", createTableStatement);
        //        NSLog(@"%@", insertStatement);
        
        //Create the new table if necessary
        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists < 1)
        {
            //Convert the databasePath NSString to a char array
            const char *dbpath = [databasePath UTF8String];
            
            //Open sqlite3 analysisDB pointing to the databasePath
            if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                //Build the CREATE TABLE statement
                //Convert the sqlStmt to char array
                if ([dictionaryOfPages count] > 1)
                {
                    int pagesindictionary = (int)[dictionaryOfPages count];
                    pagesindictionary = pagesindictionary;
                    NSMutableString *tempCreateTableStatement = [NSMutableString stringWithString:@""];
                    for (int i = 0; i < 1; i++)
                    {
                        EnterDataView *edv0 = (EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", i + 1]];
                        NSString *cts = [edv0 createTableStatement];
                        [tempCreateTableStatement appendString:cts];
                    }
                    createTableStatement = [NSString stringWithString:tempCreateTableStatement];
                }
                const char *sql_stmt = [createTableStatement UTF8String];
                //                const char *sql_stmt = [@"drop table FoodHistory" UTF8String];
                
                //Execute the CREATE TABLE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create table: %s :::: %@", errMsg, createTableStatement);
                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to create table: %s :::: %@\n", [NSDate date], errMsg, createTableStatement]];
                }
                else
                {
                    //                    NSLog(@"Table created");
                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: SUBMIT: %@ table created\n", [NSDate date], formName]];
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open/create database");
                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to open/create database\n", [NSDate date]]];
            }
        }
        
        // Insert the row
        tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists >= 1)
        {
            //Convert the databasePath NSString to a char array
            const char *dbpath = [databasePath UTF8String];
            
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
                    if ([[NSString stringWithUTF8String:errMsg] rangeOfString:@"has no column named"].location != NSNotFound)
                    {
                        NSString *newColumn = [[NSString stringWithUTF8String:errMsg] substringFromIndex:[[NSString stringWithUTF8String:errMsg] rangeOfString:@"has no column named"].location + 20];
                        NSString *alterTableStatement = [NSString stringWithFormat:@"alter table %@\nadd %@ %@", formName, newColumn, [alterTableElements objectForKey:newColumn]];
                        sql_stmt = [alterTableStatement UTF8String];
                        char *secondErrMsg;
                        if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &secondErrMsg) != SQLITE_OK)
                        {
                            NSLog(@"Failed to alter table: %s :::: %@", secondErrMsg, alterTableStatement);
                            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to alter table: %s :::: %@\n", [NSDate date], secondErrMsg, alterTableStatement]];
                        }
                        else
                        {
                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: SUBMIT: %@ table altered\n", [NSDate date], formName]];
                            [self submitButtonPressed];
                            return;
                        }
                    }
                    NSLog(@"Failed to insert row into table: %s :::: %@", errMsg, insertStatement);
                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to insert row into table: %s :::: %@\n", [NSDate date], errMsg, insertStatement]];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Could not insert into local database." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alertC addAction:okAction];
                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                }
                else
                {
                    [(DataEntryViewController *)self.rootViewController setFooterBarToUpdate];
                    guidBeingUpdated = [NSString stringWithString:newRecordGUID];
                    newRecordGUID = nil;
                    tableBeingUpdated = formName;
                    recordUIDForUpdate = [NSString stringWithString:guidBeingUpdated];
                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: SUBMIT: Row added to %@\n", [NSDate date], formName]];
                    //                    NSLog(@"Row inserted");
                    // Replace deprecated UIAlertViews
                    //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit" message:@"Row inserted into local database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    //                    [alert setTag:42];
                    //                    [alert show];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Submit" message:@"Row inserted into local database." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        if (self.client)
                        {
                            UIAlertController *alertCloud = [UIAlertController alertControllerWithTitle:@"Submit" message:@"See logs for cloud database results." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okActionCloud = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            }];
                            [alertCloud addAction:okActionCloud];
//                            [self.rootViewController presentViewController:alertCloud animated:YES completion:nil];
                        }
                    }];
                    [alertC addAction:okAction];
//                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                    [areYouSure setText:@"Row inserted into local database."];
                    [uiaiv setHidden:NO];
                    [uiaiv startAnimating];
                    [okButton setEnabled:NO];
                    
                    if (self.cloudService)
                    {
                        // Write to Azure table using generic NSURLRequest method
                        NSMutableString *cloudDataString = [[NSMutableString alloc] init];
                        [cloudDataString appendString:@"{"];
                        NSString *guidValue = nil;
                        for (NSString *key in azureDictionary)
                        {
                            [cloudDataString appendString:[NSString stringWithFormat:@" \"%@\": \"", key]];
                            id keyValue = [azureDictionary objectForKey:key];
                            if ([keyValue isKindOfClass:[NSNumber class]])
                                keyValue = [(NSNumber *)keyValue stringValue];
                            [cloudDataString appendString:keyValue];
                            [cloudDataString appendString:@"\","];
                            if ([key isEqualToString:@"id"])
                                guidValue = [azureDictionary objectForKey:key];
                        }
                        [cloudDataString deleteCharactersInRange:NSMakeRange([cloudDataString length] - 1, 1)];
                        [cloudDataString appendString:@" }"];
                        
                        NSData *cloudData = [cloudDataString dataUsingEncoding:NSUTF8StringEncoding];
                        NSString *cloudDataLength = [NSString stringWithFormat:@"%d", (int)[cloudData length]];
                        
                        NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] init];
                        [getRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                        
                        [getRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                        [getRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                        [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                        [getRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                        
                        [getRequest setHTTPMethod:@"GET"];
                        
                        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                        [[session dataTaskWithRequest:getRequest completionHandler:^(NSData *getData, NSURLResponse *response, NSError *error) {
                            NSString *requestReply = [[NSString alloc] initWithData:getData encoding:NSASCIIStringEncoding];
                            if (error)
                            {
                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Could not read table %@. ERROR=%@\n", [NSDate date], self.formName, error]];
                            }
                            else if ([requestReply containsString:guidValue])
                            {
                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item found, id: %@\n", [NSDate date], guidValue]];
                                NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
                                [deleteRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@/%@", self.cloudService, self.formName, guidValue]]];
                                
                                [deleteRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                
                                [deleteRequest setHTTPMethod:@"DELETE"];
                                
                                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                [[session dataTaskWithRequest:deleteRequest completionHandler:^(NSData *deleteData, NSURLResponse *deleteResponse, NSError *deleteError) {
                                    if (deleteError)
                                    {
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Could not delete id %@: %@\n", [NSDate date], guidValue, deleteError]];
                                    }
                                    else
                                    {
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item deleted, id: %@\n", [NSDate date], guidValue]];
                                        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                                        [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                                        
                                        [postRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                        [postRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                        [postRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                        
                                        [postRequest setValue:cloudDataLength forHTTPHeaderField:@"Content-Length"];
                                        [postRequest setHTTPBody:cloudData];
                                        
                                        [postRequest setHTTPMethod:@"POST"];
                                        
                                        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                        [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *postData, NSURLResponse *response, NSError *postError) {
                                            if (postError)
                                            {
                                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Insert error with id %@: %@\n", [NSDate date], guidValue, postError]];
                                            }
                                            else
                                            {
                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item inserted, id: %@\n", [NSDate date], guidValue]];
                                            }
                                        }] resume];
                                    }
                                }] resume];
                            }
                            else
                            {
                                NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                                [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                                
                                [postRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                [postRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                [postRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                
                                [postRequest setValue:cloudDataLength forHTTPHeaderField:@"Content-Length"];
                                [postRequest setHTTPBody:cloudData];
                                
                                [postRequest setHTTPMethod:@"POST"];
                                
                                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *postData, NSURLResponse *response, NSError *postError) {
                                    if (postError)
                                    {
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Insert error with id %@: %@\n", [NSDate date], guidValue, postError]];
                                    }
                                    else
                                    {
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item inserted, id: %@\n", [NSDate date], guidValue]];
                                    }
                                }] resume];
                            }
                        }] resume];
                    }
                    /*
                     if (self.client)
                     {
                     MSTable *itemTable = [self.client tableWithName:formName];
                     [itemTable insert:azureDictionary completion:^(NSDictionary *insertedItem, NSError *error) {
                     if (error) {
                     NSLog(@"Error: %@", error);
                     [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Error: %@\n", [NSDate date], error]];
                     } else {
                     NSLog(@"Item inserted, id: %@", [insertedItem objectForKey:@"id"]);
                     [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item inserted, id: %@\n", [NSDate date], [insertedItem objectForKey:@"id"]]];
                     }
                     }];
                     }
                     */
                    //          NSLog(@"%@", self.epiinfoService.applicationURL);
                    //          if (self.epiinfoService.applicationURL)
                    //            [self.epiinfoService addItem:[NSDictionary dictionaryWithDictionary:azureDictionary] completion:^(NSUInteger index)
                    //             {
                    //               NSString *remoteResult = @"Row inserted into Azure cloud table.";
                    //               if ((int)index < 0)
                    //                 remoteResult = @"Could not insert row into Azure cloud table.";
                    //               [areYouSure setText:[NSString stringWithFormat:@"Row inserted into local database.\n%@", remoteResult]];
                    //               [uiaiv stopAnimating];
                    //               [uiaiv setHidden:YES];
                    //               [okButton setEnabled:YES];
                    //             }];
                    //          else
                    {
                        [uiaiv stopAnimating];
                        [uiaiv setHidden:YES];
                        [okButton setEnabled:YES];
                    }
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open database or insert record");
                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to open database or insert record\n", [NSDate date]]];
            }
        }
        else
        {
            NSLog(@"Could not find table");
            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Could not find table %@\n", [NSDate date], formName]];
        }
        
        //        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        //        {
        //            NSString *selStmt = [NSString stringWithFormat:@"select * from %@", formName];
        //            const char *query_stmt = [selStmt UTF8String];
        ////            const char *query_stmt = "SELECT name FROM sqlite_master";
        //            sqlite3_stmt *statement;
        //            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        //            {
        //                int columnCount = sqlite3_column_count(statement);
        //                while (sqlite3_step(statement) == SQLITE_ROW)
        //                    for (int i = 0; i < columnCount; i++)
        //                        NSLog(@"%s", sqlite3_column_text(statement, i));
        //            }
        //            sqlite3_finalize(statement);
        //        }
        //        sqlite3_close(epiinfoDB);
        if ([[[NSFileManager defaultManager] attributesOfItemAtPath:databasePath error:nil] objectForKey:NSFileProtectionKey] != NSFileProtectionComplete)
            [[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey: NSFileProtectionComplete} ofItemAtPath:databasePath error:nil];
    }
}

- (void)submitButtonPressed
{
    guidBeingUpdated = nil;
    BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(self.superview.frame.size.width - 5.0, self.superview.frame.size.height - 5.0, 10, 10)];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setNumberOfLines:0];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [bv addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [bv addSubview:uiaiv];
    
    //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Yes" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [okButton.layer setMasksToBounds:YES];
    [okButton.layer setCornerRadius:4.0];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bv addSubview:okButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        //        if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
        //        {
        //            [[NSFileManager defaultManager] removeItemAtPath:databasePath error:nil];
        //        }
        
        NSString *insertStatement = [NSString stringWithFormat:@"\ninsert into %@(GlobalRecordID", formName];
        //        NSString *valuesClause = @" values(";
        // Switched from creating UID at submit time to load-form/clear-form time
        //    NSString *recordUUID = CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
        NSString *valuesClause = [NSString stringWithFormat:@" values('%@'", newRecordGUID];
        BOOL valuesClauseBegun = YES;
        if (parentRecordGUID)
        {
            insertStatement = [insertStatement stringByAppendingString:@",\nFKEY"];
            valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@",\n'%@'", parentRecordGUID]];
        }
        NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
        [azureDictionary setObject:newRecordGUID forKey:@"id"];
        for (id key in dictionaryOfPages)
        {
            EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
            for (UIView *v in [[tempedv formCanvas] subviews])
            {
                if ([v isKindOfClass:[Checkbox class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(Checkbox *)v columnName]];
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%d", [(Checkbox *)v value]]];
                    [azureDictionary setObject:[NSNumber numberWithBool:[(Checkbox *)v value]] forKey:[(Checkbox *)v columnName]];
                }
                else if ([v isKindOfClass:[YesNo class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(YesNo *)v columnName]];
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", [(YesNo *)v picked]]];
                    if ([[(YesNo *)v picked] length] == 1)
                        [azureDictionary setObject:[NSNumber numberWithInt:[[(YesNo *)v picked] intValue]] forKey:[(YesNo *)v columnName]];
                }
                else if ([v isKindOfClass:[LegalValuesEnter class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(LegalValuesEnter *)v columnName]];
                    if ([[(LegalValuesEnter *)v picked] isEqualToString:@"NULL"])
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [[(LegalValuesEnter *)v picked] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[NSString stringWithFormat:@"%d", (int)[[(LegalValuesEnter *)v picker] selectedRowInComponent:0]] forKey:[(LegalValuesEnter *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[NumberField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(NumberField *)v columnName]];
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", [(NumberField *)v value]]];
                    if (![[(NumberField *)v value] isEqualToString:@"NULL"])
                    {
                        [azureDictionary setObject:[NSNumber numberWithFloat:[[(NumberField *)v value] floatValue]] forKey:[(NumberField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[PhoneNumberField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(PhoneNumberField *)v columnName]];
                    if ([[(PhoneNumberField *)v value] isEqualToString:@"NULL"])
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(PhoneNumberField *)v value]]];
                        [azureDictionary setObject:[(PhoneNumberField *)v value] forKey:[(PhoneNumberField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[DateField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(DateField *)v columnName]];
                    if ([[(DateField *)v text] length] == 0)
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(DateField *)v text]]];
                        [azureDictionary setObject:[(DateField *)v text] forKey:[(DateField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoTextView class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextView *)v columnName]];
                    if ([[(EpiInfoTextView *)v text] length] == 0)
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [[(EpiInfoTextView *)v text] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(EpiInfoTextView *)v text] forKey:[(EpiInfoTextView *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoTextField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextField *)v columnName]];
                    if ([[(EpiInfoTextField *)v text] length] == 0)
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [[(EpiInfoTextField *)v text] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(EpiInfoTextField *)v text] forKey:[(EpiInfoTextField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoImageField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoImageField *)v columnName]];
                    if (![(EpiInfoImageField *)v epiInfoImageValue])
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        UIImage *imageToInsert = [(EpiInfoImageField *)v epiInfoImageValue];
                        NSString *imageGUID = [(EpiInfoImageField *)v epiInfoControlValue];
                        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
                        {
                            [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"] withIntermediateDirectories:NO attributes:nil error:nil];
                        }
                        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
                        {
                            if (![[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName]])
                            {
                                [[NSFileManager defaultManager] createDirectoryAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] withIntermediateDirectories:NO attributes:nil error:nil];
                            }
                            if ([[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName]])
                            {
//                                NSData *binaryImageData = UIImagePNGRepresentation(imageToInsert);
                                NSData *binaryImageData = UIImageJPEGRepresentation(imageToInsert, 0.9f);
                                NSString *imageFileToWrite = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageGUID]];
                                [binaryImageData writeToFile:imageFileToWrite atomically:YES];
                                valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", imageGUID]];
                                [azureDictionary setObject:imageGUID forKey:[(EpiInfoImageField *)v columnName]];
                            }
                            else
                            {
                                valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                            }
                        }
                        else
                        {
                            valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                        }
                    }
                }
                else if ([v isKindOfClass:[UppercaseTextField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(UppercaseTextField *)v columnName]];
                    if ([[(UppercaseTextField *)v text] length] == 0)
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                    }
                    else
                    {
                        valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [[[(UppercaseTextField *)v text] uppercaseString] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(UppercaseTextField *)v text] forKey:[(UppercaseTextField *)v columnName]];
                    }
                }
            }
        }
        insertStatement = [insertStatement stringByAppendingString:@")"];
        valuesClause = [valuesClause stringByAppendingString:@")"];
        insertStatement = [insertStatement stringByAppendingString:valuesClause];
//        [azureDictionary setObject:@NO forKey:@"complete"];
        //        for (id key in azureDictionary)
        //        {
        //            NSLog(@"%@ :: %@", key, [azureDictionary objectForKey:key]);
        //        }
        //        NSLog(@"%@", createTableStatement);
        //        NSLog(@"%@", insertStatement);
        
        //Create the new table if necessary
        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists < 1)
        {
            //Convert the databasePath NSString to a char array
            const char *dbpath = [databasePath UTF8String];
            
            //Open sqlite3 analysisDB pointing to the databasePath
            if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                //Build the CREATE TABLE statement
                //Convert the sqlStmt to char array
                if ([dictionaryOfPages count] > 1)
                {
                    int pagesindictionary = (int)[dictionaryOfPages count];
                    pagesindictionary = pagesindictionary;
                    NSMutableString *tempCreateTableStatement = [NSMutableString stringWithString:@""];
                    for (int i = 0; i < 1; i++)
                    {
                        EnterDataView *edv0 = (EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", i + 1]];
                        NSString *cts = [edv0 createTableStatement];
                        [tempCreateTableStatement appendString:cts];
                    }
                    createTableStatement = [NSString stringWithString:tempCreateTableStatement];
                }
                const char *sql_stmt = [createTableStatement UTF8String];
                //                const char *sql_stmt = [@"drop table FoodHistory" UTF8String];
                
                //Execute the CREATE TABLE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create table: %s :::: %@", errMsg, createTableStatement);
                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to create table: %s :::: %@\n", [NSDate date], errMsg, createTableStatement]];
                }
                else
                {
                    //                    NSLog(@"Table created");
                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: SUBMIT: %@ table created\n", [NSDate date], formName]];
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open/create database");
                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to open/create database\n", [NSDate date]]];
            }
        }
        
        // Insert the row
        tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists >= 1)
        {
            //Convert the databasePath NSString to a char array
            const char *dbpath = [databasePath UTF8String];
            
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
                    if ([[NSString stringWithUTF8String:errMsg] rangeOfString:@"has no column named"].location != NSNotFound)
                    {
                        NSString *newColumn = [[NSString stringWithUTF8String:errMsg] substringFromIndex:[[NSString stringWithUTF8String:errMsg] rangeOfString:@"has no column named"].location + 20];
                        NSString *alterTableStatement = [NSString stringWithFormat:@"alter table %@\nadd %@ %@", formName, newColumn, [alterTableElements objectForKey:newColumn]];
                        sql_stmt = [alterTableStatement UTF8String];
                        char *secondErrMsg;
                        if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &secondErrMsg) != SQLITE_OK)
                        {
                            NSLog(@"Failed to alter table: %s :::: %@", secondErrMsg, alterTableStatement);
                            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to alter table: %s :::: %@\n", [NSDate date], secondErrMsg, alterTableStatement]];
                        }
                        else
                        {
                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: SUBMIT: %@ table altered\n", [NSDate date], formName]];
                            [self submitButtonPressed];
                            return;
                        }
                    }
                    NSLog(@"Failed to insert row into table: %s :::: %@", errMsg, insertStatement);
                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to insert row into table: %s :::: %@\n", [NSDate date], errMsg, insertStatement]];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Could not insert into local database." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alertC addAction:okAction];
                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                }
                else
                {
                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: SUBMIT: Row added to %@\n", [NSDate date], formName]];
                    //                    NSLog(@"Row inserted");
                    // Replace deprecated UIAlertViews
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit" message:@"Row inserted into local database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert setTag:42];
//                    [alert show];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Submit" message:@"Row inserted into local database." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        if (self.client)
                        {
                            UIAlertController *alertCloud = [UIAlertController alertControllerWithTitle:@"Submit" message:@"See logs for cloud database results." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okActionCloud = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            }];
                            [alertCloud addAction:okActionCloud];
                            [self.rootViewController presentViewController:alertCloud animated:YES completion:nil];
                        }
                    }];
                    [alertC addAction:okAction];
                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                    [areYouSure setText:@"Row inserted into local database."];
                    [uiaiv setHidden:NO];
                    [uiaiv startAnimating];
                    [okButton setEnabled:NO];

                    // JSON section for Box;
                    NSArray *users = [BOXContentClient users];
                    if ([users count] > 0 && NO)
                    {
                        NSError *jerror;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:azureDictionary options:0 error:&jerror];
                        if (jsonData)
                        {
                            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                            NSLog(@"\n%@", jsonString);
                        }
                        else
                        {
                            NSLog(@"%@", jerror);
                        }
                        BOXUser *user0 = [users objectAtIndex:0];
                        BOXContentClient *client0 = [BOXContentClient clientForUser:user0];
                        BOXSearchRequest *searchRequest = [client0 searchRequestWithQuery:@"__EpiInfo" inRange:NSMakeRange(0, 1000)];
                        [searchRequest setType:@"folder"];
                        [searchRequest setContentTypes:@[@"name"]];
                        [searchRequest performRequestWithCompletion:^(NSArray<BOXItem *> *items, NSUInteger totalCount, NSRange range, NSError *error) {
                            if ([items count] > 0)
                            {
                                for (BOXItem *bi in items)
                                {
                                    if ([bi isKindOfClass:[BOXFolder class]])
                                    {
                                        NSString *subfoldername = [NSString stringWithString:formName];
                                        NSString *eiFolderID = [bi modelID];
                                        NSLog(@"folder __EpiInfo exists with ID %@; checking for %@ folder", eiFolderID, subfoldername);
                                        BOXSearchRequest *subfolderSearchRequest = [client0 searchRequestWithQuery:subfoldername inRange:NSMakeRange(0, 1000)];
                                        [subfolderSearchRequest setAncestorFolderIDs:@[eiFolderID]];
                                        [searchRequest setType:@"folder"];
                                        [subfolderSearchRequest setContentTypes:@[@"name"]];
                                        [subfolderSearchRequest performRequestWithCompletion:^(NSArray<BOXItem *> *sitems, NSUInteger totalCount, NSRange range, NSError *error) {
                                            if ([sitems count] > 0)
                                            {
                                                for (BOXItem *bi in sitems)
                                                {
                                                    if ([bi isKindOfClass:[BOXFolder class]])
                                                    {
                                                        NSString *folderID = [bi modelID];
                                                        NSLog(@"folder %@ exists with ID %@; attempting to add a file", subfoldername, folderID);
                                                        BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:folderID fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [azureDictionary objectForKey:@"id"]]];
                                                        [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                            NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                        } completion:^(BOXFile *file, NSError *error) {
                                                            NSLog(@"upload request finished with file %@, error %@", file, error);
                                                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@", [NSDate date], file, error]];
                                                        }];
                                                        break;
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                BOXFolderCreateRequest *folderCreateRequest = [client0 folderCreateRequestWithName:subfoldername parentFolderID:eiFolderID];
                                                [folderCreateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
                                                    NSLog(@"folder creation request finished with folder %@, error %@", folder, error);
                                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder creation request finished with folder %@, error %@", [NSDate date], folder, error]];
                                                    if (folder && !error)
                                                    {
                                                        NSLog(@"folder %@ created; attempting to add a file", subfoldername);
                                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder %@ created; attempting to add a file", [NSDate date], subfoldername]];
                                                        BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[folder modelID] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [azureDictionary objectForKey:@"id"]]];
                                                        [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                            NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                        } completion:^(BOXFile *file, NSError *error) {
                                                            NSLog(@"upload request finished with file %@, error %@", file, error);
                                                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@", [NSDate date], file, error]];
                                                        }];
                                                    }
                                                }];
                                            }
                                        }];
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                NSString *subfoldername = [NSString stringWithString:formName];
                                BOXFolderCreateRequest *folderCreateRequest = [client0 folderCreateRequestWithName:@"__EpiInfo" parentFolderID:BOXAPIFolderIDRoot];
                                [folderCreateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
                                    NSLog(@"folder creation request finished with folder %@, error %@", folder, error);
                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder creation request finished with folder %@, error %@", [NSDate date], folder, error]];
                                    if (folder && !error)
                                    {
                                        NSLog(@"folder %@ created; attempting to add a file", @"__EpiInfo");
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder %@ created; attempting to add a file", [NSDate date], @"__EpiInfo"]];
                                        BOXFolderCreateRequest *folderCreateRequest = [client0 folderCreateRequestWithName:subfoldername parentFolderID:[folder modelID]];
                                        [folderCreateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
                                            NSLog(@"folder creation request finished with folder %@, error %@", folder, error);
                                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder creation request finished with folder %@, error %@", [NSDate date], folder, error]];
                                            if (folder && !error)
                                            {
                                                NSLog(@"folder %@ created; attempting to add a file", subfoldername);
                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder %@ created; attempting to add a file", [NSDate date], subfoldername]];
                                                BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[folder modelID] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [azureDictionary objectForKey:@"id"]]];
                                                [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                    NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                } completion:^(BOXFile *file, NSError *error) {
                                                    NSLog(@"upload request finished with file %@, error %@", file, error);
                                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@", [NSDate date], file, error]];
                                                }];
                                            }
                                        }];
                                    }
                                }];
                            }
                        }];
                    }

                    if (self.cloudService)
                    {
                        // Write to Azure table using generic NSURLRequest method
                        NSMutableString *cloudDataString = [[NSMutableString alloc] init];
                        [cloudDataString appendString:@"{"];
                        NSString *guidValue = nil;
                        for (NSString *key in azureDictionary)
                        {
                            [cloudDataString appendString:[NSString stringWithFormat:@" \"%@\": \"", key]];
                            id keyValue = [azureDictionary objectForKey:key];
                            if ([keyValue isKindOfClass:[NSNumber class]])
                                keyValue = [(NSNumber *)keyValue stringValue];
                            [cloudDataString appendString:keyValue];
                            [cloudDataString appendString:@"\","];
                            if ([key isEqualToString:@"id"])
                                guidValue = [azureDictionary objectForKey:key];
                        }
                        [cloudDataString deleteCharactersInRange:NSMakeRange([cloudDataString length] - 1, 1)];
                        [cloudDataString appendString:@" }"];
                        
                        NSData *cloudData = [cloudDataString dataUsingEncoding:NSUTF8StringEncoding];
                        NSString *cloudDataLength = [NSString stringWithFormat:@"%d", (int)[cloudData length]];
                        
                        NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] init];
                        [getRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                        
                        [getRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                        [getRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                        [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                        [getRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                        
                        [getRequest setHTTPMethod:@"GET"];
                        
                        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                        [[session dataTaskWithRequest:getRequest completionHandler:^(NSData *getData, NSURLResponse *response, NSError *error) {
                            NSString *requestReply = [[NSString alloc] initWithData:getData encoding:NSASCIIStringEncoding];
                            if (error)
                            {
                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Could not read table %@. ERROR=%@\n", [NSDate date], self.formName, error]];
                            }
                            else if ([requestReply containsString:guidValue])
                            {
                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item found, id: %@\n", [NSDate date], guidValue]];
                                NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
                                [deleteRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@/%@", self.cloudService, self.formName, guidValue]]];
                                
                                [deleteRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                
                                [deleteRequest setHTTPMethod:@"DELETE"];
                                
                                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                [[session dataTaskWithRequest:deleteRequest completionHandler:^(NSData *deleteData, NSURLResponse *deleteResponse, NSError *deleteError) {
                                    if (deleteError)
                                    {
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Could not delete id %@: %@\n", [NSDate date], guidValue, deleteError]];
                                    }
                                    else
                                    {
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item deleted, id: %@\n", [NSDate date], guidValue]];
                                        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                                        [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                                        
                                        [postRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                        [postRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                        [postRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                        
                                        [postRequest setValue:cloudDataLength forHTTPHeaderField:@"Content-Length"];
                                        [postRequest setHTTPBody:cloudData];
                                        
                                        [postRequest setHTTPMethod:@"POST"];
                                        
                                        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                        [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *postData, NSURLResponse *response, NSError *postError) {
                                            if (postError)
                                            {
                                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Insert error with id %@: %@\n", [NSDate date], guidValue, postError]];
                                            }
                                            else
                                            {
                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item inserted, id: %@\n", [NSDate date], guidValue]];
                                            }
                                        }] resume];
                                    }
                                }] resume];
                            }
                            else
                            {
                                NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                                [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                                
                                [postRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                [postRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                [postRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                
                                [postRequest setValue:cloudDataLength forHTTPHeaderField:@"Content-Length"];
                                [postRequest setHTTPBody:cloudData];
                                
                                [postRequest setHTTPMethod:@"POST"];
                                
                                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *postData, NSURLResponse *response, NSError *postError) {
                                    if (postError)
                                    {
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Insert error with id %@: %@\n", [NSDate date], guidValue, postError]];
                                    }
                                    else
                                    {
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item inserted, id: %@\n", [NSDate date], guidValue]];
                                    }
                                }] resume];
                            }
                        }] resume];
                    }
                    /*
                    if (self.client)
                    {
                        MSTable *itemTable = [self.client tableWithName:formName];
                        [itemTable insert:azureDictionary completion:^(NSDictionary *insertedItem, NSError *error) {
                            if (error) {
                                NSLog(@"Error: %@", error);
                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Error: %@\n", [NSDate date], error]];
                            } else {
                                NSLog(@"Item inserted, id: %@", [insertedItem objectForKey:@"id"]);
                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE SUBMIT: Item inserted, id: %@\n", [NSDate date], [insertedItem objectForKey:@"id"]]];
                            }
                        }];
                    }
                     */
                    //          NSLog(@"%@", self.epiinfoService.applicationURL);
                    //          if (self.epiinfoService.applicationURL)
                    //            [self.epiinfoService addItem:[NSDictionary dictionaryWithDictionary:azureDictionary] completion:^(NSUInteger index)
                    //             {
                    //               NSString *remoteResult = @"Row inserted into Azure cloud table.";
                    //               if ((int)index < 0)
                    //                 remoteResult = @"Could not insert row into Azure cloud table.";
                    //               [areYouSure setText:[NSString stringWithFormat:@"Row inserted into local database.\n%@", remoteResult]];
                    //               [uiaiv stopAnimating];
                    //               [uiaiv setHidden:YES];
                    //               [okButton setEnabled:YES];
                    //             }];
                    //          else
                    {
                        [uiaiv stopAnimating];
                        [uiaiv setHidden:YES];
                        [okButton setEnabled:YES];
                    }
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open database or insert record");
                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to open database or insert record\n", [NSDate date]]];
            }
        }
        else
        {
            NSLog(@"Could not find table");
            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Could not find table %@\n", [NSDate date], formName]];
        }
        
        //        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        //        {
        //            NSString *selStmt = [NSString stringWithFormat:@"select * from %@", formName];
        //            const char *query_stmt = [selStmt UTF8String];
        ////            const char *query_stmt = "SELECT name FROM sqlite_master";
        //            sqlite3_stmt *statement;
        //            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        //            {
        //                int columnCount = sqlite3_column_count(statement);
        //                while (sqlite3_step(statement) == SQLITE_ROW)
        //                    for (int i = 0; i < columnCount; i++)
        //                        NSLog(@"%s", sqlite3_column_text(statement, i));
        //            }
        //            sqlite3_finalize(statement);
        //        }
        //        sqlite3_close(epiinfoDB);
        if ([[[NSFileManager defaultManager] attributesOfItemAtPath:databasePath error:nil] objectForKey:NSFileProtectionKey] != NSFileProtectionComplete)
            [[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey: NSFileProtectionComplete} ofItemAtPath:databasePath error:nil];
    }
    
    [self clearButtonPressed];
    
    //  [self.superview addSubview:bv];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [bv setFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.width)];
        [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
        [uiaiv setFrame:CGRectMake(bv.frame.size.width / 2.0 - 20.0, bv.frame.size.height / 2.0 - 60.0, 40, 40)];
        [okButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)updateWithoutClearing
{
    guidBeingUpdated = nil;
    BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(self.superview.frame.size.width - 5.0, self.superview.frame.size.height - 5.0, 10, 10)];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setNumberOfLines:0];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [bv addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [bv addSubview:uiaiv];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Oh Kay" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [okButton.layer setMasksToBounds:YES];
    [okButton.layer setCornerRadius:4.0];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bv addSubview:okButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        NSString *insertStatement = [NSString stringWithFormat:@"\nupdate %@\nset ", formName];
        
        NSString *recordUUID = [NSString stringWithString:recordUIDForUpdate];
        NSString *valuesClause = [NSString stringWithFormat:@" values('%@'", recordUUID];
        BOOL valuesClauseBegun = NO;
        NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
        [azureDictionary setObject:recordUUID forKey:@"id"];
        for (id key in dictionaryOfPages)
        {
            EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
            for (UIView *v in [[tempedv formCanvas] subviews])
            {
                if ([v isKindOfClass:[Checkbox class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(Checkbox *)v columnName]];
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %d", [(Checkbox *)v value]]];
                    [azureDictionary setObject:[NSNumber numberWithBool:[(Checkbox *)v value]] forKey:[(Checkbox *)v columnName]];
                }
                else if ([v isKindOfClass:[YesNo class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(YesNo *)v columnName]];
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", [(YesNo *)v picked]]];
                    if ([[(YesNo *)v picked] length] == 1)
                        [azureDictionary setObject:[NSNumber numberWithInt:[[(YesNo *)v picked] intValue]] forKey:[(YesNo *)v columnName]];
                }
                else if ([v isKindOfClass:[LegalValuesEnter class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(LegalValuesEnter *)v columnName]];
                    if ([[(LegalValuesEnter *)v picked] isEqualToString:@"NULL"])
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [[(LegalValuesEnter *)v picked] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[NSString stringWithFormat:@"%d", (int)[[(LegalValuesEnter *)v picker] selectedRowInComponent:0]] forKey:[(LegalValuesEnter *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[NumberField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(NumberField *)v columnName]];
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", [(NumberField *)v value]]];
                    if (![[(NumberField *)v value] isEqualToString:@"NULL"])
                    {
                        [azureDictionary setObject:[NSNumber numberWithFloat:[[(NumberField *)v value] floatValue]] forKey:[(NumberField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[PhoneNumberField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(PhoneNumberField *)v columnName]];
                    if ([[(PhoneNumberField *)v value] isEqualToString:@"NULL"])
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(PhoneNumberField *)v value]]];
                        [azureDictionary setObject:[(PhoneNumberField *)v value] forKey:[(PhoneNumberField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[DateField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(DateField *)v columnName]];
                    if ([[(DateField *)v text] length] == 0)
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(DateField *)v text]]];
                        [azureDictionary setObject:[(DateField *)v text] forKey:[(DateField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoTextView class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextView *)v columnName]];
                    if ([[(EpiInfoTextView *)v text] length] == 0)
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [[(EpiInfoTextView *)v text] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(EpiInfoTextView *)v text] forKey:[(EpiInfoTextView *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoTextField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextField *)v columnName]];
                    if ([[(EpiInfoTextField *)v text] length] == 0)
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [[(EpiInfoTextField *)v text] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(EpiInfoTextField *)v text] forKey:[(EpiInfoTextField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoImageField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoImageField *)v columnName]];
                    if (![(EpiInfoImageField *)v epiInfoImageValue])
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        UIImage *imageToInsert = [(EpiInfoImageField *)v epiInfoImageValue];
                        NSString *imageGUID = [(EpiInfoImageField *)v epiInfoControlValue];
                        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
                        {
                            [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"] withIntermediateDirectories:NO attributes:nil error:nil];
                        }
                        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
                        {
                            if (![[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName]])
                            {
                                [[NSFileManager defaultManager] createDirectoryAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] withIntermediateDirectories:NO attributes:nil error:nil];
                            }
                            if ([[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName]])
                            {
                                //                                NSData *binaryImageData = UIImagePNGRepresentation(imageToInsert);
                                NSData *binaryImageData = UIImageJPEGRepresentation(imageToInsert, 0.9f);
                                NSString *imageFileToWrite = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageGUID]];
                                [binaryImageData writeToFile:imageFileToWrite atomically:YES];
                                insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", imageGUID]];
                                [azureDictionary setObject:imageGUID forKey:[(EpiInfoImageField *)v columnName]];
                            }
                            else
                            {
                                insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                            }
                        }
                        else
                        {
                            insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                        }
                    }
                }
                else if ([v isKindOfClass:[UppercaseTextField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(UppercaseTextField *)v columnName]];
                    if ([[(UppercaseTextField *)v text] length] == 0)
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [[[(UppercaseTextField *)v text] uppercaseString] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(UppercaseTextField *)v text] forKey:[(UppercaseTextField *)v columnName]];
                    }
                }
            }
        }
        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@"\nwhere GlobalRecordID = '%@'", recordUIDForUpdate]];
        
        //        [azureDictionary setObject:@NO forKey:@"complete"];
        
        //Create the new table if necessary
        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists < 1)
        {
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
                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: Failed to create table: %s :::: %@\n", [NSDate date], errMsg, createTableStatement]];
                }
                else
                {
                    //                    NSLog(@"Table created");
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open/create database");
                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: Failed to open/create database: %@\n", [NSDate date], databasePath]];
            }
        }
        
        // Update the row
        tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists >= 1)
        {
            //Convert the databasePath NSString to a char array
            const char *dbpath = [databasePath UTF8String];
            
            //Open sqlite3 analysisDB pointing to the databasePath
            if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                //Build the CREATE TABLE statement
                //Convert the sqlStmt to char array
                const char *sql_stmt = [insertStatement UTF8String];
                
                //Execute the UPDATE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    if ([[NSString stringWithUTF8String:errMsg] rangeOfString:@"no such column:"].location != NSNotFound)
                    {
                        NSString *newColumn = [[NSString stringWithUTF8String:errMsg] substringFromIndex:[[NSString stringWithUTF8String:errMsg] rangeOfString:@"no such column:"].location + 16];
                        NSString *alterTableStatement = [NSString stringWithFormat:@"alter table %@\nadd %@ %@", formName, newColumn, [alterTableElements objectForKey:newColumn]];
                        sql_stmt = [alterTableStatement UTF8String];
                        char *secondErrMsg;
                        if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &secondErrMsg) != SQLITE_OK)
                        {
                            NSLog(@"Failed to alter table: %s :::: %@", secondErrMsg, alterTableStatement);
                            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: Failed to alter table: %s :::: %@\n", [NSDate date], secondErrMsg, alterTableStatement]];
                        }
                        else
                        {
                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: UPDATE: %@ table altered\n", [NSDate date], formName]];
                            [self updateButtonPressed];
                            return;
                        }
                    }
                    NSLog(@"Failed to update row in table: %s :::: %@", errMsg, insertStatement);
                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: Failed to update row in table: %s :::: %@\n", [NSDate date], errMsg, insertStatement]];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Could not update row in table." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alertC addAction:okAction];
                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                }
                else
                {
                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: UPDATE: %@ row updated\n", [NSDate date], formName]];
                    //                    NSLog(@"Row inserted");
                    [areYouSure setText:@"Local database row updated."];
                    // Replace deprecated UIAlertViews
                    //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update" message:@"Local database row updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    //                    [alert setTag:42];
                    //                    [alert show];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Update" message:@"Local database row updated." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        if (self.client)
                        {
                            UIAlertController *alertCloud = [UIAlertController alertControllerWithTitle:@"Update" message:@"See logs for cloud database results." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okActionCloud = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            }];
                            [alertCloud addAction:okActionCloud];
//                            [self.rootViewController presentViewController:alertCloud animated:YES completion:nil];
                        }
                    }];
                    [alertC addAction:okAction];
//                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                    [uiaiv setHidden:NO];
                    [uiaiv startAnimating];
                    [okButton setEnabled:NO];
                    
                    if (self.cloudService)
                    {
                        // Write to Azure table using generic NSURLRequest method
                        NSMutableString *cloudDataString = [[NSMutableString alloc] init];
                        [cloudDataString appendString:@"{"];
                        NSString *guidValue = nil;
                        for (NSString *key in azureDictionary)
                        {
                            [cloudDataString appendString:[NSString stringWithFormat:@" \"%@\": \"", key]];
                            id keyValue = [azureDictionary objectForKey:key];
                            if ([keyValue isKindOfClass:[NSNumber class]])
                                keyValue = [(NSNumber *)keyValue stringValue];
                            [cloudDataString appendString:keyValue];
                            [cloudDataString appendString:@"\","];
                            if ([key isEqualToString:@"id"])
                                guidValue = [azureDictionary objectForKey:key];
                        }
                        [cloudDataString deleteCharactersInRange:NSMakeRange([cloudDataString length] - 1, 1)];
                        [cloudDataString appendString:@" }"];
                        
                        NSData *cloudData = [cloudDataString dataUsingEncoding:NSUTF8StringEncoding];
                        NSString *cloudDataLength = [NSString stringWithFormat:@"%d", (int)[cloudData length]];
                        
                        NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] init];
                        [getRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                        
                        [getRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                        [getRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                        [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                        [getRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                        
                        [getRequest setHTTPMethod:@"GET"];
                        
                        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                        [[session dataTaskWithRequest:getRequest completionHandler:^(NSData *getData, NSURLResponse *response, NSError *error) {
                            NSString *requestReply = [[NSString alloc] initWithData:getData encoding:NSASCIIStringEncoding];
                            if (error)
                            {
                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Could not read table %@. ERROR=%@\n", [NSDate date], self.formName, error]];
                            }
                            else if ([requestReply containsString:guidValue])
                            {
                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item found, id: %@\n", [NSDate date], guidValue]];
                                NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
                                [deleteRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@/%@", self.cloudService, self.formName, guidValue]]];
                                
                                [deleteRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                
                                [deleteRequest setHTTPMethod:@"DELETE"];
                                
                                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                [[session dataTaskWithRequest:deleteRequest completionHandler:^(NSData *deleteData, NSURLResponse *deleteResponse, NSError *deleteError) {
                                    if (deleteError)
                                    {
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Could not delete id %@: %@\n", [NSDate date], guidValue, deleteError]];
                                    }
                                    else
                                    {
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item deleted, id: %@\n", [NSDate date], guidValue]];
                                        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                                        [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                                        
                                        [postRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                        [postRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                        [postRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                        
                                        [postRequest setValue:cloudDataLength forHTTPHeaderField:@"Content-Length"];
                                        [postRequest setHTTPBody:cloudData];
                                        
                                        [postRequest setHTTPMethod:@"POST"];
                                        
                                        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                        [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *postData, NSURLResponse *response, NSError *postError) {
                                            if (postError)
                                            {
                                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Insert error with id %@: %@\n", [NSDate date], guidValue, postError]];
                                            }
                                            else
                                            {
                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item inserted, id: %@\n", [NSDate date], guidValue]];
                                            }
                                        }] resume];
                                    }
                                }] resume];
                            }
                            else
                            {
                                NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                                [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                                
                                [postRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                [postRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                [postRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                
                                [postRequest setValue:cloudDataLength forHTTPHeaderField:@"Content-Length"];
                                [postRequest setHTTPBody:cloudData];
                                
                                [postRequest setHTTPMethod:@"POST"];
                                
                                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *postData, NSURLResponse *response, NSError *postError) {
                                    if (postError)
                                    {
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Insert error with id %@: %@\n", [NSDate date], guidValue, postError]];
                                    }
                                    else
                                    {
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item inserted, id: %@\n", [NSDate date], guidValue]];
                                    }
                                }] resume];
                            }
                        }] resume];
                    }
                    /*
                     if (self.client)
                     {
                     MSTable *itemTable = [self.client tableWithName:formName];
                     [itemTable readWithId:[azureDictionary objectForKey:@"id"] completion:^(NSDictionary *queriedItem, NSError *queryError) {
                     if (queryError) {
                     [itemTable insert:azureDictionary completion:^(NSDictionary *insertedItem, NSError *error) {
                     if (error) {
                     NSLog(@"Insert error: %@", error);
                     [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Insert error: %@\n", [NSDate date], error]];
                     } else {
                     NSLog(@"Item inserted, id: %@", [insertedItem objectForKey:@"id"]);
                     [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item inserted, id: %@\n", [NSDate date], [insertedItem objectForKey:@"id"]]];
                     }
                     }];
                     } else {
                     NSLog(@"Item found, id: %@", [queriedItem objectForKey:@"id"]);
                     [itemTable update:azureDictionary completion:^(NSDictionary *updateDictionary, NSError *updateError) {
                     if (updateError) {
                     NSLog(@"Update error: %@", updateError);
                     [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Update error: %@\n", [NSDate date], updateError]];
                     } else {
                     NSLog(@"Item updated, id: %@", [updateDictionary objectForKey:@"id"]);
                     [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item updated, id: %@\n", [NSDate date], [updateDictionary objectForKey:@"id"]]];
                     }
                     }];
                     }
                     }];
                     }
                     */
                    //          if (self.epiinfoService.applicationURL)
                    //          {
                    //            [self.epiinfoService addItem:[NSDictionary dictionaryWithDictionary:azureDictionary] completion:^(NSUInteger index)
                    //             {
                    //               NSString *remoteResult = @"Azure cloud table row updated.";
                    //               if ((int)index < 0)
                    //                 remoteResult = @"Could not update Azure cloud table.";
                    //               [areYouSure setText:[NSString stringWithFormat:@"Row inserted into local database.\n%@", remoteResult]];
                    //               [uiaiv stopAnimating];
                    //               [uiaiv setHidden:YES];
                    //               [okButton setEnabled:YES];
                    //             }];
                    //          }
                    //          else
                    {
                        [uiaiv stopAnimating];
                        [uiaiv setHidden:YES];
                        [okButton setEnabled:YES];
                    }
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open database or insert record");
                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: failed to open %@ dataset or insert record\n", [NSDate date], formName]];
            }
        }
        else
        {
            NSLog(@"Could not find table");
            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: could not find table: %@\n", [NSDate date], formName]];
        }
    }
}

- (void)updateButtonPressed
{
    guidBeingUpdated = nil;
    BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(self.superview.frame.size.width - 5.0, self.superview.frame.size.height - 5.0, 10, 10)];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setNumberOfLines:0];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [bv addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [bv addSubview:uiaiv];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Oh Kay" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [okButton.layer setMasksToBounds:YES];
    [okButton.layer setCornerRadius:4.0];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bv addSubview:okButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        NSString *insertStatement = [NSString stringWithFormat:@"\nupdate %@\nset ", formName];
        
        NSString *recordUUID = [NSString stringWithString:recordUIDForUpdate];
        NSString *valuesClause = [NSString stringWithFormat:@" values('%@'", recordUUID];
        BOOL valuesClauseBegun = NO;
        NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
        [azureDictionary setObject:recordUUID forKey:@"id"];
        for (id key in dictionaryOfPages)
        {
            EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
            for (UIView *v in [[tempedv formCanvas] subviews])
            {
                if ([v isKindOfClass:[Checkbox class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(Checkbox *)v columnName]];
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %d", [(Checkbox *)v value]]];
                    [azureDictionary setObject:[NSNumber numberWithBool:[(Checkbox *)v value]] forKey:[(Checkbox *)v columnName]];
                }
                else if ([v isKindOfClass:[YesNo class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(YesNo *)v columnName]];
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", [(YesNo *)v picked]]];
                    if ([[(YesNo *)v picked] length] == 1)
                        [azureDictionary setObject:[NSNumber numberWithInt:[[(YesNo *)v picked] intValue]] forKey:[(YesNo *)v columnName]];
                }
                else if ([v isKindOfClass:[LegalValuesEnter class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(LegalValuesEnter *)v columnName]];
                    if ([[(LegalValuesEnter *)v picked] isEqualToString:@"NULL"])
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [[(LegalValuesEnter *)v picked] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[NSString stringWithFormat:@"%d", (int)[[(LegalValuesEnter *)v picker] selectedRowInComponent:0]] forKey:[(LegalValuesEnter *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[NumberField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(NumberField *)v columnName]];
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", [(NumberField *)v value]]];
                    if (![[(NumberField *)v value] isEqualToString:@"NULL"])
                    {
                        [azureDictionary setObject:[NSNumber numberWithFloat:[[(NumberField *)v value] floatValue]] forKey:[(NumberField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[PhoneNumberField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(PhoneNumberField *)v columnName]];
                    if ([[(PhoneNumberField *)v value] isEqualToString:@"NULL"])
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(PhoneNumberField *)v value]]];
                        [azureDictionary setObject:[(PhoneNumberField *)v value] forKey:[(PhoneNumberField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[DateField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(DateField *)v columnName]];
                    if ([[(DateField *)v text] length] == 0)
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(DateField *)v text]]];
                        [azureDictionary setObject:[(DateField *)v text] forKey:[(DateField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoTextView class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextView *)v columnName]];
                    if ([[(EpiInfoTextView *)v text] length] == 0)
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [[(EpiInfoTextView *)v text] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(EpiInfoTextView *)v text] forKey:[(EpiInfoTextView *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoTextField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextField *)v columnName]];
                    if ([[(EpiInfoTextField *)v text] length] == 0)
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [[(EpiInfoTextField *)v text] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(EpiInfoTextField *)v text] forKey:[(EpiInfoTextField *)v columnName]];
                    }
                }
                else if ([v isKindOfClass:[EpiInfoImageField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(EpiInfoImageField *)v columnName]];
                    if (![(EpiInfoImageField *)v epiInfoImageValue])
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        UIImage *imageToInsert = [(EpiInfoImageField *)v epiInfoImageValue];
                        NSString *imageGUID = [(EpiInfoImageField *)v epiInfoControlValue];
                        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
                        {
                            [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"] withIntermediateDirectories:NO attributes:nil error:nil];
                        }
                        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
                        {
                            if (![[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName]])
                            {
                                [[NSFileManager defaultManager] createDirectoryAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] withIntermediateDirectories:NO attributes:nil error:nil];
                            }
                            if ([[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName]])
                            {
//                                NSData *binaryImageData = UIImagePNGRepresentation(imageToInsert);
                                NSData *binaryImageData = UIImageJPEGRepresentation(imageToInsert, 0.9f);
                                NSString *imageFileToWrite = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageGUID]];
                                [binaryImageData writeToFile:imageFileToWrite atomically:YES];
                                insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", imageGUID]];
                                [azureDictionary setObject:imageGUID forKey:[(EpiInfoImageField *)v columnName]];
                            }
                            else
                            {
                                insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                            }
                        }
                        else
                        {
                            insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                        }
                    }
                }
                else if ([v isKindOfClass:[UppercaseTextField class]])
                {
                    if (valuesClauseBegun)
                    {
                        insertStatement = [insertStatement stringByAppendingString:@",\n"];
                        valuesClause = [valuesClause stringByAppendingString:@",\n"];
                    }
                    valuesClauseBegun = YES;
                    insertStatement = [insertStatement stringByAppendingString:[(UppercaseTextField *)v columnName]];
                    if ([[(UppercaseTextField *)v text] length] == 0)
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                    }
                    else
                    {
                        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [[[(UppercaseTextField *)v text] uppercaseString] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                        [azureDictionary setObject:[(UppercaseTextField *)v text] forKey:[(UppercaseTextField *)v columnName]];
                    }
                }
            }
        }
        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@"\nwhere GlobalRecordID = '%@'", recordUIDForUpdate]];
        
//        [azureDictionary setObject:@NO forKey:@"complete"];
        
        //Create the new table if necessary
        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists < 1)
        {
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
                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: Failed to create table: %s :::: %@\n", [NSDate date], errMsg, createTableStatement]];
                }
                else
                {
                    //                    NSLog(@"Table created");
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open/create database");
                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: Failed to open/create database: %@\n", [NSDate date], databasePath]];
            }
        }
        
        // Update the row
        tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists >= 1)
        {
            //Convert the databasePath NSString to a char array
            const char *dbpath = [databasePath UTF8String];
            
            //Open sqlite3 analysisDB pointing to the databasePath
            if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                //Build the CREATE TABLE statement
                //Convert the sqlStmt to char array
                const char *sql_stmt = [insertStatement UTF8String];
                
                //Execute the UPDATE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    if ([[NSString stringWithUTF8String:errMsg] rangeOfString:@"no such column:"].location != NSNotFound)
                    {
                        NSString *newColumn = [[NSString stringWithUTF8String:errMsg] substringFromIndex:[[NSString stringWithUTF8String:errMsg] rangeOfString:@"no such column:"].location + 16];
                        NSString *alterTableStatement = [NSString stringWithFormat:@"alter table %@\nadd %@ %@", formName, newColumn, [alterTableElements objectForKey:newColumn]];
                        sql_stmt = [alterTableStatement UTF8String];
                        char *secondErrMsg;
                        if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &secondErrMsg) != SQLITE_OK)
                        {
                            NSLog(@"Failed to alter table: %s :::: %@", secondErrMsg, alterTableStatement);
                            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: Failed to alter table: %s :::: %@\n", [NSDate date], secondErrMsg, alterTableStatement]];
                        }
                        else
                        {
                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: UPDATE: %@ table altered\n", [NSDate date], formName]];
                            [self updateButtonPressed];
                            return;
                        }
                    }
                    NSLog(@"Failed to update row in table: %s :::: %@", errMsg, insertStatement);
                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: Failed to update row in table: %s :::: %@\n", [NSDate date], errMsg, insertStatement]];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Could not update row in table." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alertC addAction:okAction];
                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                }
                else
                {
                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: UPDATE: %@ row updated\n", [NSDate date], formName]];
                    //                    NSLog(@"Row inserted");
                    [areYouSure setText:@"Local database row updated."];
                    // Replace deprecated UIAlertViews
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update" message:@"Local database row updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert setTag:42];
//                    [alert show];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Update" message:@"Local database row updated." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        if (self.client)
                        {
                            UIAlertController *alertCloud = [UIAlertController alertControllerWithTitle:@"Update" message:@"See logs for cloud database results." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okActionCloud = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            }];
                            [alertCloud addAction:okActionCloud];
                            [self.rootViewController presentViewController:alertCloud animated:YES completion:nil];
                        }
                    }];
                    [alertC addAction:okAction];
                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                    [uiaiv setHidden:NO];
                    [uiaiv startAnimating];
                    [okButton setEnabled:NO];
                    
                    if (self.cloudService)
                    {
                        // Write to Azure table using generic NSURLRequest method
                        NSMutableString *cloudDataString = [[NSMutableString alloc] init];
                        [cloudDataString appendString:@"{"];
                        NSString *guidValue = nil;
                        for (NSString *key in azureDictionary)
                        {
                            [cloudDataString appendString:[NSString stringWithFormat:@" \"%@\": \"", key]];
                            id keyValue = [azureDictionary objectForKey:key];
                            if ([keyValue isKindOfClass:[NSNumber class]])
                                keyValue = [(NSNumber *)keyValue stringValue];
                            [cloudDataString appendString:keyValue];
                            [cloudDataString appendString:@"\","];
                            if ([key isEqualToString:@"id"])
                                guidValue = [azureDictionary objectForKey:key];
                        }
                        [cloudDataString deleteCharactersInRange:NSMakeRange([cloudDataString length] - 1, 1)];
                        [cloudDataString appendString:@" }"];
                        
                        NSData *cloudData = [cloudDataString dataUsingEncoding:NSUTF8StringEncoding];
                        NSString *cloudDataLength = [NSString stringWithFormat:@"%d", (int)[cloudData length]];
                        
                        NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] init];
                        [getRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                        
                        [getRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                        [getRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                        [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                        [getRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                        
                        [getRequest setHTTPMethod:@"GET"];
                        
                        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                        [[session dataTaskWithRequest:getRequest completionHandler:^(NSData *getData, NSURLResponse *response, NSError *error) {
                            NSString *requestReply = [[NSString alloc] initWithData:getData encoding:NSASCIIStringEncoding];
                            if (error)
                            {
                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Could not read table %@. ERROR=%@\n", [NSDate date], self.formName, error]];
                            }
                            else if ([requestReply containsString:guidValue])
                            {
                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item found, id: %@\n", [NSDate date], guidValue]];
                                NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
                                [deleteRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@/%@", self.cloudService, self.formName, guidValue]]];
                                
                                [deleteRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                
                                [deleteRequest setHTTPMethod:@"DELETE"];
                                
                                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                [[session dataTaskWithRequest:deleteRequest completionHandler:^(NSData *deleteData, NSURLResponse *deleteResponse, NSError *deleteError) {
                                    if (deleteError)
                                    {
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Could not delete id %@: %@\n", [NSDate date], guidValue, deleteError]];
                                    }
                                    else
                                    {
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item deleted, id: %@\n", [NSDate date], guidValue]];
                                        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                                        [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                                        
                                        [postRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                        [postRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                        [postRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                        
                                        [postRequest setValue:cloudDataLength forHTTPHeaderField:@"Content-Length"];
                                        [postRequest setHTTPBody:cloudData];
                                        
                                        [postRequest setHTTPMethod:@"POST"];
                                        
                                        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                        [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *postData, NSURLResponse *response, NSError *postError) {
                                            if (postError)
                                            {
                                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Insert error with id %@: %@\n", [NSDate date], guidValue, postError]];
                                            }
                                            else
                                            {
                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item inserted, id: %@\n", [NSDate date], guidValue]];
                                            }
                                        }] resume];
                                    }
                                }] resume];
                            }
                            else
                            {
                                NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                                [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                                
                                [postRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                [postRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                [postRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                
                                [postRequest setValue:cloudDataLength forHTTPHeaderField:@"Content-Length"];
                                [postRequest setHTTPBody:cloudData];
                                
                                [postRequest setHTTPMethod:@"POST"];
                                
                                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *postData, NSURLResponse *response, NSError *postError) {
                                    if (postError)
                                    {
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Insert error with id %@: %@\n", [NSDate date], guidValue, postError]];
                                    }
                                    else
                                    {
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item inserted, id: %@\n", [NSDate date], guidValue]];
                                    }
                                }] resume];
                            }
                        }] resume];
                    }
                    /*
                    if (self.client)
                    {
                        MSTable *itemTable = [self.client tableWithName:formName];
                        [itemTable readWithId:[azureDictionary objectForKey:@"id"] completion:^(NSDictionary *queriedItem, NSError *queryError) {
                            if (queryError) {
                                [itemTable insert:azureDictionary completion:^(NSDictionary *insertedItem, NSError *error) {
                                    if (error) {
                                        NSLog(@"Insert error: %@", error);
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Insert error: %@\n", [NSDate date], error]];
                                    } else {
                                        NSLog(@"Item inserted, id: %@", [insertedItem objectForKey:@"id"]);
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item inserted, id: %@\n", [NSDate date], [insertedItem objectForKey:@"id"]]];
                                    }
                                }];
                            } else {
                                NSLog(@"Item found, id: %@", [queriedItem objectForKey:@"id"]);
                                [itemTable update:azureDictionary completion:^(NSDictionary *updateDictionary, NSError *updateError) {
                                    if (updateError) {
                                        NSLog(@"Update error: %@", updateError);
                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Update error: %@\n", [NSDate date], updateError]];
                                    } else {
                                        NSLog(@"Item updated, id: %@", [updateDictionary objectForKey:@"id"]);
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE UPDATE: Item updated, id: %@\n", [NSDate date], [updateDictionary objectForKey:@"id"]]];
                                    }
                                }];
                            }
                        }];
                    }
                    */
                    //          if (self.epiinfoService.applicationURL)
                    //          {
                    //            [self.epiinfoService addItem:[NSDictionary dictionaryWithDictionary:azureDictionary] completion:^(NSUInteger index)
                    //             {
                    //               NSString *remoteResult = @"Azure cloud table row updated.";
                    //               if ((int)index < 0)
                    //                 remoteResult = @"Could not update Azure cloud table.";
                    //               [areYouSure setText:[NSString stringWithFormat:@"Row inserted into local database.\n%@", remoteResult]];
                    //               [uiaiv stopAnimating];
                    //               [uiaiv setHidden:YES];
                    //               [okButton setEnabled:YES];
                    //             }];
                    //          }
                    //          else
                    {
                        [uiaiv stopAnimating];
                        [uiaiv setHidden:YES];
                        [okButton setEnabled:YES];
                    }
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open database or insert record");
                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: failed to open %@ dataset or insert record\n", [NSDate date], formName]];
            }
        }
        else
        {
            NSLog(@"Could not find table");
            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: UPDATE: could not find table: %@\n", [NSDate date], formName]];
        }
    }
    updatevisibleScreenOnly = NO;
    
    //  [self.superview addSubview:bv];
//    NSLog(@"Superview == %@", self.superview);
    [self clearButtonPressed];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [bv setFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.width)];
        [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
        [uiaiv setFrame:CGRectMake(bv.frame.size.width / 2.0 - 20.0, bv.frame.size.height / 2.0 - 60.0, 40, 40)];
        [okButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)deleteButtonPressed
{
    guidBeingUpdated = nil;
    BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(self.superview.frame.size.width - 5.0, self.superview.frame.size.height - 5.0, 10, 10)];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setNumberOfLines:0];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [bv addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [bv addSubview:uiaiv];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Oh Kay" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [okButton.layer setMasksToBounds:YES];
    [okButton.layer setCornerRadius:4.0];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bv addSubview:okButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        NSString *insertStatement = [NSString stringWithFormat:@"\ndelete from %@", formName];
        
        NSString *recordUUID = [NSString stringWithString:recordUIDForUpdate];
        
        NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
        [azureDictionary setObject:recordUUID forKey:@"id"];
        
        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@"\nwhere GlobalRecordID = '%@'", recordUIDForUpdate]];
        
//        [azureDictionary setObject:@NO forKey:@"complete"];
        
        // Delete the row
        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists >= 1)
        {
            //Convert the databasePath NSString to a char array
            const char *dbpath = [databasePath UTF8String];
            
            //Open sqlite3 analysisDB pointing to the databasePath
            if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                //Build the DELETE FROM TABLE statement
                //Convert the sqlStmt to char array
                const char *sql_stmt = [insertStatement UTF8String];
                
                //Execute the UPDATE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to delete row from table: %s :::: %@", errMsg, insertStatement);
                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: DELETE: Could not delete row from table: %s :::: %@\n", [NSDate date], errMsg, insertStatement]];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Could not delete row from table." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alertC addAction:okAction];
                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                }
                else
                {
                    for (id key in dictionaryOfPages)
                    {
                        EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
                        for (UIView *v in [[tempedv formCanvas] subviews])
                        {
                            if ([v isKindOfClass:[EpiInfoImageField class]])
                            {
                                if (![(EpiInfoImageField *)v epiInfoImageValue])
                                {
                                    continue;
                                }
                                else
                                {
                                    NSString *imageGUID = [(EpiInfoImageField *)v epiInfoControlValue];
                                    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository"]])
                                    {
                                        if ([[NSFileManager defaultManager] fileExistsAtPath:[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName]])
                                        {
                                            NSString *imageFileToRemove = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageGUID]];
                                            NSError *nse;
                                            [[NSFileManager defaultManager] removeItemAtPath:imageFileToRemove error:&nse];
                                        }
                                        else
                                        {
                                            continue;
                                        }
                                    }
                                    else
                                    {
                                        continue;
                                    }
                                }
                            }
                        }
                    }
                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: DELETE: %@ row deleted\n", [NSDate date], formName]];
                    // Replace deprecated UIAlertViews
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Local database row deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert setTag:42];
//                    [alert show];
                    /*
                    if (self.client)
                    {
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Local database row deleted. Delete cloud database row also?" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            MSTable *itemTable = [self.client tableWithName:formName];
                            [itemTable deleteWithId:[azureDictionary objectForKey:@"id"] completion:^(id itemID, NSError *error) {
                                if (error) {
                                    NSLog(@"Error deleting record: %@", error);
                                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE DELETE: Error deleting record: %@\n", [NSDate date], error]];
                                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to delete cloud row. See Error Log." preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                    }];
                                    [alertC addAction:okAction];
                                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                                } else {
                                    NSLog(@"Item deleted, id: %@", itemID);
                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE DELETE: Item deleted, id: %@\n", [NSDate date], itemID]];
                                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Cloud database row deleted." preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                    }];
                                    [alertC addAction:okAction];
                                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                                }
                            }];
                        }];
                        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        }];
                        [alertC addAction:yesAction];
                        [alertC addAction:noAction];
                        [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                    }
                     */
                    if (self.cloudService)
                    {
                        // Write to Azure table using generic NSURLRequest method
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Local database row deleted. Delete cloud database row also?" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            NSMutableString *cloudDataString = [[NSMutableString alloc] init];
                            [cloudDataString appendString:@"{"];
                            NSString *guidValue = nil;
                            for (NSString *key in azureDictionary)
                            {
                                [cloudDataString appendString:[NSString stringWithFormat:@" \"%@\": \"", key]];
                                id keyValue = [azureDictionary objectForKey:key];
                                if ([keyValue isKindOfClass:[NSNumber class]])
                                    keyValue = [(NSNumber *)keyValue stringValue];
                                [cloudDataString appendString:keyValue];
                                [cloudDataString appendString:@"\","];
                                if ([key isEqualToString:@"id"])
                                    guidValue = [azureDictionary objectForKey:key];
                            }
                            [cloudDataString deleteCharactersInRange:NSMakeRange([cloudDataString length] - 1, 1)];
                            [cloudDataString appendString:@" }"];
                            
                            NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] init];
                            [getRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@", self.cloudService, self.formName]]];
                            
                            [getRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                            [getRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                            [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                            [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                            [getRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                            
                            [getRequest setHTTPMethod:@"GET"];
                            
                            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                            [[session dataTaskWithRequest:getRequest completionHandler:^(NSData *getData, NSURLResponse *response, NSError *error) {
                                NSString *requestReply = [[NSString alloc] initWithData:getData encoding:NSASCIIStringEncoding];
                                if (error)
                                {
                                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE DELETE: Could not read table %@. ERROR=%@\n", [NSDate date], self.formName, error]];
                                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to read cloud table. See Error Log." preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                    }];
                                    [alertC addAction:okAction];
                                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                                }
                                else if ([requestReply containsString:guidValue])
                                {
                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE DELETE: Item found, id: %@\n", [NSDate date], guidValue]];
                                    NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
                                    [deleteRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@.azurewebsites.net/tables/%@/%@", self.cloudService, self.formName, guidValue]]];
                                    
                                    [deleteRequest setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
                                    [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"epi-token"];
                                    [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                    [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                                    [deleteRequest setValue:self.cloudKey forHTTPHeaderField:@"X-ZUMO-APPLICATION"];
                                    
                                    [deleteRequest setHTTPMethod:@"DELETE"];
                                    
                                    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                    [[session dataTaskWithRequest:deleteRequest completionHandler:^(NSData *deleteData, NSURLResponse *deleteResponse, NSError *deleteError) {
                                        if (deleteError)
                                        {
                                            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE DELETE: Could not delete id %@: %@\n", [NSDate date], guidValue, deleteError]];
                                            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to delete cloud row. See Error Log." preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                            }];
                                            [alertC addAction:okAction];
                                            [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                                        }
                                        else
                                        {
                                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: AZURE DELETE: Item deleted, id: %@\n", [NSDate date], guidValue]];
                                            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Cloud database row deleted." preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                            }];
                                            [alertC addAction:okAction];
                                            [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                                        }
                                    }] resume];
                                }
                                else
                                {
                                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: AZURE DELETE: Could not find id %@ table %@. ERROR=%@\n", [NSDate date], guidValue, self.formName, error]];
                                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to find cloud row. See Error Log." preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                    }];
                                    [alertC addAction:okAction];
                                    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                                }
                            }] resume];
                        }];
                        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        }];
                        [alertC addAction:yesAction];
                        [alertC addAction:noAction];
                        [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Local database row deleted." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        }];
                        [alertC addAction:okAction];
                        [self.rootViewController presentViewController:alertC animated:YES completion:nil];
                    }
                    
                    [areYouSure setText:@"Local database row deleted."];
                    [uiaiv setHidden:NO];
                    [uiaiv startAnimating];
                    [okButton setEnabled:NO];
                    if (self.client)
                    {
                    }
                    //          if (self.epiinfoService.applicationURL)
                    //          {
                    //            [self.epiinfoService deleteItem:[NSDictionary dictionaryWithDictionary:azureDictionary] completion:^(NSUInteger index)
                    //             {
                    //               NSString *remoteResult = @"Row delete from Azure cloud table.";
                    //               if ((int)index < 0)
                    //                 remoteResult = @"Could not delete row from Azure cloud table.";
                    //               [areYouSure setText:[NSString stringWithFormat:@"Row delete from local database.\n%@", remoteResult]];
                    //               [uiaiv stopAnimating];
                    //               [uiaiv setHidden:YES];
                    //               [okButton setEnabled:YES];
                    //             }];
                    //          }
                    //          else
                    {
                        [uiaiv stopAnimating];
                        [uiaiv setHidden:YES];
                        [okButton setEnabled:YES];
                    }
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open database or delete record");
                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: DELETE: Could not open database or delete record from %@\n", [NSDate date], formName]];
            }
        }
        else
        {
            NSLog(@"Could not find table");
            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: DELETE: Could not find table %@\n", [NSDate date], formName]];
        }
    }
    updatevisibleScreenOnly = NO;
    [self clearButtonPressed];
    
    //  [((EnterDataView *)[dictionaryOfPages objectForKey:@"Page1"]).superview addSubview:bv];
//    NSLog(@"Superview == %@", ((EnterDataView *)[dictionaryOfPages objectForKey:@"Page1"]).superview);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [bv setFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.width)];
        [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
        [uiaiv setFrame:CGRectMake(bv.frame.size.width / 2.0 - 20.0, bv.frame.size.height / 2.0 - 60.0, 40, 40)];
        [okButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)confirmSubmitOrClear:(UIButton *)sender
{
    [self resignAll];
    
    //  for (id v in [formCanvas subviews])
    //    if (![v isKindOfClass:[UILabel class]])
    //      [v setEnabled:NO];
    
    // Replace deprecated UIAlertViews
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit" message:@"Submit this record?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//    [alert setTag:0];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Submit" message:@"Submit this record?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alertC addAction:noAction];
    if ([sender tag] == 9)
    {
//        [alert setTitle:@"Clear"];
//        [alert setMessage:@"Clear all fields without submitting?"];
//        [alert setTag:3];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self callClearButtonPressed];
        }];
        [alertC addAction:yesAction];
        [alertC setTitle:@"Clear"];
        [alertC setMessage:@"Clear all fields without submitting?"];
    }
    else if ([sender tag] == 8)
    {
//        [alert setTitle:@"Update"];
//        [alert setMessage:@"Update this record?"];
//        [alert setTag:1];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self updateButtonPressed];
        }];
        [alertC addAction:yesAction];
        [alertC setTitle:@"Update"];
        [alertC setMessage:@"Update this record?"];
    }
    else if ([sender tag] == 7)
    {
//        [alert setTitle:@"Delete"];
//        [alert setMessage:@"Delete this record?"];
//        [alert setTag:2];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self deleteButtonPressed];
        }];
        [alertC addAction:yesAction];
        [alertC setTitle:@"Delete"];
        [alertC setMessage:@"Delete this record?"];
    }
    else
    {
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self submitButtonPressed];
        }];
        [alertC addAction:yesAction];
    }
//    [alert show];
    [self.rootViewController presentViewController:alertC animated:YES completion:nil];
    if (sender.tag == 9 || sender.tag == 7) {
        
        BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, self.superview.frame.size.height - (formCanvas.frame.size.height - sender.frame.origin.y), sender.frame.size.width, sender.frame.size.height)];
        
        UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bv.frame.size.width - 20, 36)];
        [areYouSure setBackgroundColor:[UIColor clearColor]];
        [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        if (sender.tag == 9)
            [areYouSure setText:@"Clear all fields without submitting?"];
        else if (sender.tag == 8)
            [areYouSure setText:@"Update this record?"];
        else if (sender.tag == 7)
            [areYouSure setText:@"Delete this record?"];
        else
            [areYouSure setText:@"Submit this record?"];
        [areYouSure setNumberOfLines:0];
        [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
        [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
        [areYouSure setTextAlignment:NSTextAlignmentCenter];
        [bv addSubview:areYouSure];
        
        //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
        UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        [yesButton setImage:[UIImage imageNamed:@"YesButton.png"] forState:UIControlStateNormal];
        [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [yesButton.layer setMasksToBounds:YES];
        [yesButton.layer setCornerRadius:4.0];
        if (sender.tag == 9)
            [yesButton addTarget:self action:@selector(clearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        else if (sender.tag == 8)
            [yesButton addTarget:self action:@selector(updateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        else if (sender.tag == 7)
            [yesButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        else
            [yesButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [bv addSubview:yesButton];
        
        //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
        UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        [noButton setImage:[UIImage imageNamed:@"NoButton.png"] forState:UIControlStateNormal];
        [noButton setTitle:@"No" forState:UIControlStateNormal];
        [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [noButton.layer setMasksToBounds:YES];
        [noButton.layer setCornerRadius:4.0];
        [noButton addTarget:self action:@selector(doNotSubmitOrClear) forControlEvents:UIControlEventTouchUpInside];
        [bv addSubview:noButton];
        
        //  [self.superview addSubview:bv];
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [bv setFrame:CGRectMake(0, self.frame.size.height - self.frame.size.width, self.frame.size.width, self.frame.size.width)];
            [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
            [yesButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
            [noButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 + 22.0, 120, 40)];
        } completion:^(BOOL finished){
        }];
    }
    else
    {
        if ([self onSubmitRequiredFrom:@"if"])
        {
            
            [self checkDialogs:[pageName lowercaseString] Tag:1 type:1 from:@"after" from:@"page"];
            
            BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, self.superview.frame.size.height - (formCanvas.frame.size.height - sender.frame.origin.y), sender.frame.size.width, sender.frame.size.height)];
            
            UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bv.frame.size.width - 20, 36)];
            [areYouSure setBackgroundColor:[UIColor clearColor]];
            [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            if (sender.tag == 9)
                [areYouSure setText:@"Clear all fields without submitting?"];
            else if (sender.tag == 8)
                [areYouSure setText:@"Update this record?"];
            else if (sender.tag == 7)
                [areYouSure setText:@"Delete this record?"];
            else
                [areYouSure setText:@"Submit this record?"];
            [areYouSure setNumberOfLines:0];
            [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
            [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
            [areYouSure setTextAlignment:NSTextAlignmentCenter];
            [bv addSubview:areYouSure];
            
            //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
            UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
            [yesButton setImage:[UIImage imageNamed:@"YesButton.png"] forState:UIControlStateNormal];
            [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
            [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [yesButton.layer setMasksToBounds:YES];
            [yesButton.layer setCornerRadius:4.0];
            if (sender.tag == 9)
                [yesButton addTarget:self action:@selector(clearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            else if (sender.tag == 8)
                [yesButton addTarget:self action:@selector(updateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            else if (sender.tag == 7)
                [yesButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            else
                [yesButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [bv addSubview:yesButton];
            
            //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
            UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
            [noButton setImage:[UIImage imageNamed:@"NoButton.png"] forState:UIControlStateNormal];
            [noButton setTitle:@"No" forState:UIControlStateNormal];
            [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [noButton.layer setMasksToBounds:YES];
            [noButton.layer setCornerRadius:4.0];
            [noButton addTarget:self action:@selector(doNotSubmitOrClear) forControlEvents:UIControlEventTouchUpInside];
            [bv addSubview:noButton];
            
            //  [self.superview addSubview:bv];
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [bv setFrame:CGRectMake(0, self.frame.size.height - self.frame.size.width, self.frame.size.width, self.frame.size.width)];
                [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
                [yesButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
                [noButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 + 22.0, 120, 40)];
            } completion:^(BOOL finished){
            }];
        }
    }
    
}
- (void)doNotSubmitOrClear
{
    for (UIView *v in [self.superview subviews])
    {
        if ([v isKindOfClass:[BlurryView class]])
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [v setFrame:CGRectMake(0, self.superview.frame.size.height, v.frame.size.width, v.frame.size.width)];
            } completion:^(BOOL finished){
                [v removeFromSuperview];
            }];
        }
    }
    for (id v in [formCanvas subviews])
        if (![v isKindOfClass:[UILabel class]])
            [v setEnabled:YES];
}
- (void)clearButtonPressedAction
{
    [(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", 1]] clearButtonPressedAction];
}
- (void)callClearButtonPressed
{
    guidBeingUpdated = nil;
    BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(self.superview.frame.size.width - 5.0, self.superview.frame.size.height - 5.0, 10, 10)];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setNumberOfLines:0];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [bv addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [bv addSubview:uiaiv];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Oh Kay" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [okButton.layer setMasksToBounds:YES];
    [okButton.layer setCornerRadius:4.0];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bv addSubview:okButton];
    
    updatevisibleScreenOnly = NO;
    
    //  [self.superview addSubview:bv];
    //    NSLog(@"Superview == %@", self.superview);
    [self clearButtonPressed];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [bv setFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.width)];
        [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
        [uiaiv setFrame:CGRectMake(bv.frame.size.width / 2.0 - 20.0, bv.frame.size.height / 2.0 - 60.0, 40, 40)];
        [okButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
    } completion:^(BOOL finished){
    }];
}
- (void)clearButtonPressed
{
    // New code for separating pages
    UIView *selfsuperview = [self superview];
    guidBeingUpdated = nil;
    recordUIDForUpdate = nil;
    newRecordGUID = CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
    NSDictionary *copyOfDictionaryOfPages = [NSDictionary dictionaryWithDictionary:dictionaryOfPages];
    for (id key in copyOfDictionaryOfPages)
    {
        [(EnterDataView *)[dictionaryOfPages objectForKey:key] setNewRecordGUID:newRecordGUID];
        if (updatevisibleScreenOnly && ![(NSString *)key isEqualToString:[NSString stringWithFormat:@"Page%d", pageToDisplay]])
        {
            continue;
        }
        EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
        [tempedv setRecordUIDForUpdate:nil];
        if ([(NSString *)key isEqualToString:@"Page1"])
        {
            [selfsuperview addSubview:tempedv];
            if (!populateInstructionCameFromLineList)
            {
                DataEntryViewController *devc = (DataEntryViewController *)self.rootViewController;
                [devc resetPagedots];
            }
        }
        else if (!populateInstructionCameFromLineList)
        {
            [tempedv removeFromSuperview];
        }
        for (UIView *v in [self.rootViewController.view subviews])
        {
            if ([[v backgroundColor] isEqual:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:0.95]] && v == myOrangeBanner)
            {
                [self.rootViewController.view bringSubviewToFront:v];
                for (UIView *l in [v subviews])
                {
                    if ([l isKindOfClass:[UILabel class]])
                    {
                        [(UILabel *)l setText:[NSString stringWithFormat:@"%@", formName]];
                    }
                }
            }
            else if ([v isKindOfClass:[UINavigationBar class]])
            {
                [self.rootViewController.view bringSubviewToFront:v];
            }
        }
        for (id v in [[tempedv formCanvas] subviews])
        {
            if ([v conformsToProtocol:@protocol(EpiInfoControlProtocol)])
            {
                [(UIView <EpiInfoControlProtocol> *)v reset];
                continue;
            }
            if ([v isKindOfClass:[DateField class]])
                [(DateField *)v reset];
            else if ([v isKindOfClass:[UITextField class]])
                [(UITextField *)v setText:nil];
            else if ([v isKindOfClass:[UITextView class]])
                [(UITextView *)v setText:nil];
            else if ([v isKindOfClass:[YesNo class]])
                [(YesNo *)v reset];
            else if ([v isKindOfClass:[LegalValuesEnter class]])
                [(LegalValuesEnter *)v reset];
            else if ([v isKindOfClass:[Checkbox class]])
                [(Checkbox *)v reset];
            [v setEnabled:YES];
            if ([v conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                [v setIsEnabled:YES];
        }
        // Clear the fieldsAndStringValues dictionary
//        for (id key in self.fieldsAndStringValues.nsmd)
//            [self.fieldsAndStringValues setObject:@"" forKey:key];
        [tempedv resignAll];
        [tempedv setContentOffset:CGPointZero animated:YES];
        [self doNotSubmitOrClear];
        //    [self.locationManager stopUpdatingLocation];
        //    [self getMyLocation];
        for (UIView *v in [tempedv subviews])
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                if ([(UIButton *)v tag] == 8 && v.frame.size.width > 40)
                {
                    [(UIButton *)v setTag:1];
                    if ([(UIButton *)v isEnabled])
                        [(UIButton *)v setImage:[UIImage imageNamed:@"SubmitButton.png"] forState:UIControlStateNormal];
                }
                if ([(UIButton *)v tag] == 7 && v.frame.size.width > 40)
                {
                    [(UIButton *)v setHidden:YES];
                }
            }
        }
    }
    [(DataEntryViewController *)self.rootViewController resetHeaderAndFooterBars];
    if (parentEnterDataView)
        [ChildFormFieldAssignments parseForAssignStatements:[self formCheckCodeString] parentForm:(EnterDataView *)parentEnterDataView childForm:self relateButtonName:relateButtonName];
    else
        [(DataEntryViewController *)self.rootViewController setUpdateExistingRecord:NO];

    [[NSUserDefaults standardUserDefaults] setObject:[(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", 1]] myTextPageName] forKey:@"nameOfThePage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", 1]] checkElements:@"1" from:@"before" page:@"1"];
}
- (void)okButtonPressed
{
    for (UIView *v in [self.superview subviews])
        if ([v isKindOfClass:[BlurryView class]])
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [v setFrame:CGRectMake(0, -v.frame.size.height, v.frame.size.width, v.frame.size.width)];
            } completion:^(BOOL finished){
                [v removeFromSuperview];
            }];
        }
}

- (void)resignAll
{
    for (id v in [formCanvas subviews])
    {
        if ([v isKindOfClass:[UITextField class]] && [v isFirstResponder])
        {
            [(UITextField *)v resignFirstResponder];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
            } completion:^(BOOL finished){
                hasAFirstResponder = NO;
            }];
        }
        else if ([v isKindOfClass:[UITextView class]] && [v isFirstResponder])
        {
            [(UITextView *)v resignFirstResponder];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
            } completion:^(BOOL finished){
                hasAFirstResponder = NO;
            }];
        }
    }
    
//    NSLog(@"------------------------- %f, %f",self.contentSize.width, self.contentSize.height - 200.0);
    
}
- (void)doResignAll
{
    [self resignAll];
}

- (void)dismissForm;
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [(DataEntryViewController *)self.rootViewController setLegalValuesDictionary:nil];
        // Return the Back button to the nav controller
        [self.rootViewController.navigationItem setHidesBackButton:NO animated:YES];
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
            [self.rootViewController.view.layer setTransform:rotate];
        } completion:^(BOOL finished){
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
    
    ElementsModel *epc = [[ElementsModel alloc]init];
    
    if ([elementName isEqualToString:@"Template"])
    {
        if ([[attributeDict objectForKey:@"Level"] isEqualToString:@"Project"] && ![(DataEntryViewController *)self.rootViewController didShowProjectTemplateWarning])
        {
            NSLog(@"THIS IS A PROJECT TEMPLATE!!!!");
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warning" message:@"This form was created with a Project Template. Forms should be loaded to the device with Form Templates." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [(DataEntryViewController *)self.rootViewController setDidShowProjectTemplateWarning:YES];
            }];
            [alertC addAction:yesAction];
            [(DataEntryViewController *)self.rootViewController presentViewController:alertC animated:YES completion:nil];
            [(DataEntryViewController *)self.rootViewController setDidShowProjectTemplateWarning:YES];
        }
    }

    NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
    [nsnf setMaximumFractionDigits:6];
    
    dataText = [dataText stringByAppendingString:[NSString stringWithFormat:@"\n%@", elementName]];
    
    if (firstParse)
    {
        //        int pageNo = 0;
        if ([elementName isEqualToString:@"Page"])
        {
            //            NSLog(@"Page %@", [attributeDict objectForKey:@"PageId"]);
            //            pageNo = [[attributeDict objectForKey:@"PageId"] intValue];
            
            //        pageName = [attributeDict objectForKey:@"Name"];
            //        [[NSUserDefaults standardUserDefaults] setObject:pageName forKey:@"pageName"];
            //        [[NSUserDefaults standardUserDefaults] synchronize];
            //        firstEdit = FALSE;
            
            if (!self.pagesArray)
            {
                self.pagesArray = [[NSMutableArray alloc] init];
                self.pageIDs = [[NSMutableArray alloc] init];
                self.checkboxes = [[NSMutableDictionary alloc] init];
            }
            [[self pagesArray] addObject:[[NSMutableArray alloc] init]];
            [[self pageIDs] addObject:[attributeDict objectForKey:@"PageId"]];
            //            NSLog(@"%d", [[self pagesArray] count]);
        }
        if ([elementName isEqualToString:@"Field"] && [[attributeDict objectForKey:@"FieldTypeId"] intValue] < 26 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 2 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 13 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 15 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 20 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 21 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 22 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 23 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 24 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 16)
        {
            
            
            //            NSLog(@"\t%@", [attributeDict objectForKey:@"Name"]);
            [(NSMutableArray *)[[self pagesArray] objectAtIndex:self.pagesArray.count - 1] addObject:[attributeDict objectForKey:@"Name"]];
            if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"10"])
            {
                [self.checkboxes setObject:@"A" forKey:[attributeDict objectForKey:@"Name"]];
            }
            if (![((DataEntryViewController *)[self rootViewController]).arrayOfFieldsAllPages containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
            {
                [((DataEntryViewController *)[self rootViewController]).arrayOfFieldsAllPages addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
            }
        }
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
        NSString *commaOrParen;
        if ([elementName isEqualToString:@"View"])
        {
            //            formName = [attributeDict objectForKey:@"Name"];
            formName = self.nameOfTheForm;
            // Tell the Azure service the table name.
            //      [self.epiinfoService setTableName:formName];
            
            //      createTableStatement = [NSString stringWithFormat:@"create table %@(GlobalRecordID text", formName];
            if (!((DataEntryViewController *)self.rootViewController).alterTableElements)
                ((DataEntryViewController *)self.rootViewController).alterTableElements = [[NSMutableDictionary alloc] init];
            alterTableElements = ((DataEntryViewController *)self.rootViewController).alterTableElements;
            beginColumList = NO;
            
            if ([attributeDict objectForKey:@"CheckCode"])
            {
                
                ccp = [[CheckCodeParser alloc]init];
                NSString *checkCodeString = [attributeDict objectForKey:@"CheckCode"];
                ccp.edv = self;
                NSString *valueToSave = checkCodeString;
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"checkcode"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [ccp parseCheckCode:checkCodeString];
                formCheckCodeString = checkCodeString;
                int geocodePosition = (int)[[checkCodeString stringByReplacingOccurrencesOfString:@"The GEOCODE command requires an active Internet connection" withString:@""] rangeOfString:@"GEOCODE"].location;
                if (geocodePosition >= 0 && geocodePosition < [checkCodeString stringByReplacingOccurrencesOfString:@"The GEOCODE command requires an active Internet connection" withString:@""].length)
                {
                    NSString *geocodeString = [[checkCodeString stringByReplacingOccurrencesOfString:@"The GEOCODE command requires an active Internet connection" withString:@""] substringFromIndex:geocodePosition];
                    int commaPosition = (int)[geocodeString rangeOfString:@","].location;
                    geocodeString = [geocodeString substringFromIndex:commaPosition + 1];
                    commaPosition = (int)[geocodeString rangeOfString:@","].location;
                    [self setLatitudeField:[[geocodeString substringToIndex:commaPosition] stringByReplacingOccurrencesOfString:@" " withString:@""]];
                    geocodeString = [geocodeString substringFromIndex:commaPosition + 1];
                    commaPosition = (int)[geocodeString rangeOfString:@"End-Click"].location;
                    [self setLongitudeField:[[[[geocodeString substringToIndex:commaPosition] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
                }
                while ((int)[checkCodeString rangeOfString:@"//"].location >= 0 && (int)[checkCodeString rangeOfString:@"//"].location < checkCodeString.length)
                {
                    NSRange slashrange = [checkCodeString rangeOfString:@"//"];
                    NSRange crrange = [[checkCodeString substringFromIndex:(int)slashrange.location] rangeOfString:@"\n"];
                    NSRange range = NSMakeRange(slashrange.location, crrange.location + crrange.length);
                    checkCodeString = [checkCodeString stringByReplacingCharactersInRange:range withString:@""];
                }
                self.dictionaryOfWordsArrays = [[NSMutableDictionary alloc] init];
                //        while ([[checkCodeString uppercaseString] containsString:@"FIELD "] && (int)[[checkCodeString uppercaseString] rangeOfString:@"Field "].location < checkCodeString.length)
                while (NO)
                {
                    NSRange fieldrange = [[checkCodeString uppercaseString] rangeOfString:@"FIELD "];
                    NSRange endfieldrange = [[checkCodeString uppercaseString] rangeOfString:@"END-FIELD"];
                    if (endfieldrange.location > checkCodeString.length)
                        break;
                    //          NSLog(@"\n%@", [[checkCodeString substringToIndex:endfieldrange.location] substringFromIndex:fieldrange.location + fieldrange.length]);
                    NSArray *wordsArray = [[[[checkCodeString substringToIndex:endfieldrange.location] substringFromIndex:fieldrange.location + fieldrange.length] stringByReplacingOccurrencesOfString:@"\t" withString:@""] componentsSeparatedByString:@"\n"];
                    //          NSLog(@"%@", wordsArray);
                    [self.dictionaryOfWordsArrays setObject:wordsArray forKey:(NSString *)[wordsArray objectAtIndex:0]];
                    checkCodeString = [checkCodeString substringFromIndex:endfieldrange.location + endfieldrange.length];
                }
                
                NSMutableArray *eleTemArray = [[NSMutableArray alloc]init];
                eleTemArray=[ccp sendArray];
                if (elementsArray.count<1 || elmArray.count<1 || elementListArray.count<1)
                {
                    [self copyToArray:eleTemArray];
//                    NSLog(@"satya IN");
                }
            }
        }
        // New code for separating pages
        if ([elementName isEqualToString:@"Page"])
        {
            NSString *pageNo = [attributeDict objectForKey:@"ActualPageNumber"];
            int pageNumber = [pageNo intValue];
//            NSLog(@"Page %d", pageNumber);
            isFirstPage = (pageToDisplay == 1);
            isLastPage = YES;
            if (pageNumber == pageToDisplay)
            {
                isCurrentPage = YES;
 //               NSLog(@"PageId attribute (%d) equals pageToDisplay(%d)", pageNumber, pageToDisplay);
                
                pageName = [NSString stringWithFormat:@"%d",pageToDisplay];
                [[NSUserDefaults standardUserDefaults] setObject:pageName forKey:@"pageName"];
                [self setMyTextPageName:[NSString stringWithString:[attributeDict objectForKey:@"Name"]]];
                [[NSUserDefaults standardUserDefaults] setObject:[attributeDict objectForKey:@"Name"] forKey:@"nameOfThePage"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                NSLog(@"000%@",pageName);
                
            }
            else if (pageNumber == pageToDisplay + 1)
            {
                isCurrentPage = NO;
                isLastPage = NO;
//                NSLog(@"PageId attribute (%d) is the next page", pageNumber);
            }
            else if (pageNumber == pageToDisplay - 1)
            {
                isCurrentPage = NO;
//                NSLog(@"PageId attribute (%d) is the previous page", pageNumber);
            }
            else
            {
                isCurrentPage = NO;
                if (pageNumber > pageToDisplay)
                    isLastPage = NO;
//                NSLog(@"PageId attribute (%d) is neither the next or the previous page", pageNumber);
            }
            if (isFirstPage && isCurrentPage)
                createTableStatement = [NSString stringWithFormat:@"create table %@(GlobalRecordID text", formName];
            else if (isCurrentPage)
                createTableStatement = @"";
        }
        // New code for separating pages
        if ([elementName isEqualToString:@"Field"] )//&& isCurrentPage)
        {
            UILabel *elementLabel;
            float fontsize;
            commaOrParen = @",";
            if (isCurrentPage)
            {
                if (tagNum<100)
                {
                    tagNum = 100;
                }
                if (beginColumList)
                    commaOrParen = @",";
                else
                    commaOrParen = @",";
                
                float elementLabelHeight = 40.0;
                
                
                
                
                elementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, contentSizeHeight, self.frame.size.width - 40, 40)];
                
                if (([[attributeDict objectForKey:@"IsRequired"] caseInsensitiveCompare:@"true"] ==  NSOrderedSame)&&(![[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"10"]))
                {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:@"*"];
                    
                    [elementLabel setText:[NSString stringWithFormat:@"%@ %@", [attributeDict objectForKey:@"PromptText"],attributedString]];
                    [elementLabel setText:[[elementLabel.text stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""]];
                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]  initWithAttributedString: elementLabel.attributedText];
                    
                    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(text.length-2, 1)];
                    [elementLabel setAttributedText: text];
                    
                }
                
                else
                {
                    [elementLabel setText:[NSString stringWithFormat:@"%@", [attributeDict objectForKey:@"PromptText"]]];
                }
                
                
                [elementLabel setTextAlignment:NSTextAlignmentLeft];
                [elementLabel setNumberOfLines:0];
                [elementLabel setLineBreakMode:NSLineBreakByWordWrapping];
                fontsize = 14.0;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    fontsize = 24.0;
                [elementLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]];
                elementLabel.tag = tagNum;
                tagNum++;
                
                
                [formCanvas addSubview:elementLabel];
                
                if ([elementLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]}].width > self.frame.size.width - 80.0)
                {
                    elementLabelHeight = 20.0 * (fontsize / 14.0) * ((float)((int)([elementLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]}].width / (self.frame.size.width - 80.0))) + 1.0);
                    [elementLabel setFrame:CGRectMake(20, contentSizeHeight, self.frame.size.width - 40.0, elementLabelHeight)];
                    contentSizeHeight += (elementLabelHeight - 40.0);
                }
                int carriageReturns = 1;
                NSString *elementLabelTextSubstring = [NSString stringWithString:elementLabel.text];
                while (elementLabelTextSubstring.length > 0)
                {
                    int crPos = (int)[elementLabelTextSubstring rangeOfString:@"\n"].location;
                    if (crPos < elementLabelTextSubstring.length && crPos >= 0)
                    {
                        carriageReturns ++;
                        elementLabelTextSubstring = [elementLabelTextSubstring substringFromIndex:crPos + 1];
                    }
                    else
                        break;
                }
                if (carriageReturns > (int)(elementLabelHeight / 20.0))
                {
                    float carriageReturnHeightMultiplier = 20.0;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        carriageReturnHeightMultiplier *= (24.0 / 14.0);
                    elementLabelHeight += carriageReturnHeightMultiplier * (float)(carriageReturns - (int)(elementLabelHeight / 20.0));
                    [elementLabel setFrame:CGRectMake(20, contentSizeHeight, self.frame.size.width - 40.0, elementLabelHeight)];
                    contentSizeHeight += carriageReturnHeightMultiplier * (float)(carriageReturns - (int)(elementLabelHeight / 20.0));
                }
                
            }

            if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"1"])
            {
                EpiInfoTextField *tf;
                if (isCurrentPage)
                {
                    //ADD
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    
                    tf = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 1;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                //          [elementListArray addObject:epc];
                //          [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    tagNum++;
                    
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
                
                //          if (firstEdit == YES && isCurrentPage)
                //          {
                //              [self onLoadEleCheck];
                //          }
                /*END-CHECK*/
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                        NSLog(@"enb yes %ld",(long)tf.tag);
                        
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (self.dictionaryOfWordsArrays)
                    {
                        NSString *checkCodeFieldName = [self.dictionaryOfWordsArrays objectForKey:[attributeDict objectForKey:@"Name"]];
                        if (checkCodeFieldName)
                        {
                            [tf setCheckcode:[[CheckCode alloc] init]];
//                            [(CheckCode *)[tf checkcode] setTheWords:(NSArray *)checkCodeFieldName];
                        }
                    }
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                    //ADD
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [tf setIsReadOnly:YES];
                    [tf setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"2"])
            {
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"3"])
            {
                UppercaseTextField *tf;
                if (isCurrentPage)
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    
                    tf = [[UppercaseTextField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                }
                
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 3;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [tf setIsReadOnly:YES];
                    [tf setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"4"])
            {
                EpiInfoTextView *tf;
                if (isCurrentPage)
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    
                    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 160)];
                    [bg setBackgroundColor:[UIColor blackColor]];
                    /*VERIFY - SATYA*/
                    [formCanvas addSubview:bg];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [bg setFrame:CGRectMake(40, bg.frame.origin.y, MIN(1.5 * bg.frame.size.width, formCanvas.frame.size.width - 80), 160)];
                    tf = [[EpiInfoTextView alloc] initWithFrame:CGRectMake(bg.frame.origin.x + 1, bg.frame.origin.y + 1, bg.frame.size.width - 2, bg.frame.size.height - 2)];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 4;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor whiteColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 160;
                    [tf setDelegate:self];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    beginColumList = YES;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [tf setIsReadOnly:YES];
                    [tf setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"5"])
            {
                NumberField *tf;
                if (isCurrentPage)
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    
                    tf  = [[NumberField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 5;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    [alterTableElements setObject:@"real" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (self.dictionaryOfWordsArrays)
                    {
                        NSString *checkCodeFieldName = [self.dictionaryOfWordsArrays objectForKey:[attributeDict objectForKey:@"Name"]];
                        if (checkCodeFieldName)
                        {
                            [tf setCheckcode:[[CheckCode alloc] init]];
//                            [(CheckCode *)[tf checkcode] setTheWords:(NSArray *)checkCodeFieldName];
//                            [(CheckCode *)[tf checkcode] setDictionaryOfFields:self.dictionaryOfFields.nsmd];
                        }
                    }
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    if (seenFirstGeocodeField && ([[attributeDict objectForKey:@"Name"] isEqualToString:self.latitudeField] || [[attributeDict objectForKey:@"Name"] isEqualToString:self.longitudeField]))
                    {
                        contentSizeHeight += 40.0;
                        UIView *hideTheGeocodeCheckbox = [[UIView alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 5, 160, 30)];
                        geocodingCheckbox = [[Checkbox alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                        [(DataEntryViewController *)self.rootViewController setGeocodingCheckbox:geocodingCheckbox];
                        [hideTheGeocodeCheckbox addSubview:geocodingCheckbox];
                        UILabel *useDeviceLocation = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 120, 30)];
                        [useDeviceLocation setText:@"Use device location"];
                        [useDeviceLocation setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
                        [hideTheGeocodeCheckbox addSubview:useDeviceLocation];
                        [formCanvas addSubview:hideTheGeocodeCheckbox];
                    }
                    if ([[attributeDict objectForKey:@"Name"] isEqualToString:self.latitudeField] || [[attributeDict objectForKey:@"Name"] isEqualToString:self.longitudeField])
                        seenFirstGeocodeField = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ real", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [tf setIsReadOnly:YES];
                    [tf setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"6"])
            {
                PhoneNumberField *tf;
                if (isCurrentPage)
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    
                    tf  = [[PhoneNumberField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 6;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [tf setIsReadOnly:YES];
                    [tf setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"7"])
            {
                DateField *tf;
                if (isCurrentPage)
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    
                    tf = [[DateField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                    
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 7;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setFieldLabel:[attributeDict objectForKey:@"PromptText"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    [tf setTemplateFieldID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"FieldId"] intValue]]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [tf setIsReadOnly:YES];
                    [tf setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"8"])
            {
                TimeField *tf;
                if (isCurrentPage)
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    
                    tf = [[TimeField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 8;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
                
                /*END-CHECK*/
                
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [tf setIsReadOnly:YES];
                    [tf setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"9"])
            {
                DateTimeField *tf;
                if (isCurrentPage)
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    
                    tf = [[DateTimeField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 9;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [tf setIsReadOnly:YES];
                    [tf setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"10"])
            {
                Checkbox *cb;
                if (isCurrentPage)
                {
                    float fieldWidth = 768 - 100;
                    float checkboxLines = 3.0;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 260.0)
                        fieldWidth = 260.0;
                    else
                    {
                        fontsize = 24.0;
                        checkboxLines = 2.0;
                    }
                    [elementLabel setFrame:CGRectMake(60, contentSizeHeight - 10, fieldWidth, 60)];
                    while ([elementLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]}].width > checkboxLines * (fieldWidth - 18))
                        fontsize -= 0.1;
                    [elementLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]];
                    
                    cb = [[Checkbox alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 5, 30, 30)];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [cb setFrame:CGRectMake(40, cb.frame.origin.y, 30, 30)];
                        [elementLabel setFrame:CGRectMake(80, contentSizeHeight - 20, fieldWidth, 80)];
                    }
                    
                    /*CHECK*/
                    
                    cb.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 10;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [cb setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [cb setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [cb hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [cb hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [cb setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [cb setBackgroundColor:[UIColor blackColor]];
                    }
                    
                    [formCanvas addSubview:cb];
                    [alterTableElements setObject:@"integer" forKey:[attributeDict objectForKey:@"Name"]];
                    [cb setColumnName:[attributeDict objectForKey:@"Name"]];
                    [cb setCheckboxAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    //        [self.checkboxes setObject:@"A" forKey:[attributeDict objectForKey:@"Name"]];
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:cb forKey:[attributeDict objectForKey:@"Name"]];
                    if (self.dictionaryOfWordsArrays)
                    {
                        NSString *checkCodeFieldName = [self.dictionaryOfWordsArrays objectForKey:[attributeDict objectForKey:@"Name"]];
                        if (checkCodeFieldName)
                        {
                            [cb setCheckcode:[[CheckCode alloc] init]];
//                            [(CheckCode *)[cb checkcode] setTheWords:(NSArray *)checkCodeFieldName];
                        }
                    }
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ integer", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [cb setIsReadOnly:YES];
                    [cb setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"11"])
            {
                YesNo *yn;
                if (isCurrentPage)
                {
                    yn = [[YesNo alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180)];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [yn setFrame:CGRectMake(20, yn.frame.origin.y, yn.frame.size.width, yn.frame.size.height)];
                    
                    /*CHECK*/
                    
                    yn.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 11;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [yn setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [yn setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [yn hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [yn hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [yn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [yn setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:yn];
                    contentSizeHeight += [yn contentSizeHeightAdjustment];
                    [alterTableElements setObject:@"integer" forKey:[attributeDict objectForKey:@"Name"]];
                    [yn setColumnName:[attributeDict objectForKey:@"Name"]];
                    [yn setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:yn forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ integer", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [yn setIsReadOnly:YES];
                    [yn setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"15"])
            {
                MirrorField *tf;
                if (isCurrentPage)
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    
                    tf = [[MirrorField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 15;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    [tf setSourceFieldID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"SourceFieldId"] intValue]]];
                    [tf setEnabled:NO];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"17"])
            {
                LegalValuesEnter *lv;
                if (isCurrentPage)
                {
                    lv = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
                    
                    /*CHECK*/
                    
                    lv.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 17;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
                
                /*END-CHECK*/
                
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [lv setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [lv setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [lv hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [lv hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [lv setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [lv setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:lv];
                    contentSizeHeight += [lv contentSizeHeightAdjustment];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [lv setColumnName:[attributeDict objectForKey:@"Name"]];
                    // Add the array of values to the root view controller's legal values dictionary
                    if ([legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]])
                    {
                        [legalValuesDictionaryForRVC setObject:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]] forKey:[lv.columnName lowercaseString]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [lv setIsReadOnly:YES];
                    [lv setIsEnabled:NO];
                }
           }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"18"])
            {
                EpiInfoCodesField *lv;
                if (isCurrentPage)
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
                    
                    lv = [[EpiInfoCodesField alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:oddArray];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
                    [lv setTextColumnValues:evenArray];
                    
                    /*CHECK*/
                    
                    lv.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 18;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [lv setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [lv setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [lv hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [lv hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [lv setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [lv setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:lv];
                    contentSizeHeight += 160;
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [lv setColumnName:[attributeDict objectForKey:@"Name"]];
                    [lv setTextColumnName:[attributeDict objectForKey:@"TextColumnName"]];
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [lv setIsReadOnly:YES];
                    [lv setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"19"])
            {
                CommentLegal *lv;
                if (isCurrentPage)
                {
                    lv = [[CommentLegal alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
                    
                    /*CHECK*/
                    
                    lv.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 19;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
               
                /*END-CHECK*/
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [lv setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [lv setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [lv hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [lv hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [lv setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [lv setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:lv];
                    contentSizeHeight += [lv contentSizeHeightAdjustment];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [lv setColumnName:[attributeDict objectForKey:@"Name"]];
                    if ([legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]])
                    {
                        [legalValuesDictionaryForRVC setObject:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]] forKey:[lv.columnName lowercaseString]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
                    [self.dictionaryOfCommentLegals setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [lv setIsReadOnly:YES];
                    [lv setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"14"])
            {
                EpiInfoImageField *iv;
                if (isCurrentPage)
                {
                    iv = [[EpiInfoImageField alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 120, 120)];
                    [iv setColumnName:[attributeDict objectForKey:@"Name"]];
                    [iv setBackgroundImage:[UIImage imageNamed:@"iconCDC_for_image_field"] forState:UIControlStateNormal];
                    if (isCurrentPage)
                    {
                        if ([self isEnableName:epc.elementName])
                        {
                            [iv setUserInteractionEnabled:NO];
                            NSLog(@"enb no");
                        }
                        else
                        {
                            [iv setUserInteractionEnabled:YES];
                        }
                        if ([self ishideName:epc.elementName])
                        {
                            [iv hideByHeight:YES];
                            NSLog(@"hide yes");
                            
                        }
                        else
                        {
                            [iv hideByHeight:NO];
                        }
                        if ([self ishighlightName:epc.elementName])
                        {
                            [iv setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                            NSLog(@"hig yes");
                            
                        }
                        else
                        {
                            [iv setBackgroundColor:[UIColor clearColor]];
                        }
                        
                        [formCanvas addSubview:iv];
                    }
                    /*CHECK*/
                    
                    iv.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 14;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
                
                /*END-CHECK*/
                
                if (isCurrentPage)
                {
                    [self.dictionaryOfFields setObject:iv forKey:[attributeDict objectForKey:@"Name"]];
                    contentSizeHeight += 120;
                }
                
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];

            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"12"])
            {
                EpiInfoOptionField *lv;
                if (isCurrentPage)
                {
                    NSString *list = [attributeDict objectForKey:@"List"];
                    int pipes = (int)[list rangeOfString:@"||"].location;
                    NSString *valuesList = [list substringToIndex:pipes];
                    NSArray *nsaFromValuesList = [NSArray arrayWithArray:[valuesList componentsSeparatedByString:@","]];
                    NSMutableArray *nsmaFromValuesList = [[NSMutableArray alloc] init];
                    [nsmaFromValuesList addObject:@""];
                    for (int q = 0; q < nsaFromValuesList.count; q++)
                        [nsmaFromValuesList addObject:(NSString *)[nsaFromValuesList objectAtIndex:q]];
                    
                    lv = [[EpiInfoOptionField alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:nsmaFromValuesList];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
                    
                    /*CHECK*/
                    
                    lv.tag = tagNum;
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 12;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
                
                /*END-CHECK*/
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [lv setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [lv setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [lv hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [lv hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [lv setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [lv setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:lv];
                    contentSizeHeight += 160;
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [lv setColumnName:[attributeDict objectForKey:@"Name"]];
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [lv setIsReadOnly:YES];
                    [lv setIsEnabled:NO];
                }
           }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"25"])
            {
                EpiInfoUniqueIDField *tf;
                if (isCurrentPage)
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    
                    tf = [[EpiInfoUniqueIDField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                }
                BOOL required;
                //SET to NO always
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = NO;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 25;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
                
                /*END-CHECK*/
                
                if (isCurrentPage)
                {
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                if ([[attributeDict objectForKey:@"IsReadOnly"]caseInsensitiveCompare:@"true"] == NSOrderedSame)
                {
                    [tf setIsReadOnly:YES];
                    [tf setIsEnabled:NO];
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"20"])
            {
                RelateButton *tf;
                if (isCurrentPage)
                {
                    tf = [[RelateButton alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 240, 40)];
                    [tf.layer setCornerRadius:4.0];
                    [tf setTitle:[attributeDict objectForKey:@"PromptText"] forState:UIControlStateNormal];
                    if ([attributeDict objectForKey:@"RelatedViewName"])
                        [tf setRelatedViewName:[attributeDict objectForKey:@"RelatedViewName"]];
                    else
                        [tf setEnabled:NO];
                    if ([attributeDict objectForKey:@"Name"])
                        [tf setRelateButtonName:[attributeDict objectForKey:@"Name"]];
                    [tf setParentEDV:self];
                    
                    /*CHECK*/
                    
                    tf.tag = tagNum;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                BOOL required;
                if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                {
                    required = YES;
                }
                else
                {
                    required = NO;
                }
                epc.req = required;
                epc.elementName = [attributeDict objectForKey:@"Name"];
                epc.type = 20;
                epc.tag = tagNum;
                epc.enable= YES;
                epc.hide = NO;
                epc.highlight = NO;
                epc.page = [attributeDict objectForKey:@"PageId"];
                tagNum++;
                epc.promptText = [attributeDict objectForKey:@"PromptText"];
                if (![elmArray containsObject:[[attributeDict objectForKey:@"Name"] lowercaseString]])
                {
                    
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                }
                else
                {
                    int indexofcontrol = (int)[elmArray indexOfObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    [(ElementsModel *)[elementListArray objectAtIndex:indexofcontrol] setTag:epc.tag];
                }
                
                /*END-CHECK*/
                
                if (isCurrentPage)
                {
                    if ([self isEnableName:epc.elementName])
                    {
                        [tf setUserInteractionEnabled:NO];
                        NSLog(@"enb no");
                    }
                    else
                    {
                        [tf setUserInteractionEnabled:YES];
                    }
                    if ([self ishideName:epc.elementName])
                    {
                        [tf hideByHeight:YES];
                        NSLog(@"hide yes");
                        
                    }
                    else
                    {
                        [tf hideByHeight:NO];
                    }
                    if ([self ishighlightName:epc.elementName])
                    {
                        [tf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1]];
                        NSLog(@"hig yes");
                        
                    }
                    else
                    {
                        [tf setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [elementLabel setHidden:YES];
                    
                }
            }
            else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"21"])
            {
                if (isCurrentPage)
                    contentSizeHeight -= 25.0;
                if (!arrayOfGroups)
                    arrayOfGroups = [[NSMutableArray alloc] init];
                if (!dictionaryOfGroupsAndLists)
                    dictionaryOfGroupsAndLists = [[NSMutableDictionary alloc] init];
                [arrayOfGroups addObject:[attributeDict objectForKey:@"Name"]];
                [dictionaryOfGroupsAndLists setObject:[attributeDict objectForKey:@"List"] forKey:[attributeDict objectForKey:@"Name"]];
            }
            else
            {
                //                                NSLog(@"%@", [attributeDict objectForKey:@"FieldTypeId"]);
                [elementLabel setHidden:YES];
            }
            
            if (isCurrentPage)
            {
                contentSizeHeight += 60.0;
            }
        }
        else if ([elementName isEqualToString:@"Field"] && [[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"19"])
        {
            if (isCurrentPage)
            {
                CommentLegal *lv = [[CommentLegal alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]]];
                [self.dictionaryOfCommentLegals setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
            }
        }
    }
    
    for (id key in attributeDict)
    {
        if ([key isEqualToString:@"Name"] || [key isEqualToString:@"PromptText"] || [key isEqualToString:@"FieldTypeId"])
        {
            dataText = [dataText stringByAppendingString:[NSString stringWithFormat:@"\n\t\t%@ = %@", key, [attributeDict objectForKey:key]]];
        }
    }
    
    // Set up any mirroring
    for (UIView *v in [formCanvas subviews])
    {
        if ([v isKindOfClass:[MirrorField class]])
            for (UIView *v0 in [formCanvas subviews])
            {
                if ([v0 isKindOfClass:[DateField class]])
                    if ([(DateField *)v0 templateFieldID] && [[(DateField *)v0 templateFieldID] intValue] == [[(MirrorField *)v sourceFieldID] intValue])
                    {
                        [(DateField *)v0 setMirroringMe:(MirrorField *)v];
                        [v setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, v0.frame.size.width, v0.frame.size.height)];
                    }
            }
        else if ([v isKindOfClass:[EpiInfoCodesField class]])
            for (UIView *v0 in [formCanvas subviews])
            {
                if ([v0 isKindOfClass:[EpiInfoTextField class]])
                    if ([[(EpiInfoTextField *)v0 columnName] isEqualToString:[(EpiInfoCodesField *)v textColumnName]])
                        [(EpiInfoCodesField *)v setTextColumnField:(EpiInfoTextField *)v0];
            }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
    } completion:^(BOOL finished){
        hasAFirstResponder = NO;
    }];
    NSLog(@" ------------------------- %f, %f",self.contentSize.width, self.contentSize.height - 200.0);
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (hasAFirstResponder)
        return YES;
    
    [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height + 200.0)];
    NSLog(@"%f, %f -------------------------",self.contentSize.width, self.contentSize.height + 200.0);
    hasAFirstResponder = YES;
    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (hasAFirstResponder)
        return YES;
    
    [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height + 200.0)];
    NSLog(@"%f, %f -------------------------",self.contentSize.width, self.contentSize.height + 200.0);
    
    hasAFirstResponder = YES;
    
    return YES;
}

- (void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"executeGOTOs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    updatevisibleScreenOnly = NO;
    if (guidBeingUpdated)
        updatevisibleScreenOnly = YES;
    [self clearButtonPressed];
    [(DataEntryViewController *)self.rootViewController setUpdateExistingRecord:YES];
    if (geocodingCheckbox)
        [geocodingCheckbox reset];
    
    queriedColumnsAndValues = [[NSMutableDictionary alloc] init];
    
    NSString *tableName = [tableNameAndGUID objectAtIndex:0];
    NSString *guid = [tableNameAndGUID objectAtIndex:1];
    guidBeingUpdated = guid;
    newRecordGUID = nil;
    tableBeingUpdated = tableName;
    recordUIDForUpdate = guid;
    guidBeingUpdated = guid;
    for (id key in dictionaryOfPages)
    {
        [(EnterDataView *)[dictionaryOfPages objectForKey:key] setRecordUIDForUpdate:guid];
        [(EnterDataView *)[dictionaryOfPages objectForKey:key] setTableBeingUpdated:tableName];
        [(EnterDataView *)[dictionaryOfPages objectForKey:key] setNewRecordGUID:newRecordGUID];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
    {
        NSString *selStmt = [NSString stringWithFormat:@"select * from %@ where globalrecordid = '%@'", tableName, guid];
        
        const char *query_stmt = [selStmt UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int i = 0;
                while (sqlite3_column_name(statement, i))
                {
                    NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                    if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                    {
                        i++;
                        continue;
                    }
                    [queriedColumnsAndValues setObject:[NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]] forKey:[columnName lowercaseString]];
                    i++;
                }
                break;
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(epiinfoDB);
    
    // New code for sepatrating pages
    if (!dictionaryOfPages)
    {
        dictionaryOfPages = [[NSMutableDictionary alloc] init];
        [dictionaryOfPages setObject:self forKey:[NSString stringWithFormat:@"Page%d", pageToDisplay]];
    }

    for (id key in dictionaryOfPages)
    {
        if (updatevisibleScreenOnly && ![(NSString *)key isEqualToString:[NSString stringWithFormat:@"Page%d", pageToDisplay]])
            continue;
        
        EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
        for (UIView *v in [[tempedv formCanvas] subviews])
        {
            if ([v conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                if (![queriedColumnsAndValues objectForKey:[[(id<EpiInfoControlProtocol>)v columnName] lowercaseString]])
                    continue;
            if ([v isKindOfClass:[EpiInfoTextField class]])
                [(EpiInfoTextField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(EpiInfoTextField *)v columnName] lowercaseString]]];
            else if ([v isKindOfClass:[EpiInfoTextView class]])
                [(EpiInfoTextView *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(EpiInfoTextView *)v columnName] lowercaseString]]];
            else if ([v isKindOfClass:[EpiInfoImageField class]])
            {
                [(EpiInfoImageField *)v assignValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(EpiInfoTextView *)v columnName] lowercaseString]]];
            }
            else if ([v isKindOfClass:[Checkbox class]])
                [(Checkbox *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(Checkbox *)v columnName] lowercaseString]]];
            else if ([v isKindOfClass:[YesNo class]])
                [(YesNo *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(YesNo *)v columnName] lowercaseString]]];
            else if ([v isKindOfClass:[NumberField class]])
                [(NumberField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(NumberField *)v columnName] lowercaseString]]];
            else if ([v isKindOfClass:[PhoneNumberField class]])
                [(PhoneNumberField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(PhoneNumberField *)v columnName] lowercaseString]]];
            else if ([v isKindOfClass:[DateField class]])
                [(DateField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(DateField *)v columnName] lowercaseString]]];
            else if ([v isKindOfClass:[UppercaseTextField class]])
                [(UppercaseTextField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(UppercaseTextField *)v columnName] lowercaseString]]];
            else if ([v isKindOfClass:[LegalValuesEnter class]])
            {
                [(LegalValuesEnter *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(LegalValuesEnter *)v columnName] lowercaseString]]];
                [(LegalValuesEnter *)v setPicked:(NSString *)[queriedColumnsAndValues objectForKey:[[(LegalValuesEnter *)v columnName] lowercaseString]]];
            }
            else
                continue;
            if ([v conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                [self.fieldsAndStringValues setObject:[(id<EpiInfoControlProtocol>)v epiInfoControlValue] forKey:[(id<EpiInfoControlProtocol>)v columnName]];
            if ([v conformsToProtocol:@protocol(EpiInfoControlProtocol)])
            {
                if ([[self.fieldsAndStringValues objectForKey:[(id<EpiInfoControlProtocol>)v columnName]] isEqualToString:@""])
                {
                    [self.fieldsAndStringValues setObject:[(id<EpiInfoControlProtocol>)v epiInfoControlValue] forKey:[(id<EpiInfoControlProtocol>)v columnName]];
                }
                else
                {
                    [(id<EpiInfoControlProtocol>)v assignValue:[self.fieldsAndStringValues objectForKey:[(id<EpiInfoControlProtocol>)v columnName]]];
                }
            }
        }
        for (UIView *v in [tempedv subviews])
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                if ([(UIButton *)v tag] == 1 && v.frame.size.width > 40)
                {
                    [(UIButton *)v setTag:8];
                    if ([(UIButton *)v isEnabled])
                        [(UIButton *)v setImage:[UIImage imageNamed:@"UpdateButton.png"] forState:UIControlStateNormal];
                }
                if ([(UIButton *)v tag] == 7 && v.frame.size.width > 40)
                {
                    [(UIButton *)v setHidden:NO];
                }
            }
        }
        [(DataEntryViewController *)self.rootViewController setFooterBarToUpdate];
    }
    [self checkElements:[NSString stringWithFormat:@"%d", pageToDisplay] from:@"before" page:[NSString stringWithFormat:@"%d", pageToDisplay]];
    
    for (id pageskey in self.dictionaryOfPages)
    {
        if ([[self.dictionaryOfPages objectForKey:pageskey] superview])
        {
            NSLog(@"");
            [(EnterDataView *)[self.dictionaryOfPages objectForKey:pageskey] syncPageDots];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"executeGOTOs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fieldBecameFirstResponder:(id)field
{
    if ([field isKindOfClass:[DateField class]])
    {
        DateField *dateField = (DateField *)field;
//        NSLog(@"%@ became first responder", [dateField columnName]);
        [self checkDialogs:[dateField columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[dateField columnName] from:@"before" page:pageName];
    }
    
    if ([field isKindOfClass:[EpiInfoTextField class]])
    {
        EpiInfoTextField *etf = (EpiInfoTextField *)field;
        //  NSLog(@"%@",[etf columnName]);
        
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[EpiInfoTextView class]])
    {
        EpiInfoTextView *etf = (EpiInfoTextView *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[UppercaseTextField class]])
    {
        UppercaseTextField *etf = (UppercaseTextField *)field;
        //NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[NumberField class]])
    {
        NumberField *etf = (NumberField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[PhoneNumberField class]])
    {
        PhoneNumberField *etf = (PhoneNumberField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[TimeField class]])
    {
        TimeField *etf = (TimeField *)field;
        NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[DateTimeField class]])
    {
        [self resignAll];
        DateTimeField *etf = (DateTimeField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[EpiInfoOptionField class]])
    {
        EpiInfoOptionField *etf = (EpiInfoOptionField *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[LegalValuesEnter class]])
    {
        LegalValuesEnter *etf = (LegalValuesEnter *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[EpiInfoUniqueIDField class]])
    {
        EpiInfoUniqueIDField *etf = (EpiInfoUniqueIDField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[Checkbox class]])
    {
        Checkbox *etf = (Checkbox *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    if ([field isKindOfClass:[YesNo class]])
    {
        YesNo *etf = (YesNo *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] from:@"before" page:pageName];
        
    }
    
}

- (void)fieldResignedFirstResponder:(id)field
{
    if ([field isKindOfClass:[DateField class]])
    {
        DateField *dateField = (DateField *)field;
        NSLog(@"%@ resigned first responder", [dateField columnName]);
        [self checkDialogs:[dateField columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[dateField columnName] from:@"after" page:pageName];
        
    }
    
    if ([field isKindOfClass:[EpiInfoTextField class]])
    {
        EpiInfoTextField *etf = (EpiInfoTextField *)field;
        //  NSLog(@"%@",[etf columnName]);
        
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
        /*If-EndIf*/
        //Add if-endIf text value to array here
        
        ElementsModel *emc = [[ElementsModel alloc]init];
    
        emc.fieldValue = etf.text;
        
       NSUInteger idx = [elementListArray indexOfObject:etf.columnName];
        idx = idx;
//        [elementsArray replaceObjectAtIndex:idx withObject:emc];
        
        /*End of if-EndIf*/
        
    }
    if ([field isKindOfClass:[EpiInfoTextView class]])
    {
        EpiInfoTextView *etf = (EpiInfoTextView *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[UppercaseTextField class]])
    {
        UppercaseTextField *etf = (UppercaseTextField *)field;
        //NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[NumberField class]])
    {
        NumberField *etf = (NumberField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[PhoneNumberField class]])
    {
        PhoneNumberField *etf = (PhoneNumberField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[TimeField class]])
    {
        [self resignAll];
        TimeField *etf = (TimeField *)field;
        NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[DateTimeField class]])
    {
        DateTimeField *etf = (DateTimeField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[EpiInfoOptionField class]])
    {
        EpiInfoOptionField *etf = (EpiInfoOptionField *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[LegalValuesEnter class]])
    {
        LegalValuesEnter *etf = (LegalValuesEnter *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[EpiInfoUniqueIDField class]])
    {
        EpiInfoUniqueIDField *etf = (EpiInfoUniqueIDField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[Checkbox class]])
    {
        Checkbox *etf = (Checkbox *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
    if ([field isKindOfClass:[YesNo class]])
    {
        YesNo *etf = (YesNo *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"after" from:@"field"];
        [self checkElements:[etf columnName] from:@"after" page:pageName];
        
    }
}

- (void)checkboxChanged:(Checkbox *)checkbox
{
    NSLog(@"%@ changed", [checkbox columnName]);
    [self checkDialogs:[checkbox columnName] Tag:1 type:1 from:@"after" from:@"field"];
    [self checkElements:[checkbox columnName] from:@"after" page:pageName];
    
}

- (NSString *)fixPageIdValues:(NSMutableString *)xmlText
{
    int substringStartPosition = 0;
    int pageNumber = 1;
    while ([[xmlText substringFromIndex:substringStartPosition] containsString:@"<Page "])
    {
        substringStartPosition += (int)[[xmlText substringFromIndex:substringStartPosition] rangeOfString:@"<Page "].location;
        substringStartPosition += (int)[[xmlText substringFromIndex:substringStartPosition] rangeOfString:@"PageId=\""].location + 8;
        NSString *pageNumberString = [NSString stringWithFormat:@"%d", pageNumber++];
        int relativePositionOfSecondQuote = (int)[[xmlText substringFromIndex:substringStartPosition] rangeOfString:@"\""].location;
        substringStartPosition += relativePositionOfSecondQuote + 1;
        NSString *actualPageString = [NSString stringWithFormat:@" ActualPageNumber=\"%@\"", pageNumberString];
        int actualPageStringLength = (int)[actualPageString length];
        [xmlText insertString:actualPageString atIndex:substringStartPosition];
        substringStartPosition += actualPageStringLength;
    }
    return [NSString stringWithString:xmlText];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case 0:
            switch (buttonIndex) {
                case 0:
                    break;
                    
                case 1:
                    [self submitButtonPressed];
                    break;
            }
            break;
            
        case 1:
            switch (buttonIndex) {
                case 0:
                    break;
                    
                case 1:
                    [self updateButtonPressed];
                    break;
            }
            break;
            
        case 2:
            switch (buttonIndex) {
                case 0:
                    break;
                    
                case 1:
                    [self deleteButtonPressed];
                    break;
            }
            break;
            
        case 3:
            switch (buttonIndex) {
                case 0:
                    break;
                    
                case 1:
                    updatevisibleScreenOnly = NO;
                    [self clearButtonPressed];
                    break;
            }
            break;
            
        default:
            break;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark "CheckCode"

/*CheckCode*/

-(void)copyToArray:(NSMutableArray *)eleArray
{
    if (elementsArray.count<1) {
        elementsArray = [[NSMutableArray alloc]init];
        elementsArray = eleArray;
    }
    if(elementListArray.count<1)
    {
        elementListArray = [[NSMutableArray alloc]init];
        elmArray = [[NSMutableArray alloc]init];
        requiredArray = [[NSMutableArray alloc]init];
        require = 0;
        valid = 0;
    }
}

#pragma mark parse and track
/*KeyWords Parsing*/

- (void)getAssign
{
    NSLog(@"getAssign method");
    ElementPairsCheck *epc = [[ElementPairsCheck alloc]init];
    if (assignArray.count<1)
    {
        assignArray = [[NSMutableArray alloc]init];
    }
    if (elementsArray.count<1)
    {
        elementsArray = [ccp sendArray];
        
    }
    for (int i=0; i<elementsArray.count; i++)
    {
        epc = [elementsArray objectAtIndex:i];
        NSString *conditionWord;
        NSString *conditionWordOne;
        NSUInteger count = [self numberOfWordsInString:epc.name];
        conditionWord= [[[epc.name componentsSeparatedByString:@" "] objectAtIndex:0]lowercaseString];
        if (count>1) {
            NSRange range = [epc.name rangeOfString:conditionWord];
            conditionWordOne=[epc.name stringByReplacingCharactersInRange:range withString:@""];
            conditionWordOne = [[self removeSp:conditionWordOne]lowercaseString];
            
        }
        conditionWordOne=[[conditionWordOne stringByReplacingOccurrencesOfString:@" Before" withString:@""]stringByReplacingOccurrencesOfString:@" before" withString:@""];
        
        NSString *elmt;
        NSString *lastElmt;
        NSString *eleSp= [[self removeSp:epc.stringValue]lowercaseString];
        NSArray *arrayOfStatements = [eleSp componentsSeparatedByString:@"<linefeed>"];
        for (NSString *eleSp in arrayOfStatements)
        {
            for (int j = 0; j<1; j++)
            {
                elmt = [[[self removeSp:eleSp] componentsSeparatedByString:@" "]objectAtIndex:j];
                
                // NSLog(@"Satya - %@ %d",elmt,j);
                
                if (![elmt isEqualToString:@""] && elmt)
                {
                    if ([self checkKeyWordArray:elmt])
                    {
                        if ([elmt isEqualToString:@"assign"])
                        {
                            NSMutableString *assignmentMutableString = [NSMutableString stringWithString:[[[self removeSp:eleSp] componentsSeparatedByString:@"="] objectAtIndex:1]];
                            while ([assignmentMutableString characterAtIndex:0] == ' ')
                                [assignmentMutableString deleteCharactersInRange:NSMakeRange(0, 1)];
                            
                            AssignModel *aModel = [[AssignModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[[self removeSp:eleSp] componentsSeparatedByString:@" "]objectAtIndex:j+1] assignment:[NSString stringWithString:assignmentMutableString] beforeAfter:epc.condition condition:@"assign"];
                            [assignArray addObject:aModel];
                            lastElmt = @"assign";
                            j++;
                            
                        }
                    }
                }
            }
        }
    }
}

-(void)getIfs
{
    NSLog(@"getIfs method");
    ElementPairsCheck *epc = [[ElementPairsCheck alloc]init];
    if (ifsArray.count<1)
    {
        ifsArray = [[NSMutableArray alloc]init];
    }
    if (elementsArray.count<1)
    {
        elementsArray = [ccp sendArray];
        
    }
    // Next two lines are to prevent repeated items in ifsArray
    if (ifsArray.count > 0)
        return;
    for (int i=0; i<elementsArray.count; i++)
    {
        epc = [elementsArray objectAtIndex:i];
        NSString *eleSp= [self removeSp:epc.stringValue];
//        NSArray *arrayOfWords = [eleSp componentsSeparatedByString:@" "];
        NSArray *aoifs = [self arrayOfIFs:eleSp];
        if (aoifs.count > 0)
        {
            for (int j = 0; j < aoifs.count; j++)
            {
                ElementPairsCheck *epc0 = [[ElementPairsCheck alloc] init];
                NSMutableString *epc0StringValue = [NSMutableString stringWithString:[[[[aoifs objectAtIndex:j] stringByReplacingOccurrencesOfString:@"(.)" withString:@"\"\""] stringByReplacingOccurrencesOfString:@"OR" withString:@"or"] stringByReplacingOccurrencesOfString:@"AND" withString:@"and"]];
                NSString *epc0StringValueLC = [epc0StringValue lowercaseString];
                
                // Replace not-all-caps end-if with END-IF
                NSRange searchRange = NSMakeRange(0, epc0StringValueLC.length);
                NSRange foundRange;
                while (searchRange.location < epc0StringValueLC.length)
                {
                    searchRange.length = epc0StringValueLC.length - searchRange.location;
                    foundRange = [epc0StringValueLC rangeOfString:@"end-if" options:nil range:searchRange];
                    if (foundRange.location != NSNotFound)
                    {
                        [epc0StringValue replaceCharactersInRange:foundRange withString:@"END-IF"];
                        searchRange.location = foundRange.location + foundRange.length;
                    } else
                    {
                        // no more substring to find
                        break;
                    }
                }
                epc0.name = epc.name;
                epc0.condition = epc.condition;
                epc0.stringValue = [NSString stringWithString:epc0StringValue ];
                [ifsArray addObject:epc0];
            }
        }
    }
}

-(NSArray *)arrayOfIFs:(NSString *)ifString
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    NSMutableString *nsms = [[NSMutableString alloc] init];
    
    NSArray *words = [ifString componentsSeparatedByString:@" "];
    int ifcount = 0;
    
    for (int i = 0; i < words.count; i++)
    {
        if ([[[words objectAtIndex:i] lowercaseString] isEqualToString:@"if"])
        {
            ifcount++;
        }
        if (ifcount > 0)
            [nsms appendString:[NSString stringWithFormat:@" %@", [words objectAtIndex:i]]];
        if ([[[words objectAtIndex:i] lowercaseString] isEqualToString:@"end-if"])
        {
            ifcount--;
            if (ifcount == 0)
            {
                [nsma addObject:[NSString stringWithString:[nsms substringFromIndex:1]]];
                nsms = [[NSMutableString alloc] init];
            }
        }
    }
    
    return [NSArray arrayWithArray:nsma];
}

-(void)getDisEnb
{
    ElementPairsCheck *epc = [[ElementPairsCheck alloc]init];
    if (conditionsArray.count<1) {
        conditionsArray = [[NSMutableArray alloc]init];
        
    }
    if (elementsArray.count<1) {
        elementsArray = [ccp sendArray];
        
    }
    for (int i=0; i<elementsArray.count; i++)
    {
        epc = [elementsArray objectAtIndex:i];
        NSString *conditionWord;
        NSString *conditionWordOne;
        NSUInteger count = [self numberOfWordsInString:epc.name];
        conditionWord= [[[epc.name componentsSeparatedByString:@" "] objectAtIndex:0]lowercaseString];
        if (count>1) {
            NSRange range = [epc.name rangeOfString:conditionWord];
            conditionWordOne=[epc.name stringByReplacingCharactersInRange:range withString:@""];
            conditionWordOne = [[self removeSp:conditionWordOne]lowercaseString];
            
        }
        conditionWordOne=[[conditionWordOne stringByReplacingOccurrencesOfString:@" Before" withString:@""]stringByReplacingOccurrencesOfString:@" before" withString:@""];
        
        NSString *elmt;
        NSString *lastElmt;
        int eleCount = (int)[self numberOfWordsInString:epc.stringValue];
        NSString *eleSp= [[[self removeSp:epc.stringValue] stringByReplacingOccurrencesOfString:@"<LINEFEED>" withString:@""] lowercaseString];
        for (int j = 0; j<eleCount; j++) {
            elmt = [[eleSp componentsSeparatedByString:@" "]objectAtIndex:j];
            
            // NSLog(@"Satya - %@ %d",elmt,j);
            
            if (![elmt isEqualToString:@""] && elmt)
            {
                if ([self checkKeyWordArray:elmt])
                {
                    if ([elmt isEqualToString:@"disable"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"disable"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"disable";
                        j++;
                        
                    }
                    else if ([elmt isEqualToString:@"enable"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"enable"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"enable";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"set-required"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"required"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"required";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"set-not-required"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"notrequired"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"notrequired";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"highlight"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"highlight"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"highlight";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"unhighlight"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"unhighlight"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"unhighlight";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"goto"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"goto"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"goto";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"clear"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"clear"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"clear";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"hide"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"hidden"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"hidden";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"unhide"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"unhidden"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"unhidden";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"execute"])
                    {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:eleSp beforeAfter:epc.condition condition:@"unhidden"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"unhidden";
                        j++;
                        j++;
                    }
                    else if ([elmt isEqualToString:@"if"])
                    {
                        break;
                    }
                    
                }
                
                else
                {
                    ConditionsModel *cModel = [[ConditionsModel alloc]initWithPage:pageName from:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j] beforeAfter:epc.condition condition:lastElmt];
                    [conditionsArray addObject:cModel];
                }
            }
            
            
            
        }
        
    }
    
}

/*Dialogs*/
-(void)getDialogs
{
    ElementPairsCheck *epc = [[ElementPairsCheck alloc]init];
    if (dialogArray.count<1) {
        dialogArray = [[NSMutableArray alloc]init];
        dialogListArray = [[NSMutableArray alloc]init];
        dialogTitleArray = [[NSMutableArray alloc]init];
    }
    if (elementsArray.count<1) {
        elementsArray = [ccp sendArray];
        
    }
    for (int i=0; i<elementsArray.count; i++)
    {
        epc = [elementsArray objectAtIndex:i];
        NSString *conditionWord;
        NSString *conditionWordOne;
        NSUInteger count = [self numberOfWordsInString:epc.name];
        conditionWord= [[[epc.name componentsSeparatedByString:@" "] objectAtIndex:0]lowercaseString];
        if (count>1) {
            NSRange range = [epc.name rangeOfString:conditionWord];
            conditionWordOne=[epc.name stringByReplacingCharactersInRange:range withString:@""];
            conditionWordOne = [[self removeSp:conditionWordOne]lowercaseString];
        }
        
        NSString *eleSp= [self removeSp:epc.stringValue];
        NSString *first = [[eleSp componentsSeparatedByString:@" "]objectAtIndex:0];
        
        if([first caseInsensitiveCompare:@"dialog"]==NSOrderedSame)
        {
            eleSp=[[[eleSp stringByReplacingOccurrencesOfString:@"DIALOG" withString:@"dialogTe"]stringByReplacingOccurrencesOfString:@"Dialog" withString:@"dialogTe"]stringByReplacingOccurrencesOfString:@"dialog" withString:@"dialogTe"];
            eleSp=[[[eleSp stringByReplacingOccurrencesOfString:@"TITLETEXT" withString:@"titletext"]stringByReplacingOccurrencesOfString:@"Titletext" withString:@"titletext"]stringByReplacingOccurrencesOfString:@"TitleText" withString:@"titletext"];
            
        }
        if([eleSp containsString:@"dialogTe"])
            
        {
            NSArray* dialogArraySingle = [eleSp componentsSeparatedByString: @"dialogTe"];
            for (int i=0; i<dialogArraySingle.count; i++) {
                
                NSString *item = [dialogArraySingle objectAtIndex:i];
                if ([item containsString:@"\""]) {
                    //[dialogArraySingle removeObject:item];
                    DialogModel *dmc = [[DialogModel alloc]initWithFrom:conditionWord name:conditionWordOne beforeAfter:epc.condition title:item subject:@"" displayed:NO];
                    
                    [dialogArray addObject:dmc];
                }
                
            }
        }
    }
    
    /*for (int j = 0; j<dialogArray.count; j++) {
     */
    // for (DialogModel *dmc in dialogArray) {
    for (int i =0; i<dialogArray.count; i++)
    {
        DialogModel *dmc = [dialogArray objectAtIndex:i];
        BOOL isFirst = FALSE;
        NSScanner *scanner = [NSScanner scannerWithString:dmc.title];
        NSString *tmp;
        NSMutableArray *target = [NSMutableArray array];
        
        
        while ([scanner isAtEnd] == NO)
        {
            [scanner scanUpToString:@"\"" intoString:NULL];
            [scanner scanString:@"\"" intoString:NULL];
            [scanner scanUpToString:@"\"" intoString:&tmp];
            if ([scanner isAtEnd] == NO)
            {
                if (isFirst == FALSE)
                {
                    [target addObject:tmp];
                    [scanner scanString:@"\"" intoString:NULL];
                    isFirst = TRUE;
                    dmc.subject = tmp;
                    [dialogArray replaceObjectAtIndex:i withObject:dmc];
                }
                else
                {
                    break;
                }
                
            }
        }
        NSString *tempo = dmc.title;
        NSString *replace=[NSString stringWithFormat:@"\"%@\"",dmc.subject];
        tempo = [tempo stringByReplacingOccurrencesOfString:replace withString:@""];
        //            NSLog(@"%@---%@",tempo,replace);
        tempo = [self removeSp:tempo];
        if ([[[tempo componentsSeparatedByString:@" "] objectAtIndex:0] containsString:@"titletext"])
            
        {
            //NSLog(@"%@",tempo);
            NSScanner *scanner = [NSScanner scannerWithString:tempo];
            NSString *tmp;
            
            while ([scanner isAtEnd] == NO)
            {
                [scanner scanUpToString:@"\"" intoString:NULL];
                [scanner scanString:@"\"" intoString:NULL];
                [scanner scanUpToString:@"\"" intoString:&tmp];
                if ([scanner isAtEnd] == NO)
                {
                    [scanner scanString:@"\"" intoString:NULL];
                    dmc.title = tmp;
                    [dialogArray replaceObjectAtIndex:i withObject:dmc];
                    
                }
            }
            
        }
        else
        {
            [dialogArray removeObjectAtIndex:i];
            i--;
        }
        
    }
    for (DialogModel *dmc in dialogArray) {
        if ([dmc.from isEqualToString:@"page"] &&[dmc.beforeAfter isEqualToString:@"after"]) {
            // NSLog(@"-----PAGE AFTER %@---------%@",dmc.from,dmc.name);
            [dialogListArray addObject:dmc.name];
        }
    }
    
}
/*Get IFs from ifArray*/


/*String Methods*/
- (NSUInteger)numberOfWordsInString:(NSString *)str
{
    NSArray *words = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger count = 0;
    for (NSString *word in words) {
        if (![word isEqualToString:@""])
            count++;
    }
    return count;
}

-(NSString *)removeSp:(NSString *)newStr
{
    NSString *tmp;
    
    tmp= [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newTmp = [tmp stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    return newTmp;
    
}

-(BOOL)checkKeyWordArray:(NSString *)str
{
    BOOL present =  NO;
    
    if ([keywordsArray containsObject:str]) {
        present = YES;
    }
    return present;
}

#pragma mark checkcode UI manipulations
/*Dialog Display*/

-(void)checkDialogs:(NSString *)name Tag:(NSInteger *)newTag type:(int)newType from:(NSString *)befAft from:(NSString *)newFrom
{
    //dialogTitleArray = [[NSMutableArray alloc]init];
    NSString *fromVal;
    for (int i = 0; i<dialogArray.count; i++)
    {
        DialogModel *dmc = [dialogArray objectAtIndex:i];
        if ([dmc.beforeAfter caseInsensitiveCompare:@"before"] == NSOrderedSame)
        {
            if (([dmc.name containsString:name]) &&  [befAft isEqualToString:dmc.beforeAfter]&& (dmc.displayed == NO))
            {
                //NSLog(@"%@---%@",dmc.name,name);
                [dialogTitleArray addObject:dmc.title];
                [dialogTitleArray addObject:dmc.subject];
                [dialogTitleArray addObject:[NSNumber numberWithInt:i]];
                
                fromVal = @"";
                
                //                alertBefore = FALSE;
                
            }
            
            
        }
        else if ([dmc.beforeAfter caseInsensitiveCompare:@"after"] == NSOrderedSame)
        {
            name =[name lowercaseString];
            //Fix page vs field compare
            if (([dmc.name isEqualToString:name]) &&  [befAft isEqualToString:dmc.beforeAfter] && (dmc.displayed == NO))
            {
                //                alertBefore = TRUE;
                
                [dialogTitleArray addObject:dmc.title];
                [dialogTitleArray addObject:dmc.subject];
                [dialogTitleArray addObject:[NSNumber numberWithInt:i]];
                fromVal = newFrom;
                
                //For Submit button
                if ([dialogListArray containsObject:dmc.name])
                {
                    [dialogListArray removeObject:dmc.name];
                }
                // break;
            }
            
            
            
        }
        
    }
    [self showAlertsQueuedTag:newTag];
}

/*Checkcode after page loads for multiple pages*/

-(void)onLoadEleCheck
{
    for (ElementsModel *emc in elementListArray)
    {
        //pageName
        if ([emc.page isEqualToString:pageName])
        {
            //            [self checkElements:emc.elementName from:@"before" page:emc.page];
            if (emc.enable == NO)
            {
                UIView *control = [self.dictionaryOfFields objectForKey:emc.elementName];
                if (!control)
                    continue;
                int controlTag = (int)control.tag;
                [self disable:controlTag type:emc.type];
            }
            if (emc.highlight == YES)
            {
                [self highlight:emc.tag type:emc.type];
            }
            if (emc.hide == YES)
            {
                [self hide:emc.tag type:emc.type];
            }
            if (emc.req == YES) {
                [self setLabelReqAfter:emc.elementName tag:emc.tag text:emc.promptText reqnot:YES];
            }
            if (emc.enable == YES)
            {
                UIView *control = [self.dictionaryOfFields objectForKey:emc.elementName];
                if (!control)
                    continue;
                int controlTag = (int)control.tag;
                [self enable:controlTag type:emc.type];
            }
            if (emc.highlight == NO)
            {
                [self unhighlight:emc.tag type:emc.type];
            }
            if (emc.hide == NO)
            {
                [self unhide:emc.tag type:emc.type];
            }
            if (emc.req == NO) {
                [self setLabelReqAfter:emc.elementName tag:emc.tag text:emc.promptText reqnot:NO];
            }
            
        }
    }
}

#pragma mark Boolean UI checks for checkcode

-(BOOL)isEnableName:(NSString *)newName
{
    newName = [newName lowercaseString];
    NSUInteger idx = [elmArray indexOfObject:newName];
    BOOL val = FALSE;
    if (idx != NSNotFound)
    {
        
        ElementsModel *emc = [elementListArray objectAtIndex:idx];
        
        if (emc.enable == NO)
        {
            val = true;
        }
        else
        {
            val = false;
        }
    }
    return val;
}


-(BOOL)ishighlightName:(NSString *)newName
{
    NSUInteger idx = [elmArray indexOfObject:newName];
    BOOL val= false;
    if (idx != NSNotFound)
    {
        
        ElementsModel *emc = [elementListArray objectAtIndex:idx];
        if (emc.highlight == YES)
        {
            val = true;
        }
        else
        {
            val = false;
        }
    }
    return val;
}



-(BOOL)ishideName:(NSString *)newName
{
    NSUInteger idx = [elmArray indexOfObject:newName];
    BOOL val = FALSE;
    if (idx != NSNotFound)
    {
        
        ElementsModel *emc = [elementListArray objectAtIndex:idx];
        if (emc.hide == YES)
        {
            val = true;
        }
        else
        {
            val = false;
        }
    }
    return val;
}

#pragma mark checkcode checkelements 

-(void)checkElements:(NSString *)name from:(NSString *)befAft page:(NSString *)newPage
//Tag:(NSInteger *)newTag type:(int)newType from:(NSString *)newFrom
{
    ConditionsModel *cpm = [[ConditionsModel alloc]init];
    AssignModel *am = [[AssignModel alloc] init];
    if (conditionsArray.count<1)
    {
        [self getDialogs];
        [self getDisEnb];
        [self getAssign];
        [self getIfs];
    }
    
    NSLog(@"COUNT %lu %lu",(unsigned long)elementListArray.count, (unsigned long)conditionsArray.count);
    for (cpm in conditionsArray)
    {
        counter++;
//        NSLog(@"counter is %d",counter);
        //        if ([cpm.page isEqualToString:newPage]) //Change to page
        // {
        if ([befAft isEqualToString:@"before"])
        {
            if([cpm.beforeAfter isEqualToString:@"before"])//check CM cond
            {
                if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame)) //check for element match
                {
                    if ([elmArray containsObject:cpm.element]) //check for elements list todo check elm array
                    {
                        NSUInteger idx = [elmArray indexOfObject:cpm.element];
                        ElementsModel *emc = [elementListArray objectAtIndex:idx];
                        NSLog(@"******%lu******",(unsigned long)conditionsArray.count);
                        if ([cpm.condition isEqualToString:@"enable"])
                        {
                            emc.enable = YES;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self enable:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"disable"])
                        {
                            emc.enable = NO;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self disable:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"highlight"])
                        {
                            emc.highlight = YES;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self highlight:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"unhighlight"])
                        {
                            emc.highlight = NO;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self unhighlight:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"goto"])
                        {
                            [self gotoFormField:emc.type tag:emc.tag];
                        }
                        if ([cpm.condition isEqualToString:@"clear"])
                        {
                            [self clear:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"hide"])
                        {
                            emc.hide = YES;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self hide:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"unhide"])
                        {
                            emc.hide = NO;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self unhide:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"required"])
                        {
                            if (emc.type == 10)
                            {
                                emc.req = NO;
                                [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            }
                            else
                            {
                                emc.req = YES;
                                [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            }
                        }
                        if ([cpm.condition isEqualToString:@"notrequired"])
                        {
                            emc.req = NO;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                        }
                    }
                }
            }
        }
        
        else if([befAft isEqualToString:@"after"])
        {
            if([cpm.beforeAfter isEqualToString:@"after"])
            {
                if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame))
                {
                    if ([elmArray containsObject:cpm.element]) //check for elements list todo check elm array
                    {
                        NSUInteger idx = [elmArray indexOfObject:cpm.element];
                        ElementsModel *emc = [elementListArray objectAtIndex:idx];
                        
                        if ([cpm.condition isEqualToString:@"enable"])
                        {
                            emc.enable = YES;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            NSLog(@"-ena--%@",emc.elementName);
                            UIView *control = [self.dictionaryOfFields objectForKey:emc.elementName];
                            int controlTag = (int)control.tag;
                            [self enable:controlTag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"disable"])
                        {
                            emc.enable = NO;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            NSLog(@"-dis--%@",emc.elementName);
                            UIView *control = [self.dictionaryOfFields objectForKey:emc.elementName];
                            int controlTag = (int)control.tag;
                            [self disable:controlTag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"highlight"])
                        {
                            emc.highlight = YES;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self highlight:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"unhighlight"])
                        {
                            emc.highlight = NO;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self unhighlight:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"goto"])
                        {
                            NSString *gotoFieldName = emc.elementName;
//                            id gotoField = [self.dictionaryOfFields objectForKey:gotoFieldName];
//                            [gotoField selfFocus];
//                            [self gotoFormField:emc.type tag:emc.tag];
                            BOOL pageAlreadyExists = NO;
                            int pageCurrentlyBeingDisplayed = 0;
                            int pageToWhichWeAreTurning = 0;
                            while (!pageAlreadyExists)
                            {
                                EnterDataView *edv0;
                                for (id key in self.dictionaryOfPages)
                                {
                                    edv0 = [self.dictionaryOfPages objectForKey:key];
                                    if ([edv0 superview])
                                        pageCurrentlyBeingDisplayed = [[(NSString *)key substringFromIndex:4] intValue];
                                    if ([edv0.dictionaryOfFields objectForKey:gotoFieldName])
                                    {
                                        [[edv0.dictionaryOfFields objectForKey:gotoFieldName] selfFocus];
                                        pageAlreadyExists = YES;
                                        pageToWhichWeAreTurning = [[(NSString *)key substringFromIndex:4] intValue];
                                    }
                                }
                                if (edv0 && !pageAlreadyExists)
                                {
                                    @try {
                                        [edv0 userSwipedToTheLeft];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Could not swipe left for some reason.");
                                        break;
                                    } @finally {
                                        //
                                    }
                                }
                                if (!edv0)
                                    break;
                            }
                            if (pageCurrentlyBeingDisplayed > 0 && pageToWhichWeAreTurning > 0)
                            {
                                if (pageToWhichWeAreTurning > pageCurrentlyBeingDisplayed)
                                {
                                    @try {
                                        for (int swipe = 0; swipe < pageToWhichWeAreTurning - pageCurrentlyBeingDisplayed; swipe++)
                                        {
                                            [(EnterDataView *)[self.dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", pageCurrentlyBeingDisplayed + swipe]] userSwipedToTheLeft];
                                        }
                                    } @catch (NSException *exception) {
                                        NSLog(@"Could not swipe left for some reason");
                                    } @finally {
                                        //
                                    }
                                }
                                else if (pageCurrentlyBeingDisplayed > pageToWhichWeAreTurning)
                                {
                                    @try {
                                        for (int swipe = 0; swipe < pageCurrentlyBeingDisplayed - pageToWhichWeAreTurning; swipe++)
                                        {
                                            [(EnterDataView *)[self.dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", pageCurrentlyBeingDisplayed - swipe]] userSwipedToTheRight];
                                        }
                                    } @catch (NSException *exception) {
                                        NSLog(@"Could not swipe right for some reason");
                                    } @finally {
                                        //
                                    }
                                }
                            }
                        }
                        if ([cpm.condition isEqualToString:@"clear"])
                        {
                            [self clear:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"hide"])
                        {
                            emc.hide = YES;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self hide:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"unhide"])
                        {
                            emc.hide = NO;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self unhide:emc.tag type:emc.type];
                        }
                        if ([cpm.condition isEqualToString:@"required"])
                        {
                            if (emc.type == 10)
                            {
                                emc.req = NO;
                                [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            }
                            else
                            {
                                emc.req = YES;
                                [elementListArray replaceObjectAtIndex:idx withObject:emc];
                                [self setLabelReqAfter:emc.elementName tag:emc.tag text:emc.promptText reqnot:YES];
                                
                            }
                            
                        }
                        if ([cpm.condition isEqualToString:@"notrequired"])
                        {
                            emc.req = NO;
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            [self setLabelReqAfter:emc.elementName tag:emc.tag text:emc.promptText reqnot:NO];
                            
                            
                        }
                    }
                    else if ([cpm.element caseInsensitiveCompare:@"execute nowaitforexit \"save\""] == NSOrderedSame)
                        [self submitOrUpdateWithoutClearing];
                }
            }
        }
        
        
        // }
    }
    // ASSIGN
    NSLog(@"COUNT %lu %lu",(unsigned long)elementListArray.count, (unsigned long)assignArray.count);
    for (am in assignArray)
    {
        counter++;
//        NSLog(@"counter is %d",counter);
        //        if ([cpm.page isEqualToString:newPage]) //Change to page
        // {
        if ([befAft isEqualToString:@"before"])
        {
            if([am.beforeAfter isEqualToString:@"before"])//check CM cond
            {
                if (([am.element caseInsensitiveCompare:name] == NSOrderedSame) || ([am.name caseInsensitiveCompare:name] == NSOrderedSame) || ([am.name caseInsensitiveCompare:[NSString stringWithFormat:@"page %@", name]] == NSOrderedSame)) //check for element match
                {
                    if ([elmArray containsObject:am.element]) //check for elements list todo check elm array
                    {
                        NSUInteger idx = [elmArray indexOfObject:am.element];
                        ElementsModel *emc = [elementListArray objectAtIndex:idx];
                        NSLog(@"******%lu******",(unsigned long)assignArray.count);
                        if ([am.condition isEqualToString:@"assign"])
                        {
                            AssignmentModel *assignmentModel = [ParseAssignment parseAssign:am.assignment];
                            for (id key in [self.fieldsAndStringValues nsmd])
                            {
                                if ([assignmentModel.initialText containsString:(NSString *)key])
                                {
                                    [assignmentModel setInitialText:[assignmentModel.initialText stringByReplacingOccurrencesOfString:(NSString *)key withString:[self.fieldsAndStringValues objectForKey:key]]];
                                }
                            }
                            
                            AssignStatementParser *parser = [[AssignStatementParser alloc] init];
                            
                            NSError *err = nil;
                            PKAssembly *result = [parser parseString:assignmentModel.initialText error:&err];
                            
                            if (!result) {
                                if (err) NSLog(@"%@", err);
                                //                                assignmentModel.initialText = @"Unable to parse";
                                result = [[PKAssembly alloc] init];
                                [result push:assignmentModel.initialText];
                                //                               return;
                            }
                            
                            // print the entire assembly in the result output field
                            id n = [result pop];
                            assignmentModel.initialText = [result description];
                            if ([n isKindOfClass:[NSString class]])
                                assignmentModel.initialText = n;
                            else
                                assignmentModel.initialText = [n stringValue];
                            
                            [[self.dictionaryOfFields objectForKey:am.element] assignValue:assignmentModel.initialText];
                            NSLog(@"%@", assignmentModel.initialText);
                            //                            struct AssignPieces postAssign = parseAssign((char*)[am.assignment UTF8String]);
                            //                            NSLog(@"%s", postAssign.token0->initialText);
                            //                            NSLog(@"%s", postAssign.token1->initialText);
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            NSLog(@"-ena--%@",emc.elementName);
                        }
                    }
                }
            }
        }
        
        else if([befAft isEqualToString:@"after"])
        {
            if([am.beforeAfter isEqualToString:@"after"])
            {
                if (([am.name caseInsensitiveCompare:name] == NSOrderedSame))
                {
                    if ([elmArray containsObject:am.element]) //check for elements list todo check elm array
                    {
                        NSUInteger idx = [elmArray indexOfObject:am.element];
                        ElementsModel *emc = [elementListArray objectAtIndex:idx];
                        
                        if ([am.condition isEqualToString:@"assign"])
                        {
                            AssignmentModel *assignmentModel = [ParseAssignment parseAssign:am.assignment];
                            NSArray *initialTextArray = [[[[assignmentModel.initialText stringByReplacingOccurrencesOfString:@"(" withString:@" "] stringByReplacingOccurrencesOfString:@")" withString:@" "] stringByReplacingOccurrencesOfString:@"," withString:@" "] componentsSeparatedByString:@" "];
                            for (id key in [self.fieldsAndStringValues nsmd])
                            {
                                if ([initialTextArray containsObject:(NSString *)key])
                                {
                                    [assignmentModel setInitialText:[assignmentModel.initialText stringByReplacingOccurrencesOfString:(NSString *)key withString:[self.fieldsAndStringValues objectForKey:key]]];
                                }
                            }
                            
                            AssignStatementParser *parser = [[AssignStatementParser alloc] init];
                            
                            NSError *err = nil;
                            PKAssembly *result = [parser parseString:assignmentModel.initialText error:&err];
                            
                            if (!result) {
                                if (err) NSLog(@"%@", err);
//                                assignmentModel.initialText = @"Unable to parse";
                                result = [[PKAssembly alloc] init];
                                [result push:assignmentModel.initialText];
 //                               return;
                            }
                            
                            // print the entire assembly in the result output field
                            id n = [result pop];
                            assignmentModel.initialText = [result description];
                            if ([n isKindOfClass:[NSString class]])
                                assignmentModel.initialText = n;
                            else
                                assignmentModel.initialText = [n stringValue];
                            
                            [[self.dictionaryOfFields objectForKey:am.element] assignValue:assignmentModel.initialText];
                            NSLog(@"%@", assignmentModel.initialText);
//                            struct AssignPieces postAssign = parseAssign((char*)[am.assignment UTF8String]);
//                            NSLog(@"%s", postAssign.token0->initialText);
//                            NSLog(@"%s", postAssign.token1->initialText);
                            [elementListArray replaceObjectAtIndex:idx withObject:emc];
                            NSLog(@"-ena--%@",emc.elementName);
                        }
                    }
                }
            }
        }
    }
    
    for (ElementPairsCheck *ifElement in ifsArray)
    {
        NSLog(@"%@", [ifElement name]);
//        NSLog(@"%@", [ifElement stringValue]);
        NSLog(@"%@", [ifElement condition]);
        NSString *nameOfThePage = [[NSUserDefaults standardUserDefaults] stringForKey:@"nameOfThePage"];
        if ([befAft isEqualToString:@"before"])
        {
            if([ifElement.condition isEqualToString:@"before"])//check CM cond
            {
                if (([[[ifElement.name componentsSeparatedByString:@" "] objectAtIndex:1] caseInsensitiveCompare:name] == NSOrderedSame) ||
                    ([name intValue] > 0 && ([[ifElement.name substringFromIndex:[[ifElement.name componentsSeparatedByString:@" "] objectAtIndex:0].length + 1] caseInsensitiveCompare:nameOfThePage] == NSOrderedSame)) ||
                    (([[[ifElement.name componentsSeparatedByString:@" "] objectAtIndex:1] caseInsensitiveCompare:@"Page"] == NSOrderedSame) &&
                     ([[[ifElement.name componentsSeparatedByString:@" "] objectAtIndex:2] caseInsensitiveCompare:name] == NSOrderedSame))) //check for element match
                {
                    IfParser *ifParser = [[IfParser alloc] init];
                    NSError *err = nil;
                    ifParser.silentlyConsumesWhitespace = NO;
                    PKTokenizer *t = ifParser.tokenizer;
                    t.whitespaceState.reportsWhitespaceTokens = YES;
                    ifParser.tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
                    ifParser.assembly.preservesWhitespaceTokens = YES;
                    
                    [ifParser setDictionaryOfFields:self.dictionaryOfFields];
                    [ifParser setDictionaryOfPages:[self dictionaryOfPages]];
                    
                    [ifParser setRootViewController:self.rootViewController];
                    PKAssembly *ifResult = [ifParser parseString:[ifElement stringValue] error:&err];
                    if (ifResult)
                    {
                        id nn = [ifResult pop];
                        if ([nn isKindOfClass:[NSString class]])
                            NSLog(@"%@", nn);
                        else
                            NSLog(@"%@", [nn stringValue]);
                    }
                }
            }
        }
        
        else if([befAft isEqualToString:@"after"])
        {
            if([ifElement.condition isEqualToString:@"after"])
            {
                if (([[[ifElement.name componentsSeparatedByString:@" "] objectAtIndex:1] caseInsensitiveCompare:name] == NSOrderedSame) ||
                    ([name intValue] > 0 && ([[ifElement.name substringFromIndex:[[ifElement.name componentsSeparatedByString:@" "] objectAtIndex:0].length + 1] caseInsensitiveCompare:nameOfThePage] == NSOrderedSame)) ||
                    (([[[ifElement.name componentsSeparatedByString:@" "] objectAtIndex:1] caseInsensitiveCompare:@"Page"] == NSOrderedSame) &&
                     ([[[ifElement.name componentsSeparatedByString:@" "] objectAtIndex:2] caseInsensitiveCompare:name] == NSOrderedSame))) //check for element match
                {
                    IfParser *ifParser = [[IfParser alloc] init];
                    NSError *err = nil;
                    ifParser.silentlyConsumesWhitespace = NO;
                    PKTokenizer *t = ifParser.tokenizer;
                    t.whitespaceState.reportsWhitespaceTokens = YES;
                    ifParser.tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
                    ifParser.assembly.preservesWhitespaceTokens = YES;
                    
                    [ifParser setDictionaryOfFields:self.dictionaryOfFields];
                    [ifParser setDictionaryOfPages:[self dictionaryOfPages]];

                    [ifParser setRootViewController:self.rootViewController];
                    PKAssembly *ifResult = [ifParser parseString:[ifElement stringValue] error:&err];
                    if (ifResult)
                    {
                        id nn = [ifResult pop];
                        if ([nn isKindOfClass:[NSString class]])
                            NSLog(@"%@", nn);
                        else
                            NSLog(@"%@", [nn stringValue]);
                    }
                }
            }
        }
    }
}

/*Check Required strings*/

-(BOOL)checkRequiredstr:(NSString *)name Tag:(NSInteger *)newTag type:(int)newType from:(NSString *)befAft str:(NSString *)
newStr{
    
    BOOL reqYes;
    NSInteger *idx = [elmArray indexOfObject:[name lowercaseString]];
    ElementsModel *emc = [elementListArray objectAtIndex:idx];
    if (([emc.elementName caseInsensitiveCompare:name]==NSOrderedSame) && (emc.req == true ))
    {
        if ([newStr isEqualToString:@""])
        {
            reqYes = YES;
            emc.input = 0;
            [elementListArray replaceObjectAtIndex:idx withObject:emc];
            if (![requiredArray containsObject:emc.elementName]) {
                [requiredArray addObject:emc.elementName];
                if (valid>0)
                {
                    valid--;
                }
            }
        }
        else
        {
            reqYes = NO;
            emc.input = 1;
            [elementListArray replaceObjectAtIndex:idx withObject:emc];
            
            
            if ([requiredArray containsObject:emc.elementName]) {
                [requiredArray removeObject:emc.elementName];
                valid++;
            }
        }
    }
    else
    {
        reqYes = NO;
        emc.input = 1;
        [elementListArray replaceObjectAtIndex:idx withObject:emc];
        
        
    }
    return reqYes;
}

/*Show Alerts*/

-(void)showAlertsQueuedTag:(int)newTag
{
    if (dialogTitleArray.count>1) {
        int count = (int)(dialogTitleArray.count/3);
        int i =0;
        NSString *title = [dialogTitleArray objectAtIndex:i];
        NSString *subject = [dialogTitleArray objectAtIndex:i+1];
        int index = [[dialogTitleArray objectAtIndex:i+2]intValue];
        DialogModel *dmc = [dialogArray objectAtIndex:index];
        dmc.displayed = YES;
        [dialogArray replaceObjectAtIndex:index withObject:dmc];
        [dialogTitleArray removeObjectAtIndex:0];
        [dialogTitleArray removeObjectAtIndex:0];
        [dialogTitleArray removeObjectAtIndex:0];
        
        if (count==1) {
            [self endEditing:YES];
        }
        UIAlertAction *defaultAction ;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:subject preferredStyle:UIAlertControllerStyleAlert];
        
        if (dialogTitleArray.count>1) {
            defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UITextField *utf = (UITextField *)[formCanvas viewWithTag:newTag];
                    [utf resignFirstResponder];
                    
                    [self showAlertsQueuedTag:newTag];
                    
                    
                    
                });
            }];
        }
        else
        {
            defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                UITextField *utf = (UITextField *)[formCanvas viewWithTag:newTag];
                [utf resignFirstResponder];
                
                // [self gotoField:@"before" element:[pageName lowercaseString]];
                
                
            }];
            
        }
        [alert addAction:defaultAction];
        
        [self showAlrt:alert];
    }
    
    
}

-(void)showAlrt:(UIAlertController *)alrt
{
    UIWindow *keyWin = [[UIApplication sharedApplication]keyWindow];
    UIViewController *mainVC = [keyWin rootViewController];
    [mainVC presentViewController:alrt animated:YES completion:nil];
    
}


#pragma mark checkSubmitValidation

-(BOOL)onSubmitRequiredFrom:(NSString *)from
{
    BOOL done = NO;
    int counter = 0;
    
    for (ElementsModel *emc in elementListArray) {
        counter++;
        if (emc.req == YES && emc.input == NO)
        {
            
            if ([from isEqualToString:@"else"]) {
                [self showAlertForType:emc.type tag:emc.tag];
            }
            //            if ([from isEqualToString:@"elsealert"]) {
            //            [self gotoMissingFieldtype:emc.type tag:emc.tag];
            //            }
            done = NO;
            break;
            
        }
        if (counter == elementListArray.count) {
            done = YES;
        }
    }
    return done;
}

-(void)showAlertForType:(int)newType tag:(NSInteger *)newTag
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Required Fields" message:@"Please fill in all required fields" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self gotoMissingFieldtype:newType tag:newTag];
        
    }];
    
    [alert addAction:defaultAction];
    // UIViewController *uvc = [[[[UIApplication sharedApplication] delegate] window] rootViewController] ;
    //[self presentViewController:alert animated:YES completion:nil];
    
    UIWindow *keyWin = [[UIApplication sharedApplication]keyWindow];
    UIViewController *mainVC = [keyWin rootViewController];
    [mainVC presentViewController:alert animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
}


#pragma mark ElementManipulation CC

-(void)gotoMissingFieldtype:(int)newType tag:(NSInteger *)newTag
{
    switch (newType) {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        default:
            break;
    }
}

/*Enable*/

-(void)enable:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
           
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setIsEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            [utf setIsEnabled:YES];
           break;
        }
        default:
            break;
    }
    
}

/*Disable*/


-(void)disable:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            [utf setIsEnabled:NO];
            break;
        }
        default:
            break;
    }
    
}

/*Highlight*/

-(void)highlight:(int)eleTag type:(int)newType
{
    UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
    
    //    UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
    //            [utf setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];];
    
    
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 11:
        {
            NSLog(@"y/n");
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            //            UILabel *utf = (UILabel *)[formCanvas viewWithTag:eleTag-1];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        default:
            break;
    }
    
}

/*Unhighlight*/

-(void)unhighlight:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
//            [utf setBackgroundColor:[UIColor blackColor]];
            
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        default:
            break;
    }
    
}


/*Hide*/

-(void)hide:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf setBackgroundColor:[UIColor whiteColor]];
            [utf hideByHeight:YES];
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf hideByHeight:YES];
            break;
        }
        default:
            break;
    }
    
}


/*Unhide*/

-(void)unhide:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            [utf hideByHeight:NO];
            break;
        }
        default:
            break;
    }
    
}


/*Goto*/

-(void)gotoFormField:(int)newType tag:(NSInteger *)newTag
{
    // [self endEditing:YES];
    switch (newType) {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:newTag];
            [utf selfFocus];
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
            
        default:
            break;
    }
}

/*Clear*/

-(void)clear:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setFormFieldValue:NULL];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setTrueFalse:0];
            [utf setBackgroundColor:[UIColor whiteColor]];
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf reset];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf reset];
            
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf reset];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf reset];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf reset];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setImage:[[UIImage alloc] init]];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            break;
        }
        default:
            break;
    }
    
}


#pragma mark checkRequiredLabels

-(void)setLabelReq
{
    BOOL req = NO;
    BOOL notReq = NO;
    for (ConditionsModel *cpm in conditionsArray)
    {
        if ([cpm.condition isEqualToString:@"required"] && [cpm.beforeAfter isEqualToString:@"before"])
        {
            BOOL there = [elmArray containsObject:cpm.element];
            if (there) {
                int idx = (int)[elmArray indexOfObject:cpm.element];
                ElementsModel *emc = [elementListArray objectAtIndex:idx];
                int ty = 10;
                //                NSLog(@"%d %lu",emc.type,(unsigned long)idx);
                if (emc.type == ty) {
                    emc.req = NO;
                    notReq = YES;
                    [elementListArray replaceObjectAtIndex:idx withObject:emc];
                    [self setLabels:NO tag:emc.tag label:emc.promptText];
                    
                }
                else
                {
                    
                    if (!(emc.req == YES))
                    {
                        require++;
                        emc.req = YES;
                        req = YES;
                        [elementListArray replaceObjectAtIndex:idx withObject:emc];
                        [self setLabels:YES tag:emc.tag label:emc.promptText];
                        
                    }
                }
                
            }
            
        }
        if ([cpm.condition isEqualToString:@"notrequired"]&&[cpm.beforeAfter isEqualToString:@"before"])
        {
            BOOL there = [elmArray containsObject:cpm.element];
            if (there) {
                NSUInteger idx = [elmArray indexOfObject:cpm.element];
                ElementsModel *emc = [elementListArray objectAtIndex:idx];
                if (emc.req == YES) {
                    require--;
                    emc.req = NO;
                    notReq = YES;
                    [elementListArray replaceObjectAtIndex:idx withObject:emc];
                    [self setLabels:NO tag:emc.tag label:emc.promptText];
                    
                }
            }
        }
    }
    
}

-(void)setLabels:(BOOL)req tag:(int)newTag label:(NSString *)newText
{
    
    UILabel *eleLabel = (UILabel *)[formCanvas viewWithTag:newTag-1];
    
    if (req == YES) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:@"*"];
        
        [eleLabel setText:[NSString stringWithFormat:@"%@ %@", newText,attributedString]];
        [eleLabel setText:[[eleLabel.text stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""]];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]  initWithAttributedString: eleLabel.attributedText];
        
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(text.length-2, 1)];
        [eleLabel setAttributedText: text];
    }
    else if (req == NO)
    {
        eleLabel.text = newText;
        
    }
}
-(void)setLabelReqAfter:(NSString *)newName tag:(int)newTag text:(NSString *)newText reqnot:(BOOL)newReq;
{
    BOOL req = newReq;
    UILabel *eleLabel = (UILabel *)[formCanvas viewWithTag:newTag-1];
    
    if (req == YES) {
        if (eleLabel == nil)
            return;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:@"*"];
        
        [eleLabel setText:[NSString stringWithFormat:@"%@ %@", newText,attributedString]];
        [eleLabel setText:[[eleLabel.text stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""]];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]  initWithAttributedString: eleLabel.attributedText];
        
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(text.length-2, 1)];
        [eleLabel setAttributedText: text];
    }
    else if (req == NO)
    {
//        eleLabel.text = newText;
        UITextField *utf = (UITextField *)[formCanvas viewWithTag:newTag];
        utf.layer.borderWidth = 1.0f;
        utf.layer.borderColor = [[UIColor clearColor] CGColor];
        utf.layer.cornerRadius = 5;
        utf.clipsToBounds      = YES;
//        [utf setAlpha:1.0f];
        
        
    }
    
}

- (void)restoreToViewController
{
    NSThread *rtvcat = [[NSThread alloc] initWithTarget:self selector:@selector(restoreToViewControllerActionThread) object:nil];
    [rtvcat start];
}
- (void)restoreToViewControllerActionThread
{
    [NSThread sleepForTimeInterval:0.2];

    [self.rootViewController.view addSubview:self];
    [self.rootViewController.view bringSubviewToFront:self];
    
    for (UIView *v in [self.rootViewController.view subviews])
    {
        if ([[v backgroundColor] isEqual:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:0.95]])
        {
            [self.rootViewController.view bringSubviewToFront:v];
        }
        else if ([v isKindOfClass:[UINavigationBar class]])
        {
            [self.rootViewController.view bringSubviewToFront:v];
        }
    }
}

- (void)setElementListArrayIsEnabledForElement:(NSString *)elementName andIsEnabled:(BOOL)enabled
{
    for (int ela = 0; ela < elementListArray.count; ela++)
    {
        ElementsModel *em0 = (ElementsModel *)[elementListArray objectAtIndex:ela];
        if ([em0.elementName isEqualToString:elementName])
        {
            em0.enable = enabled;
            break;
        }
    }
}

- (void)syncPageDots
{
    NSLog(@"syncPageDots method pageToDisplay = %d", pageToDisplay);
    [(DataEntryViewController *)self.rootViewController setPageDotsPage:pageToDisplay - 1];
}

@end
