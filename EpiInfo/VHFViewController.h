//
//  UIViewController+VHFViewController.h
//  EpiInfo
//
//  Created by John Copeland on 10/8/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MessageUI/MessageUI.h"
#import "EpiInfoLineListView.h"
#import "Checkbox.h"
#import "sqlite3.h"
#import "EpiInfoTextField.h"

@interface VHFViewController : UIViewController <MFMessageComposeViewControllerDelegate, UITextFieldDelegate>
{
    UIButton *customBackButton;
    
    UIImageView *fadingColorView;
    CGRect headerFrame;
    CGRect subHeaderFrame;
    UILabel *headerLabel;
    UILabel *subHeaderLabel;
    
    UIView *orangeBanner;
    UIView *orangeBannerBackground;
    
    NSString *imageFileToUseInSegue;
    
    NSMutableArray *arrayOfLabels;
    NSArray *arrayOfCheckboxes;
    
    UIView *displayView;
    UIView *checkboxView0;
    UIView *checkboxView1;
    
    EpiInfoTextField *notes;
    BOOL hasAFirstResponder;
    
    UIButton *smsButton;
}
-(void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID;
@end
