//
//  CohortSampleSizeCompute.m
//  EpiInfo
//
//  Created by John Copeland on 10/11/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import "CohortSampleSizeCompute.h"
#import "SharedResources.h"

@implementation CohortSampleSizeCompute

-(void)Calculate:(double)a VariableB:(double)b VariableVR:(double)vr VariableV2:(double)v2 VariableVOR:(double)vor VariableV1:(double)v1 KelseyAndFleissValues:(int[])sizes
{
    double Za = [SharedResources ANorm:a];
    double Zb = 0;
    
    if (b >= 1.0)
        b = b / 100.0;
    if (b < 0.5)
        Zb = -1.0 * [SharedResources ANorm:(2.0 * b)];
    else
        Zb = [SharedResources ANorm:(2.0 - 2.0 * b)];
    if (vor != 0.0)
        v1 = v2 * vor / (1.0 + v2 * (vor - 1.0));
    
    double pbar = (v1 + vr * v2) / (1.0 + vr);
    double qbar = 1.0 - pbar;
    double vn = ((pow((Za + Zb), 2.0)) * pbar * qbar * (vr + 1.0)) / ((pow((v1 - v2), 2.0)) * vr);
    double vn1 = pow(((Za * sqrt((vr + 1.0) * pbar * qbar)) + (Zb * sqrt((vr * v1 * (1.0 - v1)) + (v2 * (1.0 - v2))))), 2.0) / (vr * pow((v2 - v1), 2.0));
    double vn2 = pow(Za * sqrt((vr + 1.0) * pbar * qbar) + Zb * sqrt(vr * v1 * (1.0 - v1) + v2 * (1.0 - v2)), 2.0) / (vr * pow(ABS(v1 - v2), 2.0));
    vn2 = vn2 * pow((1.0 + sqrt(1.0 + 2.0 * (vr + 1.0) / (vn2 * vr * ABS(v2 - v1)))), 2.0) / 4.0;
    
    sizes[0] = ceil(vn);
    sizes[1] = ceil(vn * vr);
    sizes[2] = ceil(vn) + ceil(vn * vr);
    
    sizes[3] = ceil(vn1);
    sizes[4] = ceil(vn1 * vr);
    sizes[5] = ceil(vn1) + ceil(vn1 * vr);
    
    sizes[6] = ceil(vn2);
    sizes[7] = ceil(vn2 * vr);
    sizes[8] = ceil(vn2) + ceil(vn2 * vr);
}

@end
