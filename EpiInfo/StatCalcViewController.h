//
//  StatCalcViewController.h
//  StatCalc
//
//  Created by John Copeland on 10/4/12.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DrawCurveView.h"
#import "BlurryView.h"

@interface StatCalcViewController : UIViewController
{
    UIButton *customBackButton;
    
    BOOL currentOrientationPortrait;
    
    UIImageView *fadingColorView;
    CGRect headerFrame;
    CGRect subHeaderFrame;
    UILabel *headerLabel;
    UILabel *subHeaderLabel;
    
    CGRect button1Frame;
    CGRect button2Frame;
    CGRect button3Frame;
    CGRect button4Frame;
    CGRect button5Frame;
    CGRect button6Frame;
    CGRect button7Frame;
    CGRect button8Frame;
    CGRect button1LandscapeFrame;
    CGRect button2LandscapeFrame;
    CGRect button3LandscapeFrame;
    CGRect button4LandscapeFrame;
    CGRect button5LandscapeFrame;
    CGRect button6LandscapeFrame;
    CGRect button7LandscapeFrame;
    CGRect button8LandscapeFrame;
    
    UIView *buttonBox;
    UIView *buttonWhiteBox;
    UIView *powerBox;
    UIView *powerWhiteBox;
    UILabel *powerSectionHeaderLabel;
    
    UIImageView *cdcImageView;
    UIImageView *hhsImageView;
    
    UIView *v1;
    UIView *v2;
    UIView *v3;
    UIView *v4;
    UIView *v5;
    UIView *v6;
    
    BlurryView *blurryView;
    BlurryView *blurryView2;
    
    CGRect frameOfButtonPressed;
    UIButton *buttonPressed;
    
    NSString *imageFileToUseInSegue;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneHeaderLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property (weak, nonatomic) IBOutlet UIButton *button10;

-(BlurryView *)blurryView;
-(BlurryView *)blurryView2;
-(CGRect)frameOfButtonPressed;
-(UIButton *)buttonPressed;
-(NSString *)imageFileToUseInSegue;
@end
