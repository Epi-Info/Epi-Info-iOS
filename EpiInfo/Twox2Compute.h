//
//  Twox2Compute.h
//  StatCalc2x2
//
//  Created by John Copeland on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigDouble.h"

@interface Twox2Compute : NSObject
-(double)OddsRatioEstimate:(int)a cellb:(int)b cellc:(int)c celld:(int)d;
-(double)OddsRatioLower:(int)a cellb:(int)b cellc:(int)c celld:(int)d;
-(double)OddsRatioUpper:(int)a cellb:(int)b cellc:(int)c celld:(int)d;
-(double)CalcPoly:(double)yy CPyn:(double)yn CPny:(double)ny CPnn:(double)nn CPExactResults:(double[])ExactResults;
-(double)FishOR:(int)a cellb:(int)b cellc:(int)c celld:(int)d alpha:(double)alpha initialOR:(double)OR plusA:(int)plusA one:(int)one minus:(int)minus PBLowerVariable:(BOOL)pbLower PBFisherVariable:(BOOL)pbFisher;
-(void)RRStats:(int)a RRSb:(int)b RRSc:(int)c RRSd:(int)d RRSstats:(double[])RRstats;
-(double)GetExactLim:(BOOL)pbLower IsItFisher:(BOOL)pbFisher ApproxVariable:(double)approx MinSumAVariable:(double)minSumA SumAVariable:(double)sumA DegDVariable:(int)degD BigPolyD:(BigDouble *__strong*)bigPolyD;
-(double)CalcExactLim:(BOOL)pbLower IsItFisher:(BOOL)pbFisher ApproxVariable:(double)approx MinSumAVariable:(double)minSumA SumAVariable:(double)sumA MaxSumAVariable:(double)maxSumA DegDVariable:(int)degD BigPolyD:(BigDouble *__strong*)bigPolyD;
@end
