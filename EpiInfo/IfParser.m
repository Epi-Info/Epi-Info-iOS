#import "IfParser.h"
#import "ExpressionActionParser.h"
#import "FullAssignStatementParser.h"
#import "AssignStatementParser.h"
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

@interface IfParser ()
@property (nonatomic, retain) NSMutableDictionary *statement_memo;
@property (nonatomic, retain) NSMutableDictionary *ifStatement_memo;
@property (nonatomic, retain) NSMutableDictionary *ifElseStatement_memo;
@property (nonatomic, retain) NSMutableDictionary *condition_memo;
@property (nonatomic, retain) NSMutableDictionary *ifWord_memo;
@property (nonatomic, retain) NSMutableDictionary *thenWord_memo;
@property (nonatomic, retain) NSMutableDictionary *elseWord_memo;
@property (nonatomic, retain) NSMutableDictionary *endIf_memo;
@end

@implementation IfParser
@synthesize dictionaryOfFields = _dictionaryOfFields;

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        truthState = NO;
        elseing = NO;
        self.startRuleName = @"statement";
        self.tokenKindTab[@"THEN"] = @(IFPARSER_TOKEN_KIND_THENWORD);
        self.tokenKindTab[@"IF"] = @(IFPARSER_TOKEN_KIND_IFWORD);
        self.tokenKindTab[@"END-IF"] = @(IFPARSER_TOKEN_KIND_ENDIF);
        self.tokenKindTab[@"ELSE"] = @(IFPARSER_TOKEN_KIND_ELSEWORD);

        self.tokenKindNameTab[IFPARSER_TOKEN_KIND_THENWORD] = @"THEN";
        self.tokenKindNameTab[IFPARSER_TOKEN_KIND_IFWORD] = @"IF";
        self.tokenKindNameTab[IFPARSER_TOKEN_KIND_ENDIF] = @"END-IF";
        self.tokenKindNameTab[IFPARSER_TOKEN_KIND_ELSEWORD] = @"ELSE";

        self.statement_memo = [NSMutableDictionary dictionary];
        self.ifStatement_memo = [NSMutableDictionary dictionary];
        self.ifElseStatement_memo = [NSMutableDictionary dictionary];
        self.condition_memo = [NSMutableDictionary dictionary];
        self.ifWord_memo = [NSMutableDictionary dictionary];
        self.thenWord_memo = [NSMutableDictionary dictionary];
        self.elseWord_memo = [NSMutableDictionary dictionary];
        self.endIf_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_clearMemo {
    [_statement_memo removeAllObjects];
    [_ifStatement_memo removeAllObjects];
    [_ifElseStatement_memo removeAllObjects];
    [_condition_memo removeAllObjects];
    [_ifWord_memo removeAllObjects];
    [_thenWord_memo removeAllObjects];
    [_elseWord_memo removeAllObjects];
    [_endIf_memo removeAllObjects];
}

- (void)start {
    [self statement_];
    [self matchEOF:YES]; 
}

- (void)__statement {
    
    if ([self speculate:^{ [self ifStatement_]; }]) {
        [self ifStatement_];
    } else if ([self speculate:^{ [self ifElseStatement_]; }]) {
        [self ifElseStatement_];
    } else if ([self speculate:^{ do {[self matchAny:NO]; } while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]);[self execute:(id)^{
        NSLog(@"Doing a statement 0");
        NSString *newStr;
        NSMutableString *nsms = [[NSMutableString alloc] init];
        while ((newStr = POP_STR()))
        {
            [nsms insertString:newStr atIndex:0];
        }
        NSLog(@"%@", nsms);
        NSLog(@"Finished doing a statement 0");
    }];
    }]) {
        do {
            [self matchAny:NO];
        } while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0] && !([LS(1) isEqualToString:@"END-IF"] || [LS(1) isEqualToString:@"ELSE"]));
        [self execute:(id)^{
            
            NSLog(@"Doing a statement 1");
            NSString *newStr;
            NSString *oldStr;
            NSMutableString *nsms = [[NSMutableString alloc] init];
            while ((newStr = POP_STR()))
            {
                [nsms insertString:newStr atIndex:0];
                oldStr = [NSString stringWithString:newStr];
            }
            [nsms insertString:@" " atIndex:oldStr.length];
            NSLog(@"Statement is: %@", nsms);
            NSLog(@"truthState is %@.", [self truthStateString]);
            NSLog(@"elseing is %@.", [self elseingString]);
            if ((truthState && !elseing) || (!truthState && elseing))
            {
                NSLog(@"Execute this statement");
                if ([oldStr isEqualToString:@"ASSIGN"])
                {
                    FullAssignStatementParser *fasParser = [[FullAssignStatementParser alloc] init];
                    NSError *err = nil;
                    PKAssembly *fasResult = [fasParser parseString:nsms error:&err];
                    if (fasResult)
                    {
                        NSString *assignInput = [fasResult pop];
                        AssignStatementParser *parser = [[AssignStatementParser alloc] init];
                        PKAssembly *result = [parser parseString:assignInput error:&err];
                        NSLog(@"Result is %@", [result pop]);
                    }
                }
            }
            else
                NSLog(@"Don't execute this statement");
            NSLog(@"Finished doing a statement 1");
            
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'statement'."];
    }
    
    [self fireDelegateSelector:@selector(parser:didMatchStatement:)];
}

