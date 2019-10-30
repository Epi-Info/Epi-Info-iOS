//
//  ConditionalAssignmentValuesView.h
//  EpiInfo
//
//  Created by John Copeland on 10/30/19.
//

#import "DataManagementView.h"
#import "EpiInfoTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConditionalAssignmentValuesView : DataManagementView
{
    EpiInfoTextView *filter;
}
-(void)setFilterText:(NSString *)filterText;
@end

NS_ASSUME_NONNULL_END
