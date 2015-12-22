//
//  Twox2SummaryData.m
//  EpiInfo
//
//  Created by John Copeland on 1/14/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "Twox2SummaryData.h"
#import "Twox2StrataData.h"
#import "Twox2Compute.h"
#import "SharedResources.h"

@implementation Twox2SummaryData
- (void)compute:(NSArray *)stData summaryResults:(double[])suData
{
    double a = 0;
    double b = 0;
    double c = 0;
    double d = 0;
    if (stData.count == 5)
        for (int i = 0; i < 5; i++)
        {
            if ([stData[i] hasStatistics])
            {
                a += [stData[i] yy];
                b += [stData[i] yn];
                c += [stData[i] ny];
                d += [stData[i] nn];
            }
        }
    else
        for (int i = 0; i < stData.count; i++)
        {
            if ([stData[i] hasStatistics])
            {
                a += [stData[i] yy];
                b += [stData[i] yn];
                c += [stData[i] ny];
                d += [stData[i] nn];
            }
        }
    suData[0] = a;
    suData[1] = b;
    suData[2] = c;
    suData[3] = d;
    
    Twox2Compute *crudeComputer = [[Twox2Compute alloc] init];
    
    suData[4] = [crudeComputer OddsRatioEstimate:(int)a cellb:(int)b cellc:(int)c celld:(int)d];
    suData[5] = [crudeComputer OddsRatioLower:(int)a cellb:(int)b cellc:(int)c celld:(int)d];
    suData[6] = [crudeComputer OddsRatioUpper:(int)a cellb:(int)b cellc:(int)c celld:(int)d];
    
//    double ExactResults[4];
//    [crudeComputer CalcPoly:a CPyn:b CPny:c CPnn:d CPExactResults:ExactResults];
    
//    suData[7] = ExactResults[0];
//    suData[8] = [crudeComputer FishOR:a cellb:b cellc:c celld:d alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:NO];
//    suData[9] = [crudeComputer FishOR:a cellb:b cellc:c celld:d alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:NO];
//    suData[10] = [crudeComputer FishOR:a cellb:b cellc:c celld:d alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:YES];
//    suData[11] = [crudeComputer FishOR:a cellb:b cellc:c celld:d alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:YES];

    double RRstats[12];
    [crudeComputer RRStats:(int)a RRSb:(int)b RRSc:(int)c RRSd:(int)d RRSstats:RRstats];
    
    suData[18] = RRstats[0];
    suData[19] = RRstats[1];
    suData[20] = RRstats[2];
    
    int withStatistics = 0;
    for (int i = 0; i < [stData count]; i++)
        if ([stData[i] hasStatistics])
            withStatistics++;
    
    double aa[withStatistics];
    double bb[withStatistics];
    double cc[withStatistics];
    double dd[withStatistics];
    
    int j = 0;
    for (int i = 0; i < [stData count]; i++)
        if ([stData[i] hasStatistics])
        {
            aa[j] = (double)[stData[i] yy];
            bb[j] = (double)[stData[i] yn];
            cc[j] = (double)[stData[i] ny];
            dd[j++] = (double)[stData[i] nn];
        }
    
    suData[12] = [self computeOddsRatio:aa CellB:bb CellC:cc CellD:dd ArrayLengths:withStatistics];
    double zSELnOR = [self zSELnOR:aa CellB:bb CellC:cc CellD:dd ArrayLengths:withStatistics];
    suData[13] = suData[12] * exp(-zSELnOR);
    suData[14] = suData[12] * exp(zSELnOR);
    
    suData[15] = [self computeRiskRatio:aa CellB:bb CellC:cc CellD:dd ArrayLengths:withStatistics];
    zSELnOR = [self zSELnRR:aa CellB:bb CellC:cc CellD:dd ArrayLengths:withStatistics];
    suData[16] = suData[15] * exp(-zSELnOR);
    suData[17] = suData[15] * exp(zSELnOR);
    
    [self computeChiSq:aa CellB:bb CellC:cc CellD:dd ArrayLengths:withStatistics ReturnValues:suData];
    suData[22] = [SharedResources PValFromChiSq:suData[21] PVFCSdf:1.0];
    suData[24] = [SharedResources PValFromChiSq:suData[23] PVFCSdf:1.0];
    
    suData[25] = [self bdtOR:aa CellB:bb CellC:cc CellD:dd ArrayLengths:withStatistics MLEOddsRatio:suData[12]];
    suData[26] = [SharedResources PValFromChiSq:suData[25] PVFCSdf:(double)(withStatistics - 1)];
    
    suData[27] = [self bdOR:aa CellB:bb CellC:cc CellD:dd ArrayLengths:withStatistics];
    suData[28] = [SharedResources PValFromChiSq:suData[27] PVFCSdf:(double)(withStatistics - 1)];
    
    suData[29] = [self bdRR:aa CellB:bb CellC:cc CellD:dd ArrayLengths:withStatistics];
    suData[30] = [SharedResources PValFromChiSq:suData[29] PVFCSdf:(double)(withStatistics - 1)];
}

