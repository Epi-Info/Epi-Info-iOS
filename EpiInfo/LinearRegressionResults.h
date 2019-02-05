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
@property NSString *errorMessage;
@end

NS_ASSUME_NONNULL_END
