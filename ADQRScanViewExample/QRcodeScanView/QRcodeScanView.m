//
//  QRcodeScanView.m
//  TestCode
//
//  Created by bjwltiankong on 15/9/22.
//  Copyright © 2015年 bjwltiankong. All rights reserved.
//

#import "QRcodeScanView.h"
#import <AVFoundation/AVFoundation.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kScanViewBackgroundColor RGBCOLOR(78, 78, 79)
#define kBackgroundOpacity 0.8

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface QRcodeScanView()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, weak) UIImageView *scanView;
/**是否已经设置背景*/
@property (nonatomic, assign)  BOOL previewBackgroundSetted;

/**遮盖背景图层*/
@property (nonatomic, strong) CALayer *coverLayer;

/**占位*/
@property (weak, nonatomic) UIView *cover;
/**菊花*/
@property (weak, nonatomic) UIActivityIndicatorView *refrshView;

@end

@implementation QRcodeScanView
{
    UIColor *_previewBackgroundColor;
}

+ (instancetype)scanViewWithFrame:(CGRect)frame visibleRect:(CGRect)visibleRect
{
    QRcodeScanView *scanView = [[self alloc] initWithFrame:frame];
    scanView.visibleRect = visibleRect;
    return scanView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.previewBackgroundSetted = NO;
        [self setupScanView];
    }
    return self;
}

- (void)setupScanView{
    UIImageView *scanView = [[UIImageView alloc] init];
    self.scanView = scanView;
    [self addSubview:scanView];
    
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = kScanViewBackgroundColor;
    self.cover = cover;
    [self addSubview:cover];
    UIActivityIndicatorView *refrshView = [[UIActivityIndicatorView alloc] init];
    self.refrshView = refrshView;
    [refrshView startAnimating];
    [cover addSubview:refrshView];
}

- (void)setupCamera
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];

    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
//    [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型(删除二维码识别AVMetadataObjectTypeQRCode)
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code];
    
    // Preview
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer insertSublayer:self.preview atIndex:0];
}

- (void)setVisibleRect:(CGRect)visibleRect
{
    _visibleRect = visibleRect;
    if (CGRectEqualToRect(visibleRect, CGRectZero))
    {
        _visibleRect = self.bounds;
    }
    
    self.scanView.frame = _visibleRect;
    
    CGRect rectOfInterest = [self.preview metadataOutputRectOfInterestForRect:_visibleRect];
    
    [self.output setRectOfInterest:rectOfInterest];
    
    [self setPreviewBackground];
    
    CGPoint refreshViewCenter = [self.cover convertPoint:self.scanView.center fromView:self];
    
    self.refrshView.center = refreshViewCenter;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
        NSString *stringValue;
    
        if ([metadataObjects count] >0)
        {
            [self stopScan];
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
            stringValue = metadataObject.stringValue;
        }
    
        [self performSelector:@selector(dismissWithString:) withObject:stringValue afterDelay:0.3];
}

- (void)dismissWithString:(NSString *)stringValue
{
    [UIView animateWithDuration:1.5 animations:^{
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(scanView:didFinishedScanWithCodeString:)]) {
            [self.delegate scanView:self didFinishedScanWithCodeString:stringValue];
            return;
        }
    }];
}

- (void)startScan
{
    [self.cover removeFromSuperview];
    
    if (!self.device) {
        [self setupCamera];
    }
    
    [self.session startRunning];
}

- (void)stopScan{
    [self.session stopRunning];
}

#pragma mark 设置背景
- (void)setPreviewBackground{
    if (self.previewBackgroundSetted) {
        return;
    }
    self.previewBackgroundSetted = YES;
    CALayer *coverLayer = [[CALayer alloc] init];
    self.coverLayer = coverLayer;
    coverLayer.frame = self.bounds;
    coverLayer.backgroundColor = [self.previewBackgroundColor colorWithAlphaComponent:kBackgroundOpacity].CGColor;
    [self.layer addSublayer:coverLayer];
    
    UIBezierPath *outerBorderPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    UIBezierPath *innderBorderPath = [UIBezierPath bezierPathWithRect:self.visibleRect];
    
    [outerBorderPath appendPath:innderBorderPath];
    
    CAShapeLayer *visibleRectLayer = [CAShapeLayer layer];
    
    visibleRectLayer.path = outerBorderPath.CGPath;
    
    visibleRectLayer.fillRule = kCAFillRuleEvenOdd;
    
    coverLayer.mask = visibleRectLayer;
}

- (UIColor *)previewBackgroundColor
{
    return _previewBackgroundColor ? _previewBackgroundColor : kScanViewBackgroundColor;
}

- (void)setPreviewBackgroundColor:(UIColor *)previewBackgroundColor
{
    _previewBackgroundColor = previewBackgroundColor;
    
    self.coverLayer.backgroundColor = [_previewBackgroundColor colorWithAlphaComponent:kBackgroundOpacity].CGColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.visibleRect = self.visibleRect;
    
    self.preview.frame = self.bounds;
    
    self.cover.frame = self.bounds;
}


@end
