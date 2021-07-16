//
//  BoxContentSDKConstants.h
//  BoxContentSDK
//
//  Created on 2/22/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BOX_CONTENT_SDK_IDENTIFIER @"box-content-sdk"
#define BOX_CONTENT_SDK_VERSION @"1.0.14"

// API Resources
extern NSString *const BOXAPIResourceFolders;
extern NSString *const BOXAPIResourceFiles;
extern NSString *const BOXAPIResourceBookmarks;
extern NSString *const BOXAPIResourceSharedItems;
extern NSString *const BOXAPIResourceUsers;
extern NSString *const BOXAPIResourceComments;
extern NSString *const BOXAPIResourceCollections;
extern NSString *const BOXAPIResourceEvents;
extern NSString *const BOXAPIResourceCollaborations;
extern NSString *const BOXAPIResourceSearch;
extern NSString *const BOXAPIResourceMetadataTemplates;
extern NSString *const BOXAPIResourceRecentItems;

// API Metadata Template Scope
typedef NSString *BOXMetadataScope NS_EXTENSIBLE_STRING_ENUM;
extern BOXMetadataScope const BOXAPITemplateScopeGlobal;
extern BOXMetadataScope const BOXAPITemplateScopeEnterprise;

// API Subresources
extern NSString *const BOXAPISubresourceItems;
extern NSString *const BOXAPISubresourceCopy;
extern NSString *const BOXAPISubresourceTrash;
extern NSString *const BOXAPISubresourceContent;
extern NSString *const BOXAPISubresourceComments;
extern NSString *const BOXAPISubresourceVersions;
extern NSString *const BOXAPISubresourceThumnailPNG;
extern NSString *const BOXAPISubresourceCurrent;
extern NSString *const BOXAPISubresourceMetadata;
extern NSString *const BOXAPISubresourceAvatar;

// HTTP Method Names
typedef NSString BOXAPIHTTPMethod;
extern BOXAPIHTTPMethod *const BOXAPIHTTPMethodHEAD;
extern BOXAPIHTTPMethod *const BOXAPIHTTPMethodDELETE;
extern BOXAPIHTTPMethod *const BOXAPIHTTPMethodGET;
extern BOXAPIHTTPMethod *const BOXAPIHTTPMethodOPTIONS;
extern BOXAPIHTTPMethod *const BOXAPIHTTPMethodPOST;
extern BOXAPIHTTPMethod *const BOXAPIHTTPMethodPUT;

// HTTP Header Names
typedef NSString BOXAPIHTTPHeader;
extern BOXAPIHTTPHeader *const BOXAPIHTTPHeaderAuthorization;
extern BOXAPIHTTPHeader *const BOXAPIHTTPHeaderContentType;
extern BOXAPIHTTPHeader *const BOXAPIHTTPHeaderContentLength;
extern BOXAPIHTTPHeader *const BOXAPIHTTPHeaderContentMD5;
extern BOXAPIHTTPHeader *const BOXAPIHTTPHeaderIfMatch;
extern BOXAPIHTTPHeader *const BOXAPIHTTPHeaderIfNoneMatch;
extern BOXAPIHTTPHeader *const BOXAPIHTTPHeaderBoxAPI;
extern BOXAPIHTTPHeader *const BOXAPIHTTPHeaderXRepHints;

// OAuth2 constants
// Authorization code response
extern NSString *const BOXAuthURLParameterAuthorizationStateKey;
extern NSString *const BOXAuthURLParameterAuthorizationCodeKey;
extern NSString *const BOXAuthURLParameterErrorCodeKey;
// token response
extern NSString *const BOXAuthTokenJSONAccessTokenKey;
extern NSString *const BOXAuthTokenJSONRefreshTokenKey;
extern NSString *const BOXAuthTokenJSONExpiresInKey;
// token request
extern NSString *const BOXAuthTokenRequestGrantTypeKey;
extern NSString *const BOXAuthTokenRequestAuthorizationCodeKey;
extern NSString *const BOXAuthTokenRequestRefreshTokenKey;
extern NSString *const BOXAuthTokenRequestClientIDKey;
extern NSString *const BOXAuthTokenRequestClientSecretKey;
extern NSString *const BOXAuthTokenRequestRedirectURIKey;
extern NSString *const BOXAuthTokenRequestDeviceIDKey;
extern NSString *const BOXAuthTokenRequestDeviceNameKey;
extern NSString *const BOXAuthTokenRequestAccessTokenExpiresAtKey;
extern NSString *const BOXAuthTokenRequestRefreshTokenExpiresAtKey;

