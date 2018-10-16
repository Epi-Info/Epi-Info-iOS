//
//  FieldsAndStringValues.h
//  EpiInfo
//
//  Created by John Copeland on 11/2/16.
//

#import <Foundation/Foundation.h>

@interface FieldsAndStringValues : NSObject
@property NSMutableDictionary *nsmd;
-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
-(id)objectForKey:(id)aKey;
@end
