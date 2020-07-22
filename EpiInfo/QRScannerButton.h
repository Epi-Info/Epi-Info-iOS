//
//  QRScannerButton.h
//  EpiInfo
//
//  Created by John Copeland on 3/18/20.
//

#import <UIKit/UIKit.h>
#include "EpiInfoControlProtocol.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRScannerButton : UIButton <AVCaptureMetadataOutputObjectsDelegate>
{
    UIView<EpiInfoControlProtocol> *control;
    UIView *scannerView;
}
@property BOOL isReading;
@property UIView *viewPreview;
@property (nonatomic, strong, nullable) AVCaptureSession *captureSession;
@property (nonatomic, strong, nullable) AVCaptureVideoPreviewLayer *videoPreviewLayer;
-(void)setControl:(UIView<EpiInfoControlProtocol> *)c;
@end

NS_ASSUME_NONNULL_END
