//
//  FieldsAndStringValues.m
//  EpiInfo
//
//  Created by John Copeland on 11/2/16.
//

#import "FieldsAndStringValues.h"

@implementation FieldsAndStringValues
@synthesize nsmd = _nsmd;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.nsmd = [[NSMutableDictionary alloc] init];
        NSThread *loggingThread = [[NSThread alloc] initWithTarget:self selector:@selector(backgroundLogging) object:nil];
//        [loggingThread start];
    }
    return self;
}
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    [self.nsmd setObject:anObject forKey:[(NSString *)aKey lowercaseString]];
}
- (id)objectForKey:(id)aKey
{
    return [self.nsmd objectForKey:[(NSString *)aKey lowercaseString]];
}

- (void)backgroundLogging
{
    while (YES) {
        if (!self.nsmd)
            break;
        for (id key in self.nsmd) {
            NSLog(@"%@: %@", key, [self.nsmd objectForKey:key]);
        }
        NSLog(@"-------------------------------------------------");
        sleep(8);
    }
}
@end