extern NSString *const BOXAuthTokenRequestGrantTypeAuthorizationCode;
extern NSString *const BOXAuthTokenRequestGrantTypeRefreshToken;

// Auth Delegation
extern NSString *const BOXOAuth2AuthDelegationNewClientKey;

// Notifications
extern NSString *const BOXUserWasLoggedOutDueToErrorNotification;
extern NSString *const BOXAuthOperationDidCompleteNotification;
extern NSString *const BOXFileDownloadCorruptedNotification;
extern NSString *const BOXRefreshTokenSaveToKeychainNotification;

// Private Notifications. No guarantee for future support.
extern NSString *const BOXAccessTokenRefreshDiagnosisNotification;

// Item Types
typedef NSString BOXAPIItemType;
extern BOXAPIItemType *const BOXAPIItemTypeFile;
extern BOXAPIItemType *const BOXAPIItemTypeFolder;
extern BOXAPIItemType *const BOXAPIItemTypeWebLink;
extern BOXAPIItemType *const BOXAPIItemTypeUser;
extern BOXAPIItemType *const BOXAPIItemTypeComment;
extern BOXAPIItemType *const BOXAPIItemTypeCollection;
extern BOXAPIItemType *const BOXAPIItemTypeEvent;
extern BOXAPIItemType *const BOXAPIItemTypeCollaboration;
extern BOXAPIItemType *const BOXAPIItemTypeGroup;
extern BOXAPIItemType *const BOXAPIItemTypeFileVersion;
extern BOXAPIItemType *const BOXAPIItemTypeRecentItem;

// Shared Link Access Levels
typedef NSString BOXSharedLinkAccessLevel;
extern BOXSharedLinkAccessLevel *const BOXSharedLinkAccessLevelOpen;
extern BOXSharedLinkAccessLevel *const BOXSharedLinkAccessLevelCompany;
extern BOXSharedLinkAccessLevel *const BOXSharedLinkAccessLevelCollaborators;

// Collaboration collaborator types
typedef NSString BOXCollaborationCollaboratorType;
extern BOXCollaborationCollaboratorType *const BOXCollaborationCollaboratorTypeUser;
extern BOXCollaborationCollaboratorType *const BOXCollaborationCollaboratorTypeGroup;

// Metadata Types
extern NSString *const BOXMetadataTypeProperties;

typedef NSString BOXMetadataUpdateOperationType;
extern BOXMetadataUpdateOperationType *const BOXMetadataUpdateOperationTypeAdd;
extern BOXMetadataUpdateOperationType *const BOXMetadataUpdateOperationTypeReplace;
extern BOXMetadataUpdateOperationType *const BOXMetadataUpdateOperationTypeRemove;
extern BOXMetadataUpdateOperationType *const BOXMetadataUpdateOperationTypeTest;

extern NSString *const BOXAPIMetadataParameterKeyOp;
extern NSString *const BOXAPIMetadataParameterKeyPath;
extern NSString *const BOXAPIMetadataParameterKeyValue;

// Collaboration Status
typedef NSString BOXCollaborationStatus;
extern BOXCollaborationStatus *const BOXCollaborationStatusAccepted;
extern BOXCollaborationStatus *const BOXCollaborationStatusRejected;
extern BOXCollaborationStatus *const BOXCollaborationStatusPending;

