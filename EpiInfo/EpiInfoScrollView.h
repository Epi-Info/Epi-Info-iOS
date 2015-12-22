//
//  EpiInfoScrollView.h
//  EpiInfo
//
//  Created by John Copeland on 10/12/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface EpiInfoScrollView : UIScrollView
{
    NSMutableArray *Xs;
    NSMutableArray *Ys;
    NSMutableArray *Ws;
    NSMutableArray *Hs;
    CGFloat lastScale;
    CGPoint lastPoint;
    CGPoint point;
}
@property (nonatomic) CGFloat scale;
@property CGSize initialContentSize;
-(void)pinch:(UIPinchGestureRecognizer *)gesture;
-(void)initialInventoryOfSubviews;
@end
