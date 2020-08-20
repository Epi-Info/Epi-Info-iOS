//
//  EIIntArray.h
//  EpiInfo
//
//  Created by John Copeland on 8/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EIIntArray : NSObject
@property NSMutableArray *nsma;
-(id)initWithCapacity:(NSUInteger)numItems;
-(id)initWithCArray:(int*)cArray ofSize:(int)numItems;
-(void)setNumber:(int)value atIndex:(int)index;
-(int)numberAtIndex:(int)index;
-(int*)cArray;
-(void)sort;
-(EIIntArray *)copy;
@end

NS_ASSUME_NONNULL_END
