//
//  PoissonCalculatorCompute.m
//  EpiInfo
//
//  Created by John Copeland on 10/12/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import "PoissonCalculatorCompute.h"

@implementation PoissonCalculatorCompute
-(void)Calculate:(int)x VariableLambda:(double)lambda ProbabilityArray:(double[])probabilities
{
    probabilities[0] = 0.0;
    probabilities[1] = 0.0;
    probabilities[2] = 0.0;
    probabilities[3] = 0.0;
    probabilities[4] = 0.0;
    
    double denominator = 0.0;
    
    if (x > 0)
    {
        probabilities[0] = exp(-1.0 * lambda);
        for (int j = 1; j < x; j++)
        {
            denominator = 1.0;
            for (int i = 0; i < j; i++)
                denominator *= (j - i);
            probabilities[0] += (pow(lambda, (double)j) * exp(-1.0 * lambda)) / denominator;
        }
    }
    probabilities[1] = exp(-lambda);
    for (int j = 1; j <= x; j++)
    {
        denominator = 1.0;
        for (int i = 0; i < j; i++)
            denominator *= (j - i);
        probabilities[1] += (pow(lambda, (double)j) * exp(-lambda)) / denominator;
    }
    denominator = 1.0;
    for (int i = 0; i < x; i++)
        denominator *= (x - i);
    probabilities[2] = (pow(lambda, x) * exp(-lambda)) / denominator;
    probabilities[3] = 1.0 - probabilities[0];
    probabilities[4] = 1.0 - probabilities[1];
}
@end
