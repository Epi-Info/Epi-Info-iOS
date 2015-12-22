//
//  FrequencyObject.h
//  EpiInfo
//
//  Created by John Copeland on 6/27/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalysisDataObject.h"
#import "SQLiteData.h"
#import "sqlite3.h"

@interface FrequencyObject : NSObject
{
    sqlite3 *analysisDB;
}

@property (nonatomic, strong) NSString *variableName;
@property (nonatomic, strong) NSArray *variableValues;
@property (nonatomic, strong) NSArray *cellCounts;

-(id)initWithAnalysisDataObject:(AnalysisDataObject *)dataSet AndVariable:(NSString *)variableName AndIncludeMissing:(BOOL)includeMissing;
-(id)initWithSQLiteData:(SQLiteData *)dataSet AndWhereClause:(NSString *)whereClause AndVariable:(NSString *)variableName AndIncludeMissing:(BOOL)includeMissing;
@end
