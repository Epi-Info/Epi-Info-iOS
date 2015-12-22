//
//  MirrorField.m
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//

#import "MirrorField.h"

@implementation MirrorField
@synthesize columnName = _columnName;
@synthesize sourceFieldID = _sourceFieldID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setEnabled:NO];
    }
    return self;
}

- (void)setFormFieldValue:(NSString *)formFieldValue
{
    if ([formFieldValue isEqualToString:@"(null)"])
        return;
    
    [self setText:formFieldValue];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
