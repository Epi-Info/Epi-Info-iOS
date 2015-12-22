//
//  MatchedPairCalculatorView.h
//  MatchedPairCalculator
//
//  Created by John Copeland on 10/1/12.
//

#import <UIKit/UIKit.h>

@interface MatchedPairCalculatorView : UIScrollView
@property (nonatomic) CGFloat scale;
-(void)pinch:(UIPinchGestureRecognizer *)gesture;
@end
