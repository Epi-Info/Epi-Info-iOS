//
//  ConfirmDeleteButton.m
//  EpiInfo
//
//  Created by John Copeland on 8/6/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import "ConfirmDeleteButton.h"

@implementation ConfirmDeleteButton
@synthesize datasetToDelete = _datasetToDelete;
@synthesize buttonToRemove = _buttonToRemove;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
