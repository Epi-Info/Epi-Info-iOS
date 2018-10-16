//
//  Twox2Compute.m
//  StatCalc2x2
//
//  Adaptation by John Copeland begun on 9/7/12.
//
//  This class contains the methods for cumputing statistics
//  associated with a single-stratum 2x2 table.  It receives
//  the four cell values as inputs.
//

#import "Twox2Compute.h"
#import "SharedResources.h"

@implementation Twox2Compute
-(double)OddsRatioEstimate:(int)a cellb:(int)b cellc:(int)c celld:(int)d
{
    if (b * c == 0)
        return INFINITY;
    else if (a * d == 0)
        return 0.0;
    else
        return round(10000 * (((double)a * (double)d) / ((double)b * (double)c))) / 10000;
}

- (double)OddsRatioLower:(int)a cellb:(int)b cellc:(int)c celld:(int)d
{
    if (b * c == 0)
        return INFINITY;
    else if (a * d == 0)
        return 0.0;
    else
        return round(10000 * exp(log(((double)a * (double)d) / ((double)b * (double)c)) - 1.96 * sqrt(1 / (double)a + 1 / (double)b + 1 / (double)c + 1 / (double)d))) / 10000;
}

- (double)OddsRatioUpper:(int)a cellb:(int)b cellc:(int)c celld:(int)d
{
    if (b * c == 0)
        return INFINITY;
    else if (a * d == 0)
        return 0.0;
    else
        return round(10000 * exp(log(((double)a * (double)d) / ((double)b * (double)c)) + 1.96 * sqrt(1 / (double)a + 1 / (double)b + 1 / (double)c + 1 / (double)d))) / 10000;
}

// More testing...
// One more time...

- (double)FishOR:(int)a cellb:(int)b cellc:(int)c celld:(int)d alpha:(double)alpha initialOR:(double)OR plusA:(int)plusA one:(int)one minus:(int)minus PBLowerVariable:(BOOL)pbLower PBFisherVariable:(BOOL)pbFisher
{
    int m1 = a + c;
    int n0 = c + d;
    int n1 = a + b;
    int maxK = m1;
    if (n1 < m1)
        maxK = n1;
    int minK = 0;
    if (m1 - n0 > 0)
        minK = m1 - n0;
//    double polyDD[(maxK - minK) + 1];
    BigDouble *bigPolyDD[(maxK - minK) + 1];
//    polyDD[0] = 1.0;
    bigPolyDD[0] = [[BigDouble alloc] initWithDouble:1.0];
    int bb = m1 - minK + 1;
    int cc = n1 - minK + 1;
    int dd = n0 - m1 + minK;
//    double polyDDI = polyDD[0];
    BigDouble *bigPolyDDI = [[BigDouble alloc] initWithLogDouble:[bigPolyDD[0] logValue]];
    int degD = (maxK - minK) + 1;
    for (int i = 1; i < degD; i++)
    {
//        polyDD[i] = polyDD[i - 1] * ((double)(bb - i) / (double)(minK + i)) * ((double)(cc - i) / (double)(dd + i));
        bigPolyDD[i] = [[BigDouble alloc] initWithLogDouble:[bigPolyDD[i - 1] timesReturn:((double)(bb - i) / (double)(minK + i)) * ((double)(cc - i) / (double)(dd + i))]];
//        polyDDI = polyDD[i];
        [bigPolyDDI setLogValue:[bigPolyDD[i] logValue]];
    }
    return [self CalcExactLim:pbLower IsItFisher:pbFisher ApproxVariable:OR MinSumAVariable:minK SumAVariable:a MaxSumAVariable:maxK DegDVariable:degD BigPolyD:bigPolyDD];
}

