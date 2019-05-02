//
//  AssigningFunction.h
//  EpiInfo
//
//  Created by John Copeland on 5/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssigningFunction : UIView
{
    UIButton *callingButton;
    UIView *ccWriter;
    UILabel *titleLabel;
    UILabel *subtitleLabel;
}
-(id)initWithFrame:(CGRect)frame AndCallingButton:(UIButton *)cb;
@end

NS_ASSUME_NONNULL_END
