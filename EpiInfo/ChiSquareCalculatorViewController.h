//
//  ChiSquareCalculatorViewController.h
//  EpiInfo
//
//  Created by John Copeland on 10/12/12.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ZoomView.h"

@interface ChiSquareCalculatorViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *customBackButton;
    
    BOOL fourInchPhone;

    BOOL currentOrientationPortrait;
    
    BOOL hasAFirstResponder;
    
    CGRect scrollViewFrame;
    UIImageView *fadingColorView;
    UIImageView *fadingColorView0;
    
    UIControl *selfViewControl;
    
    CGSize noResponderSize;
    CGSize responderSize;
    CGSize landscapeNoResponderSize;
    CGSize landscapeResponderSize;
    
    ZoomView *zoomingView;
    UIScrollView *phoneScrollView;
    
    CGRect phoneScrollViewSize;
    
    CGRect phoneHeaderLabelFrame;
    CGRect phoneChiSquareLabelFrame;
    CGRect phonePValueLabelFrame;
    CGRect phoneChiSquareResultFrame;
    CGRect phonePValueResultFrame;
    
    CGRect phoneExposureScoreLabelFrame;
    CGRect phoneCasesLabelFrame;
    CGRect phoneControlsLabelFrame;
    CGRect phoneOddsRatioLabelFrame;
    CGRect phoneExposureScoreField0Frame;
    CGRect phoneExposureScoreField1Frame;
    CGRect phoneExposureScoreField2Frame;
    CGRect phoneExposureScoreField3Frame;
    CGRect phoneExposureScoreField4Frame;
    CGRect phoneExposureScoreField5Frame;
    CGRect phoneExposureScoreField6Frame;
    CGRect phoneExposureScoreField7Frame;
    CGRect phoneExposureScoreField8Frame;
    CGRect phoneExposureScoreField9Frame;
    CGRect phoneCasesField0Frame;
    CGRect phoneCasesField1Frame;
    CGRect phoneCasesField2Frame;
    CGRect phoneCasesField3Frame;
    CGRect phoneCasesField4Frame;
    CGRect phoneCasesField5Frame;
    CGRect phoneCasesField6Frame;
    CGRect phoneCasesField7Frame;
    CGRect phoneCasesField8Frame;
    CGRect phoneCasesField9Frame;
    CGRect phoneControlsField0Frame;
    CGRect phoneControlsField1Frame;
    CGRect phoneControlsField2Frame;
    CGRect phoneControlsField3Frame;
    CGRect phoneControlsField4Frame;
    CGRect phoneControlsField5Frame;
    CGRect phoneControlsField6Frame;
    CGRect phoneControlsField7Frame;
    CGRect phoneControlsField8Frame;
    CGRect phoneControlsField9Frame;
    CGRect phoneOddsRatioResults0Frame;
    CGRect phoneOddsRatioResults1Frame;
    CGRect phoneOddsRatioResults2Frame;
    CGRect phoneOddsRatioResults3Frame;
    CGRect phoneOddsRatioResults4Frame;
    CGRect phoneOddsRatioResults5Frame;
    CGRect phoneOddsRatioResults6Frame;
    CGRect phoneOddsRatioResults7Frame;
    CGRect phoneOddsRatioResults8Frame;
    CGRect phoneOddsRatioResults9Frame;
    
    CGRect phoneLargeColorBoxFrame;
    UIView *phoneLargeColorBox;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneExposureScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCasesLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneControlsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneOddsRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneChiSquareLabel;
@property (weak, nonatomic) IBOutlet UILabel *phonePValueLabel;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField0;
@property (weak, nonatomic) IBOutlet UITextField *casesField0;
@property (weak, nonatomic) IBOutlet UITextField *controlsField0;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult0;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField1;
@property (weak, nonatomic) IBOutlet UITextField *casesField1;
@property (weak, nonatomic) IBOutlet UITextField *controlsField1;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult1;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField2;
@property (weak, nonatomic) IBOutlet UITextField *casesField2;
@property (weak, nonatomic) IBOutlet UITextField *controlsField2;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult2;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField3;
@property (weak, nonatomic) IBOutlet UITextField *casesField3;
@property (weak, nonatomic) IBOutlet UITextField *controlsField3;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult3;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField4;
@property (weak, nonatomic) IBOutlet UITextField *casesField4;
@property (weak, nonatomic) IBOutlet UITextField *controlsField4;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult4;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField5;
@property (weak, nonatomic) IBOutlet UITextField *casesField5;
@property (weak, nonatomic) IBOutlet UITextField *controlsField5;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult5;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField6;
@property (weak, nonatomic) IBOutlet UITextField *casesField6;
@property (weak, nonatomic) IBOutlet UITextField *controlsField6;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult6;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField7;
@property (weak, nonatomic) IBOutlet UITextField *casesField7;
@property (weak, nonatomic) IBOutlet UITextField *controlsField7;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult7;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField8;
@property (weak, nonatomic) IBOutlet UITextField *casesField8;
@property (weak, nonatomic) IBOutlet UITextField *controlsField8;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult8;

@property (weak, nonatomic) IBOutlet UITextField *exposureScoreField9;
@property (weak, nonatomic) IBOutlet UITextField *casesField9;
@property (weak, nonatomic) IBOutlet UITextField *controlsField9;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioResult9;

@property (weak, nonatomic) IBOutlet UILabel *chiSquareResult;
@property (weak, nonatomic) IBOutlet UILabel *pValueResult;

@property (weak, nonatomic) IBOutlet UIScrollView *epiInfoScrollView0;
@property (weak, nonatomic) IBOutlet UINavigationBar *lowerNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *subView1;
@property (weak, nonatomic) IBOutlet UIView *subView2;

- (IBAction)textFieldBecameFirstResponder:(id)sender;
- (IBAction)resetBarButtonPressed:(id)sender;
- (IBAction)textFieldAction:(id)sender;
- (IBAction)compute:(id)sender;
- (IBAction)reset:(id)sender;
@end
