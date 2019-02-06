//
//  LinearView.h
//  EpiInfo
//
//  Created by John Copeland on 2/4/19.
//

#import "TablesView.h"
#import "LinearObject.h"
#import "LinearRegressionResults.h"
#import "sqlite3.h"
#import "EIMatrix.h"

NS_ASSUME_NONNULL_BEGIN

@interface LinearView : TablesView <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
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
    NSString *mstrWeightVar;
    NSString *mstrDependVar;
    NSMutableArray *mstraTerms;
    NSMutableArray *mStrADiscrete;
    int terms, discrete;
    int lintIntercept, lintweight, NumRows, NumColumns;
    
    NSMutableArray *exposuresNSMA;
    UITableView *exposuresUITV;
    
    UIButton *makeDummyButton;
    NSString *exposureVariableSelected;
    
    NSMutableArray *dummiesNSMA;
    UITableView *dummiesUITV;
    
    LinearObject *to;
    
    CGSize avDefaultContentSize;
}
@end

NS_ASSUME_NONNULL_END
