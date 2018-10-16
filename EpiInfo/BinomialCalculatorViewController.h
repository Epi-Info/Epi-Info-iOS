//
//  BinomialCalculatorViewController.h
//  EpiInfo
//
//  Created by John Copeland on 10/12/12.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ZoomView.h"

@interface BinomialCalculatorViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *customBackButton;
    
    BOOL currentOrientationPortrait;
    
    UITextField *sliderLabel;
    NSThread *workerThread;
    NSThread *anotherWorkerThread;
    NSString *ll;
    NSString *ul;
    
    CGRect scrollViewFrame;
    UIImageView *fadingColorView;
    UIImageView *fadingColorView0;
    
    CGRect computingCIFrame;
    
    ZoomView *zoomingView;
    UIView *phoneColorBox;
    UIView *phoneWhiteBox0;
    UIView *phoneWhiteBox1;
    UIView *phoneWhiteBox2;
    UIView *phoneWhiteBox3;
    UIView *phoneWhiteBox4;
    UIView *phoneWhiteBox5;
    UIView *phoneWhiteBox6;
    UIView *phoneWhiteBox7;
    UIView *phoneWhiteBox8;
    UIView *phoneWhiteBox9;
    UIView *phoneExtraWhite0;
    UIView *phoneExtraWhite1;
    UIView *phoneExtraWhite2;
    UIView *phoneExtraWhite3;
    
    UIView *phonePValueColorBox;
    UIView *phonePValueWhiteBox;
    UIView *phonePValueExtraWhiteBox;
    UIView *phoneCIColorBox;
    UIView *phoneCIWhiteBox;
    UIView *phoneCIExtraWhiteBox;
    
    UIView *phoneResultsView;
    UIView *phoneInputsView;
    UIView *phonePValueView;
    UIView *phoneCIView;
}
@property (weak, nonatomic) IBOutlet UIButton *phoneResetButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneComputeButton;
@property (weak, nonatomic) IBOutlet UILabel *phonePercentSign;
@property (weak, nonatomic) IBOutlet UILabel *phoneExpectedPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTotalObservationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumeratorLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCILabel;
@property (weak, nonatomic) IBOutlet UILabel *phonePValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneSectionHeaderLabel;
@property (weak, nonatomic) IBOutlet UITextField *numeratorField;
@property (weak, nonatomic) IBOutlet UITextField *denominatorField;
@property (weak, nonatomic) IBOutlet UITextField *expectedPercentageField;
@property (weak, nonatomic) IBOutlet UILabel *ltLabel;
@property (weak, nonatomic) IBOutlet UILabel *ltValue;
@property (weak, nonatomic) IBOutlet UILabel *leLabel;
@property (weak, nonatomic) IBOutlet UILabel *leValue;
@property (weak, nonatomic) IBOutlet UILabel *eqLabel;
@property (weak, nonatomic) IBOutlet UILabel *eqValue;
@property (weak, nonatomic) IBOutlet UILabel *geLabel;
@property (weak, nonatomic) IBOutlet UILabel *geValue;
@property (weak, nonatomic) IBOutlet UILabel *gtLabel;
@property (weak, nonatomic) IBOutlet UILabel *gtValue;
@property (weak, nonatomic) IBOutlet UILabel *pValue;
@property (weak, nonatomic) IBOutlet UILabel *ciValue;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetBarButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *computingCI;

- (IBAction)compute:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)textFieldAction:(id)sender;
- (IBAction)resetBarButtonPressed:(id)sender;

//For iPad
@property (nonatomic,retain) IBOutlet UITextField *sliderLabel;
-(IBAction) sliderChanged:(id) sender;
@property (weak, nonatomic) IBOutlet UISlider *expectedPercentageSlider;
- (IBAction)stepperChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *expectedPercentageStepper;
@property (weak, nonatomic) IBOutlet UIScrollView *epiInfoScrollView0;
@property (weak, nonatomic) IBOutlet UINavigationBar *lowerNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *subView1;
@property (weak, nonatomic) IBOutlet UIView *subView2;
//
@end
