//
//  ConditionalAssignmentValuesView.h
//  EpiInfo
//
//  Created by John Copeland on 10/30/19.
//

#import "NewVariableInputs.h"
#import "EpiInfoTextView.h"
#import "LegalValuesEnter.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConditionalAssignmentValuesView : NewVariableInputs
{
    EpiInfoTextView *filter;
    LegalValuesEnter *trueValueLVE;
    LegalValuesEnter *elseValueLVE;
}
-(void)setFilterText:(NSString *)filterText;
@end

NS_ASSUME_NONNULL_END
