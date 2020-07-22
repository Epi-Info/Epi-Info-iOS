//
//  CommandButton.h
//  EpiInfo
//
//  Created by John Copeland on 9/9/19.
//

#import "Checkbox.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommandButton : Checkbox
-(id)initWithFrame:(CGRect)frame AndPromptText:(NSString *)prompt;
@end

NS_ASSUME_NONNULL_END
