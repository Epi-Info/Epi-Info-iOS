//
//  LogisticView.h
//  EpiInfo
//
//  Created by John Copeland on 11/9/18.
//  Copyright © 2018 John Copeland. All rights reserved.
//

#import "TablesView.h"
#import "LogisticRegressionResults.h"
#import "VariableRow.h"
#import "InteractionRow.h"
#import "sqlite3.h"
#import "EIMatrix.h"
#import "EpiInfoTextField.h"

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
    
    UILabel *outcomeVariableLabel;
    UITextField *outcomeVariableString;
    LegalValuesEnter *outcomeLVE;
    UILabel *exposureVariableLabel;
    EpiInfoTextField *exposureVariableString;
    LegalValuesEnter *exposureLVE;
    
    NSMutableArray *exposuresNSMA;
    UITableView *exposuresUITV;
}
@end

NS_ASSUME_NONNULL_END