- (void)computeSlowStuff:(NSArray *)stData summaryResults:(double[])suData
{
    double a = 0;
    double b = 0;
    double c = 0;
    double d = 0;
    if (stData.count == 5)
        for (int i = 0; i < 5; i++)
        {
            if ([stData[i] hasStatistics])
            {
                a += [stData[i] yy];
                b += [stData[i] yn];
                c += [stData[i] ny];
                d += [stData[i] nn];
            }
        }
    else
        for (int i = 0; i < stData.count; i++)
        {
            if ([stData[i] hasStatistics])
            {
                a += [stData[i] yy];
                b += [stData[i] yn];
                c += [stData[i] ny];
                d += [stData[i] nn];
            }
        }
    
    Twox2Compute *crudeComputer = [[Twox2Compute alloc] init];
    
    double ExactResults[4];
    [crudeComputer CalcPoly:a CPyn:b CPny:c CPnn:d CPExactResults:ExactResults];
    
    suData[7] = ExactResults[0];
    suData[8] = [crudeComputer FishOR:a cellb:b cellc:c celld:d alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:NO];
    suData[9] = [crudeComputer FishOR:a cellb:b cellc:c celld:d alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:NO];
    suData[10] = [crudeComputer FishOR:a cellb:b cellc:c celld:d alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:YES];
    suData[11] = [crudeComputer FishOR:a cellb:b cellc:c celld:d alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:YES];
}

- (void)computeExactOR:(NSArray *)stData summaryResults:(double[])suData
{
    int withStatistics = 0;
    for (int i = 0; i < [stData count]; i++)
        if ([stData[i] hasStatistics])
            withStatistics++;
    
    double aa[withStatistics];
    double bb[withStatistics];
    double cc[withStatistics];
    double dd[withStatistics];
    
    int j = 0;
    for (int i = 0; i < [stData count]; i++)
        if ([stData[i] hasStatistics])
        {
            aa[j] = (double)[stData[i] yy];
            bb[j] = (double)[stData[i] yn];
            cc[j] = (double)[stData[i] ny];
            dd[j++] = (double)[stData[i] nn];
        }
    
    if (withStatistics > 1)
    {
        [self exactORLL:aa CellB:bb CellC:cc CellD:dd ArrayLengths:withStatistics ReturnValues:suData];
        [self mleOR:aa CellB:bb CellC:cc CellD:dd LowerLimit:suData[1] ArrayLengths:withStatistics ReturnValues:suData];
        [self exactORUL:aa CellB:bb CellC:cc CellD:dd Estimate:suData[0] ArrayLengths:withStatistics ReturnValues:suData];
    }
}

- (double)computeOddsRatio:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d ArrayLengths:(int)withStatistics
{
    double numerator = 0.0;
    double denominator = 0.0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        numerator = numerator + (a[i] * d[i]) / (a[i] + b[i] + c[i] + d[i]);
        denominator = denominator + (b[i] * c[i]) / (a[i] + b[i] + c[i] + d[i]);
    }
    
    return numerator / denominator;
}

