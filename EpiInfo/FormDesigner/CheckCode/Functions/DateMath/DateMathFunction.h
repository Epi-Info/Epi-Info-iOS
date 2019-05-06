//
//  DateMathFunction.h
//  EpiInfo
//
//  Created by John Copeland on 5/2/19.
//

#import "AssigningFunction.h"
#import "DateField.h"

NS_ASSUME_NONNULL_BEGIN

@interface DateMathFunction : AssigningFunction
{
    UILabel *beginDateLabel;
    LegalValuesEnter *beginDate;
    UITextField *beginDateSelected;
    UILabel *beginDateLiteralLabel;
    DateField *beginDateLiteral;
}
@end

NS_ASSUME_NONNULL_END