- (double)CalcPoly:(double)yy CPyn:(double)yn CPny:(double)ny CPnn:(double)nn CPExactResults:(double[])ExactResults
{
    double n0 = ny + nn;
    double n1 = yy + yn;
    double m1 = yy + ny;
    double minA = 0.0;
    if (m1 - n0 > 0.0)
        minA = m1 - n0;
    double maxA = m1;
    if (n1 < m1)
        maxA = n1;
//    double polyD[(int) (maxA - minA + 1)];
    BigDouble *bigPolyD[(int) (maxA - minA + 1)];
//    polyD[0] = 1.0;
    bigPolyD[0] = [[BigDouble alloc] initWithDouble:1.0];
    double aa = minA;
    double bb = m1 - minA + 1.0;
    double cc = n1 - minA + 1.0;
    double dd = n0 - m1 + minA;
    for (int i = 1; i < maxA - minA + 1; i++)
    {
//        polyD[i] = polyD[i - 1] * ((bb - i) / (aa + i)) * ((cc - i) / (dd + i));
        bigPolyD[i] = [[BigDouble alloc] initWithLogDouble:[bigPolyD[i - 1] timesReturn:((bb - i) / (aa + i)) * ((cc - i) / (dd + i))]];
    }
    
    ExactResults[0] =  [self CalcCmle:1.0 CCminSumA:minA CCsumA:yy CCmaxSumA:maxA CCdegN:(maxA - minA + 1) BigPolyD:bigPolyD];
    double ExactTests[5];
    [self ExactTests:minA ETsumA:yy ETdegD:maxA - minA ETExactTests:ExactTests BigPolyD:bigPolyD];
    ExactResults[1] = ExactTests[3];
    if (ExactTests[4] < ExactTests[3])
        ExactResults[1] = ExactTests[4];
    ExactResults[2] = ExactTests[0];
    if (ExactTests[1] < ExactTests[0])
        ExactResults[2] = ExactTests[1];
    ExactResults[3] = ExactTests[2];
    return ExactResults[0];
}

- (void)ExactTests:(double)minSumA ETsumA:(double)sumA ETdegD:(int)degD ETExactTests:(double[])ExactTests BigPolyD:(BigDouble *__strong*)bigPolyD
{
    int diff = (int) (sumA - minSumA);
//    double upTail = polyD[degD];
    BigDouble *bigUpTail = [[BigDouble alloc] initWithLogDouble:[bigPolyD[degD] logValue]];
//    double twoTail = 0.0;
    BigDouble *bigTwoTail = [[BigDouble alloc] initWithDouble:0.0];
    if ([bigUpTail logValue] <= log10(1.000001) + [bigPolyD[diff] logValue])
        [bigTwoTail plusLog:[bigUpTail logValue]];
//    if (upTail <= 1.000001 * polyD[diff])
//        twoTail = twoTail + upTail;
    for (int i = degD - 1; i >= diff; i--)
    {
//        upTail = upTail + polyD[i];
        [bigUpTail plusLog:[bigPolyD[i] logValue]];
//        if (polyD[i] <= 1.000001 * polyD[diff])
//            twoTail = twoTail + polyD[i];
        if ([bigPolyD[i] logValue] <= log10(1.000001) + [bigPolyD[diff] logValue])
            [bigTwoTail plusLog:[bigPolyD[i] logValue]];
    }
//    double denom = upTail;
    BigDouble *bigDenom = [[BigDouble alloc] initWithLogDouble:[bigUpTail logValue]];
    for (int i = diff - 1; i >= 0; i--)
    {
//        denom = denom + polyD[i];
        [bigDenom plusLog:[bigPolyD[i] logValue]];
//        if (polyD[i] <= 1.000001 * polyD[diff])
//            twoTail = twoTail + polyD[i];
        if ([bigPolyD[i] logValue] <= log10(1.000001) + [bigPolyD[diff] logValue])
            [bigTwoTail plusLog:[bigPolyD[i] logValue]];
    }
//    ExactTests[0] = 1.0 - (upTail - polyD[diff]) / denom;
    ExactTests[0] = 1.0 - (pow(10.0, [bigUpTail logValue] - [bigDenom logValue]) - pow(10.0, [bigPolyD[diff] logValue] - [bigDenom logValue]));
//    ExactTests[1] = upTail / denom;
    ExactTests[1] = pow(10.0, [bigUpTail logValue] - [bigDenom logValue]);
//    ExactTests[2] = twoTail / denom;
    ExactTests[2] = pow(10.0, [bigTwoTail logValue] - [bigDenom logValue]);
//    ExactTests[3] = 1.0 - (upTail - 0.5 * polyD[diff]) / denom;
    ExactTests[3] = 1.0 - (pow(10.0, [bigUpTail logValue] - [bigDenom logValue]) - pow(10.0, (log10(0.5) + [bigPolyD[diff] logValue]) - [bigDenom logValue]));
//    ExactTests[4] = (upTail - 0.5 * polyD[diff]) / denom;
    ExactTests[4] = pow(10.0, [bigUpTail logValue] - [bigDenom logValue]) - pow(10.0, (log10(0.5) + [bigPolyD[diff] logValue]) - [bigDenom logValue]);
}

