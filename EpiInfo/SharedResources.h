//
//  SharedResources.h
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedResources : NSObject
+(double)choosey:(double)chooa chooseK:(double)choob;
+(double)chooseyforbeta:(double)chooa chooseK:(double)choob P:(double)p J:(int)j;
+(double)chooseyforlep:(double)chooa chooseK:(double)choob VariablePPP:(double)ppp;
+(double)pFromZ:(double)_z;
+(double)zFromP:(double)_p;
+(double)pFromT:(double)_t DegreesOfFreedom:(int)_df;
+(double)pFromF:(double)F DegreesOfFreedom1:(double)df1 DegreesOfFreedom2:(double)df2;
+(double)PValFromChiSq:(double)x PVFCSdf:(double)df;
+(double)ANorm:(double)p;
+(double)Norm:(double)z;
+(double)ribetafunction:(double)p VariableAlpha:(int)alpha VariableBeta:(int)beta;
+(double)ribetafunction:(double)p VariableAlpha:(int)alpha VariableBeta:(int)beta UsesChoosey:(BOOL)yn;
+(double)TfromP:(double)pdblProportion AndDF:(short)pintDF;
+(NSArray *)sortArrayOfArrays:(NSArray *)inArray onIndex:(int)idx;
@end
