//
//  ElementPairsCheck.h
//  EpiInfo
//
//  Created by admin on 11/24/15.
//  Copyright © 2015 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ElementPairsCheck : NSObject
{
    NSString *name;
    NSString *stringValue;
    NSString *condition;
}

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *condition;
@property(nonatomic) NSString *stringValue;


-(id)initWithName:(NSString *)newName condition:(NSString *)newCondition stringValue:(NSString *)newStringValue;
@end