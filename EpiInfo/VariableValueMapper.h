//
//  VariableValueMapper.h
//  EpiInfo
//
//  Created by John Copeland on 1/27/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VariableValueMapper : UIView <UITableViewDelegate, UITableViewDataSource>
{
    UIView *whiteView;
    NSArray *allInputValues;
    NSMutableArray *onesNSMA;
    UITableView *onesUITV;
    NSMutableArray *zerosNSMA;
    UITableView *zerosUITV;
    
    NSArray *selectedOnes;
    NSArray *selectedZeros;
}
-(void)setWhiteY:(float)whiteY andValueList:(NSArray *)valueList;
-(UITableView *)onesUITV;
-(UITableView *)zerosUITV;
-(NSMutableArray *)onesNSMA;
-(NSMutableArray *)zerosNSMA;
@end

NS_ASSUME_NONNULL_END
