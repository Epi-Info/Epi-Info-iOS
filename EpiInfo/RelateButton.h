//
//  RelateButton.h
//  EpiInfo
//
//  Created by John Copeland on 2/25/16.
//

#import <UIKit/UIKit.h>
#import "BlurryView.h"
#import "FeedbackView.h"
#import "Reachability.h"
#import "sqlite3.h"
#import <CoreImage/CoreImage.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface RelateButton : UIButton <MFMailComposeViewControllerDelegate, UITextFieldDelegate>
{
    NSString *relatedViewName;
    UIViewController *rootViewController;
    UIView *parentEDV;
    UIView *dismissView;
    UIView *edv;
    UIView *orangeBannerBackground;
    UIView *orangeBanner;
    
    sqlite3 *epiinfoDB;
    int recordsToBeWrittenToPackageFile;
    UIView *dotDecimalSeparatorView;
    UIView *commaDecimalSeparatorView;
    BOOL useDotForDecimal;
    
    BOOL mailComposerShown;
}
-(void)setRelatedViewName:(NSString *)rvn;
-(NSString *)relatedViewName;
-(void)setRootViewController:(UIViewController *)rvc;
-(UIViewController *)rootViewController;
-(void)setParentEDV:(UIView *)medv;
-(UIView *)parentEDV;
@end
