//
//  SyncView.h
//  EpiInfo
//
//  Created by John Copeland on 3/20/19.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "LegalValuesEnter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SyncView : UIView <NSXMLParserDelegate, UITextFieldDelegate>
{
    BOOL firstParse;
    
    NSXMLParser *xmlParser;
    NSXMLParser *xmlParser1;
    UIView *formCanvas;
    NSString *dataText;
    
    NSString *formName;
    
    UIBarButtonItem *xBarButton;
    UIBarButtonItem *saveBarButton;

    LegalValuesEnter *lv;
    UITextField *lvSelected;
    UITextField *passwordField;
    
    NSMutableArray *arrayOfGUIDs;
    NSMutableArray *arrayOfColumns;
    NSMutableArray *arrayOfValues;
    
    BOOL doingResponseDetail;
}

@property NSURL *url;
@property UIViewController *rootViewController;
@property UIView *fakeNavBar;

-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndFakeNavBar:(UIView *)fnb;@end

NS_ASSUME_NONNULL_END
