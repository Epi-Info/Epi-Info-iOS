//
//  DictionaryOfFields.m
//  EpiInfo
//
//  Created by John Copeland on 11/2/16.
//

#import "DictionaryOfFields.h"
#import "EpiInfoControlProtocol.h"

@implementation DictionaryOfFields
@synthesize nsmd = _nsmd;
@synthesize fasv = _fasv;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.nsmd = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    [self.nsmd setObject:anObject forKey:[(NSString *)aKey lowercaseString]];
    
    if ([self.fasv objectForKey:[(NSString *)aKey lowercaseString]])
    {
        if ([anObject conformsToProtocol:@protocol(EpiInfoControlProtocol)])
            [anObject assignValue:[self.fasv objectForKey:[(NSString *)aKey lowercaseString]]];
    }
    else
    {
        [self.fasv setObject:@"" forKey:[(NSString *)aKey lowercaseString]];
    }
}
- (id)objectForKey:(id)aKey
{
    return [self.nsmd objectForKey:[(NSString *)aKey lowercaseString]];
}
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [self.nsmd countByEnumeratingWithState:state objects:buffer count:len];
}
@end
