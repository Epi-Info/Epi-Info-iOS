#import "ExpressionActionParser.h"
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

@interface ExpressionActionParser ()
@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *orExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *orTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *andExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *andTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *relExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *relOp_memo;
@property (nonatomic, retain) NSMutableDictionary *relOpTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *callExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *argList_memo;
@property (nonatomic, retain) NSMutableDictionary *primary_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@property (nonatomic, retain) NSMutableDictionary *obj_memo;
@property (nonatomic, retain) NSMutableDictionary *id_memo;
@property (nonatomic, retain) NSMutableDictionary *member_memo;
@property (nonatomic, retain) NSMutableDictionary *mmallexpr_memo;
@property (nonatomic, retain) NSMutableDictionary *concatenationArgument_memo;
@property (nonatomic, retain) NSMutableDictionary *concantenateFunction_memo;
@property (nonatomic, retain) NSMutableDictionary *mmexpr_memo;
@property (nonatomic, retain) NSMutableDictionary *addExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *multExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *caretExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *datemathExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *epiweekExpr_memo;
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
@property (nonatomic, retain) NSMutableDictionary *mmprimary_memo;
@property (nonatomic, retain) NSMutableDictionary *mmatom_memo;
@property (nonatomic, retain) NSMutableDictionary *literal_memo;
@property (nonatomic, retain) NSMutableDictionary *bool_memo;
@end

@implementation ExpressionActionParser

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        self.startRuleName = @"expr";
        self.tokenKindTab[@","] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"-"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_MINUS);
        self.tokenKindTab[@">="] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_GE);
        self.tokenKindTab[@"."] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_DOT);
        self.tokenKindTab[@"<"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_LT);
        self.tokenKindTab[@"<>"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_NE);
        self.tokenKindTab[@"/"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_FORWARD_SLASH);
        self.tokenKindTab[@"="] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"YES"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_YES_UPPER);
        self.tokenKindTab[@"or"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_OR);
        self.tokenKindTab[@">"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_GT);
        self.tokenKindTab[@"<="] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_LE);
        self.tokenKindTab[@"and"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_AND);
        self.tokenKindTab[@"%"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_PERCENT);
        self.tokenKindTab[@"yes"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_YES);
        self.tokenKindTab[@"&"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_AMPERSAND);
        self.tokenKindTab[@"no"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_NO);
        self.tokenKindTab[@"^"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_CARET);
        self.tokenKindTab[@"("] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"NO"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_NO_UPPER);
        self.tokenKindTab[@")"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"*"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_STAR);
        self.tokenKindTab[@"+"] = @(EXPRESSIONACTIONPARSER_TOKEN_KIND_PLUS);

        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_NE] = @"<>";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_FORWARD_SLASH] = @"/";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_YES_UPPER] = @"YES";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_PERCENT] = @"%";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_YES] = @"yes";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_AMPERSAND] = @"&";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_NO] = @"no";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_CARET] = @"^";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_NO_UPPER] = @"NO";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_STAR] = @"*";
        self.tokenKindNameTab[EXPRESSIONACTIONPARSER_TOKEN_KIND_PLUS] = @"+";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.orExpr_memo = [NSMutableDictionary dictionary];
        self.orTerm_memo = [NSMutableDictionary dictionary];
        self.andExpr_memo = [NSMutableDictionary dictionary];
        self.andTerm_memo = [NSMutableDictionary dictionary];
        self.relExpr_memo = [NSMutableDictionary dictionary];
        self.relOp_memo = [NSMutableDictionary dictionary];
        self.relOpTerm_memo = [NSMutableDictionary dictionary];
        self.callExpr_memo = [NSMutableDictionary dictionary];
        self.argList_memo = [NSMutableDictionary dictionary];
        self.primary_memo = [NSMutableDictionary dictionary];
        self.atom_memo = [NSMutableDictionary dictionary];
        self.obj_memo = [NSMutableDictionary dictionary];
        self.id_memo = [NSMutableDictionary dictionary];
        self.member_memo = [NSMutableDictionary dictionary];
        self.mmallexpr_memo = [NSMutableDictionary dictionary];
        self.concatenationArgument_memo = [NSMutableDictionary dictionary];
        self.concantenateFunction_memo = [NSMutableDictionary dictionary];
        self.mmexpr_memo = [NSMutableDictionary dictionary];
        self.addExpr_memo = [NSMutableDictionary dictionary];
        self.multExpr_memo = [NSMutableDictionary dictionary];
        self.caretExpr_memo = [NSMutableDictionary dictionary];
        self.datemathExpr_memo = [NSMutableDictionary dictionary];
        self.epiweekExpr_memo = [NSMutableDictionary dictionary];
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
        self.mmprimary_memo = [NSMutableDictionary dictionary];
        self.mmatom_memo = [NSMutableDictionary dictionary];
        self.literal_memo = [NSMutableDictionary dictionary];
        self.bool_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_clearMemo {
    [_expr_memo removeAllObjects];
    [_orExpr_memo removeAllObjects];
    [_orTerm_memo removeAllObjects];
    [_andExpr_memo removeAllObjects];
    [_andTerm_memo removeAllObjects];
    [_relExpr_memo removeAllObjects];
    [_relOp_memo removeAllObjects];
    [_relOpTerm_memo removeAllObjects];
    [_callExpr_memo removeAllObjects];
    [_argList_memo removeAllObjects];
    [_primary_memo removeAllObjects];
    [_atom_memo removeAllObjects];
    [_obj_memo removeAllObjects];
    [_id_memo removeAllObjects];
    [_member_memo removeAllObjects];
    [_mmallexpr_memo removeAllObjects];
    [_concatenationArgument_memo removeAllObjects];
    [_concantenateFunction_memo removeAllObjects];
    [_mmexpr_memo removeAllObjects];
    [_addExpr_memo removeAllObjects];
    [_multExpr_memo removeAllObjects];
    [_caretExpr_memo removeAllObjects];
    [_datemathExpr_memo removeAllObjects];
    [_epiweekExpr_memo removeAllObjects];
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
    [_mmprimary_memo removeAllObjects];
    [_mmatom_memo removeAllObjects];
    [_literal_memo removeAllObjects];
    [_bool_memo removeAllObjects];
}

