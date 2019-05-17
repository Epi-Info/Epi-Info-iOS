//
//  IfText.h
//  EpiInfo
//
//  Created by John Copeland on 5/17/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IfText : UIView <UITextViewDelegate>
{
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    
    UITextView *textView;
    
    UITextView *destinationOfText;
}
-(id)initWithFrame:(CGRect)frame AndCallingButton:(UIButton *)cb;
-(void)setDestinationOfText:(UITextView *)dot;
-(void)setText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