//- (void)ExactTests:(double)minSumA ETsumA:(double)sumA ETpolyD:(double[])polyD ETdegD:(int)degD ETExactTests:(double[])ExactTests
//{
//    int diff = (int) (sumA - minSumA);
//    double upTail = polyD[degD];
//    double twoTail = 0.0;
//    if (upTail <= 1.000001 * polyD[diff])
//        twoTail = twoTail + upTail;
//    for (int i = degD - 1; i >= diff; i--)
//    {
//        upTail = upTail + polyD[i];
//        if (polyD[i] <= 1.000001 * polyD[diff])
//            twoTail = twoTail + polyD[i];
//    }
//    double denom = upTail;
//    for (int i = diff - 1; i >= 0; i--)
//    {
//        denom = denom + polyD[i];
//        if (polyD[i] <= 1.000001 * polyD[diff])
//            
//            twoTail = twoTail + polyD[i];
//    }
//    ExactTests[0] = 1.0 - (upTail - polyD[diff]) / denom;
//    ExactTests[1] = upTail / denom;
//    ExactTests[2] = twoTail / denom;
//    ExactTests[3] = 1.0 - (upTail - 0.5 * polyD[diff]) / denom;
//    ExactTests[4] = (upTail - 0.5 * polyD[diff]) / denom;
//}

- (double)CalcCmle:(double)approx CCminSumA:(double)minSumA CCsumA:(double)sumA CCmaxSumA:(double)maxSumA CCdegN:(int)degN BigPolyD:(BigDouble *__strong*)bigPolyD
{
    double cmle = 0.0;
    if (minSumA < sumA && sumA < maxSumA)
        cmle = [self GetCmle:approx GCminSumA:minSumA GCsumA:sumA GCdegN:degN BigPolyD:bigPolyD];
    else if (sumA == maxSumA)
        cmle = INFINITY;
    
    return cmle;
}

- (double)GetCmle:(double)approx GCminSumA:(double)minSumA GCsumA:(double)sumA GCdegN:(int)degN BigPolyD:(BigDouble *__strong*)bigPolyD
{
//    double polyN[degN];
    BigDouble *bigPolyN[degN];
    for (int i = 0; i < degN; i++)
    {
//        polyN[i] = (minSumA + i) * polyD[i];
        bigPolyN[i] = [[BigDouble alloc] initWithLogDouble:[bigPolyD[i] timesReturn:(minSumA + i)]];
    }
    
    return [self Converge:approx CsumA:sumA Cvalue:sumA CdegN:degN BigPolyD:bigPolyD BigPolyN:bigPolyN];
}

- (double)Converge:(double)approx CsumA:(double)sumA Cvalue:(double)value CdegN:(int)degN BigPolyD:(BigDouble *__strong*)bigPolyD BigPolyN:(BigDouble *__strong*)bigPolyN
{
    double coordinates[4];
    [self BracketRoot:approx BRx0:0.0 BRx1:0.0 BRf0:0.0 BRf1:0.0 BRsumA:sumA BRvalue:value BRdegN:degN Bcoordinates:coordinates BigPolyD:bigPolyD BigPolyN:bigPolyN];
    double cmle = [self Zero:coordinates[0] Zx1:coordinates[1] Zf0:coordinates[2] Zf1:coordinates[3] ZsumA:sumA Zvalue:value ZdegN:degN ZdegD:degN BigPolyD:bigPolyD BigPolyN:bigPolyN];
    return cmle;
}

- (double)Converge:(double)approx CsumA:(double)sumA Cvalue:(double)value CdegN:(int)degN DegDVariable:(int)degD BigPolyD:(BigDouble *__strong*)bigPolyD BigPolyN:(BigDouble *__strong*)bigPolyN
{
    double coordinates[4];
    [self BracketRoot:approx BRx0:0.0 BRx1:0.0 BRf0:0.0 BRf1:0.0 BRsumA:sumA BRvalue:value BRdegN:degN Bcoordinates:coordinates DegDVariable:degD BigPolyD:bigPolyD BigPolyN:bigPolyN];
    double cmle = [self Zero:coordinates[0] Zx1:coordinates[1] Zf0:coordinates[2] Zf1:coordinates[3] ZsumA:sumA Zvalue:value ZdegN:(degN + 1) ZdegD:degD BigPolyD:bigPolyD BigPolyN:bigPolyN];
    return cmle;
}

