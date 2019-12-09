//
//  LegalValuesEnter.h
//  EpiInfo
//
//  Created by admin on 2/19/16.
//

#import <UIKit/UIKit.h>
#import "EpiInfoControlProtocol.h"
#import "DownTriangle.h"
#import "DownTriangleAnalysisStyle.h"

@interface LegalValuesEnter : UIView <UIPickerViewDelegate, UIPickerViewDataSource, EpiInfoControlProtocol, UITableViewDelegate, UITableViewDataSource>
{
    float topX;
    float topY;
    float finalTopY;
    UILabel *picked;
    //    UIPickerView *picker;
    NSMutableArray *listOfValues;
    UIView *valueButtonView;
    UIView *shield;
    
    BOOL isAnalysisStyle;
}
@property NSString *columnName;
@property BOOL isReadOnly;
@property UIPickerView *picker;
@property UITextField *textFieldToUpdate;
@property UIView *viewToAlertOfChanges;
@property NSNumber *selectedIndex;
@property UIButton *valueButton;
@property UITableView *tv;
- (void)setListOfValues:(NSMutableArray *)lov;
- (NSMutableArray *)listOfValues;
- (NSString *)picked;
- (void)setPicked:(NSString *)pkd;
- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov;
- (id)initWithFrame:(CGRect)frame ForOptionsField:(BOOL)forOptionsField;
- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov ForOptionsField:(BOOL)forOptionsField;
- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov AndTextFieldToUpdate:(UITextField *)tftu;
- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov NoFixedDimensions:(BOOL)nfd;
- (id)initWithFrame:(CGRect)frame AndListOfValues:(NSMutableArray *)lov AndTextFieldToUpdate:(UITextField *)tftu NoFixedDimensions:(BOOL)nfd;
-(void)reset;
-(void)setSelectedLegalValue:(NSString *)selectedLegalValue;
-(void)setFormFieldValue:(NSString *)formFieldValue;
-(void)removeValueButtonViewFromSuperview;
-(float)contentSizeHeightAdjustment;
-(void)analysisStyle;
-(void)valueButtonPressed:(id)sender;
@end
