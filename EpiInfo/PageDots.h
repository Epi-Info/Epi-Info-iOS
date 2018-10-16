//
//  PageDots.h
//  EpiInfo
//
//  Created by John Copeland on 6/28/16.
//  Copyright © 2016 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageDots : UIView
{
    int pagenumber;
    NSMutableArray *arrayOfDots;
    UIColor *dotFillColor;
}
-(id)initWithNumberOfDots:(int)dots AndFooterFrame:(CGRect)footerframe;
-(void)advancePage;
-(void)retreatPage;
-(void)resetToFirstPage;
-(void)setSpacificPage:(int)pg;
@end
