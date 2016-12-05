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

@interface AssignStatementParser ()
@property (nonatomic, retain) NSMutableDictionary *allexpr_memo;
@property (nonatomic, retain) NSMutableDictionary *concatenationArgument_memo;
@property (nonatomic, retain) NSMutableDictionary *concantenateFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *addExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *multExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *caretExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *datemathExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *daysmathExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *monthsmathExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *yearsmathExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *dateValue_memo;
@property (nonatomic, retain) NSMutableDictionary *dateLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *sysdateExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *mdyExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *dmyExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *absFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *roundingFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *roundFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *rndFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *trigFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *sineFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *cosineFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *tangentFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *piFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *inverseFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *function_memo;
@property (nonatomic, retain) NSMutableDictionary *textReturningFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *uppercaseExpression_memo;
@property (nonatomic, retain) NSMutableDictionary *quotedString_memo;
@property (nonatomic, retain) NSMutableDictionary *numberReturningFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *datereturningfunction_memo;
@property (nonatomic, retain) NSMutableDictionary *arithmeticFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *primary_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@end

@implementation AssignStatementParser

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        self.startRuleName = @"allexpr";
        self.tokenKindTab[@"*"] = @(ASSIGNSTATEMENT_TOKEN_KIND_STAR);
        self.tokenKindTab[@"&"] = @(ASSIGNSTATEMENT_TOKEN_KIND_AMPERSAND);
        self.tokenKindTab[@"/"] = @(ASSIGNSTATEMENT_TOKEN_KIND_FORWARD_SLASH);
        self.tokenKindTab[@"+"] = @(ASSIGNSTATEMENT_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"^"] = @(ASSIGNSTATEMENT_TOKEN_KIND_CARET);
        self.tokenKindTab[@","] = @(ASSIGNSTATEMENT_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"("] = @(ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"-"] = @(ASSIGNSTATEMENT_TOKEN_KIND_MINUS);
        self.tokenKindTab[@")"] = @(ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"%"] = @(ASSIGNSTATEMENT_TOKEN_KIND_PERCENT);

        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_STAR] = @"*";
        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_AMPERSAND] = @"&";
        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_FORWARD_SLASH] = @"/";
        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_CARET] = @"^";
        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[ASSIGNSTATEMENT_TOKEN_KIND_PERCENT] = @"%";

        self.allexpr_memo = [NSMutableDictionary dictionary];
        self.concatenationArgument_memo = [NSMutableDictionary dictionary];
        self.concantenateFunction_memo = [NSMutableDictionary dictionary];
        self.expr_memo = [NSMutableDictionary dictionary];
        self.addExpr_memo = [NSMutableDictionary dictionary];
        self.multExpr_memo = [NSMutableDictionary dictionary];
        self.caretExpr_memo = [NSMutableDictionary dictionary];
        self.datemathExpr_memo = [NSMutableDictionary dictionary];
        self.daysmathExpr_memo = [NSMutableDictionary dictionary];
        self.monthsmathExpr_memo = [NSMutableDictionary dictionary];
        self.yearsmathExpr_memo = [NSMutableDictionary dictionary];
        self.dateValue_memo = [NSMutableDictionary dictionary];
        self.dateLiteral_memo = [NSMutableDictionary dictionary];
        self.sysdateExpr_memo = [NSMutableDictionary dictionary];
        self.mdyExpr_memo = [NSMutableDictionary dictionary];
        self.dmyExpr_memo = [NSMutableDictionary dictionary];
        self.absFunction_memo = [NSMutableDictionary dictionary];
        self.roundingFunction_memo = [NSMutableDictionary dictionary];
        self.roundFunction_memo = [NSMutableDictionary dictionary];
        self.rndFunction_memo = [NSMutableDictionary dictionary];
        self.trigFunction_memo = [NSMutableDictionary dictionary];
        self.sineFunction_memo = [NSMutableDictionary dictionary];
        self.cosineFunction_memo = [NSMutableDictionary dictionary];
        self.tangentFunction_memo = [NSMutableDictionary dictionary];
        self.piFunction_memo = [NSMutableDictionary dictionary];
        self.inverseFunction_memo = [NSMutableDictionary dictionary];
        self.function_memo = [NSMutableDictionary dictionary];
        self.textReturningFunction_memo = [NSMutableDictionary dictionary];
        self.uppercaseExpression_memo = [NSMutableDictionary dictionary];
        self.quotedString_memo = [NSMutableDictionary dictionary];
        self.numberReturningFunction_memo = [NSMutableDictionary dictionary];
        self.datereturningfunction_memo = [NSMutableDictionary dictionary];
        self.arithmeticFunction_memo = [NSMutableDictionary dictionary];
        self.primary_memo = [NSMutableDictionary dictionary];
        self.atom_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_clearMemo {
    [_allexpr_memo removeAllObjects];
    [_concatenationArgument_memo removeAllObjects];
    [_concantenateFunction_memo removeAllObjects];
    [_expr_memo removeAllObjects];
    [_addExpr_memo removeAllObjects];
    [_multExpr_memo removeAllObjects];
    [_caretExpr_memo removeAllObjects];
    [_datemathExpr_memo removeAllObjects];
    [_daysmathExpr_memo removeAllObjects];
    [_monthsmathExpr_memo removeAllObjects];
    [_yearsmathExpr_memo removeAllObjects];
    [_dateValue_memo removeAllObjects];
    [_dateLiteral_memo removeAllObjects];
    [_sysdateExpr_memo removeAllObjects];
    [_mdyExpr_memo removeAllObjects];
    [_dmyExpr_memo removeAllObjects];
    [_absFunction_memo removeAllObjects];
    [_roundingFunction_memo removeAllObjects];
    [_roundFunction_memo removeAllObjects];
    [_rndFunction_memo removeAllObjects];
    [_trigFunction_memo removeAllObjects];
    [_sineFunction_memo removeAllObjects];
    [_cosineFunction_memo removeAllObjects];
    [_tangentFunction_memo removeAllObjects];
    [_piFunction_memo removeAllObjects];
    [_inverseFunction_memo removeAllObjects];
    [_function_memo removeAllObjects];
    [_textReturningFunction_memo removeAllObjects];
    [_uppercaseExpression_memo removeAllObjects];
    [_quotedString_memo removeAllObjects];
    [_numberReturningFunction_memo removeAllObjects];
    [_datereturningfunction_memo removeAllObjects];
    [_arithmeticFunction_memo removeAllObjects];
    [_primary_memo removeAllObjects];
    [_atom_memo removeAllObjects];
}