- (double)zSELnOR:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d ArrayLengths:(int)withStatistics
{
    double p[5];
    p[0] = 0.0;p[1] = 0.0;p[2] = 0.0;p[3] = 0.0;p[4] = 0.0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        p[0] = p[0] + ((a[i] + d[i]) / (a[i] + b[i] + c[i] + d[i])) * (a[i] * d[i] / (a[i] + b[i] + c[i] + d[i]));
        p[1] = p[1] + ((a[i] + d[i]) / (a[i] + b[i] + c[i] + d[i])) * (b[i] * c[i] / (a[i] + b[i] + c[i] + d[i])) + ((b[i] + c[i]) / (a[i] + b[i] + c[i] + d[i])) * (a[i] * d[i] / (a[i] + b[i] + c[i] + d[i]));
        p[2] = p[2] + ((b[i] + c[i]) / (a[i] + b[i] + c[i] + d[i])) * (b[i] * c[i] / (a[i] + b[i] + c[i] + d[i]));
        p[3] = p[3] + (a[i] * d[i] / (a[i] + b[i] + c[i] + d[i]));
        p[4] = p[4] + (b[i] * c[i] / (a[i] + b[i] + c[i] + d[i]));
    }
    
    return 1.96 * sqrt(p[0] / (2 * p[3] * p[3]) + p[1] / (2 * p[3] * p[4]) + p[2] / (2 * p[4] * p[4]));
}

- (double)computeRiskRatio:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d ArrayLengths:(int)withStatistics
{
    double numerator = 0.0;
    double denominator = 0.0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        numerator = numerator + (a[i] * (c[i] + d[i])) / (a[i] + b[i] + c[i] + d[i]);
        denominator = denominator + ((a[i] + b[i]) * c[i]) / (a[i] + b[i] + c[i] + d[i]);
    }
    
    return numerator / denominator;
}

- (double)zSELnRR:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d ArrayLengths:(int)withStatistics
{
    double p[3];
    p[0] = 0.0;p[1] = 0.0;p[2] = 0.0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        p[0] = p[0] + ((a[i] + c[i]) * (a[i] + b[i]) * (c[i] + d[i]) - a[i] * c[i] * (a[i] + b[i] + c[i] + d[i])) / ((a[i] + b[i] + c[i] + d[i]) * (a[i] + b[i] + c[i] + d[i]));
        p[1] = p[1] + (a[i] * (c[i] + d[i])) / (a[i] + b[i] + c[i] + d[i]);
        p[2] = p[2] + (c[i] * (a[i] + b[i])) / (a[i] + b[i] + c[i] + d[i]);
    }
    
    return 1.96 * sqrt(p[0] / (p[1] * p[2]));
}

- (void)computeChiSq:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d ArrayLengths:(int)withStatistics ReturnValues:(double[])x2Values
{
    double p[2];
    p[0] = 0.0;p[1] = 0.0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        p[0] = p[0] + (a[i] * d[i] - b[i] * c[i]) / (a[i] + b[i] + c[i] + d[i]);
        p[1] = p[1] + ((a[i] + b[i]) * (c[i] + d[i]) * (a[i] + c[i]) * (b[i] + d[i])) / (((a[i] + b[i] + c[i] + d[i]) - 1) * (a[i] + b[i] + c[i] + d[i]) * (a[i] + b[i] + c[i] + d[i]));
    }
    
    x2Values[21] = (p[0] * p[0]) / p[1];
    x2Values[23] = ((ABS(p[0]) - 0.5) * (ABS(p[0]) - 0.5)) / p[1];
}

- (void)mleOR:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d LowerLimit:(double)LL ArrayLengths:(int)withStatistics ReturnValues:(double[])rValues
{
    rValues[0] = 0.0;
    bool yyZero = YES;
    bool ynZero = YES;
    bool nyZero = YES;
    bool nnZero = YES;
    for (int i = 0; i < withStatistics; i++)
    {
        if (a[i] > 0.0)
            yyZero = NO;
        if (b[i] > 0.0)
            ynZero = NO;
        if (c[i] > 0.0)
            nyZero = NO;
        if (d[i] > 0.0)
            nnZero = NO;
    }
    if (ynZero || nyZero)
        rValues[25] = INFINITY;
    if (!(yyZero || ynZero || nyZero || nnZero))
        [self ucestimaten:a CellB:b CellC:c CellD:d LowerLimit:LL ArrayLengths:withStatistics ReturnValues:rValues];
}

