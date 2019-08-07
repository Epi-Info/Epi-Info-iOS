//
//  CheckCodeWriter.h
//  EpiInfo
//
//  Created by John Copeland on 4/29/19.
//

#import <UIKit/UIKit.h>
#import "IfBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckCodeWriter : UIView
{
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
    UILabel *fourthLabel;
    UILabel *fifthLabel;
    UILabel *sixthLabel;

    UIView *senderSuperview;
    NSString *beginFieldString;
    NSString *endFieldString;
    NSMutableArray *beforeFunctions;
    NSMutableArray *afterFunctions;
    NSMutableArray *clickFunctions;
    
    UIButton *beforeButton;
    UIButton *afterButton;
}
-(id)initWithFrame:(CGRect)frame AndFieldName:(NSString *)fn AndFieldType:(NSString *)ft AndSenderSuperview:(UIView *)sv;
-(NSString *)beginFieldString;
-(void)setBeginFieldString:(NSString *)bfs;
-(NSString *)endFieldString;
-(void)setEndFieldString:(NSString *)efs;
-(void)addAfterFunction:(NSString *)function;
-(void)addBeforeFunction:(NSString *)function;
-(void)addClickFunction:(NSString *)function;
-(NSMutableArray *)beforeFunctions;
-(NSMutableArray *)afterFunctions;
-(NSMutableArray *)clickFunctions;
-(void)closeButtonPressed:(UIButton *)sender;
-(void)ifButtonPressed:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
