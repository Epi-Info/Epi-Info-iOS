//
//  ChildFormFieldAssignments.h
//  EpiInfo
//
//  Created by John Copeland on 3/11/16.
//

#import <UIKit/UIKit.h>
#import "EnterDataView.h"

@interface ChildFormFieldAssignments : UIButton
+(void)parseForAssignStatements:(NSString *)checkCodeString parentForm:(EnterDataView *)parentForm childForm:(EnterDataView *)childForm relateButtonName:(NSString *)relateButtonName;
@end