// Collaboration Role
typedef NSString BOXCollaborationRole;
extern BOXCollaborationRole *const BOXCollaborationRoleOwner;
extern BOXCollaborationRole *const BOXCollaborationRoleCoOwner;
extern BOXCollaborationRole *const BOXCollaborationRoleEditor;
extern BOXCollaborationRole *const BOXCollaborationRoleViewerUploader;
extern BOXCollaborationRole *const BOXCollaborationRolePreviewerUploader;
extern BOXCollaborationRole *const BOXCollaborationRoleViewer;
extern BOXCollaborationRole *const BOXCollaborationRolePreviewer;
extern BOXCollaborationRole *const BOXCollaborationRoleUploader;

// Representation Type
typedef NSString BOXRepresentationType;
extern BOXRepresentationType *const BOXRepresentationTypeOriginal;
extern BOXRepresentationType *const BOXRepresentationTypePDF;
extern BOXRepresentationType *const BOXRepresentationTypeMP4;
extern BOXRepresentationType *const BOXRepresentationTypeMP3;
extern BOXRepresentationType *const BOXRepresentationTypePNG;
extern BOXRepresentationType *const BOXRepresentationTypeJPG;
extern BOXRepresentationType *const BOXRepresentationType3D;
extern BOXRepresentationType *const BOXRepresentationTypeFilmstrip;
extern BOXRepresentationType *const BOXRepresentationTypeDASH;
extern BOXRepresentationType *const BOXRepresentationTypeHLS;
extern BOXRepresentationType *const BOXRepresentationTypeCrocodoc;
extern BOXRepresentationType *const BOXRepresentationTypeDICOM;
extern BOXRepresentationType *const BOXRepresentationTypeExtractedText;

// Representations URL Template
extern NSString *const BOXRepresentationTemplateKeyAccessPath;

// Representation Template Value
extern NSString *const BOXRepresentationTemplateValueHLSManifest;

// Representation Status
typedef NSString BOXRepresentationStatus;
extern BOXRepresentationStatus *const BOXRepresentationStatusSuccess;
extern BOXRepresentationStatus *const BOXRepresentationStatusViewable;
extern BOXRepresentationStatus *const BOXRepresentationStatusPending;
extern BOXRepresentationStatus *const BOXRepresentationStatusNone;
extern BOXRepresentationStatus *const BOXRepresentationStatusError;

// Representation Supported Image Formats
// Formats greater than 1024 are rendered on demand, all others are rendered once the file is uploaded to Box.
// JPG 2048, PNG 1024 and PNG 2048 representations not available for video file types
// If the original file is not a square, images requested above 160x160 will retain the file's original aspect ratio.
// JPG avaiable in all sizes, PNG available only in 1024 and 2048

typedef NSString BOXRepresentationImageDimensions;
extern BOXRepresentationImageDimensions *const BOXRepresentationImageDimensionsJPG32;
extern BOXRepresentationImageDimensions *const BOXRepresentationImageDimensionsJPG94;
extern BOXRepresentationImageDimensions *const BOXRepresentationImageDimensionsJPG160;
extern BOXRepresentationImageDimensions *const BOXRepresentationImageDimensionsJPG320;
extern BOXRepresentationImageDimensions *const BOXRepresentationImageDimensions1024;
extern BOXRepresentationImageDimensions *const BOXRepresentationImageDimensions2048;

// Folder upload email access level
typedef NSString BOXFolderUploadEmailAccessLevel;
extern BOXFolderUploadEmailAccessLevel *const BOXFolderUploadEmailAccessLevelOpen;
extern BOXFolderUploadEmailAccessLevel *const BOXFolderUploadEmailAccessLevelCollaborators;

// Item status
typedef NSString BOXItemStatus;
extern BOXItemStatus *const BOXItemStatusActive;
extern BOXItemStatus *const BOXItemStatusTrashed;
extern BOXItemStatus *const BOXItemStatusDeleted;

// Collection keys
extern NSString *const BOXAPICollectionKeyEntries;
extern NSString *const BOXAPICollectionKeyTotalCount;
extern NSString *const BOXAPICollectionKeyNextStreamPosition;