- (void)exactORLL:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d ArrayLengths:(int)withStatistics ReturnValues:(double[])rValues
{
    rValues[1] = 0.0;
    bool yyZero = YES;
    bool nnZero = YES;
    for (int i = 0; i < withStatistics; i++)
    {
        if (a[i] > 0.0)
            yyZero = NO;
        if (d[i] > 0.0)
            nnZero = NO;
    }
    if (!(yyZero || nnZero))
    {
        [self exactorln:a CellB:b CellC:c CellD:d ArrayLengths:withStatistics ReturnValues:rValues];
    }
}

- (void)exactORUL:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d Estimate:(double)MLE ArrayLengths:(int)withStatistics ReturnValues:(double[])rValues
{
    rValues[2] = 0.0;
    bool ynZero = YES;
    bool nyZero = YES;
    for (int i = 0; i < withStatistics; i++)
    {
        if (b[i] > 0.0)
            ynZero = NO;
        if (c[i] > 0.0)
            nyZero = NO;
    }
    if (!(ynZero || nyZero))
        [self exactorun:a CellB:b CellC:c CellD:d Estimate:MLE ArrayLengths:withStatistics ReturnValues:rValues];
}

- (void)exactorln:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d ArrayLengths:(int)withStatistics ReturnValues:(double[])rValues
{
    int M1[withStatistics];
    int M0[withStatistics];
    int N1[withStatistics];
    int N0[withStatistics];
    int ls[withStatistics];
    int us[withStatistics];
    double xs[withStatistics];
    
    for (int i = 0; i < withStatistics; i++)
        xs[i] = a[i];

    int x = 0;
    int l = 0;
    int u = 0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        M1[i] = (int) (a[i] + c[i]);
        M0[i] = (int) (b[i] + d[i]);
        N1[i] = (int) (a[i] + b[i]);
        N0[i] = (int) (c[i] + d[i]);
        ls[i] = MAX(0, N1[i] - M0[i]);
        us[i] = MIN(M1[i], N1[i]);
        x = (int) (x + xs[i]);
        l = l + ls[i];
        u = u + us[i];
    }
    
    int dimC2 = 0;
    for (int i = 0; i < withStatistics; i++)
        dimC2 += (us[i] - ls[i]);
    double maxuldiff = 0.0;
    
    NSMutableArray *Cs = [[NSMutableArray alloc] init];
    for (int i = 0; i < withStatistics; i++)
    {
        if (us[i] - ls[i] > maxuldiff)
            maxuldiff = us[i] - ls[i];
        [Cs addObject:[[NSMutableArray alloc] init]];
        for (int s = ls[i]; s <= us[i]; s++)
            [Cs[i] addObject:[[NSNumber alloc] initWithDouble:[SharedResources choosey:M1[i] chooseK:s] * [SharedResources choosey:M0[i] chooseK:(N1[i] - s)]]];
    }

    double C2[dimC2 + 1];
    for (int i = 0; i < dimC2 + 1; i++)
        C2[i] = 0.0;
    for (int j = 0; j <= us[0] - ls[0]; j++)
        for (int k = 0; k <= us[1] - ls[1]; k++)
            C2[j + k] = C2[j + k] + [Cs[0][j] doubleValue] * [Cs[1][k] doubleValue];
    
    int bound = 0;
    double Y[u - l + 1];
    for (int i = 2; i < withStatistics; i++)
    {
        for (int j = 0; j <= u - l; j++)
        {
            Y[j] = C2[j];
            C2[j] = 0.0;
        }
        bound = 0;
        for (int j = 0; j < i; j++)
            bound = bound + (us[i] - ls[i]);
        for (int j = 0; j <= u - l; j++)
            for (int k = 0; k <= us[i] - ls[i]; k++)
                if (j + k <= u - l)
                    C2[j + k] = C2[j + k] + Y[j] * [Cs[i][k] doubleValue];
    }
    
    double R = 0.0;
    double Ds[withStatistics];
    for (int i = 0; i < withStatistics; i++)
        Ds[i] = 0.0;
    double d2 = 1.0;
    double FR = 1.0;
    double adder = 0.0;
    
    //The below commented line is from the old bethod.  Before I learned the halfway method.
