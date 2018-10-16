//
//  EpiInfoLineListView.h
//  EpiInfo
//
//  Created by John Copeland on 5/7/14.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface EpiInfoLineListView : UIView <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSString *formName;
    NSMutableArray *dataLines;
    NSMutableArray *allDataLines;
    NSMutableArray *guids;
    NSMutableArray *allGuids;
    sqlite3 *epiinfoDB;
    BOOL forVHF;
    BOOL forChildForm;
    UITextField *searchField;
    UIView *targetEnterDataView;
}

@property UITableView *tv;

-(id)initWithFrame:(CGRect)frame andFormName:(NSString *)fn;
-(id)initWithFrame:(CGRect)frame andFormName:(NSString *)fn forVHFContactTracing:(BOOL)isVHF;
-(id)initWithFrame:(CGRect)frame andFormName:(NSString *)fn forChildForm:(UIView *)childForm;
@end
