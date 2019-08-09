//
//  IfBuilder.m
//  EpiInfo
//
//  Created by John Copeland on 5/16/19.
//

#import "IfBuilder.h"
#import "CheckCodeWriter.h"
#import "PageCheckCodeWriter.h"
#import "FormDesigner.h"
#import "ExistingFunctionsListView.h"
#import "ConditionText.h"
#import "ThenText.h"
#import "ElseText.h"

@implementation IfBuilder

- (void)setFormDesignerCheckCodeStrings:(NSMutableArray *)fdccs
{
    formDesignerCheckCodeStrings = fdccs;
}

- (void)setDeletedIfBlocks:(NSMutableArray *)dib
{
    deletedIfBlocks = dib;
}

- (void)addAfterFunction:(NSString *)function
{
    [(CheckCodeWriter *)ccWriter addAfterFunction:function];
}
- (void)addBeforeFunction:(NSString *)function
{
    [(CheckCodeWriter *)ccWriter addBeforeFunction:function];
}
- (void)addClickFunction:(NSString *)function
{
    [(CheckCodeWriter *)ccWriter addClickFunction:function];
}

- (id)initWithFrame:(CGRect)frame AndCallingButton:(nonnull UIButton *)cb
{
    self = [super initWithFrame:frame];
    if (self)
    {
        callingButton = cb;
        ccWriter = [[callingButton superview] superview];
        formDesigner = [ccWriter superview];
        existingFunctions = NO;
        
        if ([[cb.layer valueForKey:@"BeforeAfter"] isEqualToString:@"After"])
        {
            if ([[(CheckCodeWriter *)ccWriter afterFunctions] count] > 0)
            {
                existingFunctions = YES;
                existingFunctionsArray = [(CheckCodeWriter *)ccWriter afterFunctions];
            }
        }
        else if ([[cb.layer valueForKey:@"BeforeAfter"] isEqualToString:@"Before"])
        {
            if ([[(CheckCodeWriter *)ccWriter beforeFunctions] count] > 0)
            {
                existingFunctions = YES;
                existingFunctionsArray = [(CheckCodeWriter *)ccWriter beforeFunctions];
            }
        }
        else if ([[cb.layer valueForKey:@"BeforeAfter"] isEqualToString:@"Click"])
        {
            if ([[(CheckCodeWriter *)ccWriter clickFunctions] count] > 0)
            {
                existingFunctions = YES;
                existingFunctionsArray = [(CheckCodeWriter *)ccWriter clickFunctions];
            }
        }
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        float textAreaHeight = 96.0;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 32)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [titleLabel setText:@"IF-THEN-ELSE Builder"];
        [self addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, frame.size.width, 32)];
        [subtitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [subtitleLabel setTextAlignment:NSTextAlignmentCenter];
        [subtitleLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [subtitleLabel setText:[NSString stringWithFormat:@"%@ %@", [cb.layer valueForKey:@"BeforeAfter"], [(CheckCodeWriter *)ccWriter beginFieldString]]];
        [self addSubview:subtitleLabel];
        
        ifConditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, frame.size.width, 32)];
        [ifConditionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [ifConditionLabel setTextAlignment:NSTextAlignmentLeft];
        [ifConditionLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [ifConditionLabel setText:@"\tIF Condition:"];
        [self addSubview:ifConditionLabel];
        
        ifConditionText = [[UITextView alloc] initWithFrame:CGRectMake(4, ifConditionLabel.frame.origin.y + ifConditionLabel.frame.size.height, ifConditionLabel.frame.size.width - 8, textAreaHeight)];
        [ifConditionText.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
        [ifConditionText.layer setBorderWidth:1.0];
        [ifConditionText setClipsToBounds:YES];
        [self addSubview:ifConditionText];
        
        UIButton *ifConditionButton = [[UIButton alloc] initWithFrame:ifConditionText.frame];
        [ifConditionButton setBackgroundColor:[UIColor clearColor]];
        [ifConditionButton addTarget:self action:@selector(ifConditionTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ifConditionButton];
        
        thenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ifConditionText.frame.origin.y + ifConditionText.frame.size.height, frame.size.width, 32)];
        [thenLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [thenLabel setTextAlignment:NSTextAlignmentLeft];
        [thenLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [thenLabel setText:@"\tTHEN:"];
        [self addSubview:thenLabel];
        
        thenText = [[UITextView alloc] initWithFrame:CGRectMake(4, thenLabel.frame.origin.y + thenLabel.frame.size.height, thenLabel.frame.size.width - 8, textAreaHeight)];
        [thenText.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
        [thenText.layer setBorderWidth:1.0];
        [thenText setClipsToBounds:YES];
        [self addSubview:thenText];
        
        UIButton *thenButton = [[UIButton alloc] initWithFrame:thenText.frame];
        [thenButton setBackgroundColor:[UIColor clearColor]];
        [thenButton addTarget:self action:@selector(thenTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:thenButton];
        
        elseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, thenText.frame.origin.y + thenText.frame.size.height, frame.size.width, 32)];
        [elseLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [elseLabel setTextAlignment:NSTextAlignmentLeft];
        [elseLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [elseLabel setText:@"\tELSE:"];
        [self addSubview:elseLabel];
        
        elseText = [[UITextView alloc] initWithFrame:CGRectMake(4, elseLabel.frame.origin.y + elseLabel.frame.size.height, elseLabel.frame.size.width - 8, textAreaHeight)];
        [elseText.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
        [elseText.layer setBorderWidth:1.0];
        [elseText setClipsToBounds:YES];
        [self addSubview:elseText];
        
        UIButton *elseButton = [[UIButton alloc] initWithFrame:elseText.frame];
        [elseButton setBackgroundColor:[UIColor clearColor]];
        [elseButton addTarget:self action:@selector(elseTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:elseButton];

        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                          self.frame.size.height - 40,
                                                                          self.frame.size.width / 4.0,
                                                                          32)];
        [saveButton setBackgroundColor:[UIColor whiteColor]];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [saveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [saveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [saveButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4.0,
                                                                           self.frame.size.height - 40,
                                                                           self.frame.size.width / 4.0,
                                                                           32)];
        [closeButton setBackgroundColor:[UIColor whiteColor]];
        [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        existingFunctionsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0,
                                                                             self.frame.size.height - 40,
                                                                             self.frame.size.width / 4.0,
                                                                             32)];
        [existingFunctionsButton setBackgroundColor:[UIColor whiteColor]];
        [existingFunctionsButton setTitle:@"Edit" forState:UIControlStateNormal];
        [existingFunctionsButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [existingFunctionsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [existingFunctionsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [existingFunctionsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [existingFunctionsButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(3.0 * self.frame.size.width / 4.0,
                                                                  self.frame.size.height - 40,
                                                                  self.frame.size.width / 4.0,
                                                                  32)];
        [deleteButton setBackgroundColor:[UIColor whiteColor]];
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [deleteButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [deleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [deleteButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (existingFunctions)
        {
            for (NSString *s in existingFunctionsArray)
            {
                if ([s containsString:@"END-IF"])
                {
                    [existingFunctionsButton setTag:4384363573];
                    [self addSubview:existingFunctionsButton];
                    break;
                }
            }
        }
    }
    return self;
}

- (void)closeButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[sender superview] setFrame:CGRectMake([sender superview].frame.origin.x, -[sender superview].frame.size.height, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
        [[sender superview] removeFromSuperview];
    }];

    if ([[[sender titleLabel] text] isEqualToString:@"Cancel"])
    {
        if (functionBeingEdited != nil)
            if ([functionBeingEdited length] > 0)
                if (![existingFunctionsArray containsObject:functionBeingEdited])
                    [existingFunctionsArray addObject:functionBeingEdited];
        return;
    }
    else if ([[[sender titleLabel] text] isEqualToString:@"Delete"])
    {
        if (!deletedIfBlocks)
            deletedIfBlocks = [[NSMutableArray alloc] init];
        [deletedIfBlocks addObject:functionBeingEdited];
        return;
    }
    
    if ([[ifConditionText text] length] > 0 && [[thenText text] length] > 0)
    {
        NSMutableString *ifStatement = [NSMutableString stringWithFormat:@"IF %@ THEN&#xA;&#x9;&#x9;&#x9;%@", [ifConditionText text], [thenText text]];
        if ([[elseText text] length] > 0)
        {
            [ifStatement appendFormat:@"&#xA;&#x9;&#x9;ELSE&#xA;&#x9;&#x9;&#x9;%@", [elseText text]];
        }
        [ifStatement appendString:@"&#xA;&#x9;&#x9;END-IF"];
        NSLog(@"%@", ifStatement);
        if ([deletedIfBlocks containsObject:ifStatement])
            [deletedIfBlocks removeObject:ifStatement];
        if ([callingButton.layer valueForKey:@"BeforeAfter"])
        {
            NSString *ba = [callingButton.layer valueForKey:@"BeforeAfter"];
            if ([ba isEqualToString:@"After"])
            {
                [self addAfterFunction:ifStatement];
            }
            else if ([ba isEqualToString:@"Before"])
            {
                [self addBeforeFunction:ifStatement];
            }
            else if ([ba isEqualToString:@"Click"])
            {
                [self addClickFunction:ifStatement];
            }
        }
    }
}

- (void)editButtonPressed:(UIButton *)sender
{
    NSMutableArray *relevantFunctionsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [existingFunctionsArray count]; i++)
            if ([(NSString *)[existingFunctionsArray objectAtIndex:i] containsString:@"IF "])
            {
                [relevantFunctionsArray addObject:[existingFunctionsArray objectAtIndex:i]];
//                [relevantFunctionsArray addObject:[[[existingFunctionsArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"&#xA;" withString:@"\n"] stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""]];
            }
    ExistingFunctionsListView *eflv = [[ExistingFunctionsListView alloc] initWithFrame:CGRectMake(0,
                                                                                                  -self.frame.size.height,
                                                                                                  self.frame.size.width,
                                                                                                  self.frame.size.height)
                                                                     AndFunctionsArray:relevantFunctionsArray
                                                                             AndSender:sender];
    [self addSubview:eflv];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [eflv setFrame:CGRectMake(0, 0, eflv.frame.size.width, eflv.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)ifConditionTouched:(UIButton *)sender
{
    ConditionText *span = [[ConditionText alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                                          -[sender superview].frame.size.height,
                                                                          [sender superview].frame.size.width,
                                                                          [sender superview].frame.size.height)
                                              AndCallingButton:sender];
    [span setDestinationOfText:ifConditionText];
    [span setText:[ifConditionText text]];
    	
    [[sender superview] addSubview:span];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [span setFrame:CGRectMake(0, 0, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)thenTouched:(UIButton *)sender
{
    ThenText *span = [[ThenText alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                                          -[sender superview].frame.size.height,
                                                                          [sender superview].frame.size.width,
                                                                          [sender superview].frame.size.height)
                                              AndCallingButton:sender];
    [span setDestinationOfText:thenText];
    [span setText:[thenText text]];
    
    [[sender superview] addSubview:span];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [span setFrame:CGRectMake(0, 0, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)elseTouched:(UIButton *)sender
{
    ElseText *span = [[ElseText alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                                -[sender superview].frame.size.height,
                                                                [sender superview].frame.size.width,
                                                                [sender superview].frame.size.height)
                                    AndCallingButton:sender];
    [span setDestinationOfText:elseText];
    [span setText:[elseText text]];
    
    [[sender superview] addSubview:span];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [span setFrame:CGRectMake(0, 0, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)loadFunctionToEdit:(NSString *)function
{
    [self addSubview:deleteButton];
    functionBeingEdited = [NSString stringWithString:function];
    [existingFunctionsArray removeObject:functionBeingEdited];
//    NSArray *tokens = [function componentsSeparatedByString:@"\n"];
    NSString *ifConditionString = @"";
    NSString *thenString = @"";
    NSString *elseString = @"";
    if ([function containsString:@"IF "] && [function containsString:@" THEN&#xA;"])
    {
        int ifLoc = (int)[function rangeOfString:@"IF "].location;
        int thenLoc = (int)[function rangeOfString:@" THEN&#xA;"].location;
        NSRange ifThenRange = NSMakeRange(ifLoc + 3, thenLoc - (ifLoc + 3));
        ifConditionString = [[[[function substringWithRange:ifThenRange]
                              stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"]
                             stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]
                            stringByReplacingOccurrencesOfString:@" &amp; " withString:@" & "];
        if ([[function uppercaseString] containsString:@"END-IF"])
        {
            int endIfLoc = (int)[function rangeOfString:@"END-IF"].location;
            if ([function containsString:@"ELSE&#xA;"])
            {
                int elseLoc = (int)[function rangeOfString:@"ELSE&#xA;"].location;
                NSRange elseRange = NSMakeRange(elseLoc + 9, endIfLoc - (elseLoc + 9));
                elseString = [[[[[[function substringWithRange:elseRange]
                                  stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"]
                                 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]
                                stringByReplacingOccurrencesOfString:@"&#xA;" withString:@"\n"]
                               stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""]
                              stringByReplacingOccurrencesOfString:@" &amp; " withString:@" & "];
                NSRange thenRange = NSMakeRange(thenLoc + 10, elseLoc - (thenLoc + 10));
                thenString = [[[[[[function substringWithRange:thenRange]
                                  stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"]
                                 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]
                                stringByReplacingOccurrencesOfString:@"&#xA;" withString:@"\n"]
                               stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""]
                              stringByReplacingOccurrencesOfString:@" &amp; " withString:@" & "];
            }
            else
            {
                NSRange thenRange = NSMakeRange(thenLoc + 10, endIfLoc - (thenLoc + 10));
                thenString = [[[[[[function substringWithRange:thenRange]
                                  stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"]
                                 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]
                                stringByReplacingOccurrencesOfString:@"&#xA;" withString:@"\n"]
                               stringByReplacingOccurrencesOfString:@"&#x9;" withString:@""]
                              stringByReplacingOccurrencesOfString:@" &amp; " withString:@" & "];
            }
        }
    }

    @try {
        [ifConditionText setText:ifConditionString];
        [thenText setText:thenString];
        [elseText setText:elseString];
    } @catch (NSException *exception) {
    } @finally {
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
