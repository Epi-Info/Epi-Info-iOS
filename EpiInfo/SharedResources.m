//
//  SharedResources.m
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import "SharedResources.h"
#include <math.h>

@implementation SharedResources

+(double)choosey:(double)chooa chooseK:(double)choob
{
    double ccccc = chooa - choob;
    if (choob < chooa / 2)
        choob = ccccc;
    double choosey = 1.0;
    for (int i = (int)choob + 1; i <= (int)chooa; i++)
    {
        choosey = (choosey * (double)i) / (chooa - ((double)i - 1.0));
    }
    return choosey;
}

+(double)chooseyforlep:(double)chooa chooseK:(double)choob VariablePPP:(double)ppp
{
    double ccccc = chooa - choob;
    double chooseyforlep = 1.0;
    int oldchoob = (int)choob;
    if (choob < chooa / 2)
        choob = ccccc;
    for (int i = (int)choob + 1; i <= (int)chooa; i++)
        chooseyforlep = (chooseyforlep * (double)i) / (chooa - ((double)i - 1.0)) * ppp;
    chooseyforlep = chooseyforlep * pow((1.0 - ppp), (chooa - oldchoob));
    if (oldchoob == choob)
        chooseyforlep = chooseyforlep * pow(ppp, (choob - (chooa - choob)));
    return chooseyforlep;
}

+(double)zFromP:(double)_p
{
    double ZFP = NAN;
    
    const double P0 = -0.322232431088;
    const double P2 = -0.342242088547;
    const double P3 = -0.0204231210245;
    const double P4 = -4.53642210148E-05;
    const double Q0 = 0.099348462606;
    const double Q1 = 0.588581570495;
    const double Q2 = 0.531103462366;
    const double Q3 = 0.10353775285;
    const double Q4 = 0.0038560700634;
    
    double F, T;
    
    F = _p;
    ZFP = 0.0;
    
    if (F >= 1)
        return ZFP;
    
    if (F > 0.5)
    {
        F = 1.0 - F;
    }
    if (F == 0.5)
        return ZFP;
    
    T = sqrt(log(1 / pow(F, 2.0)));
    T = T + ((((T * P4 + P3) * T + P2) * T - 1) * T + P0) / ((((T * Q4 + Q3) * T+ Q2) * T + Q1) * T + Q0);
    
    if (_p > 0.5)
        ZFP = -T;
    else
        ZFP = T;
    
    return ZFP;
}

+(double)pFromZ:(double)_z
{
    double PFZ = NAN;
    int UTZERO = 12;
    double CON = 1.28;
    
    double _x = ABS(_z);
    if (_x > UTZERO)
    {
        if (_z < 0)
            PFZ = 1.0;
        else
            PFZ = 0.0;
        return PFZ;
    }
    double _y = pow(_z, 2.0) / 2.0;
    if (_x > CON)
    {
        PFZ = _x - 0.151679116635 + 5.29330324926 / (_x + 4.8385912808 - 15.1508972451 / (_x + 0.742380924027 + 30.789933034 / (_x + 3.99019417011)));
        PFZ = _x + 0.000398064794 + 1.986158381364 / PFZ;
        PFZ = _x - 0.000000038052 + 1.00000615302 / PFZ;
        PFZ = 0.398942280385 * exp(-_y) / PFZ;
    }
    else
    {
        PFZ = _y / (_y + 5.75885480458 - 29.8213557808 / (_y + 2.624331121679 + 48.6959930692 / (_y + 5.92885724438)));
        PFZ = 0.398942280444 - 0.399903438504 * PFZ;
        PFZ = 0.5 - _x * PFZ;
    }
    if (_z < 0)
        PFZ = 1 - PFZ;
    return PFZ;
}

+(double)pFromT:(double)_t DegreesOfFreedom:(int)_df
{
    double PFT = NAN;
    double g1 = 0.3183098862;
    int MaxInt = 1000;
    int ddf = 0;
    int F = 0;
    int i = 0;
    double _a = NAN;
    double _b = NAN;
    double _c = NAN;
    double _s = NAN;
    double _p = NAN;
    
    _t = ABS(_t);
    if (_df < MaxInt)
    {
        ddf = _df;
        _a = _t / sqrt((double)ddf);
        _b = ddf / (ddf + pow(_t, 2.0));
        i = ddf % 2;
        _s = 1;
        _c = 1;
        F = 2 + i;
        while (F <= ddf - 2)
        {
            _c = _c * _b * (F - 1) / F;
            _s = _s + _c;
            F = F + 2;
        }
        if (i <= 0)
            _p = 0.5 - _a * sqrt(_b) * _s / 2;
        else
            _p = 0.5 - (_a * _b * _s + atan(_a)) * g1;
        if (_p < 0)
            _p = 0;
        if (_p > 1)
            _p = 1;
        PFT = _p;
    }
    else
        PFT = [SharedResources pFromZ:(_t)];
    
    return PFT;
}

