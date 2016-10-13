//
//  ParseAssignment.h
//  EpiInfo
//
//  Created by John Copeland on 8/17/16.
//

#import <Foundation/Foundation.h>
#import "AssignmentModel.h"

@interface ParseAssignment : NSObject
+(AssignmentModel *)parseAssign:(NSString *)statement;
@end
