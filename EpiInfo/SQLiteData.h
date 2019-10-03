//
//  SQLiteData.h
//  EpiInfo
//
//  Created by John Copeland on 8/12/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "AnalysisDataObject.h"
#import "sqlite3.h"

@interface SQLiteData : NSObject
{
    sqlite3 *analysisDB;
}

@property (nonatomic, strong) NSArray *columnNamesFull;
@property (nonatomic, strong) NSMutableArray *columnNamesWorking;
@property (nonatomic, strong) NSArray *dataTypesFull;
@property (nonatomic, strong) NSMutableArray *dataTypesWorking;
@property (nonatomic, strong) NSArray *isBinaryFull;
@property (nonatomic, strong) NSMutableArray *isBinaryWorking;
@property (nonatomic, strong) NSArray *isOneZeroFull;
@property (nonatomic, strong) NSMutableArray *isOneZeroWorking;
@property (nonatomic, strong) NSArray *isYesNoFull;
@property (nonatomic, strong) NSMutableArray *isYesNoWorking;
@property (nonatomic, strong) NSArray *isTrueFalseFull;
@property (nonatomic, strong) NSMutableArray *isTrueFalseWorking;
@property UIButton *databaseButton;

- (void)makeSQLiteFullTable:(AnalysisDataObject *)ado ProvideUpdatesTo:(UIButton *)button;
- (void)makeSQLiteWorkingTable;
- (void)makeSQLiteWorkingTableWithWhereClause:(NSString *)whereClause;
- (int)addColumnToWorkingTable:(NSString *)columnName ColumnType:(NSNumber *)columnType;
- (int)workingTableSize;
@end
