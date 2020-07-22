//
//  Clear.m
//  EpiInfo
//
//  Created by John Copeland on 5/13/19.
//

#import "Clear.h"

@implementation Clear

- (id)initWithFrame:(CGRect)frame AndCallingButton:(UIButton *)cb
{
    self = [super initWithFrame:frame AndCallingButton:cb];
    if (self)
    {
        [titleLabel setText:@"Clear Field"];
        
        if (existingFunctions)
        {
            for (NSString *s in existingFunctionsArray)
            {
                if ([s containsString:@"CLEAR"])
                {
                    [existingFunctionsButton setTag:25327];
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
        NSString *assignStatement = [NSString stringWithFormat:@"CLEAR %@", fieldToClear];
        NSLog(@"%@", assignStatement);
        if ([callingButton.layer valueForKey:@"BeforeAfter"])
        {
            NSString *ba = [callingButton.layer valueForKey:@"BeforeAfter"];
            if ([ba isEqualToString:@"After"])
            {
                [self addAfterFunction:assignStatement];
            }
            else if ([ba isEqualToString:@"Before"])
            {
                [self addBeforeFunction:assignStatement];
            }
            else if ([ba isEqualToString:@"Click"])
            {
                [self addClickFunction:assignStatement];
            }
        }

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