//- (double)Converge:(double)approx CpolyN:(double[])polyN CpolyD:(double[])polyD CsumA:(double)sumA Cvalue:(double)value CdegN:(int)degN DegDVariable:(int)degD
//{
//    double coordinates[4];
//    [self BracketRoot:approx BRx0:0.0 BRx1:0.0 BRf0:0.0 BRf1:0.0 BRpolyN:polyN BRpolyD:polyD BRsumA:sumA BRvalue:value BRdegN:degN Bcoordinates:coordinates DegDVariable:degD];
//    double cmle = [self Zero:coordinates[0] Zx1:coordinates[1] Zf0:coordinates[2] Zf1:coordinates[3] ZpolyN:polyN ZpolyD:polyD ZsumA:sumA Zvalue:value ZdegN:(degN + 1) ZdegD:degD];
//    return cmle;
//}

- (void)BracketRoot:(double)approx BRx0:(double)x0 BRx1:(double)x1 BRf0:(double)f0 BRf1:(double)f1 BRsumA:(double)sumA BRvalue:(double)value BRdegN:(int)degN Bcoordinates:(double[])coordinates BigPolyD:(BigDouble *__strong*)bigPolyD BigPolyN:(BigDouble *__strong*)bigPolyN
{
    int iter = 0;
    x1 = 0.5;
    if (approx > x1)
        x1 = approx;
    f0 = [self Func:x0 FsumA:sumA Fvalue:value FdegN:degN FdegD:degN BigPolyD:bigPolyD BigPolyN:bigPolyN];
    f1 = [self Func:x1 FsumA:sumA Fvalue:value FdegN:degN FdegD:degN BigPolyD:bigPolyD BigPolyN:bigPolyN];
    while (f1 * f0 > 0.0 && iter < 10000)
    {
        iter = iter + 1;
        x0 = x1;
        f0 = f1;
        x1 = x1 * 1.5 * iter;
        f1 = [self Func:x1 FsumA:sumA Fvalue:value FdegN:degN FdegD:degN BigPolyD:bigPolyD BigPolyN:bigPolyN];
    }
    coordinates[0] = x0;
    coordinates[1] = x1;
    coordinates[2] = f0;
    coordinates[3] = f1;
}

- (void)BracketRoot:(double)approx BRx0:(double)x0 BRx1:(double)x1 BRf0:(double)f0 BRf1:(double)f1 BRsumA:(double)sumA BRvalue:(double)value BRdegN:(int)degN Bcoordinates:(double[])coordinates DegDVariable:(int)degD BigPolyD:(BigDouble *__strong*)bigPolyD BigPolyN:(BigDouble *__strong*)bigPolyN
{
    int iter = 0;
    x1 = 0.5;
    if (approx > x1)
        x1 = approx;
    f0 = [self Func:x0 FsumA:sumA Fvalue:value FdegN:(degN + 1) FdegD:degD BigPolyD:bigPolyD BigPolyN:bigPolyN];
    f1 = [self Func:x1 FsumA:sumA Fvalue:value FdegN:(degN + 1) FdegD:degD BigPolyD:bigPolyD BigPolyN:bigPolyN];
    while (f1 * f0 > 0.0 && iter < 10000)
    {
        iter = iter + 1;
        x0 = x1;
        f0 = f1;
        x1 = x1 * 1.5 * iter;
        f1 = [self Func:x1 FsumA:sumA Fvalue:value FdegN:(degN + 1) FdegD:degD BigPolyD:bigPolyD BigPolyN:bigPolyN];
    }
    coordinates[0] = x0;
    coordinates[1] = x1;
    coordinates[2] = f0;
    coordinates[3] = f1;
}

