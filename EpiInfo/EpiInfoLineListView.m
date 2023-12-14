//
//  EpiInfoLineListView.m
//  EpiInfo
//
//  Created by John Copeland on 5/7/14.
//

#import "EpiInfoLineListView.h"
#import "DataEntryViewController.h"
#import "VHFViewController.h"
#include <sys/sysctl.h>

@implementation EpiInfoLineListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
        BOOL spanishLanguage = NO;
        if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
            spanishLanguage = YES;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // Add label and tool banner
        UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 36)];
        [banner setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:0.95]];
        [self addSubview:banner];
        
        // Add X-button to banner
        UIButton *xButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 32.0, 2, 30, 30)];
        [xButton setBackgroundColor:[UIColor clearColor]];
        [xButton setImage:[UIImage imageNamed:@"StAndrewXButton.png"] forState:UIControlStateNormal];
        [xButton setTitle:@"Close the form" forState:UIControlStateNormal];
        [xButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [xButton setAlpha:0.5];
        [xButton.layer setMasksToBounds:YES];
        [xButton.layer setCornerRadius:8.0];
        [xButton addTarget:self action:@selector(removeSelfFromSuperview) forControlEvents:UIControlEventTouchUpInside];
//        [banner addSubview:xButton];
        
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = [NSString stringWithUTF8String:machine];
        float lineListNavigationBarY = 0.0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] || [platform isEqualToString:@"iPad2,7"]))
            lineListNavigationBarY = 8.0;
        UINavigationBar *lineListNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, lineListNavigationBarY, banner.frame.size.width, banner.frame.size.height - 4)];
        [lineListNavigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [lineListNavigationBar setShadowImage:[UIImage new]];
        [lineListNavigationBar setTranslucent:YES];
        UINavigationItem *lineListNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        UIBarButtonItem *closeLineListBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(removeSelfFromSuperview)];
        [closeLineListBarButtonItem setAccessibilityLabel:@"Close List"];
        [closeLineListBarButtonItem setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [lineListNavigationItem setRightBarButtonItem:closeLineListBarButtonItem];
        [lineListNavigationBar setItems:[NSArray arrayWithObject:lineListNavigationItem]];
        [banner addSubview:lineListNavigationBar];
        
        // Add search field
        searchField = [[UITextField alloc] initWithFrame:CGRectMake(2, 2, 252, 32)];
        [searchField setBackgroundColor:[UIColor whiteColor]];
//        [searchField addTarget:self action:@selector(searchFieldAction:) forControlEvents:UIControlEventEditingChanged];
        [searchField setReturnKeyType:UIReturnKeyDone];
        [searchField setDelegate:self];
        [searchField setPlaceholder:@"Search"];
        if (spanishLanguage)
            [searchField setPlaceholder:@"Buscar"];
        [banner addSubview:searchField];
        
        // Add label to banner
        float labelOffset = xButton.frame.size.width + 4.0;
        UILabel *formLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelOffset, 0, banner.frame.size.width - 2.0 * labelOffset, banner.frame.size.height)];
        [formLabel setBackgroundColor:[UIColor clearColor]];
        [formLabel setTextColor:[UIColor whiteColor]];
        [formLabel setTextAlignment:NSTextAlignmentCenter];
        [formLabel setText:formName];
//        [banner addSubview:formLabel];
        float fontSize = 32.0;
        if ([formName isEqualToString:@"_VHFContactTracing"])
        {
            [formLabel setText:@"VHF Contact Tracing"];
            fontSize = 24.0;
        }
        while ([formLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]}].width > formLabel.frame.size.width)
            fontSize -= 0.1;
        [formLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]];
        
        // Add the UITableView
        self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, banner.frame.size.height, self.frame.size.width, self.frame.size.height - banner.frame.size.height) style:UITableViewStylePlain];
        [self.tv setDelegate:self];
        [self.tv setDataSource:self];
        [self.tv setSeparatorColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self addSubview:self.tv];
        
        // Get the data and put it into NSMutableArray
        dataLines = [[NSMutableArray alloc] init];
        guids = [[NSMutableArray alloc] init];
//        for (int i=0; i <200; i++)
//            [dataLines addObject:[NSString stringWithFormat:@"Row %d", i]];
        [self getDataFromDatabase];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andFormName:(NSString *)fn;
{
    formName = fn;
    self = [self initWithFrame:frame];
    forVHF = NO;
    return self;
}

- (id)initWithFrame:(CGRect)frame andFormName:(NSString *)fn forVHFContactTracing:(BOOL)isVHF
{
    self = [self initWithFrame:frame andFormName:fn];
    forVHF = YES;
    return self;
}

- (id)initWithFrame:(CGRect)frame andFormName:(NSString *)fn forChildForm:(UIView *)childForm
{
    targetEnterDataView = childForm;
    self = [self initWithFrame:frame andFormName:fn];
    forChildForm = YES;
    targetEnterDataView = childForm;
    return self;
}

