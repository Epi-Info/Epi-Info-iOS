//
//  PageDots.m
//  EpiInfo
//
//  Created by John Copeland on 6/28/16.
//  Copyright © 2016 CDC. All rights reserved.
//

#import "PageDots.h"

@implementation PageDots

- (id)initWithNumberOfDots:(int)dots AndFooterFrame:(CGRect)footerframe
{
    float width = footerframe.size.width - 140.0;
    self = [super initWithFrame:CGRectMake(70, 0, width, 32.0)];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    dotFillColor = [UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0];
    
    float dotwidth = 8.0;
    float dotspace = dotwidth + 2.0;
    float cornerradius = dotwidth / 2.0;
    arrayOfDots = [[NSMutableArray alloc] init];
    
    int remainder = dots % 2;
    float startingX = self.frame.size.width / 2.0 - dotspace / 2.0;
    if (remainder == 0)
    {
        startingX = self.frame.size.width / 2.0 - (dots / 2) * dotspace + 1.0;
    }
    else
    {
        startingX -= ((dots - 1) / 2) * dotspace + 1.0;
    }
    
    for (int i = 0; i < dots; i++)
    {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(startingX, 4, dotwidth, dotwidth)];
        [dot.layer setCornerRadius:cornerradius];
        [dot.layer setBorderWidth:1.0];
        [dot.layer setBorderColor:dotFillColor.CGColor];
        [dot setBackgroundColor:[UIColor clearColor]];
        [self addSubview:dot];
        [arrayOfDots addObject:dot];
        startingX += dotspace;
    }
    
    pagenumber = 0;
    [(UIButton *)[arrayOfDots objectAtIndex:pagenumber] setBackgroundColor:dotFillColor];
    
    return self;
}

- (void)advancePage
{
    [(UIButton *)[arrayOfDots objectAtIndex:pagenumber] setBackgroundColor:[UIColor clearColor]];
    pagenumber++;
    [(UIButton *)[arrayOfDots objectAtIndex:pagenumber] setBackgroundColor:dotFillColor];
}
- (void)retreatPage
{
    [(UIButton *)[arrayOfDots objectAtIndex:pagenumber] setBackgroundColor:[UIColor clearColor]];
    pagenumber--;
    [(UIButton *)[arrayOfDots objectAtIndex:pagenumber] setBackgroundColor:dotFillColor];
}
- (void)resetToFirstPage
{
    [(UIButton *)[arrayOfDots objectAtIndex:pagenumber] setBackgroundColor:[UIColor clearColor]];
    pagenumber = 0;
    [(UIButton *)[arrayOfDots objectAtIndex:pagenumber] setBackgroundColor:dotFillColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
