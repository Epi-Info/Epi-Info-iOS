//
//  EpiInfoCodesField.h
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//

#import "LegalValuesEnter.h"
#import "DictionaryOfFields.h"
#import "EpiInfoControlProtocol.h"

@interface EpiInfoCodesField : LegalValuesEnter
{
    NSMutableDictionary *linkedFields;
}
@property NSString *textColumnName;
@property UITextField *textColumnField;
@property NSMutableArray *textColumnValues;
- (id)initWithFrame:(CGRect)frame AndDictionaryOfCodes:(NSMutableDictionary *)doc AndFieldName:(NSString *)fn;
@end