// API Parameter keys
extern NSString *const BOXAPIParameterKeyFields;
extern NSString *const BOXAPIParameterKeyRecursive;
extern NSString *const BOXAPIParameterKeyLimit;
extern NSString *const BOXAPIParameterKeyOffset;
extern NSString *const BOXAPIParameterKeyFileVersion;
extern NSString *const BOXAPIParameterKeyStreamPosition;
extern NSString *const BOXAPIParameterKeyStreamType;
extern NSString *const BOXAPIParameterKeyCreatedAfter;
extern NSString *const BOXAPIParameterKeyCreatedBefore;
extern NSString *const BOXAPIParameterKeyEventType;
extern NSString *const BOXAPIParameterKeyNotify;
extern NSString *const BOXAPIParameterKeyFileExtensions;
extern NSString *const BOXAPIParameterKeyCreatedAtRange;
extern NSString *const BOXAPIParameterKeyUpdatedAtRange;
extern NSString *const BOXAPIParameterKeySizeRange;
extern NSString *const BOXAPIParameterKeyOwnerUserIDs;
extern NSString *const BOXAPIParameterKeyAncestorFolderIDs;
extern NSString *const BOXAPIParameterKeyContentTypes;
extern NSString *const BOXAPIParameterKeyType;
extern NSString *const BOXAPIParameterKeyQuery;
extern NSString *const BOXAPIParameterKeyMDFilter;
extern NSString *const BOXAPIParameterKeyMinWidth;
extern NSString *const BOXAPIParameterKeyMinHeight;
extern NSString *const BOXAPIParameterKeyMaxWidth;
extern NSString *const BOXAPIParameterKeyMaxHeight;
extern NSString *const BOXAPIParameterKeyAvatarType;

// Recent Items Parameter Keys
extern NSString *const BOXAPIParameterKeyNextMarker;
extern NSString *const BOXAPIParameterKeyListType;

extern NSString *const BOXAPIParameterKeyMarker;

// Metadata Parameter Key
extern NSString *const BOXAPIParameterKeyTemplate;
extern NSString *const BOXAPIParameterKeyScope;
extern NSString *const BOXAPIParameterKeyFilter;

// Multipart parameter keys
extern NSString *const BOXAPIMultipartParameterFieldKeyFile;
extern NSString *const BOXAPIMultipartParameterFieldKeyParentID;
extern NSString *const BOXAPIMultipartFormBoundary;

// API object keys
extern NSString *const BOXAPIObjectKeyAccess;
extern NSString *const BOXAPIObjectKeyEffectiveAccess;
extern NSString *const BOXAPIObjectKeyUnsharedAt;
extern NSString *const BOXAPIObjectKeyEmail;
extern NSString *const BOXAPIObjectKeyDownloadCount;
extern NSString *const BOXAPIObjectKeyPreviewCount;
extern NSString *const BOXAPIObjectKeyPermissions;
extern NSString *const BOXAPIObjectKeyPermissionsDownload;
extern NSString *const BOXAPIObjectKeyPermissionsPreview;

extern NSString *const BOXAPIObjectKeyCanDownload;
extern NSString *const BOXAPIObjectKeyCanPreview;
extern NSString *const BOXAPIObjectKeyCanUpload;
extern NSString *const BOXAPIObjectKeyCanComment;
extern NSString *const BOXAPIObjectKeyCanRename;
extern NSString *const BOXAPIObjectKeyCanDelete;
extern NSString *const BOXAPIObjectKeyCanShare;
extern NSString *const BOXAPIObjectKeyCanSetShareAccess;
extern NSString *const BOXAPIObjectKeyCanInviteCollaborator;

