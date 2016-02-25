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
#import "EpiInfoOptionField.h"
#import "EpiInfoCodesField.h"
#import "EpiInfoUniqueIDField.h"
#import "RelateButton.h"
#import "SaveFormView.h"
#import "BlurryView.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "sqlite3.h"

@interface EnterDataView : UIScrollView <NSXMLParserDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITextViewDelegate>
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

@property NSMutableDictionary *dictionaryOfFields;
@property NSMutableDictionary *dictionaryOfWordsArrays;

-(NSString *)formName;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page;
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
@end