//    while (ABS(FR - 0.975) > 0.0002)
    while (FR > 0.975)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        for (int i = 0; i < withStatistics; i++)
            Ds[i] = 0.0;
        d2 = 1.0;
        FR = 0.0;
        R += 1;
        for (int j = 0; j < withStatistics; j++)
        {
            for (int i = 0; i <= us[j] - ls[j]; i++)
                Ds[j] = Ds[j] + [Cs[j][i] doubleValue] * pow(R, ls[j] + i);
            d2 = d2 * Ds[j];
        }
        for (int i = 0; i <= (x - 1) - l; i++)
        {
            adder = C2[i];
            for (int j = 0; j < withStatistics; j++)
                adder /= Ds[j];
            adder *= pow(R,  i + l);
            FR += adder;
//            FR = FR + (C2[i] * pow(R,  i + l)) / d2;
        }
    }
    double aa = R - 1.0;
    double bb = R + 0.5;
    double precision = 0.000001;
    while (bb - aa > precision)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        for (int i = 0; i < withStatistics; i++)
            Ds[i] = 0.0;
        d2 = 1.0;
        FR = 0.0;
        R = (bb + aa) / 2.0;
        for (int j = 0; j < withStatistics; j++)
        {
            for (int i = 0; i <= us[j] - ls[j]; i++)
                Ds[j] = Ds[j] + [Cs[j][i] doubleValue] * pow(R, ls[j] + i);
            d2 = d2 * Ds[j];
        }
        for (int i = 0; i <= (x - 1) - l; i++)
        {
            adder = C2[i];
            for (int j = 0; j < withStatistics; j++)
                adder /= Ds[j];
            adder *= pow(R,  i + l);
            FR += adder;
            //            FR = FR + (C2[i] * pow(R,  i + l)) / d2;
        }
        if (FR > 0.975)
            aa = R;
        else
            bb = R;
    }

    rValues[1] = R;
}

- (void)ucestimaten:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d LowerLimit:(double)LL ArrayLengths:(int)withStatistics ReturnValues:(double[])rValues
{
    int M1[withStatistics];
    int M0[withStatistics];
    int N1[withStatistics];
    int N0[withStatistics];
    int ls[withStatistics];
    int us[withStatistics];
    double xs[withStatistics];
    
    for (int i = 0; i < withStatistics; i++)
        xs[i] = a[i];
    
    int x = 0;
    int l = 0;
    int u = 0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        M1[i] = (int) (a[i] + c[i]);
        M0[i] = (int) (b[i] + d[i]);
        N1[i] = (int) (a[i] + b[i]);
        N0[i] = (int) (c[i] + d[i]);
        ls[i] = MAX(0, N1[i] - M0[i]);
        us[i] = MIN(M1[i], N1[i]);
        x = (int) (x + xs[i]);
        l = l + ls[i];
        u = u + us[i];
    }
    
    int dimC2 = 0;
    for (int i = 0; i < withStatistics; i++)
        dimC2 += (us[i] - ls[i]);
    double maxuldiff = 0.0;
    
    NSMutableArray *Cs = [[NSMutableArray alloc] init];
    for (int i = 0; i < withStatistics; i++)
    {
        if (us[i] - ls[i] > maxuldiff)
            maxuldiff = us[i] - ls[i];
        [Cs addObject:[[NSMutableArray alloc] init]];
        for (int s = ls[i]; s <= us[i]; s++)
            [Cs[i] addObject:[[NSNumber alloc] initWithDouble:[SharedResources choosey:M1[i] chooseK:s] * [SharedResources choosey:M0[i] chooseK:(N1[i] - s)]]];
    }

    double C2[dimC2 + 1];
    for (int i = 0; i < dimC2 + 1; i++)
        C2[i] = 0.0;
    for (int j = 0; j <= us[0] - ls[0]; j++)
        for (int k = 0; k <= us[1] - ls[1]; k++)
            C2[j + k] = C2[j + k] + [Cs[0][j] doubleValue] * [Cs[1][k] doubleValue];
    
    int bound = 0;
    double Y[u - l + 1];
    for (int i = 2; i < withStatistics; i++)
    {
        for (int j = 0; j <= u - l; j++)
        {
            Y[j] = C2[j];
            C2[j] = 0.0;
        }
        bound = 0;
        for (int j = 0; j < i; j++)
            bound = bound + (us[i] - ls[i]);
        for (int j = 0; j <= u - l; j++)
            for (int k = 0; k <= us[i] - ls[i]; k++)
                if (j + k <= u - l)
                    C2[j + k] = C2[j + k] + Y[j] * [Cs[i][k] doubleValue];
    }
    
    double R = ((double) round(LL * 10000) / 10000) - 0.0002;
    double Ds[withStatistics];
    for (int i = 0; i < withStatistics; i++)
        Ds[i] = 0.0;
    double d2 = 1.0;
    double FR = 0.0;
    double adder = 0.0;
    
    //The below commented line is from the old bethod.  Before I learned the halfway method.
