//
//  DictionaryOfFields.h
//  EpiInfo
//
//  Created by John Copeland on 11/2/16.
//

#import <Foundation/Foundation.h>
#import "FieldsAndStringValues.h"

@interface DictionaryOfFields : NSObject
@property NSMutableDictionary *nsmd;
@property FieldsAndStringValues *fasv;
-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
-(id)objectForKey:(id)aKey;
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  __unsafe_unretained [])buffer count:(NSUInteger)len;
@end
