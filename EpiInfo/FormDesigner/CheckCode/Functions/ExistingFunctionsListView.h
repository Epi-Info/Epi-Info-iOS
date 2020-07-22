//
//  ExistingFunctionsListView.h
//  EpiInfo
//
//  Created by John Copeland on 5/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExistingFunctionsListView : UIView
{
    UIView *assigningFunction;
}
-(id)initWithFrame:(CGRect)frame AndFunctionsArray:(NSMutableArray *)functionsArray AndSender:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
