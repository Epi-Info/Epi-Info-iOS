//
//  BigDouble.m
//  EpiInfo
//
//  Created by John Copeland on 8/26/13.
//
//  A simple class for storing floating point
//  values that exceed the maximum size for a
//  double.  It stores the log10 of the value
//  and contains methods for arithmetic operations.
//

#import "BigDouble.h"

@implementation BigDouble
@synthesize logValue = _logValue;

-(id)initWithDouble:(double)doubleValue
{
    self = [super init];
    if (self)
    {
        self.logValue = log10(doubleValue);
    }
    return self;
}

-(id)initWithLogDouble:(double)logDouble
{
    self = [super init];
    if (self)
    {
        self.logValue = logDouble;
    }
    return self;
}

-(void)plus:(double)adder
{
    if (pow(10, [self logValue]) == 0)
    {
        [self setLogValue:log10(adder)];
        return;
    }
    double power = round([self logValue]);
    [self setLogValue:(power + log10(pow(10.0, [self logValue] - power) + pow(10.0, log10(adder) - power)))];
}

-(void)plusLog:(double)logAdder
{
    if (pow(10, [self logValue]) == 0)
    {
        [self setLogValue:logAdder];
        return;
    }
    double power = round([self logValue]);
    [self setLogValue:(power + log10(pow(10.0, [self logValue] - power) + pow(10.0, logAdder - power)))];
}

-(void)minus:(double)subtractor
{
}

-(void)times:(double)multiple
{
    self.logValue += log10(multiple);
}

-(double)timesReturn:(double)multiple
{
    return self.logValue + log10(multiple);
}

-(void)dividedBy:(double)divisor
{
    self.logValue -= log10(divisor);
}

-(double)doubleValue
{
    return pow(10.0, self.logValue);
}
@end
