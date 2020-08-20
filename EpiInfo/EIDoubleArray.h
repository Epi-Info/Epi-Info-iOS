//
//  EIDoubleArray.h
//  EpiInfo
//
//  Created by John Copeland on 8/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EIDoubleArray : NSObject
@property NSMutableArray *nsma;
-(id)initWithCapacity:(NSUInteger)numItems;
-(id)initWithCArray:(double*)cArray ofSize:(int)numItems;
-(void)setNumber:(double)value atIndex:(int)index;
-(double)numberAtIndex:(int)index;
-(double*)cArray;
-(void)sort;
-(EIDoubleArray *)copy;
@end

NS_ASSUME_NONNULL_END