- (void)start {
    [self allexpr_]; 
    [self matchEOF:YES]; 
}

- (void)__allexpr {
    
    if ([self speculate:^{ [self dateLiteral_]; }]) {
        [self dateLiteral_]; 
    } else if ([self speculate:^{ [self concantenateFunction_]; }]) {
        [self concantenateFunction_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'allexpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAllexpr:)];
}

- (void)allexpr_ {
    [self parseRule:@selector(__allexpr) withMemo:_allexpr_memo];
}

- (void)__concatenationArgument {
    
    if ([self speculate:^{ [self expr_]; }]) {
        [self expr_]; 
    } else if ([self speculate:^{ [self dateValue_]; }]) {
        [self dateValue_]; 
    } else if ([self speculate:^{ [self textReturningFunction_]; }]) {
        [self textReturningFunction_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'concatenationArgument'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchConcatenationArgument:)];
}

- (void)concatenationArgument_ {
    [self parseRule:@selector(__concatenationArgument) withMemo:_concatenationArgument_memo];
}

- (void)__concantenateFunction {
    
    [self concatenationArgument_]; 
    while ([self speculate:^{ [self match:ASSIGNSTATEMENT_TOKEN_KIND_AMPERSAND discard:YES]; [self concatenationArgument_]; }]) {
        [self match:ASSIGNSTATEMENT_TOKEN_KIND_AMPERSAND discard:YES]; 
        [self concatenationArgument_]; 
        [self execute:(id)^{
         
	NSString *secondWord = POP_STR();
	NSString *firstWord = POP_STR();
	NSString *concatString = [NSString stringWithFormat:@"%@%@", firstWord, secondWord];
    PUSH(concatString);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchConcantenateFunction:)];
}

- (void)concantenateFunction_ {
    [self parseRule:@selector(__concantenateFunction) withMemo:_concantenateFunction_memo];
}

- (void)__expr {
    
    [self addExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__addExpr {
    
    [self multExpr_]; 
    while ([self speculate:^{ if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_PLUS, 0]) {[self match:ASSIGNSTATEMENT_TOKEN_KIND_PLUS discard:NO]; } else if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_MINUS, 0]) {[self match:ASSIGNSTATEMENT_TOKEN_KIND_MINUS discard:NO]; } else {[self raise:@"No viable alternative found in rule 'addExpr'."];}[self multExpr_]; }]) {
        if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_PLUS, 0]) {
            [self match:ASSIGNSTATEMENT_TOKEN_KIND_PLUS discard:NO]; 
        } else if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_MINUS, 0]) {
            [self match:ASSIGNSTATEMENT_TOKEN_KIND_MINUS discard:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'addExpr'."];
        }
        [self multExpr_]; 
        [self execute:(id)^{
        
	double secondDouble = POP_DOUBLE();
	char operator = [POP_STR() characterAtIndex:0];
	double firstDouble = POP_DOUBLE();

	if (operator == '+')
		PUSH_DOUBLE(firstDouble + secondDouble);
	else
		PUSH_DOUBLE(firstDouble - secondDouble);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAddExpr:)];
}

