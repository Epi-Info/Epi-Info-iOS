//
//  FeedbackView.m
//  EpiInfo
//
//  Created by John Copeland on 12/15/15.
//  Copyright © 2015 John Copeland. All rights reserved.
//

#import "FeedbackView.h"

@implementation FeedbackView
@synthesize percentLabel = _percentLabel;
@synthesize totalRecords = _totalRecords;
-(void)setTag:(NSInteger)tag
{
  [super setTag:tag];
  NSThread *labelThread = [[NSThread alloc] initWithTarget:self selector:@selector(labelThreadMethod) object:nil];
  [labelThread start];
}
-(void)labelThreadMethod
{
  [self.percentLabel setText:[NSString stringWithFormat:@"Writing record %ld of %d.", (long)[self tag], self.totalRecords]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
