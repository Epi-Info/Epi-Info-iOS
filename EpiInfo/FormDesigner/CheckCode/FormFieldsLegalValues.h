//
//  FormFieldsLegalValues.h
//  EpiInfo
//
//  Created by John Copeland on 5/24/19.
//

#import "LegalValuesEnter.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormFieldsLegalValues : LegalValuesEnter
-(id)initWithFrame:(CGRect)frame AndFormDesigner:(UIView *)formDesigner AndTextFieldToUpdate:(UITextField *)tftu;
@end

NS_ASSUME_NONNULL_END
