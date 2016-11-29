//
//  AssignModel.m
//  EpiInfo
//
//  Created by John Copeland on 8/4/16.
//

#import "AssignModel.h"

@implementation AssignModel
@synthesize assignment;

- (id)initWithPage:(NSString *)newPage from:(NSString *)newFrom name:(NSString *)newName element:(NSString *)newElement assignment:(NSString *)newAssignment beforeAfter:(NSString *)newbeforeAfter condition:(NSString *)newCondition
{
    self = [super initWithPage:newPage from:newFrom name:newName element:newElement beforeAfter:newbeforeAfter condition:newCondition];
    if (self)
    {
        self.assignment = [newAssignment substringToIndex:(int)[newAssignment rangeOfString:@"<linefeed>"].location];
//        self.assignment = newAssignment;
    }
    
    return self;
}
@end
