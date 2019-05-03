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
@synthesize lstrError = _lstrError;
@synthesize mstrMatchVar = _mstrMatchVar;
@synthesize matchGroupValues = _matchGroupValues;

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

- (void)lubksb:(NSMutableArray *)a N:(int)n Indx:(int[])indx B:(double[])B
{
    int ii = 0;
    int ip = 0;
    double sum = 0.0;
    
    for (int i = 0; i < n; i++)
    {
        ip = indx[i + 1];
        sum = B[ip];
        B[ip] = B[i + 1];
        if (ii > 0)
        {
            for (int j = ii; j <= i; j++)
            {
                sum = sum - [[(NSArray *)[a objectAtIndex:i] objectAtIndex:j - 1] doubleValue] * B[j];
            }
        }
        else if (sum != 0.0)
        {
            ii = i + 1;
        }
        B[i + 1] = sum;
    }
    for (int i = n - 1; i >= 0; i--)
    {
        sum = B[i + 1];
        for (int j = i + 1; j < n; j++)
        {
            sum = sum - [[(NSArray *)[a objectAtIndex:i] objectAtIndex:j] doubleValue] * B[j + 1];
        }
        B[i + 1] = sum / [[(NSArray *)[a objectAtIndex:i] objectAtIndex:i] doubleValue];
    }
}

- (int)ludcmp:(NSMutableArray *)a N:(int)n Indx:(int[])indx D:(double *)d
{
    *d = 44.5;
    const double TINY = 1.0e-20;
    
    int imax = 0;
    double dum = 0.0;
    double big = 0.0;
    double sum = 0.0;
    double vv[n];
    
    *d = 1.0;
    for (int i = 0; i < n; i++)
    {
        big = 0.0;
        for (int j = 0; j < n; j++)
        {
            double absaij = fabs([[(NSArray *)[a objectAtIndex:i] objectAtIndex:j] doubleValue]);
            if (absaij > big)
            {
                big = absaij;
            }
        }
        if (big == 0.0)
        {
            return -1;
        }
        vv[i] = 1.0 / big;
    }
    for (int j = 0; j < n; j++)
    {
        for (int i = 0; i < j; i++)
        {
            sum = [[(NSArray *)[a objectAtIndex:i] objectAtIndex:j] doubleValue];
            for (int k = 0; k < i; k++)
            {
                sum = sum - [[(NSArray *)[a objectAtIndex:i] objectAtIndex:k] doubleValue] * [[(NSArray *)[a objectAtIndex:k] objectAtIndex:j] doubleValue];
            }
            [(NSMutableArray *)[a objectAtIndex:i] setObject:[NSNumber numberWithDouble:sum] atIndexedSubscript:j];
        }
        big = 0.0;
        for (int i = j; i < n; i++)
        {
            sum = [[(NSArray *)[a objectAtIndex:i] objectAtIndex:j] doubleValue];
            for (int k = 0; k < j; k++)
            {
                sum = sum - [[(NSArray *)[a objectAtIndex:i] objectAtIndex:k] doubleValue] * [[(NSArray *)[a objectAtIndex:k] objectAtIndex:j] doubleValue];
            }
            [(NSMutableArray *)[a objectAtIndex:i] setObject:[NSNumber numberWithDouble:sum] atIndexedSubscript:j];
            dum = vv[i] * fabs(sum);
            if (dum >= big)
            {
                big = dum;
                imax = i;
            }
        }
        if (j != imax)
        {
            for (int k = 0; k < n; k++)
            {
                dum = [[(NSArray *)[a objectAtIndex:imax] objectAtIndex:k] doubleValue];
                [(NSMutableArray *)[a objectAtIndex:imax] setObject:[NSNumber numberWithDouble:[[(NSArray *)[a objectAtIndex:j] objectAtIndex:k] doubleValue]] atIndexedSubscript:k];
                [(NSMutableArray *)[a objectAtIndex:j] setObject:[NSNumber numberWithDouble:dum] atIndexedSubscript:k];
            }
            *d = -1.0 * *d;
            vv[imax] = vv[j];
        }
        indx[j] = imax + 1;
        if ([[(NSArray *)[a objectAtIndex:j] objectAtIndex:j] doubleValue] == 0.0)
        {
            [(NSMutableArray *)[a objectAtIndex:j] setObject:[NSNumber numberWithDouble:TINY] atIndexedSubscript:j];
        }
        if (j != n)
        {
            dum = 1.0 / [[(NSArray *)[a objectAtIndex:j] objectAtIndex:j] doubleValue];
            for (int i = j + 1; i < n; i++)
            {
                double oldvalue = [[(NSArray *)[a objectAtIndex:i] objectAtIndex:j] doubleValue];
                double newvalue = oldvalue * dum;
                [(NSMutableArray *)[a objectAtIndex:i] setObject:[NSNumber numberWithDouble:newvalue] atIndexedSubscript:j];
            }
        }
    }
    return 1;
}

