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

- (double)UnConditional:(int)lintOffset LdblaDataArray:(NSArray *)ldblaDataArray LdblaJacobian:(NSMutableArray *)ldblaJacobian LdblB:(NSMutableArray *)ldblB LdblaF:(NSMutableArray *)ldblaF NRows:(int)nRows
{
    double unconditional = 0.0;
    
    double x[[ldblB count]];
    double ldblIthLikelihood = 0.0;
    double ldblIthContribution = 0.0;
    double ithcontribution = 0.0;
    double ldblweight = 1.0;
    
    for (int i = 0; i < nRows; i++)
    {
        for (int j = 0; j < [ldblB count]; j++)
        {
            x[j] = [[(NSArray *)[ldblaDataArray objectAtIndex:i] objectAtIndex:j + lintOffset] doubleValue];
        }
        
        if (lintOffset == 2)
        {
            ldblweight = [[(NSArray *)[ldblaDataArray objectAtIndex:i] objectAtIndex:1] doubleValue];
        }
        ldblIthLikelihood = 0.0;
        for (int j = 0; j < [ldblB count]; j++)
        {
            ldblIthLikelihood = ldblIthLikelihood + x[j] * [[ldblB objectAtIndex:j] doubleValue];
        }
        ldblIthLikelihood = 1 / (1 + exp(-ldblIthLikelihood));
        if ([[(NSArray *)[ldblaDataArray objectAtIndex:i] objectAtIndex:0] doubleValue] == 0)
        {
            ldblIthContribution = 1.0 - ldblIthLikelihood;
        }
        else
        {
            ldblIthContribution = ldblIthLikelihood;
        }
        for (int k = 0; k < [ldblB count]; k++)
        {
            double oldldblaF = 0.0;
            if ([ldblaF count] > k)
                oldldblaF = [[ldblaF objectAtIndex:k] doubleValue];
            if ([[(NSArray *)[ldblaDataArray objectAtIndex:i] objectAtIndex:0] doubleValue] > 0.0)
            {
                double newldblaF = oldldblaF + (1 - ldblIthLikelihood) * x[k] * ldblweight;
                [ldblaF setObject:[NSNumber numberWithDouble:newldblaF] atIndexedSubscript:k];
            }
            else
            {
                double newldblaF = oldldblaF + (0 - ldblIthLikelihood) * x[k] * ldblweight;
                [ldblaF setObject:[NSNumber numberWithDouble:newldblaF] atIndexedSubscript:k];
            }
            for (int j = 0; j < [ldblB count]; j++)
            {
                double oldldblaJacobianjk = 0.0;
                if ([ldblaJacobian count] > j)
                {
                    NSArray *oldldblaJacobianj = [ldblaJacobian objectAtIndex:j];
                    if ([oldldblaJacobianj count] > k)
                        oldldblaJacobianjk = [[oldldblaJacobianj objectAtIndex:k] doubleValue];
                }
                else
                {
                    [ldblaJacobian setObject:[[NSMutableArray alloc] init] atIndexedSubscript:j];
                }
                double newldblaJacobianjk = oldldblaJacobianjk + (x[k] * x[j] * (1 - ldblIthLikelihood) * ldblIthLikelihood) * ldblweight;
                [(NSMutableArray *)[ldblaJacobian objectAtIndex:j] setObject:[NSNumber numberWithDouble:newldblaJacobianjk] atIndexedSubscript:k];
            }
        }
        unconditional = unconditional + log(ldblIthContribution) * ldblweight;
    }
    
    return unconditional;
}

- (void)CalcLikelihood:(int *)lintOffset LdblA:(NSArray *)ldblA LdblB:(NSMutableArray *)ldblB LdblaJacobian:(NSMutableArray *)ldblaJacobian LdblaF:(NSMutableArray *)ldblaF NRows:(int)nRows Likelihood:(double *)likelihood StrError:(NSString **)strError BooStartAtZero:(BOOL)booStartAtZero
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
            if ([[(NSArray *)[ldblA objectAtIndex:i] objectAtIndex:0] intValue] == 1)
                ncases += 1.0;
            nrecs += 1.0;
        }
        if (ncases > 0.0 && nrecs - ncases > 0.0)
        {
            if (booStartAtZero)
            {
                [ldblB setObject:[NSNumber numberWithDouble:0.0] atIndexedSubscript:[ldblB count] - 1];
            }
            else
            {
                [ldblB setObject:[NSNumber numberWithDouble:log(ncases / (nrecs - ncases))] atIndexedSubscript:[ldblB count] - 1];
            }
        }
        else if (ncases == 0.0)
        {
            *strError = @"Dependent variable contains no cases.";
            return;
        }
        else if (nrecs - ncases == 0.0)
        {
            *strError = @"Dependent variable contains no controls.";
            return;
        }
    }
    if (NO)
    {
        //
    }
    else
    {
        *likelihood = [self UnConditional:lintOffset LdblaDataArray:ldblA LdblaJacobian:ldblaJacobian LdblB:ldblB LdblaF:ldblaF NRows:nRows];
    }
}

- (void)MaximizeLikelihood:(int)nRows NCols:(int *)nCols DataArray:(NSArray *)dataArray LintOffset:(int *)lintOffset LintMatrixSize:(int)lintMatrixSize LlngIters:(int *)llngIters LdblToler:(double *)ldblToler LdblConv:(double *)ldblConv BooStartAtZero:(BOOL)booStartAtZero
{
    NSString *strCalcLikelihoodError = @"";
    double ldbllfst = 0.0;
    double ldblaScore[lintMatrixSize - 1];
    [self setMdblScore:0.0];
    double oldmdblScore = 0.0;
    [self setMboolConverge:YES];
    
    [self setMboolErrorStatus:NO];
    self.mdblaJacobian = [[NSMutableArray alloc] init];
    double oldmdblaJacobian[lintMatrixSize - 1][lintMatrixSize - 1];
    self.mdblaInv = [[NSMutableArray alloc] init];
    self.mdblaF = [[NSMutableArray alloc] init];
    double oldmdblaF[lintMatrixSize - 1];
    
    self.mdblaB = [[NSMutableArray alloc] init];
    for (int i = 0; i < lintMatrixSize; i++)
        [self.mdblaB addObject:[NSNumber numberWithDouble:0.0]];
    
    [self CalcLikelihood:lintOffset LdblA:dataArray LdblB:self.mdblaB LdblaJacobian:self.mdblaJacobian LdblaF:self.mdblaF NRows:nRows Likelihood:&ldbllfst StrError:&strCalcLikelihoodError BooStartAtZero:booStartAtZero];
    
    for (int i = 0; i < [self.mdblaB count]; i++)
    {
        for (int j = 0; j < [self.mdblaB count]; j++)
        {
            oldmdblaJacobian[i][j] = [[(NSArray *)[self.mdblaJacobian objectAtIndex:i] objectAtIndex:j] doubleValue];
        }
        oldmdblaF[i] = [[self.mdblaF objectAtIndex:i] doubleValue];
    }
    for (int i = 0; i < [self.mdblaB count]; i++)
    {
        for (int j = 0; j < [self.mdblaB count]; j++)
        {
            NSLog(@"%f", oldmdblaJacobian[i][j]);
        }
        NSLog(@"\t\t%.6e", oldmdblaF[i]);
    }
}
@end
