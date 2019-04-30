//
//  CheckCodeWriter.h
//  EpiInfo
//
//  Created by John Copeland on 4/29/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckCodeWriter : UIView
-(id)initWithFrame:(CGRect)frame AndFieldName:(NSString *)fn AndFieldType:(NSString *)ft;
@end

NS_ASSUME_NONNULL_END