- (void)inv:(NSMutableArray *)a InvA:(NSMutableArray *)invA
{
    int n = (int)[(NSArray *)[a objectAtIndex:0] count];
    int indx[n + 2];
    for (int i = 0; i < n + 2; i++)
        indx[i] = 0;
    double col[n + 2];
    double d = 0.0;
    [self ludcmp:a N:n Indx:indx D:&d];
    
    for (int j = 0; j < n; j++)
    {
        for (int i = 0; i < n; i++)
        {
            col[i] = 0.0;
        }
        col[j] = 1.0;
        
        int indxShifted[n + 3];
        double colShifted[n + 3];
        indxShifted[0] = 0;
        colShifted[0] = 0.0;
        
        for (int k = 0; k < n + 2; k++)
        {
            indxShifted[k + 1] = indx[k];
            colShifted[k + 1] = col[k];
        }
        
        [self lubksb:a N:n Indx:indxShifted B:colShifted];
        for (int i = 0; i < n; i++)
        {
            [(NSMutableArray *)[invA objectAtIndex:i] setObject:[NSNumber numberWithDouble:colShifted[i + 1]] atIndexedSubscript:j];
        }
    }
}

- (double)Conditional:(int)lintOffset LdblaDataArray:(NSArray *)ldblaDataArray LdblaJacobian:(NSMutableArray *)ldblaJacobian LdblB:(NSMutableArray *)ldblB LdblaF:(NSMutableArray *)ldblaF NRows:(int)nRows
{
    double conditional = 0.0;
    
    double x[[ldblB count]];
    double lDblAParamSum[[ldblB count]];
    double t[[ldblB count]];
    double c[[ldblB count]][[ldblB count]];
    for (int i = 0; i < [ldblB count]; i++)
    {
        x[i] = 0.0;
        lDblAParamSum[i] = 0.0;
        t[i] = 0.0;
        for (int j = 0; j < [ldblB count]; j++)
        {
            c[i][j] = 0.0;
        }
    }
    double IthLikelihood = 0.0;
    double LogLikelihood = 0.0;
    LogLikelihood = 0.0;
    double likelihood = 1.0;
    likelihood = 1.0;
    double ldblweight = 1.0;
    
    int lIntRow = 1;
    int lLevels = 0;
    double lLeveldata = 0.0;
    double lDblT0 = 0.0;
    
    int cases = 0;
    int count = 0;
    
    for (int s = 0; s < self.matchGroupValues; s++)
    {
        lIntRow += lLevels;
        lLevels = 1;
        lLeveldata = [(NSNumber *)[(NSArray *)[ldblaDataArray objectAtIndex:lIntRow] objectAtIndex:1] doubleValue];
        
        if (s + 1 == self.matchGroupValues)
        {
            lLevels = nRows - lIntRow + 1;
        }
        else
        {
            while (lLeveldata == [(NSNumber *)[(NSArray *)[ldblaDataArray objectAtIndex:(lIntRow + lLevels - 1)] objectAtIndex:1] doubleValue])
            {
                lLevels++;
            }
        }
        
        lDblT0 = 0.0;
        cases = 0;
        count = 0;
        for (int i = lIntRow - 1; i < lLevels + lIntRow - 1; i++)
        {
            if (lintOffset == 3)
            {
                ldblweight = [(NSNumber *)[(NSArray *)[ldblaDataArray objectAtIndex:i] objectAtIndex:lintOffset] doubleValue];
            }
            count += ldblweight;
            for (int j = 0; j < [ldblB count]; j++)
            {
                x[j] = [(NSNumber *)[(NSArray *)[ldblaDataArray objectAtIndex:i] objectAtIndex:j + lintOffset] doubleValue];
            }
            
            if ([(NSNumber *)[(NSArray *)[ldblaDataArray objectAtIndex:i] objectAtIndex:0] doubleValue] > 0)
            {
                for (int j = 0; j < [ldblB count]; j++)
                {
                    lDblAParamSum[j] += x[j];
                }
                cases += ldblweight;
            }
            
            IthLikelihood = 0.0;
            for (int j = 0; j < [ldblB count]; j++)
            {
                IthLikelihood += (x[j] * [(NSNumber *)[ldblB objectAtIndex:j] doubleValue]);
            }
            IthLikelihood = exp(IthLikelihood);
            IthLikelihood *= ldblweight;
            
            lDblT0 += IthLikelihood;
            for (int k = 0; k < [ldblB count]; k++)
            {
                t[k] += (IthLikelihood * x[k]);
            }
            for (int k = 0; k < [ldblB count]; k++)
            {
                for (int j = 0; j < [ldblB count]; j++)
                {
                    c[j][k] += (x[j] * x[k] * IthLikelihood);
                }
           }
        }
        
        IthLikelihood = 0.0;
        for (int i = 0; i < [ldblB count]; i++)
        {
            IthLikelihood += (lDblAParamSum[i] * [(NSNumber *)[ldblB objectAtIndex:i] doubleValue]);
        }
        
        BOOL contrast = YES;
        if (cases == count || cases == 0)
            contrast = NO;
        if (contrast)
        {
            conditional += (IthLikelihood - log(lDblT0));
            for (int i = 0; i < [ldblB count]; i++)
            {
                double ldblaFi = [(NSNumber *)[ldblaF objectAtIndex:i] doubleValue];
                ldblaFi += (lDblAParamSum[i] - (t[i] / lDblT0));
                [ldblaF setObject:[NSNumber numberWithDouble:ldblaFi] atIndexedSubscript:i];
            }
            for (int i = 0; i < [ldblB count]; i++)
            {
                for (int k = 0; k < [ldblB count]; k++)
                {
                    double ldblaJacobianik = [(NSNumber *)[(NSArray *)[ldblaJacobian objectAtIndex:i] objectAtIndex:k] doubleValue];
                    ldblaJacobianik = ldblaJacobianik + c[i][k] / lDblT0 - t[i] * t[k] / (lDblT0 * lDblT0);
                    [(NSMutableArray *)[ldblaJacobian objectAtIndex:i] setObject:[NSNumber numberWithDouble:ldblaJacobianik] atIndexedSubscript:k];
                }
            }
        }
        for (int i = 0; i < [ldblB count]; i++)
        {
            lDblAParamSum[i] = 0.0;
            t[i] = 0.0;
            for (int k = 0; k < [ldblB count]; k++)
            {
                c[i][k] = 0.0;
            }
        }
    }
    
    return conditional;
}
- (double)UnConditional:(int)lintOffset LdblaDataArray:(NSArray *)ldblaDataArray LdblaJacobian:(NSMutableArray *)ldblaJacobian LdblB:(NSMutableArray *)ldblB LdblaF:(NSMutableArray *)ldblaF NRows:(int)nRows
{
    double unconditional = 0.0;
    
    double x[[ldblB count]];
    double ldblIthLikelihood = 0.0;
    double ldblIthContribution = 0.0;
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
    k = NO;
    
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
    if ([self.mstrMatchVar length] > 0)
    {
        for (int i = 0; i < [ldblB count]; i++)
        {
            [ldblaF addObject:[NSNumber numberWithDouble:0.0]];
            NSMutableArray *arrayfori = [[NSMutableArray alloc] init];
            for (int j = 0; j < [ldblB count]; j++)
            {
                [arrayfori addObject:[NSNumber numberWithDouble:0.0]];
            }
            [ldblaJacobian addObject:arrayfori];
        }
        *likelihood = [self Conditional:lintOffset LdblaDataArray:ldblA LdblaJacobian:ldblaJacobian LdblB:ldblB LdblaF:ldblaF NRows:nRows];
    }
    else
    {
        *likelihood = [self UnConditional:lintOffset LdblaDataArray:ldblA LdblaJacobian:ldblaJacobian LdblB:ldblB LdblaF:ldblaF NRows:nRows];
    }
}