- (void)addExpr_ {
    [self parseRule:@selector(__addExpr) withMemo:_addExpr_memo];
}

- (void)__multExpr {
    
    [self caretExpr_]; 
    while ([self speculate:^{ if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_STAR, 0]) {[self match:ASSIGNSTATEMENT_TOKEN_KIND_STAR discard:NO]; } else if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_FORWARD_SLASH, 0]) {[self match:ASSIGNSTATEMENT_TOKEN_KIND_FORWARD_SLASH discard:NO]; } else if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_PERCENT, 0]) {[self match:ASSIGNSTATEMENT_TOKEN_KIND_PERCENT discard:NO]; } else {[self raise:@"No viable alternative found in rule 'multExpr'."];}[self caretExpr_]; }]) {
        if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_STAR, 0]) {
            [self match:ASSIGNSTATEMENT_TOKEN_KIND_STAR discard:NO]; 
        } else if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_FORWARD_SLASH, 0]) {
            [self match:ASSIGNSTATEMENT_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
        } else if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_PERCENT, 0]) {
            [self match:ASSIGNSTATEMENT_TOKEN_KIND_PERCENT discard:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'multExpr'."];
        }
        [self caretExpr_]; 
        [self execute:(id)^{
         
	double secondDouble = POP_DOUBLE();
	char operator = [POP_STR() characterAtIndex:0];
	double firstDouble = POP_DOUBLE();

	if (operator == '*')
		PUSH_DOUBLE(firstDouble * secondDouble);
	else if (operator == '/')
		PUSH_DOUBLE(firstDouble / secondDouble);
	else
		PUSH_DOUBLE((double)((int)firstDouble % (int)secondDouble));

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultExpr:)];
}

- (void)multExpr_ {
    [self parseRule:@selector(__multExpr) withMemo:_multExpr_memo];
}

