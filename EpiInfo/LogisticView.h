//
//  LogisticView.h
//  EpiInfo
//
//  Created by John Copeland on 11/9/18.
//

#import "TablesView.h"
#import "LogisticObject.h"
#import "LogisticRegressionResults.h"
#import "VariableRow.h"
#import "InteractionRow.h"
#import "sqlite3.h"
#import "EIMatrix.h"
#import "VariableValueMapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogisticView : TablesView <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    EIMatrix *mMatrixLikelihood;
    sqlite3 *analysisDB;
    NSArray *currentTable;
    NSArray *lStrAVarNames;
    NSString *mstrC;
    double mdblC;
    double mdblP;
    int mlngIter;
    double mdblConv;
    double mdblToler;
    BOOL mboolFirst;
    BOOL mboolIntercept;
    NSArray *mstraBoolean;
    NSString *mstrMatchVar;
    NSString *mstrWeightVar;
    NSString *mstrDependVar;
    NSMutableArray *mstraTerms;
    NSMutableArray *mStrADiscrete;
    int terms, discrete;
    int lintIntercept, lintweight, NumRows, NumColumns;
    
    UILabel *groupVariableLabel;
    LegalValuesEnter *groupVariableLVE;
    
    NSMutableArray *exposuresNSMA;
    UITableView *exposuresUITV;
    
    UIButton *makeDummyButton;
    NSString *exposureVariableSelected;
    
    NSMutableArray *dummiesNSMA;
    UITableView *dummiesUITV;
    
    LogisticObject *to;
    
    CGSize avDefaultContentSize;
    
    NSMutableArray *outputViewsNSMA;
    float initialOutputViewY;
    UIView *oddsTableView;
    
    VariableValueMapper *exposureValueMapper;
    UIButton *mapExposureValuesButton;
    NSString *previousExposureVariableValue;
}
@end

NS_ASSUME_NONNULL_END
