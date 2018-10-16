#import "FullAssignStatementParser.h"
#import <PEGKit/PEGKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LD:(i)]

#define POP()        [self.assembly pop]
#define POP_STR()    [self popString]
#define POP_TOK()    [self popToken]
#define POP_BOOL()   [self popBool]
#define POP_INT()    [self popInteger]
#define POP_DOUBLE() [self popDouble]

#define PUSH(obj)      [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn)  [self pushBool:(BOOL)(yn)]
#define PUSH_INT(i)    [self pushInteger:(NSInteger)(i)]
#define PUSH_DOUBLE(d) [self pushDouble:(double)(d)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define MATCHES(pattern, str)               ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:0                                  error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)
#define MATCHES_IGNORE_CASE(pattern, str)   ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PKParser ()
//@property (nonatomic, retain) NSMutableDictionary *tokenKindTab;
//@property (nonatomic, retain) NSMutableArray *tokenKindNameTab;
//@property (nonatomic, retain) NSString *startRuleName;
//@property (nonatomic, retain) NSString *statementTerminator;
//@property (nonatomic, retain) NSString *singleLineCommentMarker;
//@property (nonatomic, retain) NSString *blockStartMarker;
//@property (nonatomic, retain) NSString *blockEndMarker;
//@property (nonatomic, retain) NSString *braces;

- (BOOL)popBool;
- (NSInteger)popInteger;
- (double)popDouble;
- (PKToken *)popToken;
- (NSString *)popString;

- (void)pushBool:(BOOL)yn;
- (void)pushInteger:(NSInteger)i;
- (void)pushDouble:(double)d;
@end

@interface FullAssignStatementParser ()
@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *variableName_memo;
@end

@implementation FullAssignStatementParser

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        self.startRuleName = @"expr";
        self.tokenKindTab[@"="] = @(FULLASSIGNSTATEMENTPARSER_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"_"] = @(FULLASSIGNSTATEMENTPARSER_TOKEN_KIND_UNDERSCORE);

        self.tokenKindNameTab[FULLASSIGNSTATEMENTPARSER_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[FULLASSIGNSTATEMENTPARSER_TOKEN_KIND_UNDERSCORE] = @"_";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.variableName_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_clearMemo {
    [_expr_memo removeAllObjects];
    [_variableName_memo removeAllObjects];
}

- (void)start {
    [self expr_]; 
    [self matchEOF:YES]; 
}

- (void)__expr {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"assign"); }]; 
    [self matchWord:YES]; 
    [self variableName_]; 
    [self match:FULLASSIGNSTATEMENTPARSER_TOKEN_KIND_EQUALS discard:YES]; 
    while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]) {
        [self matchAny:NO]; 
    }
    [self execute:(id)^{
    
        NSMutableString *rs = [[NSMutableString alloc] init];
        NSString *oldString;
        NSString *newString;
        // Won’t generate with this chunk
        // Remove it from this tool and re-add it to the generated code
        while ((newString = POP_STR()))
        {
            @try {
                [rs  insertString:newString atIndex:0];
                oldString = newString;
            } @catch (NSException *ex) {
                NSLog(@"%@", ex);
                break;
            } @finally {
                //
            }
        }
        // To here
        [rs replaceCharactersInRange:NSMakeRange(0, oldString.length) withString:@""];
        PUSH(oldString);
        PUSH(rs);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__variableName {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self matchWord:NO]; 
    } else if ([self predicts:FULLASSIGNSTATEMENTPARSER_TOKEN_KIND_UNDERSCORE, 0]) {
        while ([self predicts:FULLASSIGNSTATEMENTPARSER_TOKEN_KIND_UNDERSCORE, 0]) {
            [self match:FULLASSIGNSTATEMENTPARSER_TOKEN_KIND_UNDERSCORE discard:NO]; 
        }
        [self matchWord:NO]; 
        [self execute:(id)^{
        
        NSMutableString *rs = [[NSMutableString alloc] init];
        NSString *newString;
        // Won’t generate with this chunk
        // Remove it from this tool and re-add it to the generated code
            while ((newString = POP_STR()))
            {
                @try {
                    [rs  insertString:newString atIndex:0];
                } @catch (NSException *ex) {
                    NSLog(@"%@", ex);
                    break;
                } @finally {
                    //
                }
            }
        // To here
        PUSH(rs);

        }];
    } else {
        [self raise:@"No viable alternative found in rule 'variableName'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchVariableName:)];
}

- (void)variableName_ {
    [self parseRule:@selector(__variableName) withMemo:_variableName_memo];
}

@end