//- (void)BracketRoot:(double)approx BRx0:(double)x0 BRx1:(double)x1 BRf0:(double)f0 BRf1:(double)f1 BRpolyN:(double[])polyN BRpolyD:(double[])polyD BRsumA:(double)sumA BRvalue:(double)value BRdegN:(int)degN Bcoordinates:(double[])coordinates DegDVariable:(int)degD
//{
//    int iter = 0;
//    x1 = 0.5;
//    if (approx > x1)
//        x1 = approx;
//    f0 = [self Func:x0 FpolyN:polyN FpolyD:polyD FsumA:sumA Fvalue:value FdegN:(degN + 1) FdegD:degD];
//    f1 = [self Func:x1 FpolyN:polyN FpolyD:polyD FsumA:sumA Fvalue:value FdegN:(degN + 1) FdegD:degD];
//    while (f1 * f0 > 0.0 && iter < 10000)
//    {
//        iter = iter + 1;
//        x0 = x1;
//        f0 = f1;
//        x1 = x1 * 1.5 * iter;
//        f1 = [self Func:x1 FpolyN:polyN FpolyD:polyD FsumA:sumA Fvalue:value FdegN:(degN + 1) FdegD:degD];
//    }
//    coordinates[0] = x0;
//    coordinates[1] = x1;
//    coordinates[2] = f0;
//    coordinates[3] = f1;
//}

//- (double)BracketRoot0:(double)approx BRx0:(double)x0 BRx1:(double)x1 BRf0:(double)f0 BRf1:(double)f1 BRpolyN:(double[])polyN BRpolyD:(double[])polyD BRsumA:(double)sumA BRvalue:(double)value BRdegN:(int)degN Biter:(int)i
//{
//    int iter = 0;
//    x1 = 0.5;
//    if (approx > x1)
//        x1 = approx;
//    f0 = [self Func:x0 FpolyN:polyN FpolyD:polyD FsumA:sumA Fvalue:value FdegN:degN FdegD:degN];
//    f1 = [self Func:x1 FpolyN:polyN FpolyD:polyD FsumA:sumA Fvalue:value FdegN:degN FdegD:degN];
//    while (f1 * f0 > 0.0 && iter < 10000)
//    {
//        iter = iter + 1;
//        x0 = x1;
//        f0 = f1;
//        x1 = x1 * 1.5 * iter;
//        f1 = [self Func:x1 FpolyN:polyN FpolyD:polyD FsumA:sumA Fvalue:value FdegN:degN FdegD:degN];
//    }
//    double coordinates[4];
//    coordinates[0] = x0;
//    coordinates[1] = x1;
//    coordinates[2] = f0;
//    coordinates[3] = f1;
//    return coordinates[i];
//}

- (double)EvalPoly:(int)degC EPr:(double)r BigC:(BigDouble *__strong*)bigC
{
    double y = 0.0;
    BigDouble *bigY = [[BigDouble alloc] initWithDouble:0.0];
    if (r == 0.0)
    {
//        y = c[0];
        [bigY setLogValue:bigC[0].logValue];
    }
    else if (r <= 1.0)
    {
//        y = c[degC];
        [bigY setLogValue:bigC[degC].logValue];
        if (r < 1.0)
        {
            for (int i = degC - 1; i >= 0; i--)
            {
//                y = y * r + c[i];
                [bigY times:r];
                [bigY plusLog:[bigC[i] logValue]];
            }
        }
        else
            for (int i = degC - 1; i >= 0; i--)
            {
//                y = y + c[i];
                [bigY plusLog:[bigC[i] logValue]];
            }
    }
    else if (r > 1.0)
    {
//        y = c[0];
        [bigY setLogValue:bigC[0].logValue];
        r = 1.0 / r;
        for (int i = 1; i <= degC; i++)
        {
//            y = y * r + c[i];
            [bigY times:r];
            [bigY plusLog:[bigC[i] logValue]];
        }
    }
    
    return  bigY.logValue;
    return y;
}

//- (double)EvalPoly:(double[]) c EPdegC:(int) degC EPr:(double)r
//{
//    double y = 0.0;
//    if (r == 0.0)
//        y = c[0];
//    else if (r <= 1.0)
//    {
//        y = c[degC];
//        if (r < 1.0)
//        {
//            for (int i = degC - 1; i >= 0; i--)
//                y = y * r + c[i];
//        }
//        else
//            for (int i = degC - 1; i >= 0; i--)
//                y = y + c[i];
//    }
//    else if (r > 1.0)
//    {
//        y = c[0];
//        r = 1.0 / r;
//        for (int i = 1; i <= degC; i++)
//            y = y * r + c[i];
//    }
//    
//    return y;
//}

