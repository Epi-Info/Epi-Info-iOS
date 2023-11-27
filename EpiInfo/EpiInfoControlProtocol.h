//
//  EpiInfoControlProtocol.h
//  EpiInfo
//
//  Created by John Copeland on 4/11/16.
//

#import <Foundation/Foundation.h>

@protocol EpiInfoControlProtocol <NSObject>

@property NSString *columnName;
@property BOOL isReadOnly;

-(NSString *)epiInfoControlValue;
-(void)assignValue:(NSString *)value;
-(void)setIsEnabled:(BOOL)isEnabled;
-(void)setIsHidden:(BOOL)isHidden;
-(void)selfFocus;
-(void)reset;
-(void)resetDoNotEnable;

@end