- (void)start {
    [self expr_]; 
    [self matchEOF:YES]; 
}

- (void)__expr {
    
    [self execute:(id)^{
    
    PKTokenizer *t = self.tokenizer;
    [t.symbolState add:@"<>"];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];

    }];
    [self orExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__orExpr {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self orTerm_]; }]) {
        [self orTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)orExpr_ {
    [self parseRule:@selector(__orExpr) withMemo:_orExpr_memo];
}

- (void)__orTerm {
    
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OR discard:YES]; 
    [self andExpr_]; 
    [self execute:(id)^{
    
	BOOL rhs = POP_BOOL();
	BOOL lhs = POP_BOOL();
	PUSH_BOOL(lhs || rhs);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchOrTerm:)];
}

- (void)orTerm_ {
    [self parseRule:@selector(__orTerm) withMemo:_orTerm_memo];
}

- (void)__andExpr {
    
    [self relExpr_]; 
    while ([self speculate:^{ [self andTerm_]; }]) {
        [self andTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)andExpr_ {
    [self parseRule:@selector(__andExpr) withMemo:_andExpr_memo];
}

- (void)__andTerm {
    
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_AND discard:YES]; 
    [self relExpr_]; 
    [self execute:(id)^{
    
	BOOL rhs = POP_BOOL();
	BOOL lhs = POP_BOOL();
	PUSH_BOOL(lhs && rhs);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAndTerm:)];
}

- (void)andTerm_ {
    [self parseRule:@selector(__andTerm) withMemo:_andTerm_memo];
}

- (void)__relExpr {
    
    [self callExpr_]; 
    while ([self speculate:^{ [self relOpTerm_]; }]) {
        [self relOpTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelExpr:)];
}

- (void)relExpr_ {
    [self parseRule:@selector(__relExpr) withMemo:_relExpr_memo];
}

- (void)__relOp {
    
    if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_LT, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_LT discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_GT, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_GT discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_EQUALS, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_EQUALS discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_NE, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_NE discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_LE, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_LE discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_GE, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_GE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'relOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelOp:)];
}

- (void)relOp_ {
    [self parseRule:@selector(__relOp) withMemo:_relOp_memo];
}

- (void)__relOpTerm {
    
    [self relOp_]; 
    [self callExpr_]; 
    [self execute:(id)^{
    
        id rightObject = POP();
        id operatorObject = POP();
        id leftObject = POP();
        
        int caseNumber = -1;
        
        if ([self isANumber:leftObject] && [self isANumber:rightObject])
            caseNumber = 0;
        else if ([rightObject isKindOfClass:[NSDate class]] && [leftObject isKindOfClass:[NSDate class]])
            caseNumber = 1;
        else if ([self isAString:rightObject] && [self isAString:leftObject])
        {
            if ([self isADateString:(NSString *)leftObject] && [self isADateString:(NSString *)rightObject])
                caseNumber = 1;
            else
                caseNumber = 2;
        }
        else if ([self isGenericPositiveOrNegative:rightObject] || [self isGenericPositiveOrNegative:leftObject])
            caseNumber = 3;
        
        PUSH(leftObject);
        PUSH(operatorObject);
        PUSH(rightObject);

        switch (caseNumber) {
            case 0:
            {
                double rhs = POP_DOUBLE();
                NSString  *op = POP_STR();
                double lhs = POP_DOUBLE();
                
                if (EQ(op, @"<"))  PUSH_BOOL(lhs <  rhs);
                else if (EQ(op, @">"))  PUSH_BOOL(lhs >  rhs);
                else if (EQ(op, @"="))  PUSH_BOOL(lhs == rhs);
                else if (EQ(op, @"<>")) PUSH_BOOL(lhs != rhs);
                else if (EQ(op, @"<=")) PUSH_BOOL(lhs <= rhs);
                else if (EQ(op, @">=")) PUSH_BOOL(lhs >= rhs);
            }
                break;
                
            case 1:
            {
                NSString *rhs = POP_STR();
                NSString  *op = POP_STR();
                NSString *lhs = POP_STR();
                
                if (EQ(op, @"="))
                {
                    NSDate *rhDate = [self dateFromString:rhs];
                    NSDate *lhDate = [self dateFromString:lhs];
                    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:lhDate toDate:rhDate options:0];
                    PUSH_BOOL([difference day] == 0);
                }
                else if (EQ(op, @">"))
                {
                    NSDate *rhDate = [self dateFromString:rhs];
                    NSDate *lhDate = [self dateFromString:lhs];
                    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:lhDate toDate:rhDate options:0];
                    PUSH_BOOL([difference day] < 0);
                }
                else if (EQ(op, @"<"))
                {
                    NSDate *rhDate = [self dateFromString:rhs];
                    NSDate *lhDate = [self dateFromString:lhs];
                    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:lhDate toDate:rhDate options:0];
                    PUSH_BOOL([difference day] > 0);
                }
                else if (EQ(op, @"<>"))
                {
                    NSDate *rhDate = [self dateFromString:rhs];
                    NSDate *lhDate = [self dateFromString:lhs];
                    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:lhDate toDate:rhDate options:0];
                    PUSH_BOOL([difference day] != 0);
                }
                else if (EQ(op, @">="))
                {
                    NSDate *rhDate = [self dateFromString:rhs];
                    NSDate *lhDate = [self dateFromString:lhs];
                    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:lhDate toDate:rhDate options:0];
                    PUSH_BOOL([difference day] <= 0);
                }
                else if (EQ(op, @"<="))
                {
                    NSDate *rhDate = [self dateFromString:rhs];
                    NSDate *lhDate = [self dateFromString:lhs];
                    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:lhDate toDate:rhDate options:0];
                    PUSH_BOOL([difference day] >= 0);
                }
            }
                break;
                
            case 2:
            {
                NSString *rhs = POP_STR();
                NSString  *op = POP_STR();
                NSString *lhs = POP_STR();
                
                if (EQ(op, @"="))  PUSH_BOOL([lhs isEqualToString:rhs] || [[self stripQuotes:lhs] isEqualToString:[self stripQuotes:rhs]] || [self lhsAndRhsAreBothMissing:lhs AndRHS:rhs]);
                else if (EQ(op, @"<>"))  PUSH_BOOL(!([lhs isEqualToString:rhs] || [[self stripQuotes:lhs] isEqualToString:[self stripQuotes:rhs]] || [self lhsAndRhsAreBothMissing:lhs AndRHS:rhs]));
            }
                break;
                
            case 3:
            {
                NSString *rhs = POP_STR();
                NSString  *op = POP_STR();
                NSString *lhs = POP_STR();
                
                if (EQ(op, @"=")) PUSH_BOOL([self testLHS:lhs equalityWithGeneric:rhs]);
                if (EQ(op, @"<>")) PUSH_BOOL(![self testLHS:lhs equalityWithGeneric:rhs]);
            }
                break;
                
            default:
            {
                NSString *rhs = POP_STR();
                NSString  *op = POP_STR();
                NSString *lhs = POP_STR();
                
                if (EQ(op, @"="))  PUSH_BOOL([lhs isEqualToString:rhs] || [[self stripQuotes:lhs] isEqualToString:[self stripQuotes:rhs]] || [self lhsAndRhsAreBothMissing:lhs AndRHS:rhs]);
                else if (EQ(op, @"<>"))  PUSH_BOOL(!([lhs isEqualToString:rhs] || [[self stripQuotes:lhs] isEqualToString:[self stripQuotes:rhs]]));
            }
                break;
        }

    }];

    [self fireDelegateSelector:@selector(parser:didMatchRelOpTerm:)];
}