//    while (ABS(FR - x) > 0.002)
    while (FR < x)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        for (int i = 0; i < withStatistics; i++)
            Ds[i] = 0.0;
        d2 = 1.0;
        FR = 0.0;
        R += 1;
        for (int j = 0; j < withStatistics; j++)
        {
            for (int i = 0; i <= us[j] - ls[j]; i++)
                Ds[j] = Ds[j] + [Cs[j][i] doubleValue] * pow(R, ls[j] + i);
            d2 = d2 * Ds[j];
        }
        for (int i = 0; i <= u - l; i++)
        {
            adder = (i + l) * C2[i];
            for (int j = 0; j < withStatistics; j++)
                adder /= Ds[j];
            adder *= pow(R,  i + l);
            FR += adder;
            //            FR = FR + (C2[i] * pow(R,  i + l)) / d2;
        }
    }
    double aa = R - 1.0;
    double bb = R + 0.5;
    double precision = 0.000001;
    while (bb - aa > precision)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        for (int i = 0; i < withStatistics; i++)
            Ds[i] = 0.0;
        d2 = 1.0;
        FR = 0.0;
        R = (bb + aa) / 2.0;
        for (int j = 0; j < withStatistics; j++)
        {
            for (int i = 0; i <= us[j] - ls[j]; i++)
                Ds[j] = Ds[j] + [Cs[j][i] doubleValue] * pow(R, ls[j] + i);
            d2 = d2 * Ds[j];
        }
        for (int i = 0; i <= u - l; i++)
        {
            adder = (i + l) * C2[i];
            for (int j = 0; j < withStatistics; j++)
                adder /= Ds[j];
            adder *= pow(R,  i + l);
            FR += adder;
            //            FR = FR + (C2[i] * pow(R,  i + l)) / d2;
        }
        if (FR < x)
            aa = R;
        else
            bb = R;
    }

    rValues[0] = R;
}