+(double)pFromF:(double)F DegreesOfFreedom1:(double)df1 DegreesOfFreedom2:(double)df2
{
    double PFF = 0.0;
    double ACU = 0.000000001;
    double xx = 0.0;
    double pp = 0.0;
    double qq = 0.0;
    BOOL index;
    
    if (F == 0.0)
        return 0.0;
    if (F < 0.0 || df1 < 1.0 || df2 < 1.0)
        return 0.0;
    if (df1 == 1)
    {
        PFF = [SharedResources pFromT:sqrt(F) DegreesOfFreedom:(int)df2] * 2;
        return PFF;
    }
    
    double x = df1 * F / (df2 + df1 * F);
    double P = df1 / 2;
    double q = df2 / 2;
    double psq = P + q;
    double cx = 1 - x;
    
    if (P >= x * psq)
    {
        xx = x;
        pp = P;
        qq = q;
        index = NO;
    }
    else
    {
        xx = cx;
        cx = x;
        pp = q;
        qq = P;
        index = YES;
    }
    
    double term = 1.0;
    double ai = 1.0;
    double b = 1.0;
    double ns = pp + cx * psq;
    double rx = xx / cx;
    double term1 = 1.0;
    double temp = 0.0;
three:
    temp = qq - ai;
    
    if (ns == 0.0)
        rx = xx;
    
four:
    term = term / (pp + ai) * temp * rx;
    
    if (ABS(term) <= term1)
    {
        b = b + term;
        temp = ABS(term);
        term1 = temp;
        if (temp > ACU || temp > ACU * b)
        {
            ai += 1.0;
            ns -= 1.0;
            if (ns >= 0.0)
                goto three;
            temp = psq;
            psq += 1.0;
            goto four;
        }
    }
    
    double beta = [SharedResources algama:P] + [self algama:q] - [SharedResources algama:P + q];
    temp = (pp * log(xx) + (qq - 1.0) * log(cx) - beta) - log(pp);
    
    if (temp > -70)
        b *= exp(temp);
    else b = 0.0;
    
    if (index)
        b = 1 - b;
    
    PFF = 1 - b;
    return PFF;
}

+(double)algama:(double)s
{
    double ag = 0.0;
    double Z = 0.0;
    double F = 0.0;
    double x = s;
    
    if (x < 0)
        return ag;
    
    if (x < 7)
    {
        F = 1.0;
        Z = x - 1;
        while (Z < 7)
        {
            Z = Z + 1;
            if (Z < 7)
            {
                x = Z;
                F *= Z;
            }
        }
        x += 1;
        F = -log(F);
    }
    
    Z = 1 / pow(x, 2.0);
    
    ag = F + (x - 0.5) * log(x) - x + 0.918938533204673 + (((-1.0 / 1680.0 * Z + 1.0 / 1260.0) * Z - 1.0 / 360.0) * Z + 1.0 / 12.0) / x;
    return ag;
}

+(double)PValFromChiSq:(double)x PVFCSdf:(double)df
{
    double j = 0.0;
    double k = 0.0;
    double l = 0.0;
    double m = 0.0;
    double pi = M_PI;
    double absx = x;
    if (x < 0)
        absx = -x;
    
    if (x < 0.000000001 || df < 1.0)
        return 1.0;
    
    double rr = 1.0;
    int ii = (int) (df * 1);
    
    while (ii >= 2)
    {
        rr = rr * (double) (ii * 1.0);
        ii = ii - 2;
    }
    
    k = exp(floor((df + 1.0) * 0.5) * log(absx) - x * 0.5) / rr;
    
    if (k < 0.00001)
        return 0.0;
    
    if (floor(df * 0.5) == df * 0.5)
        j = 1.0;
    else j = sqrt(2.0 / x / pi);
    
    l = 1.0;
    m = 1.0;
    
    if (!isnan(x) && !isinf(x))
    {
        while (m >= 0.00000001)
        {
            df = df + 2.0;
            m = m * x / df;
            l = l + m;
        }
    }
    return round(10000 * (1 - j * k * l)) / 10000;
}

