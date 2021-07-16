//
//  BOXAPIMultipartToJSONOperation.h
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIJSONOperation.h"
#import "BOXURLRequestSerialization.h"

typedef void (^BOXAPIMultipartProgressBlock)(unsigned long long totalBytes, unsigned long long bytesSent);

/**
 * BOXAPIMultipartToJSONOperation is an authenticated API operation that sends data
 * encoded as multipart form data and receives a JSON response. This operation is used
 * for uploading files to the Box API. Multipart data is streamed to the Box API, which
 * allows large files to be uploaded directly from disk without running out of memory.
 *
 * The implementation of this class is based on [RFC 1876](http://tools.ietf.org/rfc/rfc1867.txt).
 *
 * Each section of the multipart form data is encapsulated as a single piece. Body data passed in through
 * the designated initializer is converted to multipart pieces. You may append arbitrary data as multipart pieces.
 * Each piece is isolated from others in the request using multipart form boundaries.
 *
 * Callbacks and typedefs
 * ======================
 * This operation defines a new callback type for upload progress callbacks:
 *
 * <pre><code>typedef void (^BOXAPIMultipartProgressBlock)(unsigned long long totalBytes, unsigned long long bytesSent);</code></pre>
 *
 * @warning Because BOXAPIMultipartToJSONOperation holds references to `NSStream`s, it cannot be copied. Because it
 * cannot be copied, BOXAPIMultipartToJSONOperation instances cannot be automatically retried by the SDK in the event
 * of an expired access token. In this case, the operation will fail with error code
 * `BoxContentSDKAuthErrorAccessTokenExpiredOperationCannotBeReenqueued`.
 *
 * BOXAPIMultipartToJSONOperation supports both foreground and background uploads
 * By default, upload is foreground unless associateId and uploadMultipartCopyFilePath properties are provided
 */
@interface BOXAPIMultipartToJSONOperation : BOXAPIJSONOperation <NSStreamDelegate, BOXURLSessionUploadTaskDelegate>

/**
 * Location to write a multi-part formatted file of the uploaded content into for background upload
 * If nil, upload will be a non-background upload. For background upload, also make sure to have a valid associateId as well
 */
@property (nonatomic, readwrite, strong) NSString *uploadMultipartCopyFilePath;

/** @name Callbacks */

/**
 * progressBlock is called every time data is successfully written to the network connection's
 * HTTPBodyStream.
 */
@property (nonatomic, readwrite, strong) BOXAPIMultipartProgressBlock progressBlock;

/** @name Multipart data handling */

/**
 * The length in bytes of the complete multipart form data encoded body.
 */
- (unsigned long long)contentLength;

/**
 * Append the contents of file at filePath as a multipart piece in the multipart form data. Data will be
 * attached with a Content-Disposition header derived from fieldName and filename.
 *
 * @param filePath  Location of a file, whose content to be included in the body of this multipart piece.
 * @param fieldName The value of the name component of the Content-Disposition header for this piece.
 * @param filename  If this piece is a file, the value of the filename parameter of the Content-Disposition
 *   header for this piece. filename should only be provided if this piece represents a file upload. Pass nil
 *   otherwise.
 * @param MIMEType  The MIME type of the provided data. This value will be included in this piece's Content-Type
 *   header. MIMEType is optional. Pass nil if you do not wish to provide it.
 */
- (void)appendMultipartPieceWithFilePath:(NSString *)filePath fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType;
/**
 * Append the contents of data as a multipart piece in the multipart form data. Data will be
 * attached with a Content-Disposition header derived from fieldName and filename.
 *
 * @param data The data to include in the body of this multipart piece.
 * @param fieldName The value of the name component of the Content-Disposition header for this piece.
 * @param filename If this piece is a file, the value of the filename parameter of the Content-Disposition
 *   header for this piece. filename should only be provided if this piece represents a file upload. Pass nil
 *   otherwise.
 * @param MIMEType The MIME type of the provided data. This value will be included in this piece's Content-Type
 *   header. MIMEType is optional. Pass nil if you do not wish to provide it.
 */
- (void)appendMultipartPieceWithData:(NSData *)data fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType;

/**
 * Append the contents of inputStream as a multipart piece in the multipart form data. Data will be
 * attached with a Content-Disposition header derived from fieldName and filename.
 *
 * The inputStream is never buffered. It is read incrementally and immediately streamed to this
 * operation's network connection.
 *
 * @param inputStream A stream containing the data to include in the body of this multipart piece.
 * @param length The length in bytes of the data backing inputStream. This parameter is required
 *   to correctly compute contentLength. If this value is incorrect, the multipart form data may be truncated.
 * @param fieldName The value of the name component of the Content-Disposition header for this piece.
 * @param filename If this piece is a file, the value of the filename parameter of the Content-Disposition
 *   header for this piece. filename should only be provided if this piece represents a file upload. Pass nil
 *   otherwise.
 * @param MIMEType The MIME type of the provided data. This value will be included in this piece's Content-Type
 *   header. MIMEType is optional. Pass nil if you do not wish to provide it.
 */
- (void)appendMultipartPieceWithInputStream:(NSInputStream *)inputStream contentLength:(unsigned long long)length fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType;

/**
 * Initialize the streams used for writing to the connection's input stream, finalize the HTTP headers
 * for the request, notably Content-Length, and set the connection's HTTPBodyStream.
 *
 * @see [BOXAPIAuthenticatedOperation prepareAPIRequest]
 */
- (void)prepareAPIRequest;

/** @name Overridden methods */

/**
 * Override this method to turn it into a NO-OP. The multipart operation will attach itself
 * to the request with a stream
 *
 * @param bodyDictionary This dictionary should already be attached to the request as a multipart piece
 *
 * @return nil
 */
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary;

@end
