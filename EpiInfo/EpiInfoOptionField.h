//
//  EpiInfoOptionField.h
//  EpiInfo
//
//  Created by John Copeland on 6/2/14.
//

#import "LegalValuesEnter.h"

@interface EpiInfoOptionField : LegalValuesEnter <UITableViewDelegate, UITableViewDataSource>
@property UITableView *oftv;
@end
