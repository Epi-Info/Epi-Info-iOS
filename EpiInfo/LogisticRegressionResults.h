//
//  LogisticRegressionResults.h
//  EpiInfo
//
//  Created by John Copeland on 11/21/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogisticRegressionResults : NSObject
@property NSMutableArray *variables;
@property NSArray *betas;
@property NSArray *standardErrors;
@property NSArray *oddsRatios;
@property NSArray *lcls;
@property NSArray *ucls;
@property NSArray *zStatistics;
@property NSArray *pValues;
@property NSMutableArray *interactionOddsRatios;
@property NSString *convergence;
@property int iterations;
@property double finalLikelihood;
@property int casesIncluded;
@property double scoreStatistic;
@property double scoreDF;
@property double scoreP;
@property double LRStatistic;
@property double LRDF;
@property double LRP;
@property NSString *errorMessage;
@end

NS_ASSUME_NONNULL_END
