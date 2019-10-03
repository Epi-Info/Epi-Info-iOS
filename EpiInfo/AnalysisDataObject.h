//
//  AnalysisDataObject.h
//  EpiInfo
//
//  Created by John Copeland on 6/24/13.
//

#import "sqlite3.h"
#import <Foundation/Foundation.h>

@interface AnalysisDataObject : NSObject
{
    sqlite3 *epiinfoDB;
    NSMutableString *whereClause;
}
@property (nonatomic, strong) NSMutableArray *listOfFilters;
@property (nonatomic, strong) NSDictionary *dataDefinitions;
@property (nonatomic, strong) NSDictionary *columnNames;
@property (nonatomic, strong) NSDictionary *dataTypes;
@property (nonatomic, strong) NSDictionary *isBinary;
@property (nonatomic, strong) NSDictionary *isOneZero;
@property (nonatomic, strong) NSDictionary *isYesNo;
@property (nonatomic, strong) NSDictionary *isTrueFalse;
@property (nonatomic, strong) NSArray *dataSet;

-(NSMutableString *)whereClause;
-(id)initWithAnalysisDataObject:(AnalysisDataObject *)analysisDataObject;
-(id)initWithAnalysisDataObject:(AnalysisDataObject *)analysisDataObject AndTableName:(NSString *)tableName AndFilters:(NSMutableArray *)filters;
-(id)initWithCSVFile:(NSString *)pathAndFileName;
-(id)initWithStoredDataTable:(NSString *)tableName;
-(id)initWithVariablesArray:(NSMutableArray *)variables AndDataArray:(NSMutableArray *)data;
@end
