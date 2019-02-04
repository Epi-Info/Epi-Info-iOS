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

- (id)init
{
    self = [super init];
    if (self) {
        self.variables = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
