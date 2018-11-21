//
//  LogisticRegressionResults.m
//  EpiInfo
//
//  Created by John Copeland on 11/21/18.
//

#import "LogisticRegressionResults.h"

@implementation LogisticRegressionResults
@synthesize variables = _variables;
@synthesize interactionOddsRatios = _interactionOddsRatios;
@synthesize convergence = _convergence;
@synthesize iterations = _iterations;
@synthesize finalLikelihood = _finalLikelihood;
@synthesize casesIncluded = _casesIncluded;
@synthesize scoreStatistic = _scoreStatistic;
@synthesize scoreDF = _scoreDF;
@synthesize scoreP = _scoreP;
@synthesize LRStatistic = _LRStatistic;
@synthesize LRDF = _LRDF;
@synthesize LRP = _LRP;
@synthesize errorMessage = _errorMessage;

- (id)init
{
    self = [super init];
    if (self) {
        self.variables = [[NSMutableArray alloc] init];
        self.interactionOddsRatios = [[NSMutableArray alloc] init];
        self.convergence = [[NSString alloc] init];
        self.errorMessage = [[NSString alloc] init];
    }
    return self;
}
@end
