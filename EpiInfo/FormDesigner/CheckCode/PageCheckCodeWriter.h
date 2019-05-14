//
//  PageCheckCodeWriter.h
//  EpiInfo
//
//  Created by John Copeland on 5/14/19.
//

#import "CheckCodeWriter.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageCheckCodeWriter : CheckCodeWriter <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *pageNames;
    UIPickerView *pageNamePicker;
    NSString *pageNameSelected;
    NSUInteger pageNameSelectedIndex;
}
@end

NS_ASSUME_NONNULL_END
