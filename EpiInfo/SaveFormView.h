//
//  SaveFormView.h
//  EpiInfo
//
//  Created by John Copeland on 12/3/13.
//

#import <UIKit/UIKit.h>
#import "LegalValues.h"
#import "sqlite3.h"
#import "EpiInfoTextField.h"
#import "EpiInfoLogManager.h"

@interface SaveFormView : UIView <UITextFieldDelegate, NSXMLParserDelegate>
{
    UITextField *typeFormName;
    
    UIView *msAzureCredsView;
    
    sqlite3 *epiinfoDB;
    
    UILabel *fakeNavBar;
    
    NSString *createTableStatement;
    NSString *alterTableStatement;
    NSMutableDictionary *dictionaryOfColumnsAndTypes;
}
@property NSURL *url;
@property UIViewController *rootViewController;
@property UIView *formView;
@property NSString *formName;

@property NSString *cloudDataType;
@property NSString *cloudDataBase;
@property NSString *cloudDataKey;

-(id)initWithFrame:(CGRect)frame AndRootViewController:(UIViewController *)rvc AndFormView:(UIView *)fv AndFormName:(NSString *)fn AndURL:(NSURL *)url;
@end