- (void)relOpTerm_ {
    [self parseRule:@selector(__relOpTerm) withMemo:_relOpTerm_memo];
}

- (void)__callExpr {
    
    if ([self speculate:^{ [self dateLiteral_]; }]) {
        [self dateLiteral_]; 
    } else if ([self speculate:^{ [self primary_]; }]) {
        [self primary_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'callExpr'."];
    }
    if ([self speculate:^{ [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; if ([self speculate:^{ [self argList_]; }]) {[self argList_]; }[self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; }]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        if ([self speculate:^{ [self argList_]; }]) {
            [self argList_]; 
        }
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchCallExpr:)];
}

- (void)callExpr_ {
    [self parseRule:@selector(__callExpr) withMemo:_callExpr_memo];
}

- (void)__argList {
    
    [self atom_]; 
    while ([self speculate:^{ [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA discard:NO]; [self atom_]; }]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA discard:NO]; 
        [self atom_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgList:)];
}

- (void)argList_ {
    [self parseRule:@selector(__argList) withMemo:_argList_memo];
}

- (void)__primary {
    
    if ([self speculate:^{ [self atom_]; }]) {
        [self atom_]; 
    } else if ([self speculate:^{ [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; [self expr_]; [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; }]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        [self expr_]; 
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
        [self execute:(id)^{
        
		//NSLog(@"primary");

        }];
    } else {
        [self raise:@"No viable alternative found in rule 'primary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimary:)];
}

- (void)primary_ {
    [self parseRule:@selector(__primary) withMemo:_primary_memo];
}

- (void)__atom {
    
    if ([self speculate:^{ [self mmexpr_]; }]) {
        [self mmexpr_]; 
    } else if ([self speculate:^{ [self obj_]; }]) {
        [self obj_]; 
    } else if ([self speculate:^{ [self literal_]; }]) {
        [self literal_]; 
        [self execute:(id)^{
        
		//NSLog(@"atom");

        }];
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)atom_ {
    [self parseRule:@selector(__atom) withMemo:_atom_memo];
}

- (void)__obj {
    
    [self id_]; 
    while ([self speculate:^{ [self member_]; }]) {
        [self member_]; 
    }
    [self execute:(id)^{
    
		//NSLog(@"obj");

    }];

    [self fireDelegateSelector:@selector(parser:didMatchObj:)];
}

- (void)obj_ {
    [self parseRule:@selector(__obj) withMemo:_obj_memo];
}

- (void)__id {
    
    if ([self speculate:^{ [self dateValue_]; }]) {
        [self dateValue_]; 
    } else if ([self speculate:^{ [self matchWord:NO]; }]) {
        [self matchWord:NO]; 
        [self execute:(id)^{
        
    //NSLog(@"id = Word is right here");

        }];
    } else {
        [self raise:@"No viable alternative found in rule 'id'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchId:)];
}

- (void)id_ {
    [self parseRule:@selector(__id) withMemo:_id_memo];
}

- (void)__member {
    
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_DOT discard:NO]; 
    [self id_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMember:)];
}

- (void)member_ {
    [self parseRule:@selector(__member) withMemo:_member_memo];
}

- (void)__mmallexpr {
    
    if ([self speculate:^{ [self dateLiteral_]; }]) {
        [self dateLiteral_]; 
    } else if ([self speculate:^{ [self concantenateFunction_]; }]) {
        [self concantenateFunction_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'mmallexpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMmallexpr:)];
}

- (void)mmallexpr_ {
    [self parseRule:@selector(__mmallexpr) withMemo:_mmallexpr_memo];
}

- (void)__concatenationArgument {
    
    if ([self speculate:^{ [self mmexpr_]; }]) {
        [self mmexpr_]; 
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
    while ([self speculate:^{ [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_AMPERSAND discard:YES]; [self concatenationArgument_]; }]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_AMPERSAND discard:YES]; 
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

- (void)__mmexpr {
    
    [self addExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMmexpr:)];
}

- (void)mmexpr_ {
    [self parseRule:@selector(__mmexpr) withMemo:_mmexpr_memo];
}

- (void)__addExpr {
    
    [self multExpr_]; 
    while ([self speculate:^{ if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_PLUS, 0]) {[self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_PLUS discard:NO]; } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_MINUS, 0]) {[self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_MINUS discard:NO]; } else {[self raise:@"No viable alternative found in rule 'addExpr'."];}[self multExpr_]; }]) {
        if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_PLUS, 0]) {
            [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_PLUS discard:NO]; 
        } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_MINUS, 0]) {
            [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_MINUS discard:NO]; 
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
    while ([self speculate:^{ if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_STAR, 0]) {[self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_STAR discard:NO]; } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {[self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_PERCENT, 0]) {[self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_PERCENT discard:NO]; } else {[self raise:@"No viable alternative found in rule 'multExpr'."];}[self caretExpr_]; }]) {
        if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_STAR, 0]) {
            [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_STAR discard:NO]; 
        } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {
            [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
        } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_PERCENT, 0]) {
            [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_PERCENT discard:NO]; 
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
    while ([self speculate:^{ [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CARET discard:YES]; [self numberReturningFunction_]; }]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CARET discard:YES]; 
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
    } else if ([self speculate:^{ [self epiweekExpr_]; }]) {
        [self epiweekExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'datemathExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchDatemathExpr:)];
}

- (void)datemathExpr_ {
    [self parseRule:@selector(__datemathExpr) withMemo:_datemathExpr_memo];
}

- (void)__epiweekExpr {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"epiweek"); }]; 
    [self matchWord:YES]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self dateValue_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
        NSString *dateString = POP_STR();
        
        int firstSlash1 = (int)[dateString rangeOfString:@"/"].location;
        int secondSlash1 = (int)[[dateString substringFromIndex:firstSlash1 + 1] rangeOfString:@"/"].location + firstSlash1 + 1;

        NSDateComponents *argComponents = [[NSDateComponents alloc] init];
        [argComponents setDay:[[dateString substringWithRange:NSMakeRange(firstSlash1 + 1, secondSlash1 - firstSlash1 - 1)] intValue]];
        [argComponents setMonth:[[dateString substringToIndex:firstSlash1] intValue]];
        [argComponents setYear:[[dateString substringFromIndex:secondSlash1 + 1] intValue]];
        NSDate *argDate = [[NSCalendar currentCalendar] dateFromComponents:argComponents];

        NSDateComponents *foyComponents = [[NSDateComponents alloc] init];
        [foyComponents setDay:1];
        [foyComponents setMonth:1];
        [foyComponents setYear:[argComponents year]];
        NSDate *foyDate = [[NSCalendar currentCalendar] dateFromComponents:foyComponents];

        NSDateComponents *nsdc = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:foyDate];
        
        int dayOfFirstOfYear = (int)[nsdc weekday] - 1;
        
        NSDate *mmwrStart;
