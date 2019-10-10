//
//  NewVariablesView.h
//  EpiInfo
//
//  Created by John Copeland on 8/9/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SQLiteData.h"
#import "ShinyButton.h"
#import "DataManagementView.h"
#import "LegalValuesEnter.h"

@interface NewVariablesView : DataManagementView <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UITextField *newVariableName;
    LegalValuesEnter *selectVariableType;
    LegalValuesEnter *selectFunction;

    NSMutableArray *listOfNewVariables;
    UITableView *newVariableList;
}
- (id)initWithViewController:(UIViewController *)vc;
- (id)initWithViewController:(UIViewController *)vc AndSQLiteData:(SQLiteData *)sqliteData;
@end
