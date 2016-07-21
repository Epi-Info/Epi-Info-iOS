//
//  ElementPairsCheck.m
//  EpiInfo
//
//  Created by admin on 11/24/15.
//  Copyright © 2015 John Copeland. All rights reserved.
//

#import "ElementPairsCheck.h"

@implementation ElementPairsCheck
@synthesize name;
@synthesize stringValue;
@synthesize condition;

-(id)initWithName:(NSString *)newName condition:(NSString *)newCondition stringValue:(NSString *)newStringValue;
{
    self = [super init];
    if (self!=nil) {
        self.name = newName;
        self.stringValue = newStringValue;
        self.condition = newCondition;
    }
   
    return self;
}
@end
