//
//  EpiInfoLineListView.h
//  EpiInfo
//
//  Created by John Copeland on 5/7/14.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface EpiInfoLineListView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *formName;
    NSMutableArray *dataLines;
    NSMutableArray *guids;
    sqlite3 *epiinfoDB;
    BOOL forVHF;
}

@property UITableView *tv;

-(id)initWithFrame:(CGRect)frame andFormName:(NSString *)fn;
-(id)initWithFrame:(CGRect)frame andFormName:(NSString *)fn forVHFContactTracing:(BOOL)isVHF;
@end