- (void)__caretExpr {
    
    [self numberReturningFunction_]; 
    while ([self speculate:^{ [self match:ASSIGNSTATEMENT_TOKEN_KIND_CARET discard:YES]; [self numberReturningFunction_]; }]) {
        [self match:ASSIGNSTATEMENT_TOKEN_KIND_CARET discard:YES]; 
        [self numberReturningFunction_]; 
        [self execute:(id)^{
         
	double a = POP_DOUBLE();
    PUSH_DOUBLE(pow(POP_DOUBLE(), a));

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchCaretExpr:)];
}

- (void)caretExpr_ {
    [self parseRule:@selector(__caretExpr) withMemo:_caretExpr_memo];
}

- (void)__datemathExpr {
    
    if ([self speculate:^{ [self daysmathExpr_]; }]) {
        [self daysmathExpr_]; 
    } else if ([self speculate:^{ [self monthsmathExpr_]; }]) {
        [self monthsmathExpr_]; 
    } else if ([self speculate:^{ [self yearsmathExpr_]; }]) {
        [self yearsmathExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'datemathExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchDatemathExpr:)];
}

- (void)datemathExpr_ {
    [self parseRule:@selector(__datemathExpr) withMemo:_datemathExpr_memo];
}

- (void)__daysmathExpr {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"days"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self dateValue_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_COMMA discard:YES]; 
    [self dateValue_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
        NSString *endDateString = POP_STR();
        NSString *beginDateString = POP_STR();
        
        int firstSlash1 = (int)[beginDateString rangeOfString:@"/"].location;
        int secondSlash1 = (int)[[beginDateString substringFromIndex:firstSlash1 + 1] rangeOfString:@"/"].location + firstSlash1 + 1;
        int firstSlash2 = (int)[endDateString rangeOfString:@"/"].location;
        int secondSlash2 = (int)[[endDateString substringFromIndex:firstSlash2 + 1] rangeOfString:@"/"].location + firstSlash2 + 1;

        NSDateComponents *beginComponents = [[NSDateComponents alloc] init];
        [beginComponents setDay:[[beginDateString substringWithRange:NSMakeRange(firstSlash1 + 1, secondSlash1 - firstSlash1 - 1)] intValue]];
        [beginComponents setMonth:[[beginDateString substringToIndex:firstSlash1] intValue]];
        [beginComponents setYear:[[beginDateString substringFromIndex:secondSlash1 + 1] intValue]];

        NSDateComponents *endComponents = [[NSDateComponents alloc] init];
        [endComponents setDay:[[endDateString substringWithRange:NSMakeRange(firstSlash2 + 1, secondSlash2 - firstSlash2 - 1)] intValue]];
        [endComponents setMonth:[[endDateString substringToIndex:firstSlash2] intValue]];
        [endComponents setYear:[[endDateString substringFromIndex:secondSlash2 + 1] intValue]];
        
        NSDate *beginDate = [[NSCalendar currentCalendar] dateFromComponents:beginComponents];
        NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endComponents];
        
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:beginDate toDate:endDate options:0];
        PUSH_DOUBLE([difference day]);
        
        endDateString = [NSString stringWithFormat:@"%d/%d/%d", 3, 3, 1970];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchDaysmathExpr:)];
}

- (void)daysmathExpr_ {
    [self parseRule:@selector(__daysmathExpr) withMemo:_daysmathExpr_memo];
}

- (void)__monthsmathExpr {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"months"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self dateValue_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_COMMA discard:YES]; 
    [self dateValue_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
        NSString *endDateString = POP_STR();
        NSString *beginDateString = POP_STR();
        
        int firstSlash1 = (int)[beginDateString rangeOfString:@"/"].location;
        int secondSlash1 = (int)[[beginDateString substringFromIndex:firstSlash1 + 1] rangeOfString:@"/"].location + firstSlash1 + 1;
        int firstSlash2 = (int)[endDateString rangeOfString:@"/"].location;
        int secondSlash2 = (int)[[endDateString substringFromIndex:firstSlash2 + 1] rangeOfString:@"/"].location + firstSlash2 + 1;

        NSDateComponents *beginComponents = [[NSDateComponents alloc] init];
        [beginComponents setDay:[[beginDateString substringWithRange:NSMakeRange(firstSlash1 + 1, secondSlash1 - firstSlash1 - 1)] intValue]];
        [beginComponents setMonth:[[beginDateString substringToIndex:firstSlash1] intValue]];
        [beginComponents setYear:[[beginDateString substringFromIndex:secondSlash1 + 1] intValue]];

        NSDateComponents *endComponents = [[NSDateComponents alloc] init];
        [endComponents setDay:[[endDateString substringWithRange:NSMakeRange(firstSlash2 + 1, secondSlash2 - firstSlash2 - 1)] intValue]];
        [endComponents setMonth:[[endDateString substringToIndex:firstSlash2] intValue]];
        [endComponents setYear:[[endDateString substringFromIndex:secondSlash2 + 1] intValue]];
        
        NSDate *beginDate = [[NSCalendar currentCalendar] dateFromComponents:beginComponents];
        NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endComponents];
        
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:beginDate toDate:endDate options:0];
        PUSH_DOUBLE([difference month]);
        
        endDateString = [NSString stringWithFormat:@"%d/%d/%d", 3, 3, 1970];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchMonthsmathExpr:)];
}

- (void)monthsmathExpr_ {
    [self parseRule:@selector(__monthsmathExpr) withMemo:_monthsmathExpr_memo];
}

