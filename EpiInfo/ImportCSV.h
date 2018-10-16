//
//  ImportCSV.h
//  EpiInfo
//
//  Created by John Copeland on 8/1/14.
//

#import <UIKit/UIKit.h>
#import "SaveFormView.h"
#import "AnalysisDataObject.h"
#import "EpiInfoTextField.h"
#import "EpiInfoUILabel.h"
#import "EpiInfoViewController.h"
#import "EpiInfoNavigationController.h"

@interface ImportCSV : UIScrollView <UITextFieldDelegate>
{
    UIView *formCanvas;
    NSString *dataText;
    float contentSizeHeight;
    
    SaveFormView *saveFormView;
    
    NSString *formName;
    
    AnalysisDataObject *ado;

    BOOL hasAFirstResponder;
    
    sqlite3 *epiinfoDB;
}

@property NSURL *url;
@property UIViewController *rootViewController;
@property UIView *fakeNavBar;

-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url;
-(id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndFakeNavBar:(UIView *)fnb;
@end