+(double)ANorm:(double)p
{
    double v = 0.5;
    double dv = 0.5;
    double z = 0;
    
    while (dv > 1e-6)
    {
        z = 1.0 / v - 1.0;
        dv = dv / 2.0;
        if ([self Norm:z] > p)
            v -= dv;
        else
            v += dv;
    }
    return z;
}

+(double)Norm:(double)z
{
    z = sqrt(z * z);
    double p = 1.0 + z * (0.04986735 + z * (0.02114101 + z * (0.00327763 + z * (0.0000380036 + z * (0.0000488906 + z * 0.000005383)))));
    p = p * p;
    p = p * p;
    p = p * p;
    return 1.0 / (p * p);
}

+(double)chooseyforbeta:(double)chooa chooseK:(double)choob P:(double)p J:(int)j
{
    double q = 1 - p;
    int pPow = j;
    int qPow = chooa - j;
    double ccccc = chooa - choob;
    if (choob < chooa / 2)
        choob = ccccc;
    double choosey = 1.0;
    double oldchoosey = choosey;
    int positive200s = 0;
    int negative200s = 0;
    for (int i = (int)choob + 1; i <= (int)chooa; i++)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        oldchoosey = choosey;
        if (choosey < pow(10, -200))
        {
            choosey *= pow(10, 200);
            positive200s++;
        }
        if (choosey > pow(10, 200))
        {
            choosey *= pow(10, -200);
            negative200s++;
        }
        if (pPow > 0)
        {
            choosey *= p;
            pPow--;
        }
        if (qPow > 0)
        {
            choosey *= q;
            qPow--;
        }
        choosey = (choosey * (double)i) / (chooa - ((double)i - 1.0));
    }
    for (int i = 0; i < pPow; i++)
    {
        oldchoosey = choosey;
        choosey *= p;
    }
    for (int i = 0; i < qPow; i++)
    {
        oldchoosey = choosey;
        choosey *= q;
    }
    if (positive200s > negative200s)
    {
        positive200s -= negative200s;
        for (int i = 0; i < positive200s; i++)
        {
            oldchoosey = choosey;
            choosey *= pow(10, -200);
        }
    }
    else if (positive200s < negative200s)
    {
        negative200s -= positive200s;
        for (int i = 0; i < negative200s; i++)
        {
            oldchoosey = choosey;
            choosey *= pow(10, 200);
        }
    }
    return choosey;
}

+(double)ribetafunction:(double)p VariableAlpha:(int)alpha VariableBeta:(int)beta UsesChoosey:(BOOL)yn
{
    double functionvalue = 0.0;
    double functionadd = 0.0;
    
    for (int j = alpha; j < alpha + beta; j++)
    {
        functionadd = [self chooseyforbeta:(alpha + beta - 1) chooseK:j P:p J:j];
        functionvalue += functionadd;
    }

    return functionvalue;
}

+(double)ribetafunction:(double)p VariableAlpha:(int)alpha VariableBeta:(int)beta
{
    double functionvalue = 0.0;
    double oldfunctionvalue = 0.0;
    double aa = 1.0e-300;
    double bb = 0.0;
    double cc = 1.0;
//    double times = 0.0;
    double aatimes = 0.0;
    double bbtimes = 0.0;
    double cctimes = 0.0;
    
    for (int i = 0; i <= alpha + beta - 2; i++)
    {
        aa *= (double)((alpha + beta - 1) - i);
        if (aa > 1.0e300)
        {
            aa *= 1.0e-100;
            bbtimes += 1.0;
            cctimes += 1.0;
        }
    }
//    double power = pow(10.0, times * -100);
//    times = 0.0;
    for (int j = alpha; j < alpha + beta; j++)
    {
        oldfunctionvalue = functionvalue;
        bb = 1.0e-150;
        cc = 1.0e-150;
        double aatimesj = aatimes;
        double bbtimesj = bbtimes;
        double cctimesj = cctimes;
        for (int i = 0; i < j; i++)
        {
            bb *= (double)(j - i);
            if (bb > 1.0e300)
            {
                bb *= 1.0e-50;
                bbtimesj -= 1.0;
            }
        }
        if (bbtimesj < 0.0)
        {
            aatimesj -= bbtimesj;
            cctimesj -= bbtimesj;
            bbtimesj = 0.0;
        }
//        double aapower = pow(10, times * -200);
//        cc *= pow(10, times * -100);
//        times = 0.0;
        for (int i = 0; i < alpha + beta - 1 - j; i++)
        {
            cc *= (double)((alpha + beta - 1 - j) - i);
            if (cc > 1.0e300)
            {
                cc *= 1.0e-50;
                cctimesj -= 1.0;
            }
        }
        if (cctimesj < 0.0)
        {
            aatimesj -= cctimesj;
            bbtimesj -= cctimesj;
            cctimesj = 0.0;
        }
//        double aapower = pow(10, aatimesj * -200);
//        double bbpower = pow(10, bbtimesj * -100);
//        double ccpower = pow(10, cctimesj * -100);
        double ntimes = aatimesj * -100;
        double dtimes = bbtimesj * -50 + cctimesj * -50;
        double multiple = pow(10, ntimes - dtimes);
//        aapower *= pow(10, times * -200);
//        bb *= pow(10, times * -100);
        functionvalue += multiple * (aa / (bb * cc)) * pow(p, (double)j) * pow((1.0 - p), (double)(alpha + beta - 1 - j));
        BOOL fvnan = isnan(functionvalue) && !isnan(oldfunctionvalue);
        if (fvnan)
            NSLog(@"%g, %g, %g, %g, %g, %g, %g, %g, %g", ntimes, dtimes, multiple, aa, bb, cc, pow(p, (double)j), pow((1.0 - p), (double)(alpha + beta - 1 - j)), oldfunctionvalue);
    }
    
    return functionvalue;
}