- (void)__yearsmathExpr {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"years"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self dateValue_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_COMMA discard:YES]; 
    [self dateValue_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
        NSString *endDateString = POP_STR();
        NSString *beginDateString = POP_STR();
        
        int firstSlash1 = (int)[beginDateString rangeOfString:@"/"].location;
        int secondSlash1 = (int)[[beginDateString substringFromIndex:firstSlash1 + 1] rangeOfString:@"/"].location + firstSlash1 + 1;
        int firstSlash2 = (int)[endDateString rangeOfString:@"/"].location;
        int secondSlash2 = (int)[[endDateString substringFromIndex:firstSlash2 + 1] rangeOfString:@"/"].location + firstSlash2 + 1;

        NSDateComponents *beginComponents = [[NSDateComponents alloc] init];
        [beginComponents setDay:[[beginDateString substringWithRange:NSMakeRange(firstSlash1 + 1, secondSlash1 - firstSlash1 - 1)] intValue]];
        [beginComponents setMonth:[[beginDateString substringToIndex:firstSlash1] intValue]];
        [beginComponents setYear:[[beginDateString substringFromIndex:secondSlash1 + 1] intValue]];

        NSDateComponents *endComponents = [[NSDateComponents alloc] init];
        [endComponents setDay:[[endDateString substringWithRange:NSMakeRange(firstSlash2 + 1, secondSlash2 - firstSlash2 - 1)] intValue]];
        [endComponents setMonth:[[endDateString substringToIndex:firstSlash2] intValue]];
        [endComponents setYear:[[endDateString substringFromIndex:secondSlash2 + 1] intValue]];
        
        NSDate *beginDate = [[NSCalendar currentCalendar] dateFromComponents:beginComponents];
        NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endComponents];
        
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:beginDate toDate:endDate options:0];
        PUSH_DOUBLE([difference year]);
        
        endDateString = [NSString stringWithFormat:@"%d/%d/%d", 3, 3, 1970];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchYearsmathExpr:)];
}

- (void)yearsmathExpr_ {
    [self parseRule:@selector(__yearsmathExpr) withMemo:_yearsmathExpr_memo];
}

- (void)__dateValue {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self dateLiteral_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self datereturningfunction_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'dateValue'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchDateValue:)];
}

- (void)dateValue_ {
    [self parseRule:@selector(__dateValue) withMemo:_dateValue_memo];
}

- (void)__dateLiteral {
    
    [self matchNumber:NO]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_FORWARD_SLASH discard:YES]; 
    [self matchNumber:NO]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_FORWARD_SLASH discard:YES]; 
    [self matchNumber:NO]; 
    [self execute:(id)^{
    
	int year = (int)POP_DOUBLE();
	int day = (int)POP_DOUBLE();
	int month = (int)POP_DOUBLE();
	NSString *stringDate = [NSString stringWithFormat:@"%d/%d/%d", month, day, year];
	PUSH(stringDate);
	stringDate = [NSString stringWithFormat:@"%d/%d/%d", 3, 3, 1970];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchDateLiteral:)];
}

- (void)dateLiteral_ {
    [self parseRule:@selector(__dateLiteral) withMemo:_dateLiteral_memo];
}

- (void)__sysdateExpr {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"systemdate"); }]; 
    [self matchWord:YES]; 
    [self execute:(id)^{
    
        int todayday = (int)[[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]];
        int todaymonth = (int)[[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:[NSDate date]];
        int todayyear = (int)[[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
        NSString *today = [NSString stringWithFormat:@"%d/%d/%d", todaymonth, todayday, todayyear];
        PUSH(today);
        today = [NSString stringWithFormat:@"%d/%d/%d", 10, 9, 2016];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchSysdateExpr:)];
}

- (void)sysdateExpr_ {
    [self parseRule:@selector(__sysdateExpr) withMemo:_sysdateExpr_memo];
}

- (void)__mdyExpr {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"mdy"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_COMMA discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_COMMA discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	int year = (int)POP_DOUBLE();
	int day = (int)POP_DOUBLE();
	int month = (int)POP_DOUBLE();

    NSString *today = [NSString stringWithFormat:@"%d/%d/%d", month, day, year];
    PUSH(today);
	today = [NSString stringWithFormat:@"%d/%d/%d", 3, 3, 1970];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchMdyExpr:)];
}

- (void)mdyExpr_ {
    [self parseRule:@selector(__mdyExpr) withMemo:_mdyExpr_memo];
}