extern NSString *const BOXAPIObjectKeyID;
extern NSString *const BOXAPIObjectKeyRank;
extern NSString *const BOXAPIObjectKeyKey;
extern NSString *const BOXAPIObjectKeyDisplayName;
extern NSString *const BOXAPIObjectKeyOptions;
extern NSString *const BOXAPIObjectKeyType;
extern NSString *const BOXAPIObjectKeySequenceID;
extern NSString *const BOXAPIObjectKeyETag;
extern NSString *const BOXAPIObjectKeySHA1;
extern NSString* const BOXAPIObjectKeyWatermarkInfo;
extern NSString *const BOXAPIObjectKeyName;
extern NSString *const BOXAPIObjectKeyCreatedAt;
extern NSString *const BOXAPIObjectKeyModifiedAt;
extern NSString *const BOXAPIObjectKeyExpiresAt;
extern NSString *const BOXAPIObjectKeyInteractedAt;
extern NSString *const BOXAPIObjectKeyContentCreatedAt;
extern NSString *const BOXAPIObjectKeyContentModifiedAt;
extern NSString *const BOXAPIObjectKeyTrashedAt;
extern NSString *const BOXAPIObjectKeyPurgedAt;
extern NSString *const BOXAPIObjectKeyDescription;
extern NSString *const BOXAPIObjectKeySize;
extern NSString *const BOXAPIObjectKeyCommentCount;
extern NSString *const BOXAPIObjectKeyPathCollection;
extern NSString *const BOXAPIObjectKeyCreatedBy;
extern NSString *const BOXAPIObjectKeyModifiedBy;
extern NSString *const BOXAPIObjectKeyOwnedBy;
extern NSString *const BOXAPIObjectKeySharedLink;
extern NSString *const BOXAPIObjectKeyFolderUploadEmail;
extern NSString *const BOXAPIObjectKeyParent;
extern NSString *const BOXAPIObjectKeyItem;
extern NSString *const BOXAPIObjectKeyItemStatus;
extern NSString *const BOXAPIObjectKeyItemCollection;
extern NSString *const BOXAPIObjectKeySyncState;
extern NSString *const BOXAPIObjectKeyURL;
extern NSString *const BOXAPIObjectKeyURLTemplate;
extern NSString *const BOXAPIObjectKeyDownloadURL;
extern NSString *const BOXAPIObjectKeyAuthenticatedDownloadURL;
extern NSString *const BOXAPIObjectKeyVanityURL;
extern NSString *const BOXAPIObjectKeyIsPasswordEnabled;
extern NSString *const BOXAPIObjectKeyLogin;
extern NSString *const BOXAPIObjectKeyRole;
extern NSString *const BOXAPIObjectKeyLanguage;
extern NSString *const BOXAPIObjectKeySpaceAmount;
extern NSString *const BOXAPIObjectKeySpaceUsed;
extern NSString *const BOXAPIObjectKeyMaxUploadSize;
extern NSString *const BOXAPIObjectKeyTrackingCodes;
extern NSString *const BOXAPIObjectKeyCanSeeManagedUsers;
extern NSString *const BOXAPIObjectKeyIsSyncEnabled;
extern NSString *const BOXAPIObjectKeyStatus;
extern NSString *const BOXAPIObjectKeyState;
extern NSString *const BOXAPIObjectKeyCode;
extern NSString *const BOXAPIObjectKeyJobTitle;
extern NSString *const BOXAPIObjectKeyPhone;
extern NSString *const BOXAPIObjectKeyAddress;
extern NSString *const BOXAPIObjectKeyAvatarURL;
extern NSString *const BOXAPIObjectKeyIsExemptFromDeviceLimits;
extern NSString *const BOXAPIObjectKeyIsExemptFromLoginVerification;
extern NSString *const BOXAPIObjectKeyIsDeactivated;
extern NSString *const BOXAPIObjectKeyIsPasswordResetRequired;
extern NSString *const BOXAPIObjectKeyHasCustomAvatar;
extern NSString *const BOXAPIObjectKeyMessage;
extern NSString *const BOXAPIObjectKeyTaggedMessage;
extern NSString *const BOXAPIObjectKeyIsReplyComment;
extern NSString *const BOXAPIObjectKeyLock;
extern NSString *const BOXAPIObjectKeyExtension;
extern NSString *const BOXAPIObjectKeyIsPackage;
extern NSString *const BOXAPIObjectKeyAllowedSharedLinkAccessLevels;
extern NSString *const BOXAPIObjectKeyCollections;
extern NSString *const BOXAPIObjectKeyCollection;
extern NSString *const BOXAPIObjectKeyCollectionMemberships;
extern NSString *const BOXAPIObjectKeyHasCollaborations;
extern NSString *const BOXAPIObjectKeyIsExternallyOwned;
extern NSString *const BOXAPIObjectKeyCanNonOwnersInvite;
extern NSString *const BOXAPIObjectKeyAllowedInviteeRoles;
extern NSString *const BOXAPIObjectKeyDefaultInviteeRole;
extern NSString *const BOXAPIObjectKeyFileVersion;
extern NSString *const BOXAPIObjectKeyVersionNumber;
extern NSString *const BOXAPIObjectKeyTimezone;
extern NSString *const BOXAPIObjectKeyIsExternalCollabRestricted;
extern NSString *const BOXAPIObjectKeyEnterprise;
extern NSString *const BOXAPIObjectKeyIsDownloadPrevented;
extern NSString *const BOXAPIObjectKeySharedLinkPassword;
extern NSString *const BOXAPIObjectKeyCollectionType;
extern NSString *const BOXAPIObjectKeyCollectionRank;
extern NSString *const BOXAPIObjectKeyEventID;
extern NSString *const BOXAPIObjectKeyEventType;
extern NSString *const BOXAPIObjectKeyInteractionSharedLink;
extern NSString *const BOXAPIObjectKeyInteractionType;
extern NSString *const BOXAPIObjectKeySessionID;
extern NSString *const BOXAPIObjectKeySource;
extern NSString *const BOXAPIObjectKeyAcknowledgedAt;
extern NSString *const BOXAPIObjectKeyAccessibleBy;
extern NSString *const BOXAPIObjectKeyEntries;
extern NSString *const BOXAPIObjectKeyIsBoxNotesCreationEnabled;
extern NSString *const BOXAPIObjectKeyRepresentations;
extern NSString *const BOXAPIObjectKeyRepresentation;
extern NSString *const BOXAPIObjectKeyProperties;
extern NSString *const BOXAPIObjectKeyDetails;
extern NSString *const BOXAPIObjectKeyLinks;
extern NSString *const BOXAPIObjectKeyContent;
extern NSString *const BOXAPIObjectKeyInfo;
extern NSString *const BOXAPIObjectKeyDimensions;

