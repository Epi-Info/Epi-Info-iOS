//
//  PopulationSurveySampleSizeCompute.h
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopulationSurveySampleSizeCompute : NSObject
-(void)CalculateSampleSizes:(int)pop ExpectedFrequency:(double)freq ConfidenceLimit:(double)worst DesignEffect:(double)de NumberOfClusters:(int)clusters ClusterSizes:(int[])sizes;
@end
