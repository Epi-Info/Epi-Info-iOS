//
//  MatchedPairCompute.m
//  MatchedPairCalculator
//
//  Created by John Copeland on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchedPairCompute.h"
#import "SharedResources.h"

@implementation MatchedPairCompute

-(double)OddsRatioEstimate:(int)a cellb:(int)b cellc:(int)c celld:(int)d
{
    double X = (double)b;
    double Y = (double)c;
    if (X == 0.0 || Y == 0.0)
    {
        X += 0.5;
        Y += 0.5;
    }
    return round(10000 * X / Y) / 10000;
}

-(double)OddsRatioLower:(int)a cellb:(int)b cellc:(int)c celld:(int)d
{
    double X = (double)b;
    double Y = (double)c;
    if (X == 0.0 || Y == 0.0)
    {
        X += 0.5;
        Y += 0.5;
    }
    return round(10000 * exp(log([self OddsRatioEstimate:a cellb:b cellc:c celld:d]) - 1.96 * pow(1 / X + 1 / Y, 0.5))) / 10000;
}

-(double)OddsRatioUpper:(int)a cellb:(int)b cellc:(int)c celld:(int)d
{
    double X = (double)b;
    double Y = (double)c;
    if (X == 0.0 || Y == 0.0)
    {
        X += 0.5;
        Y += 0.5;
    }
    return round(10000 * exp(log([self OddsRatioEstimate:a cellb:b cellc:c celld:d]) + 1.96 * pow(1 / X + 1 / Y, 0.5))) / 10000;
}

-(void)fisherLimits:(int)a cellb:(int)b cellc:(int)c celld:(int)d limits:(double[])l
{
    double X = (double)b;
    double Y = (double)c;
    if (X == 0.0 || Y == 0.0)
    {
        X += 0.5;
        Y += 0.5;
    }
    double F = 0.0;
    double p = 1.0;
    while (p > 0.975)
    {
        F += 1;
        p = [SharedResources pFromF:F DegreesOfFreedom1:2.0 * X DegreesOfFreedom2:2.0 * (Y + 1.0)];
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
    }
    double aa = F - 1.0;
    double bb = F;
    double precision = 0.0000001;
    while (bb - aa > precision)
    {
        F = (bb + aa) / 2.0;
        if ([SharedResources pFromF:F DegreesOfFreedom1:2.0 * X DegreesOfFreedom2:2.0 * (Y + 1.0)] > 0.975)
            aa = F;
        else
            bb = F;
    }
    l[0] = round(10000 * (X * F / (Y + 1.0))) / 10000;
    while (p > 0.025)
    {
        F += 1;
        p = [SharedResources pFromF:F DegreesOfFreedom1:2.0 * (X + 1.0) DegreesOfFreedom2:2.0 * Y];
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
    }
    aa = F - 1.0;
    bb = F + 0.5;
    while (bb - aa > precision)
    {
        F = (bb + aa) / 2.0;
        if ([SharedResources pFromF:F DegreesOfFreedom1:2.0 * (X + 1.0) DegreesOfFreedom2:2.0 * Y] > 0.025)
            aa = F;
        else
            bb = F;
    }
    l[1] = round(10000 * ((X + 1.0) * F / Y)) / 10000;
}

-(double)McNemarUncorrectedVal:(int)a cellb:(int)b cellc:(int)c celld:(int)d
{
    double X = (double)b;
    double Y = (double)c;
    if (X == 0.0 || Y == 0.0)
    {
        X += 0.5;
        Y += 0.5;
    }
    return round(10000 * pow(X - Y, 2.0) / (X + Y)) / 10000;
}

-(double)McNemarCorrectedVal:(int)a cellb:(int)b cellc:(int)c celld:(int)d
{
    double X = (double)b;
    double Y = (double)c;
    if (X == 0.0 || Y == 0.0)
    {
        X += 0.5;
        Y += 0.5;
    }
    return round(10000 * pow(fabs(X - Y) - 1.0, 2.0) / (X + Y)) / 10000;
}

-(void)oneFish:(int)a cellb:(int)b cellc:(int)c celld:(int)d rvs:(double[])oTF
{
    double X = (double)b;
    double Y = (double)c;
    
    double lowfish = 0.0;
    double upfish = 0.0;
    for (int k = 0; k <= b; k++)
        lowfish += [SharedResources choosey:X + Y chooseK:(double)k] * pow(0.5, X + Y);
    for (int k = b; k <= b + c; k++)
        upfish += [SharedResources choosey:X + Y chooseK:(double)k] * pow(0.5, X + Y);
    double lowup = 0.0;
    if (upfish < lowfish)
        lowup = 1.0;
    oTF[0] = round(1000000 * MIN(lowfish, upfish)) / 1000000;
    
    double p = oTF[0];
    double Xp = [SharedResources choosey:X + Y chooseK:X] * pow(0.5, X + Y);
    if (lowup == 1.0)
        for (int k = 0; k < b; k++)
        {
            double tempP = [SharedResources choosey:X + Y chooseK:(double)k] * pow(0.5, X + Y);
            if (tempP < Xp)
                p += tempP;
        }
    else
        for (int k = b; k < b + c; k++)
        {
            double tempP = [SharedResources choosey:X + Y chooseK:(double)k] * pow(0.5, X + Y);
            if (tempP < Xp)
                p += tempP;
        }
    oTF[1] = round(1000000 * p) / 1000000;
}

@end
