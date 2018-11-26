//
//  EIMatrix.h
//  EpiInfo
//
//  Created by John Copeland on 11/26/18.
//  Copyright © 2018 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EIMatrix : NSObject
@property NSMutableArray *mdblaJacobian;
@property NSMutableArray *mdblaInv;
@property NSMutableArray *mdblaB;
@property NSMutableArray *mdblaF;
@property BOOL mboolConverge;
@property BOOL mboolErrorStatus;
@property double mdblllfst;
@property double mdbllllast;
@property double mdblScore;
@property int mintIterations;

-(void)MaximizeLikelihood:(int)nRows NCols:(int)nCols DataArray:(NSArray *)dataArray LintOffset:(int)lintOffset LintMatrixSize:(int)lintMatrixSize LlngIters:(int)llngIters LdblToler:(double)ldblToler LdblConv:(double)ldblConv BooStartAtZero:(BOOL)booStartAtZero;
@end

NS_ASSUME_NONNULL_END
