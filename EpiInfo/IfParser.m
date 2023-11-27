#import "IfParser.h"
#import "ExpressionActionParser.h"
#import "FullAssignStatementParser.h"
#import "AssignStatementParser.h"
#import "DataEntryViewController.h"
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
@synthesize dictionaryOfPages = _dictionaryOfPages;

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
                if (nsms.length > 0 && ![newStr isEqualToString:@"LINEFEED"] && ![oldStr isEqualToString:@"LINEFEED"])
                    [nsms insertString:@" " atIndex:0];
                [nsms insertString:newStr atIndex:0];
                oldStr = [NSString stringWithString:newStr];
            }
            NSLog(@"Statement is: %@", nsms);
            NSLog(@"truthState is %@.", [self truthStateString]);
            NSLog(@"elseing is %@.", [self elseingString]);
            if ((truthState && !elseing) || (!truthState && elseing))
            {
                NSLog(@"Execute this statement");
                NSArray *arrayOfStatements = [nsms componentsSeparatedByString:@"<LINEFEED>"];
                for (int aos = 0; aos < arrayOfStatements.count; aos++)
                {
                    NSString *statement = [arrayOfStatements objectAtIndex:aos];
                    if (statement.length == 0)
                        continue;
                    if ([statement characterAtIndex:statement.length - 1] == ' ')
                        statement = [statement substringToIndex:statement.length - 1];
                    if ([statement characterAtIndex:0] == ' ')
                        statement = [statement substringFromIndex:1];
                    if ([[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"ASSIGN"])
                    {
                        FullAssignStatementParser *fasParser = [[FullAssignStatementParser alloc] init];
                        NSError *err = nil;
                        PKAssembly *fasResult = [fasParser parseString:[statement stringByReplacingOccurrencesOfString:@"<LINEFEED>" withString:@""] error:&err];
                        if (fasResult)
                        {
                            __block NSString *assignInput = [fasResult pop];
                            for (id key in [[self.dictionaryOfFields fasv] nsmd])
                            {
                                PKTokenizer *pkparser = [[PKTokenizer alloc] initWithString:assignInput];
                                [pkparser enumerateTokensUsingBlock:^(PKToken *token, BOOL *boo){
                                    NSLog(@"%@", token.stringValue);
                                    if ([[token.stringValue lowercaseString] isEqualToString:(NSString *)key])
                                    {
                                        assignInput = [[assignInput lowercaseString] stringByReplacingOccurrencesOfString:(NSString *)key withString:[[[self.dictionaryOfFields fasv] nsmd] objectForKey:key]];
                                    }
                                }];
                            }
                            NSString *targetField = [fasResult pop];
                            AssignStatementParser *parser = [[AssignStatementParser alloc] init];
                            PKAssembly *result = [parser parseString:assignInput error:&err];
                            NSString *stringToAssign = [NSString stringWithFormat:@"%@", [result pop]];
                            NSLog(@"Result is %@. Target Field is %@", stringToAssign, targetField);
                            [[self.dictionaryOfFields objectForKey:targetField] assignValue:stringToAssign];
                        }
                    }
                    else if ([[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"CLEAR"])
                    {
                        NSMutableArray *controlsToAlter = [NSMutableArray arrayWithArray:[statement componentsSeparatedByString:@" "]];
                        for (int cto = 1; cto < controlsToAlter.count; cto++)
                        {
                            if (!(([((DataEntryViewController *)[self rootViewController]).arrayOfFieldsAllPages containsObject:[[controlsToAlter objectAtIndex:cto] lowercaseString]]) || ([(NSDictionary *)[(EnterDataView *)[self.dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", 1]] dictionaryOfGroupsAndLists] objectForKey:[controlsToAlter objectAtIndex:cto]])))
                                continue;
                            BOOL pageAlreadyExists = NO;
                            int pageTurns = 0;
                            EnterDataView *edv0;
                            while (!pageAlreadyExists)
                            {
                                for (int keyint = 0; keyint < self.dictionaryOfPages.count; keyint++)
                                {
                                    NSString *key = [NSString stringWithFormat:@"Page%d", keyint + 1];
                                    edv0 = [self.dictionaryOfPages objectForKey:key];
                                    if ([edv0 dictionaryOfGroupsAndLists])
                                    {
                                        if ([(NSDictionary *)[edv0 dictionaryOfGroupsAndLists] objectForKey:[controlsToAlter objectAtIndex:cto]])
                                        {
                                            NSArray *arrayOfFieldsInGroup = [(NSString *)[(NSDictionary *)[edv0 dictionaryOfGroupsAndLists] objectForKey:[controlsToAlter objectAtIndex:cto]] componentsSeparatedByString:@","];
                                            for (int fig = 0; fig < arrayOfFieldsInGroup.count; fig++)
                                            {
                                                NSString *fieldInGroup = [arrayOfFieldsInGroup objectAtIndex:fig];
                                                if ([edv0.dictionaryOfFields objectForKey:fieldInGroup])
                                                {
                                                    if (![controlsToAlter containsObject:fieldInGroup])
                                                        [controlsToAlter addObject:fieldInGroup];
                                                }
                                            }
                                            pageAlreadyExists = YES;
                                        }
                                    }
                                    if ([edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]])
                                    {
                                        [[edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]] resetDoNotEnable];
                                        pageAlreadyExists = YES;
                                    }
                                }
                                // REVISIT this bit preventing page-turning by Check Code on Child Forms
                                if (edv0 && !pageAlreadyExists && [edv0 parentEnterDataView] == nil)
                                {
                                    @try {
                                        [edv0 checkcodeSwipedToTheLeft];
                                        if (pageTurns == 0)
                                            [edv0 restoreToViewController];
                                        pageTurns++;
                                    } @catch (NSException *exception) {
                                        NSLog(@"Could not swipe left for some reason.");
                                        break;
                                    } @finally {
                                        //
                                    }
                                }
                                // REVISIT this bit preventing page-turning by Check Code on Child Forms
                                if (!edv0 || [edv0 parentEnterDataView] != nil)
                                    break;
                            }
                            while (pageTurns > 0)
                            {
                                if (edv0)
                                    [edv0 checkcodeSwipedToTheRight];
                                pageTurns--;
                            }
                        }
                    }
                    else if ([[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"ENABLE"] ||
                             [[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"UNHIDE"])
                    {
                        NSMutableArray *controlsToAlter = [NSMutableArray arrayWithArray:[statement componentsSeparatedByString:@" "]];
                        for (int cto = 1; cto < controlsToAlter.count; cto++)
                        {
                            if (!(([((DataEntryViewController *)[self rootViewController]).arrayOfFieldsAllPages containsObject:[[controlsToAlter objectAtIndex:cto] lowercaseString]]) || ([(NSDictionary *)[(EnterDataView *)[self.dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", 1]] dictionaryOfGroupsAndLists] objectForKey:[controlsToAlter objectAtIndex:cto]])))
                                continue;
                            BOOL pageAlreadyExists = NO;
                            int pageTurns = 0;
                            EnterDataView *edv0;
                            while (!pageAlreadyExists)
                            {
                                for (int keyint = 0; keyint < self.dictionaryOfPages.count; keyint++)
                                {
                                    NSString *key = [NSString stringWithFormat:@"Page%d", keyint + 1];
                                    edv0 = [self.dictionaryOfPages objectForKey:key];
                                    if ([edv0 dictionaryOfGroupsAndLists])
                                    {
                                        if ([(NSDictionary *)[edv0 dictionaryOfGroupsAndLists] objectForKey:[controlsToAlter objectAtIndex:cto]])
                                        {
                                            NSArray *arrayOfFieldsInGroup = [(NSString *)[(NSDictionary *)[edv0 dictionaryOfGroupsAndLists] objectForKey:[controlsToAlter objectAtIndex:cto]] componentsSeparatedByString:@","];
                                            for (int fig = 0; fig < arrayOfFieldsInGroup.count; fig++)
                                            {
                                                NSString *fieldInGroup = [arrayOfFieldsInGroup objectAtIndex:fig];
                                                if ([edv0.dictionaryOfFields objectForKey:fieldInGroup])
                                                {
                                                    if (![controlsToAlter containsObject:fieldInGroup])
                                                        [controlsToAlter addObject:fieldInGroup];
                                                }
                                            }
                                            pageAlreadyExists = YES;
                                        }
                                    }
                                    if ([edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]])
                                    {
                                        [[edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]] setIsEnabled:YES];
                                        if ([[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"UNHIDE"])
                                            [[edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]] setIsHidden:NO];
                                        pageAlreadyExists = YES;
                                    }
                                }
                                // REVISIT this bit preventing page-turning by Check Code on Child Forms
                                if (edv0 && !pageAlreadyExists && [edv0 parentEnterDataView] == nil)
                                {
                                    @try {
                                        [edv0 checkcodeSwipedToTheLeft];
                                        if (pageTurns == 0)
                                            [edv0 restoreToViewController];
                                        pageTurns++;
                                    } @catch (NSException *exception) {
                                        NSLog(@"Could not swipe left for some reason.");
                                        break;
                                    } @finally {
                                        //
                                    }
                                }
                                // REVISIT this bit preventing page-turning by Check Code on Child Forms
                                if (!edv0 || [edv0 parentEnterDataView] != nil)
                                    break;
                            }
                            while (pageTurns > 0)
                            {
                                if (edv0)
                                    [edv0 checkcodeSwipedToTheRight];
                                pageTurns--;
                            }
                        }
                    }
                    else if ([[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"DISABLE"] ||
                             [[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"HIDE"])
                    {
                        NSMutableArray *controlsToAlter = [NSMutableArray arrayWithArray:[statement componentsSeparatedByString:@" "]];
                        for (int cto = 1; cto < controlsToAlter.count; cto++)
                        {
                            if (!(([((DataEntryViewController *)[self rootViewController]).arrayOfFieldsAllPages containsObject:[[controlsToAlter objectAtIndex:cto] lowercaseString]]) || ([(NSDictionary *)[(EnterDataView *)[self.dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", 1]] dictionaryOfGroupsAndLists] objectForKey:[controlsToAlter objectAtIndex:cto]])))
                                continue;
                            BOOL pageAlreadyExists = NO;
                            int pageTurns = 0;
                            EnterDataView *edv0;
                            while (!pageAlreadyExists)
                            {
                                for (int keyint = 0; keyint < self.dictionaryOfPages.count; keyint++)
                                {
                                    NSString *key = [NSString stringWithFormat:@"Page%d", keyint + 1];
                                    edv0 = [self.dictionaryOfPages objectForKey:key];
                                    if ([edv0 dictionaryOfGroupsAndLists])
                                    {
                                        if ([(NSDictionary *)[edv0 dictionaryOfGroupsAndLists] objectForKey:[controlsToAlter objectAtIndex:cto]])
                                        {
                                            NSArray *arrayOfFieldsInGroup = [(NSString *)[(NSDictionary *)[edv0 dictionaryOfGroupsAndLists] objectForKey:[controlsToAlter objectAtIndex:cto]] componentsSeparatedByString:@","];
                                            for (int fig = 0; fig < arrayOfFieldsInGroup.count; fig++)
                                            {
                                                NSString *fieldInGroup = [arrayOfFieldsInGroup objectAtIndex:fig];
                                                if ([edv0.dictionaryOfFields objectForKey:fieldInGroup])
                                                {
                                                    if (![controlsToAlter containsObject:fieldInGroup])
                                                        [controlsToAlter addObject:fieldInGroup];
                                                }
                                            }
                                            pageAlreadyExists = YES;
                                        }
                                    }
                                    if ([edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]])
                                    {
                                        [[edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]] setIsEnabled:NO];
                                        if ([[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"HIDE"])
                                            [[edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]] setIsHidden:YES];
                                        pageAlreadyExists = YES;
                                    }
                                }
                                // REVISIT this bit preventing page-turning by Check Code on Child Forms
                                if (edv0 && !pageAlreadyExists && [edv0 parentEnterDataView] == nil)
                                {
                                    @try {
                                        [edv0 checkcodeSwipedToTheLeft];
                                        if (pageTurns == 0)
                                            [edv0 restoreToViewController];
                                        pageTurns++;
                                    } @catch (NSException *exception) {
                                        NSLog(@"Could not swipe left for some reason.");
                                        break;
                                    } @finally {
                                        //
                                    }
                                }
                                // REVISIT this bit preventing page-turning by Check Code on Child Forms
                                if (!edv0 || [edv0 parentEnterDataView] != nil)
                                    break;
                            }
                            while (pageTurns > 0)
                            {
                                // REVISIT consider implementing this for back page turns
                                @try {
                                    if (edv0)
                                    {
                                        [edv0 checkcodeSwipedToTheRight];
                                        int newEDV0 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pageName"] intValue] - 1;
                                        NSLog(@"__statement method newEDV0 = %d", newEDV0);
                                        edv0 = [edv0.dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", newEDV0]];
                                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", newEDV0] forKey:@"pageName"];
                                    }
                                    pageTurns--;
                                } @catch (NSException *exception) {
                                    NSLog(@"Could not swipe right for some reason.");
                                    break;
                                } @finally {
                                    //
                                }
                            }
                        }
                    }
                    else if ([[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"GOTO"]
                             && [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"executeGOTOs"] boolValue])
                    {
                        NSArray *controlsToAlter = [statement componentsSeparatedByString:@" "];
                        for (int cto = 1; cto < controlsToAlter.count; cto++)
                        {
                            if (![((DataEntryViewController *)[self rootViewController]).arrayOfFieldsAllPages containsObject:[[controlsToAlter objectAtIndex:cto] lowercaseString]])
                                continue;
                            BOOL pageAlreadyExists = NO;
                            int pageBeingDisplayed = 0;
                            int pageToWhichWeAreTurning = 0;
                            while (!pageAlreadyExists)
                            {
                                EnterDataView *edv0;
                                for (int keyint = 0; keyint < self.dictionaryOfPages.count; keyint++)
                                {
                                    NSString *key = [NSString stringWithFormat:@"Page%d", keyint + 1];
                                    edv0 = [self.dictionaryOfPages objectForKey:key];
                                    if ([edv0 arrayOfGroups])
                                    {
                                        if ([(NSArray *)[edv0 arrayOfGroups] containsObject:[controlsToAlter objectAtIndex:cto]])
                                        {
                                            pageAlreadyExists = YES;
                                            break;
                                        }
                                    }
                                    if ([edv0 superview])
                                        pageBeingDisplayed = [[(NSString *)key substringFromIndex:4] intValue];
                                    if ([edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]])
                                    {
                                        [[edv0.dictionaryOfFields objectForKey:[controlsToAlter objectAtIndex:cto]] selfFocus];
                                        pageAlreadyExists = YES;
                                        pageToWhichWeAreTurning = [[(NSString *)key substringFromIndex:4] intValue];
                                    }
                                }
                                if (edv0 && !pageAlreadyExists)
                                {
                                    @try {
                                        [edv0 userSwipedToTheLeft];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Could not swipe left for some reason.");
                                        break;
                                    } @finally {
                                        //
                                    }
                                }
                                if (!edv0)
                                    break;
                            }
                            if (pageBeingDisplayed > 0 && pageToWhichWeAreTurning > 0)
                            {
                                if (pageToWhichWeAreTurning > pageBeingDisplayed)
                                {
                                    @try {
                                        for (int swipe = 0; swipe < pageToWhichWeAreTurning - pageBeingDisplayed; swipe++)
                                        {
                                            [(EnterDataView *)[self.dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", pageBeingDisplayed + swipe]] userSwipedToTheLeft];
                                            if (swipe > 0)
                                                [(EnterDataView *)[self.dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", pageBeingDisplayed + swipe]] setSkipThisPage:YES];
                                        }
                                    } @catch (NSException *exception) {
                                        NSLog(@"Could not swipe left for some reason");
                                    } @finally {
                                        //
                                    }
                                }
                                else if (pageBeingDisplayed > pageToWhichWeAreTurning)
                                {
                                    @try {
                                        for (int swipe = 0; swipe < pageBeingDisplayed - pageToWhichWeAreTurning; swipe++)
                                        {
                                            [(EnterDataView *)[self.dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%d", pageBeingDisplayed - swipe]] userSwipedToTheRight];
                                        }
                                    } @catch (NSException *exception) {
                                        NSLog(@"Could not swipe right for some reason");
                                    } @finally {
                                        //
                                    }
                                }
                            }
                        }
                    }
                    else if ([[[[statement uppercaseString] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"DIALOG"])
                    {
                        NSArray *dialogArray = [statement componentsSeparatedByString:@"\""];
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[dialogArray objectAtIndex:3] message:[dialogArray objectAtIndex:1] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        }];
                        [alertC addAction:okAction];
                        [self.rootViewController presentViewController:alertC animated:YES completion:nil];
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
                if (!([newStr isEqualToString:@"<"] && [nsms characterAtIndex:0] == '>') &&
                    !([newStr isEqualToString:@"+"] && [nsms characterAtIndex:0] == ')') &&
                    !([newStr isEqualToString:@"-"] && [nsms characterAtIndex:0] == ')') &&
                    !([newStr isEqualToString:@"("] && [nsms characterAtIndex:0] == '+' && [nsms characterAtIndex:1] == ')') &&
                    !([newStr isEqualToString:@"("] && [nsms characterAtIndex:0] == '-' && [nsms characterAtIndex:1] == ')'))
                    [nsms insertString:@" " atIndex:0];
                id field = [self.dictionaryOfFields objectForKey:newStr];
                if (field)
                {
                    NSString *fieldsControlValue = [field epiInfoControlValue];
                    //
                    // For Legal Values and Comment Legal:
                    // Check if the value begins with a numeral
                    // If so, and it is not a date or entirely a number,
                    // then it needs to be quoted or Check Code will fail
                    if ([field isKindOfClass:[LegalValuesEnter class]])
                    {
                        if ([[NSScanner scannerWithString:[NSString stringWithFormat:@"%c", [fieldsControlValue characterAtIndex:0]]] scanFloat:nil] ||
                            ([fieldsControlValue length] > 1 && [[NSScanner scannerWithString:[NSString stringWithFormat:@"%c%c", [fieldsControlValue characterAtIndex:0], [fieldsControlValue characterAtIndex:1]]] scanFloat:nil]))
                        {
                            bool canBeQuoted = false;
                            NSCharacterSet *justNumbers = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%@0123456789", [[[NSNumberFormatter alloc] init] decimalSeparator]]];
                            NSCharacterSet *controlValueCharacterSet = [NSCharacterSet characterSetWithCharactersInString:fieldsControlValue];
                            NSArray *decimalCounter = [fieldsControlValue componentsSeparatedByString:[[[NSNumberFormatter alloc] init] decimalSeparator]];
                            if (![justNumbers isSupersetOfSet:controlValueCharacterSet] || decimalCounter.count > 2)
                                canBeQuoted = true;
                            NSError *dateCheckError = nil;
                            NSDataDetector *dateDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate error:&dateCheckError];
                            NSUInteger datesinstring = [dateDetector numberOfMatchesInString:fieldsControlValue options:0 range:NSMakeRange(0, [fieldsControlValue length])];
                            if (datesinstring == 1)
                                canBeQuoted = false;
                            if (canBeQuoted)
                                fieldsControlValue = [NSString stringWithFormat:@"%c%@%c", '"', fieldsControlValue, '"'];
                        }
                    }
                    // End of Legal Values leading numeral check
                    //
                    if ([field isKindOfClass:[EpiInfoOptionField class]])
                    {
//                        fieldsControlValue = [NSString stringWithFormat:@"%d", [fieldsControlValue intValue] - 1];
                        if ([fieldsControlValue intValue] < 0)
                            fieldsControlValue = @"";
                    }
                    if ([field isKindOfClass:[NumberField class]])
                    {
                        fieldsControlValue = [fieldsControlValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    }
                    if ([fieldsControlValue componentsSeparatedByString:@" "].count > 1 || [fieldsControlValue componentsSeparatedByString:@"\n"].count > 1)
                        fieldsControlValue = [NSString stringWithFormat:@"\"%@\"", [field epiInfoControlValue]];
                    if (fieldsControlValue.length == 0)
                        fieldsControlValue = @"NULL";
                    [nsms insertString:fieldsControlValue atIndex:0];
                }
                else
                    [nsms insertString:newStr atIndex:0];
            }
        }
        [nsms replaceCharactersInRange:NSMakeRange(nsms.length - 1, 1) withString:@""];
        [nsms replaceOccurrencesOfString:@"(+)" withString:@"\"(+)\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, nsms.length)];
        [nsms replaceOccurrencesOfString:@"(-)" withString:@"\"(-)\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, nsms.length)];
        //NSLog(@"Condition is: %@", nsms);
        ExpressionActionParser *eParser = [[ExpressionActionParser alloc] init];
        NSError *err = nil;
        // ExpressionActionParser BREAKPOINT goes here
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
    [self execute:(id)^{
        
        elseing = NO;
        
    }];

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