// Won’t generate with this if-statement
// Remove it from this tool and re-add it to the generated code
        if (dayOfFirstOfYear < 4)
        {
            mmwrStart = [foyDate dateByAddingTimeInterval:-(dayOfFirstOfYear * 24 * 60 * 60)];
        }
        else
        {
            mmwrStart = [foyDate dateByAddingTimeInterval:(7 * 24 * 60 * 60) - (dayOfFirstOfYear * 24 * 60 * 60)];
        }
        
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:mmwrStart toDate:argDate options:0];

        PUSH_INT((int)([difference day] / 7) + 1);
        
        dateString = [NSString stringWithFormat:@"%d/%d/%d", 3, 3, 1970];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchEpiweekExpr:)];
}

- (void)epiweekExpr_ {
    [self parseRule:@selector(__epiweekExpr) withMemo:_epiweekExpr_memo];
}

- (void)__daysmathExpr {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(LS(1), @"days"); }]; 
    [self matchWord:YES]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self dateValue_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA discard:YES]; 
    [self dateValue_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self dateValue_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA discard:YES]; 
    [self dateValue_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self dateValue_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA discard:YES]; 
    [self dateValue_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_FORWARD_SLASH discard:YES]; 
    [self matchNumber:NO]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_FORWARD_SLASH discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_COMMA discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self mmexpr_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self textReturningFunction_]; 
    [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
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
    } else if ([self speculate:^{ [self mmprimary_]; }]) {
        [self mmprimary_]; 
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

- (void)__mmprimary {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self mmatom_]; 
    } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
        [self mmexpr_]; 
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'mmprimary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMmprimary:)];
}

