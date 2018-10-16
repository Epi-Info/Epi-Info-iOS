//
//  MatchedPairCompute.h
//  MatchedPairCalculator
//
//  Created by John Copeland on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchedPairCompute : NSObject
-(double)OddsRatioEstimate:(int)a cellb:(int)b cellc:(int)c celld:(int)d;
-(double)OddsRatioLower:(int)a cellb:(int)b cellc:(int)c celld:(int)d;
-(double)OddsRatioUpper:(int)a cellb:(int)b cellc:(int)c celld:(int)d;
-(void)oneFish:(int)a cellb:(int)b cellc:(int)c celld:(int)d rvs:(double[])oTF;
-(void)fisherLimits:(int)a cellb:(int)b cellc:(int)c celld:(int)d limits:(double[])l;
-(double)McNemarUncorrectedVal:(int)a cellb:(int)b cellc:(int)c celld:(int)d;
-(double)McNemarCorrectedVal:(int)a cellb:(int)b cellc:(int)c celld:(int)d;
@end
