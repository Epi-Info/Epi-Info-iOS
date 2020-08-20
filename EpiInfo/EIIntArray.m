//
//  EIIntArray.m
//  EpiInfo
//
//  Created by John Copeland on 8/5/20.
//

#import "EIIntArray.h"

@implementation EIIntArray
@synthesize nsma = _nsma;
- (id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self)
    {
        self.nsma = [[NSMutableArray alloc] init];
        for (int i = 0; i < numItems; i++)
            [self.nsma addObject:[NSNumber numberWithInt:0]];
    }
    return self;
}
- (id)initWithCArray:(int[])cArray ofSize:(int)numItems
{
    self = [self initWithCapacity:numItems];
    if (self)
    {
        for (int i = 0; i < numItems; i++)
            [self.nsma setObject:[NSNumber numberWithInt:cArray[i]] atIndexedSubscript:i];
    }
    return self;
}
- (NSUInteger)count
{
    return [self.nsma count];
}
- (void)setNumber:(int)value atIndex:(int)index
{
    [self.nsma setObject:[NSNumber numberWithInt:value] atIndexedSubscript:index];
}
- (int)numberAtIndex:(int)index
{
    return [(NSNumber *)[self.nsma objectAtIndex:index] intValue];
}
- (void)addObject:(id)anObject
{
    [self.nsma addObject:anObject];
}
- (int*)cArray
{
    int cArray[[self.nsma count]];
    for (int i = 0; i < [self.nsma count]; i++)
        cArray[i] = [(NSNumber *)[self.nsma objectAtIndex:i] intValue];
    return cArray;
}
- (void)sort
{
    [self.nsma sortUsingSelector:@selector(compare:)];
}
- (EIIntArray *)copy
{
    EIIntArray *copyofself = [[EIIntArray alloc] initWithCapacity:[self.nsma count]];
    for (int i = 0; i < [self.nsma count]; i++)
        [copyofself setNumber:[(NSNumber *)[self.nsma objectAtIndex:i] intValue] atIndex:i];
    return copyofself;
}
@end
