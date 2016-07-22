//
//  ConditionsModel.h
//  EpiInfo
//
//  Created by admin on 12/9/15.
//  Copyright © 2015 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConditionsModel : NSObject
{
    NSString *page;
    NSString *from;
    NSString *name;
    NSString *element;
    NSString *beforeAfter;
    NSString *condition;
}

@property(nonatomic) NSString *page;
@property(nonatomic) NSString *from;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *element;
@property(nonatomic) NSString *beforeAfter;
@property(nonatomic) NSString *condition;

-(id)initWithPage:(NSString *)newPage from:(NSString *)newFrom name:(NSString *)newName element:(NSString *)newElement beforeAfter:(NSString *)newbeforeAfter condition:(NSString *)newCondition;
@end
