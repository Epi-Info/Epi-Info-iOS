//
//  TablesObject.h
//  EpiInfo
//
//  Created by labuser on 7/1/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalysisDataObject.h"
#import "SQLiteData.h"
#import "sqlite3.h"

@interface TablesObject : NSObject
{
    sqlite3 *analysisDB;
}

@property (nonatomic, strong) NSString *exposureVariable;
@property (nonatomic, strong) NSString *outcomeVariable;
@property (nonatomic, strong) NSArray *exposureValues;
@property (nonatomic, strong) NSArray *outcomeValues;
@property (nonatomic, strong) NSArray *cellCounts;

-(id)initWithAnalysisDataObject:(AnalysisDataObject *)dataSet AndOutcomeVariable:(NSString *)outcomeVariable AndExposureVariable:(NSString *)exposureVariable AndIncludeMissing:(BOOL)includeMissing;
-(id)initWithSQLiteData:(SQLiteData *)dataSet AndWhereClause:(NSString *)whereClause AndOutcomeVariable:(NSString *)outcomeVariable AndExposureVariable:(NSString *)exposureVariable AndIncludeMissing:(BOOL)includeMissing;
@end
