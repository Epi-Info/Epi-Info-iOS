//
//  BoxData.m
//  EpiInfo
//
//  Created by John Copeland on 6/9/20.
//

#import "BoxData.h"
#import "EnterDataView.h"
#import "EpiInfoControlProtocol.h"
#import "YesNo.h"
#import "LegalValuesEnter.h"
#import "EpiInfoOptionField.h"
#import "NumberField.h"
#import "sqlite3.h"
@import BoxContentSDK;

@implementation BoxData

- (id)initWithFormName:(NSString *)fn AndDictionaryOfPages:(NSDictionary *)dop AndNoTwo:(BOOL)no2
{
    self = [super init];
    if (self)
    {
        formName = fn;
        notwo = no2;
        
        NSMutableDictionary *mutableDictionaryOfControls = [[NSMutableDictionary alloc] init];
        NSMutableArray *mutableArrayOfYesNoFieldNames = [[NSMutableArray alloc] init];
        for (NSString *key in dop)
        {
            EnterDataView *tempedv = (EnterDataView *)[dop objectForKey:key];
            for (UIView *v in [[tempedv formCanvas] subviews])
            {
                if ([v conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                {
                    [mutableDictionaryOfControls setObject:v forKey:[(UIView <EpiInfoControlProtocol> *)v columnName]];
                    if ([v isKindOfClass:[YesNo class]])
                        [mutableArrayOfYesNoFieldNames addObject:[[(YesNo *)v columnName] lowercaseString]];
                }
            }
        }
        arrayOfYesNoFieldNames = [NSArray arrayWithArray:mutableArrayOfYesNoFieldNames];
        dictionaryOfControls = [NSDictionary dictionaryWithDictionary:mutableDictionaryOfControls];
    }
    return self;
}

- (BOOL)sendAllRecordsToBox
{
    NSThread *boxThread = [[NSThread alloc] initWithTarget:self selector:@selector(sendAllRecordsToBoxInBackground) object:nil];
    [boxThread start];
    return YES;
}

- (BOOL)sendAllRecordsToBoxInBackground
{
    sqlite3 *epiinfoDB;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select * from %@", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Beginning upload of all %@ records.\n", [NSDate date], formName]];
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    // SEND FOREIGN KEYS TO BOX IF FORM IS A CHILD FORM
                    NSMutableDictionary *boxDictionary = [[NSMutableDictionary alloc] init];
                    if (notwo)
                        [boxDictionary setObject:[NSNumber numberWithInt:1003036077] forKey:@"_updateStamp"];
                    int i = 0;
                    while (sqlite3_column_name(statement, i))
                    {
                        NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                        if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                        {
                            [boxDictionary setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] forKey:@"id"];
                        }
                        else
                        {
                            if (notwo)
                            {
                                if ([arrayOfYesNoFieldNames containsObject:[columnName lowercaseString]])
                                {
                                    int ynvalue = 0;
                                    NSString *ynstringvalue = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                                    if (ynstringvalue)
                                    {
                                        if ([ynstringvalue length] > 0 && ![ynstringvalue containsString:@"null"])
                                        {
                                            ynvalue = 2 - [ynstringvalue intValue];
                                        }
                                    }
                                    [boxDictionary setObject:[NSNumber numberWithInt:ynvalue] forKey:columnName];
                                    i++;
                                    continue;
                                }
                            }
                            NSObject *columnText = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                            if ([(NSString *)columnText isEqualToString:@"(null)"])
                            {
                                i++;
                                continue;
                            }
                            if ([dictionaryOfControls objectForKey:columnName])
                            {
                                UIView *controlForColumn = [dictionaryOfControls objectForKey:columnName];
                                if ([controlForColumn isKindOfClass:[NumberField class]])
                                {
                                    NSDecimalNumber *nsdn = [NSDecimalNumber decimalNumberWithString:(NSString *)columnText];
                                    columnText = nsdn;
                                }
                                else if ([arrayOfYesNoFieldNames containsObject:[columnName lowercaseString]])
                                {
                                    if ([(NSString *)columnText length] > 0)
                                    {
                                        int ynvalue = [(NSString *)columnText intValue];
                                        columnText = [NSNumber numberWithInt:ynvalue];
                                    }
                                }
                                else if ([controlForColumn isKindOfClass:[EpiInfoOptionField class]])
                                {
                                    
                                }
                                else if ([controlForColumn isKindOfClass:[LegalValuesEnter class]])
                                {
                                    NSArray *valuesArray = [(LegalValuesEnter *)controlForColumn listOfStoredValues];
                                    if ([valuesArray containsObject:columnText])
                                    {
                                        unsigned long indexOfObject = [valuesArray indexOfObject:columnText];
                                        columnText = [NSString stringWithFormat:@"%lu", indexOfObject];
                                    }
                                }
                            }
                            [boxDictionary setObject:columnText forKey:columnName];
                        }
                        i++;
                    }
                    // JSON section for Box;
                    NSArray *users = [BOXContentClient users];
                    if ([users count] > 0)
                    {
                        NSError *jerror;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:boxDictionary options:0 error:&jerror];
                        if (jsonData)
                        {
                            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                            NSLog(@"\n%@", jsonString);
                        }
                        else
                        {
                            NSLog(@"%@", jerror);
                        }
                        BOXUser *user0 = [users objectAtIndex:0];
                        BOXContentClient *client0 = [BOXContentClient clientForUser:user0];
                        BOXSearchRequest *searchRequest = [client0 searchRequestWithQuery:@"__EpiInfo" inRange:NSMakeRange(0, 1000)];
                        [searchRequest setType:@"folder"];
                        [searchRequest setContentTypes:@[@"name"]];
                        [searchRequest performRequestWithCompletion:^(NSArray<BOXItem *> *items, NSUInteger totalCount, NSRange range, NSError *error) {
                            if ([items count] > 0)
                            {
                                for (BOXItem *bi in items)
                                {
                                    if ([bi isKindOfClass:[BOXFolder class]])
                                    {
                                        NSString *subfoldername = [NSString stringWithString:formName];
                                        NSString *eiFolderID = [bi modelID];
                                        NSLog(@"folder __EpiInfo exists with ID %@; checking for %@ folder", eiFolderID, subfoldername);
                                        BOXSearchRequest *subfolderSearchRequest = [client0 searchRequestWithQuery:subfoldername inRange:NSMakeRange(0, 1000)];
                                        [subfolderSearchRequest setAncestorFolderIDs:@[eiFolderID]];
                                        [searchRequest setType:@"folder"];
                                        [subfolderSearchRequest setContentTypes:@[@"name"]];
                                        [subfolderSearchRequest performRequestWithCompletion:^(NSArray<BOXItem *> *sitems, NSUInteger totalCount, NSRange range, NSError *error) {
                                            if ([sitems count] > 0)
                                            {
                                                for (BOXItem *bi in sitems)
                                                {
                                                    if ([bi isKindOfClass:[BOXFolder class]])
                                                    {
                                                        NSString *folderID = [bi modelID];
                                                        NSLog(@"folder %@ exists with ID %@; attempting to remove and re-add a file", subfoldername, folderID);
                                                        BOXSearchRequest *fileSearchRequest = [client0 searchRequestWithQuery:[NSString stringWithFormat:@"%@", [boxDictionary objectForKey:@"id"]] inRange:NSMakeRange(0, 1000)];
                                                        [fileSearchRequest setAncestorFolderIDs:@[eiFolderID, folderID]];
                                                        [fileSearchRequest setType:@"file"];
                                                        [fileSearchRequest setFileExtensions:@[@"txt"]];
                                                        [fileSearchRequest setContentTypes:@[@"name"]];
                                                        [fileSearchRequest performRequestWithCompletion:^(NSArray<BOXItem *> *fileitems, NSUInteger totalCount, NSRange range, NSError *error) {
                                                            NSLog(@"Found %lu file(s) with that name.", (unsigned long)totalCount);
                                                            if ([fileitems count] > 0)
                                                            {
                                                                for (BOXItem *bifile in fileitems)
                                                                {
                                                                    if ([bifile isKindOfClass:[BOXFile class]])
                                                                    {
                                                                        BOXFileDeleteRequest *deleteRequest = [client0 fileDeleteRequestWithID:[bifile modelID]];
                                                                        [deleteRequest performRequestWithCompletion:^(NSError *deleteError) {
                                                                            if (deleteError)
                                                                            {
                                                                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: Could not delete existing Box file %@, error %@\n", [NSDate date], [boxDictionary objectForKey:@"id"], deleteError]];
                                                                            }
                                                                            else
                                                                            {
                                                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box delete request finished with file %@, error %@\n", [NSDate date], [boxDictionary objectForKey:@"id"], deleteError]];
                                                                                BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:folderID fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                                                [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                                                    NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                                                } completion:^(BOXFile *file, NSError *error) {
                                                                                    NSLog(@"upload request finished with file %@, error %@", file, error);
                                                                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                                                }];
                                                                            }
                                                                        }];
                                                                    }
                                                                }
                                                            }
                                                            else
                                                            {
                                                                BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:folderID fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                                [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                                    NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                                } completion:^(BOXFile *file, NSError *error) {
                                                                    if (error)
                                                                    {
                                                                        NSDictionary *thing1 = [error.userInfo objectForKey:@"com.box.contentsdk.jsonerrorresponse"];
                                                                        NSDictionary *thing2 = [thing1 objectForKey:@"context_info"];
                                                                        NSDictionary *thing3 = [thing2 objectForKey:@"conflicts"];
                                                                        BOXFileDeleteRequest *deleteRequest = [client0 fileDeleteRequestWithID:[thing3 objectForKey:@"id"]];
                                                                        [deleteRequest performRequestWithCompletion:^(NSError *deleteError) {
                                                                            if (deleteError)
                                                                            {
                                                                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: Could not delete existing Box file %@, error %@\n", [NSDate date], [boxDictionary objectForKey:@"id"], deleteError]];
                                                                            }
                                                                            else
                                                                            {
                                                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box delete request finished with file %@, error %@\n", [NSDate date], [boxDictionary objectForKey:@"id"], deleteError]];
                                                                                BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:folderID fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                                                [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                                                    NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                                                } completion:^(BOXFile *file, NSError *error) {
                                                                                    NSLog(@"upload request finished with file %@, error %@", file, error);
                                                                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                                                }];
                                                                            }
                                                                        }];
                                                                    }
                                                                    else
                                                                    {
                                                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                                    }
                                                                }];
                                                            }
                                                        }];
                                                        break;
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                BOXFolderCreateRequest *folderCreateRequest = [client0 folderCreateRequestWithName:subfoldername parentFolderID:eiFolderID];
                                                [folderCreateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
                                                    if (folder && !error)
                                                    {
                                                        NSLog(@"folder %@ created; attempting to add a file", subfoldername);
                                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder %@ created; attempting to add a file\n", [NSDate date], subfoldername]];
                                                        BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[folder modelID] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                        [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                            NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                        } completion:^(BOXFile *file, NSError *error) {
                                                            NSLog(@"upload request finished with file %@, error %@", file, error);
                                                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                        }];
                                                    }
                                                    else if (error)
                                                    {
                                                        NSDictionary *thing11 = [error.userInfo objectForKey:@"com.box.contentsdk.jsonerrorresponse"];
                                                        NSDictionary *thing12 = [thing11 objectForKey:@"context_info"];
                                                        NSArray *thing13 = [thing12 objectForKey:@"conflicts"];
                                                        NSDictionary *thing14 = [thing13 objectAtIndex:0];
                                                        BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[thing14 objectForKey:@"id"] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                        [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                            NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                        } completion:^(BOXFile *file, NSError *error) {
                                                            if (error)
                                                            {
                                                                NSDictionary *thing1 = [error.userInfo objectForKey:@"com.box.contentsdk.jsonerrorresponse"];
                                                                NSDictionary *thing2 = [thing1 objectForKey:@"context_info"];
                                                                NSDictionary *thing3 = [thing2 objectForKey:@"conflicts"];
                                                                BOXFileDeleteRequest *deleteRequest = [client0 fileDeleteRequestWithID:[thing3 objectForKey:@"id"]];
                                                                [deleteRequest performRequestWithCompletion:^(NSError *deleteError) {
                                                                    if (deleteError)
                                                                    {
                                                                        [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: Could not delete existing Box file %@, error %@\n", [NSDate date], [boxDictionary objectForKey:@"id"], deleteError]];
                                                                    }
                                                                    else
                                                                    {
                                                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box delete request finished with file %@, error %@\n", [NSDate date], [boxDictionary objectForKey:@"id"], deleteError]];
                                                                        BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[thing14 objectForKey:@"id"] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                                        [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                                            NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                                        } completion:^(BOXFile *file, NSError *error) {
                                                                            NSLog(@"upload request finished with file %@, error %@", file, error);
                                                                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                                        }];
                                                                    }
                                                                }];
                                                            }
                                                            else
                                                            {
                                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                            }
                                                        }];
                                                    }
                                                }];
                                            }
                                        }];
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                NSString *subfoldername = [NSString stringWithString:formName];
                                BOXFolderCreateRequest *folderCreateRequest = [client0 folderCreateRequestWithName:@"__EpiInfo" parentFolderID:BOXAPIFolderIDRoot];
                                [folderCreateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
                                    NSLog(@"folder creation request finished with folder %@, error %@", folder, error);
                                    if (folder && !error)
                                    {
                                        NSLog(@"folder %@ created; attempting to add a subfolder", @"__EpiInfo");
                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder %@ created; attempting to add a subfolder\n", [NSDate date], @"__EpiInfo"]];
                                        BOXFolderCreateRequest *folderCreateRequest = [client0 folderCreateRequestWithName:subfoldername parentFolderID:[folder modelID]];
                                        [folderCreateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
                                            if (folder && !error)
                                            {
                                                NSLog(@"folder %@ created; attempting to add a file", subfoldername);
                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder %@ created; attempting to add a file\n", [NSDate date], subfoldername]];
                                                BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[folder modelID] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                    NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                } completion:^(BOXFile *file, NSError *error) {
                                                    NSLog(@"upload request finished with file %@, error %@", file, error);
                                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                }];
                                            }
                                            else if (error)
                                            {
                                                NSDictionary *thing11 = [error.userInfo objectForKey:@"com.box.contentsdk.jsonerrorresponse"];
                                                NSDictionary *thing12 = [thing11 objectForKey:@"context_info"];
                                                NSArray *thing13 = [thing12 objectForKey:@"conflicts"];
                                                NSDictionary *thing14 = [thing13 objectAtIndex:0];
                                                BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[thing14 objectForKey:@"id"] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                    NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                } completion:^(BOXFile *file, NSError *error) {
                                                    NSLog(@"upload request finished with file %@, error %@", file, error);
                                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                }];
                                            }
                                        }];
                                    }
                                    else if (error)
                                    {
                                        NSDictionary *thing1 = [error.userInfo objectForKey:@"com.box.contentsdk.jsonerrorresponse"];
                                        NSDictionary *thing2 = [thing1 objectForKey:@"context_info"];
                                        NSArray *thing3 = [thing2 objectForKey:@"conflicts"];
                                        NSDictionary *thing4 = [thing3 objectAtIndex:0];
                                        BOXFolderCreateRequest *folderCreateRequest = [client0 folderCreateRequestWithName:subfoldername parentFolderID:[thing4 objectForKey:@"id"]];
                                        [folderCreateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
                                            NSLog(@"folder creation request finished with folder %@, error %@", folder, error);
                                            if (folder && !error)
                                            {
                                                NSLog(@"folder %@ created; attempting to add a file", subfoldername);
                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder %@ created; attempting to add a file\n", [NSDate date], subfoldername]];
                                                BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[folder modelID] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                    NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                } completion:^(BOXFile *file, NSError *error) {
                                                    NSLog(@"upload request finished with file %@, error %@", file, error);
                                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                }];
                                            }
                                            else if (error)
                                            {
                                                NSDictionary *thing11 = [error.userInfo objectForKey:@"com.box.contentsdk.jsonerrorresponse"];
                                                NSDictionary *thing12 = [thing11 objectForKey:@"context_info"];
                                                NSArray *thing13 = [thing12 objectForKey:@"conflicts"];
                                                NSDictionary *thing14 = [thing13 objectAtIndex:0];
                                                BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[thing14 objectForKey:@"id"] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                    NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                } completion:^(BOXFile *file, NSError *error) {
                                                    if (error)
                                                    {
                                                        NSDictionary *thing21 = [error.userInfo objectForKey:@"com.box.contentsdk.jsonerrorresponse"];
                                                        NSDictionary *thing22 = [thing21 objectForKey:@"context_info"];
                                                        NSDictionary *thing23 = [thing22 objectForKey:@"conflicts"];
                                                        BOXFileDeleteRequest *deleteRequest = [client0 fileDeleteRequestWithID:[thing23 objectForKey:@"id"]];
                                                        [deleteRequest performRequestWithCompletion:^(NSError *deleteError) {
                                                            if (deleteError)
                                                            {
                                                                [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: Could not delete existing Box file %@, error %@\n", [NSDate date], [boxDictionary objectForKey:@"id"], deleteError]];
                                                            }
                                                            else
                                                            {
                                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box delete request finished with file %@, error %@\n", [NSDate date], [boxDictionary objectForKey:@"id"], deleteError]];
                                                                BOXFileUploadRequest *uploadRequest = [client0 fileUploadRequestToFolderWithID:[thing14 objectForKey:@"id"] fromData:jsonData fileName:[NSString stringWithFormat:@"%@.txt", [boxDictionary objectForKey:@"id"]]];
                                                                [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                                    NSLog(@"totalBytesTransferred, totalBytesExpectedToTransfer: %lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
                                                                } completion:^(BOXFile *file, NSError *error) {
                                                                    NSLog(@"upload request finished with file %@, error %@", file, error);
                                                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                                }];
                                                            }
                                                        }];
                                                    }
                                                    else
                                                    {
                                                        [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box upload request finished with file %@, error %@\n", [NSDate date], file, error]];
                                                    }
                                                }];
                                            }
                                        }];
                                    }
                                }];
                            }
                        }];
                    }
                    sleep(1);
                }
                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Completed upload of all %@ records.\n", [NSDate date], formName]];
            }
        }
    }
    else
        return NO;
    return YES;
}

