//
//  BlurryView.m
//  EpiInfo
//
//  Created by John Copeland on 10/25/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "BlurryView.h"
#import <QuartzCore/QuartzCore.h>

@interface BlurryView ()
@property (nonatomic, strong) UIToolbar *toolBar;
@end

@implementation BlurryView
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return  self;
}

- (void)setup
{
    [self setClipsToBounds:YES];
    
    if (![self toolBar])
    {
        [self setToolBar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
        [self.layer insertSublayer:[self.toolBar layer] atIndex:0];
    }
}

- (void)setBlurTintColor:(UIColor *)blurTintColor
{
    [self.toolBar setBarTintColor:blurTintColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.toolBar setFrame:[self bounds]];
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
