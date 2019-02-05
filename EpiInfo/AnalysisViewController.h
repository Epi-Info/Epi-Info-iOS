//
//  AnalysisViewController.h
//  EpiInfo
//
//  Created by labuser on 3/15/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AWSRuntime/AWSRuntime.h>
//#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AnalysisDataObject.h"
#import "FrequencyObject.h"
#import "TablesObject.h"
#import "EpiInfoScrollView.h"
#import "ZoomView.h"
#import "FrequencyView.h"
#import "TablesView.h"
#import "MeansView.h"
#import "LogisticObject.h"
#import "LogisticView.h"
#import "LinearView.h"
//#import "AWSSimpleDBConnectionInfo.h"
#import "ChooseAnalysisButton.h"
#import "AnalysisList.h"
//#import "AddAWSSimpleDBSchema.h"
#import "FilterButton.h"
#import "AnalysisFilterView.h"
#import "NewVariablesButton.h"
#import "NewVariablesView.h"
#import "SQLiteData.h"
#import "BlurryView.h"
#import "ConfirmDeleteButton.h"
#import "SQLTool.h"

#define ACCESS_KEY_ID                @"AKIAIBI5F4JI26UWTAXQ"
#define SECRET_KEY                   @"3qMcS6KW2IzcWG06k5Kb3lLU7rBRNYz1m02nATtH"
#define CREDENTIALS_ALERT_MESSAGE    @"Please update the AnalysisViewController.h file with your credentials or Token Vending Machine URL."
#define ACCESS_KEY_ID_2              @"AKIAIVE6TVDQRLCT65VQ"
#define SECRET_KEY_2                 @"eDtowshq2ZpXbi3jhXuZxANtaKL2se3mJD9F9Mhj"

@interface AnalysisViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate>
{
    UIButton *customBackButton;
    
    BOOL fourInchPhone;
    
    BOOL currentOrientationPortrait;
    
    ZoomView *zoomingView;
    CGRect zoomongViewInitialFrame;
    
    UILabel *analyzeDataLabel;
    UIButton *setDataSource;
    UILabel *dataSourceLabel;
    UIView *dataSourceBorder;
    
    ChooseAnalysisButton *chooseAnalysis;
    
    UIView *dataTypeList;
    
    UIScrollView *dataSourceList;
    NSDirectoryEnumerator *directoryEnumerator;
    int numberOfFiles;
    float numberOfDataTypes;
    
    AnalysisList *analysisList;
    double availableAnalyses;
    
    AnalysisDataObject *fullDataObject;
    AnalysisDataObject *workingDataObject;
    SQLiteData *sqlData;
    
    FrequencyView *fv;
    TablesView *tv;
    MeansView *mv;
    
    CGSize initialContentSize;
    CGSize initialLandscapeContentSize;
    
//    AmazonSimpleDBClient *sdb;
    NSMutableArray *SimpleDBDomains;
    NSMutableArray *SimpleDBItems;
    
    UIView *schemaList;
    int schema;
    
    FilterButton *filterButton;
    AnalysisFilterView *filterView;
    
    NewVariablesButton *newVariablesButton;
    NewVariablesView *newVariableswView;
    
    sqlite3 *epiinfoDB;
    
    UIButton *datasetButton;
}
- (void)replaceChooseAnalysis;
- (void)setContentSize:(CGSize)size;
- (void)resetContentSize;
- (BOOL)portraitOrientation;
- (CGRect)getZoomingViewFrame;
//- (void)lookupSimpleDBSources;
- (void)setDataSourceEnabled:(BOOL)isEnabled;
-(void)setInitialContentSize:(CGSize)ics;
-(CGSize)getInitialContentSize;
-(void)putViewOnZoomingView:(UIView *)viewToMove;
-(void)putViewOnEpiInfoScrollView:(UIView *)viewToMove;
@end
