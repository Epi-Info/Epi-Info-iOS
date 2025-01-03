//
//  ConditionsModel.m
//  EpiInfo
//
//  Created by admin on 12/9/15.
//  Copyright © 2015 John Copeland. All rights reserved.
//

#import "ConditionsModel.h"

@implementation ConditionsModel
@synthesize page;
@synthesize from;
@synthesize name;
@synthesize element;
@synthesize beforeAfter;
@synthesize condition;

-(id)initWithPage:(NSString *)newPage from:(NSString *)newFrom name:(NSString *)newName element:(NSString *)newElement beforeAfter:(NSString *)newbeforeAfter condition:(NSString *)newCondition;
{
    self = [super init];
    if (self!=nil) {
        self.page = newPage;
        self.from = newFrom;
        self.name = newName;
        self.element = newElement;
        self.beforeAfter = newbeforeAfter;
        self.condition = newCondition;
    }
    
    return self;
}
@end
