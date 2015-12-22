//
//  CohortSampleSizeCompute.h
//  EpiInfo
//
//  Created by John Copeland on 10/11/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CohortSampleSizeCompute : NSObject
-(void)Calculate:(double)a VariableB:(double)b VariableVR:(double)vr VariableV2:(double)v2 VariableVOR:(double)vor VariableV1:(double)v1 KelseyAndFleissValues:(int[])sizes;
@end
