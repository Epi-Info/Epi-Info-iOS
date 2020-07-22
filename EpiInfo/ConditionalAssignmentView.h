//
//  ConditionalAssignmentView.h
//  EpiInfo
//
//  Created by John Copeland on 10/28/19.
//

#import "AnalysisFilterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConditionalAssignmentView : AnalysisFilterView
{
    NSString *newVariableType;
    NSString *newVariableName;
    NSMutableArray *listOfNewVariables;
    UITableView *newVariableList;
}
-(void)setAnalysisViewController:(UIViewController *)uivc;
-(void)setNewVariableType:(NSString *)nvType;
-(void)setNewVariableName:(NSString *)nvn;
-(void)setListOfNewVariables:(NSMutableArray *)nsma;
-(void)setNewVariableList:(UITableView *)uitv;
@end

NS_ASSUME_NONNULL_END
