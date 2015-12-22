//
//  PoissonCalculatorViewController.h
//  EpiInfo
//
//  Created by John Copeland on 10/12/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ZoomView.h"

@interface PoissonCalculatorViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *customBackButton;
    
    BOOL currentOrientationPortrait;
    
    CGRect scrollViewFrame;
    UIImageView *fadingColorView;
    UIImageView *fadingColorView0;
        
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
    
    UIView *phoneResultsView;
    UIView *phoneInputsView;
}
@property (weak, nonatomic) IBOutlet UIButton *phoneResetButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneComputeButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneExpectedEventsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneObservedEventsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneSectionHeaderLabel;
@property (weak, nonatomic) IBOutlet UITextField *observedEventsField;
@property (weak, nonatomic) IBOutlet UITextField *expectedEventsField;
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
@property (weak, nonatomic) IBOutlet UIScrollView *epiInfoScrollView0;
@property (weak, nonatomic) IBOutlet UINavigationBar *lowerNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *subView1;
@property (weak, nonatomic) IBOutlet UIView *subView2;

- (IBAction)textFieldActions:(id)sender;
- (IBAction)resetBarButtonPressed:(id)sender;

- (IBAction)compute:(id)sender;
- (IBAction)reset:(id)sender;
@end
