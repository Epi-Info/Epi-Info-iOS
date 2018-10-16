//
//  EpiInfoViewController.h
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "sqlite3.h"
#import "MainMenuMenu.h"

@interface EpiInfoViewController : UIViewController
{
    BOOL currentOrientationPortrait;
    
    UIImageView *fadingColorView;
    UIImageView *cdcImageView;
    UIImageView *hhsImageView;
    CGRect button1Frame;
    CGRect button2Frame;
    CGRect button3Frame;
    CGRect button4Frame;
    CGRect button5Frame;
    CGRect button1LandscapeFrame;
    CGRect button2LandscapeFrame;
    CGRect button3LandscapeFrame;
    
    UIView *v1;
    UIView *v2;
    UIView *v3;
    UIView *v4;
    UIView *v5;
    
    UILabel *l1a;
    UILabel *l1b;
    UILabel *l2a;
    UILabel *l2b;
    UILabel *l3a;
    UILabel *l3b;
    
    CGRect frameOfButtonPressed;
    UIButton *buttonPressed;
    
    NSString *imageFileToUseInSegue;
    
    BOOL hasVHFData;
}
@property (weak, nonatomic) IBOutlet UIButton *analyzeDataButton;
@property (weak, nonatomic) IBOutlet UIButton *statCalcButton;
@property (weak, nonatomic) IBOutlet UIButton *dataEntryButton;
@property (weak, nonatomic) IBOutlet UIButton *vhfButton;
@property (weak, nonatomic) IBOutlet UIButton *simulationsButton;

@property UIBarButtonItem *mainMenuMenu;

-(CGRect)frameOfButtonPressed;
-(UIButton *)buttonPressed;
-(NSString *)imageFileToUseInSegue;

@end
