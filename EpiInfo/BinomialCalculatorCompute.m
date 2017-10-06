//
//  BinomialCalculatorCompute.m
//  EpiInfo
//
//  Created by John Copeland on 10/25/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import "BinomialCalculatorCompute.h"
#import "SharedResources.h"
#include <math.h>

@implementation BinomialCalculatorCompute
-(void)Calculate:(int)n VariableX:(int)x VariableP:(double)p ProbabilityArray:(double[])probabilitiesAndLimits
{
    probabilitiesAndLimits[0] = 0.0;
    probabilitiesAndLimits[1] = 0.0;
    probabilitiesAndLimits[2] = [SharedResources chooseyforlep:(double)n chooseK:(double)x VariablePPP:p];
    probabilitiesAndLimits[3] = 0.0;
    probabilitiesAndLimits[4] = 0.0;
    probabilitiesAndLimits[5] = 0.0;
    
    NSMutableDictionary *args1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:n], @"n", [[NSNumber alloc] initWithInt:x], @"x", [[NSNumber alloc] initWithDouble:p], @"p", [[NSNumber alloc] initWithInt:1], @"ii", [[NSNumber alloc] initWithInt:x], @"iii", [[NSNumber alloc] initWithInt:-1], @"ck", nil];
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(threadedWork:) object:args1];
    
    NSMutableDictionary *args2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:n], @"n", [[NSNumber alloc] initWithInt:x], @"x", [[NSNumber alloc] initWithDouble:p], @"p", [[NSNumber alloc] initWithInt:0], @"ii", [[NSNumber alloc] initWithInt:x], @"iii", [[NSNumber alloc] initWithInt:-1], @"ck", nil];
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(threadedWork:) object:args2];
    
    NSMutableDictionary *args3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:n], @"n", [[NSNumber alloc] initWithInt:x], @"x", [[NSNumber alloc] initWithDouble:p], @"p", [[NSNumber alloc] initWithInt:0], @"ii", [[NSNumber alloc] initWithInt:n - x], @"iii", [[NSNumber alloc] initWithInt:1], @"ck", nil];
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(threadedWork:) object:args3];
    
    NSMutableDictionary *args4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:n], @"n", [[NSNumber alloc] initWithInt:x], @"x", [[NSNumber alloc] initWithDouble:p], @"p", [[NSNumber alloc] initWithInt:1], @"ii", [[NSNumber alloc] initWithInt:n - x], @"iii", [[NSNumber alloc] initWithInt:1], @"ck", nil];
    NSThread *thread4 = [[NSThread alloc] initWithTarget:self selector:@selector(threadedWork:) object:args4];

    [thread1 start];
    [thread2 start];
    [thread3 start];
    [thread4 start];

    while (![args4 objectForKey:@"ReturnV"])
    {
        
    }

    probabilitiesAndLimits[0] = [[args1 valueForKey:@"ReturnV"] doubleValue];
    probabilitiesAndLimits[1] = [[args2 valueForKey:@"ReturnV"] doubleValue];
    probabilitiesAndLimits[3] = [[args3 valueForKey:@"ReturnV"] doubleValue];
    probabilitiesAndLimits[4] = [[args4 valueForKey:@"ReturnV"] doubleValue];
    
    probabilitiesAndLimits[5] = MIN(2 * MIN(probabilitiesAndLimits[1], probabilitiesAndLimits[3]), 1.0);
}

-(void)CalculateMore:(int)n VariableX:(int)x VariableP:(double)p ProbabilityArray:(double[])probabilitiesAndLimits
{
    probabilitiesAndLimits[0] = 0.0;
    probabilitiesAndLimits[1] = (double)n;
    
    NSMutableDictionary *args1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:n], @"n", [[NSNumber alloc] initWithInt:x], @"x", nil];
    NSMutableDictionary *args2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:n], @"n", [[NSNumber alloc] initWithInt:x], @"x", nil];
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(calculateLowerLimit:) object:args1];
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(calculateUpperLimit:) object:args2];
    
    [thread1 start];
    [thread2 start];
    
//    NSDate *start = [NSDate date];
    
    while ([thread1 isExecuting] || [thread2 isExecuting])
    {
        if ([[NSThread currentThread] isCancelled])
        {
            [thread1 cancel];
            [thread2 cancel];
            [NSThread exit];
        }
        sleep(1);
    }
    
//    NSTimeInterval elapsed = -[start timeIntervalSinceNow];
//    NSLog(@"Time:  %g", elapsed);
    
    probabilitiesAndLimits[0] = [[args1 valueForKey:@"ReturnV"] doubleValue];
    probabilitiesAndLimits[1] = [[args2 valueForKey:@"ReturnV"] doubleValue];
}

