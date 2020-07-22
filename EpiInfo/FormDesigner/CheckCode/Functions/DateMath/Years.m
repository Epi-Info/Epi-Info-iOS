//
//  Years.m
//  EpiInfo
//
//  Created by John Copeland on 5/1/19.
//

#import "Years.h"
#import "CheckCodeWriter.h"

@implementation Years

- (id)initWithFrame:(CGRect)frame AndCallingButton:(UIButton *)cb
{
    self = [super initWithFrame:frame AndCallingButton:cb];
    if (self)
    {
        [titleLabel setText:@"Assign Result of Years Function"];

        if (existingFunctions)
        {
            for (NSString *s in existingFunctionsArray)
            {
                if ([s containsString:@"YEARS"])
                {
                    [existingFunctionsButton setTag:93277];
                    [self addSubview:existingFunctionsButton];
                    break;
                }
            }
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