- (double)Func:(double)r FsumA:(double)sumA Fvalue:(double)value FdegN:(int)degN FdegD:(int)degD BigPolyD:(BigDouble *__strong*)bigPolyD BigPolyN:(BigDouble *__strong*)bigPolyN
{
    double func = 0.0;
    double logNumOverDenom = 0.0;
//    double numer = [self EvalPoly:polyN EPdegC:degN - 1 EPr:r];
//    double denom = [self EvalPoly:polyD EPdegC:degD - 1 EPr:r];
    double logNumer = [self EvalPoly:degN - 1 EPr:r BigC:bigPolyN];
    double logDenom = [self EvalPoly:degD - 1 EPr:r BigC:bigPolyD];
    if (r <= 1.0)
    {
//        func = numer / denom - value;
        logNumOverDenom = logNumer - logDenom;
        func = pow(10,logNumOverDenom) - value;
    }
    else
    {
//        func = (numer / pow(r, (double)((degD - 1) - (degN - 1)))) / denom - value;
        logNumOverDenom = (logNumer - log10(pow(r, (double)((degD - 1) - (degN - 1))))) - logDenom;
        func = pow(10,logNumOverDenom) - value;
    }
    
    return func;
}

//- (double)Func:(double)r FpolyN:(double[])polyN FpolyD:(double[])polyD FsumA:(double)sumA Fvalue:(double)value FdegN:(int)degN FdegD:(int)degD
//{
//    double func = 0.0;
//    double numer = [self EvalPoly:polyN EPdegC:degN - 1 EPr:r];
//    double denom = [self EvalPoly:polyD EPdegC:degD - 1 EPr:r];
//    if (r <= 1.0)
//        func = numer / denom - value;
//    else
//        func = (numer / pow(r, (double)((degD - 1) - (degN - 1)))) / denom - value;
//    
//    return func;
//}

- (double)Zero:(double)x0 Zx1:(double)x1 Zf0:(double)f0 Zf1:(double)f1 ZsumA:(double)sumA Zvalue:(double)value ZdegN:(int)degN ZdegD:(int)degD BigPolyD:(BigDouble *__strong*)bigPolyD BigPolyN:(BigDouble *__strong*)bigPolyN
{
    Boolean found = false;
    double f2 = 0.0;
    double x2 = 0.0;
    double swap = 0.0;
    int iter = 0;
    int errorRenamed = 0;
    double absf0 = f0;
    double absf1 = f1;
    if (f0 < 1)
        absf0 = -f0;
    if (f1 < 0)
        absf1 = -f1;
    
    if (absf0 < absf1)
    {
        swap = x0; x0 = x1; x1 = swap;
        swap = f0; f0 = f1; f1 = swap;
    }
    found = (f1 == 0.0);
    if (!found && f0 * f1 > 0.0)
        errorRenamed = 1;
    
    while (!found && iter < 10000 &&errorRenamed == 0)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        iter++;
        x2 = x1 - f1 * (x1 - x0) / (f1 - f0);
        f2 = [self Func:x2 FsumA:sumA Fvalue:value FdegN:degN FdegD:degD BigPolyD:bigPolyD BigPolyN:bigPolyN];
        if (f1 * f2 < 0.0)
        {
            x0 = x1;
            f0 = f1;
        }
        else
            f0 = f0 * f1 / (f1 + f2);
        x1 = x2;
        f1 = f2;
        found = (fabs(x1 / 0.0000001 - x0 / 0.0000001) * 0.0000001 < fabs(x1 / 0.0000001) * 0.0000001 * 0.0000001 || f1 == 0.0);
    }
    double cmle = x1;
    if (!found && iter > 10000)
        cmle = NAN;
    
    return cmle;
}
//- (double)Zero:(double)x0 Zx1:(double)x1 Zf0:(double)f0 Zf1:(double)f1 ZpolyN:(double[])polyN ZpolyD:(double[])polyD ZsumA:(double)sumA Zvalue:(double)value ZdegN:(int)degN ZdegD:(int)degD
//{
//    Boolean found = false;
//    double f2 = 0.0;
//    double x2 = 0.0;
//    double swap = 0.0;
//    int iter = 0;
//    int errorRenamed = 0;
//    double absf0 = f0;
//    double absf1 = f1;
//    if (f0 < 1)
//        absf0 = -f0;
//    if (f1 < 0)
//        absf1 = -f1;
//    
//    if (absf0 < absf1)
//    {
//        swap = x0; x0 = x1; x1 = swap;
//        swap = f0; f0 = f1; f1 = swap;
//    }
//    found = (f1 == 0.0);
//    if (!found && f0 * f1 > 0.0)
//        errorRenamed = 1;
//    
//    while (!found && iter < 10000 &&errorRenamed == 0)
//    {
//        iter++;
//        x2 = x1 - f1 * (x1 - x0) / (f1 - f0);
//        f2 = [self Func:x2 FpolyN:polyN FpolyD:polyD FsumA:sumA Fvalue:value FdegN:degN FdegD:degD];
//        if (f1 * f2 < 0.0)
//        {
//            x0 = x1;
//            f0 = f1;
//        }
//        else
//            f0 = f0 * f1 / (f1 + f2);
//        x1 = x2;
//        f1 = f2;
//        found = (abs(x1 / 0.0000001 - x0 / 0.0000001) * 0.0000001 < abs(x1 / 0.0000001) * 0.0000001 * 0.0000001 || f1 == 0.0);
//    }
//    double cmle = x1;
//    if (!found && iter > 10000)
//        cmle = NAN;
//    
//    return cmle;
//}

