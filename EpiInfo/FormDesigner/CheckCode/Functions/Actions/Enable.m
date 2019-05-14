//
//  Enable.m
//  EpiInfo
//
//  Created by John Copeland on 5/13/19.
//

#import "Enable.h"

@implementation Enable

- (id)initWithFrame:(CGRect)frame AndCallingButton:(UIButton *)cb
{
    self = [super initWithFrame:frame AndCallingButton:cb];
    if (self)
    {
        [titleLabel setText:@"Enable Field"];
        
        if (existingFunctions)
        {
            for (NSString *s in existingFunctionsArray)
            {
                if ([s containsString:@"ENABLE"])
                {
                    [existingFunctionsButton setTag:362253];
                    [self addSubview:existingFunctionsButton];
                    break;
                }
            }
        }
    }
    return self;
}

- (void)closeButtonPressed:(UIButton *)sender
{
    NSString *fieldToClear = [fieldToAffectSelected text];
    
    [super closeButtonPressed:sender];
    
    if ([[[sender titleLabel] text] isEqualToString:@"Cancel"])
    {
        if (functionBeingEdited != nil)
            if ([functionBeingEdited length] > 0)
                if (![existingFunctionsArray containsObject:functionBeingEdited])
                    [existingFunctionsArray addObject:functionBeingEdited];
        return;
    }
    else if ([[[sender titleLabel] text] isEqualToString:@"Delete"])
    {
        return;
    }
    
    if ([fieldToClear length] > 0)
    {
        NSString *assignStatement = [NSString stringWithFormat:@"ENABLE %@", fieldToClear];
        NSLog(@"%@", assignStatement);
        [self addAfterFunction:assignStatement];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
