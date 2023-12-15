//
//  SQLTool.h
//  EpiInfo
//
//  Created by John Copeland on 4/4/16.
//

#import <UIKit/UIKit.h>
#import "SQLiteData.h"
#import "AnalysisDataObject.h"

@interface SQLTool : UIScrollView <UITextViewDelegate>
{
    BOOL spanishLanguage;
    UIView *sqlStatementFieldBackground;
    UITextView *sqlStatementField;
    float initialHeight;
    
    UIView *results;
    
    sqlite3 *epiinfoDB;
    
    UISwipeGestureRecognizer *downRecognizer;
    
    UIScrollView *instructionsView;
    
    NSMutableArray *recentSubmissions;
    int recentSubmissionsIndex;
}
@end