- (void)RRStats:(int)a RRSb:(int)b RRSc:(int)c RRSd:(int)d RRSstats:(double[])RRstats
{
    double n1 = a + b;
    double n0 = c + d;
    double m1 = a + c;
    double m0 = b + d;
    double n = m1 + m0;
    double re = a / n1;
    double ru = c / n0;
    if (ru < 0.00001)
    {
        RRstats[0] = -1.0;
        RRstats[1] = -1.0;
        RRstats[2] = -1.0;
    }
    else
    {
        RRstats[0] = re / ru;
        if (re < 0.00001)
        {
            RRstats[1] = -1.0;
            RRstats[2] = -1.0;
        }
        else
        {
            RRstats[1] = exp(log((a / n1) / (c / n0)) - 1.96 * sqrt(d / (c * n0) + b / (n1 * a)));
            RRstats[2] = exp(log((a / n1) / (c / n0)) + 1.96 * sqrt(d / (c * n0) + b / (n1 * a)));
        }
    }
    RRstats[3] = (re - ru) * 100;
    RRstats[4] = (re - ru - 1.96 * sqrt(re * (1 - re) / n1 + ru * (1 - ru) / n0)) * 100;
    RRstats[5] = (re - ru + 1.96 * sqrt(re * (1 - re) / n1 + ru * (1 - ru) / n0)) * 100;
    double h3 = m1 * m0 * n1 * n0;
    double phi = (a * d - b * c) / sqrt(h3);
    RRstats[6] = n * pow(phi, 2.0);
    RRstats[7] = [SharedResources PValFromChiSq:RRstats[6] PVFCSdf:1.0];
    RRstats[8] = (n - 1) / h3 * pow(a * d - b * c, 2.0);
    RRstats[9] = [SharedResources PValFromChiSq:RRstats[8] PVFCSdf:1.0];
    RRstats[10] = n / h3 * pow(MAX(0.0, (double) abs((int) (a * d - b * c)) - n * 0.5), 2.0);
    RRstats[11] = [SharedResources PValFromChiSq:RRstats[10] PVFCSdf:1.0];
}

-(double)GetExactLim:(BOOL)pbLower IsItFisher:(BOOL)pbFisher ApproxVariable:(double)approx MinSumAVariable:(double)minSumA SumAVariable:(double)sumA DegDVariable:(int)degD BigPolyD:(BigDouble *__strong*)bigPolyD
{
    int degN = (int)sumA - (int)minSumA;
    double pnConfLevel = 0.95;
    double value = 0.5 * (1.0 - pnConfLevel);
    if (pbLower)
        value = 0.5 * (1 + pnConfLevel);
    if (pbLower && pbFisher)
        degN = (int)sumA - (int)minSumA - 1;
//    double polyN[degN + 1];
//    double polyNI = 0.0;
    BigDouble *bigPolyN[degN + 1];
    BigDouble *bigPolyNI = [[BigDouble alloc] initWithDouble:0.0];
    for (int i = 0; i <= degN; i++)
    {
//        polyN[i] = polyD[i];
//        polyNI = polyN[i];
        bigPolyN[i] = [[BigDouble alloc] initWithLogDouble:[bigPolyD[i] logValue]];
        [bigPolyNI setLogValue:[bigPolyN[i] logValue]];
    }
    if (!pbFisher)
    {
//        polyN[degN] = 0.5 * polyD[degN];
        [bigPolyN[degN] setLogValue:(log10(0.5) + [bigPolyD[degN] logValue])];
    }
    double limit = [self Converge:approx CsumA:sumA Cvalue:value CdegN:degN DegDVariable:degD BigPolyD:bigPolyD BigPolyN:bigPolyN];
    
    return limit;
}