// API Metadata Object keys
extern NSString *const BOXAPIMetadataObjectKeyID;
extern NSString *const BOXAPIMetadataObjectKeyType;
extern NSString *const BOXAPIMetadataObjectKeyScope;
extern NSString *const BOXAPIMetadataObjectKeyTemplate;
extern NSString *const BOXAPIMetadataObjectKeyParent;
extern NSString *const BOXAPIMetadataObjectKeyOperation;
extern NSString *const BOXAPIMetadataObjectKeyPath;
extern NSString *const BOXAPIMetadataObjectKeyValue;
extern NSString *const BOXAPIMetadataObjectKeyVersion;
extern NSString *const BOXAPIMetadataObjectKeyTypeVersion;

// API Folder IDs
extern NSString *const BOXAPIFolderIDRoot;
extern NSString *const BOXAPIFolderIDTrash;
// API Collection constants
extern NSString *const BOXAPIFavoritesCollectionType;

// API Events Constants
extern NSString *const BOXAPIEventStreamPositionDefault;

extern NSString *const BOXAPIEventStreamTypeAll;
extern NSString *const BOXAPIEventStreamTypeChanges;
extern NSString *const BOXAPIEventStreamTypeSync;
extern NSString *const BOXAPIEventStreamTypeAdminLogs;

// API Recent Items Constants
extern NSString *const BOXAPIRecentItemsListTypeShared;
extern NSString *const BOXAPIRecentItemsInteractionTypeOpen;
extern NSString *const BOXAPIRecentItemsInteractionTypePreview;
extern NSString *const BOXAPIRecentItemsInteractionTypeComment;
extern NSString *const BOXAPIRecentItemsInteractionTypeModification;
extern NSString *const BOXAPIRecentItemsInteractionTypeUpload;

