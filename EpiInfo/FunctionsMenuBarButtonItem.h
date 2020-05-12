//
//  FunctionsMenuBarButtonItem.h
//  EpiInfo
//
//  Created by John Copeland on 5/12/20.
//

#import "EpiInfoBarButtonItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FunctionsMenuBarButtonItem : EpiInfoBarButtonItem
{
    UIViewController *uivc;
    BOOL scannersEnabled;
}
@property NSMutableArray *arrayOfScannerButtons;
-(void)setUIVC:(UIViewController *)devc;
-(void)selfPressed;
@end

NS_ASSUME_NONNULL_END