//-(double)GetExactLim:(BOOL)pbLower IsItFisher:(BOOL)pbFisher ApproxVariable:(double)approx MinSumAVariable:(double)minSumA SumAVariable:(double)sumA PolyDVector:(double[])polyD DegDVariable:(int)degD
//{
//    int degN = (int)sumA - (int)minSumA;
//    double pnConfLevel = 0.95;
//    double value = 0.5 * (1.0 - pnConfLevel);
//    if (pbLower)
//        value = 0.5 * (1 + pnConfLevel);
//    if (pbLower && pbFisher)
//        degN = (int)sumA - (int)minSumA - 1;
//    double polyN[degN + 1];
//    double polyNI = 0.0;
//    for (int i = 0; i <= degN; i++)
//    {
//        polyN[i] = polyD[i];
//        polyNI = polyN[i];
//    }
//    if (!pbFisher)
//        polyN[degN] = 0.5 * polyD[degN];
//    double limit = [self Converge:approx CpolyN:polyN CpolyD:polyD CsumA:sumA Cvalue:value CdegN:degN DegDVariable:degD];
//    
//    return limit;
//}

-(double)CalcExactLim:(BOOL)pbLower IsItFisher:(BOOL)pbFisher ApproxVariable:(double)approx MinSumAVariable:(double)minSumA SumAVariable:(double)sumA MaxSumAVariable:(double)maxSumA DegDVariable:(int)degD BigPolyD:(BigDouble *__strong*)bigPolyD
{
    double limit = 0.0;
    if (minSumA < sumA && sumA < maxSumA)
        limit = [self GetExactLim:pbLower IsItFisher:pbFisher ApproxVariable:approx MinSumAVariable:minSumA SumAVariable:sumA DegDVariable:degD BigPolyD:bigPolyD];
    else if (sumA == minSumA)
    {
        if (!pbLower)
            limit = [self GetExactLim:pbLower IsItFisher:pbFisher ApproxVariable:approx MinSumAVariable:minSumA SumAVariable:sumA DegDVariable:degD BigPolyD:bigPolyD];
    }
    else if (sumA == maxSumA)
    {
        if (pbLower)
            limit = [self GetExactLim:pbLower IsItFisher:pbFisher ApproxVariable:approx MinSumAVariable:minSumA SumAVariable:sumA DegDVariable:degD BigPolyD:bigPolyD];
        else limit = INFINITY;
    }
    
    return limit;
}

//-(double)CalcExactLim:(BOOL)pbLower IsItFisher:(BOOL)pbFisher ApproxVariable:(double)approx MinSumAVariable:(double)minSumA SumAVariable:(double)sumA MaxSumAVariable:(double)maxSumA PolyDVector:(double[])polyD DegDVariable:(int)degD
//{
//    double limit = 0.0;
//    if (minSumA < sumA && sumA < maxSumA)
//        limit = [self GetExactLim:pbLower IsItFisher:pbFisher ApproxVariable:approx MinSumAVariable:minSumA SumAVariable:sumA PolyDVector:polyD DegDVariable:degD];
//    else if (sumA == minSumA)
//    {
//        if (!pbLower)
//            limit = [self GetExactLim:pbLower IsItFisher:pbFisher ApproxVariable:approx MinSumAVariable:minSumA SumAVariable:sumA PolyDVector:polyD DegDVariable:degD];
//    }
//    else if (sumA == maxSumA)
//    {
//        if (pbLower)
//            limit = [self GetExactLim:pbLower IsItFisher:pbFisher ApproxVariable:approx MinSumAVariable:minSumA SumAVariable:sumA PolyDVector:polyD DegDVariable:degD];
//        else limit = INFINITY;
//    }
//    
//    return limit;
//}

@end
