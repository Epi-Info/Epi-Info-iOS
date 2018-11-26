//
//  EIMatrix.m
//  EpiInfo
//
//  Created by John Copeland on 11/26/18.
//  Copyright © 2018 John Copeland. All rights reserved.
//

#import "EIMatrix.h"

@implementation EIMatrix
@synthesize mdblaJacobian = _mdblaJacobian;
@synthesize mdblaInv = _mdblaInv;
@synthesize mdblaB = _mdblaB;
@synthesize mdblaF = _mdblaF;
@synthesize mboolConverge = _mboolConverge;
@synthesize mboolErrorStatus = _mboolErrorStatus;
@synthesize mdblllfst = _mdblllfst;
@synthesize mdbllllast = _mdbllllast;
@synthesize mdblScore = _mdblScore;
@synthesize mintIterations = _mintIterations;

- (void)MaximizeLikelihood:(int)nRows NCols:(int)nCols DataArray:(NSArray *)dataArray LintOffset:(int)lintOffset LintMatrixSize:(int)lintMatrixSize LlngIters:(int)llngIters LdblToler:(double)ldblToler LdblConv:(double)ldblConv BooStartAtZero:(BOOL)booStartAtZero
{
    
}
@end
