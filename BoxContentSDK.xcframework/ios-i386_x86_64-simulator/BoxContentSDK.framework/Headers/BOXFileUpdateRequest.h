//
//  BOXFileUpdateRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileUpdateRequest : BOXRequestWithSharedLinkHeader <BOXBackgroundRequestProtocol>

@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readwrite, strong) NSString *fileName;
@property (nonatomic, readwrite, strong) NSString *fileDescription;
@property (nonatomic, readwrite, strong) NSString *parentID;

@property (nonatomic, readwrite, strong) BOXSharedLinkAccessLevel *sharedLinkAccessLevel;
@property (nonatomic, readwrite, strong) NSDate *sharedLinkExpirationDate;
@property (nonatomic, readwrite, assign) BOOL sharedLinkPermissionCanDownload;
@property (nonatomic, readwrite, assign) BOOL sharedLinkPermissionCanPreview;

@property (nonatomic, readwrite, strong) NSString *matchingEtag;

@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

// NOTE: Both the associateID and requestDirectoryPath values are required for performing the request in the background.

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, strong) NSString *requestDirectoryPath;

- (instancetype)initWithFileID:(NSString *)fileID;
- (instancetype)initWithFileID:(NSString *)fileID associateID:(NSString *)associateID;

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

@end
