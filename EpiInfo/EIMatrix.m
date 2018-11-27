//
//  EIMatrix.m
//  EpiInfo
//
//  Created by John Copeland on 11/26/18.
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

- (id)initWithFirst:(BOOL)mbf AndIntercept:(BOOL)mbi
{
    self = [super init];
    if (self)
    {
        mboolFirst = mbf;
        mboolIntercept = mbi;
    }
    return self;
}

- (void)CalcLikelihood:(int *)lintOffset LdblA:(NSArray *)ldblA LdblB:(NSMutableArray *)ldblB LdblaJacobian:(NSMutableArray *)ldblaJacobian LdblaF:(NSMutableArray *)ldblaF NRows:(int *)nRows Likelihood:(double *)likelihood StrError:(NSString **)strError BooStartAtZero:(BOOL)booStartAtZero
{
    int i = 0;
    BOOL k = NO;
    
    double ncases = 0.0;
    double nrecs = 0.0;
    
    *strError = @"";
    
    if (mboolFirst && mboolIntercept)
    {
        mboolFirst = NO;
        ncases = 0.0;
        for (i = 0; i < ldblA.count; i++)
        {
            
        }
    }
}

- (void)MaximizeLikelihood:(int *)nRows NCols:(int *)nCols DataArray:(NSArray *)dataArray LintOffset:(int *)lintOffset LintMatrixSize:(int *)lintMatrixSize LlngIters:(int *)llngIters LdblToler:(double *)ldblToler LdblConv:(double *)ldblConv BooStartAtZero:(BOOL)booStartAtZero
{
    NSString *strCalcLikelihoodError = @"";
    double ldbllfst = 0.0;
    double ldblaScore[*lintMatrixSize - 1];
    [self setMdblScore:0.0];
    double oldmdblScore = 0.0;
    [self setMboolConverge:YES];
    
    [self setMboolErrorStatus:NO];
    self.mdblaJacobian = [[NSMutableArray alloc] init];
    double oldmdblaJacobian[*lintMatrixSize - 1][*lintMatrixSize - 1];
    self.mdblaInv = [[NSMutableArray alloc] init];
    self.mdblaF = [[NSMutableArray alloc] init];
    double oldmdblaF[*lintMatrixSize - 1];
    
    [self CalcLikelihood:lintOffset LdblA:dataArray LdblB:self.mdblaB LdblaJacobian:self.mdblaJacobian LdblaF:self.mdblaF NRows:nRows Likelihood:&ldbllfst StrError:&strCalcLikelihoodError BooStartAtZero:booStartAtZero];
}
@end
