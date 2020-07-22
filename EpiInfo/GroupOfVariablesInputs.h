//
//  GroupOfVariablesInputs.h
//  EpiInfo
//
//  Created by John Copeland on 11/15/19.
//

#import "NewVariableInputs.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupOfVariablesInputs : NewVariableInputs <UITableViewDelegate, UITableViewDataSource>
{
    UILabel *variablesListLabel;
    LegalValuesEnter *variablesListLVE;
    NSMutableArray *arrayOfVariablesInGroup;
    UITableView *variablesInGroupUITV;
}
@end

NS_ASSUME_NONNULL_END