- (void)MaximizeLikelihood:(int *)nRows NCols:(int *)nCols DataArray:(NSArray *)dataArray LintOffset:(int *)lintOffset LintMatrixSize:(int)lintMatrixSize LlngIters:(int *)llngIters LdblToler:(double *)ldblToler LdblConv:(double *)ldblConv BooStartAtZero:(BOOL)booStartAtZero
{
    NSString *strCalcLikelihoodError = @"";
    self.lstrError = strCalcLikelihoodError;
    double ldbllfst = 0.0;
    [self setMdblScore:0.0];
    double oldmdblScore = 0.0;
    oldmdblScore = 0.0;
    [self setMboolConverge:YES];
    
    [self setMboolErrorStatus:NO];
    self.mdblaJacobian = [[NSMutableArray alloc] init];
    double oldmdblaJacobian[lintMatrixSize - 1][lintMatrixSize - 1];
    self.mdblaInv = [[NSMutableArray alloc] init];
    self.mdblaF = [[NSMutableArray alloc] init];
    double oldmdblaF[lintMatrixSize - 1];
    self.mboolConverge = YES;

    self.mdblaB = [[NSMutableArray alloc] init];
    for (int i = 0; i < lintMatrixSize; i++)
        [self.mdblaB addObject:[NSNumber numberWithDouble:0.0]];
    
    [self CalcLikelihood:lintOffset LdblA:dataArray LdblB:self.mdblaB LdblaJacobian:self.mdblaJacobian LdblaF:self.mdblaF NRows:nRows Likelihood:&ldbllfst StrError:&strCalcLikelihoodError BooStartAtZero:booStartAtZero];

    for (int i = 0; i < [self.mdblaB count]; i++)
    {
        NSMutableArray *forInv = [[NSMutableArray alloc] init];
        for (int j = 0; j < [self.mdblaB count]; j++)
        {
            [forInv addObject:[NSNumber numberWithDouble:0.0]];
            oldmdblaJacobian[i][j] = [[(NSArray *)[self.mdblaJacobian objectAtIndex:i] objectAtIndex:j] doubleValue];
        }
        [self.mdblaInv addObject:forInv];
        oldmdblaF[i] = [[self.mdblaF objectAtIndex:i] doubleValue];
    }

    if ([strCalcLikelihoodError length] > 0)
    {
        // Do something to display the error
        return;
    }
    
    self.mintIterations = 1;
    double ldbloldll = ldbllfst;
    double ldbll = ldbllfst;
    if (ldbllfst > 0)
    {
        // Message Positive Log-Likelihood, regression is diverging
        self.mboolConverge = NO;
        strCalcLikelihoodError = @"Positive Log-Likelihood, regression is diverging";
        return;
    }
    [self inv:self.mdblaJacobian InvA:self.mdblaInv];

    NSArray *oldmdblaB = [NSArray arrayWithArray:self.mdblaB];
    NSArray *oldmdblaInv = [NSArray arrayWithArray:self.mdblaInv];
    double ldblDet = 1.0;
    for (int i = 0; i < [self.mdblaB count]; i++)
    {
        ldblDet *= [[(NSArray *)[self.mdblaJacobian objectAtIndex:i] objectAtIndex:i] doubleValue];
    }
    
    if (fabs(ldblDet) < *ldblToler)
    {
        self.mboolConverge = NO;
        strCalcLikelihoodError = @"Matrix Tolerance Exceeded";
        return;
    }
    
    double ldblaScore[lintMatrixSize];
    for (int i = 0; i < lintMatrixSize; i++)
        ldblaScore[i] = 0.0;
    // Now find the delta coefficients for this iteration and clear the arrays at the same time
    for (int i = 0; i < [self.mdblaB count]; i++)
    {
        for (int k = 0; k < [self.mdblaB count]; k++)
        {
            double mdblainfik = [[(NSArray *)[self.mdblaInv objectAtIndex:i] objectAtIndex:k] doubleValue];
            double mdblafk = [[self.mdblaF objectAtIndex:k] doubleValue];
            double onetimestheother = mdblafk * mdblainfik;
            ldblaScore[i] = ldblaScore[i] + onetimestheother;
            [(NSMutableArray *)[self.mdblaJacobian objectAtIndex:i] setObject:[NSNumber numberWithDouble:0.0] atIndexedSubscript:k];
        }
        [self.mdblaB setObject:[NSNumber numberWithDouble:[[self.mdblaB objectAtIndex:i] doubleValue] + ldblaScore[i]] atIndexedSubscript:i];
        self.mdblScore = self.mdblScore + ldblaScore[i] * [[self.mdblaF objectAtIndex:i] doubleValue];
    }
    
    double ridge = 0.0;
    for (self.mintIterations = 2; self.mintIterations < *llngIters; self.mintIterations++)
    {
        for (int i = 0; i < [self.mdblaF count]; i++)
        {
            [self.mdblaF setObject:[NSNumber numberWithDouble:0.0] atIndexedSubscript:i];
        }
           [self CalcLikelihood:lintOffset LdblA:dataArray LdblB:self.mdblaB LdblaJacobian:self.mdblaJacobian LdblaF:self.mdblaF NRows:nRows Likelihood:&ldbll StrError:&strCalcLikelihoodError BooStartAtZero:booStartAtZero];
        BOOL doThisStuff = YES;
        if (ldbloldll - ldbll > *ldblConv)
        {
            if (ridge > 0.0 && ridge < 1000.0)
            {
                self.mintIterations--;
                ridge *= 4.0;
                for (int i = 0; i < [self.mdblaB count]; i++)
                {
                    for (int j = 0; j < [self.mdblaB count]; j++)
                    {
                        double iequalsj = 0.0;
                        if (i == j)
                            iequalsj = 1.0;
                        [(NSMutableArray *)[self.mdblaJacobian objectAtIndex:i] setObject:[NSNumber numberWithDouble:oldmdblaJacobian[i][j] *(1 + iequalsj * ridge)] atIndexedSubscript:j];
                    }
                    [self.mdblaB setObject:[NSNumber numberWithDouble:[(NSNumber *)[oldmdblaB objectAtIndex:i] doubleValue]] atIndexedSubscript:i];
                    [self.mdblaF setObject:[NSNumber numberWithDouble:oldmdblaF[i]] atIndexedSubscript:i];
                }
                doThisStuff = NO;
            }
            if (doThisStuff)
            {
                self.mboolConverge = NO;
                self.mdblllfst = ldbllfst;
                strCalcLikelihoodError = @"Regression not converging";
            }
        }
        else if (ldbll - ldbloldll < *ldblConv)
        {
            self.mdblaB = [NSMutableArray arrayWithArray:oldmdblaB];
            self.mintIterations--;
            self.mdblllfst = ldbllfst;
            self.mdbllllast = ldbll;
            return;
        }
        
        if (doThisStuff)
        {
            oldmdblaInv = [NSArray arrayWithArray:self.mdblaInv];
            oldmdblaB = [NSArray arrayWithArray:self.mdblaB];
            for (int i = 0; i < [self.mdblaB count]; i++)
            {
                for (int j = 0; j < [self.mdblaB count]; j++)
                {
                    oldmdblaJacobian[i][j] = [(NSNumber *)[(NSArray *)[self.mdblaJacobian objectAtIndex:i] objectAtIndex:j] doubleValue];
                }
                oldmdblaF[i] = [(NSNumber *)[self.mdblaF objectAtIndex:i] doubleValue];
            }
            ridge = 0.0;
            ldbloldll = ldbll;
        }
        
        [self inv:self.mdblaJacobian InvA:self.mdblaInv];
        ldblDet = 1.0;
        for (int i = 0; i < [self.mdblaB count]; i++)
        {
            ldblDet = ldblDet * [(NSNumber *)[(NSArray *)[self.mdblaJacobian objectAtIndex:i] objectAtIndex:i] doubleValue];
        }
        
        if (fabs(ldblDet) < *ldblToler)
        {
            self.mboolConverge = NO;
            strCalcLikelihoodError = @"Matrix Tolerance Exceeded";
            return;
        }
        
        // Find the delta coefficients for this iteration and clear the arrays at the same time.
        for (int i = 0; i < [self.mdblaB count]; i++)
        {
            for (int k = 0; k < [self.mdblaB count]; k++)
            {
                [self.mdblaB setObject:[NSNumber numberWithDouble:[(NSNumber *)[self.mdblaB objectAtIndex:i] doubleValue] + [(NSNumber *)[self.mdblaF objectAtIndex:k] doubleValue] * [(NSNumber *)[(NSArray *)[self.mdblaInv objectAtIndex:i] objectAtIndex:k] doubleValue]] atIndexedSubscript:i];
                [(NSMutableArray *)[self.mdblaJacobian objectAtIndex:i] setObject:[NSNumber numberWithDouble:0.0] atIndexedSubscript:k];
            }
        }
    }
    
    self.mdblllfst = ldbllfst;
    self.mdbllllast = ldbll;
}
@end
