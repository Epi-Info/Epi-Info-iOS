//
//  FunctionsMenuBarButtonItem.h
//  EpiInfo
//
//  Created by John Copeland on 5/12/20.
//

#import "EpiInfoBarButtonItem.h"
#import "BoxData.h"

NS_ASSUME_NONNULL_BEGIN

@interface FunctionsMenuBarButtonItem : EpiInfoBarButtonItem
{
    UIViewController *uivc;
    BOOL scannersEnabled;
    BOOL connectedToBox;
    BOOL notwo;
    BOOL spanishLanguage;
}
@property NSMutableArray *arrayOfScannerButtons;
-(void)setConnectedToBox:(BOOL)ctb;
-(BOOL)connectedToBox;
-(void)setNotwo:(BOOL)no2;
-(BOOL)notwo;
-(void)setUIVC:(UIViewController *)devc;
-(void)selfPressed;
@end

NS_ASSUME_NONNULL_END
