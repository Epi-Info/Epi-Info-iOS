//
//  LinearRegressionResults.h
//  EpiInfo
//
//  Created by John Copeland on 2/4/19.

//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinearRegressionResults : NSObject
@property NSMutableArray *variables;
@property NSArray *betas;
@property NSArray *standardErrors;
@property NSArray *betaLCLs;
@property NSArray *betaUCLs;
@property NSArray *betaFs;
@property NSArray *betaFPs;

@property NSString *errorMessage;

@property double correlationCoefficient;
@property int regressionDf;
@property double regressionSumOfSquares;
@property double regressionMeanSquare;
@property double regressionF;
@property double regressionFP;
@property int residualsDf;
@property double residualsSumOfSquares;
@property double residualsMeanSquare;
@property int totalDf;
@property double totalSumOfSquares;
@end

NS_ASSUME_NONNULL_END