- (void)statement_ {
    [self parseRule:@selector(__statement) withMemo:_statement_memo];
}

- (void)__ifStatement {
    
    [self ifWord_]; 
    [self condition_]; 
    [self statement_]; 
    [self endIf_]; 
    [self execute:(id)^{
    
        NSLog(@"Doing an ifStatement");
        NSString *newStr;
        NSMutableString *nsms = [[NSMutableString alloc] init];
        while ((newStr = POP_STR()))
        {
            [nsms insertString:newStr atIndex:0];
        }
        NSLog(@"Stack contains: %@", nsms);
        NSLog(@"Finished doing an IfStatement");

    }];

    [self fireDelegateSelector:@selector(parser:didMatchIfStatement:)];
}

- (void)ifStatement_ {
    [self parseRule:@selector(__ifStatement) withMemo:_ifStatement_memo];
}

- (void)__ifElseStatement {
    
    [self ifWord_]; 
    [self condition_]; 
    [self statement_]; 
    [self elseWord_]; 
    [self statement_]; 
    [self endIf_]; 
    [self execute:(id)^{
    
        NSLog(@"Doing an ifElseStatement");
        NSString *newStr;
        NSMutableString *nsms = [[NSMutableString alloc] init];
        while ((newStr = POP_STR()))
        {
            [nsms insertString:newStr atIndex:0];
        }
        NSLog(@"Stack contains: %@", nsms);
        NSLog(@"Finished doing an IfElseStatement");

    }];

    [self fireDelegateSelector:@selector(parser:didMatchIfElseStatement:)];
}

- (void)ifElseStatement_ {
    [self parseRule:@selector(__ifElseStatement) withMemo:_ifElseStatement_memo];
}

- (void)__condition {
    
    do {
        [self matchAny:NO]; 
    } while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0] && ![LS(1) isEqualToString:@"THEN"]);
    [self thenWord_]; 
    [self execute:(id)^{
    
        //NSLog(@"Doing a condition");
        NSString *newStr;
        NSMutableString *nsms = [[NSMutableString alloc] init];
        while ((newStr = POP_STR()))
        {
            if (!([newStr isEqualToString:@"IF"] || [newStr isEqualToString:@"THEN"] || [newStr isEqualToString:@"ELSE"] || [newStr isEqualToString:@"END-IF"]))
            {
                id field = [self.dictionaryOfFields objectForKey:newStr];
                if (field)
                    [nsms insertString:[field epiInfoControlValue] atIndex:0];
                else
                    [nsms insertString:newStr atIndex:0];
            }
        }
        //NSLog(@"Condition is: %@", nsms);
        ExpressionActionParser *eParser = [[ExpressionActionParser alloc] init];
        NSError *err = nil;
        PKAssembly *eResult = [eParser parseString:nsms error:&err];
        if (eResult)
        {
            bool truth;
            id nn = [eResult pop];
            if ([nn isKindOfClass:[NSString class]])
                truth = [nn boolValue];
            else
                truth = [[nn stringValue] boolValue];
            if (truth)
            {
                //NSLog(@"Condition is true");
            }
            else
            {
                //NSLog(@"Condition is false");
            }
            truthState = truth;
            //PUSH_BOOL(truth);
        }
        else
            NSLog(@"Could not evaluate condition");
        //NSLog(@"Finished doing a condition");

    }];

    [self fireDelegateSelector:@selector(parser:didMatchCondition:)];
}

- (void)condition_ {
    [self parseRule:@selector(__condition) withMemo:_condition_memo];
}

- (void)__ifWord {
    
    [self match:IFPARSER_TOKEN_KIND_IFWORD discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIfWord:)];
}

- (void)ifWord_ {
    [self parseRule:@selector(__ifWord) withMemo:_ifWord_memo];
}

- (void)__thenWord {
    
    [self match:IFPARSER_TOKEN_KIND_THENWORD discard:NO]; 
    [self execute:(id)^{
        
        NSLog(@"THEN. truthState = %@.", [self truthStateString]);
        
    }];

    [self fireDelegateSelector:@selector(parser:didMatchThenWord:)];
}

- (void)thenWord_ {
    [self parseRule:@selector(__thenWord) withMemo:_thenWord_memo];
}

- (void)__elseWord {
    
    [self match:IFPARSER_TOKEN_KIND_ELSEWORD discard:NO]; 
    [self execute:(id)^{
        
        NSLog(@"ELSE. truthState = %@.", [self truthStateString]);
        NSLog(@"Popping: %@", POP_STR());
        elseing = YES;
        
    }];

    [self fireDelegateSelector:@selector(parser:didMatchElseWord:)];
}

- (void)elseWord_ {
    [self parseRule:@selector(__elseWord) withMemo:_elseWord_memo];
}

- (void)__endIf {
    
    [self match:IFPARSER_TOKEN_KIND_ENDIF discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEndIf:)];
}

- (void)endIf_ {
    [self parseRule:@selector(__endIf) withMemo:_endIf_memo];
}

- (NSString *)truthStateString
{
    if (truthState)
        return @"True";
    return @"False";
}
- (NSString *)elseingString
{
    if (elseing)
        return @"True";
    return @"False";
}

@end
