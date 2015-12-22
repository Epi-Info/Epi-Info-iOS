//
//  GrowthPercentilesCompute.h
//  EpiInfo
//
//  Created by John Copeland on 6/20/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalysisDataObject.h"

@interface GrowthPercentilesCompute : NSObject
{
    AnalysisDataObject *lengthForAgeData;
    AnalysisDataObject *weightForAgeData;
    AnalysisDataObject *circumferenceForAgeData;
    AnalysisDataObject *lengthForAgeDataCDC;
    AnalysisDataObject *weightForAgeDataCDC;
    AnalysisDataObject *circumferenceForAgeDataCDC;
}
-(float)computePercentileOnLength:(float)lengthCM forAge:(float)age inMonths:(BOOL)isMonths forMale:(BOOL)isMale;
-(float)computePercentileOnWeight:(float)weightKG forAge:(float)age inMonths:(BOOL)isMonths forMale:(BOOL)isMale;
-(float)computePercentileOnCircumference:(float)circumferenceCM forAge:(float)age inMonths:(BOOL)isMonths forMale:(BOOL)isMale;
@end
