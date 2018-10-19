//
//  FormFromGoogleSheetView.h
//  EpiInfo
//
//  Created by John Copeland on 10/18/18.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "LegalValuesEnter.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormFromGoogleSheetView : UIView <UITextViewDelegate>
{
    UITextView *sheetURL;
    sqlite3 *epiinfoDB;
    LegalValuesEnter *devclve;
}
@property UIButton *runButton;
@property UIButton *dismissButton;
-(id)initWithFrame:(CGRect)frame andSender:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
