//
//  AssignModel.h
//  EpiInfo
//
//  Created by John Copeland on 8/4/16.
//

#import "ConditionsModel.h"

@interface AssignModel : ConditionsModel
{
    NSString *assignment;
}

@property(nonatomic) NSString *assignment;

-(id)initWithPage:(NSString *)newPage from:(NSString *)newFrom name:(NSString *)newName element:(NSString *)newElement assignment:(NSString *)newAssignment beforeAfter:(NSString *)newbeforeAfter condition:(NSString *)newCondition;
@end