// Standard Events
extern NSString *const BOXAPIEventTypeItemCreate;
extern NSString *const BOXAPIEventTypeItemUpload;
extern NSString *const BOXAPIEventTypeCommentCreate;
extern NSString *const BOXAPIEventTypeItemDownload;
extern NSString *const BOXAPIEventTypeItemPreview;
extern NSString *const BOXAPIEventTypeItemMove;
extern NSString *const BOXAPIEventTypeItemCopy;
extern NSString *const BOXAPIEventTypeTaskAssignment;
extern NSString *const BOXAPIEventTypeLockCreate;
extern NSString *const BOXAPIEventTypeLockDestroy;
extern NSString *const BOXAPIEventTypeItemTrash;
extern NSString *const BOXAPIEventTypeCollaboratorAdded;
extern NSString *const BOXAPIEventTypeCollaborationInvited;
extern NSString *const BOXAPIEventTypeItemSync;
extern NSString *const BOXAPIEventTypeItemRename;
extern NSString *const BOXAPIEventTypeItemSharedCreate;
extern NSString *const BOXAPIEventTypeItemSharedUnshare;
extern NSString *const BOXAPIEventTypeItemShared;
extern NSString *const BOXAPIEventTypeTagItemCreate;
extern NSString *const BOXAPIEventTypeAddLoginActivityDevice;
extern NSString *const BOXAPIEventTypeRemoveLoginActivityDevice;
extern NSString *const BOXAPIEventTypeChangeAdminRole;

// Enterprise Events
extern NSString *const BOXAPIEnterpriseEventTypeGroupAddUser;
extern NSString *const BOXAPIEnterpriseEventTypeNewUser;
extern NSString *const BOXAPIEnterpriseEventTypeGroupCreation;
extern NSString *const BOXAPIEnterpriseEventTypeGroupDeletion;
extern NSString *const BOXAPIEnterpriseEventTypeDeleteUser;
extern NSString *const BOXAPIEnterpriseEventTypeGroupEdited;
extern NSString *const BOXAPIEnterpriseEventTypeEditUser;
extern NSString *const BOXAPIEnterpriseEventTypeGroupAddFolder;
extern NSString *const BOXAPIEnterpriseEventTypeGroupeRemoveFolder;
extern NSString *const BOXAPIEnterpriseEventTypeItemGroupeRemoveUser;
extern NSString *const BOXAPIEnterpriseEventTypeAdminLogin;
extern NSString *const BOXAPIEnterpriseEventTypeAddDeviceAssociation;
extern NSString *const BOXAPIEnterpriseEventTypeFailedLogin;
extern NSString *const BOXAPIEnterpriseEventTypeLogin;
extern NSString *const BOXAPIEnterpriseEventTypeUserAuthTokenRefresh;
extern NSString *const BOXAPIEnterpriseEventTypeRemoveDeviceAssociation;
extern NSString *const BOXAPIEnterpriseEventTypeTosAgree;
extern NSString *const BOXAPIEnterpriseEventTypeTosReject;
extern NSString *const BOXAPIEnterpriseEventTypeCopy;
extern NSString *const BOXAPIEnterpriseEventTypeDelete;
extern NSString *const BOXAPIEnterpriseEventTypeDownload;
extern NSString *const BOXAPIEnterpriseEventTypeLock;
extern NSString *const BOXAPIEnterpriseEventTypeMove;
extern NSString *const BOXAPIEnterpriseEventTypePreview;
extern NSString *const BOXAPIEnterpriseEventTypeRename;
extern NSString *const BOXAPIEnterpriseEventTypeStorageExpiration;
extern NSString *const BOXAPIEnterpriseEventTypeUndelete;
extern NSString *const BOXAPIEnterpriseEventTypeUnlock;
extern NSString *const BOXAPIEnterpriseEventTypeUpload;
extern NSString *const BOXAPIEnterpriseEventTypeShare;
extern NSString *const BOXAPIEnterpriseEventTypeUpdateShareExpiration;
extern NSString *const BOXAPIEnterpriseEventTypeShareExpiration;
extern NSString *const BOXAPIEnterpriseEventTypeUnshare;
extern NSString *const BOXAPIEnterpriseEventTypeItemAcceptCollaboration;
extern NSString *const BOXAPIEnterpriseEventTypeCollaborationRoleChange;
extern NSString *const BOXAPIEnterpriseEventTypeUpdateCollaborationExpiration;
extern NSString *const BOXAPIEnterpriseEventTypeCollaborationRemove;
extern NSString *const BOXAPIEnterpriseEventTypeCollaborationInvite;
extern NSString *const BOXAPIEnterpriseEventTypeCollaborationExpiration;
extern NSString *const BOXAPIEnterpriseEventTypeItemSync;
extern NSString *const BOXAPIEnterpriseEventTypeItemUnsync;

