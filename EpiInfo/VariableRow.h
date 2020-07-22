//
//  VariableRow.h
//  EpiInfo
//
//  Created by John Copeland on 11/21/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VariableRow : NSObject
@property NSString *variableName;
@property double oddsRatio;
@property double ninetyFivePercent;
@property double ci;
@property double coefficient;
@property double se;
@property double Z;
@property double P;
@end

NS_ASSUME_NONNULL_END