- (void)exactorun:(double[])a CellB:(double[])b CellC:(double[])c CellD:(double[])d Estimate:(double)MLE ArrayLengths:(int)withStatistics ReturnValues:(double[])rValues
{
    int M1[withStatistics];
    int M0[withStatistics];
    int N1[withStatistics];
    int N0[withStatistics];
    int ls[withStatistics];
    int us[withStatistics];
    double xs[withStatistics];
    
    for (int i = 0; i < withStatistics; i++)
        xs[i] = a[i];
    
    int x = 0;
    int l = 0;
    int u = 0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        M1[i] = (int) (a[i] + c[i]);
        M0[i] = (int) (b[i] + d[i]);
        N1[i] = (int) (a[i] + b[i]);
        N0[i] = (int) (c[i] + d[i]);
        ls[i] = MAX(0, N1[i] - M0[i]);
        us[i] = MIN(M1[i], N1[i]);
        x = (int) (x + xs[i]);
        l = l + ls[i];
        u = u + us[i];
    }
    
    int dimC2 = 0;
    for (int i = 0; i < withStatistics; i++)
        dimC2 += (us[i] - ls[i]);
    double maxuldiff = 0.0;
    
    NSMutableArray *Cs = [[NSMutableArray alloc] init];
    for (int i = 0; i < withStatistics; i++)
    {
        if (us[i] - ls[i] > maxuldiff)
            maxuldiff = us[i] - ls[i];
        [Cs addObject:[[NSMutableArray alloc] init]];
        for (int s = ls[i]; s <= us[i]; s++)
            [Cs[i] addObject:[[NSNumber alloc] initWithDouble:[SharedResources choosey:M1[i] chooseK:s] * [SharedResources choosey:M0[i] chooseK:(N1[i] - s)]]];
    }

    double C2[dimC2 + 1];
    for (int i = 0; i < dimC2 + 1; i++)
        C2[i] = 0.0;
    for (int j = 0; j <= us[0] - ls[0]; j++)
        for (int k = 0; k <= us[1] - ls[1]; k++)
        {
            C2[j + k] = C2[j + k] + [Cs[0][j] doubleValue] * [Cs[1][k] doubleValue];
            if (C2[j + k] == INFINITY)
            {
                rValues[2] = NAN;
                return;
            }
        }
    
    int bound = 0;
    double Y[u - l + 1];
    for (int i = 2; i < withStatistics; i++)
    {
        for (int j = 0; j <= u - l; j++)
        {
            Y[j] = C2[j];
            C2[j] = 0.0;
        }
        bound = 0;
        for (int j = 0; j < i; j++)
            bound = bound + (us[i] - ls[i]);
        for (int j = 0; j <= u - l; j++)
            for (int k = 0; k <= us[i] - ls[i]; k++)
            {
                if (j + k <= u - l)
                    C2[j + k] = C2[j + k] + Y[j] * [Cs[i][k] doubleValue];
                if (C2[j + k] == INFINITY)
                {
                    rValues[2] = NAN;
                    return;
                }
            }
    }
    
    double R = ((double) round(MLE * 10000) / 10000) - 0.1;
    double Ds[withStatistics];
    for (int i = 0; i < withStatistics; i++)
        Ds[i] = 0.0;
    double d2 = 1.0;
    double FR = 1.0;
//    double adder = 0.0;
    
    //The below commented line is from the old bethod.  Before I learned the halfway method.
//    while (ABS(FR - 0.025) > 0.0002)
    while (FR > 0.025)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        for (int i = 0; i < withStatistics; i++)
            Ds[i] = 0.0;
        d2 = 1.0;
        FR = 0.0;
        R += 0.1;
        for (int j = 0; j < withStatistics; j++)
        {
            for (int i = 0; i <= us[j] - ls[j]; i++)
                Ds[j] = Ds[j] + [Cs[j][i] doubleValue] * pow(R, ls[j] + i);
            d2 = d2 * Ds[j];
        }
        double MiddlePart = 1 / Ds[0];
        for (int i = 0; i <= x - l; i++)
        {
            if (i + l > 0)
                MiddlePart = R / Ds[0];
            for (int j = 2; j <= i + l; j++)
                MiddlePart *= R;
            for (int j = 1; j < withStatistics; j++)
                MiddlePart /= Ds[j];
            FR += C2[i] * MiddlePart;
/*
            adder = C2[i];
            for (int j = 0; j < withStatistics; j++)
                adder /= Ds[j];
            adder *= pow(R,  i + l);
            FR += adder;*/
            //            FR = FR + (C2[i] * pow(R,  i + l)) / d2;
        }
    }
    double aa = R - 1.0;
    double bb = R + 0.5;
    double precision = 0.000001;
    while (bb - aa > precision)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        for (int i = 0; i < withStatistics; i++)
            Ds[i] = 0.0;
        d2 = 1.0;
        FR = 0.0;
        R = (bb + aa) / 2.0;
        for (int j = 0; j < withStatistics; j++)
        {
            for (int i = 0; i <= us[j] - ls[j]; i++)
                Ds[j] = Ds[j] + [Cs[j][i] doubleValue] * pow(R, ls[j] + i);
            d2 = d2 * Ds[j];
        }
        double MiddlePart = 1 / Ds[0];
        for (int i = 0; i <= x - l; i++)
        {
            if (i + l > 0)
                MiddlePart = R / Ds[0];
            for (int j = 2; j <= i + l; j++)
                MiddlePart *= R;
            for (int j = 1; j < withStatistics; j++)
                MiddlePart /= Ds[j];
            FR += C2[i] * MiddlePart;
            /*
            adder = C2[i];
            for (int j = 0; j < withStatistics; j++)
                adder /= Ds[j];
            adder *= pow(R,  i + l);
            FR += adder;*/
            //            FR = FR + (C2[i] * pow(R,  i + l)) / d2;
        }
        if (FR > 0.025)
            aa = R;
        else
            bb = R;
    }

    rValues[2] = R;
}