//urlsessiontask cache dir, file prefix
extern NSString *const BOXURLSessionTaskCacheDirectoryName;
extern NSString *const BOXURLSessionTaskCacheOnGoingSessionTasksDirectoryName;
extern NSString *const BOXURLSessionTaskCacheUsersDirectoryName;
extern NSString *const BOXURLSessionTaskCacheBackgroundSessionsIndexDirectoryName;
extern NSString *const BOXURLSessionTaskCacheExtensionSessionsDirectoryName;
extern NSString *const BOXURLSessionTaskCacheDestinationFilePath;
extern NSString *const BOXURLSessionTaskCacheResumeData;
extern NSString *const BOXURLSessionTaskCacheResponse;
extern NSString *const BOXURLSessionTaskCacheResponseData;
extern NSString *const BOXURLSessionTaskCacheError;
extern NSString *const BOXURLSessionTaskCacheUserIdAndAssociateId;

typedef NS_ENUM(NSUInteger, BOXURLSessionTaskCacheFileType) {
    BOXURLSessionTaskCacheFileTypeDestinationFilePath = 0,
    BOXURLSessionTaskCacheFileTypeResumeData = 1,
    BOXURLSessionTaskCacheFileTypeResponse = 2,
    BOXURLSessionTaskCacheFileTypeResponseData = 3,
    BOXURLSessionTaskCacheFileTypeError = 4,
    BOXURLSessionTaskCacheFileTypeUserIdAndAssociateId = 5
};

typedef NS_ENUM(NSUInteger, BOXThumbnailSize) {
    BOXThumbnailSize32 = 32,
    BOXThumbnailSize64 = 64,
    BOXThumbnailSize128 = 128,
    BOXThumbnailSize256 = 256,
    BOXThumbnailSize1024 = 1024,
    BOXThumbnailSize2048 = 2048,
};

typedef NS_ENUM(NSUInteger, BOXAvatarType) {
    BOXAvatarTypeUnspecified = 0,
    BOXAvatarTypeSmall,
    BOXAvatarTypeLarge,
    BOXAvatarTypePreview
};

/// Some reasonable default values for the X-Rep-Hints header when requesting
/// the representations field of a file or files.
///
/// The exact definition of these values may change between SDK versions, but
/// the semantics will remain.
///
/// For further information, refer to https://developer.box.com/v2.0/reference
typedef NSString *BOXRepresentationHints;
/// Large and small thumbnails (currently JPG thumbnails up to 1024px and 320px
/// on a side, if available)
extern const BOXRepresentationHints BOXRepresentationHintsDefaultThumbnails;
/// A good preview for most file types. Maybe more than one preview representation
/// (currently at least the first available of PDF, HLS, MP4, MP3 or JPG)
extern const BOXRepresentationHints BOXRepresentationHintsDefaultPreview;
/// Both thumbnails and the preview defined above
extern const BOXRepresentationHints BOXRepresentationHintsDefaultThumbnailsandPreview;