- (void)mmprimary_ {
    [self parseRule:@selector(__mmprimary) withMemo:_mmprimary_memo];
}

- (void)__mmatom {
    
    [self matchNumber:NO]; 
    [self execute:(id)^{
     
    PUSH_DOUBLE(POP_DOUBLE()); 

    }];

    [self fireDelegateSelector:@selector(parser:didMatchMmatom:)];
}

- (void)mmatom_ {
    [self parseRule:@selector(__mmatom) withMemo:_mmatom_memo];
}

- (void)__literal {
    
    if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_NO, EXPRESSIONACTIONPARSER_TOKEN_KIND_NO_UPPER, EXPRESSIONACTIONPARSER_TOKEN_KIND_YES, EXPRESSIONACTIONPARSER_TOKEN_KIND_YES_UPPER, 0]) {
        [self testAndThrow:(id)^{ return LA(1) != EXPRESSIONACTIONPARSER_TOKEN_KIND_YES_UPPER; }]; 
        [self bool_]; 
        [self execute:(id)^{
         PUSH_BOOL(EQ_IGNORE_CASE(POP_STR(), @"yes")); 
        }];
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self matchNumber:NO]; 
        [self execute:(id)^{
         PUSH_DOUBLE(POP_DOUBLE()); 
        }];
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self matchQuotedString:NO]; 
        [self execute:(id)^{
         PUSH(POP_STR()); 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)literal_ {
    [self parseRule:@selector(__literal) withMemo:_literal_memo];
}

- (void)__bool {
    
    if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_YES, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_YES discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_YES_UPPER, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_YES_UPPER discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_NO, 0]) {
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_NO discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONPARSER_TOKEN_KIND_NO_UPPER, 0]) {
        [self testAndThrow:(id)^{ return NE(LS(1), @"NO"); }]; 
        [self match:EXPRESSIONACTIONPARSER_TOKEN_KIND_NO_UPPER discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)bool_ {
    [self parseRule:@selector(__bool) withMemo:_bool_memo];
}

- (BOOL)isADateString:(NSString *)testString
{
    BOOL testResult = NO;
    
    if ([testString isKindOfClass:[PKToken class]])
        testString = [(PKToken *)testString stringValue];
    
    if ([testString componentsSeparatedByString:@"/"].count == 3)
    {
        int firstSlash1 = (int)[testString rangeOfString:@"/"].location;
        int secondSlash1 = (int)[[testString substringFromIndex:firstSlash1 + 1] rangeOfString:@"/"].location + firstSlash1 + 1;
        
        int parsedDay = [[testString substringWithRange:NSMakeRange(firstSlash1 + 1, secondSlash1 - firstSlash1 - 1)] intValue];
        int parsedMonth = [[testString substringToIndex:firstSlash1] intValue];
        int parsedYear = [[testString substringFromIndex:secondSlash1 + 1] intValue];
        
        if (parsedDay == 0 || parsedMonth == 0 || parsedYear == 0)
            return NO;
        
        NSDateComponents *argComponents = [[NSDateComponents alloc] init];
        [argComponents setDay:[[testString substringWithRange:NSMakeRange(firstSlash1 + 1, secondSlash1 - firstSlash1 - 1)] intValue]];
        [argComponents setMonth:[[testString substringToIndex:firstSlash1] intValue]];
        [argComponents setYear:[[testString substringFromIndex:secondSlash1 + 1] intValue]];
        NSDate *argDate = [[NSCalendar currentCalendar] dateFromComponents:argComponents];
        if (argDate > 0)
            testResult = YES;
    }
    
    return testResult;
}
- (BOOL)isANumber:(id)testObject
{
    if ([testObject isKindOfClass:[NSNumber class]])
        return YES;
    if ([testObject isKindOfClass:[PKToken class]])
    {
        if ([(PKToken *)testObject tokenType] == PKTokenTypeNumber)
            return YES;
    }
    return NO;
}
- (BOOL)isAString:(id)testObject
{
    if ([testObject isKindOfClass:[NSString class]])
        return YES;
    if ([testObject isKindOfClass:[PKToken class]])
    {
        if ([(PKToken *)testObject tokenType] == PKTokenTypeWord)
            return YES;
    }
    return NO;
}
- (BOOL)isGenericPositiveOrNegative:(id)testObject
{
    BOOL testResult = NO;
    
    if ([testObject isKindOfClass:[NSString class]])
    {
        if ([(NSString *)testObject length] < 5)
        {
            return NO;
        }
        if ([testObject characterAtIndex:1] == '(' && [testObject characterAtIndex:3] == ')' &&
            ([testObject characterAtIndex:2] == '+' || [testObject characterAtIndex:2] == '-'))
        {
            testResult = YES;
        }
    }
    else if ([testObject isKindOfClass:[PKToken class]])
    {
        if ([(PKToken *)testObject tokenKind] == PKTokenTypeWord)
        {
            NSString *tokenWord = [(PKToken *)testObject stringValue];
            if (tokenWord.length < 5)
            {
                return NO;
            }
            if ([tokenWord characterAtIndex:1] == '(' && [tokenWord characterAtIndex:3] == ')' &&
                ([tokenWord characterAtIndex:2] == '+' || [tokenWord characterAtIndex:2] == '-'))
            {
                testResult = YES;
            }
        }
    }
    
    return testResult;
}
- (BOOL)testLHS:(NSString *)lhs equalityWithGeneric:(NSString *)rhs
{
    BOOL testResult = NO;
    
    NSArray *positiveValues = @[@"TRUE", @"1", @"YES"];
    NSArray *negativeValues = @[@"FALSE", @"0", @"NO"];
    
    if ([[self stripQuotes:rhs] isEqualToString:@"(+)"])
    {
        NSString *compareString = [[self stripQuotes:lhs] uppercaseString];
        if ([positiveValues containsObject:compareString])
            return YES;
    }
    
    if ([[self stripQuotes:rhs] isEqualToString:@"(-)"])
    {
        NSString *compareString = [[self stripQuotes:lhs] uppercaseString];
        if ([negativeValues containsObject:compareString])
            return YES;
    }
    
    if ([[self stripQuotes:lhs] isEqualToString:@"(+)"])
    {
        NSString *compareString = [[self stripQuotes:rhs] uppercaseString];
        if ([positiveValues containsObject:compareString])
            return YES;
    }
    
    if ([[self stripQuotes:lhs] isEqualToString:@"(-)"])
    {
        NSString *compareString = [[self stripQuotes:rhs] uppercaseString];
        if ([negativeValues containsObject:compareString])
            return YES;
    }
    
    return testResult;
}

- (NSDate *)dateFromString:(NSString *)properDateString
{
    NSDate *returnDate;
    
    int firstSlash1 = (int)[properDateString rangeOfString:@"/"].location;
    int secondSlash1 = (int)[[properDateString substringFromIndex:firstSlash1 + 1] rangeOfString:@"/"].location + firstSlash1 + 1;
    
    NSDateComponents *argComponents = [[NSDateComponents alloc] init];
    [argComponents setDay:[[properDateString substringWithRange:NSMakeRange(firstSlash1 + 1, secondSlash1 - firstSlash1 - 1)] intValue]];
    [argComponents setMonth:[[properDateString substringToIndex:firstSlash1] intValue]];
    [argComponents setYear:[[properDateString substringFromIndex:secondSlash1 + 1] intValue]];
    returnDate = [[NSCalendar currentCalendar] dateFromComponents:argComponents];
    
    return returnDate;
}

- (NSString *)stripQuotes:(NSString *)inputStr
{
    NSMutableString *nsms = [[NSMutableString alloc] init];
    [nsms insertString:inputStr atIndex:0];
    if ([nsms characterAtIndex:0] == '"' && [nsms characterAtIndex:inputStr.length - 1] == '"')
    {
        [nsms replaceCharactersInRange:NSMakeRange(inputStr.length - 1, 1) withString:@""];
        [nsms replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    return [NSString stringWithString:nsms];
}

- (bool)lhsAndRhsAreBothMissing:(NSString *)lhs AndRHS:(NSString *)rhs
{
    bool testResult = NO;
    bool lhsIsMissing = NO;
    bool rhsIsMissing = NO;
    
    NSString *strippedLHS = [[self stripQuotes:lhs] uppercaseString];
    NSString *strippedRHS = [[self stripQuotes:rhs] uppercaseString];
    
    if ([strippedLHS isEqualToString:@""] || [strippedLHS isEqualToString:@"NULL"] || [strippedLHS isEqualToString:@"(.)"])
        lhsIsMissing = YES;
    if ([strippedRHS isEqualToString:@""] || [strippedRHS isEqualToString:@"NULL"] || [strippedRHS isEqualToString:@"(.)"])
        rhsIsMissing = YES;
    
    if (lhsIsMissing && rhsIsMissing)
        testResult = YES;
    return testResult;
}

@end
