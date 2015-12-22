//
//  PopulationSurveySampleSizeCompute.m
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import "PopulationSurveySampleSizeCompute.h"
#import "SharedResources.h"

@implementation PopulationSurveySampleSizeCompute

-(void)CalculateSampleSizes:(int)pop ExpectedFrequency:(double)freq ConfidenceLimit:(double)worst DesignEffect:(double)de NumberOfClusters:(int)clusters ClusterSizes:(int[])sizes
{
    double percentiles[7];
    percentiles[0] = 0.8;
    percentiles[1] = 0.9;
    percentiles[2] = 0.95;
    percentiles[3] = 0.97;
    percentiles[4] = 0.99;
    percentiles[5] = 0.999;
    percentiles[6] = 0.9999;
    
    double d = ABS(worst);
    double factor = freq * (100 - freq) / (d * d);
    for (int i = 0; i < 7; i++)
    {
        double twoTail = [SharedResources ANorm:(1 - percentiles[i])];
        double n = twoTail * twoTail * factor;
        double sampleSize = n / (1 + (n / pop));
        sizes[i] = (int)round(sampleSize);
        sizes[i] = (int)ceil(de * (double)sizes[i] / (double)clusters);
    }
}

@end
