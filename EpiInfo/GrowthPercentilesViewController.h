//
//  GrowthPercentilesViewController.h
//  EpiInfo
//
//  Created by John Copeland on 6/19/14.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ZoomView.h"
#import "Checkbox.h"
#import "NumberField.h"
#import "GrowthPercentilesCompute.h"

@interface GrowthPercentilesViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    BOOL hasAFirstResponder;

    UIButton *customBackButton;
    
    CGRect scrollViewFrame;
    UIImageView *fadingColorView;
    UIImageView *fadingColorView0;
    
    ZoomView *zoomingView;
    
    UIView *headerView;
    
    GrowthPercentilesCompute *gpc;
    
    UIView *maleFemaleView;
    Checkbox *maleChecked;
    Checkbox *femaleChecked;
    
    UIView *ageView;
    NumberField *ageField;
    
    UIView *lengthForAgeView;
    BOOL centimeters;
    NumberField *lengthField;
    UILabel *lengthForAgePercent;
    
    UIView *weightForAgeView;
    BOOL kilograms;
    NumberField *weightField;
    UILabel *weightForAgePercent;
    
    UIView *circumferenceForAgeView;
    BOOL ccentimeters;
    NumberField *circumferenceField;
    UILabel *circumferenceForAgePercent;
}
@property (weak, nonatomic) IBOutlet UIScrollView *epiInfoScrollView0;
@end