- (BOOL)retrieveAllRecordsFromBox
{

    NSArray *users = [BOXContentClient users];
    if ([users count] > 0)
    {
        BOXUser *user0 = [users objectAtIndex:0];
        BOXContentClient *client0 = [BOXContentClient clientForUser:user0];
        BOXSearchRequest *searchRequest = [client0 searchRequestWithQuery:@"__EpiInfo" inRange:NSMakeRange(0, 1000)];
        [searchRequest setType:@"folder"];
        [searchRequest setContentTypes:@[@"name"]];
        [searchRequest performRequestWithCompletion:^(NSArray<BOXItem *> *items, NSUInteger totalCount, NSRange range, NSError *error)
        {
            if ([items count] > 0)
            {
                for (BOXItem *bi in items)
                {
                    if ([bi isKindOfClass:[BOXFolder class]])
                    {
                        NSString *subfoldername = [NSString stringWithString:formName];
                        NSString *eiFolderID = [bi modelID];
                        NSLog(@"folder __EpiInfo exists with ID %@; checking for %@ folder", eiFolderID, subfoldername);
                        BOXSearchRequest *subfolderSearchRequest = [client0 searchRequestWithQuery:subfoldername inRange:NSMakeRange(0, 1000)];
                        [subfolderSearchRequest setAncestorFolderIDs:@[eiFolderID]];
                        [searchRequest setType:@"folder"];
                        [subfolderSearchRequest setContentTypes:@[@"name"]];
                        [subfolderSearchRequest performRequestWithCompletion:^(NSArray<BOXItem *> *sitems, NSUInteger totalCount, NSRange range, NSError *error)
                        {
                            if ([sitems count] > 0)
                            {
                                for (BOXItem *bi in sitems)
                                {
                                    if ([bi isKindOfClass:[BOXFolder class]])
                                    {
                                        NSString *folderID = [bi modelID];
                                        NSLog(@"folder %@ exists with ID %@", subfoldername, folderID);
                                        BOXFolderItemsRequest *listAllInFolder = [client0 folderItemsRequestWithID:folderID];
                                        [listAllInFolder performRequestWithCompletion:^(NSArray<BOXItem *> *folderItems, NSError *error)
                                        {
                                            if ([folderItems count] > 0)
                                            {
                                                for (int fi = 0; fi < [folderItems count]; fi++)
                                                {
                                                    NSOutputStream *fileOutputStream = [NSOutputStream outputStreamToMemory];
                                                    BOXFileDownloadRequest *downloadRequest = [client0 fileDownloadRequestWithID:[(BOXFile *)[folderItems objectAtIndex:fi] modelID] toOutputStream:fileOutputStream];
                                                    [downloadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                                                        //
                                                    } completion:^(NSError *error) {
                                                        NSString *jsonString = [fileOutputStream description];
                                                        NSLog(@"%@", jsonString);
                                                        [fileOutputStream open];
                                                        NSData *jsonData = [fileOutputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
                                                        [fileOutputStream close];
                                                        NSError *jserror;
                                                        NSDictionary *boxDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jserror];
                                                        for (NSString *key in boxDictionary)
                                                        {
                                                            //
                                                        }
                                                    }];
                                                }
                                            }
                                            else
                                            {
                                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: No records in Box folder %@.\n", [NSDate date], formName]];
                                            }
                                        }];
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder %@ not found.\n", [NSDate date], formName]];
                            }
                        }];
                        break;
                    }
                }
            }
            else
            {
                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box folder %@ not found.\n", [NSDate date], formName]];
            }
        }];
    }
    return YES;
}

@end