+ (double)TfromP:(double)pdblProportion AndDF:(short)pintDF
{
    if (pintDF <= 0)
        return NAN;
    
    const double TOLERANCE = 0.00000001;
    double ldblProp = 0.0;
    double ldblLeftX = 0.0;
    double ldblLeftT = 0.5;
    double ldblRightX = 1.0;
    double ldblRightT = 0.0;
    double ldblX = 0.0;
    double ldblT = 0.0;
    
    if (pdblProportion < 0 || pdblProportion > 1)
        return 0.0;
    if (pdblProportion < 0.5)
        ldblProp = pdblProportion;
    else
        ldblProp = 1.0 - pdblProportion;
    ldblProp = ldblProp / 2.0;
    
    ldblRightX = 10.0 * ldblRightX;
    ldblRightT = [self pFromT:ldblRightX DegreesOfFreedom:(int)pintDF];
    while (ldblRightT >= ldblProp)
    {
        ldblRightX = 10.0 * ldblRightX;
        ldblRightT = [self pFromT:ldblRightX DegreesOfFreedom:(int)pintDF];
    }
    
    ldblX = (ldblRightX + ldblLeftX) / 2.0;
    ldblT = [self pFromT:ldblX DegreesOfFreedom:(int)pintDF];
    if (ldblT < ldblProp)
    {
        ldblRightT = ldblT;
        ldblRightX = ldblX;
    }
    else
    {
        ldblLeftT = ldblT;
        ldblLeftX = ldblX;
    }
    double testValue = ldblT - ldblProp;
    if (testValue < 0.0)
        testValue = -1.0 * testValue;
    while (testValue >= TOLERANCE)
    {
        ldblX = (ldblRightX + ldblLeftX) / 2.0;
        ldblT = [self pFromT:ldblX DegreesOfFreedom:(int)pintDF];
        if (ldblT < ldblProp)
        {
            ldblRightT = ldblT;
            ldblRightX = ldblX;
        }
        else
        {
            ldblLeftT = ldblT;
            ldblLeftX = ldblX;
        }
        testValue = ldblT - ldblProp;
        if (testValue < 0.0)
            testValue = -1.0 * testValue;
    }

    return ldblX;
}

+ (NSArray *)sortArrayOfArrays:(NSArray *)inArray onIndex:(int)idx
{
    NSMutableArray *outArray = [[NSMutableArray alloc] init];
    [outArray addObject:[inArray objectAtIndex:0]];
    for (int i = 1; i < [inArray count]; i++)
    {
        BOOL continueI = NO;
        for (int j = 0; j < [outArray count]; j++)
        {
            if ([(NSNumber *)[(NSMutableArray *)[inArray objectAtIndex:i] objectAtIndex:idx] floatValue] >
                [(NSNumber *)[(NSMutableArray *)[outArray objectAtIndex:j] objectAtIndex:idx] floatValue])
            {
                [outArray insertObject:[inArray objectAtIndex:i] atIndex:j];
                continueI = YES;
                break;
            }
        }
        if (continueI)
            continue;
        [outArray addObject:[inArray objectAtIndex:i]];
    }
    return outArray;
}

@end
