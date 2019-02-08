//
//  LinearRegressionResults.m
//  EpiInfo
//
//  Created by John Copeland on 2/4/19.
//

#import "LinearRegressionResults.h"

@implementation LinearRegressionResults
@synthesize variables = _variables;
@synthesize betas = _betas;
@synthesize standardErrors = _standardErrors;
@synthesize betaLCLs = _betaLCLs;
@synthesize betaUCLs = _betaUCLs;
@synthesize betaFs = _betaFs;
@synthesize betaFPs = _betaFPs;
@synthesize errorMessage = _errorMessage;
@synthesize correlationCoefficient = _correlationCoefficient;
@synthesize regressionDf = _regressionDf;
@synthesize regressionSumOfSquares = _regressionSumOfSquares;
@synthesize regressionMeanSquare = _regressionMeanSquare;
@synthesize regressionF = _regressionF;
@synthesize regressionFP = _regressionFP;
@synthesize residualsDf = _residualsDf;
@synthesize residualsSumOfSquares = _residualsSumOfSquares;
@synthesize residualsMeanSquare = _residualsMeanSquare;
@synthesize totalDf = _totalDf;
@synthesize totalSumOfSquares = _totalSumOfSquares;

- (id)init
{
    self = [super init];
    if (self) {
        self.variables = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
