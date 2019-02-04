//
//  LogisticObject.h
//  EpiInfo
//
//  Created by John Copeland on 10/16/18.
//

#import "TablesObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogisticObject : TablesObject
@property (nonatomic, strong) NSArray *exposureVariables;
@property (nonatomic, strong) NSString *matchVariable;
-(id)initWithSQLiteData:(SQLiteData *)dataSet AndWhereClause:(NSString * _Nullable)whereClause AndOutcomeVariable:(NSString *)outcomeVariable AndExposureVariables:(NSArray *)exposureVariables AndIncludeMissing:(BOOL)includeMissing;
@end

NS_ASSUME_NONNULL_END
