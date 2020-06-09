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
    NSDictionary *dictionaryOfPages;
}
-(id)initWithFormName:(NSString *)fn AndDictionaryOfPages:(NSDictionary *)dop;
-(BOOL)sendAllRecordsToBox;
-(BOOL)retrieveAllRecordsFromBox;
@end

NS_ASSUME_NONNULL_END
