//
//  QRScannerButton.m
//  EpiInfo
//
//  Created by John Copeland on 3/18/20.
//

#import "QRScannerButton.h"

@implementation QRScannerButton
@synthesize viewPreview = _viewPreview;
@synthesize captureSession = _captureSession;
@synthesize videoPreviewLayer = _videoPreviewLayer;

- (void)setControl:(UIView<EpiInfoControlProtocol> *)c
{
    control = c;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundImage:[UIImage imageNamed:@"ScannerIcon.png"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(selfPressed) forControlEvents:UIControlEventTouchUpInside];
        [self setAccessibilityLabel:@"Scan value from Q R code or bar code"];
     }
    return self;
}

- (void)selfPressed
{
    scannerView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x - 90, self.frame.origin.y, 120, 120)];
    
    if (self.frame.origin.y + 120 > [self superview].frame.size.height)
    {
        float subtractor = (self.frame.origin.y + 120) - [self superview].frame.size.height;
        [scannerView setFrame:CGRectMake(scannerView.frame.origin.x, scannerView.frame.origin.y - subtractor, scannerView.frame.size.width, scannerView.frame.size.height)];
    }
    if (self.frame.origin.x < 90)
    {
        float subtractor = self.frame.origin.x - 90;
        [scannerView setFrame:CGRectMake(scannerView.frame.origin.x - subtractor, scannerView.frame.origin.y, scannerView.frame.size.width, scannerView.frame.size.height)];
    }
    
    [scannerView setBackgroundColor:[UIColor cyanColor]];
    [[self superview] addSubview:scannerView];
    self.isReading = NO;
    [self setCaptureSession:nil];
    self.viewPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scannerView.frame.size.width, scannerView.frame.size.height)];
    [self startStopReading];
}

- (void)startStopReading
{
    if (!self.isReading)
    {
        if ([self startReading])
        {
        }
    }
    else
    {
        [self stopReading];
    }
    
    self.isReading = !self.isReading;
}

- (void)stopReading
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    [self.videoPreviewLayer removeFromSuperlayer];
    [self.viewPreview removeFromSuperview];
    
    [scannerView removeFromSuperview];
    scannerView = nil;
}

- (bool)startReading
{
    NSError *error;
    
    [scannerView addSubview:self.viewPreview];
    
    UIButton *stopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, scannerView.frame.size.width, scannerView.frame.size.height)];
    [stopButton setBackgroundColor:[UIColor clearColor]];
    [stopButton addTarget:self action:@selector(stopReading) forControlEvents:UIControlEventTouchDownRepeat];
    [stopButton setAccessibilityLabel:@"Scanner: scan a code or tap four times to remove scanner from screen"];
    [scannerView addSubview:stopButton];
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input)
    {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeEAN13Code, nil]];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.viewPreview.layer.bounds];
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
    [self.captureSession startRunning];
    
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode] || [[metadataObj type] isEqualToString:AVMetadataObjectTypeUPCECode] || [[metadataObj type] isEqualToString:AVMetadataObjectTypeEAN13Code])
        {
            [self performSelectorOnMainThread:@selector(setControlValue:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            self.isReading = NO;
        }
    }
}

- (void)setControlValue:(NSString *)cv
{
    [control assignValue:cv];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
