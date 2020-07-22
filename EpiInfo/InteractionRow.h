//
//  InteractionRow.h
//  EpiInfo
//
//  Created by John Copeland on 11/21/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InteractionRow : NSObject
@property NSString *variableName;
@property NSString *oddsRatio;
@property NSString *ninetyFivePercent;
@property NSString *ci;
@end

NS_ASSUME_NONNULL_END
