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
    NSString *from;
    NSString *name;
    NSString *element;
    NSString *beforeAfter;
    NSString *condition;
}

@property(nonatomic,strong) NSString *from;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *element;
@property(nonatomic,strong) NSString *beforeAfter;
@property(nonatomic,strong) NSString *condition;

-(id)initWithFrom:(NSString *)newFrom name:(NSString *)newName element:(NSString *)newElement beforeAfter:(NSString *)newbeforeAfter condition:(NSString *)newCondition;
@end
