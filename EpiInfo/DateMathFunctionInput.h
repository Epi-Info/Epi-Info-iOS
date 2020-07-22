//
//  DateMathFunctionInput.h
//  EpiInfo
//
//  Created by John Copeland on 10/10/19.ights reserved.
//

#import "NewVariableInputs.h"

NS_ASSUME_NONNULL_BEGIN

@interface DateMathFunctionInput : NewVariableInputs
{
    UILabel *beginDateLabel;
    LegalValuesEnter *beginDateLVE;
    DateField *beginDateLiteral;
    UILabel *endDateLabel;
    LegalValuesEnter *endDateLVE;
    DateField *endDateLiteral;
}
@end

NS_ASSUME_NONNULL_END
