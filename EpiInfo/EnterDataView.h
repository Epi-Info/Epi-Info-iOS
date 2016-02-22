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
#import "EpiInfoOptionField.h"
#import "EpiInfoCodesField.h"
#import "EpiInfoUniqueIDField.h"
#import "SaveFormView.h"
#import "BlurryView.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "sqlite3.h"
#import <CoreText/CoreText.h>

@class CheckCodeParser;
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
    
    NSMutableArray *elementsArray;
    NSMutableArray *conditionsArray;
    NSMutableArray *elementListArray;
    NSMutableArray *elmArray;
    int tagNum;
    int require;
    int valid;
    NSMutableArray *requiredArray;
    CheckCodeParser *ccp;
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

@property (nonatomic) NSMutableArray *elementsArray;
@property (nonatomic) NSMutableArray *conditionsArray;
@property (nonatomic) NSMutableArray *elementListArray;
@property (nonatomic) NSMutableArray *elmArray;
@property (nonatomic) NSMutableArray *requiredArray;
@property (nonatomic) NSString *afterString;





-(NSString *)formName;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndNameOfTheForm:(NSString *)notf;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndNameOfTheForm:(NSString *)notf;
-(void)getMyLocation;
-(void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID;

-(void)fieldBecameFirstResponder:(id)field;
-(void)fieldResignedFirstResponder:(id)field;
-(void)checkboxChanged:(Checkbox *)checkbox;
-(void)copyToArray:(NSMutableArray *)eleArray;
-(BOOL)checkElements:(NSString *)name Tag:(NSInteger *)newTag type:(int)newType from:(NSString *)befAft;

@end
