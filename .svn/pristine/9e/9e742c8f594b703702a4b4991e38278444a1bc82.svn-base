//
//  MeansObject.h
//  EpiInfo
//
//  Created by John Copeland on 8/21/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalysisDataObject.h"
#import "SQLiteData.h"
#import "sqlite3.h"

@interface MeansObject : NSObject
{
    sqlite3 *analysisDB;
}

@property (nonatomic, strong) NSString *meansVariable;
@property (nonatomic, strong) NSArray *meansVariableValues;
@property (nonatomic, strong) NSArray *meansVariableFloatValues;

-(id)initWithAnalysisDataObject:(AnalysisDataObject *)dataSet AndMeansVariable:(NSString *)meansVariable AndIncludeMissing:(BOOL)includeMissing;
-(id)initWithSQLiteData:(SQLiteData *)dataSet AndWhereClause:(NSString *)whereClause AndMeansVariable:(NSString *)meansVariable AndIncludeMissing:(BOOL)includeMissing;
@end