- (void)removeSelfFromSuperview
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void)getDataFromDatabase
{
    int columsToDisplay = 4;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        columsToDisplay = 8;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
    {
        NSString *selStmt = [NSString stringWithFormat:@"select * from %@", formName];
        if ([(EnterDataView *)targetEnterDataView parentRecordGUID])
        {
            selStmt = [selStmt stringByAppendingString:[NSString stringWithFormat:@"\nwhere FKEY = '%@'", [(EnterDataView *)targetEnterDataView parentRecordGUID]]];
        }
        
        const char *query_stmt = [selStmt UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int i = 0;
                int j = 0;
                NSString *rowDisplay = @"";
                while (sqlite3_column_name(statement, i))
                {
                    NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                    if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"] || [[columnName lowercaseString] isEqualToString:@"fkey"])
                    {
                        if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                            [guids addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                        i++;
                        continue;
                    }
                    else if ([formName isEqualToString:@"_VHFContactTracing"] && [[columnName lowercaseString] isEqualToString:@"id"])
                    {
                        [guids addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                    }
                    if ([formName isEqualToString:@"_VHFContactTracing"])
                    {
                        if ([[columnName lowercaseString] isEqualToString:@"id"] || [[columnName lowercaseString] isEqualToString:@"dateoflastfollowup"] || [[columnName lowercaseString] isEqualToString:@"status"] || [[columnName lowercaseString] isEqualToString:@"notes"])
                        {
                            if (![[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] isEqualToString:@"(null)"])
                                rowDisplay = [rowDisplay stringByAppendingString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                            rowDisplay = [rowDisplay stringByAppendingString:@" | "];
                        }
                        i++;
                        continue;
                    }
                    else
                    {
                        NSString *stringToAppend = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                        NSNumberFormatter *numFor = [[NSNumberFormatter alloc] init];
                        if ([numFor numberFromString:stringToAppend])
                        {
                            if ([stringToAppend length] > 1)
                            {
                                if ([[stringToAppend substringFromIndex:[stringToAppend length] - 2] isEqualToString:@".0"])
                                {
                                    stringToAppend = [stringToAppend substringToIndex:[stringToAppend length] - 2];
                                }
                            }
                        }
                        rowDisplay = [rowDisplay stringByAppendingString:stringToAppend];
                    }
                    i++;
                    j++;
                    if (j >= columsToDisplay)
                        break;
                    rowDisplay = [rowDisplay stringByAppendingString:@" | "];
                }
                // Code for correcting bad single and double quote characters already in SQLite
                NSMutableArray *eightytwoeighteens = [[NSMutableArray alloc] init];
                for (int i = 0; i < rowDisplay.length; i++)
                {
                    if ([rowDisplay characterAtIndex:i] == 8218)
                        [eightytwoeighteens addObject:[NSNumber numberWithInteger:i]];
                }
                for (int i = (int)eightytwoeighteens.count - 1; i >= 0; i--)
                {
                    NSNumber *num = [eightytwoeighteens objectAtIndex:i];
                    rowDisplay = [rowDisplay stringByReplacingCharactersInRange:NSMakeRange([num integerValue], 1) withString:@""];
                }
                if ([eightytwoeighteens count] > 0)
                {
                    if ([rowDisplay containsString:[NSString stringWithFormat:@"%c%c", '\304', '\364']])
                        rowDisplay = [rowDisplay stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c%c", '\304', '\364'] withString:@"'"];
                    if ([rowDisplay containsString:[NSString stringWithFormat:@"%c%c", '\304', '\371']])
                        rowDisplay = [rowDisplay stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c%c", '\304', '\371'] withString:@"\""];
                }
                //
                [dataLines addObject:rowDisplay];
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(epiinfoDB);
    allDataLines = [NSMutableArray arrayWithArray:dataLines];
    allGuids = [NSMutableArray arrayWithArray:guids];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableIdentifier = @"dataline";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableIdentifier];
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height)];
    }
    
    [cell.textLabel setText:[dataLines objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    
    float fontSize = 16.0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        fontSize = 20.0;
    while ([cell.textLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > cell.frame.size.width - 40.0)
        fontSize -= 0.1;
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataLines count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (forVHF)
    {
        [(VHFViewController *)[self.superview nextResponder] populateFieldsWithRecord:[NSArray arrayWithObjects:formName, (NSString *)[guids objectAtIndex:indexPath.item], nil]];
    }
    else if (forChildForm)
    {
        [(DataEntryViewController *)[self.superview nextResponder] populateFieldsWithRecord:[NSArray arrayWithObjects:formName, (NSString *)[guids objectAtIndex:indexPath.item], nil] OnEnterDataView:targetEnterDataView];
    }
    else
    {
        [(DataEntryViewController *)[self.superview nextResponder] populateFieldsWithRecord:[NSArray arrayWithObjects:formName, (NSString *)[guids objectAtIndex:indexPath.item], nil]];
    }
    [self removeSelfFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        dataLines = [NSMutableArray arrayWithArray:allDataLines];
        guids = [NSMutableArray arrayWithArray:allGuids];
    }
    else
    {
        [dataLines removeAllObjects];
        [guids removeAllObjects];
        int i = 0;
        for (id s in allDataLines)
        {
            if ([[(NSString *)s lowercaseString] containsString:[textField.text lowercaseString]])
            {
                [dataLines addObject:(NSString *)s];
                [guids addObject:[allGuids objectAtIndex:i]];
            }
            i++;
        }
    }
    // Re-Add the UITableView
    CGRect tvFrame = self.tv.frame;
    [self.tv removeFromSuperview];
    self.tv = [[UITableView alloc] initWithFrame:tvFrame style:UITableViewStylePlain];
    [self.tv setDelegate:self];
    [self.tv setDataSource:self];
    [self.tv setSeparatorColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
    [self addSubview:self.tv];
    return [textField resignFirstResponder];
}

- (void)searchFieldAction:(UITextField *)sender
{
    NSLog(@"%@", sender.text);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
