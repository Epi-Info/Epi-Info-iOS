//
//  EnterDataView.h
//  EpiInfo
//
//  Created by John Copeland on 12/19/13.
//

#import "EpiInfo-Swift.h"
#import "EpiInfoTextField.h"
#import "EpiInfoTextView.h"
#import "Checkbox.h"
#import "YesNo.h"
#import "NumberField.h"
#import "PhoneNumberField.h"
#import "DateField.h"
#import "TimeField.h"
#import "DateTimeField.h"
#import "UppercaseTextField.h"
#import "MirrorField.h"
#import "LegalValues.h"
#import "LegalValuesEnter.h"
#import "CommentLegal.h"
#import "EpiInfoOptionField.h"
#import "EpiInfoCodesField.h"
#import "EpiInfoUniqueIDField.h"
#import "RelateButton.h"
#import "SaveFormView.h"
#import "BlurryView.h"
#import "CheckCodeParser.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "sqlite3.h"
#import "AssignParse.h"
#import "ParseAssignment.h"
#import "AssignmentModel.h"
#import "IfParser.h"
#import "FieldsAndStringValues.h"
#import "DictionaryOfFields.h"
#import <MicrosoftAzureMobile/MicrosoftAzureMobile.h>

@interface EnterDataView : UIScrollView <NSXMLParserDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITextViewDelegate, UIAlertViewDelegate>
{
    BOOL firstParse;
    BOOL firstElement;
    
    NSXMLParser *xmlParser;
    NSXMLParser *xmlParser1;
    UIView *formCanvas;
    NSString *dataText;
    float contentSizeHeight;
    NSMutableDictionary *legalValuesDictionary;
    NSMutableArray *legalValuesArray;
    NSString *lastLegalValuesKey;
    
    NSString *formName;
    
    NSString *createTableStatement;
    BOOL beginColumList;
    NSMutableDictionary *alterTableElements;
    
    sqlite3 *epiinfoDB;
    
    BOOL hasAFirstResponder;
    
    NSMutableDictionary *queriedColumnsAndValues;
    NSString *recordUIDForUpdate;
    
    BOOL seenFirstGeocodeField;
    Checkbox *geocodingCheckbox;
    
    NSMutableDictionary *legalValuesDictionaryForRVC;
    
    int pageToDisplay;
    BOOL isCurrentPage;
    BOOL isFirstPage;
    BOOL isLastPage;
    NSMutableDictionary *dictionaryOfPages;
    NSString *guidBeingUpdated;
    NSString *tableBeingUpdated;
    BOOL updatevisibleScreenOnly;
    BOOL populateInstructionCameFromLineList;
    UIButton *nextPageButton;
    UIButton *previousPageButton;
    
    NSNumber *pageBeingDisplayed;
    
    UIView *myOrangeBanner;
    
    NSString *newRecordGUID;
    
    NSString *parentRecordGUID;
    UIView *parentEnterDataView;
    NSString *relateButtonName;
    
    NSString *formCheckCodeString;
    
    int tagNum;
    int require;
    int valid;
    int counter;
    BOOL firstEdit;
    
    CheckCodeParser *ccp;
    NSString *pageName;
    
    /*CheckCode*/
    NSMutableArray *keywordsArray;
    NSMutableArray *conditionsArray;
    NSMutableArray* dialogArray;
    NSMutableArray *elementListArray;
    NSMutableArray *elementsArray;
    NSMutableArray *elmArray;
    NSMutableArray *dialogListArray;
    NSMutableArray *dialogTitleArray;
    NSMutableArray *requiredArray;
    NSMutableArray *assignArray;
    NSMutableArray *ifsArray;
    
    BOOL alertBefore;
    
    NSMutableArray *arrayOfGroups;
    NSMutableDictionary *dictionaryOfGroupsAndLists;
}

@property NSURL *url;
@property UIViewController *rootViewController;
@property CLLocationManager *locationManager;
@property NSThread *updateLocationThread;

@property NSString *latitudeField;
@property NSString *longitudeField;

@property NSString *nameOfTheForm;

@property NSMutableArray *pagesArray;
@property NSMutableArray *pageIDs;
@property NSMutableDictionary *checkboxes;

@property NSMutableDictionary *dictionaryOfCommentLegals;

@property DictionaryOfFields *dictionaryOfFields;
@property NSMutableDictionary *dictionaryOfWordsArrays;

@property FieldsAndStringValues *fieldsAndStringValues;

@property NSString *myTextPageName;

@property BOOL skipThisPage;

//@property(strong, nonatomic) NSMutableArray *conditionsArray;
@property(strong) NSMutableArray* dialogArray;
@property(strong) NSMutableArray *elementListArray;
//@property(strong, nonatomic) NSMutableArray *elementsArray;
@property(strong) NSMutableArray *elmArray;
//@property(nonatomic) BOOL firstEdit;

@property (strong, nonatomic) MSClient *client;
@property (strong, nonatomic) NSString *cloudService;
@property (strong, nonatomic) NSString *cloudKey;


-(void)setNewRecordGUID:(NSString *)guid;

-(void)setTableBeingUpdated:(NSString *)tbu;

-(void)setRecordUIDForUpdate:(NSString *)uid;

-(NSDictionary *)dictionaryOfPages;
-(NSMutableDictionary *)mutableDictionaryOfPages;
-(void)setDictionaryOfPagesObject:(id)object forKey:(id<NSCopying>)key;

-(void)setParentRecordGUID:(NSString *)prguid;
-(NSString *)parentRecordGUID;
-(NSString *)guidToSendToChild;

-(void)setParentEnterDataView:(EnterDataView *)parentEDV;
-(EnterDataView *)parentEnterDataView;

-(void)setRelateButtonName:(NSString *)rbn;

-(NSString *)formCheckCodeString;

-(void)setMyOrangeBanner:(UIView *)mob;
-(UIView *)myOrangeBanner;

-(NSString *)formName;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page AndParentForm:(EnterDataView *)parentForm;
-(void)getMyLocation;
-(void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID;
-(void)setPageToDisplay:(int)pageNumber;

-(BOOL)getIsFirstPage;
-(BOOL)getIsLastPage;
-(void)setDictionaryOfPages:(NSMutableDictionary *)dop;
-(UIView *)formCanvas;
-(void)setGuidBeingUpdated:(NSString *)gbu;
-(void)setPopulateInstructionCameFromLineList:(BOOL)yesNo;

-(void)fieldBecameFirstResponder:(id)field;
-(void)fieldResignedFirstResponder:(id)field;
-(void)checkboxChanged:(Checkbox *)checkbox;

-(void)setPageBeingDisplayed:(NSNumber *)page;
-(NSNumber *)pageBeingDisplayed;

- (NSString *)createTableStatement;

-(void)confirmSubmitOrClear:(UIButton *)sender;

-(void)setAssignArray:(NSMutableArray *)aa;

-(void)checkcodeSwipedToTheLeft;
-(void)checkcodeSwipedToTheRight;
-(void)userSwipedToTheLeft;
-(void)userSwipedToTheRight;

-(void)doResignAll;

-(NSArray *)arrayOfGroups;
-(NSDictionary *)dictionaryOfGroupsAndLists;

-(void)checkElements:(NSString *)name from:(NSString *)befAft page:(NSString *)newPage;

-(void)restoreToViewController;

-(void)setElementListArrayIsEnabledForElement:(NSString *)elementName andIsEnabled:(BOOL)enabled;

-(void)clearButtonPressedAction;

-(void)syncPageDots;
@end
