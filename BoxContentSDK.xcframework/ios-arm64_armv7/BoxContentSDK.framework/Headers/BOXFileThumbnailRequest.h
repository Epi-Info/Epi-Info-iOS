//
//  BOXFileThumbnailRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileThumbnailRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readonly, strong) NSString *destinationPath;
@property (nonatomic, readwrite, strong) NSNumber *minHeight;
@property (nonatomic, readwrite, strong) NSNumber *minWidth;
@property (nonatomic, readwrite, strong) NSNumber *maxHeight;
@property (nonatomic, readwrite, strong) NSNumber *maxWidth;

- (instancetype)initWithFileID:(NSString *)fileID;

- (instancetype)initWithFileID:(NSString *)fileID localDestination:(NSString *)destinationPath;

- (instancetype)initWithFileID:(NSString *)fileID size:(BOXThumbnailSize)size;

- (instancetype)initWithFileID:(NSString *)fileID size:(BOXThumbnailSize)size localDestination:(NSString *)destinationPath;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock
                        completion:(BOXImageBlock)completionBlock;

@end
