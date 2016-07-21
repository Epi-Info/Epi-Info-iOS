//
//  ChiSquareCalculatorCompute.m
//  EpiInfo
//
//  Created by John Copeland on 10/29/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import "ChiSquareCalculatorCompute.h"
#import "SharedResources.h"

@implementation ChiSquareCalculatorCompute
-(void)Calculate:(int)levels ExposureScoreVector:(double[])esv CasesVector:(int[])cav ControlsVector:(int[])cov OddsRatioVector:(double[])orv ChiSquareAndPValueVector:(double[])cspvv
{
    double n1 = 0.0;
    double n2 = 0.0;
    double n = 0.0;
    double T1 = 0.0;
    double T2 = 0.0;
    double T3 = 0.0;
    double Vsum = 0.0;
    double V1sum = 0.0;
    
    orv[0] = 1.0;
    orv[1] = round(1000 * ((double)cav[1] / (double)cov[1]) / ((double)cav[0] / (double)cov[0])) / 1000;
    
    for (int i = 0; i < levels; i++)
    {
        if (i > 0)
            orv[i] = round(1000 * ((double)cav[i] / (double)cov[i]) / ((double)cav[0] / (double)cov[0])) / 1000;
        double x = esv[i];
        double a = (double)cav[i];
        double b = (double)cov[i];
        double m = a + b;
        T1 += a * x;
        T2 += m * x;
        T3 += m * x * x;
        n1 += a;
        n2 += b;
        n += a + b;
    }
    
    Vsum += (n1 * n2 * (n * T3 - (T2 * T2))) / (n * n * (n - 1));
    V1sum += T1 - ((n1 / n) * T2);
    
    cspvv[0] = ((V1sum - 0.5) * (V1sum - 0.5)) / Vsum;
    cspvv[1] = [SharedResources PValFromChiSq:cspvv[0] PVFCSdf:1.0];
}
@end