- (double)bdtOR:(double[])yy CellB:(double[])yn CellC:(double[])ny CellD:(double[])nn ArrayLengths:(int)withStatistics MLEOddsRatio:(double)mleOR
{
    double bd = 0.0;
    double sumYY = 0.0;
    double sumAk = 0.0;
    double sumVar = 0.0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        double N1k = yy[i] + ny[i];
        double N0k = yn[i] + nn[i];
        double tk = yy[i] + yn[i];
        
        double a = 0.0;
        double b = MIN(tk, N1k);
        double Ak = (a + b) / 2.0;
        
        double precision = 0.00001;
        double psi = 0.0;
        
        do {
            //Expected cell count for yy under adjusted mleOR assumption
            Ak = (a + b) / 2.0;
            //Formula for iteratively computing expected count
            psi = (Ak * (N0k - tk + Ak)) / ((N1k - Ak) * (tk - Ak));
            
            if (psi < 0.0 || psi < mleOR)
                a = Ak;
            else
                b = Ak;
        } while (ABS(mleOR - psi) > precision);
        
        double var = 1 / (1 / Ak + 1 / (N1k - Ak) + 1 / (tk - Ak) + 1 / (N0k - tk + Ak));
        
        //The Breslow-Day (uncorrected) statistic
        bd += ((yy[i] - Ak) * (yy[i] - Ak)) / var;
        
        sumYY += yy[i];
        sumAk += Ak;
        sumVar += var;
    }
    
    //Tarone correction to Breslow-Day
    double correction = ((sumYY - sumAk) * (sumYY - sumAk)) / sumVar;
    
    bd -= correction;
    
    return bd;
}

- (double)bdOR:(double[])yy CellB:(double[])yn CellC:(double[])ny CellD:(double[])nn ArrayLengths:(int)withStatistics
{
    double bd = 0.0;

    double w[withStatistics];
    double or[withStatistics];
    
    for (int i = 0; i < withStatistics; i++)
    {
        or[i] = (yy[i] / yn[i]) / (ny[i] / nn[i]);
        w[i] = 1 / (1 / yy[i] + 1 / yn[i] + 1 / ny[i] + 1 / nn[i]);
    }
    
    double numerator = 0.0;
    double denominator = 0.0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        numerator += w[i] * log(or[i]);
        denominator += w[i];
    }
    
    double orDirect = exp(numerator / denominator);
    
    for (int i = 0; i < withStatistics; i++)
        bd += pow(log(or[i]) - log(orDirect), 2.0) * w[i];
    
    return bd;
}

- (double)bdRR:(double[])yy CellB:(double[])yn CellC:(double[])ny CellD:(double[])nn ArrayLengths:(int)withStatistics
{
    double bd = 0.0;

    double w[withStatistics];
    double rr[withStatistics];
    
    for (int i = 0; i < withStatistics; i++)
    {
        rr[i] = (yy[i] / (yy[i] + yn[i])) / (ny[i] / (ny[i] + nn[i]));
        w[i] = 1 / (yn[i] / (yy[i] * (yy[i] + yn[i])) + nn[i] / (ny[i] * (ny[i] + nn[i])));
    }
    
    double numerator = 0.0;
    double denominator = 0.0;
    
    for (int i = 0; i < withStatistics; i++)
    {
        numerator += w[i] * log(rr[i]);
        denominator += w[i];
    }
    
    double rrDirect = exp(numerator / denominator);
    
    for (int i = 0; i < withStatistics; i++)
        bd += pow(log(rr[i]) - log(rrDirect), 2.0) * w[i];
    
    return bd;
}
@end
