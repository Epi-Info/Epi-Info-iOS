//
//  BOXFolderDeleteRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderDeleteRequest : BOXRequestWithSharedLinkHeader <BOXBackgroundRequestProtocol>

// NOTE: Both the associateID and requestDirectoryPath values are required for performing the request in the background.

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 */
@property (nonatomic, readwrite, copy) NSString *requestDirectoryPath;

@property (nonatomic, readonly, strong) NSString *folderID;
@property (nonatomic, readwrite, assign) BOOL recursive; // Defaults to YES

// Optional, if nil the folder will get deleted if it exists and deletion is permissable.
// If an etag value is supplied, the folder will only be deleted if the provided etag matches the current value.
@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (instancetype)initWithFolderID:(NSString *)folderID
                     associateID:(NSString *)associateID;

- (instancetype)initWithFolderID:(NSString *)folderID isTrashed:(BOOL)isTrashed;

- (instancetype)initWithFolderID:(NSString *)folderID
                       isTrashed:(BOOL)isTrashed
                     associateID:(NSString *)associateID;

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