- (void)__dmyExpr {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"dmy"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_COMMA discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_COMMA discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	int year = (int)POP_DOUBLE();
	int month = (int)POP_DOUBLE();
	int day = (int)POP_DOUBLE();

    NSString *today = [NSString stringWithFormat:@"%d/%d/%d", month, day, year];
    PUSH(today);
	today = [NSString stringWithFormat:@"%d/%d/%d", 3, 3, 1970];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchDmyExpr:)];
}

- (void)dmyExpr_ {
    [self parseRule:@selector(__dmyExpr) withMemo:_dmyExpr_memo];
}

- (void)__absFunction {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"abs"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	PUSH_DOUBLE(fabs(POP_DOUBLE()));

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAbsFunction:)];
}

- (void)absFunction_ {
    [self parseRule:@selector(__absFunction) withMemo:_absFunction_memo];
}

- (void)__roundingFunction {
    
    if ([self speculate:^{ [self roundFunction_]; }]) {
        [self roundFunction_]; 
    } else if ([self speculate:^{ [self rndFunction_]; }]) {
        [self rndFunction_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'roundingFunction'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRoundingFunction:)];
}

- (void)roundingFunction_ {
    [self parseRule:@selector(__roundingFunction) withMemo:_roundingFunction_memo];
}

- (void)__roundFunction {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"round"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	PUSH_DOUBLE(round(POP_DOUBLE()));

    }];

    [self fireDelegateSelector:@selector(parser:didMatchRoundFunction:)];
}

- (void)roundFunction_ {
    [self parseRule:@selector(__roundFunction) withMemo:_roundFunction_memo];
}

- (void)__rndFunction {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"rnd"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	PUSH_DOUBLE(round(POP_DOUBLE()));

    }];

    [self fireDelegateSelector:@selector(parser:didMatchRndFunction:)];
}

- (void)rndFunction_ {
    [self parseRule:@selector(__rndFunction) withMemo:_rndFunction_memo];
}

- (void)__trigFunction {
    
    if ([self speculate:^{ [self sineFunction_]; }]) {
        [self sineFunction_]; 
    } else if ([self speculate:^{ [self cosineFunction_]; }]) {
        [self cosineFunction_]; 
    } else if ([self speculate:^{ [self tangentFunction_]; }]) {
        [self tangentFunction_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'trigFunction'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTrigFunction:)];
}

- (void)trigFunction_ {
    [self parseRule:@selector(__trigFunction) withMemo:_trigFunction_memo];
}

- (void)__sineFunction {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"sin"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	PUSH_DOUBLE(sinf(POP_DOUBLE()));

    }];

    [self fireDelegateSelector:@selector(parser:didMatchSineFunction:)];
}

- (void)sineFunction_ {
    [self parseRule:@selector(__sineFunction) withMemo:_sineFunction_memo];
}

- (void)__cosineFunction {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"cos"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	PUSH_DOUBLE(cosf(POP_DOUBLE()));

    }];

    [self fireDelegateSelector:@selector(parser:didMatchCosineFunction:)];
}

- (void)cosineFunction_ {
    [self parseRule:@selector(__cosineFunction) withMemo:_cosineFunction_memo];
}

- (void)__tangentFunction {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"tan"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	PUSH_DOUBLE(tanf(POP_DOUBLE()));

    }];

    [self fireDelegateSelector:@selector(parser:didMatchTangentFunction:)];
}

- (void)tangentFunction_ {
    [self parseRule:@selector(__tangentFunction) withMemo:_tangentFunction_memo];
}

- (void)__piFunction {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"pi"); }]; 
    [self matchWord:YES]; 
    [self execute:(id)^{
    
	PUSH_DOUBLE(M_PI);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchPiFunction:)];
}

- (void)piFunction_ {
    [self parseRule:@selector(__piFunction) withMemo:_piFunction_memo];
}

- (void)__inverseFunction {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"inverse"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	PUSH_DOUBLE(1.0 / POP_DOUBLE());

    }];

    [self fireDelegateSelector:@selector(parser:didMatchInverseFunction:)];
}

- (void)inverseFunction_ {
    [self parseRule:@selector(__inverseFunction) withMemo:_inverseFunction_memo];
}

- (void)__function {
    
    if ([self speculate:^{ [self datereturningfunction_]; }]) {
        [self datereturningfunction_]; 
    } else if ([self speculate:^{ [self numberReturningFunction_]; }]) {
        [self numberReturningFunction_]; 
    } else if ([self speculate:^{ [self concantenateFunction_]; }]) {
        [self concantenateFunction_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'function'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFunction:)];
}

