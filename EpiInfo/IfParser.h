#import <PEGKit/PKParser.h>
#import "DictionaryOfFields.h"
#import "EpiInfoControlProtocol.h"
#import "EnterDataView.h"

enum {
    IFPARSER_TOKEN_KIND_THENWORD = 14,
    IFPARSER_TOKEN_KIND_IFWORD,
    IFPARSER_TOKEN_KIND_ENDIF,
    IFPARSER_TOKEN_KIND_ELSEWORD,
};

@interface IfParser : PKParser
{
    bool truthState;
    bool elseing;
}
@property DictionaryOfFields *dictionaryOfFields;
@property NSDictionary *dictionaryOfPages;
@property UIViewController *rootViewController;
@end

