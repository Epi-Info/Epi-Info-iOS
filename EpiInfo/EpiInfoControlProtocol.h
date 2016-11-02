//
//  EpiInfoControlProtocol.h
//  EpiInfo
//
//  Created by John Copeland on 4/11/16.
//

#import <Foundation/Foundation.h>

@protocol EpiInfoControlProtocol <NSObject>

- (NSString *)epiInfoControlValue;
- (void)assignValue:(NSString *)value;

@end