- (void)function_ {
    [self parseRule:@selector(__function) withMemo:_function_memo];
}

- (void)__textReturningFunction {
    
    if ([self speculate:^{ [self uppercaseExpression_]; }]) {
        [self uppercaseExpression_]; 
    } else if ([self speculate:^{ [self matchWord:NO]; }]) {
        [self matchWord:NO]; 
    } else if ([self speculate:^{ [self quotedString_]; }]) {
        [self quotedString_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'textReturningFunction'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTextReturningFunction:)];
}

- (void)textReturningFunction_ {
    [self parseRule:@selector(__textReturningFunction) withMemo:_textReturningFunction_memo];
}

- (void)__uppercaseExpression {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"uppercase"); }]; 
    [self matchWord:YES]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self textReturningFunction_]; 
    [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
	PUSH([POP_STR() uppercaseString]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchUppercaseExpression:)];
}

- (void)uppercaseExpression_ {
    [self parseRule:@selector(__uppercaseExpression) withMemo:_uppercaseExpression_memo];
}

- (void)__quotedString {
    
    [self matchQuotedString:NO]; 
    [self execute:(id)^{
    
	// pop the string value of the `PKToken` on the top of the stack
	NSString *dbName = POP_STR();
	// trim quotes
	dbName = [dbName substringWithRange:NSMakeRange(1, [dbName length]-2)];
	// leave it on the stack for later
	PUSH(dbName);
	dbName = @"John";

    }];

    [self fireDelegateSelector:@selector(parser:didMatchQuotedString:)];
}

- (void)quotedString_ {
    [self parseRule:@selector(__quotedString) withMemo:_quotedString_memo];
}

- (void)__numberReturningFunction {
    
    if ([self speculate:^{ [self datemathExpr_]; }]) {
        [self datemathExpr_]; 
    } else if ([self speculate:^{ [self arithmeticFunction_]; }]) {
        [self arithmeticFunction_]; 
    } else if ([self speculate:^{ [self trigFunction_]; }]) {
        [self trigFunction_]; 
    } else if ([self speculate:^{ [self primary_]; }]) {
        [self primary_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'numberReturningFunction'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNumberReturningFunction:)];
}

- (void)numberReturningFunction_ {
    [self parseRule:@selector(__numberReturningFunction) withMemo:_numberReturningFunction_memo];
}

- (void)__datereturningfunction {
    
    if ([self speculate:^{ [self sysdateExpr_]; }]) {
        [self sysdateExpr_]; 
    } else if ([self speculate:^{ [self mdyExpr_]; }]) {
        [self mdyExpr_]; 
    } else if ([self speculate:^{ [self dmyExpr_]; }]) {
        [self dmyExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'datereturningfunction'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchDatereturningfunction:)];
}

- (void)datereturningfunction_ {
    [self parseRule:@selector(__datereturningfunction) withMemo:_datereturningfunction_memo];
}

- (void)__arithmeticFunction {
    
    if ([self speculate:^{ [self absFunction_]; }]) {
        [self absFunction_]; 
    } else if ([self speculate:^{ [self roundingFunction_]; }]) {
        [self roundingFunction_]; 
    } else if ([self speculate:^{ [self piFunction_]; }]) {
        [self piFunction_]; 
    } else if ([self speculate:^{ [self inverseFunction_]; }]) {
        [self inverseFunction_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'arithmeticFunction'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchArithmeticFunction:)];
}

- (void)arithmeticFunction_ {
    [self parseRule:@selector(__arithmeticFunction) withMemo:_arithmeticFunction_memo];
}

- (void)__primary {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self atom_]; 
    } else if ([self predicts:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self match:ASSIGNSTATEMENT_TOKEN_KIND_OPEN_PAREN discard:YES]; 
        [self expr_]; 
        [self match:ASSIGNSTATEMENT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimary:)];
}

- (void)primary_ {
    [self parseRule:@selector(__primary) withMemo:_primary_memo];
}

- (void)__atom {
    
    [self matchNumber:NO]; 
    [self execute:(id)^{
     
    PUSH_DOUBLE(POP_DOUBLE()); 

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)atom_ {
    [self parseRule:@selector(__atom) withMemo:_atom_memo];
}

@end
