//
//  CheckCodeParser.h
//  EpiInfo
//
//  Created by admin on 1/5/16.
//  Copyright © 2016 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EnterDataView;

@interface CheckCodeParser : NSObject
{
    NSMutableArray *pageArray;
    NSMutableArray *fieldArray;
    NSMutableArray *allArray;
    NSMutableArray *ifArray;
    NSMutableArray *fieldPageArray;
    NSMutableArray *conditionsArray;
    NSMutableString *check;
}

@property(nonatomic,weak) EnterDataView *edv;

-(void)parseCheckCode:(NSString *)pcc;
-(NSMutableArray *)sendArray;
@end
