//
//  ChiSquareCalculatorCompute.h
//  EpiInfo
//
//  Created by John Copeland on 10/29/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChiSquareCalculatorCompute : NSObject
-(void)Calculate:(int)levels ExposureScoreVector:(double[])esv CasesVector:(int[])cav ControlsVector:(int[])cov OddsRatioVector:(double[])orv ChiSquareAndPValueVector:(double[])cspvv;
@end
