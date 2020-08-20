//
//  FEXACT.h
//  EpiInfo
//
//  Created by John Copeland on 7/28/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEXACT : NSObject
{
    double stp[];
}
+(float)FEXACT:(NSArray *)SortedRows;
@end

NS_ASSUME_NONNULL_END