- (void)calculateLowerLimit:(NSDictionary *)args
{
    int n = [[args valueForKey:@"n"] intValue];
    int x = [[args valueForKey:@"x"] intValue];
    double rv = 0.0;
    
    double pp = 0.0;
    double pvalue = 0.0;
    double LowerDesiredPValue = 0.025;
    if (x > 0)
    {
        while (ABS(pvalue - LowerDesiredPValue) > 0.0001)
        {
            pp += 0.00001;
            pvalue = [SharedResources ribetafunction:pp VariableAlpha:x VariableBeta:(n - x + 1)];
            if ([[NSThread currentThread] isCancelled])
                [NSThread exit];
        }
        rv = round(pp * n);
    }
    [args setValue:[[NSNumber alloc] initWithDouble:rv] forKey:@"ReturnV"];
}

- (double)calculateLowerLimit:(int)n VariableX:(int)x VariableP:(double)p
{
    double rv = 0.0;
    double a = 0.0;
    double b = 1.0;
    double pp = 0.0;
    double precision = 0.00001;
    
    @try {
        while (b - a > precision)
        {
            pp = (a + b) / 2.0;
            if ([SharedResources ribetafunction:pp VariableAlpha:x VariableBeta:(n - x + 1) UsesChoosey:YES] > 0.025)
                b = pp;
            else
                a = pp;
        }
        rv = round(pp * n);
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return rv;
}

- (double)calculateLowerLimit:(int)n VariableX:(int)x VariableP:(double)p BooleanParameter:(BOOL)bp
{
    double rv = 0.0;
    
    double pp = 0.0;
    double pvalue = 0.0;
    double LowerDesiredPValue = 0.025;
    if (x > 0)
    {
        while (ABS(pvalue - LowerDesiredPValue) > 0.0001)
        {
            pp += 0.00001;
            pvalue = [SharedResources ribetafunction:pp VariableAlpha:x VariableBeta:(n - x + 1) UsesChoosey:YES];
            if ([[NSThread currentThread] isCancelled])
                [NSThread exit];
        }
        rv = round(pp * n);
    }
    return rv;
}

- (void)calculateUpperLimit:(NSDictionary *)args
{
    int n = [[args valueForKey:@"n"] intValue];
    int x = [[args valueForKey:@"x"] intValue];
    double rv = (double)n;
    
    double pp = 1.0;
    double pvalue = 0.0;
    double UpperDesiredPValue = 0.975;
    if (x < n)
    {
        while (ABS(pvalue - UpperDesiredPValue) > 0.0001)
        {
            pp -= 0.00001;
            pvalue = [SharedResources ribetafunction:pp VariableAlpha:(x + 1) VariableBeta:(n - x)];
            if ([[NSThread currentThread] isCancelled])
                [NSThread exit];
        }
        rv = round(pp * n);
    }
    [args setValue:[[NSNumber alloc] initWithDouble:rv] forKey:@"ReturnV"];
}

- (double)calculateUpperLimit:(int)n VariableX:(int)x VariableP:(double)p
{
    double rv = (double)n;
    double a = 0.0;
    double b = 1.0;
    double pp = 0.0;
    double precision = 0.00001;

    @try {
        while (b - a > precision)
        {
            pp = (a + b) / 2.0;
            if ([SharedResources ribetafunction:pp VariableAlpha:(x + 1) VariableBeta:(n - x) UsesChoosey:YES] > 0.975)
                b = pp;
            else
                a = pp;
        }
        rv = round(pp * n);
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return  rv;
}

- (double)calculateUpperLimit:(int)n VariableX:(int)x VariableP:(double)p BooleanParameter:(BOOL)bp
{
    double rv = (double)n;
    
    double pp = 1.0;
    double pvalue = 0.0;
    double UpperDesiredPValue = 0.975;
    if (x < n)
    {
//        NSDate *start = [NSDate date];
        
        while (ABS(pvalue - UpperDesiredPValue) > 0.0001)
        {
            pp -= 0.00001;
            pvalue = [SharedResources ribetafunction:pp VariableAlpha:(x + 1) VariableBeta:(n - x) UsesChoosey:YES];
            if ([[NSThread currentThread] isCancelled])
                [NSThread exit];
//            NSLog(@"Upper limit executing");
        }
        
//        NSTimeInterval elapsed = -[start timeIntervalSinceNow];
//        NSLog(@"Time:  %g", elapsed);
        
        rv = round(pp * n);
    }
    return rv;
}

- (void)threadedWork:(NSDictionary *)args
{
    int n = [[args valueForKey:@"n"] intValue];
    int x = [[args valueForKey:@"x"] intValue];
    double p = [[args valueForKey:@"p"] doubleValue];
    int ii = [[args valueForKey:@"ii"] intValue];
    int iii = [[args valueForKey:@"iii"] intValue];
    int ck = [[args valueForKey:@"ck"] intValue];
    double rv = 0.0;
    for (int i = ii; i <= iii; i++)
        rv += [SharedResources chooseyforlep:(double)n chooseK:(double)(x + ck * i) VariablePPP:p];
    [args setValue:[[NSNumber alloc] initWithDouble:rv] forKey:@"ReturnV"];
}
@end
