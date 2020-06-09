//
//  BoxData.h
//  EpiInfo
//
//  Created by John Copeland on 6/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoxData : NSObject
{
    NSString *formName;
    BOOL notwo;
    
    NSDictionary *dictionaryOfControls;
    NSArray *arrayOfYesNoFieldNames;
}
-(id)initWithFormName:(NSString *)fn AndDictionaryOfPages:(NSDictionary *)dop AndNoTwo:(BOOL)no2;
-(BOOL)sendAllRecordsToBox;
-(BOOL)retrieveAllRecordsFromBox;
@end

NS_ASSUME_NONNULL_END
