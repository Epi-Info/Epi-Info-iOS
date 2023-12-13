//
//  DataEntryViewController.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import <UIKit/UIKit.h>
#import "LegalValues.h"
#import "CommentLegal.h"
#import "EnterDataView.h"
#import "EpiInfoLineListView.h"
#import "BlurryView.h"
#import "FeedbackView.h"
#import "Reachability.h"
#import "PageDots.h"
#import "sqlite3.h"
#import "FieldsAndStringValues.h"
#import "EpiInfoLogManager.h"
#import "EncryptionDecryptionKeys.h"
#import "FunctionsMenuBarButtonItem.h"
#import <CoreImage/CoreImage.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface DataEntryViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    FunctionsMenuBarButtonItem *functionsMenu;
    NSMutableArray *arrayOfScannerButtons;
    
    UIButton *customBackButton;
    UIBarButtonItem *backToMainMenu;
    
    UIImageView *fadingColorView;
    UILabel *pickerLabel;
    LegalValuesEnter *lv;
    UIButton *openButton;
    UIButton *manageButton;
    UITextField *lvSelected;
    UIButton *googleSheetButton;
    UIButton *formDesignerButton;
    
    EnterDataView *edv;
    UIView *orangeBanner;
    UIView *orangeBannerBackground;
    UINavigationBar *footerBar;
    
    UIView *dismissView;
    
    sqlite3 *epiinfoDB;
    
    BOOL mailComposerShown;
  
  int recordsToBeWrittenToPackageFile;
    
    UIView *dotDecimalSeparatorView;
    UIView *commaDecimalSeparatorView;
    BOOL useDotForDecimal;

    UINavigationItem *formNavigationItem;
    UINavigationItem *footerBarNavigationItem;
    UIBarButtonItem *closeFormBarButtonItem;
    UIBarButtonItem *deleteRecordBarButtonItem;
    UIBarButtonItem *submitFooterBarButtonItem;
    UIBarButtonItem *updateFooterBarButtonItem;
    UIBarButtonItem *deleteHeaderBarButtonItem;
    
    NSMutableArray *formNavigationItems;
    NSMutableArray *closeFormBarButtonItems;
    NSMutableArray *deleteRecordBarButtonItems;
    
    BOOL updatingExistingRecord;
    
    PageDots *pagedots;
    NSMutableArray *arrayOfPageDots;
    
    BOOL useCustomKeys;
    NSString *customKeyString;
    NSString *customSaltString;
    
    BOOL spanishLanguage;
}
@property NSMutableDictionary *legalValuesDictionary;
@property FieldsAndStringValues *fieldsAndStringValues;
@property BOOL didShowProjectTemplateWarning;
@property NSMutableArray *arrayOfFieldsAllPages;
@property NSMutableDictionary *alterTableElements;
@property id geocodingCheckbox;
-(BOOL)notwo;
-(UIButton *)openButton;
-(void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID;
-(void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID OnEnterDataView:(UIView *)onEdv;
-(UIImageView *)backgroundImage;
-(void)resetHeaderAndFooterBars;
-(void)setFooterBarToUpdate;
-(BOOL)alreadyHasFooter;
-(void)childFormDismissed;
-(void)setUpdateExistingRecord:(BOOL)uer;
-(NSMutableArray *)formNavigationItems;
-(NSMutableArray *)closeFormBarButtonItems;
-(NSMutableArray *)deleteRecordBarButtonItems;
-(void)setFooterBarNavigationItemTitle:(NSString *)footerBarNavigationItemTitle;
-(void)advancePagedots;
-(void)retreatPagedots;
-(void)resetPagedots;
-(void)addNewSetOfPageDots:(EnterDataView *)newedv;
-(void)popPageDots;
-(void)setPageDotsPage:(int)pg;
-(void)lvReset:(NSString *)newForm;
-(void)activateFunctionsMenu:(BOOL)active;
-(void)addButtonToArrayOfScannerButtons:(UIButton *)b;
-(EnterDataView *)edv;
@end
