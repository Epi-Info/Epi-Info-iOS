//
//  BOXCollaborationCreateRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"
#import "BOXContentSDKConstants.h"

@interface BOXCollaborationCreateRequest : BOXRequest

@property (nonatomic, readwrite, assign) BOOL shouldNotifyUsers;
@property (nonatomic, readwrite, strong) NSString *userID;
@property (nonatomic, readwrite, strong) NSString *groupID;
@property (nonatomic, readwrite, strong) NSString *login;
@property (nonatomic, readwrite, strong) BOXCollaborationRole *role;

@property (nonatomic, readonly, strong) NSString *itemID;
@property (nonatomic, readonly, strong) BOXAPIItemType *type;

- (instancetype)initWithItemType:(BOXAPIItemType *)type itemID:(NSString *)itemID;

- (void)performRequestWithCompletion:(BOXCollaborationBlock)completionBlock;

@end
