//
//  EIDoubleArray.m
//  EpiInfo
//
//  Created by John Copeland on 8/5/20.
//

#import "EIDoubleArray.h"

@implementation EIDoubleArray
@synthesize nsma = _nsma;
- (id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self)
    {
        self.nsma = [[NSMutableArray alloc] init];
        for (int i = 0; i < numItems; i++)
            [self.nsma addObject:[NSNumber numberWithDouble:0.0]];
    }
    return self;
}
- (id)initWithCArray:(double[])cArray ofSize:(int)numItems
{
    self = [self initWithCapacity:numItems];
    if (self)
    {
        for (int i = 0; i < numItems; i++)
            [self.nsma setObject:[NSNumber numberWithDouble:cArray[i]] atIndexedSubscript:i];
    }
    return self;
}
- (NSUInteger)count
{
    return [self.nsma count];
}
- (void)setNumber:(double)value atIndex:(int)index
{
    [self.nsma setObject:[NSNumber numberWithDouble:value] atIndexedSubscript:index];
}
- (double)numberAtIndex:(int)index
{
    return [(NSNumber *)[self.nsma objectAtIndex:index] doubleValue];
}
- (void)addObject:(id)anObject
{
    [self.nsma addObject:anObject];
}
- (double*)cArray
{
    double cArray[[self.nsma count]];
    for (int i = 0; i < [self.nsma count]; i++)
        cArray[i] = [(NSNumber *)[self.nsma objectAtIndex:i] doubleValue];
    return cArray;
}
- (void)sort
{
    [self.nsma sortUsingSelector:@selector(compare:)];
}
- (EIDoubleArray *)copy
{
    EIDoubleArray *copyofself = [[EIDoubleArray alloc] initWithCapacity:[self.nsma count]];
    for (int i = 0; i < [self.nsma count]; i++)
        [copyofself setNumber:[(NSNumber *)[self.nsma objectAtIndex:i] intValue] atIndex:i];
    return copyofself;
}@end
