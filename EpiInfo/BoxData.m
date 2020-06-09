//
//  BoxData.m
//  EpiInfo
//
//  Created by John Copeland on 6/9/20.
//

#import "BoxData.h"

@implementation BoxData

- (id)initWithFormName:(NSString *)fn AndDictionaryOfPages:(NSDictionary *)dop
{
    self = [super init];
    if (self)
    {
        formName = fn;
        dictionaryOfPages = dop;
    }
    return self;
}

- (BOOL)sendAllRecordsToBox
{
    return YES;
}

- (BOOL)retrieveAllRecordsFromBox
{
    return YES;
}

@end
