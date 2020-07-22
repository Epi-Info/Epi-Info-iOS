//
//  EncryptionDecryptionKeys.h
//  EpiInfo
//
//  Created by John Copeland on 9/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EncryptionDecryptionKeys : NSObject
extern NSString *const INITVECTOR;
extern NSString *const PASSWORDSALT;
extern NSString *const LEGACYKEY;
@end

NS_ASSUME_NONNULL_END
