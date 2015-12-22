//
//  FormView.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

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
#import "SaveFormView.h"
#import <UIKit/UIKit.h>

@interface FormView : UIScrollView <NSXMLParserDelegate>
{
    BOOL firstParse;
    
    NSXMLParser *xmlParser;
    NSXMLParser *xmlParser1;
    UIView *formCanvas;
    NSString *dataText;
    float contentSizeHeight;
    NSMutableDictionary *legalValuesDictionary;
    NSMutableArray *legalValuesArray;
    NSString *lastLegalValuesKey;
    
    SaveFormView *saveFormView;
    
    NSString *formName;
}

@property NSURL *url;
@property UIViewController *rootViewController;
@property UILabel *fakeNavBar;

-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndFakeNavBar:(UILabel *)fnb;
@end
